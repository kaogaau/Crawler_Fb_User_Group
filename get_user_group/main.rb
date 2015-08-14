require 'selenium-webdriver'
require 'nokogiri'
require 'mongo'
require './login_fb'
require './get_user_group'
def main
	no_group_count = 0
	_404_count = 0
	has_group_count = 0
	error_count = 0
	browser = login_fb()

	Mongo::Logger.logger.level = ::Logger::FATAL
	client = Mongo::Client.new([ '192.168.26.180:27017' ],:database =>'fb_group',:user =>'admin',:password =>'12345')
	
	doc_set = client[:user_group].find({:user_group_status => "never update"})
	puts "Get #{doc_set.count.to_i} user data need to update group"

	doc_set.each do |doc|
		begin
			user_group = get_user_group(doc['user_id'],doc['user_name'],browser)
			if user_group == 'no group'
				result = client[:user_group].find(:user_id => doc['user_id']).update_one('$set' => { :user_group_status => "no group",:latest_update_time => Time.now })
				if result.n == 1
					no_group_count += 1
					puts "\"#{doc['user_name']}\"...no_group(#{no_group_count})"
				end
			elsif user_group == '404'
				result = client[:user_group].find(:user_id => doc['user_id']).update_one('$set' => { :user_group_status => "404",:latest_update_time => Time.now })
				if result.n == 1
					_404_count += 1
					puts "\"#{doc['user_name']}\"...404(#{_404_count})"
				end
			else
				result = client[:user_group].find(:user_id => doc['user_id']).update_one('$set' => { :user_group_status => "has group",:user_group => user_group,:latest_update_time => Time.now })
				if result.n == 1
					has_group_count += 1
					puts "\"#{doc['user_name']}\"....has_group(#{has_group_count})"
				end
			end
		rescue  => ex
			puts ex.message
			result = client[:user_group].find(:user_id => doc['user_id']).update_one('$set' => { :user_group_status => "error",:user_group => Hash.new(0),:latest_update_time => Time.now })
  			if result.n == 1
  				error_count += 1
  				puts "\"#{doc['user_name']}\"....has_error(#{error_count})"
  			end
  			puts ex.backtrace.join("\n")
  			next
		end
	end
	puts "error_count : #{error_count}"
	puts "404_count : #{_404_count}"
	puts "no_group_count : #{no_group_count}"
	puts "has_group_count : #{has_group_count}"
	puts "total :  #{no_group_count + _404_count + has_group_count + error_count}"
	browser.quit
end
begin
	time_start = Time.now
 	puts "Start: #{time_start}"
  	puts "========================================"
  	main
rescue => ex
  $stderr.puts ex.message
  $stderr.puts ex.backtrace.join("\n")
ensure
	time_end = Time.now
  	puts "========================================"
  	puts "End: #{time_end}"
  	puts "Time cost: #{time_end - time_start}"
end

#get_user_group("1020407414645839","Dissy Chou",browser)
#get_user_group("287292","Dissy Chou",browser)