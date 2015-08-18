require 'selenium-webdriver'

driver = Selenium::WebDriver.for(:remote, :url => "http://localhost:8910")
driver.navigate.to 'http://www.mobileswall.com/'

# Check how many elements are there initially  
puts driver.find_elements(:css, 'div.pic').length
#=> 30

# Scroll to the last image
driver.find_elements(:css, 'div.pic').last.location_once_scrolled_into_view

# Wait for the additional images to load
current_count = driver.find_elements(:css, 'div.pic').length
until current_count < driver.find_elements(:css, 'div.pic').length
  sleep(1)
end

# Check how many elements are there now
puts driver.find_elements(:css, 'div.pic').length
#=> 59