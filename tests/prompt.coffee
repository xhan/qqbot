#!/usr/bin/env coffee

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


log = console.log
log "hello"

prompt "input something", (content)->
    log content

log "end"


