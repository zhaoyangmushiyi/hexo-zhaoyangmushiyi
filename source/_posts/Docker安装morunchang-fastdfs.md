---
title: Docker安装morunchang/fastdfs
date: 2021-03-24 17:38:47
tags:
    - Docker
    - FastDFS
categories:
    - Docker
    - FastDFS
---

# Docker安装morunchang/fastdfs

## FastDFS简介

FastDFS是一款开源的分布式文件系统，功能主要包括：文件存储、文件同步、文件访问（文件上传、文件下载）等，解决了文件大容量存储和高性能访问的问题。FastDFS特别适合以文件为载体的在线服务，如图片、视频、文档等等。

FastDFS作为一款轻量级分布式文件系统，版本V6.01代码量6.3万行。FastDFS用C语言实现，支持Linux、FreeBSD、MacOS等类UNIX系统。FastDFS类似google FS，属于应用级文件系统，不是通用的文件系统，只能通过专有API访问，目前提供了C和Java SDK，以及PHP扩展SDK。

FastDFS为互联网应用量身定做，解决大容量文件存储问题，追求高性能和高扩展性。FastDFS可以看做是基于文件的key value存储系统，key为文件ID，value为文件内容，因此称作分布式文件存储服务更为合适。

<!-- more -->

## FastDFS由跟踪服务器(Tracker Server)、存储服务器(Storage Server)和客户端(Client)构成。

### Tracker server 追踪服务器

追踪服务器负责接收客户端的请求，选择合适的组合storage server ，tracker server 与 storage server之间也会用心跳机制来检测对方是否活着。
Tracker需要管理的信息也都放在内存中，并且里面所有的Tracker都是对等的（每个节点地位相等），很容易扩展客户端访问集群的时候会随机分配一个Tracker来和客户端交互。

### Storage server 储存服务器

实际存储数据，分成若干个组（group），实际traker就是管理的storage中的组，而组内机器中则存储数据，group可以隔离不同应用的数据，不同的应用的数据放在不同group里面，

- 优点：
  海量的存储：主从型分布式存储，存储空间方便拓展,
  fastDFS对文件内容做hash处理，避免出现重复文件
  然后fastDFS结合Nginx集成, 提供网站效率

### 客户端Client

- 主要是上传下载数据的服务器，也就是我们自己的项目所部署在的服务器。

##  FastDFS特点

1. 分组存储，简单灵活；
2. 对等结构，不存在单点；
3. 文件ID由FastDFS生成，作为文件访问凭证。FastDFS不需要传统的name server或meta server；
4. 大、中、小文件均可以很好支持，可以存储海量小文件；
5. 一台storage支持多块磁盘，支持单盘数据恢复；
6. 提供了nginx扩展模块，可以和nginx无缝衔接；
7. 支持多线程方式上传和下载文件，支持断点续传；
8. 存储服务器上可以保存文件附加属性。

## 安装FastDFS

### 获取镜像

```shell
docker pull morunchang/fastdfs;
```

### 设置Tracker 

#### 运行 tracker

```shell
docker run -d --name tracker --net=host morunchang/fastdfs sh tracker.sh
```

上面的启动命令是在Linux下，如果是Mac或Windows操作系统network=host（容器与主机享受相同的network namespace）会失效，此时需要指定对应的端口映射，-p 22122:22122 

#### 进入 tracker

```shell
docker exec -it tracker /bin/bash
```

#### 修改端口

**`/etc/nginx/conf/nginx.conf`**

```json
server {
        listen       21000;
        server_name  localhost;
}
```

**`/etc/fdfs/client.conf`**

```properties
tracker_server=127.0.0.1:22122
......
http.tracker_server_port=21000

```

**`/etc/fdfs/tracker.conf`**

```properties
port=22122
......
http.server_port=21000
```

### 设置Storage 

#### **运行 storage **

```shell
docker run -d --name storage --net=host -e TRACKER_IP=127.0.0.1:22122 -e GROUP_NAME=group1 morunchang/fastdfs sh storage.sh
#共享卷
docker run -d --name storage --net=host -e TRACKER_IP=127.0.0.1:22122 -v /home/monochrome/app/fastdfs/storage:/data/fast_data -e GROUP_NAME=group1 morunchang/fastdfs sh storage.sh

docker run -d --name storage -p 22000:22000 -p 23000:23000 -e TRACKER_IP=127.0.0.1:22122 -e GROUP_NAME=group1 morunchang/fastdfs sh storage.sh
#共享卷
docker run -d --name storage -p 22000:22000 -p 23000:23000 -e TRACKER_IP=127.0.0.1:22122 -v /home/monochrome/app/fastdfs/storage:/data/fast_data -e GROUP_NAME=mono morunchang/fastdfs sh storage.sh
```

#### **进入 storage**

```shell
docker exec -it storage /bin/bash
```

#### 修改端口

**`/etc/nginx/conf/nginx.conf`**

```conf
server {
        listen       22000;
        server_name  localhost;
}
```

**`/etc/fdfs/client.conf`**

```properties
tracker_server=127.0.0.1:22122
http.tracker_server_port=21000
```

**`/etc/fdfs/storage.conf`**

```properties
port=23000
tracker_server=127.0.0.1:22122
http.server_port=22000
```

### 替换配置文件

```shell
docker cp nginx.conf tracker:/etc/nginx/conf/nginx.conf
docker cp client.conf tracker:/etc/fdfs/client.conf
docker cp tracker.conf tracker:/etc/fdfs/tracker.conf

docker cp nginx.conf storage:/etc/nginx/conf/nginx.conf
docker cp client.conf storage:/etc/fdfs/client.conf
docker cp storage.conf storage:/etc/fdfs/storage.conf
```

## 通过Spring Boot使用FastDFS

### 导入Maven依赖

```xml
<dependency>
    <groupId>com.github.tobato</groupId>
    <artifactId>fastdfs-client</artifactId>
    <version>1.27.2</version>
</dependency>
```

详见作者GitHub：https://github.com/tobato/FastDFS_Client