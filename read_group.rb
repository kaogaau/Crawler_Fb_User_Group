require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
has_group_set = client[:user_group].find(:user_group_status => "has group")
_404_set = client[:user_group].find(:user_group_status => "404")
no_group_set = client[:user_group].find(:user_group_status => "no group")
never_update_set = client[:user_group].find(:user_group_status => "never update")
puts "has group : #{has_group_set.count.to_i}"
puts "404 : #{_404_set.count.to_i}"
puts "no group : #{no_group_set.count.to_i}"
puts "never update : #{never_update_set.count.to_i}"
uniuqe_group = Hash.new(0)
group_count = 0
has_group_set.each do |doc|
	 group_count = group_count + doc['user_group'].size
	 doc['user_group'].each do |ele|
	 	uniuqe_group[ele] += 1
	 end
end
uniuqe_group_count =  uniuqe_group.keys.size
puts "Total groups : #{group_count}"
puts "Total uniuqe groups : #{uniuqe_group_count}"
File.open('./unique_group.txt','w+') do |output|
	uniuqe_group.keys.each do |ele|
		output.puts ele
	end
end