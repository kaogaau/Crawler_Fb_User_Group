require 'json'
require 'net/http'
def get_group_id(group_name)
	output = File.open('./group_id.txt','a+')
	token = 'CAAXRUfyZCg2IBAHmHneFMlTtB8J5RLZB8YebxOZAP2fZBMbAFY0rOVBN9yrrZCzQpKpQzrtZBYl8KHzt03CQ4FdZAZB6WEtCgwknOBqssVHSJ9KlehKunGSa0q4pR3kiwBJTOksBIe3nBBInz0PDTgb7URRdcnOrkoXEdFbiyGOAVkWW26kgODUbZB1nyHuSEv3OhVfvAQX7VgAZDZD'
	fb_graph_host = "graph.facebook.com"
	http = Net::HTTP.new fb_graph_host, '443'
	http.use_ssl = true
	# http.verify_mode = OpenSSL::SSL::VERIFY_NONE     
	query = "https://graph.facebook.com/search?q=#{group_name}&type=group&access_token=#{token}"
	req = Net::HTTP::Get.new(URI.escape(query)) # FIXME: URI.escape cause a obsolete warning
	res = http.request req

	result = JSON.parse(res.body)
	if !result.has_key?('error') && result.has_key?('data')
		if result['data'].size == 1
			output.puts "#{group_name}\t#{result['data'][0]['id']}"
			#puts "成功擷取ID!如果您查詢的社團名稱為<#{result['data'][0]['name']}>無誤,則此社團ID為<#{result['data'][0]['id']}>"
		else
			
			output.puts "#{group_name}\tFail"
		end
	else
		output.puts "#{group_name}\tFail"
	end
end
puts "Get group id..."
File.open('./unique_group.txt','r+') do |file|
	file.each_line do |group_name|
		get_group_id(group_name.chomp)
	end
end
puts "Get group id complicate..."