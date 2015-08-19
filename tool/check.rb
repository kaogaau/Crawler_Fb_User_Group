require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
name = '高雄/屏東區/二手/交換/買賣/二手汽車用品/美妝/雜貨/中古車/衣服/'
result = /寶寶/.match(name).to_s
puts result
puts result.class
puts name
=begin
group_id = Hash.new(0)
puts "check 麗翔特賣會..."
client[:groups].find.each do |doc|
	client[:feeds].find(:group_id => doc["_id"]).each do |feed|
		group_id[doc['doc']['name']] += 1 if /麗翔/.match(feed['doc']['message']).to_s == '麗翔'
		if feed['doc']['comments']['data'].size > 0 #comments author
			feed['doc']['comments']['data'].each do |ele|
				group_id[doc['doc']['name']] += 1 if /麗翔/.match(ele['message']).to_s == '麗翔'
			end
		end
	end
end
puts "output..."
File.open("./output.txt","w+") do |output|
	group_id.each do |k,v|
		output.puts "#{k}\t#{v}"
	end
end
=end
