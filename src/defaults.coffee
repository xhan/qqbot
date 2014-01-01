# a place to store user defaults
defaults    = {}
fs = require 'fs'
path = 'tmp/store.json'

empty = (obj)->
    Object.keys(obj).length == 0


exports.set_path = (newpath)->
  path = newpath

exports.data = (key,value)->
    read() if empty? defaults
    if key and value
        defaults[key] = value
    else if key
        defaults[key]
    else
        defaults

exports.save = ->
    fs.writeFileSync path ,  JSON.stringify defaults

read = exports.read = ->
    try
        defaults = JSON.parse( fs.readFileSync  path )
    catch error
        console.log error
