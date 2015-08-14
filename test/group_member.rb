require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
hash = Hash.new(0)
client[:groups].find.each do |doc|
	#hash["group_id"] = doc["_id"] #insert group_member~
	#hash["group_name"] = doc["doc"]["name"]
	#hash["member"] = Hash.new(0) 
	#client[:group_member].insert_one(hash)  #~insert group_member
	member = Hash.new(0)
	client[:feeds].find(:group_id => doc["_id"]).each do |feed|
		member[feed['doc']['from']['id']] = feed['doc']['from']['name']
	end
	client[:group_member].find(:group_id => doc["_id"]).update_one('$set' => { :member => member })
end
#result = client[:pages].find(:check_old_posts => false).update_many('$set' => { :check_old_posts => true })
#puts result