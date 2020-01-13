---
title: 搭建Jenkins集群
date: 2019-11-28 17:18:24
tags:
	- Jenkins
categories:
    - Jenkins
---

### 安装Jenkins

下载[Jenkins](http://updates.jenkins-ci.org/download/war/)

```
wget http://updates.jenkins-ci.org/latest/jenkins.war
```

启动Jenkins war包，默认8080端口

```
java -jar jenkins.war
```

后台启动Jenkins

```
nohup java -jar jenkins.war --httpPort=8080 &
```

查看日志

```
tail -f nohup.out
```

开放端口

```
查看想开的端口是否已开：
firewall-cmd --query-port=9090/tcp 
添加指定需要开放的端口：
firewall-cmd --add-port=9090/tcp --permanent
重载入添加的端口：
firewall-cmd --reload
查询指定端口是否开启成功：
firewall-cmd --query-port=9090/tcp
```

<!-- more -->

### 安装git

```shell
yum install -y git
git --version
```

### 添加节点

进入系统管理-->节点管理-->新建节点：

![搭建Jenkins集群-1](/images/搭建Jenkins集群-1.png)

写入节点名称，选择固定节点，配置节点：

![搭建Jenkins集群-2](/images/搭建Jenkins集群-2.png)