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

fetchImageLinks = (cssData) ->
    links = @.getElementsAttribute(cssData.selector, cssData.attribute)

forEachWebCallback = (domain) ->
    casper.thenOpen domain.url, ->
        @echo "\n> Accessing "+domain.url, 'INFO'
        imgLinks = domain.cssData.map fetchImageLinks, this

everyImageCallback = (image) ->
    @echo "-> Link: "+ image
    n = image.toString().lastIndexOf("/")
    @echo "-> Slice: "+n
    imgName = image.toString().slice(n+1)
    location = "images/".concat(imgName)
    @echo "\n> Downloading "+imgName, 'INFO'
    @download image, location
    @echo "---> Image saved in "+location

casper.on 'page.error', (msg, trace) ->
    @echo 'Error: ' + msg, 'ERROR'

casper.then ->
    data.domains.forEach forEachWebCallback

casper.then ->
    imgLinks.forEach everyImageCallback, casper

casper.run()