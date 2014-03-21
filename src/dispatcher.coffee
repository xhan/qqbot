Log = require 'log'
log = new Log('debug')

EventEmitter = require('events').EventEmitter

requireForce = (module_name) ->
  try
    delete require.cache[require.resolve(module_name)]
    require(module_name)
  catch error
    log.error "Load module #{module} failed"


class Dispatcher extends EventEmitter
    constructor: (@plugins, @robot) ->
      @listeners = []
      @obj_listeners = []
      @plugins ||= []
      
      @reload_plugin()

    dispatch: (params...)->
      try
        for plugin in @listeners
          plugin(params...)
        for plugin in @obj_listeners
          [obj,method] = plugin
          obj[method](params...)
      catch error
        log.error error
      

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
    
    # 重新加载插件
    reload_plugin:->
      @listeners = []
      for plugin_name in @plugins
        log.debug "Loading Plugin #{plugin_name}"
        plugin = requireForce "../plugins/#{plugin_name}"
        
        if plugin instanceof Function
          @listeners.push plugin
        else 
          @listeners.push plugin.received if plugin.received
          plugin.init(@robot) if plugin.init
        


module.exports = Dispatcher