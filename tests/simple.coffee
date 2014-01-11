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
    # 官方的解释 大概 
    # for in 用在 array
    # for of 用在 obj
    
    # 测试 for of / for in
    # for i,v in [10,2,3]
    #     log i,v
    log v for v in [10,2,3]
    
    # log "kk"
    log k,v for k,v of {a:10,b:20}
        # log k,v

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


test5 =->
    #测试 npm依赖 能否互相 同层级调用
    # ln -s ../../hubot-qq . 调用了 yaml
    test = require 'hubot-qq'
    log test
    
    
test6 =->
    #测试 export.xx 在包内如何获取
    exports.xx =-> log "xxxxx"
    exports.xx()
    
test7 =->
    # 回调中缩进 似乎可以和父保持一直
    log "hello"    
    setTimeout ->
    log "next"
    ,300
# test7()

# setTimeout ->
#     log 'test'
# ,500
    
    
test8 =->
  # 似乎无法在自己执行中传入stdin
  # process.stdin.resume()
  process.stdin.on "data",  (data) ->
    data = data.toString().trim()
    console.log 'received: ', data
  process.stdin.on 'end', ->
    console.log 'end'

  Readable = require('stream').Readable
  rs = new Readable
  rs.push('beep ')
  rs.push('boop\n')
  rs.push(null)

  # rs.pipe(process.stdin)
  process.stdin.resume()


test8()  
  