---
title: Spring知识点
date: 2021-07-01 19:49:16
tags:
    - Java
    - Spring
categories:
    - Java
    - Spring
---

# Bean的生命周期

Bean的生命周期指的就是：在Spring中，Bean是如何生成的？

被Spring管理的对象叫做Bean。Bean的生成步骤如下：

1. Spring扫描class得到BeanDefinition
2. 根据得到的BeanDefinition去生成bean
3. 首先根据class推断构造方法
4. 根据推断出来的构造方法，反射，得到一个对象（暂时叫做原始对象）
5. 填充原始对象中的属性（依赖注入）
6. 如果原始对象中的某个方法被AOP了，那么则需要根据原始对象生成一个代理对象
7. 把最终生成的代理对象放入单例池（源码中叫做singletonObjects）中，下次getBean时就直接从单例池拿即可

<!-- More -->

![Bean的生命周期](/images/Spring知识点/Bean的生命周期.png)

# Spring的循环依赖？

很简单，就是A对象依赖了B对象，B对象依赖了A对象。

比如：

```java
// A依赖了B
class A{
	public B b;
}

// B依赖了A
class B{
	public A a;
}
```

那么循环依赖是个问题吗？

如果不考虑Spring，循环依赖并不是问题，因为对象之间相互依赖是很正常的事情。

比如

```java
A a = new A();
B b = new B();

a.b = b;
b.a = a;
```

这样，A,B就依赖上了。



但是，在Spring中循环依赖就是一个问题了，为什么？

因为，在Spring中，一个对象并不是简单new出来了，而是会经过一系列的Bean的生命周期，就是因为Bean的生命周期所以才会出现循环依赖问题。当然，在Spring中，出现循环依赖的场景很多，有的场景Spring自动帮我们解决了，而有的场景则需要程序员来解决。



要明白Spring中的循环依赖，得先明白Spring中[Bean的生命周期](#Bean的生命周期)。

可以发现，在Spring中，构造一个Bean，包括了new这个步骤（第4步构造方法反射）。

得到一个原始对象后，Spring需要给对象中的属性进行依赖注入，那么这个注入过程是怎样的？

比如上文说的A类，A类中存在一个B类的b属性，所以，当A类生成了一个原始对象之后，就会去给b属性去赋值，此时就会根据b属性的类型和属性名去BeanFactory中去获取B类所对应的单例bean。如果此时BeanFactory中存在B对应的Bean，那么直接拿来赋值给b属性；如果此时BeanFactory中不存在B对应的Bean，则需要生成一个B对应的Bean，然后赋值给b属性。



问题就出现在第二种情况，如果此时B类在BeanFactory中还没有生成对应的Bean，那么就需要去生成，就会经过B的Bean的生命周期。



那么在创建B类的Bean的过程中，如果B类中存在一个A类的a属性，那么在创建B的Bean的过程中就需要A类对应的Bean，但是，触发B类Bean的创建的条件是A类Bean在创建过程中的依赖注入，所以这里就出现了循环依赖：



ABean创建-->依赖了B属性-->触发BBean创建--->B依赖了A属性--->需要ABean（但ABean还在创建过程中）



从而导致ABean创建不出来，BBean也创建不出来。



这是循环依赖的场景，但是上文说了，在Spring中，通过某些机制帮开发者解决了部分循环依赖的问题，这个机制就是**三级缓存**。

## 三级缓存

