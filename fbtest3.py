# -*- coding: utf-8 -*-
import time
import spynner
import chardet
import codecs

browser = spynner.Browser()
browser.debug_level = spynner.DEBUG
browser.show()
#print browser.contents
browser.load("https://www.facebook.com/" ,load_timeout=25, tries=3)    
while not ('u_0_v' in browser.contents): 
    print 'waiting....'
    browser.wait(1)
#browser.wait_load()
browser.wk_fill("input[id='email']", 'kaogaau@gmail.com')
browser.wk_fill("input[id='pass']", 'cksh1300473')
browser.click("input[id='u_0_v']")
#browser.wait_load()


browser.wait(3)
browser.load("https://www.facebook.com/happybean.shih/groups" ,load_timeout=25, tries=3)    
browser.wait(3)
#f=codecs.open("c:/tmp/test.txt",'wb','utf-8')
#mystr=browser.html
mystr=unicode(browser.webframe.toHtml().toUtf8(), encoding="UTF-8")

#f.write(mystr)
print mystr
#f.close()
browser.close()
