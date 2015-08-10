require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
doc_set = client[:user_group].find(:user_group_status => "has group")
puts doc_set.count
group = Hash.new(0)
doc_set.each do |doc|
	 doc['user_group'].each do |ele|
	 	group[ele] += 1
	 end
end
g =  group.keys
puts g.size