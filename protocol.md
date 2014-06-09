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
flag 1090519041
gid 2774835871   #发表用到
code 1787526753  #获取群member用到


```

群成员
``` json
{"retcode":0,"result":{"stats":[{"client_type":1,"uin":2440652742,"stat":10},{"client_type":41,"uin":2769546520,"stat":10}],"minfo":[{"nick":"呼吸 (糗百)","province":"上海","gender":"male","uin":2440652742,"country":"中国","city":"浦东新区"},{"nick":"robot","province":"上海","gender":"female","uin":2899268194,"country":"中国","city":"杨浦"},{"nick":"qqbot","province":"广东","gender":"male","uin":2769546520,"country":"中国","city":"深圳"},{"nick":"robot ops","province":"上海","gender":"male","uin":2041084648,"country":"中国","city":"黄浦"}],"ginfo":{"face":0,"memo":"","class":10048,"fingermemo":"","code":3483368056,"createtime":1388307595,"flag":1090519041,"level":0,"name":"qqbot群","gid":2559225925,"owner":2769546520,"members":[{"muin":2440652742,"mflag":21},{"muin":2899268194,"mflag":20},{"muin":2769546520,"mflag":20},{"muin":2041084648,"mflag":0}],"option":1},"vipinfo":[{"vip_level":0,"u":2440652742,"is_vip":0},{"vip_level":0,"u":2899268194,"is_vip":0},{"vip_level":0,"u":2769546520,"is_vip":0},{"vip_level":0,"u":2041084648,"is_vip":0}]}}
```


8. 讨论组


获取讨论组

GET http://s.web2.qq.com/api/get_discus_list

clientid
psessionid
vfwebqq
t


ret {"retcode":0,"result":{"dnamelist":[{"name":"good day","did":2006892653}]}}


获取讨论组 成员

GET http://d.web2.qq.com/channel/get_discu_info
did
clientid
psessionid
vfwebqq
t


{"retcode":0,"result":{"info":{"did":2006892653,"discu_owner":1657605740,"discu_name":"good day","info_seq":2,"mem_list":[{"mem_uin":1960624993,"ruin":21984709},{"mem_uin":1657605740,"ruin":123774072},{"mem_uin":2769546520,"ruin":2769546520}]},"mem_status":[{"uin":1657605740,"status":"online","client_type":1},{"uin":2769546520,"status":"online","client_type":41}],"mem_info":[{"uin":1960624993,"nick":"21984709"},{"uin":1657605740,"nick":"\u547C\u5438 (\u7CD7\u767E)"},{"uin":2769546520,"nick":"qqbot"}]}}


发表消息：  
did -> 组标识  

POST http://d.web2.qq.com/channel/send_discu_msg2



post:
clientid
psessionid
r= 
{"did":"2006892653","content":"[\"gogo\\n\",[\"font\",{\"name\":\"宋体\",\"size\":\"10\",\"style\":[0,0,0],\"color\":\"000000\"}]]","msg_id":78330002,"clientid":"30833194","psessionid":"8368046764001d636f6e6e7365727665725f77656271714031302e3133332e34312e38340000687900000ac0026e040018ed13a56d0000000a404c3453313676556f5a6d0000002815ee4198a3f863ce8931fec0dd1fe0e6fc9c06887829c4f7342a936929d79271bdac9e0764af52f9"}  

clientid:84369220
         30833194
                  
{
    "clientid": "30833194",
    "content": "[\"gogo\\n\",[\"font\",{\"name\":\"宋体",\"size\":\"10\",\"style\":[0,0,0],\"color\":\"000000\"}]]",
    "did": "2006892653",
    "msg_id": 78330002,
    "psessionid": "8368046764001d636f6e6e7365727665725f77656271714031302e3133332e34312e38340000687900000ac0026e040018ed13a56d0000000a404c3453313676556f5a6d0000002815ee4198a3f863ce8931fec0dd1fe0e6fc9c06887829c4f7342a936929d79271bdac9e0764af52f9"
}


图片  {"did":"2006892653","key":"E3MR8qZFt9xvRYRp","sig":"70448d5ab241b34b39622d1d6eaebdd462af7e55a154fa0cf7fccac522cac89ae78abdc646825f2f3429b31d913823e200eb2a319b4ea034","content":"[[\"cface\",\"group\",\"8D100B2F7A9221FBD60D46AA97E038B9.jPg\"],\"\\n\",[\"font\",{\"name\":\"宋体\",\"size\":\"10\",\"style\":[0,0,0],\"color\":\"000000\"}]]","clientid":"72295937","psessionid":"8368046764001d636f6e6e7365727665725f77656271714031302e3133332e34312e38340000019000000ac1026e040018ed13a56d0000000a404c3453313676556f5a6d00000028402c0abcd7ca6e184430d72632b8cb5e965901346358ba0111a7df92673c6a86251c124ef348c8c0"}
```




讨论组图片
POST  http://up.web2.qq.com/cgi-bin/cface_upload?time=1395248690537
	multipart/form-data;
	--
	from	control
	f	EQQ.Model.ChatMsg.callbackSendPicGroup
	vfwebqq	402c0abcd7ca6e184430d72632b8cb5e965901346358ba0111a7df92673c6a86251c124ef348c8c0
	custom_face  binary
	fileid 1

http://web2.qq.com/cgi-bin/webqq_app/?cmd=2&bd=8D100B2F7A9221FBD60D46AA97E038B9.jPg&vfwebqq=402c0abcd7ca6e184430d72632b8cb5e965901346358ba0111a7df92673c6a86251c124ef348c8c0

8D100B2F7A9221FBD60D46AA97E038B9.jPg8D100B2F7A9221FBD60D46AA97E038B9.jPg -7001


讨论组图片2
get http://d.web2.qq.com/channel/get_gface_sig2?clientid=72295937&psessionid=8368046764001d636f6e6e7365727665725f77656271714031302e3133332e34312e38340000019000000ac1026e040018ed13a56d0000000a404c3453313676556f5a6d00000028402c0abcd7ca6e184430d72632b8cb5e965901346358ba0111a7df92673c6a86251c124ef348c8c0&t=1395248986808

{"retcode":0,"result":{"reply":0,"gface_key":"E3MR8qZFt9xvRYRp","gface_sig":"70448d5ab241b34b39622d1d6eaebdd462af7e55a154fa0cf7fccac522cac89ae78abdc646825f2f3429b31d913823e200eb2a319b4ea034"}}



接受消息：


{"retcode":0,"result":[{"poll_type":"discu_message","value":{"msg_id":18803,"from_uin":10000,"to_uin":2769546520,"msg_id2":175418,"msg_type":42,"reply_ip":176488598,"did":2006892653,"send_uin":1657605740,"seq":8,"time":1395249174,"info_seq":2,"content":[["font",{"size":13,"color":"004faa","style":[0,0,0],"name":"STKaiti"}],"world "]}}]}


### 全局header

```
Accept	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding	gzip, deflate
Accept-Language	en-US,en;q=0.5
Connection	keep-alive
Content-Type	utf-8
Cookie	pgv_pvid=200718902; ts_uid=3184827993; pt2gguin=o1953024456; RK=pXXKnGphdn; ptcz=7c391c6d99aa6721878e46168f055a4d896d4312382656cfa344ebafdaa73509; hideusehttpstips=1; pgv_info=ssid=s6396104556&pgvReferrer=; ptisp=ctc; verifysession=h02mz5_56T4mZkxOmYRLSTPDJf1Nw9ZHo0ooO9ClWROPye9FukVWemEHC6buD7N7INJXn2vBvy8q0oCcXpfa6r9_Q**; ptui_loginuin=1953024456; uin=o1953024456; skey=@SoxMZ1bd4; ptwebqq=636683b80e7b0b46e26cc6b07c33432a4ab692e52f96e105d4d06fabd0735986; p_uin=o1953024456; p_skey=vnhLt1L6rI9PxEcvDyJCKttVGcjynVh-v7IZlH8s*oM_; pt4_token=rcG*VvNuYkYzE8IcWUGgVg__
Host	d.web2.qq.com
Referer	http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=2
User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0
```

### 修改状态
get http://d.web2.qq.com/channel/change_status2

```
clientid	34705872
newstatus	hidden
psessionid	8368046764001d636f6e6e7365727665725f77656271714031302e3133332e342e313732000024b000001950026e0400c8c968746d0000000a40536f784d5a316264346d000000285859e6c03eb067fa5d389b278a62aeeba9ff31395b9e37a29f5c8f5ba42c3ad2a47cd83332dbe5d8
t	1401343586702
```

[online,hidden,busy,callme,offline]

resp:  `{"retcode":0,"result":"ok"} `



### 获取群号/用户qq号
get http://s.web2.qq.com/api/get_friend_uin2

```  群
code	
t	1401344118978
tuin	4292540855
type	4
verifysession	
vfwebqq	5859e6c03eb067fa5d389b278a62aeeba9ff31395b9e37a29f5c8f5ba42c3ad2a47cd83332dbe5d8
```

```
{"retcode":0,"result":{"uiuin":"","account":346167134,"uin":4292540855}}
346167134 群号
```

```  用户
code	
t	1401344326640
tuin	10077914
type	1
verifysession	
vfwebqq	5859e6c03eb067fa5d389b278a62aeeba9ff31395b9e37a29f5c8f5ba42c3ad2a47cd83332dbe5d8
```

```
{"retcode":0,"result":{"uiuin":"","account":2489288370,"uin":10077914}}
```






### 未整理


错误代码说明: 

ptuiCB('7','0','','0','很遗憾，网络连接出现异常，请您稍后再试。(612369104)'); 

cookie或qq号码问题 
ptuiCB('0','0','http://aq.qq.com/cn/services/abnormal/abnormal_index? 。。。。。。！');
帐号冻结 

{"retcode":102 ,"errmsg":""}  

正常连接、没有消息。 

{"retcode":103,"errmsg":""} 

掉线  

{"retcode":108,"errmsg":""}

{"retcode":114,"errmsg":""} 

{"retcode":121,"t":"0"} 

掉线 

{"retcode":122,"errmsg":"wrong web client3"} 

{"retcode":100001}

 群编号有问题

{"retcode":100006,"errmsg":""} 





