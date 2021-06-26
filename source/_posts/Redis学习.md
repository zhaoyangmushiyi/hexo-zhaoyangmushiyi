---
title: Redis学习
date: 2021-06-26 17:58:19
tags:
    - Java
    - Redis
categories:
    - Java
    - Redis
---

Redis 是一种开源（BSD 许可）、内存中数据结构存储，用作数据库、缓存和消息代理。Redis 提供了诸如字符串、散列、列表、集合、带范围查询的排序集合、位图、超级日志、地理空间索引和流等数据结构。Redis 内置复制、Lua 脚本、LRU 驱逐、事务和不同级别的磁盘持久化，并通过 Redis Sentinel 和 Redis Cluster 自动分区提供高可用性。

<!-- more -->

# Docker安装Redis

1. 获取镜像

   ```shell
   docker pull redis
   ```

2. 运行镜像

   ```shell
   docker run -itd --name docker-redis -p 6379:6379 redis
   ```

3. 通过`redis-cli`连接测试使用`redis`服务

   ```shell
   docker exec -it docker-redis /bin/bash
   redis-cli
   set test 1
   get test
   ```

   ![截屏2021-06-26 18.40.43](/images/Redis学习/Docker安装Redis测试.png)

# Redis键(key)

keys * 查看当前库所有key  (匹配：keys *1)

exists key 判断某个key是否存在

type key 查看你的key是什么类型

del key    删除指定的key数据

unlink key  根据value选择非阻塞删除

仅将keys从keyspace元数据中删除，真正的删除会在后续异步操作。

expire key 10  10秒钟：为给定的key设置过期时间

ttl key 查看还有多少秒过期，-1表示永不过期，-2表示已过期



select命令切换数据库

dbsize查看当前数据库的key的数量

flushdb清空当前库

flushall通杀全部库

# 常用五大数据类型

## Redis字符串(String)

### **简介**

String是Redis最基本的类型，你可以理解成与Memcached一模一样的类型，一个key对应一个value。

String类型是二进制安全的。意味着Redis的string可以包含任何数据。比如jpg图片或者序列化的对象。

String类型是Redis最基本的数据类型，一个Redis中字符串value最多可以是512M

### **常用命令**

set  <key><value>添加键值对

 ![截屏2021-06-26 21.53.41](/images/Redis学习/String-set.png)

*NX：当数据库中key不存在时，可以将key-value添加数据库

*XX：当数据库中key存在时，可以将key-value添加数据库，与NX参数互斥

*EX：key的超时秒数

*PX：key的超时毫秒数，与EX互斥

 

get  <key>查询对应键值

append <key><value>将给定的<value> 追加到原值的末尾

strlen <key>获得值的长度

setnx <key><value>只有在 key 不存在时  设置 key 的值

 

incr <key> 

将 key 中储存的数字值增1(原子操作，不会被线程调度机制打断)

只能对数字值操作，如果为空，新增值为1

decr <key>

将 key 中储存的数字值减1

只能对数字值操作，如果为空，新增值为-1

incrby / decrby <key><步长>将 key 中储存的数字值增减。自定义步长。

<img src="/images/Redis学习/String-命令1.png" alt="String-命令1.png" style="zoom:50%;" />

mset <key1><value1><key2><value2> ..... 

同时设置一个或多个 key-value对 

mget <key1><key2><key3> .....

同时获取一个或多个 value 

msetnx <key1><value1><key2><value2> ..... 

同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。**原子性，有一个失败则都失败**

 

getrange <key><起始位置><结束位置>

获得值的范围，类似java中的substring，**前包，后包**

setrange <key><起始位置><value>

用 <value> 覆写<key>所储存的字符串值，从<起始位置>开始(**索引从0开始**)。

 

setex <key><过期时间><value>

设置键值的同时，设置过期时间，单位秒。

getset <key><value>

以新换旧，设置了新值同时获得旧值。

<img src="/images/Redis学习/String-命令2.png" alt="String-命令2.png" style="zoom:50%;" />

## **数据结构**

String的数据结构为简单动态字符串(Simple Dynamic String,缩写SDS)。是可以修改的字符串，内部结构实现上类似于Java的ArrayList，采用预分配冗余空间的方式来减少内存的频繁分配.

![image-20210626220837603](/images/Redis学习/String-数据结构.png)

如图中所示，内部为当前字符串实际分配的空间capacity一般要高于实际字符串长度len。当字符串长度小于1M时，扩容都是加倍现有的空间，如果超过1M，扩容时一次只会多扩1M的空间。需要注意的是字符串最大长度为512M。
