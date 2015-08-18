require './mongo_client'
Mongo::Logger.logger.level = ::Logger::FATAL
client = mongo_client([ '192.168.26.180:27017' ],'fb_group','admin','12345')
result = client[:user_group].find().update_many('$set' => { :user_group_status => "never update",:user_group => Hash.new(0),:latest_update_time => Time.now })
puts "updating #{result.n} data"