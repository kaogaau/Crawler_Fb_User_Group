require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
hash = Hash.new(0)
puts "....."
client[:user_group].find(:user_group_status => "has group").each do |doc|
	hash[doc['user_id']] = doc['user_group'] if doc['user_group'].size > 0
end
puts "....."
hash = hash.sort
File.open('./user_group.txt','w+') do |output|
	hash.each do |k,v|
		output.puts "#{k}\t#{v}"
	end 
end