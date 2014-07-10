###
http://hitokoto.us/
简单来说，一言（ヒトコト）指的是就是一句话，可以是动漫中的台词，可以是小说中的语句，也可以是网络上的各种小段子。
或是感动，或是开心，又或是单纯的回忆，来到这里，留下你所喜欢的那一句句话，与大家分享，这就是一言存在的目的。
###

module.exports = (content ,send, robot, message)->

  if content.match /^comic$/i
    robot.request.get {url:"http://api.hitokoto.us/rand",json:true}, (e,r,data)->      
      if data and data.hitokoto
        send data.hitokoto + " --" + data.source
      else
        send e
