'use strict'

data = 
    domains: [
        url:'http://www.teefury.com', 
        cssData: [
            selector:'div[id^="design-view-modal"]>img', attribute:'data-original'
        ]
    ]

imgLinks = []
folder = "images/"

casper = require('casper').create({
    verbose: true,
    logLevel: 'debug'
})
#Caman = require('caman').Caman

casper.start()
casper.userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36")

# nodeList to array
nLtoArray = (nL) ->
    i = -1
    l = nL.length
    
    while ++i isnt l
      imgLinks[i] = nL[i]

fetchImageLinks = (cssData) ->
    elements = @.getElementsAttribute(cssData.selector, cssData.attribute)
    
    nLtoArray elements

forEachWebCallback = (domain) ->
    casper.thenOpen domain.url, ->
        @echo "\n> Accessing "+domain.url, 'INFO'
        domain.cssData.map fetchImageLinks, this

downloadImage = (image) ->
    n = image.lastIndexOf("/")
    imgName = image.slice(n+1)
    location = folder.concat(imgName)
    @download image, location

casper.on 'page.error', (msg, trace) ->
    @echo 'Error: ' + msg, 'ERROR'

casper.on 'downloaded.file', (path) ->
    @echo "> Img downloaded to "+path, 'INFO'

casper.then ->
    data.domains.forEach forEachWebCallback

casper.then ->
    imgLinks.forEach downloadImage, casper

casper.run()