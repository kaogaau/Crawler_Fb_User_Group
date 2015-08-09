require 'json'
require 'net/http'
require 'nokogiri'
require 'http-cookie'
jar = HTTP::CookieJar.new
uri = URI.parse("https://www.facebook.com/login.php?login_attempt=1")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#fb_cookie = CGI::Cookie::new("datr" => "-HjBVT-FgIcVQracedKt09L-", "fr" => "0aTjPgzuXfIMI98y7.AWUVM1NOX8Nxw_OaOL9wIx7rcQ0.BVwXkn.7a.AAA.0.AWXy6sUu","lu"=>"SAIiolGxNbuIAtw4IfbC54zw","locale"=>"zh_TW","reg_fb_ref"=>"https%3A%2F%2Fwww.facebook.com%2F%3Fstype%3Dlo%26jlou%3DAffVK4Q2wiczx-ynBimnVEIWzSj-9s6EOtHrLvQ7gQmYDjCHFJ_ZfC8cgVDlWqrLVpcQsjvd4OuaRGFUGdW5qdIb%26smuh%3D43090%26lh%3DAc9MN739XsGe0MIA","reg_fb_gate"=>"https%3A%2F%2Fwww.facebook.com%2F%3Fstype%3Dlo%26jlou%3DAffVK4Q2wiczx-ynBimnVEIWzSj-9s6EOtHrLvQ7gQmYDjCHFJ_ZfC8cgVDlWqrLVpcQsjvd4OuaRGFUGdW5qdIb%26smuh%3D43090%26lh%3DAc9MN739XsGe0MIA","reg_ext_ref"=>"http%3A%2F%2F220.132.97.119%2Fdashboard%2Fopleader.php","_js_reg_fb_ref"=>"https%3A%2F%2Fwww.facebook.com%2Flogin%2F%3Fnext%3Dhttps%253A%252F%252Fwww.facebook.com%252Fpeople%252F%25E6%259E%2597%25E6%25B7%2591%25E8%258A%25AC%252F100001873173946","wd"=>"1855x923")
request = Net::HTTP::Post.new(uri.request_uri)
request.set_form_data({"email" => "kaogaau@gmail.com", "pass" => "cksh1300473"})
response = http.request(request)
puts response.header.each_header {|key,value| puts "#{key} = #{value}" }
#puts response.class
header["Set-Cookie"].each { |value|
  jar.parse(value, uri)
}
#puts response.body
