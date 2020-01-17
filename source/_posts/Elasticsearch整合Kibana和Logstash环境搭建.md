---
title: Elasticsearch整合Kibana和Logstash环境搭建
date: 2020-01-07 11:04:28
tags:
    - Elasticsearch
    - Kibana
    - Logstash
categories:
    - Elasticsearch
    - Kibana
    - Logstash
---

### Install Elasticsearch with Docker

#### Pulling the image

```shell
docker pull docker.elastic.co/elasticsearch/elasticsearch
```

#### Starting a single node cluster with Docker

采用Docker启动一个单节点的`Elasticsearch`集群:

```shell
# -d：后台启动 -p：开放端口 --name：设置名称
docker -d run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" --name elasticsearch-monochrome docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

<!-- more -->

#### Starting a multi-node cluster with Docker Compose

通过`Docker Compose`创建一个包含3个节点的`Elasticsearch`集群 :

1. 创建一个 `docker-compose.yml` file:

   ```yaml
   version: '2.2'
   services:
     es01:
       image: docker.elastic.co/elasticsearch/elasticsearch:7.5.1
       container_name: es01
       environment:
         - node.name=es01
         - cluster.name=es-docker-cluster
         - discovery.seed_hosts=es02,es03
         - cluster.initial_master_nodes=es01,es02,es03
         - bootstrap.memory_lock=true
         - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
       ulimits:
         memlock:
           soft: -1
           hard: -1
       volumes:
         - data01:/usr/share/elasticsearch/data
       ports:
         - 9200:9200
       networks:
         - elastic
     es02:
       image: docker.elastic.co/elasticsearch/elasticsearch:7.5.1
       container_name: es02
       environment:
         - node.name=es02
         - cluster.name=es-docker-cluster
         - discovery.seed_hosts=es01,es03
         - cluster.initial_master_nodes=es01,es02,es03
         - bootstrap.memory_lock=true
         - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
       ulimits:
         memlock:
           soft: -1
           hard: -1
       volumes:
         - data02:/usr/share/elasticsearch/data
       networks:
         - elastic
     es03:
       image: docker.elastic.co/elasticsearch/elasticsearch:7.5.1
       container_name: es03
       environment:
         - node.name=es03
         - cluster.name=es-docker-cluster
         - discovery.seed_hosts=es01,es02
         - cluster.initial_master_nodes=es01,es02,es03
         - bootstrap.memory_lock=true
         - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
       ulimits:
         memlock:
           soft: -1
           hard: -1
       volumes:
         - data03:/usr/share/elasticsearch/data
       networks:
         - elastic
   
   volumes:
     data01:
       driver: local
     data02:
       driver: local
     data03:
       driver: local
   
   networks:
     elastic:
       driver: bridge
   ```

   

2. Run `docker-compose` 来启动集群:

   ```shell
   docker-compose up
   ```

### Install Kibana with Docker

#### Pulling the image

```shell
docker pull docker.elastic.co/kibana/kibana
```

#### Configuring Kibana

新建配置文件`kibana.yml`，很多默认的配置，只需要修改几个配置即可：

```yaml
# Kibana is served by a back end server. This setting specifies the port to use.
#server.port: 5601

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
# 允许远程访问
server.host: "0.0.0.0"
#server.host: "localhost"

# Enables you to specify a path to mount Kibana at if you are running behind a proxy.
# Use the `server.rewriteBasePath` setting to tell Kibana if it should remove the basePath
# from requests it receives, and to prevent a deprecation warning at startup.
# This setting cannot end in a slash.
#server.basePath: ""

# Specifies whether Kibana should rewrite requests that are prefixed with
# `server.basePath` or require that they are rewritten by your reverse proxy.
# This setting was effectively always `false` before Kibana 6.3 and will
# default to `true` starting in Kibana 7.0.
#server.rewriteBasePath: false

# The maximum payload size in bytes for incoming server requests.
#server.maxPayloadBytes: 1048576

# The Kibana server's name.  This is used for display purposes.
#server.name: "your-hostname"

# The URLs of the Elasticsearch instances to use for all your queries.
elasticsearch.hosts: ["http://localhost:9200"]

# When this setting's value is true Kibana uses the hostname specified in the server.host
# setting. When the value of this setting is false, Kibana uses the hostname of the host
# that connects to this Kibana instance.
#elasticsearch.preserveHost: true

# Kibana uses an index in Elasticsearch to store saved searches, visualizations and
# dashboards. Kibana creates a new index if the index doesn't already exist.
#kibana.index: ".kibana"

# The default application to load.
#kibana.defaultAppId: "home"

# If your Elasticsearch is protected with basic authentication, these settings provide
# the username and password that the Kibana server uses to perform maintenance on the Kibana
# index at startup. Your Kibana users still need to authenticate with Elasticsearch, which
# is proxied through the Kibana server.
#elasticsearch.username: "kibana"
#elasticsearch.password: "pass"

# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server.ssl.enabled: false
#server.ssl.certificate: /path/to/your/server.crt
#server.ssl.key: /path/to/your/server.key

# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
#elasticsearch.ssl.certificate: /path/to/your/client.crt
#elasticsearch.ssl.key: /path/to/your/client.key

# Optional setting that enables you to specify a path to the PEM file for the certificate
# authority for your Elasticsearch instance.
#elasticsearch.ssl.certificateAuthorities: [ "/path/to/your/CA.pem" ]

# To disregard the validity of SSL certificates, change this setting's value to 'none'.
#elasticsearch.ssl.verificationMode: full

# Time in milliseconds to wait for Elasticsearch to respond to pings. Defaults to the value of
# the elasticsearch.requestTimeout setting.
#elasticsearch.pingTimeout: 1500

# Time in milliseconds to wait for responses from the back end or Elasticsearch. This value
# must be a positive integer.
#elasticsearch.requestTimeout: 30000

# List of Kibana client-side headers to send to Elasticsearch. To send *no* client-side
# headers, set this value to [] (an empty list).
#elasticsearch.requestHeadersWhitelist: [ authorization ]

# Header names and values that are sent to Elasticsearch. Any custom headers cannot be overwritten
# by client-side headers, regardless of the elasticsearch.requestHeadersWhitelist configuration.
#elasticsearch.customHeaders: {}

# Time in milliseconds for Elasticsearch to wait for responses from shards. Set to 0 to disable.
#elasticsearch.shardTimeout: 30000

# Time in milliseconds to wait for Elasticsearch at Kibana startup before retrying.
#elasticsearch.startupTimeout: 5000

# Logs queries sent to Elasticsearch. Requires logging.verbose set to true.
#elasticsearch.logQueries: false

# Specifies the path where Kibana creates the process ID file.
#pid.file: /var/run/kibana.pid

# Enables you specify a file where Kibana stores log output.
#logging.dest: stdout

# Set the value of this setting to true to suppress all logging output.
#logging.silent: false

# Set the value of this setting to true to suppress all logging output other than error messages.
#logging.quiet: false

# Set the value of this setting to true to log all events, including system usage information
# and all requests.
#logging.verbose: false

# Set the interval in milliseconds to sample system and process performance
# metrics. Minimum is 100ms. Defaults to 5000.
#ops.interval: 5000

# Specifies locale to be used for all localizable strings, dates and number formats.
# Supported languages are the following: English - en , by default , Chinese - zh-CN .
# 默认语言设置为中文
i18n.locale: "zh-CN"
```

#### 编排docker-compose

新建文件`docker-compose.yml`，配置特权方式和端口，映射配置kibana.yml文件：

```yaml
version: '2'
services:
  kibana:
    image: docker.elastic.co/kibana/kibana:7.5.1
    ports:
      - "5601:5601"
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml
    privileged: true
```

#### 启动Kibana

```shell
docker-compose up -d
```

### Install Logstash with Docker and Auto-Sync Mysql data

#### Pulling the image

```shell
docker pull docker.elastic.co/logstash/logstash:7.5.1
```

#### 自定义docker镜像

1. 新建`Dockerfile`文件

2. 配置`Dockerfile`

   ```dockerfile
   FROM docker.elastic.co/logstash/logstash:7.5.1
   
   #安装input插件
   RUN logstash-plugin install logstash-input-jdbc
   
   #安装output插件
   RUN logstash-plugin install logstash-output-elasticsearch
   
   #安装json_lines插件
   RUN logstash-plugin install logstash-codec-json_lines
   
   #容器启动时执行的命令.(CMD 能够被 docker run 后面跟的命令行参数替换)
   CMD ["-f","/usr/share/logstash/config/mysql.conf"]
   ```

3. 构建镜像

   ```shell
   docker build -t my_logstash .
   ```

#### 创建配置相关的文件

1. 创建配置文件夹，所有配置文件都放在这个文件夹下面

   ```shell
   mkdir /data/logstash/config
   ```

2. **logstash.yml (空文件就行)**

3. **log4j2.properties**

   ```properties
   logger.elasticsearchoutput.name = logstash.outputs.elasticsearch
   logger.elasticsearchoutput.level = debug
   ```

4. **pipelines.yml**

   ```
   - pipeline.id: my-logstash
     path.config: "/usr/share/logstash/config/*.conf"
     pipeline.workers: 3
   ```

5. **mysql.conf**

   ```json
   input {
   	jdbc {
   		jdbc_connection_string =>
   			"jdbc:mysql://localhost:3306/<database_name>?allowMultiQueries=true&useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai&rewriteBatchedStatements=true"
           ## 数据库账号和密码
   		jdbc_user => "root"
   		jdbc_password => "root"
   		## 数据库驱动的JAR位置
   		jdbc_driver_library => "/usr/share/logstash/config/mysql-connector-java-5.1.47.jar"
   		jdbc_driver_class => "com.mysql.jdbc.Driver"
   		jdbc_paging_enabled => "true"
   		jdbc_page_size => "50000"
           ## 查询的数据，根据数据库自己定义
   		statement => "select * from tb_user"
   		## 每分钟执行一次
   		schedule => "* * * * *"
   	}
   }
   output {
   	elasticsearch {
   		## elasticsearch 地址
   		hosts => "localhost:9200"
   		## 索引名称
   		index => "index-user"
           ## 主键
   		document_id => "%{id}"
   		## 索引类型
   		document_type => "user"
   	}
   	stdout {
   		codec => json_lines
   	}
   }
   ```

6. 数据库驱动jar包

   ```shell
   wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar
   ```

#### 特权方式启动`Logstash`

```shell
docker run -d --privileged=true -p 4560:4560 -p 9600:9600 -it --name=my_logstash -v /data/logstash/config/:/usr/share/logstash/config/   my_logstash
```

查看日志：

```shell
docker logs -f -t --tail 10 my_logstash
```

