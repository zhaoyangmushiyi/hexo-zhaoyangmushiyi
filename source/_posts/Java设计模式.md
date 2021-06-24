---
title: Java设计模式
date: 2021-06-09 16:11:11
tags:
    - Java
categories:
    - Java
---

软件设计模式（Software Design Pattern），又称设计模式，是一套被反复使用、多数人知晓的、经过分类编目的、代码设计经验的总结。它描述了在软件设计过程中的一些不断重复发生的问题，以及该问题的解决方案。也就是说，它是解决特定问题的一系列套路，是前辈们的代码设计经验的总结，具有一定的普遍性，可以反复使用。其目的是为了提高代码的可重用性、代码的可读性和代码的可靠性。

<!-- more -->

# 软件设计7大原则

| 设计原则     | 一句话归纳                                                   | 目的                                       |
| ------------ | ------------------------------------------------------------ | ------------------------------------------ |
| 开闭原则     | 对扩展开放，对修改关闭                                       | 降低维护带来的新风险                       |
| 依赖倒置原则 | 高层不应该依赖低层，要面向接口编程                           | 更利于代码结构的升级扩展                   |
| 单一职责原则 | 一个类只干一件事，实现类要单一                               | 便于理解，提高代码的可读性                 |
| 接口隔离原则 | 一个接口只干一件事，接口要精简单一                           | 功能解耦，高聚合、低耦合                   |
| 迪米特法则   | 不该知道的不要知道，一个类应该保持对其它对象最少的了解，降低耦合度 | 只和朋友交流，不和陌生人说话，减少代码臃肿 |
| 里氏替换原则 | 不要破坏继承体系，子类重写方法功能发生改变，不应该影响父类方法的含义 | 防止继承泛滥                               |
| 合成复用原则 | 尽量使用组合或者聚合关系实现代码复用，少使用继承             | 降低代码耦合                               |

> 记忆口诀：访问加限制，函数要节俭，依赖不允许，动态加接口，父类要抽象，扩展不更改。

# 创建型模式的特点和分类

创建型模式分为以下几种。

- [单例（Singleton）模式](#单例模式)：某个类只能生成一个实例，该类提供了一个全局访问点供外部获取该实例，其拓展是有限多例模式。
- 原型（Prototype）模式：将一个对象作为原型，通过对其进行复制而克隆出多个和原型类似的新实例。
- 工厂方法（FactoryMethod）模式：定义一个用于创建产品的接口，由子类决定生产什么产品。
- 抽象工厂（AbstractFactory）模式：提供一个创建产品族的接口，其每个子类可以生产一系列相关的产品。
- 建造者（Builder）模式：将一个复杂对象分解成多个相对简单的部分，然后根据不同需要分别创建它们，最后构建成该复杂对象。


以上 5 种创建型模式，除了[工厂方法模式](#工厂方法模式)属于类创建型模式，其他的全部属于对象创建型模式，我们将在之后的教程中详细地介绍它们的特点、结构与应用。

## 单例模式

### 什么是Singleton?

Singleton:在Java中 即指单例设计模式，探视软件开发最常用的设计模式之一

单：唯一

例：实例

单例设计模式，即某个类在整个系统中只能有一个实例对象可被获取和使用的代码模式

例如：代表JVM运行环境的Runtime类

### 要点：

一是某个类只能有一个实例

- 构造器私有化

二是他必须自行创建实例

- 含有一个该类的静态变量来保存这个唯一的实例

三是它必须自行向整个系统提供这个实例

对外提供获取该类实例对象的方式

- 直接暴露
- 用静态变量的get方法获取

### 几种常见形式

饿汉式：直接创建对象，不存在线程安全问题

- 直接实例化饿汉式(简洁直观)

  ```java
  /**
   * 1、构造器私有化
   * 2、自行创建，并且用静态变量保存
   * 3、向外提供实例
   * 4、强调这是一个单例，我们可以用final修改
   * @author Monochrome
   * @date 2021/4/13
   */
  public class Singleton1 {
  
      private static final Singleton1 INSTANCE = new Singleton1();
  
      private Singleton1() {
  
      }
  }
  ```

  

- 枚举式 (最简洁)

  ```java
  /**
   * 枚举类型：表示该类型是有限的几个
   *
   * @author Monochrome
   * @date 2021/4/13
   */
  public enum Singleton2 {
      INSTANCE
  }
  
  ```

  

- 静态代码块饿汉式(适合复杂实例化)

  ```java
  /**
   *
   * @author Monochrome
   * @date 2021/4/13
   */
  public class Singleton3 {
  
      public static final Singleton3 INSTANCE;
  
      private String info;
  
      static {
          INSTANCE = new Singleton3("info");
      }
  
      private Singleton3(String info) {
          this.info = info;
      }
  }
  
  ```

  

懒汉式：延迟创建对象

- 线程不安全(使用于单线程)

  ```java
  /**
   * 懒汉式
   * 线程不安全(使用于单线程)
   * @author Monochrome
   * @date 2021/4/13
   */
  public class Singleton4 {
  
      private static Singleton4 instance;
  
      private Singleton4() {
      }
  
      public static Singleton4 getInstance() {
          if (instance == null) {
              instance = new Singleton4();
          }
          return instance;
      }
  }
  ```

  

- 线程安全(使用于多线程)

  ```java
  /**
   * 懒汉式
   * 线程安全(使用于多线程)
   * @author Monochrome
   * @date 2021/4/13
   */
  public class Singleton5 {
  
      private static volatile Singleton5 instance;
  
      private Singleton5() {
      }
  
      public static Singleton5 getInstance() {
          if (instance == null) {
              synchronized (Singleton5.class) {
                  if (instance == null) {
                      instance = new Singleton5();
                  }
              }
          }
          return instance;
      }
  }
  ```

  

- 静态内部类模式 (适用于多线程)

  ```java
  /**
   * 1、内部类被加载和初始化时，才创建INSTANCE实例对象
   * 2、静态内部类不会自动创建,随着外部类的加载初始化而初始化，他是要单独去加载和实例化的
   * 3、因为是在内部类加载和初始化时，创建的，因此线程安全
   *
   * @author Monochrome
   * @date 2021/4/13
   */
  public class Singleton6 {
  
      private Singleton6() {
  
      }
  
      private static class Inner{
          private static final Singleton6 INSTANCE = new Singleton6();
      }
  
      public static Singleton6 getInstance() {
          return Inner.INSTANCE;
      }
  }
  
  ```

  
