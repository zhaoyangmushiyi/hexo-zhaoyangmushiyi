---
title: Effective Java Item10 覆盖equals时请遵守通用约定
date: 2018-12-10 18:53:00
tags:
    - Java
    - Effective Java
categories:
    - Java
    - Effective Java
    - chapter 3
---

## 对于所有对象都通用的方法

尽管`Object`是一个具体类，但是设计它主要是为了扩展。它所有的非`final`方法(`equals`、`hashCode`、`toString`、`clone`和`finalize`)都有明确的通用约定（**`general contract`**）,因为它们被设计成是要被覆盖（`override`）的。任何一个类，它在覆盖这些方法的时候，都有责任遵守这些通用约定；如果不能做到这一点，其他依赖于这些约定的类（例如`HashMap`和`HashSet`）就无法结合该类一起正常运作。

本章将讲述何时以及如何盖这些非`final`的`Object`方法。本章不再讨论`finalize`方法，因为Item 7已经讨论过这个方法了。而`Comparable.compareTo`虽然不是`Object`方法，但是本章也对它进行讨论，因为它具有类似的特征。
<!-- more -->

### Item 10：覆盖`equals`时请遵守通用约定

覆盖`equals`方法看起来似乎很简单，但是有许多覆盖方式会导致错误，并且后果非常严重。最容易避免这类问提的办法就是不覆盖`equals`方法，在这种情况下，类的每个实例都只与它自身相等。如果满足了以下任何一个条件，这就正是所期望的结果：
  
- **类的每个实例本质上都是唯一的**。对于代表活动实体而不是值(`value`)的类来说确实如此，例如`Thread`。`Object`的`equals`实现对于这些类来说正是正确的行为。  
- **不关心类是否提供了“逻辑相等(`logical equality`)"的测试功能**。例如，`java.util.Random`覆盖了`equals`，以检查两个`Random`实例是否产生相同的随机数序列，但是设计者并不认为客户需要或者期望这样的功能。在这样的情况下，从`Object`继承得到的`equals`实现已经足够了。  
- **超类己经覆盖了equals．从超类继承过来的行为对于子类也是合适的**。例如，大多数的`Set`实现都从`AbstractSet`继承`equals`实现，`Map`实现从`AbstractMap`继承`equals`实现。
- **类是私有的或是包级私有的，可以确定它的`equals`方法永远不会被调用**。在这种情况下，无疑是应该覆盖`equals`方法的，以防它被意外调用：

``` java
@Override 
public boolean equals(Object o) {
    throw new AssertionError(); // Method is never called
}
```

那么，什么时候应该覆盖Object.equals呢？如果类具有自己特有的“逻辑相等，概念（不
同于对象等同的概念),而且超类还没有覆盖equ囝、以实现期望的行为．这时我们就需要覆盖
eq翮方法．这通常于“值类（valueclass疒的情形。值类仅仅是一个表示值的奚，例如
Integer或者Date.程序员在利用equa《$方法来比较对象的引用时，希望知道它们在逻辑上是
否相等，而不是想了解它们是否指向同一个对象。为了满足程序员的要求，不仅老需覆盖
叫ua卜方法，而且这样做也使得这个类的实例可以被用做映射表(map)的键（处y〕，或者集
合（5以）的元素，使映射或者集合表现出预期的行为。
有一种“值类”不需要覆盖四u方法，即用实例受控（见第1条）确保“每个值至多只
存在一个对象”的类。枚举类型（见第30条）就属于这种类．对十这样的类而言，逻辑相同
与对象等同是一回事，因此Object的equal、方法等同于逻辑意义上的eq鼕小方法。
在覆盖equa方法的时候，你必须要遵守它的用约定“下面是约定的内容，来自Object
的规范0aSE61:
equa卜方法实现了等价关厚(equivalencerelation
·自反性(reflexive).对于任何非null的引用直、，x•equals(x)必须返回true.
·对称性(symmetric).对于任何非null的引用直x和Y，当且仅当y.equals(x)iÄ回true时，
x•equals(y)必须返Atrue.
。传递性(transitive).对于任何非null的引用值私y和z,如Rx-equals(y〕返回true，并
且Y，四u虱幻也返回tri《e，那么equa风z）也必须返回tri《e。
一致性：consistent).对于任甸非null的引用值x和y，只娈equa的比较作在对象中
所用的信息没有被修改多次调用、弋q“卜（刃就会一这地返回true，或者一致地赵回
．对于任何非null的引用值x，x•equals(null)必须返回false.
除非你对数学特别感兴，否则这些规定看起来可能有点让人感到恐惧，但是绝对不要忽
