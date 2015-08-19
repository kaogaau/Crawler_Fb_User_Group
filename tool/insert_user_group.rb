require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_rawdata','admin','12345')
user = Hash.new{|k,v| user[v] = Array.new(0)}
user_uniq = Hash.new(0)
puts "get orgin users of groups..."
client[:groups].find.each do |doc|
	client[:feeds].find(:group_id => doc["_id"]).each do |feed|
		user[feed['doc']['from']['id']] << feed['doc']['from']['name'] # feeds author
		if feed['doc']['comments']['data'].size > 0 #comments author
			feed['doc']['comments']['data'].each do |ele|
				user[ele['from']['id']] << ele['from']['name']
			end
		end
	end
end
puts "get orgin users of pages..."
client[:pages].find.each do |doc|
	client[:posts].find(:page_id => doc["_id"]).each do |post|
		user[post['doc']['from']['id']] << post['doc']['from']['name'] # posts author
		if post['doc']['comments']['data'].size > 0 #comments author
			post['doc']['comments']['data'].each do |ele|
				user[ele['from']['id']] << ele['from']['name']
			end
		end
	end
end
puts "get uniq users..."
user.each do |k,v|
	user_uniq[k] = v.uniq
end
#File.open('./user_uniq.txt','w+') do |output|
#	user_uniq.each do |k,v|
#		output.puts "#{k}\t#{v}"
#	end 
#end
puts "insert members blank list"
#=begin
user_uniq.each do |id,name|
	doc = Hash.new(0)
	doc["latest_update_time"] = Time.now
	doc["doc_status"] = "never update"
	doc["app_scoped_user_id"] = id
	doc["name"] = name
	doc["groups"] = Hash.new(0)
	client[:users].insert_one(doc)
end

#=end
#client[:user_groups_test].find(:group_id => doc["_id"]).update_one('$set' => { :member => member })
#result = client[:pages].find(:check_old_posts => false).update_many('$set' => { :check_old_posts => true })
#puts result