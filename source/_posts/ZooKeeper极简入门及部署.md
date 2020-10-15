---
title: ZooKeeper极简入门及部署
date: 2020-07-12 22:55:11
tags:
    - Zookeeper
categories:
    - Zookeeper
---

## 简介

Apache ZooKeeper是Apache软件基金会的一个软件项目，它为大型分布式计算提供开源的分布式配置服务、同步服务和命名注册。ZooKeeper曾经是Hadoop的一个子项目，但现在是一个独立的顶级项目。

ZooKeeper的架构通过冗余服务实现高可用性。因此，如果第一次无应答，客户端就可以询问另一台ZooKeeper主机。ZooKeeper节点将它们的数据存储于一个分层的命名空间，非常类似于一个文件系统或一个前缀树结构。客户端可以在节点读写，从而以这种方式拥有一个共享的配置服务。更新是全序的。

<!-- more -->

## 本地部署

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

## Docker部署

### pull image

```shell
docker pull zookeeper
```

### Start a Zookeeper server instance

```shell
docker run --name some-zookeeper --restart always -d zookeeper
```

This image includes `EXPOSE 2181 2888 3888 8080` (the zookeeper client port, follower port, election port, AdminServer port respectively), so standard container linking will make it automatically available to the linked containers. Since the Zookeeper "fails fast" it's better to always restart it.

### Connect to Zookeeper from an application in another Docker container

```shell
docker run --name some-app --link some-zookeeper:zookeeper -d application-that-uses-zookeeper
```

### Connect to Zookeeper from the Zookeeper command line client

```
$ docker run -it --rm --link some-zookeeper:zookeeper zookeeper zkCli.sh -server zookeeper
```

### ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `zookeeper`:

```yml
version: '3.1'

services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com/?stack=https://raw.githubusercontent.com/docker-library/docs/ef162dce5998011e1753c3337dcbe61200c522d2/zookeeper/stack.yml)

This will start Zookeeper 3.5 in [replicated mode](https://zookeeper.apache.org/doc/current/zookeeperStarted.html#sc_RunningReplicatedZooKeeper). Please note, that Zookeeper 3.4 has slightly different `ZOO_SERVERS` format. Run `docker stack deploy -c stack.yml zookeeper` (or `docker-compose -f stack.yml up`) and wait for it to initialize completely. Ports `2181-2183` will be exposed.

> Please be aware that setting up multiple servers on a single machine will not create any redundancy. If something were to happen which caused the machine to die, all of the zookeeper servers would be offline. Full redundancy requires that each server have its own machine. It must be a completely separate physical server. Multiple virtual machines on the same physical host are still vulnerable to the complete failure of that host.

Consider using [Docker Swarm](https://www.docker.com/products/docker-swarm) when running Zookeeper in replicated mode.

### Configuration

Zookeeper configuration is located in `/conf`. One way to change it is mounting your config file as a volume:

```shell
docker run --name some-zookeeper --restart always -d -v $(pwd)/zoo.cfg:/conf/zoo.cfg zookeeper
```

### Environment variables

ZooKeeper recommended defaults are used if `zoo.cfg` file is not provided. They can be overridden using the following environment variables.

```
$ docker run -e "ZOO_INIT_LIMIT=10" --name some-zookeeper --restart always -d zookeeper
```

### `ZOO_TICK_TIME`

Defaults to `2000`. ZooKeeper's `tickTime`

> The length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds. It is used to regulate heartbeats, and timeouts. For example, the minimum session timeout will be two ticks

### `ZOO_INIT_LIMIT`

Defaults to `5`. ZooKeeper's `initLimit`

> Amount of time, in ticks (see tickTime), to allow followers to connect and sync to a leader. Increased this value as needed, if the amount of data managed by ZooKeeper is large.

### `ZOO_SYNC_LIMIT`

Defaults to `2`. ZooKeeper's `syncLimit`

> Amount of time, in ticks (see tickTime), to allow followers to sync with ZooKeeper. If followers fall too far behind a leader, they will be dropped.

### `ZOO_MAX_CLIENT_CNXNS`

Defaults to `60`. ZooKeeper's `maxClientCnxns`

> Limits the number of concurrent connections (at the socket level) that a single client, identified by IP address, may make to a single member of the ZooKeeper ensemble.

### `ZOO_STANDALONE_ENABLED`

Defaults to `true`. Zookeeper's [`standaloneEnabled`](https://zookeeper.apache.org/doc/r3.5.7/zookeeperReconfig.html#sc_reconfig_standaloneEnabled)

> Prior to 3.5.0, one could run ZooKeeper in Standalone mode or in a Distributed mode. These are separate implementation stacks, and switching between them during run time is not possible. By default (for backward compatibility) standaloneEnabled is set to true. The consequence of using this default is that if started with a single server the ensemble will not be allowed to grow, and if started with more than one server it will not be allowed to shrink to contain fewer than two participants.

### `ZOO_ADMINSERVER_ENABLED`

Defaults to `true`. Zookeeper's [`admin.enableServer`](http://zookeeper.apache.org/doc/r3.5.7/zookeeperAdmin.html#sc_adminserver_config)

> New in 3.5.0: The AdminServer is an embedded Jetty server that provides an HTTP interface to the four letter word commands. By default, the server is started on port 8080, and commands are issued by going to the URL "/commands/[command name]", e.g., http://localhost:8080/commands/stat.

### `ZOO_AUTOPURGE_PURGEINTERVAL`

Defaults to `0`. Zookeeper's [`autoPurge.purgeInterval`](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_advancedConfiguration)

> The time interval in hours for which the purge task has to be triggered. Set to a positive integer (1 and above) to enable the auto purging. Defaults to 0.

### `ZOO_AUTOPURGE_SNAPRETAINCOUNT`

Defaults to `3`. Zookeeper's [`autoPurge.snapRetainCount`](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_advancedConfiguration)

> When enabled, ZooKeeper auto purge feature retains the autopurge.snapRetainCount most recent snapshots and the corresponding transaction logs in the dataDir and dataLogDir respectively and deletes the rest. Defaults to 3. Minimum value is 3.

### `ZOO_4LW_COMMANDS_WHITELIST`

Defaults to `srvr`. Zookeeper's [`4lw.commands.whitelist`](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_clusterOptions)

> A list of comma separated Four Letter Words commands that user wants to use. A valid Four Letter Words command must be put in this list else ZooKeeper server will not enable the command. By default the whitelist only contains "srvr" command which zkServer.sh uses. The rest of four letter word commands are disabled by default.

## Advanced configuration

### `ZOO_CFG_EXTRA`

Not every Zookeeper configuration setting is exposed via the environment variables listed above. These variables are only meant to cover minimum configuration keywords and some often changing options. If [mounting your custom config file](https://hub.docker.com/_/zookeeper#configuration) as a volume doesn't work for you, consider using `ZOO_CFG_EXTRA` environment variable. You can add arbitrary configuration parameters to Zookeeper configuration file using this variable. The following example shows how to enable Prometheus metrics exporter on port `7070`:

```shell
docker run --name some-zookeeper --restart always -e ZOO_CFG_EXTRA="metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider metricsProvider.httpPort=7070" zookeeper
```

### `JVMFLAGS`

Many of the Zookeeper advanced configuration options can be set there using Java system properties in the form of `-Dproperty=value`. For example, you can use Netty instead of NIO (default option) as a server communication framework:

```shell
docker run --name some-zookeeper --restart always -e JVMFLAGS="-Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory" zookeeper
```

See [Advanced Configuration](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_advancedConfiguration) for the full list of supported Java system properties.

Another example use case for the `JVMFLAGS` is setting a maximum JWM heap size of 1 GB:

```
$ docker run --name some-zookeeper --restart always -e JVMFLAGS="-Xmx1024m" zookeeper
```

## Replicated mode

Environment variables below are mandatory if you want to run Zookeeper in replicated mode.

### `ZOO_MY_ID`

The id must be unique within the ensemble and should have a value between 1 and 255. Do note that this variable will not have any effect if you start the container with a `/data` directory that already contains the `myid` file.

### `ZOO_SERVERS`

This variable allows you to specify a list of machines of the Zookeeper ensemble. Each entry has the form of `server.id=host:port:port`. Entries are separated with space. Do note that this variable will not have any effect if you start the container with a `/conf` directory that already contains the `zoo.cfg` file.

In 3.5, the syntax of this has changed. Servers should be specified as such: `server.id=<address1>:<port1>:<port2>[:role];[<client port address>:]<client port>` [Zookeeper Dynamic Reconfiguration](https://zookeeper.apache.org/doc/r3.5.7/zookeeperReconfig.html)

## Where to store data

This image is configured with volumes at `/data` and `/datalog` to hold the Zookeeper in-memory database snapshots and the transaction log of updates to the database, respectively.

> Be careful where you put the transaction log. A dedicated transaction log device is key to consistent good performance. Putting the log on a busy device will adversely affect performance.

## How to configure logging

By default, ZooKeeper redirects stdout/stderr outputs to the console. You can redirect to a file located in `/logs` by passing environment variable `ZOO_LOG4J_PROP` as follows:

```shell
docker run --name some-zookeeper --restart always -e ZOO_LOG4J_PROP="INFO,ROLLINGFILE" zookeeper
```

This will write logs to `/logs/zookeeper.log`. Check [ZooKeeper Logging](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_logging) for more details.

This image is configured with a volume at `/logs` for your convenience.