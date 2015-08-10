require 'selenium-webdriver'
require 'nokogiri'
require './mongo_client'
require 'bson'
def login_fb()
	#login my fb
	client = Selenium::WebDriver::Remote::Http::Default.new
  	client.timeout = 180 # seconds
	browser = Selenium::WebDriver.for(:firefox, :http_client => client)
	#browser.manage.timeouts.page_load = 2
	#browser.manage.timeouts.implicit_wait = 3  #Random.new.rand(3..10)
	browser.navigate.to "https://www.facebook.com/"
	email_field = browser.find_element(:id, 'email')
	password_field = browser.find_element(:id, 'pass')
	buton_field = browser.find_element(:id, 'u_0_v')
	email_field.send_keys 'kaogaau@gmail.com'
	password_field.send_keys 'cksh1300473'
	buton_field.submit
	browser
end
def get_user_group(app_scoped_user_id,user_name,browser)
	#puts "#{member_name} groups :"
	#redirct to app_scoped_user_id'person page
	browser.get "https://www.facebook.com/#{app_scoped_user_id}"
	sleep Random.new.rand(1..5)
	html_check = browser.page_source
	html_check_nokdoc = Nokogiri::HTML(html_check)
	check_tag_set = html_check_nokdoc.xpath("//div/h2[@class='_4-dp']")
	if check_tag_set.none? #check 404
		person_url = browser.current_url
		user_id = person_url.split('=')[1]#find real user id
		group_link = "https://www.facebook.com/profile.php?id=#{user_id}&sk=groups"#find group
		if user_id == nil 
			user_name = person_url.split('/')[3]
			group_link = "https://www.facebook.com/#{user_name}/groups"
		end
		#redirct to user_id'group page
		browser.get group_link
		sleep Random.new.rand(1..5)
		group_url = browser.current_url
		if group_url != person_url
			user_group = Array.new(0)
			html_str = browser.page_source
			html_nokdoc = Nokogiri::HTML(html_str)#get group html
			tag_set = html_nokdoc.xpath("//div[@class='mbs fwb']/a")
			tag_set.each do |tag|
				user_group << tag.text
			end
			return user_group
		else#no group
			user_group = 'no group'
			return user_group
		end
	else #404
		user_group = '404'
		return user_group
	end
end

no_group_count = 0
_404_count = 0
has_group_count = 0
browser = login_fb()

Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
doc_set = client[:user_group].find("latest_update_time" => { "$lt" => Time.now - 1800 },"user_group_status" => "never update")

puts "Get #{doc_set.count.to_i} user data need to update group"

doc_set.each do |doc|
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
end

browser.quit
puts "no_group_count : #{no_group_count}"
puts "404_count : #{_404_count}"
puts "has_group_count : #{has_group_count}"
puts "total :  #{no_group_count + _404_count + has_group_count}"
#get_user_group("1020407414645839","Dissy Chou",browser)
#get_user_group("287292","Dissy Chou",browser)