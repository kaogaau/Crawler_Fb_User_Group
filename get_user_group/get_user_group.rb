def get_user_group(app_scoped_user_id,user_name,browser)
	browser.get "https://www.facebook.com/#{app_scoped_user_id}"
	sleep(1)
	check_404 = true , check_group = false
	check_404 = false if browser.find_elements(:xpath, "//div/h2[@class='_4-dp']").none?
	check_group = true if browser.find_elements(:xpath, "//div/span[@class='_71u']/a").size == 1
	if check_404 #############check 404#############
		user_group = '404'
	else
		if check_group
			user_group = Hash.new(0)
			group_number = browser.find_elements(:xpath, "//div/span[@class='_71u']/a/span[@class='fwn fcg']")[0].text#get group number
			browser.get browser.find_elements(:xpath, "//div/span[@class='_71u']/a")[0]['href']#go to group page
			sleep(1)
			puts "共#{group_number}個公開社團"
			while 
				ele_count = browser.find_elements(:xpath, "//div[@class='mbs fwb']/a").length
				last_element_before = browser.find_elements(:xpath, "//div[@class='mbs fwb']/a").last
				last_element_before.location_once_scrolled_into_view#scroll down
				sleep(3)#check scroll down OK?
				last_element_after = browser.find_elements(:xpath, "//div[@class='mbs fwb']/a").last
				#puts last_element_before.location
				#puts last_element_after.location
				break if last_element_before.text == last_element_after.text#check has ele?
				#wait for  load elements
				until browser.find_elements(:xpath, "//div[@class='mbs fwb']/a").length > ele_count 
				  sleep(1)
			    	end
			end
			tag_set = browser.find_elements(:xpath, "//div[@class='mbs fwb']/a")
			tag_set.each do |tag|
				user_group[tag['data-hovercard'].split('=')[1]] = tag.text
			end
			return user_group
		else#############no group#############
			user_group = 'no group'
			return user_group
		end
	end
end
#sleep Random.new.rand(1..10)