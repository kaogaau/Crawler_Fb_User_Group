require 'selenium-webdriver'
require 'nokogiri'
require './mongo_client'
def login_fb()
	#login my fb
	client = Selenium::WebDriver::Remote::Http::Default.new
  	client.timeout = 180 # seconds
	browser = Selenium::WebDriver.for(:firefox, :http_client => client)
	#browser.manage.timeouts.page_load = 2
	browser.manage.timeouts.implicit_wait = 3  #Random.new.rand(3..10)
	browser.navigate.to "https://www.facebook.com/"
	email_field = browser.find_element(:id, 'email')
	password_field = browser.find_element(:id, 'pass')
	buton_field = browser.find_element(:id, 'u_0_v')
	email_field.send_keys 'kaogaau@gmail.com'
	password_field.send_keys 'cksh1300473'
	buton_field.submit
	browser
end
def get_user_group(member_id,member_name,browser)
	#puts "#{member_name} groups :"
	#redirct to app_scoped_user_id'person page
	app_scoped_user_id = member_id
	browser.get "https://www.facebook.com/#{app_scoped_user_id}"
	sleep Random.new.rand(3..5)
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
		sleep Random.new.rand(3..5)
		group_url = browser.current_url
		if group_url != person_url
			user = Hash.new(0)
			user['user_id'] = member_id
			user['user_name'] = member_name
			user['groups'] = Array.new(0)
			html_str = browser.page_source
			html_nokdoc = Nokogiri::HTML(html_str)#get group html
			tag_set = html_nokdoc.xpath("//div[@class='mbs fwb']/a")
			tag_set.each do |tag|
				user['groups'] << tag.text
			end
			return user
		else#no group
			user = 'no group'
			return user
		end
	else #404
		user = '404'
		return user
	end
end

count = 0
browser = login_fb()
#get_user_group("1020407414645839","Dissy Chou",browser)
#get_user_group("287292","Dissy Chou",browser)
#=begin
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
client[:group_member].find.each do |doc|
	member = Hash.new(0)
	member = doc['member']
	member.each do |member_id,member_name|
		#puts "#{member_id}:#{member_name}"
		begin
			begin
   				user = get_user_group(member_id,member_name,browser)
				if user == 'no group'
					puts "Has no group data of \"#{member_name}\""
				elsif user == '404'
					browser.quit
					browser = login_fb()
				else
					result = client[:user_groups].insert_one(user) 
					if result.n == 1
						count += 1
						puts "#{count} : Insert group data of \"#{member_name}\""
					end
				end
			end until user != '404'
		rescue Exception => e
			puts "Has error <#{e}> of \"#{member_name}\""
			next
		end
	end
end
#=end
browser.quit
puts "Insert #{count} Data"


#puts tag_set.none?
#File.open("./html.txt",'w+') do |output|
#	output.puts html_str
#end
#puts a