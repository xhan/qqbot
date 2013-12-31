EventEmitter = require('events').EventEmitter

class Dispatcher extends EventEmitter
    constructor: (@plugins) ->
        @listeners = []
        for plugin_name in @plugins
            @listeners.push require "../plugins/#{plugin_name}"
    
    dispatch: (content ,send, robot, message)->
        for plugin in @listeners
            plugin(content ,send, robot, message)            
    
    add_listener: (listener)->
      @listeners.push listener
    
            
module.exports = Dispatcher