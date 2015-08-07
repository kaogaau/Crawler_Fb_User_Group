require 'json'
require 'net/http'
require 'nokogiri'
uri = URI.parse("https://lookup-id.com/")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({"fburl" => "https://www.facebook.com/kaogaau"})
response = http.request(request)
p response
#html_str = response.body
#puts html_str
#html_nokogiri = Nokogiri::HTML(html_str)
#tag_set = html_nokogiri.xpath("//div/span[@id='code']")
#puts tag_set.none?

def get_response_with_redirect(uri)
   r = Net::HTTP.get_response(uri)
   if r.code == "301"
     r = Net::HTTP.get_response(URI.parse(r.header['location']))
   end
   r
end