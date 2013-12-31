#!/usr/bin/env coffee

log = new (require 'log')('debug')

class Group
    on: (@callback)->        
    dispatch: (msg)->
        log.info 'dispatch',msg
        @callback(msg) if @callback
    cb: ->
        @callback
        
class Bot
    constructor:(@list = [])->        
        setInterval =>
            o('bbb' ) for o in @list
        ,500
        
        
    listen_group : (name , callback) ->                
          group = new Group()
          @list.push group.dispatch
          callback group


### DEMO1
bot = new Bot()
# ggg = null
bot.listen_group 'group', (group)->
    group.on (msg)->
        log.info '- received',msg
    group.dispatch 'aaa'
    
    k = group.dispatch 
    k('single')
    # ggg = group
###
    
# ggg.dispatch 'ccc'    
# 
# setInterval ->
#     ggg.dispatch 'ddd'
# ,500

###期待
  dispatch
  - receive
  dispatch
  - receive

  实际结果
  dispatch only

  原因猜测
  - js中没class概念 传给list的是个函数，破坏了里面的 this.xx 的概念

### 



# DEMO2
group = new Group()
group.on (msg)->
    log.info '- received',msg

group.dispatch 'kk'

# obj    = group
# method = group.dispatch

group['dispatch'] 'str'





    

