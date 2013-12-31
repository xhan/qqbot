# a place to store user defaults
defaults    = {}
fs = require 'fs'

empty = (obj)->
    Object.keys(obj).length == 0


exports.data = (key,value)-> 
    read() if empty? defaults
    if key and value
        defaults[key] = value
    else if key
        defaults[key]
    else
        defaults

exports.save = ->
    fs.writeFileSync 'tmp/store.json' ,  JSON.stringify defaults

read = exports.read = ->
    try
        defaults = JSON.parse( fs.readFileSync  'tmp/store.json' )
    catch error
        console.log error
