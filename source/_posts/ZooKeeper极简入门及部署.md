---
title: ZooKeeper极简入门及部署
date: 2020-07-12 22:55:11
tags:
    - Zookeeper
categories:
    - Zookeeper
---

### 简介

Apache ZooKeeper是Apache软件基金会的一个软件项目，它为大型分布式计算提供开源的分布式配置服务、同步服务和命名注册。ZooKeeper曾经是Hadoop的一个子项目，但现在是一个独立的顶级项目。

ZooKeeper的架构通过冗余服务实现高可用性。因此，如果第一次无应答，客户端就可以询问另一台ZooKeeper主机。ZooKeeper节点将它们的数据存储于一个分层的命名空间，非常类似于一个文件系统或一个前缀树结构。客户端可以在节点读写，从而以这种方式拥有一个共享的配置服务。更新是全序的。

<!-- more -->

### 单机部署

- 操作系统: Mac OS 10.15(其他系统一样)
- JDK: 11

#### 下载

打开 [Zookeeper 下载页面](https://archive.apache.org/dist/zookeeper/)，选择想要安装的版本。我选择的是 [stable](https://archive.apache.org/dist/zookeeper/stable/) 稳定版本，版本是3.5.8，选择编译好的包，[apache-zookeeper-3.5.8-bin.tar.gz](https://archive.apache.org/dist/zookeeper/stable/apache-zookeeper-3.5.8-bin.tar.gz)。

```shell
# 下载
wget https://archive.apache.org/dist/zookeeper/stable/apache-zookeeper-3.5.8-bin.tar.gz
# 解压
tar -zxvf apache-zookeeper-3.5.8-bin.tar.gz
cd apache-zookeeper-3.5.8-bin
```

#### 配置文件

Zookeeper 提供了 `conf/zoo_sample.cfg` 模版配置文件，作为示例。这里，我们复制一下，复制出一个 `conf/zoo.cfg `(默认读取的配置文件)，然后在上面进行修改，修改后配置如下：

```properties
# The number of milliseconds of each tick
# Client-Server 通信心跳时间
# Zookeeper 服务器之间或客户端与服务器之间维持心跳的时间间隔，也就是每个 tickTime 时间就会发送一个心跳。tickTime 以毫秒为单位。
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
# Leader-Follower 初始通信时限
# 集群中的 follower 服务器(F)与 leader 服务器(L)之间初始连接时能容忍的最多心跳数（tickTime 的数量）。
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
# Leader-Follower 同步通信时限
# 集群中的 follower 服务器与 leader 服务器之间请求和应答之间能容忍的最多心跳数（tickTime的数量）。
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
# 数据文件目录
# Zookeeper 保存数据的目录，默认情况下，Zookeeper 将写数据的日志文件也保存在这个目录里。
dataDir=/Users/monochrome/app/Zookeeper/apache-zookeeper-3.5.8-bin/data
# the port at which the clients will connect
# 客户端连接端口
# 客户端连接 Zookeeper 服务器的端口，Zookeeper 会监听这个端口，接受客户端的访问请求。
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
```

#### 运行Zookeeper Server

执行 `bin/zkServer.sh start` 命令，启动 Zookeeper Server 服务。此时，控制台会输出如下日志，表示启动成功。

```shell
bin/zkServer.sh start

# 默认情况下，Zookeeper 开启 JMX
ZooKeeper JMX enabled by default
# 使用 conf/zoo.cfg 配置文件
Using config: /Users/monochrome/app/Zookeeper/apache-zookeeper-3.5.8-bin/bin/../conf/zoo.cfg
# 启动 Zookeeper Server 成功（实际不一定成功）
Starting zookeeper ... STARTED
```

注意，Zookeeper 3.5 版本开始，默认会在 8080 端口，启动一个 Zookeeper **AdminServer**。如果 8080 端口已经被其它服务占用，会导致 Zookeeper Server 启动失败。此时，我们有三种解决方案：

- 方式一，可以修改 `conf/zoo.cfg` 配置文件的 `admin.serverPort` 配置项，从而修改 Zookeeper AdminServer 的端口。
- 方式二，可以修改 `conf/zoo.cfg` 配置文件的 `admin.enableServer=false` 配置项，从而关闭 Zookeeper AdminServer 的启动。
- 方式三，关闭占用 8080 端口的服务。

#### 测试连接

测试连接到 Zookeeper Server 上，看看是否真的启动成功。操作命令如下：

```shell
# 连接 Zookeeper Server
$ bin/zkCli.sh
# 输出如下日志信息表示连接成功
Welcome to ZooKeeper!
JLine support is enabled

# 在 Zookeeper 命令行中，执行 ls / 命令，输出根目录
[zk: localhost:2181(CONNECTED) 0] ls /
[zookeeper]
```

### 集群部署

待续