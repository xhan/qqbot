QQBot
------
A Hubot adapter for QQ! And also A independence robot lives on the real world.  
FYI: QQ is a instant messaging service widely used in china provided by Tencent.  

基于[WebQQ协议](https://github.com/xhan/qqbot/blob/master/protocol.md)的QQ机器人。命令行工具，由不可思议的CoffeeScript提供支持。 

>DEMO 调戏用(测试和交流)QQ群：346167134

功能主治 Features
-----
* :muscle:  登录和验证码支持
* :muscle:  支持好友，群，讨论组的接入
* :muscle:  插件化，目前支持消息的派发
* :muscle:  可作为hubot adapter使用
* :muscle:  提供HTTP API支持（比如群通知什么的都能做哦）

你可以用TA来  

* 辅助管理群成员，比如自动清理刷屏用户啊（请自己实现）
* 聊天机器人（请自己实现AI）
* 部署机器人（请了解hubot的概念）
* 通知机器人（监控报警啊什么的，对于天天做电脑前报警还得通过邮件短信提醒多不直接呢）


Acts as Hubot Adapter
------
* Add `hubot-qq` as a dependency in your hubots `package.json`
* Run `npm install` in your hubots directory
* Run hubot with `bin/hubot -a qq`

Configurable Variables

	HUBOT_QQ_ID			#QQ ID
	HUBOT_QQ_PASS		#password
	HUBOT_QQ_GROUP		#group name that hubot listens to
	HUBOT_QQ_IMGPORT    #the port to serve verify-codes
	#for more debug variables plz check src/hubot-qq source file

On LINUX or OSX use `export VARIABLE=VALUE` to set environment variables.


独立作为机器人运行
-----
* 执行 `sudo npm install -g coffee-script` 安装 `CoffeeScript`
* 执行 `npm install` 更新依赖
* 配置一份你自己的 `config.yaml`
* 执行 `./main.coffee` 让你的机器人躁起来~

部署
-----
> 部署环境下请确保你的机器人是不需要**验证码**登录的，否则可能会无法长时间在线  

我常用的命令 `./main.coffee nologin &>> tmp/dev.log &` , 也可以使用进程管理工具比如 `pm2` 更省心


API
----
TODO GET http://localhost:port/stdin?token=(token)&value=(value)  

改动
----
https://github.com/xhan/qqbot/blob/master/CHANGELOG.md

资料
----
* WebQQ协议     https://github.com/xhan/qqbot/blob/master/protocol.md
* Java版的另一个 http://webqq-core.googlecode.com/

TODO
---
* 群成员拉取失败问题跟踪
* 用户信息,qq号等
* 机器人响应前缀
* 图片发送支持

