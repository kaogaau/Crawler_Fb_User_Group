require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
has_group_set = client[:user_group].find(:user_group_status => "has group")
_404_set = client[:user_group].find(:user_group_status => "404")
no_group_set = client[:user_group].find(:user_group_status => "no group")
never_update_set = client[:user_group].find(:user_group_status => "never update")
error_set = client[:user_group].find(:user_group_status => "error")
puts "erroe : #{error_set.count.to_i}"
puts "404 : #{_404_set.count.to_i}"
puts "never update : #{never_update_set.count.to_i}"
puts "has group : #{has_group_set.count.to_i}"
puts "no group : #{no_group_set.count.to_i}"
unique_group = Hash.new{|k,v| unique_group[v] = Array.new(0)}
group_count = 0
unique_group_count = 0
double_group_count = 0
has_group_set.each do |doc|
	if doc['user_group'].size > 0
		group_count = group_count + doc['user_group'].size
		doc['user_group'].each do |k,v|
			unique_group[k] << v
		end
	end
end
#unique_group_id_count =  unique_group.keys.size
unique_group.each do |k,v|
	v = v.uniq
	if v.size  > 1
		double_group_count += 1
	else
		unique_group_count += 1
	end
end
puts "Total groups : #{group_count}"
puts "Total unique groups : #{unique_group_count}"
puts "Total double groups : #{double_group_count}"
#File.open('./unique_group.txt','w+') do |output|
#	unique_group.keys.each do |ele|
#		output.puts ele
#	end
#end