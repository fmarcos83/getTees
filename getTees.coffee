'use strict'

data = 
	domains: [
		url:'http://www.teefury.com', 
		cssData: [
			all: false
		,
			selector:'#design-view-modal-secondProduct>img', attribute:'data-original'
		]
	,
		url:'http://www.qwertee.com'
		cssData: [
			all: true
		,
			selector:'div.zoom-dynamic-image', attribute:['style', 'src']
		]
	]

imgLinks = []

casper = require('casper').create()
#Caman = require('caman').Caman

casper.start()
casper.userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36")

callBackWarro = (cssData)->
	elements = document.querySelectorAll(cssData.selector).getAttribute(cssData.attribute)

	for element in elements


fetchImageLinks = (cssData) ->
	@evaluate callBackWarro, cssData

forEachWebCallback = (domain) ->
	casper.thenOpen domain.url, ->
		@echo "\n> Accessing "+domain.url, 'INFO'
		imgLinks = domain.cssData.map fetchImageLinks, this

everyImageCallback = (image) ->
	n = image.lastIndexOf("/")
	imgName = image.slice(n)
	location = "images".concat(imgName)	
	@download image, location
	@echo "---> Image saved in "+location

casper.then ->
	data.domains.forEach forEachWebCallback

casper.then ->
	imgLinks.map everyImageCallback, casper

casper.run()