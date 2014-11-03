'use strict'

require 'getTee'

data = 
    domains: [
        url:'http://www.teefury.com', 
        cssData: [
            selector:'div[id^="design-view-modal"]>img', attribute:'data-original'
        ]
    ,
        url:'http://www.qwertee.com'
        cssData: [
            selector:'div.zoom-dynamic-image>img.dynamic-image-design', attribute:'src'
        ,
            selector:'div.zoom-dynamic-image>div.background', attribute:'style'
        ]
    ]

imgLinks = []
folder = "images/"

casper = require('casper').create({
    verbose: true,
    logLevel: 'debug'
})

casper.start()
casper.userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36")

# nodeList to array
nLtoArray = (nL) ->
    i = -1
    l = nL.length
    array = []
    
    while ++i isnt l
        array[i] = nL[i]
    array

fetchImageLinks = (cssData) ->
    elements = @.getElementsAttribute(cssData.selector, cssData.attribute)
    if cssData.attribute isnt 'style'
        imgLinks = nLtoArray elements
        imgLinks.forEach downloadImage, casper
    else
        # WiP. Getting the background-color since .png files
        # have a transparent background
        backgrounds = nLtoArray elements
        for background in backgrounds
            n = background.indexOf(":")
            background = background.slice(n+2)
            @echo background

forEachWebCallback = (domain) ->
    casper.thenOpen domain.url, ->
        @echo "\n> Accessing "+domain.url, 'INFO'
        domain.cssData.forEach fetchImageLinks, this

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

casper.run()
