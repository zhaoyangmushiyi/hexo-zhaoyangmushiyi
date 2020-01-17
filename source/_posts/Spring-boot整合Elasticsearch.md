---
title: Spring boot整合Elasticsearch
date: 2020-01-16 16:37:31
tags:
    - Elasticsearch
    - Spring Boot
categories:
    - Elasticsearch
    - Spring Boot
---

### 环境与版本

#### Elasticsearch版本

服务端：elasticsearch 7.5.1  单节点

客户端：elasticsearch 6.8.5

#### Logstash获取MySQL数据的配置

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
	
}
```

<!-- more -->

#### Spring 版本

Spring boot:2.2.2.RELEASE

spring-boot-data-elasticsearch:3.2 对应elasticsearch的版本为6.8.5

#### 完整pom文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.2.2.RELEASE</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.monochrome</groupId>
	<artifactId>elasticsearch-test</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>elasticsearch-test</name>
	<description>Demo project for ElasticSearch</description>

	<properties>
		<java.version>1.8</java.version>
		<spring-boot-admin.version>2.2.1</spring-boot-admin.version>
		<spring-cloud.version>Hoxton.SR1</spring-cloud.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-actuator</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>de.codecentric</groupId>
			<artifactId>spring-boot-admin-starter-client</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
		</dependency>
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>5.1.47</version>
		</dependency>
		<dependency>
			<groupId>org.projectlombok</groupId>
			<artifactId>lombok</artifactId>
			<optional>true</optional>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-elasticsearch</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
			<exclusions>
				<exclusion>
					<groupId>org.junit.vintage</groupId>
					<artifactId>junit-vintage-engine</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger2</artifactId>
			<version>2.9.2</version>
		</dependency>
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger-ui</artifactId>
			<version>2.9.2</version>
		</dependency>
	</dependencies>

	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
			<dependency>
				<groupId>de.codecentric</groupId>
				<artifactId>spring-boot-admin-dependencies</artifactId>
				<version>${spring-boot-admin.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

PS：项目用到了Spring Cloud，如果不需要可以去除相关依赖。

#### Spring Boot配置文件

```yaml
spring:
  application:
    name: elasticsearch-test
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: <Mysql address>
    username: xxxxxxxxxx
    password: xxxxxxxxxx
  data:
    elasticsearch:
      cluster-name: docker-cluster
      cluster-nodes: <elasticsearch 集群地址>
  elasticsearch:
    rest:
      uris: ["<elasticsearch 地址>"]
      ipAddrs:
        - <elasticsearch 地址>
#  main:
#    allow-bean-definition-overriding: true
eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
      defaultZone: <Eureka地址>
  instance:
    instance-id: elasticsearch-test
    prefer-ip-address: true     #访问路径可以显示IP地址
#management.endpoints.web.exposure.include=* #开放所有监控端接口，可以指定开放一些
#management.endpoint.health.show-details=always
#management.endpoints.web.base-path=/monitor
#management.endpoint.shutdown.enabled=true #开启接口优雅关闭 Spring Boot 应用
server:
  port: 8091

info:
  app:
    name: elasticsearch-test
    environment: test
    version: 1.0.0

```

### 项目搭建

#### 实体类

定义一个`User`实体类以及`EsUser`实体类：

```java
@Data
@Entity(name = "tb_user")
public class User implements Serializable {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    private String username;

    private String realname;

    private Integer age;

    private Date birth;

}

@Data
@Document(indexName = "index-user", refreshInterval = "0s")
public class EsUser implements Serializable {

    @Id
    private Long id;

    private String username;

    private String realname;

    private Integer age;

    private Date birth;
}
```

#### 配置Elasticsearch Rest High Level Client

Elasticsearch(ES)有两种连接方式：transport、rest。transport通过TCP方式访问ES(只支持java),rest方式通过http API 访问ES(没有语言限制)。
ES官方建议使用rest方式, transport 在7.0版本中不建议使用，在8.X的版本中废弃。

```java
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ElasticsearchRestClientConfig extends AbstractElasticsearchConfiguration {

    private static final int ES_IP_ADDRESSES_LENGTH = 2;
    private static final String HTTP_SCHEME = "http";

    /**
     * elasticSearch 服务器地址
     */
    @Value("${spring.elasticsearch.rest.ipAddrs}")
    private List<String> ipAddresses = new ArrayList<>();

    @Bean
    public RestClientBuilder restClientBuilder() {
        HttpHost[] hosts = ipAddresses.stream()
                .map(this::makeHttpHost)
                .filter(Objects::nonNull)
                .toArray(HttpHost[]::new);
        return RestClient.builder(hosts);
    }

    private HttpHost makeHttpHost(String s) {
        assert StringUtils.isNotEmpty(s);
        String[] address = s.split(":");
        if (address.length == ES_IP_ADDRESSES_LENGTH) {
            String ip = address[0];
            int port = Integer.parseInt(address[1]);
            return new HttpHost(ip, port, HTTP_SCHEME);
        }
        return null;
    }

    @Override
    public RestHighLevelClient elasticsearchClient() {
        HttpHost[] hosts = ipAddresses.stream()
                .map(this::makeHttpHost)
                .filter(Objects::nonNull)
                .toArray(HttpHost[]::new);
        return new RestHighLevelClient(RestClient.builder(hosts));
    }
}
```

#### 使用Spring data Jpa Repository操作数据库

```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

}
```

#### 使用Spring Data Elasticsearch Repositories操作Elasticsearch

```java
public interface EsUserRepository extends ElasticsearchRepository<EsUser, Long> {
    /**
     * 查询用户名为username的用户
     * @param username
     * @return
     */
    List<EsUser> findByUsername(String username);

    /**
     * 查询用户名为username并且真实姓名为realname的用户
     * @param username
     * @param realname
     */
    List<EsUser> findByUsernameAndRealname(String username, String realname);

    /**
     * 查询用户名为username或者姓名为realname的用户
     */
    List<EsUser> findByUsernameOrRealname(String username, String realname);

    /**
     * 查询用户名不是username的所有用户
     * @param username
     * @return
     */
    List<EsUser> findByUsernameNot(String username);


    /**
     * 查询年龄段为ageFrom到ageTo的用户
     * @param ageFrom
     * @param ageTo
     * @return
     */
    List<EsUser> findByAgeBetween(Integer ageFrom, Integer ageTo);

    /**
     * 查询生日小于birthTo的用户
     */
    List<EsUser> findByBirthLessThan(LocalDateTime birthTo);


    /**
     * 查询生日段大于birthFrom的用户
     * @param birthFrom
     * @return
     */
    List<EsUser> findByBirthGreaterThan(LocalDateTime birthFrom);

    /**
     * 查询年龄小于或等于ageTo的用户
     */
    List<EsUser> findByAgeBefore(Integer ageTo);

    /**
     * 查询年龄大于或等于ageFrom的用户
     * @param ageFrom
     * @return
     */
    List<EsUser> findByAgeAfter(Integer ageFrom);

    /**
     * 用户名模糊查询
     * @param username
     * @return
     */
    List<EsUser> findByUsernameLike(String username);


    /**
     * 查询用户名以start开头的用户
     * @param start
     * @return
     */
    List<EsUser> findByUsernameStartingWith(String start);

    /**
     * 查询用户名以end结尾的用户
     * @return
     */
    List<EsUser> findByUsernameEndingWith(String end);

    /**
     * 查询用户名包含word的用户
     * @param word
     * @return
     */
    List<EsUser> findByUsernameContaining(String word);

    /**
     * 查询名字属于usernames中的用户
     * @param usernames
     * @return
     */
    List<EsUser> findByUsernameIn(Collection<String> usernames);

    /**
     * 查询名字不属于usernames中的用户
     * @param usernames
     * @return
     */
    List<EsUser> findByUsernameNotIn(Collection<String> usernames);

    /**
     *最后来个复杂点的：查询年龄小于ageTo,姓名以start开头，id大于idTo的用户，并且按照年龄倒序
     * @return
     */
    List<EsUser> findByAgeBeforeAndUsernameStartingWithAndIdGreaterThanOrderByAgeDesc(Integer ageTo, String start, Long idTo);
}
```

#### 控制层

```java
@RestController
@RequestMapping("/user")
@Slf4j
public class UserController {

    @Autowired
    private EsUserRepository esUserRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping
    public void saveUser(@RequestBody User user) {
        userRepository.save(user);
    }

    @DeleteMapping("/{id:\\d+}")
    public void removeUser(@PathVariable("id") Long id) {
        userRepository.deleteById(id);
    }

    @PostMapping("/list")
    public void saveUsers(@RequestBody List<User> users) {
        userRepository.saveAll(users);
    }

    @GetMapping("/username/{username}")
    public List<EsUser> getUserByUsername(@PathVariable String username) {
        return esUserRepository.findByUsername(username);
    }

    @GetMapping("/usernameLike/{username}")
    public List<EsUser> getUserByUsernameLike(@PathVariable String username) {
        log.info("get User By Username Like {}",username);
        return esUserRepository.findByUsernameLike(username);
    }

    @GetMapping("/ageTo/{ageTo}/name_start/{nameStart}/id/{id:\\d+}")
    public List<EsUser> getUserByAgeAndUsernameAndId(@PathVariable Integer ageTo, @PathVariable String nameStart,
                                                     @PathVariable Long id) {
        return esUserRepository.findByAgeBeforeAndUsernameStartingWithAndIdGreaterThanOrderByAgeDesc(ageTo, nameStart, id);
    }

}
```

#### Swagger配置

```java
@Configuration
@EnableSwagger2
public class Swagger2 {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.monochrome.elasticsearch"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Elasticsearch Demo RESTful APIs")
                .description("服务名：elasticsearch Demo")
                .version("1.0")
                .build();
    }

```

