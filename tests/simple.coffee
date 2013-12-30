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
    

test1 = ->
    log 'begin'
    k = 
        a:10
        b:20
        c:30

    for i,v of k
        log i , v

test2 = ->
    for i,v of [10,2,3]
        log i,v


test3 =->
    QQBot = require '../src/qqbot'
    bot = new QQBot(100)
    bot.save_buddy_info({buddy:100000})
    log bot

test4 =->
    # 没法在 =-> 方法中调用 @方法
    # 在callback 里调用方法需要用 =>
    class OOO
        constructor:(@name)->
        ask:->
            log "ask",@name
            test()
        test = ->
            log "test"
        ask2:->
            log "ask2"
            setTimeout =>
                @ask()
            ,500
            # test2()
        test2 = ->
            log "test2"
            test()
            
    v = new OOO('名字')
    v.ask2()
    log v.name


    
test4()

# setTimeout ->
#     log 'test'
# ,500
    