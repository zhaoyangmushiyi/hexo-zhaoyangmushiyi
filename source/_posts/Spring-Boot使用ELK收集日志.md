---
title: Spring Boot使用ELK收集日志
date: 2020-01-17 16:10:01
tags:
    - Elasticsearch
    - Spring Boot
categories:
    - Elasticsearch
    - Spring Boot
---

### ELK简介

ELK是有Elastic公司的三个组件配合进行日志收集，分别是：

- [ElasticSearch](https://www.elastic.co/cn/products/elasticsearch):用于存储日志信息。
- [Logstash](https://www.elastic.co/cn/products/elasticsearch):用于收集、处理和转发日志信息。
- [Kibana](https://www.elastic.co/cn/products/Kibana):提供可搜索的Web可视化界面。

ELK也可以配合[Beats](https://www.elastic.co/cn/products/Beats)进行使用，后续会写一篇文章来介绍。

### 环境搭建

之前文章分别介绍了ELK环境的搭建以及Spring Boot与之的整合。

- [Elasticsearch整合Kibana和Logstash环境搭建](https://zhaoyangmushiyi.github.io/2020/01/07/Elasticsearch整合Kibana和Logstash环境搭建/)
- [Spring-boot整合Elasticsearch](https://zhaoyangmushiyi.github.io/2020/01/16/Spring-boot整合Elasticsearch/)

<!-- more -->

本次教程基于上述两片教程的拓展。

### 项目修改

#### pom.xml

添加logstash采集logback日志的相关依赖

```xml
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>6.3</version>
</dependency>
```

#### Logback配置

新建文件`logback-spring.xml`，放在resource文件夹下面

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration>
<configuration>
    <include resource="org/springframework/boot/logging/logback/defaults.xml"/>
    <include resource="org/springframework/boot/logging/logback/console-appender.xml"/>
    <!--应用名称-->
    <property name="APP_NAME" value="xxxx"/>
    <!--日志文件保存路径-->
    <property name="LOG_FILE_PATH" value="${LOG_FILE:-${LOG_PATH:-${LOG_TEMP:-${java.io.tmpdir:-/tmp}}}/logs}"/>
    <contextName>${APP_NAME}</contextName>
    <!--每天记录日志到文件appender-->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_FILE_PATH}/${APP_NAME}-%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>${FILE_LOG_PATTERN}</pattern>
        </encoder>
    </appender>
    <!--输出到logstash的appender-->
    <appender name="LOGSTASH" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
        <!--可以访问的logstash日志收集端口-->
        <destination>localhost:4560</destination>
        <encoder charset="UTF-8" class="net.logstash.logback.encoder.LogstashEncoder"/>
    </appender>
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/>
        <appender-ref ref="LOGSTASH"/>
    </root>
</configuration>
```

#### Logstash配置

```json
input {
	jdbc {
		add_field => {"myid"=>"jdbc"}
		jdbc_connection_string =>
			"<mysql 地址>"
		jdbc_user => "xxxxxxxxxxxxx"
		jdbc_password => "xxxxxxxxxxxx"
		##数据库驱动的JAR位置
		jdbc_driver_library => "/usr/share/logstash/config/mysql-connector-java-5.1.47.jar"
		jdbc_driver_class => "com.mysql.jdbc.Driver"
		jdbc_paging_enabled => "true"
		jdbc_page_size => "50000"
		statement => "select id,username,realname,age,birth from tb_user"
		## 每分钟执行一次
		schedule => "* * * * *"
	}
	tcp {
		add_field => {"myid"=>"aptst-log"}
		mode => "server"
		host => "0.0.0.0"
		port => 4560
		codec => json_lines
	}
}
output {

	if [myid] == "jdbc" {
		elasticsearch {
			##elasticsearch 地址
			hosts => "<elasticsearch 地址>:9200"
			##索引名称
			index => "index-user"
			document_id => "%{id}"
			##索引类型
			document_type => "user"
		}
		stdout {
			codec => json_lines
		}
	}
	if [myid] == "aptst-log" {
		elasticsearch {
			##elasticsearch 地址
			hosts => "<elasticsearch 地址>:9200"
			##索引名称
			index => "springboot-logstash-%{+YYYY.MM.dd}"
		}
	}
	
}
```

#### Kibana管理

进入Kibana管理页面

![Spring-Boot使用ELK收集日志-1](/images/Spring-Boot使用ELK收集日志-1.png)

![Spring-Boot使用ELK收集日志-2](/images/Spring-Boot使用ELK收集日志-2.png)

创建索引模式，输入索引模式名称`springboot-logstash-*`

![Spring-Boot使用ELK收集日志-3](/images/Spring-Boot使用ELK收集日志-3.png)

选择时间筛选字段名称为`@timestamp`

![Spring-Boot使用ELK收集日志-3](/images/Spring-Boot使用ELK收集日志-3.png)