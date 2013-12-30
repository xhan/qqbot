EventEmitter = require('events').EventEmitter

class QQPlugin extends EventEmitter
    constructor: (@plugins,@listen) ->
        @listeners = []
        for i, plugin_name of @plugins
            @listeners.push require "../plugins/#{plugin_name}"
    
    dispatch: (robot,message)->
        for i, plugin of @listeners
            plugin( robot , message)
            
module.exports = QQPlugin             