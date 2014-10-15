'use strict'

data = 
	domains: [
		url:'http://www.teefury.com', 
		cssData: [
			selector:'div[id^="design-view-modal"]>img', attribute:'data-original'
		]
	]

imgLinks = []

casper = require('casper').create({
	verbose: true,
	logLevel: 'debug'
})
#Caman = require('caman').Caman

casper.start()
casper.userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36")

documentInspectionCallback = (cssData)->
	elements = document.querySelectorAll(cssData.selector)
	links = []
	for element in elements
		links.push(element.getAttribute(cssData.attribute))
	console.log links
	console.log elements
	links

fetchImageLinks = (cssData) ->
	@evaluate documentInspectionCallback, cssData

forEachWebCallback = (domain) ->
	casper.thenOpen domain.url, ->
		@echo "\n> Accessing "+domain.url, 'INFO'
		imgLinks = domain.cssData.map fetchImageLinks, this

everyImageCallback = (image) ->
	@echo "-> "+ typeof image
	n = image.lastIndexOf("/")
	@echo "-> "+n
	imgName = image.slice(n)
	@echo "---> Image "+imgName
	location = "images".concat(imgName)	
	@download image, location
	@echo "---> Image saved in "+location

casper.then ->
	data.domains.forEach forEachWebCallback

casper.then ->
	imgLinks.map everyImageCallback, casper

casper.run()