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
   #指定配置文件
   docker run -d --privileged=true -p 6379:6379 -v /Users/monochrome/app/redis/redis.conf:/usr/local/etc/redis.conf --name docker-redis redis redis-server /usr/local/etc/redis.conf --appendonly yes 
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

set  key value  添加键值对

 ![截屏2021-06-26 21.53.41](/images/Redis学习/String-set.png)

*NX：当数据库中key不存在时，可以将key-value添加数据库

*XX：当数据库中key存在时，可以将key-value添加数据库，与NX参数互斥

*EX：key的超时秒数

*PX：key的超时毫秒数，与EX互斥

 

get  key 查询对应键值

append key value 将给定的value  追加到原值的末尾

strlen key 获得值的长度

setnx key value 只有在 key 不存在时  设置 key 的值

 

incr key  

将 key 中储存的数字值增1(原子操作，不会被线程调度机制打断)

只能对数字值操作，如果为空，新增值为1

decr key 

将 key 中储存的数字值减1

只能对数字值操作，如果为空，新增值为-1

incrby / decrby key 步长 将 key 中储存的数字值增减。自定义步长。

<img src="/images/Redis学习/String-命令1.png" alt="String-命令1.png" style="zoom:50%;" />

mset key1 value1 key2 value2  ..... 

同时设置一个或多个 key-value对 

mget key1 key2 key3  .....

同时获取一个或多个 value 

msetnx key1 value1 key2 value2  ..... 

同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。**原子性，有一个失败则都失败**

 

getrange key 起始位置 结束位置 

获得值的范围，类似java中的substring，**前包，后包**

setrange key 起始位置 value 

用 value  覆写key 所储存的字符串值，从起始位置 开始(**索引从0开始**)。

 

setex key 过期时间 value 

设置键值的同时，设置过期时间，单位秒。

getset key value 

以新换旧，设置了新值同时获得旧值。

<img src="/images/Redis学习/String-命令2.png" alt="String-命令2.png" style="zoom:50%;" />

### **数据结构**

String的数据结构为简单动态字符串(Simple Dynamic String,缩写SDS)。是可以修改的字符串，内部结构实现上类似于Java的ArrayList，采用预分配冗余空间的方式来减少内存的频繁分配.

![image-20210626220837603](/images/Redis学习/String-数据结构.png)

如图中所示，内部为当前字符串实际分配的空间capacity一般要高于实际字符串长度len。当字符串长度小于1M时，扩容都是加倍现有的空间，如果超过1M，扩容时一次只会多扩1M的空间。需要注意的是字符串最大长度为512M。

## **Redis列表(List)**

### **简介**

单键多值

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

它的底层实际是个双向链表，对两端的操作性能很高，通过索引下标的操作中间的节点性能会较差。

![List-双向链表](/images/Redis学习/List-双向链表.png)

### **常用命令**

lpush/rpush  key value1 value2 value3 .... 从左边/右边插入一个或多个值。

lpop/rpop  key从左边/右边吐出一个值。值在键在，值光键亡。

 

rpoplpush  key1 key2 从key1列表右边吐出一个值，插到 key2列表左边。

 

lrange key start stop 按照索引下标获得元素(从左到右)

lrange mylist 0 -1  0左边第一个，-1右边第一个，（0 -1表示获取所有）

lindex  key index 按照索引下标获得元素(从左到右)

llen key 获得列表长度 

 

linsert  key before/after  value newvalue 在 value的后面插入newvalue插入值

lrem key n value 从左边删除n个value(从左到右)

lset key index value 将列表key下标为index的值替换成value

 ![List-命令](/images/Redis学习/List-命令.png)

**数据结构**

List的数据结构为快速链表quickList。

首先在列表元素较少的情况下会使用一块连续的内存存储，这个结构是ziplist，也即是压缩列表。

它将所有的元素紧挨着一起存储，分配的是一块连续的内存。

当数据量比较多的时候才会改成quicklist。

因为普通的链表需要的附加指针空间太大，会比较浪费空间。比如这个列表里存的只是int类型的数据，结构上还需要两个额外的指针prev和next。

![List-quicklist](/images/Redis学习/List-quicklist.png)

Redis将链表和ziplist结合起来组成了quicklist。也就是将多个ziplist使用双向指针串起来使用。这样既满足了快速的插入删除性能，又不会出现太大的空间冗余。

## **Redis集合(Set)**

### **简介**

Redis set对外提供的功能与list类似是一个列表的功能，特殊之处在于set是可以**自动排重**的，当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择，并且set提供了判断某个成员是否在一个set集合内的重要接口，这个也是list所不能提供的。

Redis的Set是string类型的无序集合。它底层其实是一个value为null的hash表，所以添加，删除，查找的**复杂度都是****O(1)**。

一个算法，随着数据的增加，执行时间的长短，如果是O(1)，数据增加，查找数据的时间不变

### **常用命令**

sadd key value1 value2  ..... 

将一个或多个 member 元素加入到集合 key 中，已经存在的 member 元素将被忽略

smembers key 取出该集合的所有值。

sismember key value 判断集合key 是否为含有该value 值，有1，没有0

scard key 返回该集合的元素个数。

srem key value1 value2  .... 删除集合中的某个元素。

spop key **随机从该集合中吐出一个值。**

srandmember key n 随机从该集合中取出n个值。不会从集合中删除 。

smove source destination value 把集合中一个值从一个集合移动到另一个集合

sinter key1 key2 返回两个集合的交集元素。

sunion key1 key2 返回两个集合的并集元素。

sdiff key1 key2 返回两个集合的**差集**元素(key1中的，不包含key2中的)

![Set-命令](/images/Redis学习/Set-命令.png)

### **数据结构**

Set数据结构是dict字典，字典是用哈希表实现的。

Java中HashSet的内部实现使用的是HashMap，只不过所有的value都指向同一个对象。Redis的set结构也是一样，它的内部也使用hash结构，所有的value都指向同一个内部值。

## **Redis哈希(Hash)**

### **简介**

Redis hash 是一个键值对集合。

Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。

类似Java里面的Map<String,Object>

用户ID为查找的key，存储的value用户对象包含姓名，年龄，生日等信息，如果用普通的key/value结构来存储

主要有以下2种存储方，然后衍生出我们Hash的存储方式：

1. 第一种

   ![image-20210627211632603](/images/Redis学习/Hash-store1-1.png)  

   每次修改用户的某个属性需要，先反序列化改好后再序列化回去。开销较大。

2. 第二种

   ![image-20210627211728406](/images/Redis学习/Hash-store1-2.png)

   用户ID数据冗余

3. 第三种，Hash

   ![image-20210627212109516](/images/Redis学习/Hash-store2.png)

   通过 `key(用户ID)` + `field(属性标签)`就可以操作对应属性数据了，既不需要重复存储数据，也不会带来序列化和并发修改控制的问题  

### **常用命令** 

hset key field value 给key 集合中的 field 键赋值value 

hget key field 从key集合field取出value 

hmset key field1 value1 field2 value2 ... 批量设置hash的值

hexists key field 查看哈希表 key 中，给定域 field 是否存在。 

hkeys key 列出该hash集合的所有field

hvals key 列出该hash集合的所有value

hincrby key field increment 为哈希表 key 中的域 field 的值加上增量 1  -1

hsetnx key field value 将哈希表 key 中的域 field 的值设置为 value ，当且仅当域 field 不存在 .

hgetall key 获取该hash集合的所有field以及value

![Hash-命令](/images/Redis学习/Hash-命令.png)

### **数据结构**

Hash类型对应的数据结构是两种：ziplist（压缩列表），hashtable（哈希表）。当field-value长度较短且个数较少时，使用ziplist，否则使用hashtable。

## **Redis有序集合Zset(sorted set)** 

### **简介**

Redis有序集合zset与普通集合set非常相似，是一个**没有重复元素**的字符串集合。

不同之处是有序集合的每个成员都关联了一个**评分（score）**,这个评分（score）被用来按照从最低分到最高分的方式排序集合中的成员。**集合的成员是唯一的，但是评分可以是重复了 。**

因为元素是有序的, 所以你也可以很快的根据评分（score）或者次序（position）来获取一个范围的元素。

访问有序集合的中间元素也是非常快的,因此你能够使用有序集合作为一个没有重复成员的智能列表。

### **常用命令**

zadd key score1 value1 score2 value2 …

将一个或多个 member 元素及其 score 值加入到有序集 key 当中。

**zrange key start stop  [WITHSCORES]**  

返回有序集 key 中，下标在start stop之间的元素，带WITHSCORES，可以让分数一起和值返回到结果集。

zrangebyscore key minmax [withscores] [limit offset count]

返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列。 

zrevrangebyscore key maxmin [withscores] [limit offset count]        

同上，改为从大到小排列。 

zincrby key increment value    为元素的score加上增量

zrem key value 删除该集合下，指定值的元素

zcount key min max 统计该集合，分数区间内的元素个数 

zrank key value 返回该值在集合中的排名，从0开始。

![截屏2021-06-28 15.23.53](/images/Redis学习/Zset-命令.png)

案例：如何利用zset实现一个文章访问量的排行榜？

### **数据结构**

SortedSet(zset)是Redis提供的一个非常特别的数据结构，一方面它等价于Java的数据结构Map<String, Double>，可以给每一个元素value赋予一个权重score，另一方面它又类似于TreeSet，内部的元素会按照权重score进行排序，可以得到每个元素的名次，还可以通过score的范围来获取元素的列表。

zset底层使用了两个数据结构

（1）hash，hash的作用就是关联元素value和权重score，保障元素value的唯一性，可以通过元素value找到相应的score值。

（2）跳跃表，跳跃表的目的在于给元素value排序，根据score的范围获取元素列表。

### **跳跃表（跳表）**

#### 简介

  有序集合在生活中比较常见，例如根据成绩对学生排名，根据得分对玩家排名等。对于有序集合的底层实现，可以用数组、平衡树、链表等。数组不便元素的插入、删除；平衡树或红黑树虽然效率高但结构复杂；链表查询需要遍历所有效率低。Redis采用的是跳跃表。跳跃表效率堪比红黑树，实现远比红黑树简单。

#### 实例

  对比有序链表和跳跃表，从链表中查询出51

（1） 有序链表

![Zset-有序链表](/images/Redis学习/Zset-有序链表.png)                               

要查找值为51的元素，需要从第一个元素开始依次查找、比较才能找到。共需要6次比较。

（2） 跳跃表

 ![Zset-跳跃表](/images/Redis学习/Zset-跳跃表.png)

从第2层开始，1节点比51节点小，向后比较。

21节点比51节点小，继续向后比较，后面就是NULL了，所以从21节点向下到第1层

在第1层，41节点比51节点小，继续向后，61节点比51节点大，所以从41向下

在第0层，51节点为要查找的节点，节点被找到，共查找4次。

 

从此可以看出跳跃表比有序链表效率要高

# **Redis的发布和订阅**

## **什么是发布和订阅**

Redis 发布订阅 (pub/sub) 是一种消息通信模式：发送者 (pub) 发送消息，订阅者 (sub) 接收消息。

Redis 客户端可以订阅任意数量的频道。

##  **Redis的发布和订阅**

**发布订阅命令行实现**

1、 打开一个客户端订阅channel1

```shell
subscribe channel1
```

![Redis发布和订阅-订阅channel1](/images/Redis学习/Redis发布和订阅-订阅channel1.png)     

2、打开另一个客户端，给channel1发布消息hello

```shell
publish channel1 hello
```

 ![Redis发布和订阅-给channel1发布消息](/images/Redis学习/Redis发布和订阅-给channel1发布消息.png)

返回的1是订阅者数量

3、打开第一个客户端可以看到发送的消息

![Redis发布和订阅-从channel1接收消息](/images/Redis学习/Redis发布和订阅-从channel1接收消息.png)

注：发布的消息没有持久化，如果在订阅的客户端收不到hello，只能收到订阅后发布的消息

# **Redis与Spring Boot整合**

## 导入依赖

```xml
        <!--Redis-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <!-- spring2.X集成redis所需common-pool2-->
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-pool2</artifactId>
            <version>2.6.0</version>
        </dependency>
```

## application.yml配置Redis配置

```yaml
spring:
	redis:
    host: 127.0.0.1 #Redis服务器地址
    port: 6379 #Redis服务器连接端口
    database: 0 #Redis数据库索引（默认为0）
    timeout: 18000000 #连接超时时间（毫秒）
    lettuce:
      pool:
        max-active: 20 #连接池最大连接数（使用负值表示没有限制）
        max-wait: -1 #最大阻塞等待时间(负数表示没限制)
        max-idle: 5 #连接池中的最大空闲连接
        min-idle: 0 #连接池中的最小空闲连接
```

## 添加redis配置类

```java
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsontype.impl.LaissezFaireSubTypeValidator;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;

@Configuration
@EnableCaching
public class RedisConfig {
    @Bean
    @ConditionalOnMissingBean(name = "redisTemplate")//我们可以自定义一个RedisTemplate来替换默认的
    public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate<Object, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(redisConnectionFactory);

        Jackson2JsonRedisSerializer serializer = new Jackson2JsonRedisSerializer(Object.class);

        ObjectMapper mapper = new ObjectMapper();
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        mapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL, JsonTypeInfo.As.PROPERTY);
        serializer.setObjectMapper(mapper);

        // 使用StringRedisSerializer来序列化和反序列化redis的key值
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(serializer);

        // Hash的key也采用StringRedisSerializer的序列化方式
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(serializer);

        template.afterPropertiesSet();
        return template;
    }

    @Bean
    @ConditionalOnMissingBean//由于String是redis中最常使用的类型，所以单独提出了一个bean!
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
        StringRedisTemplate template = new StringRedisTemplate();
        template.setConnectionFactory(redisConnectionFactory);
        return template;
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory factory) {
        RedisSerializer<String> redisSerializer = new StringRedisSerializer();
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        //解决查询缓存转换异常的问题
        ObjectMapper mapper = new ObjectMapper();
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        mapper.activateDefaultTyping(LaissezFaireSubTypeValidator.instance, ObjectMapper.DefaultTyping.NON_FINAL, JsonTypeInfo.As.PROPERTY);
        jackson2JsonRedisSerializer.setObjectMapper(mapper);
        // 配置序列化（解决乱码的问题）,过期时间600秒
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(600))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(redisSerializer))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(jackson2JsonRedisSerializer))
                .disableCachingNullValues();
        RedisCacheManager cacheManager = RedisCacheManager.builder(factory)
                .cacheDefaults(config)
                .build();
        return cacheManager;
    }

}

```

## **完成一个手机验证码功能**

要求：

1. 输入手机号，点击发送后随机生成6位数字码，30分钟有效

   用Random类

2. 输入验证码，点击验证，返回成功或失败

   把验证码放到Redis里面，设置过期时间为30分钟

3. 每个手机号每天只能输入3次

   把发送验证码的数量也放到Redis里面，设置过期时间为1天

   incr每次发送后+1

   大于2(也就是已经发送3次后)不能再发送

```java

    public String getVerificationCode(String phone) {
        String verifyCodeCountKey = "verifyCode" + phone + ":count";
        String verifyCodeKey = "verifyCode" + phone + ":code";
        String count = redisTemplate.opsForValue().get(verifyCodeCountKey);
        if (count == null) {
            redisTemplate.opsForValue().set(verifyCodeCountKey, "1", 1, TimeUnit.DAYS);
        } else if (Integer.parseInt(count) <= 2) {
            redisTemplate.opsForValue().increment(verifyCodeCountKey);
        } else {
            return "今天输入次数已超过3次！";
        }
        String verificationCode = getRandomVerificationCode();
        log.info(verifyCodeKey + "------" + verificationCode);
        redisTemplate.opsForValue().set(verifyCodeKey, verificationCode, 30, TimeUnit.MINUTES);
        return "验证码已发送到手机，请尽快输入，验证码将于30分钟后失效！";
    }

    @Override
    public String verifyPhoneAndVerificationCode(String phone, String verificationCode) {

        String verifyCodeKey = "verifyCode" + phone + ":code";
        String verifyCodeKeyByRedis = redisTemplate.opsForValue().get(verifyCodeKey);
        if (verificationCode.equals(verifyCodeKeyByRedis)) {
            return "验证成功";
        }
        return "验证失败！";
    }

    private String getRandomVerificationCode() {
        StringBuilder verificationCode = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            verificationCode.append(new Random().nextInt(10));
        }
        return verificationCode.toString();
    }
```

# **Redis_事务_锁机制_秒杀**

## **Redis的事务定义**

Redis事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。

Redis事务的主要作用就是**串联多个命令**防止别的命令插队。

## **Multi**、**Exec**、**discard**

从输入Multi命令开始，输入的命令都会依次进入命令队列中，但不会执行，直到输入Exec后，Redis会将之前的命令队列中的命令依次执行。

组队的过程中可以通过discard来放弃组队。 

![事务-正常](/images/Redis学习/事务-正常.png)

## **事务的错误处理**

组队中某个命令出现了报告错误，执行时整个的所有队列都会被取消。

![事务-组队时错误](/images/Redis学习/事务-组队时错误.png)

如果执行阶段某个命令报出了错误，则只有报错的命令不会被执行，而其他的命令都会执行，不会回滚。

![事务-执行时出错](/images/Redis学习/事务-执行时出错.png)

### **WATCH** **key** **[key ...]**

在执行multi之前，先执行watch key1 [key2],可以监视一个(或多个) key ，如果在事务**执行之前这个(或这些) key被其他命令所改动，那么事务将被打断。**                              

### **unwatch**

取消 WATCH 命令对所有 key 的监视。

如果在执行 WATCH 命令之后，EXEC 命令或DISCARD 命令先被执行了的话，那么就不需要再执行UNWATCH 了。

# **Redis持久化**              

Redis 提供了2个不同形式的持久化方式。

- RDB（Redis DataBase）
- AOF（Append Of File）

## **RDB(Redis DataBase)**

在指定的**时间间隔**内将内存中的数据集**快照**写入磁盘， 也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里。

### 备份是如何执行的

Redis会单独创建（fork）一个子进程来进行持久化，会**先**将数据**写**入到 一个**临时文件**中，待持久化过程都结束了，再用这个**临时文件替换**上次持久化好的文件。 整个过程中，主进程是不进行任何IO操作的，这就确保了极高的性能 如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。RDB的缺点是**最后一次持久化后的数据可能丢失**。

### Fork

- Fork的作用是复制一个与当前进程一样的进程。新进程的所有数据（变量、环境变量、程序计数器等） 数值都和原进程一致，但是是一个全新的进程，并作为**原进程的子进程**
- 在Linux程序中，fork()会产生一个和父进程完全相同的子进程，但子进程在此后多会exec系统调用，出于效率考虑，Linux中引入了“**写时复制技术**”
- 一般情况父进程和子进程会共用同一段物理内存，只有进程空间的各段的内容要发生变化时，才会将父进程的内容复制一份给子进程。

### RDB持久化流程

![RDB持久化流程](/images/Redis学习/RDB持久化流程.png)

### **如何触发RDB快照；保持策略**

#### **配置文件中默认的快照配置**

![默认快照配置](/images/Redis学习/默认快照配置.png)

#### 命令save VS bgsave

save ：save时只管保存，其它不管，全部阻塞。手动保存。不建议。
bgsave：Redis会在后台异步进行快照操作， 快照同时还可以响应客户端请求。
可以通过 lastsave 命令获取最后一次成功执行快照的时间

#### flushall命令

执行flushall命令，也会产生dump.rdb文件，但里面是空的，无意义

#### ###SNAPSHOTTING快照###

#### save

格式：save 秒钟 写操作次数

RDB是整个内存的压缩过的Snapshot，RDB的数据结构，可以配置复合的快照触发条件，默认是1分钟内改了1万次，或5分钟内改了10次，或15分钟内改了1次。

禁用：不设置save指令，或者给save传入空字符串

#### stop-writes-on-bgsave-error

当Redis无法写入磁盘的话，直接关掉Redis的写操作。推荐yes.

#### rdbcompression 压缩文件

对于存储到磁盘中的快照，可以设置是否进行压缩存储。如果是的话，redis会采用LZF算法进行压缩。
如果你不想消耗CPU来进行压缩的话，可以设置为关闭此功能。推荐yes.

#### rdbchecksum 检查完整性

在存储快照后，还可以让redis使用CRC64算法来进行数据校验，但是这样做会增加大约10%的性能消耗，如果希望获取到最大的性能提升，可以关闭此功能。推荐yes.

#### rdb的备份

- 先通过config get dir  查询rdb文件的目录 
- 将*.rdb的文件拷贝到别的地方

#### rdb的恢复

- 关闭Redis
- 先把备份的文件拷贝到工作目录下 cp dump2.rdb dump.rdb
- 启动Redis, 备份数据会直接加载

#### 优势

- 适合大规模的数据恢复
- 对数据完整性和一致性要求不高更适合使用
- 节省磁盘空间
- 恢复速度快

#### 劣势

- Fork的时候，内存中的数据被克隆了一份，大致2倍的膨胀性需要考虑
- 虽然Redis在fork时使用了写时拷贝技术,但是如果数据庞大时还是比较消耗性能
- 在备份周期在一定间隔时间做一次备份，所以如果Redis意外down掉的话，就会丢失最后一次快照后的所有修改

#### 如何停止

动态停止RDB：redis-cli config set save ""   #save后给空值，表示禁用保存策略

#### 小总结

![RDB-小总结](/images/Redis学习/RDB-小总结.png)

### **AOF(Append Only File)**

以日志的形式来记录每个写操作（增量保存），将Redis执行过的所有写指令记录下来(读操作不记录)， 只许追加文件但不可以改写文件，redis启动之初会读取该文件重新构建数据，换言之，redis 重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作

#### AOF持久化流程

1. 客户端的请求写命令会被append追加到AOF缓冲区内；
2. AOF缓冲区根据AOF持久化策略[always,everysec,no]将操作sync同步到磁盘的AOF文件中；
3. AOF文件大小超过重写策略或手动重写时，会对AOF文件rewrite重写，压缩AOF文件容量；
4. Redis服务重启时，会重新load加载AOF文件中的写操作达到数据恢复的目的；

#### AOF默认不开启

可以在redis.conf中配置文件名称，默认为 appendonly.aof
AOF文件的保存路径，同RDB的路径一致。

#### AOF和RDB同时开启，redis听谁的？

AOF和RDB同时开启，系统默认取AOF的数据（数据不会存在丢失）

#### AOF启动/修复/恢复

AOF的备份机制和性能虽然和RDB不同, 但是备份和恢复的操作同RDB一样，都是拷贝备份文件，需要恢复时再拷贝到Redis工作目录下，启动系统即加载。

正常恢复

- 修改默认的appendonly no，改为yes
- 将有数据的aof文件复制一份保存到对应目录(查看目录：config get dir)
- 恢复：重启redis然后重新加载

异常恢复

- 修改默认的appendonly no，改为yes
- 如遇到AOF文件损坏，通过/usr/local/bin/redis-check-aof--fix appendonly.aof进行恢复
- 备份被写坏的AOF文件
- 恢复：重启redis，然后重新加载

#### AOF同步频率设置

appendfsync always 始终同步，每次Redis的写入都会立刻记入日志；性能较差但数据完整性比较好
appendfsync everysec 每秒同步，每秒记入日志一次，如果宕机，本秒的数据可能丢失。
appendfsync no redis不主动进行同步，把同步时机交给操作系统。

#### Rewrite压缩

1.是什么：

AOF采用文件追加方式，文件会越来越大为避免出现此种情况，新增了重写机制, 当AOF文件的大小超过所设定的阈值时，Redis就会启动AOF文件的内容压缩， 只保留可以恢复数据的最小指令集.可以使用命令bgrewriteaof

2.重写原理，如何实现重写
AOF文件持续增长而过大时，会fork出一条新进程来将文件重写(也是先写临时文件最后再rename)，redis4.0版本后的重写，是指上就是把rdb 的快照，以二级制的形式附在新的aof头部，作为已有的历史数据，替换掉原来的流水账操作。
no-appendfsync-on-rewrite：
如果 no-appendfsync-on-rewrite=yes ,不写入aof文件只写入缓存，用户请求不会阻塞，但是在这段时间如果宕机会丢失这段时间的缓存数据。（降低数据安全性，提高性能）
	如果 no-appendfsync-on-rewrite=no,  还是会把数据往磁盘里刷，但是遇到重写操作，可能会发生阻塞。（数据安全，但是性能降低）
触发机制，何时重写
Redis会记录上次重写时的AOF大小，默认配置是当AOF文件大小是上次rewrite后大小的一倍且文件大于64M时触发
重写虽然可以节约大量磁盘空间，减少恢复时间。但是每次重写还是有一定的负担的，因此设定Redis要满足一定条件才会进行重写。 
auto-aof-rewrite-percentage：设置重写的基准值，文件达到100%时开始重写（文件是原来重写后文件的2倍时触发）
auto-aof-rewrite-min-size：设置重写的基准值，最小文件64MB。达到这个值开始重写。
例如：文件达到70MB开始重写，降到50MB，下次什么时候开始重写？100MB
系统载入时或者上次重写完毕时，Redis会记录此时AOF大小，设为base_size,
如果Redis的AOF当前大小>= base_size +base_size*100% (默认)且当前大小>=64mb(默认)的情况下，Redis会对AOF进行重写。 

3、重写流程
（1）bgrewriteaof触发重写，判断是否当前有bgsave或bgrewriteaof在运行，如果有，则等待该命令结束后再继续执行。
（2）主进程fork出子进程执行重写操作，保证主进程不会阻塞。
（3）子进程遍历redis内存中数据到临时文件，客户端的写请求同时写入aof_buf缓冲区和aof_rewrite_buf重写缓冲区保证原AOF文件完整以及新AOF文件生成期间的新的数据修改动作不会丢失。
（4）1).子进程写完新的AOF文件后，向主进程发信号，父进程更新统计信息。2).主进程把aof_rewrite_buf中的数据写入到新的AOF文件。
（5）使用新的AOF文件覆盖旧的AOF文件，完成AOF重写。

<img src="/images/Redis学习/AOF-重写流程.png" alt="AOF-重写流程" style="zoom:50%;" />

#### 优势

- 备份机制更稳健，丢失数据概率更低。
- 可读的日志文本，通过操作AOF稳健，可以处理误操作。

#### 劣势

- 比起RDB占用更多的磁盘空间。
- 恢复备份速度要慢。
- 每次读写都同步的话，有一定的性能压力。
- 存在个别Bug，造成恢复不能。

#### 小总结

![AOF-小总结](/images/Redis学习/AOF-小总结.png)

#### 用哪个好

官方推荐两个都启用。
如果对数据不敏感，可以选单独用RDB。
不建议单独用 AOF，因为可能会出现Bug。
如果只是做纯内存缓存，可以都不用。

#### **官网建议**                

- RDB持久化方式能够在指定的时间间隔能对你的数据进行快照存储
- AOF持久化方式记录每次对服务器写的操作,当服务器重启的时候会重新执行这些命令来恢复原始的数据,AOF命令以redis协议追加保存每次写的操作到文件末尾. 
- Redis还能对AOF文件进行后台重写,使得AOF文件的体积不至于过大
- 只做缓存：如果你只希望你的数据在服务器运行的时候存在,你也可以不使用任何持久化方式.

同时开启两种持久化方式

- 在这种情况下,当redis重启的时候会优先载入AOF文件来恢复原始的数据, 因为在通常情况下AOF文件保存的数据集要比RDB文件保存的数据集要完整.

RDB的数据不实时，同时使用两者时服务器重启也只会找AOF文件。那要不要只使用AOF呢？ 

- 建议不要，因为RDB更适合用于备份数据库(AOF在不断变化不好备份)， 快速重启，而且不会有AOF可能潜在的bug，留着作为一个万一的手段。

l 性能建议

> 因为RDB文件只用作后备用途，建议只在**Slave上持久化RDB文件**，而且只要15分钟备份一次就够了，只保留save 900 1这条规则。     如果使用AOF，好处是在最恶劣情况下也只会丢失不超过两秒数据，启动脚本较简单只load自己的AOF文件就可以了。  代价,一是带来了持续的IO，二是AOF rewrite的最后将rewrite过程中产生的新数据写到新文件造成的阻塞几乎是不可避免的。  只要硬盘许可，应该尽量减少AOF  rewrite的频率，AOF重写的基础大小默认值64M太小了，可以设到5G以上。  默认超过原大小100%大小时重写可以改到适当的数值。  

