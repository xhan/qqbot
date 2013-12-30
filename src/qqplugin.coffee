EventEmitter = require('events').EventEmitter

class QQPlugin extends EventEmitter
    constructor: (@plugins,@listen) ->
        @listeners = []
        for i, plugin_name of @plugins
            @listeners.push require "../plugins/#{plugin_name}"
    
    dispatch: (content ,send, robot, message)->
        for i, plugin of @listeners
            plugin(content ,send, robot, message)
            
    
            
module.exports = QQPlugin