---
title: Java面试清单(二、容器)
date: 2019-04-07 14:13:33
tags:
    - Java
categories:
    - Java
---
## java 容器都有哪些？
简单的来说Java容器类类库的用途是“持有对象”，并将其划分为两个不同的概念：  
1.Collection：一个独立元素的序列，这些元素都服从一条或者多条规则。List必须按照插入的顺序保存元素，而set不能有重复的元素。Queue按照排队规则来确定对象产生的顺序（通常与它们被插入的顺序相同）。   
2.Map：一组成对的“键值对”对象，允许你使用键来查找值。  
<!-- more -->
## Collection 和 Collections 有什么区别？
1.java.util.Collection 是一个集合接口（集合类的一个顶级接口）。它提供了对集合对象进行基本操作的通用接口方法。Collection接口在Java 类库中有很多具体的实现。Collection接口的意义是为各种具体的集合提供了最大化的统一操作方式，其直接继承接口有List与Set。  
2.Collections则是集合类的一个工具类/帮助类，其中提供了一系列静态方法，用于对集合中元素进行排序、搜索以及线程安全等各种操作。  

## List、Set、Map 之间的区别是什么？

## HashMap 和 Hashtable 有什么区别？

## 如何决定使用 HashMap 还是 TreeMap？
| *Map* | *HashMap* | *TreeMap* /
| :------: | :------: | :------: |
| 适用情况 | 查询 | 增加、快速创建  |
| 原因 | 基于散列表实现| 基于红黑树实现 |

## 说一下 HashMap 的实现原理？

## 说一下 HashSet 的实现原理？
对于HashSet而言，它是基于HashMap实现的，HashSet底层使用HashMap来保存所有元素，更确切的说，HashSet中的元素，只是存放在了底层HashMap的key上， 而value使用一个static final的Object对象标识。因此HashSet 的实现比较简单，相关HashSet的操作，基本上都是直接调用底层HashMap的相关方法来完成。  

## ArrayList 和 LinkedList 的区别是什么？
ArrayList : 长度可变的数组，可以对元素进行随机的访问，向ArrayList中插入与删除元素的速度慢。 JDK8 中ArrayList扩容的实现是通过grow()方法里使用语句newCapacity = oldCapacity + (oldCapacity >> 1)（即1.5倍扩容）计算容量，然后调用Arrays.copyof()方法进行对原数组进行复制。  
LinkedList：采用链表数据结构，插入和删除速度快，但访问速度慢。  

## 如何实现数组和 List 之间的转换？
转换为数组为list：  
使用Stream中的Collector收集器  
```
String[] arrays = new String[]{"a", "b", "c"};
List<String> listStrings = Stream.of(arrays).collector(Collectors.toList());
```
使用java.util.Arrays工具类中的asList()方法  
```
String[] arrays = new String[]{"a", "b", "c"};
List<String> listStrings = Arrays.asList(arrays);
```
转换list为数组：  
```
String[] ss = listStrings.stream().toArray(String[]::new);
String[] sss = listStrings.toArray(new String[listStrings.size()]);
```

## ArrayList 和 Vector 的区别是什么？
Vector的方法都是同步的(Synchronized),是线程安全的(thread-safe)，而ArrayList的方法不是，由于线程的同步必然要影响性能，因此,ArrayList的性能比Vector好。  
当Vector或ArrayList中的元素超过它的初始大小时,Vector会将它的容量翻倍,而ArrayList只增加50%的大小，这样,ArrayList就有利于节约内存空间。  

## Array 和 ArrayList 有何区别？
可以将 ArrayList想象成一种“会自动扩增容量的Array”，Array[]：最高效，但是其容量固定且无法动态改变；  
ArrayList：容量可动态增长，但是牺牲效率。  

## 在 Queue 中 poll()和 remove()有什么区别？
可以将 ArrayList想象成一种“会自动扩增容量的Array”，Array[]：最高效，但是其容量固定且无法动态改变；  
ArrayList：容量可动态增长，但是牺牲效率。  

## 哪些集合类是线程安全的？
Vector：就比ArrayList多了个同步化机制（线程安全），因为效率较低，现在已经不太建议使用。在web应用中，特别是前台页面，往往效率（页面响应速度）是优先考虑的。  
Stack：堆栈类，先进后出。  
HashTable：上文已经说过和HashMap的区别以及原理  
Enumeration：枚举，相当于迭代器。  

## 迭代器 Iterator 是什么？
Iterator接口提供了很多对集合元素进行迭代的方法。每一个集合类都包括了可以返回迭代器实例的迭代方法。迭代器可以在迭代过程中删除底层集合的元素，但是不可以直接调用集合的remove(Object obj)删除，可以通过迭代器的remove()方法删除。  

## Iterator 怎么使用？有什么特点？
1.Iterator遍历集合元素的过程中不允许线程对集合元素进行修改，否则会抛出ConcurrentModificationException的异常。    
2.Iterator遍历集合元素的过程中可以通过remove方法来移除集合中的元素。  
3.Iterator必须依附某个Collection对象而存在，Iterator本身不具有装载数据对象的功能。  
4.Iterator.remove方法删除的是上一次Iterator.next()方法返回的对象。  
5.强调一下next（）方法，该方法通过游标指向的形式返回Iterator下一个元素。  

## Iterator 和 ListIterator 有什么区别？
1.iterator()方法在set和list接口中都有定义，但是ListIterator（）仅存在于List接口中（或实现类中）。  
2.ListIterator有add()方法，可以向List中添加对象，而Iterator不能。  
3.ListIterator和Iterator都有hasNext()和next()方法，可以实现顺序向后遍历，但是ListIterator有hasPrevious()和previous()方法，可以实现逆向（顺序向前）遍历。Iterator就不可以。  
4.ListIterator可以定位当前的索引位置，nextIndex()和previousIndex()可以实现。Iterator没有此功能。  
5.都可实现删除对象，但是ListIterator可以实现对象的修改，set()方法可以实现。Iterator仅能遍历，不能修改。  

## 怎么确保一个集合不能被修改？ 
私有化 放到一个对象里。或者  
ImmutableList imList = ImmutableList.copyOf(list);  