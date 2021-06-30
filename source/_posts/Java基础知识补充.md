---
title: Java基础知识补充
date: 2021-04-12 11:42:07
tags:
    - Java
categories:
    - Java
---

# JavaSE

## 1.自增变量

```java
 public static void main(String[] args) {
        int i = 1;
        i = i++;
        int j = i++;
        int k = i + ++i * i++;
        System.out.println("i=" + i);
        System.out.println("j=" + j);
        System.out.println("k=" + k);
}
//输出：
//i=4
//j=1
//k=11
    
```

<!-- more -->

## 2、单例模式

### 什么是Singleton?

Singleton:在Java中 即指单例设置模式，探视软件开发最常用的设置模式之一

单：唯一

例：实例

单例设计模式，即某个类在整个系统中只能有一个实例对象可被获取和使用的代码模式

例如：代表JVM运行环境的Runtime类

### 要点：

一是某个类只能有一个实例

- 构造器私有化

二是他必须自行创建实例

-  含有一个该类的静态变量来保存这个唯一的实例

三是它必须自行向整个系统提供这个实例

对外提供获取该类实例对象的方式

- 直接暴露
- 用静态变量的get方法获取

### 几种常见形式

饿汉式：直接创建对象，不存在线程安全问题

-  直接实例化饿汉式(简洁直观)
-  枚举式 (最简洁)
- 静态代码块饿汉式(适合复杂实例化)

懒汉式;延迟创建对象

- 线程不安全(使用于单线程)
- 线程安全(使用于多线程)

- 静态内部类模式 (适用于多线程)

## 3、类初始化实例初始化

### 类初始化

> 一个类要创建实例需要先加载并初始化该类
>
> main方法所在的类需要先加载和初始化
>
> 一个子类要初始化需要先初始化父类
>
> 一个类初始化就是执行 clinit 方法
>
> clinit 方法由静态类变量显示赋值代码和静态代码块组成
>
> 类变量显示赋值代码和静态代码块代码从上到下执行
>
> clinit 方法只调用一次

### 实例初始化过程

> 实例初始化就是执行 init() 方法
>
> init () 方法可能重载有多个，有几个构造器就有几个 init() 方法
>
> init() 方法由非静态实例变量显示赋值代码和非静态代码块，对应构造器代码组成
>
> 非静态实例变量显示赋值代码和非静态代码块从上到下顺序执行，而对应构造器的代码最后执行
>
> 每次创建实例对象，调用对应构造器，执行的就是对应的 ini方法
>
> init 方法的首行是super()和super(实参列表) ,即对应父类的 init 方法

### Father.java

```java
/**
 * 父类初始化<clinit>
 * 1、j = method()
 * 2、 父类的静态代码块
 *
 * 父类实例化方法:
 * 1、super()（最前）
 * 2、i = test() (9)
 * 3、子类的非静态代码块 (3)
 * 4、子类的无参构造（最后）(2)
 *
 *
 * 非静态方法前面其实有一个默认的对象this
 * this在构造器或<init> 他表示的是正在创建的对象，因为咱们这里是正在创建Son对象，所以
 * test()执行的就是子类重写的代码(面向对象多态)
 *
 * 这里i=test() 执行的就是子类重写的test()方法
 * @author Monochrome
 * @date 2021-04-14
 */
public class Father {
    private int i = test();
    private static int j = method();

    static{
        System.out.println("(1)");
    }
    Father() {
        System.out.println("(2)");
    }
    {
        System.out.println("(3)");
    }
    public int test(){
        System.out.println("(4)");
        return 1;
    }
    public static int method() {
        System.out.println("(5)");
        return 1;
    }
}
```

### Son.java

```java
/**
 * 子类的初始化<clinit>
 * 1、j = method()
 * 2、子类的静态代码块
 *
 * 先初始化父类 (5)(1)
 * 初始化子类 (10) (6)
 *
 * 子类实例化方法:
 * 1、super()（最前
 * 2、i = test() (9)
 * 3、子类的非静态代码块 (8)
 * 4、子类的无参构造（最后）(7)
 * @author Monochrome
 * @date 2021-04-14
 */
public class Son extends Father {
    private int i = test();
    private static int j = method();
    static {
        System.out.println("(6)");
    }
    Son() {
        super();
        System.out.println("(7)");
    }
    {
        System.out.println("(8)");
    }
    public int test(){
        System.out.println("(9)");
        return 1;
    }
    public static int method() {
        System.out.println("(10)");
        return 1;
    }

    public static void main(String[] args) {
        Son son = new Son();
        System.out.println();
        Son son1 = new Son();
        // out:
        // (5)(1)(10)(6)(9)(3)(2)(9)(8)(7)
        // (9)(3)(2)(9)(8)(7)
    }
}
```

## 4、方法参数传递机制

```java
import java.util.Arrays;

/**
 *
 * @author Monochrome
 * @date 2021-04-14
 */
public class Exam4 {
    public static void main(String[] args) {
        int i = 1;
        String str = "hello";
        Integer num = 200;
        int[] arr = {1,2,3,4,5};
        MyData my = new MyData();

        change(i,str,num,arr,my);

        System.out.println("i= " + i);
        System.out.println("str= " + str);
        System.out.println("num= " + num);
        System.out.println("arr= " + Arrays.toString(arr));
        System.out.println("my.a= " + my.a);
    }
    public static void change(int j, String s, Integer n, int[] a, MyData m) {
        j += 1;
        s += "world";
        n += 1;
        a[0] += 1;
        m.a += 1;
    }
}
class MyData {
    int a = 10;
}

// out:
// i= 1
// str= hello
// num= 111
// arr= [2, 2, 3, 4, 5]
// my.a= 11
```

### 总结

1、形参是基本数据类型

- 传递数据值

2、实参是引用数据类型

- 传递地址值

 特殊的类型：String、包装类等对象的不可变性

## 5、递归与迭代

```java
/**
 * 编程题: 有n步台阶，一次只能上1步或2步，共有多少种走法?
 * @author Monochrome
 * @date 2021/4/15
 */
public class TestStep {

    public static void main(String[] args) {
        System.out.println(f(20));
        System.out.println(loop(20));

    }

    public static int f(int n) {
        if (n == 1) {
            return 1;
        }
        if (n == 2) {
            return 2;
        }

        return f(n - 2) + f(n - 1);
    }

    public static int loop(int n) {
        if (n == 1) {
            return 1;
        }
        if (n == 2) {
            return 2;
        }

        int oneStep = 2;
        int twoStep = 1;
        int sum = 0;
        for (int i = 3; i <= n; i++) {
            sum = oneStep + twoStep;
            twoStep = oneStep;
            oneStep = sum;
        }
        return sum;
    }

}
```

# SSM面试题

## Spring中支持的常用数据库事务传播属性和事务隔离级别

###  事务的传播行为

当事务方法被另一个事务方法调用时，必须指定事务应该如何传播，列如方法可能继续在现有事务中运行，也可能开启一个新事务，并在自己的事务中运行，事务传播的行为有传播属性指定，Spring定义了7中类传播行为

| 传播属性 | 描述 |
| ---- | ---- |
| REQUIRED | 如果有事务在运行，当前的方法就在这个事务内运行，否则就启动一个新的事务，并在自己的事务内运行 |
| REQUIRED_NEW | 当前方法必须启动事务，并在它自己的事务内运行，如果有事务正在运行，应该将他挂起 |
| SUPPORTS | 如果有事务在运行，当前的方法就在这个事务内运行，否则他可以不运行在事务中 |
| NOT_SUPPORTE | 当前的方法不应该运行在事务中，如果有运行的事务，将他挂起 |
| MANDATORY | 当前的方法必须运行在事务内部，如果没有正在运行的事务，就抛出异常 |
| NEVER | 当前方法不应该运行在事务中，如果有运行的事务，就抛出异常 |
| NESTED | 如果有事务在运行，当前的方法就应该在这个事物的嵌套事务内运行，否则，就启动一个新的事务，并在它自己的事务内运行 |

事务传播属性可以在@Transactional注解的propagation属性中定义

### 事务隔离级别

#### 数据库事务并发问题

 假设现在有两个事务：Transaction01和Transaction02并发执行。

##### 1) 脏读

 ①Transaction01将某条记录的AGE值从20修改为30。

 ②Transaction02读取了Transaction01更新后的值：30。

 ③Transaction01回滚，AGE值恢复到了20。

 ④Transaction02读取到的30就是一个无效的值。

##### 2) 不可重复读

 ①Transaction01读取了AGE值为20。

 ②Transaction02将AGE值修改为30。

 ③Transaction01再次读取AGE值为30，和第一次读取不一致。

##### 3) 幻读

 ①Transaction01读取了STUDENT表中的一部分数据。

 ②Transaction02向STUDENT表中插入了新的行。

 ③Transaction01读取了STUDENT表时，多出了一些行。

#### 隔离级别

数据库系统必须具有隔离并发运行各个事务的能力，使它们不会相互影响，避免各种并发问题。一个事务与其他事务隔离的程度称为隔离级别。SQL标准中规定了多种事务隔离级别，不同隔离级别对应不同的干扰程度，隔离级别越高，数据一致性就越好，但并发性越弱。

读未提交：READ UNCOMMITTED
允许Transaction01读取Transaction02未提交的修改。

读已提交：READ COMMITTED
 要求Transaction01只能读取Transaction02已提交的修改。

可重复读：REPEATABLE READ
 确保Transaction01可以多次从一个字段中读取到相同的值，即Transaction01执行期间禁止其它事务对这个字段进行更新。

串行化：SERIALIZABLE
 确保Transaction01可以多次从一个表中读取到相同的行，在Transaction01执行期间，禁止其它事务对这个表进行添加、更新、删除操作。可以避免任何并发问题，但性能十分低下。

# JavaEE

## Mysql什么时候建索引、什么时候不适合建索引

### 哪些情况需要创建索引

- 主键自动建立唯 一 索引
- 频繁作为查询条件的字段应该创建索引
- 查询中与其它表关联的字段，外键关系建立索引
- 频繁更新的字段不适合创建索引，因为每次更新不单是更新了记录还会更新索引
- 单键组索引的选择问题，who? 在高并发下领向创建组合索引
- 意询中排序的字段，排序字段若通过索引法访问将大大提高排序速度
- 查询中统计或者分组字段

### 哪些情况下不要建立索引

- 表记录太少

  Why:提高了查询速度，同时却会降低更新表的速度，如对表进行INSERT、UPDATE和DELETE.

- 经常增删改的表

  因为更新表时，MySQL不仅要保存数据，还要保存一下索引文件数据重复且分布平均的表字段，因此应该只为最经常查询和最经常排序的数据列建立索引。
  注意，如果某个数据列包含许多重复的内容，为它建立索弓就没有太大的实际效果。

- where条件里用不到的字段

- 过滤性不好的字段

## JVM垃圾回收机制、GC发生在JVM哪部分，有几种GC，他们的算法是什么

> GC 发生在JVM的堆里面

![JVM体系结构](/images/JVM体系结构.png)
![GC](/images/GC.png)