WebQQ 协议文档
===============
更新时间： 2013.12.30
> 后来发现以及有几个专门的论坛（见首页）在讨论WebQQ接口，所以这里不再更新具体协议，而是调试过程中的问题记录
> 是否有需要的cookie，请求参数，以及http header 比如refer 都可能导致请求失败，最好的办法就是抓包后复制所有信息:D

1.第一次握手，获取加密信息以及是否需要验证码
-----
ptui_checkVC('1','4GJSgm18Bw-8yw5JGKpSOXH-0idqvaCU','\x00\x00\x00\x00\xa5\x13\xed\x18');
* @param1 是否需要验证码
* @param2 默认验证码，如果 @param1 为1 此字段没用 ，密码加密需要
* @param2 密码加密需要

> 这里会取得一些 cookie


2.获取验证码图片（非必要）
-----
> 这里会取得一些 cookie



3.账户密码以及验证码的校验
-----
密码加密方式，略

	ptuiCB('7','0','','0','很遗憾，网络连接出现异常，请您稍后再试。(2220884626)', '123774072'); `参数不对就出现这个`
	ptuiCB('4','0','','0','您输入的验证码不正确，请重新输入。', '123774072');	
	ptuiCB('24','0','','0','很遗憾，网络连接出现异常，请您检查是否禁用cookies。(3972006392)', '123774072'); 
	ptuiCB('4','2','','0','页面过期，请重试。*', '123774072');
	ptuiCB('0','0','link','0','登录成功！', '呼吸 (糗百)');
	[ '3', '0', '', '0', '您输入的帐号或密码不正确，请重新输入。', '2769546520' ]


4.获取额外的cookie
-------
步骤3中 @param3 需要请求一次，并得到登录所需要的所有cookie ，最简单的一步


5.获取登录token
-----        
需要保存的几个参数，当然之前获得的cookie是必要的     
                       
	psessionid : 本次返回值 
	client_id  : 步骤@4 自己生成
	ptwebqq    : 步骤@4 来源cookie
	uin        : 本次返回值
	vfwebqq    : 本次返回值

错误码：  

	{ retcode: 108, errmsg: '' } `缺少cookie`
	{ retcode: 103, errmsg: '' } `缺少cookie`


6.长轮训
-----
错误码 108 应该也是 cookie

121 重复登录

sys_g_msg  
kick_message

``` json
{
    "result": [
        {
            "poll_type": "message",
            "value": {
                "content": [
                    [
                        "font",
                        {
                            "color": "004faa",
                            "name": "STKaiti",
                            "size": 13,
                            "style": [
                                0,
                                0,
                                0
                            ]
                        }
                    ],
                    "hii "
                ],
                "from_uin": 2440652742,
                "msg_id": 24225,
                "msg_id2": 950054,
                "msg_type": 9,
                "reply_ip": 176498455,
                "time": 1388368696,
                "to_uin": 2769546520
            }
        }
    ],
    "retcode": 0
}

{
    "result": [
        {
            "poll_type": "group_message",
            "value": {
                "content": [
                    [
                        "font",
                        {
                            "color": "004faa",
                            "name": "STKaiti",
                            "size": 13,
                            "style": [
                                0,
                                0,
                                0
                            ]
                        }
                    ],
                    "ooo "
                ],
                "from_uin": 2559225925,
                "group_code": 3483368056,
                "info_seq": 346167134,
                "msg_id": 13663,
                "msg_id2": 886022,
                "msg_type": 43,
                "reply_ip": 176756826,
                "send_uin": 2440652742,
                "seq": 27,
                "time": 1388368698,
                "to_uin": 2769546520
            }
        }
    ],
    "retcode": 0
}
```


7.获取用户，群分组
-----
群分组非常简单，用户接口有个hash的字段。相传这个加密函数更新的比较及时。  
用js写的好处就不用每次跟着重新实现一套了，复制过来执行就好  
http://0.web.qstatic.com/webqqpic/pubapps/0/50/eqq.all.js  搜索 P=function

	{"retcode":100101} `没cookie` or `ua 未设置好`



用户分组信息格式
``` json
{
        "categories": [
            {
                "index": 1,
                "name": "Acquaintances",
                "sort": 1
            },
            {
                "index": 2,
                "name": "Family",
                "sort": 2
            }
        ],
        "friends": [
            {
                "categories": 0,
                "flag": 0,
                "uin": 2440652742
            }
        ],
        "info": [
            {
                "face": 0,
                "flag": 25707010,
                "nick": "\u547c\u5438 (\u7cd7\u767e)",
                "uin": 2440652742
            }
        ],
        "marknames": [],
        "vipinfo": [
            {
                "is_vip": 0,
                "u": 2440652742,
                "vip_level": 0
            }
        ]
}

```

群分组信息

``` json
{
    "gmarklist": [],
    "gmasklist": [],
    "gnamelist": [
        {
            "code": 3483368056,
            "flag": 1090519041,
            "gid": 2559225925,
            "name": "qqbot\u7fa4"
        }
    ]
}

```

群成员
``` json
{"retcode":0,"result":{"stats":[{"client_type":1,"uin":2440652742,"stat":10},{"client_type":41,"uin":2769546520,"stat":10}],"minfo":[{"nick":"呼吸 (糗百)","province":"上海","gender":"male","uin":2440652742,"country":"中国","city":"浦东新区"},{"nick":"robot","province":"上海","gender":"female","uin":2899268194,"country":"中国","city":"杨浦"},{"nick":"qqbot","province":"广东","gender":"male","uin":2769546520,"country":"中国","city":"深圳"},{"nick":"robot ops","province":"上海","gender":"male","uin":2041084648,"country":"中国","city":"黄浦"}],"ginfo":{"face":0,"memo":"","class":10048,"fingermemo":"","code":3483368056,"createtime":1388307595,"flag":1090519041,"level":0,"name":"qqbot群","gid":2559225925,"owner":2769546520,"members":[{"muin":2440652742,"mflag":21},{"muin":2899268194,"mflag":20},{"muin":2769546520,"mflag":20},{"muin":2041084648,"mflag":0}],"option":1},"vipinfo":[{"vip_level":0,"u":2440652742,"is_vip":0},{"vip_level":0,"u":2899268194,"is_vip":0},{"vip_level":0,"u":2769546520,"is_vip":0},{"vip_level":0,"u":2041084648,"is_vip":0}]}}
```
