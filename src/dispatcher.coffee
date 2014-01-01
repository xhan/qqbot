EventEmitter = require('events').EventEmitter

class Dispatcher extends EventEmitter
    constructor: (@plugins ) ->
        @listeners = []
        @obj_listeners = []
        @plugins ||= []
        for plugin_name in @plugins
            @listeners.push require "../plugins/#{plugin_name}"

    dispatch: (params...)->
        for plugin in @listeners
            plugin(params...)
        for plugin in @obj_listeners
            [obj,method] = plugin
            obj[method](params...)

    ###
    针对 对象的方法
      请传入 [obj,'methodname']
      methodname 直接调用 methodname 会破坏内部变量 this.xxx
    ###
    add_listener: (listener)->
        if listener instanceof Function
            @listeners.push listener
        else
            @obj_listeners.push listener


module.exports = Dispatcher