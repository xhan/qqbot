{Robot, Adapter, EnterMessage, LeaveMessage, TextMessage} = require('hubot')

auth = require "../src/qqauth"
api  = require "../src/qqapi"
QQBot= require "../src/qqbot"

class QQHubotAdapter extends Adapter
    
    send: (envelope, strings...) ->
        for str in strings:
            


  reply: (user, strings...) ->
    @send user, strings...

  run: ->
    self = @
    

    @emit "connected"

exports.use = (robot) ->
  new SkypeAdapter robot

