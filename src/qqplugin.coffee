EventEmitter = require('events').EventEmitter

class QQPlugin extends EventEmitter
    constructor: (@plugins,@listen) ->
        @listeners = []
        for plugin_name in @plugins
            @listeners.push require "../plugins/#{plugin_name}"
    
    dispatch: (content ,send, robot, message)->
        for plugin in @listeners
            plugin(content ,send, robot, message)            
    
            
module.exports = QQPlugin