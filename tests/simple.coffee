#!/usr/bin/env coffee
log = console.log
prompt = (title, callback) ->
    process.stdin.resume()
    process.stdout.write(title)
    process.stdin.once "data",  (data) ->
        callback data.toString().trim()
        process.stdin.pause()
    # control + d to end 
    process.stdin.on 'end', ->
      process.stdout.write('end')
      callback()


test_prompt = ->
    log "hello"
    prompt "input something", (content)->
        log content

    log "end"
    


log 'begin'
k = 
    a:10
    b:20
    c:30

for i,v of k
    log i , v
    


