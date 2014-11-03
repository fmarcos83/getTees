#! /usr/bin/env coffee
fs         = require 'fs'
program    = require 'commander'
yamlParser = require 'js-yaml'

#TODO: setup version from package.json
options =
  FILE_FORMAT: 'utf8'
  CONFIG_OPT: '-c, --configuration [file]'
  #TODO: setup a mechanism to determine the number of formats
  #for config files
  CONFIG_OPT_MESSAGE: 'config file in {yaml} format'
program.option options.CONFIG_OPT, options.CONFIG_OPT_MESSAGE
program.parse  process.argv

fileLocation = program.configuration

try
  doc = yamlParser.safeLoad fs.readFileSync fileLocation, options.FILE_FORMAT
catch e
  console.error e

console.log doc
