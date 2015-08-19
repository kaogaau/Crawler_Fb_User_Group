require 'mongo'
#include Mongo
def mongo_client(host,database,user,password)
	client = Mongo::Client.new(host,:database =>database,:user =>user,:password =>password)
end