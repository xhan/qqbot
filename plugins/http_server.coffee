###
  发送群消息
  POST /groupmsg
  PARAMS {
            group: 'qq群'
            message: 'message'
            token  : 'token'
         }
  返回结果:
  ret {
    err: 0
    err_msg: ''
  }

  配置参数 config.yaml
  - server
    - token: 
    - allow: #TODO 白名单
  
###
