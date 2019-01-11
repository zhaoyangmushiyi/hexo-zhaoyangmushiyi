---
title: Jenkins环境安装
date: 2019-01-11 15:25:15
tags:
    - Jenkins
categories:
    - Jenkins
---
　　Jenkins是一款由Java编写的开源的持续集成工具。  
　　Jenkins提供了软件开发的持续集成服务。它运行在Servlet容器中（例如Apache Tomcat）。它支持软件配置管理（SCM）工具（包括AccuRev SCM、CVS、Subversion、Git、Perforce、Clearcase和RTC），可以执行基于Apache Ant和Apache Maven的项目，以及任意的Shell脚本和Windows批处理命令。Jenkins的主要开发者是川口耕介。Jenkins是在MIT许可证下发布的自由软件。  
　　可以通过各种手段触发构建。例如提交给版本控制系统时被触发，也可以通过类似Cron的机制调度，也可以在其他的构建已经完成时，还可以通过一个特定的URL进行请求。
<!-- more -->
## Jenkins
### JDK环境安装
安装wget，wget是一个从网络上自动下载文件的自由工具，支持通过 HTTP、HTTPS、FTP 三个最常见的 TCP/IP协议 下载。
```
yum -y install wget
```
下载[JDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
```
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F;oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz
```
解压
```
tar -zxvf jdk-8u191-linux-x64.tar.gz
```
配置环境变量
```
vim /etc/profile

#set java environment
JAVA_HOME=/usr/java/jdk1.8
CLASS_PATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
PATH=$JAVA_HOME/bin:$PATH
export PATH JAVA_HOME CLASS_PATH

source /etc/profile
```
验证：
```
java -version
```
### Maven安装
下载[Maven](http://mirror.bit.edu.cn/apache/maven/maven-3/)
```
wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
```
添加阿里的Maven仓库节点配置`conf/settings.xml`
```
    <mirror>
        <id>nexus-aliyun</id>
        <mirrorOf>*</mirrorOf>
        <name>Nexus aliyun</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    </mirror> 
```
配置环境变量
```
#Maven environment
MAVEN_HOME=/usr/maven
PATH=$PATH:$MAVEN_HOME/bin
export PATH
```
### 安装Jenkins
下载[Jenkins](http://updates.jenkins-ci.org/download/war/)
```
wget http://updates.jenkins-ci.org/download/war/2.157/jenkins.war
```
启动Jenkins war包，默认8080端口
```
java -jar jenkins.war
```
开放端口
```
firewall-cmd --add-port=8080/tcp --permanent   #添加规则
firewall-cmd --reload                          #重新加载防火墙配置
```
### 安装git
```
yum install -y git
git --version
```
### 搭建第一个项目
配置git web hook 安装 gitlab hook plugin 系统管理 -> 插件管理 -> 可选插件 -> 搜索 gitlab hook plugin -> 选中安装 
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins0)
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins1)
构建一个自由风格的软件项目 
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins2)
设置源码管理
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins3)
设置自动构建
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins4)
然后去gitlab填写刚刚获取的URL和Token
![](https://github.com/zhaoyangmushiyi/hexo-zhaoyangmushiyi/tree/master/public/images/uploads/jenkins5)