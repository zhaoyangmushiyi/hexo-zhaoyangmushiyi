---
title: MacOS开启端口转发
date: 2020-07-03 17:03:39
tags:
    - MacOS
categories:
    - MacOS
---

### 在/etc/pf.anchors/目录下新建一个名为com.pow文件，内容如下

```shell
rdr pass on en0 inet proto tcp from any to any port 8080 -> 127.0.0.1 port 8080
rdr pass on en5 inet proto tcp from any to any port 8080 -> 127.0.0.1 port 8080
```

上面的配置标表示的意思是将从en0和en5，目的端口为8080的包转发到8080端口上

### 使用`pfctl`命令检测配置文件

```shell
sudo pfctl -vnf /etc/pf.anchors/com.pow
```

### 修改`/etc/pf.conf`配置文件

`pf`启动时会自动装载`/etc/pf.conf`文件，因此将`anchor`文件链接到`/etc/pf.conf`，转发规则就会自动建立了。

```shell
#在rdr-anchor "com.apple/*"下面增加：

rdr-anchor "pow"

#在load anchor "com.apple" from "/etc/pf.anchors/com.apple"后面添加：

load anchor "pow" from "/etc/pf.anchors/com.pow"
```



修改后的配置如下：

```shell
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "com.apple/*"
rdr-anchor "pow"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
load anchor "pow" from "/etc/pf.anchors/com.pow"
```

导入并运行`pf`命令

一定要导入并允许运行`pf`的命令

```shell
sudo pfctl -evf /etc/pf.anchors/com.pow
```


设置`pf`开机自动打开

```shell
sudo pfctl -e
```

如果想要关闭`pf`，命令是

```shell
sudo pfctl -d1
```
