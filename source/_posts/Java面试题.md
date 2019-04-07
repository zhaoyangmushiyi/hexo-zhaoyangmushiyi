---
title: Java面试题
date: 2019-02-28 14:35:37
tags:
    - Java
categories:
    - Java
---
# Java面试题
## 基础篇
### 基本功
#### 面向对象的特征
##### 抽象
- 忽略一个主题中与当前目标无关的东西,专注的注意与当前目标有关的方面.(就是把现实世界中的某一类东西,提取出来,用程序代码表示,抽象出来的一般叫做类或者接口).抽象并不打算了解全部问题,而是选择其中的一部分,暂时不用部分细节.抽象包括两个方面,一个数据抽象,而是过程抽象.
- 数据抽象 -->表示世界中一类事物的特征,就是对象的属性.比如鸟有翅膀,羽毛等(类的属性)
- 过程抽象 -->表示世界中一类事物的行为,就是对象的行为.比如鸟会飞,会叫(类的方法)

<!-- more -->
##### 封装
- 封装就是把过程和数据包围起来,对数据的访问只能通过特定的界面.如私有变量,用set,get方法获取

##### 继承
- 一种联结类的层次模型,并且允许和鼓励类的重用,提供一种明确表达共性的方法.对象的一个新类可以从现有的类中派生,这个过程称为类继承.新类继承了原始类的特性,新类称为原始类的派生类(子类),原始类称为新类的基类(父类).派生类可以从它的父类哪里继承方法和实例变量,并且类可以修改或增加新的方法使之更适合特殊的需要.因此可以说,继承为了重用父类代码,同时为实现多态性作准备.

##### 多态
- 多态是指允许不同类的对象对同一消息做出响应.多态性包括参数化多态性和包含多态性.多态性语言具有灵活/抽象/行为共享/代码共享的优势,很好的解决了应用程序函数同名问题.总的来说,方法的重写,重载与动态链接构成多态性.java引入多态的概念原因之一就是弥补类的单继承带来的功能不足.
- 动态链接 -->对于父类中定义的方法,如果子类中重写了该方法,那么父类类型的引用将调用子类中的这个方法,这就是动态链接.

##### 注意
　　注意继承与重载:子类与父类的关系,重载方法的调用问题  
子类对象可以直接当成父类对象用,但是反过来就不行.比如:人是父类,学生是人的子类,所以学生对象一定具备人对象的属性,但是人对象就未必具有学生对象的特性.但是子类对象当做父类来用,将失去子类所有特性,只保留与父类同名的属性和方法,此时可以对父类方法进行重写.  
一个类中如果定义了重载的方法,则系统在调用方法时,会根据参数的类型自动选择调用合适的方法  

#### final, finally, finalize 的区别
##### final
　　final可以用来修饰类，方法和变量（成员变量或局部变量）  

##### finally
　　finally作为异常处理的一部分，它只能用在try/catch语句中，并且附带一个语句块，表示这段语句最终一定会被执行（不管有没有抛出异常），经常被用在需要释放资源的情况下。（×）    
只有与finally对应的try语句块得到执行的情况下，finally语句块才会执行。  
当一个线程在执行 try 语句块或者 catch 语句块时被打断（interrupted）或者被终止（killed），与其相对应的 finally 语句块可能不会执行。还有更极端的情况，就是在线程运行 try 语句块或者 catch 语句块时，突然死机或者断电，finally 语句块肯定不会执行了。可能有人认为死机、断电这些理由有些强词夺理，没有关系，我们只是为了说明这个问题。

##### finalize
　　finalize()是在java.lang.Object里定义的，也就是说每一个对象都有这么个方法。这个方法在gc启动，该对象被回收的时候被调用。其实gc可以回收大部分的对象（凡是new出来的对象，gc都能搞定，一般情况下我们又不会用new以外的方式去创建对象），所以一般是不需要程序员去实现finalize的。 
　　特殊情况下，需要程序员实现finalize，当对象被回收的时候释放一些资源，比如：一个socket链接，在对象初始化时创建，整个生命周期内有效，那么就需要实现finalize，关闭这个链接。   
　　使用finalize还需要注意一个事，调用super.finalize();  
　　一个对象的finalize()方法只会被调用一次，而且finalize()被调用不意味着gc会立即回收该对象，所以有可能调用finalize()后，该对象又不需要被回收了，然后到了真正要被回收的时候，因为前面调用过一次，所以不会调用finalize()，产生问题。 所以，推荐不要使用finalize()方法，它跟析构函数不一样。  

#### int 和 Integer 有什么区别
①、Integer 是 int 包装类，int 是八大基本数据类型之一(byte,char,short,int,long,float,double,boolean)；
②、Integer 是类，默认值为null，int是基本数据类型，默认值为0；
③、Integer 表示的是对象，用一个引用指向这个对象，而int是基本数据类型，直接存储数值。

#### 重载(Overloading)和重写(Overriding)的区别
##### 重载(Overloading)
①、方法重载是让类以统一的方式处理不同类型数据的一种手段。多个同名函数同时存在，具有不同的参数个数/类型。重载Overloading是一个类中多态性的一种表现。  
②、Java的方法重载，就是在类中可以创建多个方法，它们具有相同的名字，但具有不同的参数和不同的定义。调用方法时通过传递给它们的不同参数个数和参数类型来决定具体使用哪个方法, 这就是多态性。  
③、重载的时候，方法名要一样，但是参数类型和个数不一样，返回值类型可以相同也可以不相同。无法以返回型别作为重载函数的区分标准。  

##### 重写(Overriding)
（1） 父类与子类之间的多态性，对父类的函数进行重新定义。如果在子类中定义某方法与其父类有相同的名称和参数，我们说该方法被重写 (Overriding)。在Java中，子类可继承父类中的方法，而不需要重新编写相同的方法。但有时子类并不想原封不动地继承父类的方法，而是想作一定的修改，这就需要采用方法的重写。方法重写又称方法覆盖。  
（2）若子类中的方法与父类中的某一方法具有相同的方法名、返回类型和参数表，则新方法将覆盖原有的方法。如需父类中原有的方法，可使用super关键字，该关键字引用了当前类的父类。  
（3）子类函数的访问修饰权限不能少于父类的；  

#### 抽象类和接口有什么区别
什么时候使用抽象类和接口

- 如果你拥有一些方法并且想让它们中的一些有默认实现，那么使用抽象类吧。
- 如果你想实现多重继承，那么你必须使用接口。由于Java不支持多继承，子类不能够继承多个类，但可以实现多个接口。因此你就可以使用接口来解决它。
- 如果基本功能在不断改变，那么就需要使用抽象类。如果不断改变基本功能并且使用接口，那么就需要改变所有实现了该接口的类。

Java8中的默认方法和静态方法
　　Oracle已经开始尝试向接口中引入默认方法和静态方法，以此来减少抽象类和接口之间的差异

#### 说说反射的用途及实现
##### 什么是Java类中的反射？
　　当程序运行时，允许改变程序结构或变量类型，这种语言称为动态语言。我们认为 Java 并不是动态语言，但是它却又一个非常突出的动态相关的机制，俗称：反射。  
通过反射，我们可以在运行时获得程序或程序集中每一个类型成员和成员变量的信息。  
程序中一般的对象类型都是在编译期就确定下来的，而Java 反射机制可以动态的创建对象并调用其属性，这样对象的类型在编译期是未知的。所以我们可以通过反射机制直接创建对象即使这个对象在编译期是未知的，反射的核心：是 JVM 在运行时 才动态加载的类或调用方法或属性，他不需要事先（写代码的时候或编译期）知道运行对象是谁。  

Java反射框架提供以下功能：  
 ①、在运行时判断任意一个对象所属的类   
 ②、在运行时构造任意一个类的对象  
 ③、在运行时判断任意一个类所具有的成员变量和方法（通过反射设置可以调用 private）  
 ④、在运行时调用人一个对象的方法  
 
　　很多框架（比如 Spring）都是配置化的（比如通过 XML文件配置 JavaBean，Action之类的），为了保证框架的通用性，他们可能根据配置文件加载不同的对象或类，调用不同的方法，这个时候就必须用到反射——运行时动态加载需要加载的对象。  

##### 反射的基本运用
　　以上我们提到了反射可以拟用于判断任意对象所属的类，获得 Class对象，构造人一个对象以及调用一个对象。这里我们介绍一下基本反射功能的事先（反射相关类一般都在 java.lang.relfect包里）。

①、获得 Class 对象  
```（1）、使用 Class类的 forName() 静态方法：
public static Class<?> forName(String className)
……
在JDBC开发中常用此方法加载数据库驱动:
……java
Class.forName(driver)
（2）、直接获取某一个对象的 class，比如：
Class<?> klass = int.class;
Class<?> classInt = Integer.TYPE;
（3）、调用某个对象的getClass() 方法，比如：
StringBuilder str = new StringBuilder("123");
Class<?> klass = str.getClass();
```

②、判断是否为某个类的实例  
　　一般地，我们用 instanceof关键字来判断是否为某个类的实例。同时我们也可以借助反射中Class对象的 isInstance()方法来判断是否为某个类的实例，它是一个 Native 方法：  
```
public native boolean isInstance(Object obj);
```

③、创建实例  
通过反射来生成对象主要有两种方式。  
（1）使用 Class 对象的 newInstance() 方法来创建对象对应类的实例。  
```
Class<?> c  = String.calss;
Object str = c.getInstance();
```
（2）、先通过 Class 对象获取制定的 Constructor 对象，在调用 Constructor 对象的 newInstance() 方法来创建实例。这种方法可以用指定的构造器构造类的实例。  
  ```
  //获取String所对应的Class对象
   Class<?> c = String.class;
  //获取String类带一个String参数的构造器
  Constructor constructor = c.getConstructor(String.class);
  //根据构造器创建实例
  Object obj = constructor.newInstance("23333");
  System.out.println(obj);
```
#### 说说自定义注解的场景及实现
自定义注解会需要元注解，此处先介绍元注解。
##### 元注解：  
java中有四种元注解：@Retention、@Inherited、@Documented、@Target  
@Retention  
注解的保留位置（枚举RetentionPolicy），RetentionPolicy可选值：  
- SOURCE：注解仅存在于源码中，在class字节码文件中不包含
- CLASS：默认的保留策略，注解在class字节码文件中存在，但运行时无法获得
- RUNTIME：注解在class字节码文件中存在，在运行时可以通过反射获取到　　

@Inherited  
声明子类可以继承此注解，如果一个类A使用此注解，则类A的子类也继承此注解  

@Documented  
声明注解能够被javadoc等识别（下面自定义注解处会有例子做介绍，点击查看）  

@Target  
用来声明注解范围（枚举ElementType），ElementType可选值：  
- TYPE：接口、类、枚举、注解
- FIELD：字段、枚举的常量
- METHOD：方法
- PARAMETER：方法参数
- CONSTRUCTOR：构造函数
- LOCAL_VARIABLE：局部变量
- ANNOTATION_TYPE：注解
- PACKAGE：包

##### 自定义注解介绍
自定义注解使用场景：  
- 1.类属性自动赋值。
- 2.验证对象属性完整性。
- 3.代替配置文件功能，像spring基于注解的配置。
- 4.可以生成文档，像java代码注释中的@see,@param等
1和2这个没有做过类似实例，应该是像Hibernate中的使用注解映射Bean对象到数据库一样（此处为个人猜测，如有错误请留言指出），中间有检测和自动赋值。  

自定义注解定义：   
定义一个自定义注解（不使用元注解）：
```
public @interface MyAnnotation{}
```
定义一个自定义注解（使用元注解，每个元注解都是可选，非必选）：  
```
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
@Target({ElementType.FIELD,ElementType.METHOD})
public @interface MyAnnotation1{
    public String name() default "hello";
}
```
　　注解中可以声明成员方法，声明的成员方法为最终的注解里面的参数，成员方法可以使用default关键字设置默认值。上面的注解使用如：@MyAnnotation1(name=”ddd”)。

自定义注解演示：  
新建一个自定义注解：  
```
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
@Target({ElementType.FIELD,ElementType.METHOD})
@interface MyAnno{
    public String name() default "zhangsan";
    public String email() default "hello@example.com";
}
```
定义一个User类，来使用自定义注解：  
```
class User{
    @MyAnno(name = "zhang")
    private String name;
    @MyAnno(name = "zhang@example.com")
    private String email;
    @MyAnno(name = "sayHelloWorld")
    public String sayHello(){
        return "";
        
        }
    }
```
- @Documented注解的作用  
　　定义的MyAnno注解中使用了@Documented注解，可以看到User类中sayHello方法的javadoc。
- 通过反射获取注解信息  
　　下面我们通过反射来演示下获取属性的注解信息和方法的注解信息：  
```
Method[] methods = User.class.getMethods();
//Field[] fields = User.class.getFields();
Field[] fields = User.class.getDeclaredFields();
/* 
	getFields：只能访问public属性及继承到的public属性
	getDeclaredFields：只能访问到本类的属性，不能访问继承到的属性
	getMethods：只能访问public方法及继承到的public方法
	getDeclaredMethods：只能访问到本类的方法，不能访问继承到的方法
	getConstructors：只能访问public构造函数及继承到的public构造函数
	getDeclaredConstructors：只能访问到本类的构造函数，不能访问继承到的构造函数
*/
for (Field field : fields) {
	MyAnno annotation = field.getAnnotation(MyAnno.class);
	if(annotation!=null){
		System.out.println("property="+annotation.name());
	} 
} 
for (Method method : methods) {
	MyAnno annotation = method.getAnnotation(MyAnno.class);
	if(annotation!=null){
		System.out.println("sayHello="+annotation.name());
	}
}
```
输出如下：
```
property=zhang
property=zhang@example.com
sayHello=sayHelloWorld
```
#### HTTP 请求的 GET 与 POST 方式的区别
　最直观的区别就是GET把参数包含在URL中，POST通过request body传递参数。  
GET和POST还有一个重大区别，简单的说：  
- GET产生一个TCP数据包；POST产生两个TCP数据包。  
长的说：  
- 对于GET方式的请求，浏览器会把http header和data一并发送出去，服务器响应200（返回数据）；  
而对于POST，浏览器先发送header，服务器响应100 continue，浏览器再发送data，服务器响应200 ok（返回数据）  

#### session 与 cookie 区别
- 1、cookie数据存放在客户的浏览器上，session数据放在服务器上。
- 2、cookie不是很安全，别人可以分析存放在本地的COOKIE并进行COOKIE欺骗;考虑到安全应当使用session。
- 3、session会在一定时间内保存在服务器上。当访问增多，会比较占用你服务器的性能;考虑到减轻服务器性能方面，应当使用COOKIE。
- 4、单个cookie保存的数据不能超过4K，很多浏览器都限制一个站点最多保存20个cookie。
- 5、所以个人建议：  
将登陆信息等重要信息存放为SESSION  
其他信息如果需要保留，可以放在COOKIE中  

#### session 分布式处理
- 1.基于数据库的Session共享
- 2.基于NFS共享文件系统
- 3.基于memcached 的session，如何保证 memcached 本身的高可用性？
- 4.基于resin/tomcat web容器本身的session复制机制
- 5.基于TT/Redis 或 jbosscache 进行 session 共享。
- 6.基于cookie 进行session共享

#### JDBC 流程
第1步：注冊驱动 (仅仅做一次)  
第2步：建立连接(Connection)  
第3步：创建运行SQL的语句(Statement)  
第4步：运行语句  
第5步：处理运行结果(ResultSet)  
第6步：释放资源  

#### MVC 设计思想
一、概念
　　MVC是model、view、controller的简称。它是一中软件的设计思想，将应用的一个输入、处理、输出按照模型层，视图层，控制层进行分层设计。  
- 1)模型: 业务逻辑包含了业务数据的加工与处理以及相应的基础服务(为了保证业务逻辑能够正常进行的事务、安全、权限、日志等等的功能模块)  
- 2)视图:展现模型处理的结果；另外，还要提供相应的操作界面，方便用户使用。  
- 3)控制器:视图发请求给控制器，由控制器来选择相应的模型来处理；模型返回的结果给控制器，由控制器选择合适的视图。   

二、优缺点
优点：  
1、低耦合性  
　　前后端分离，更有效率。  
　　视图层和业务层分离，这样就允许更改视图层代码而不用重新编译模型和控制器代码，同样，一个应用的业务流程或者业务规则的改变只需要改动MVC的模型层即可。因为模型与控制器和视图相分离，所以很容易改变应用程序的数据层和业务规则。
2、高重用性和可适用性  
　　MVC模式允许你使用各种不同样式的视图来访问同一个服务器端的代码。它包括任何WEB（HTTP）浏览器或者无线浏览器（wap），比如，用户可以通过电脑也可通过手机来订购某样产品，虽然订购的方式不一样，但处理订购产品的方式是一样的。由于模型返回的数据没有进行格式化，所以同样的构件能被不同的界面使用。例如，很多数据可能用HTML来表示，但是也有可能用WAP来表示，而这些表示所需要的命令是改变视图层的实现方式，而控制层和模型层无需做任何改变。  
3、较低的生命周期成本  
　　MVC使开发和维护用户接口的技术含量降低。  
4、快速的部署  
　　使用MVC模式使开发时间得到相当大的缩减，它使程序员（Java开发人员）集中精力于业务逻辑，界面程序员（HTML和JSP开发人员）集中精力于表现形式上。  
5、可维护性  
　　分离视图层和业务逻辑层也使得WEB应用更易于维护和修改。  
6、有利于软件工程化管理  
　　由于不同的层各司其职，每一层不同的应用具有某些相同的特征，有利于通过工程化、工具化管理程序代码。  
缺点：  
　　使用mvc，会增加代码量、相应地也会增加软件开发的成文，设计的难度也会增加。一些小项目，完全可以不用。   

三、具体用例  
1、spring mvc框架  
2、jsp+servlet  

#### equals 与 == 的区别
　　“==” 比较的是两个引用在内存中指向的是不是同一对象（即同一内存空间），也就是说在内存空间中的存储位置是否一致。  
如果两个对象的引用相同时（指向同一对象时），“==”操作符返回true，否则返回false。  
　　equals方法是由Object类提供的，可以由子类来进行重写。  

Object类默认的实现如下：  
```
public boolean equals(Object obj) {
    return (this == obj);
}
```
总结：  
　　Java 语言里的 equals方法其实是交给开发者去覆写的，让开发者自己去定义满足什么条件的两个Object是equal的。  
所以我们不能单纯的说equals到底比较的是什么。你想知道一个类的equals方法是什么意思就是要去看定义。  

### 集合
#### List、Set、Map 区别
1.面试题：Collection里面有什么子类：  
　　List和Set  

List：
- 1.可以允许重复的对象。
- 2.可以插入多个null元素。
- 3.是一个有序容器，保持了每个元素的插入顺序，输出的顺序就是插入的顺序。
- 4.常用的实现类有 ArrayList、LinkedList 和 Vector。ArrayList 最为流行，它提供了使用索引的随意访问，而 LinkedList 则对于经常需要从 List 中添加或删除元素的场合更为合适。

Set：
- 1.不允许重复对象
- 2.无序容器，你无法保证每个元素的存储顺序，TreeSet通过 Comparator  或者 Comparable 维护了一个排序顺序。
- 3.只允许一个 null 元素
- 4.Set 接口最流行的几个实现类是 HashSet、LinkedHashSet 以及 TreeSet。最流行的是基于 HashMap 实现的 HashSet；TreeSet 还实现了 SortedSet 接口，因此 TreeSet 是一个根据其 compare() 和 compareTo() 的定义进行排序的有序容器。

Map:
- 1.Map不是collection的子接口或者实现类。Map是一个接口。
- 2.Map 的 每个 Entry 都持有两个对象，也就是一个键一个值，Map 可能会持有相同的值对象但键对象必须是唯一的。
- 3.TreeMap 也通过 Comparator  或者 Comparable 维护了一个排序顺序。
- 4.Map 里你可以拥有随意个 null 值但最多只能有一个 null 键。
- 5.Map 接口最流行的几个实现类是 HashMap、LinkedHashMap、Hashtable 和 TreeMap。（HashMap、TreeMap最常用）

2.面试题：什么场景下使用list，set，map呢？
- 1.如果你经常会使用索引来对容器中的元素进行访问，那么 List 是你的正确的选择。如果你已经知道索引了的话，那么 List 的实现类比如 ArrayList 可以提供更快速的访问,如果经常添加删除元素的，那么肯定要选择LinkedList。
- 2.如果你想容器中的元素能够按照它们插入的次序进行有序存储，那么还是 List，因为 List 是一个有序容器，它按照插入顺序进行存储。
- 3.如果你想保证插入元素的唯一性，也就是你不想有重复值的出现，那么可以选择一个 Set 的实现类，比如 HashSet、LinkedHashSet 或者 TreeSet。所有 Set 的实现类都遵循了统一约束比如唯一性，而且还提供了额外的特性比如 TreeSet 还是一个 SortedSet，所有存储于 TreeSet 中的元素可以使用 Java 里的 Comparator 或者 Comparable 进行排序。LinkedHashSet 也按照元素的插入顺序对它们进行存储。
- 4.如果你以键和值的形式进行数据存储那么 Map 是你正确的选择。你可以根据你的后续需要从 Hashtable、HashMap、TreeMap 中进行选择。

#### ArrayList 与 LinkedList 区别
大致区别：  
- 1.ArrayList是实现了基于动态数组的数据结构，LinkedList基于链表的数据结构。 （LinkedList是双向链表，有next也有previous）
- 2.对于随机访问get和set，ArrayList觉得优于LinkedList，因为LinkedList要移动指针。 
- 3.对于新增和删除操作add和remove，LinedList比较占优势，因为ArrayList要移动数据

ArrayList和LinkedList在性能上各有优缺点，都有各自所适用的地方，总的说来可以描述如下： 
- 1．对ArrayList和LinkedList而言，在列表末尾增加一个元素所花的开销都是固定的。对ArrayList而言，主要是在内部数组中增加一项，指向所添加的元素，偶尔可能会导致对数组重新进行分配；而对LinkedList而言，这个开销是统一的，分配一个内部Entry对象。
- 2．在ArrayList的中间插入或删除一个元素意味着这个列表中剩余的元素都会被移动；而在LinkedList的中间插入或删除一个元素的开销是固定的。
- 3．LinkedList不支持高效的随机元素访问。
- 4．ArrayList的空间浪费主要体现在在list列表的结尾预留一定的容量空间，而LinkedList的空间花费则体现在它的每一个元素都需要消耗相当的空间

　　可以这样说：当操作是在一列数据的后面添加数据而不是在前面或中间,并且需要随机地访问其中的元素时,使用ArrayList会提供比较好的性能；当你的操作是在一列数据的前面或中间添加或删除数据,并且按照顺序访问其中的元素时,就应该使用LinkedList了。

#### ArrayList 与 Vector 区别
- 1）Vector的方法都是同步的(Synchronized),是线程安全的(thread-safe)，而ArrayList的方法不是，由于线程的同步必然要影响性能，因此,ArrayList的性能比Vector好。 
- 2）当Vector或ArrayList中的元素超过它的初始大小时,Vector会将它的容量翻倍,而ArrayList只增加50%的大小，这样,ArrayList就有利于节约内存空间。

#### HashMap 和 Hashtable 的区别
　　HashMap和Hashtable都实现了Map接口，但决定用哪一个之前先要弄清楚它们之间的分别。主要的区别有：线程安全性，同步(synchronization)，以及速度。
- 1.HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，并可以接受null(HashMap可以接受为null的键值(key)和值(value)，而Hashtable则不行)。
- 2.HashMap是非synchronized，而Hashtable是synchronized，这意味着Hashtable是线程安全的，多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的。Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好。
- 3.另一个区别是HashMap的迭代器(Iterator)是fail-fast迭代器，而Hashtable的enumerator迭代器不是fail-fast的。所以当有其它线程改变了HashMap的结构（增加或者移除元素），将会抛出ConcurrentModificationException，但迭代器本身的remove()方法移除元素则不会抛出ConcurrentModificationException异常。但这并不是一个一定发生的行为，要看JVM。这条同样也是Enumeration和Iterator的区别。
- 4.由于Hashtable是线程安全的也是synchronized，所以在单线程环境下它比HashMap要慢。如果你不需要同步，只需要单一线程，那么使用HashMap性能要好过Hashtable。
- 5.HashMap不能保证随着时间的推移Map中的元素次序是不变的。

要注意的一些重要术语：  
- 1)synchronized意味着在一次仅有一个线程能够更改Hashtable。就是说任何线程要更新Hashtable时要首先获得同步锁，其它线程要等到同步锁被释放之后才能再次获得同步锁更新Hashtable。
- 2)Fail-safe和iterator迭代器相关。如果某个集合对象创建了Iterator或者ListIterator，然后其它的线程试图“结构上”更改集合对象，将会抛出ConcurrentModificationException异常。但其它线程可以通过set()方法更改集合对象是允许的，因为这并没有从“结构上”更改集合。但是假如已经从结构上进行了更改，再调用set()方法，将会抛出IllegalArgumentException异常。
- 3)结构上的更改指的是删除或者插入一个元素，这样会影响到map的结构。

我们能否让HashMap同步？  
HashMap可以通过下面的语句进行同步：  
```
Map m = Collections.synchronizeMap(hashMap);
```

#### HashSet 和 HashMap 区别
##### 什么是HashSet
　　HashSet实现了Set接口，它不允许集合中有重复的值，当我们提到HashSet时，第一件事情就是在将对象存储在HashSet之前，要先确保对象重写equals()和hashCode()方法，这样才能比较对象的值是否相等，以确保set中没有储存相等的对象。如果我们没有重写这两个方法，将会使用这个方法的默认实现。  
　　public boolean add(Object o)方法用来在Set中添加元素，当元素值重复时则会立即返回false，如果成功添加的话会返回true。  

##### 什么是HashMap
　　HashMap实现了Map接口，Map接口对键值对进行映射。Map中不允许重复的键。Map接口有两个基本的实现，HashMap和TreeMap。TreeMap保存了对象的排列次序，而HashMap则不能。HashMap允许键和值为null。HashMap是非synchronized的，但collection框架提供方法能保证HashMap synchronized，这样多个线程同时访问HashMap时，能保证只有一个线程更改Map。  
　　public Object put(Object Key,Object value)方法用来将元素添加到map中。  

##### HashSet和HashMap的区别
| *HashMap* | *HashSet* | 
| :------: | :------: |
| HashMap实现了Map接口 | HashSet实现了Set接口本 |
| HashMap储存键值对 | HashSet仅仅存储对象本 |
| 使用put()方法将元素放入map中 | 使用add()方法将元素放入set中本 |
| HashMap中使用键对象来计算hashcode值 | HashSet使用成员对象来计算hashcode值，对于两个对象来说hashcode可能相同，所以equals()方法用来判断对象的相等性，如果两个对象不同的话，那么返回false本 |
| HashMap比较快，因为是使用唯一的键来获取对象 | HashSet较HashMap来说比较慢本 |

#### HashMap 和 ConcurrentHashMap 的区别
　　ConcurrentHashMap具体是怎么实现线程安全的呢，肯定不可能是每个方法加synchronized，那样就变成了HashTable。  
　　从ConcurrentHashMap代码中可以看出，它引入了一个“分段锁”的概念，具体可以理解为把一个大的Map拆分成N个小的HashTable，根据key.hashCode()来决定把key放到哪个HashTable中。  
　　在ConcurrentHashMap中，就是把Map分成了N个Segment，put和get的时候，都是现根据key.hashCode()算出放到哪个Segment中。  
　　通过把整个Map分为N个Segment（类似HashTable），可以提供相同的线程安全，但是效率提升N倍，默认提升16倍。  

#### HashMap 的工作原理及代码实现 
##### 1、几个关键的信息  
　　基于Map接口实现、允许null键/值、非同步、不保证有序(比如插入的顺序)、也不保证序不随时间变化。  

##### 2、两个重要的参数  
　　容量(Capacity)和负载因子(Load factor)  

##### 3、put函数的实现  
put函数大致的思路为：  

        对key的hashCode()做hash，然后再计算index
        如果没碰撞直接放到bucket里
        如果碰撞了，以链表的形式存在buckets后
        如果碰撞导致链表过长(大于等于TREEIFY_THRESHOLD)就把链表转换成红黑树
        如果节点已经存在就替换old value(保证key的唯一性)
        如果bucket满了(超过load factor*current capacity)就要resize
具体代码的实现如下：
```
public V put(K key, V value) {
    // 对key的hashCode()做hash
    return putVal(hash(key), key, value, false, true);
}
final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
               boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
    // tab为空则创建
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length;
    // 计算index，并对null做处理
    if ((p = tab[i = (n - 1) & hash]) == null)
        tab[i] = newNode(hash, key, value, null);
    else {
        Node<K,V> e; K k;
        // 节点存在
        if (p.hash == hash &&
            ((k = p.key) == key || (key != null && key.equals(k))))
            e = p;
        // 该链为树
        else if (p instanceof TreeNode)
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
        // 该链为链表
        else {
            for (int binCount = 0; ; ++binCount) {
                if ((e = p.next) == null) {
                    p.next = newNode(hash, key, value, null);
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                        treeifyBin(tab, hash);
                    break;
                }
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    break;
                p = e;
            }
        }
        // 写入
        if (e != null) { // existing mapping for key
            V oldValue = e.value;
            if (!onlyIfAbsent || oldValue == null)
                e.value = value;
            afterNodeAccess(e);
            return oldValue;
        }
    }
    ++modCount;
    // 超过load factor*current capacity，resize
    if (++size > threshold)
        resize();
    afterNodeInsertion(evict);
    return null;
}
```

##### 4、get函数的实现  
在理解了put之后，get就很简单了。大致思路如下：  

        bucket里的第一个节点，直接命中
        如果有冲突，则通过key.equals(k)去查找对应的entry
        若为树，则在树中通过key.equals(k)查找，O(logn)；
        若为链表，则在链表中通过key.equals(k)查找，O(n)。
具体代码的实现如下：  
```
public V get(Object key) {
    Node<K,V> e;
    return (e = getNode(hash(key), key)) == null ? null : e.value;
}
final Node<K,V> getNode(int hash, Object key) {
    Node<K,V>[] tab; Node<K,V> first, e; int n; K k;
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (first = tab[(n - 1) & hash]) != null) {
        // 直接命中
        if (first.hash == hash && // always check first node
            ((k = first.key) == key || (key != null && key.equals(k))))
            return first;
        // 未命中
        if ((e = first.next) != null) {
            // 在树中get
            if (first instanceof TreeNode)
                return ((TreeNode<K,V>)first).getTreeNode(hash, key);
            // 在链表中get
            do {
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    return e;
            } while ((e = e.next) != null);
        }
    }
    return null;
}
```

##### 5、put函数的实现  
　　在get和put的过程中，计算下标时，先对hashCode进行hash操作，然后再通过hash值进一步计算下标。
在对hashCode()计算hash时具体实现是这样的：
```
static final int hash(Object key) {
    int h;
    return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```
　　可以看到这个函数大概的作用就是：高16bit不变，低16bit和高16bit做了一个异或。  
在设计hash函数时，因为目前的table长度n为2的幂，而计算下标的时候，是这样实现的(使用&位操作，而非%求余)：  
```
(n - 1) & hash
```
　　设计者认为这方法很容易发生碰撞。为什么这么说呢？不妨思考一下，在n - 1为15(0x1111)时，其实散列真正生效的只是低4bit的有效位，当然容易碰撞了。  
　　因此，设计者想了一个顾全大局的方法(综合考虑了速度、作用、质量)，就是把高16bit和低16bit异或了一下。设计者还解释到因为现在大多数的hashCode的分布已经很不错了，就算是发生了碰撞也用O(logn)的tree去做了。仅仅异或一下，既减少了系统的开销，也不会造成的因为高位没有参与下标的计算(table长度比较小时)，从而引起的碰撞。  
　　如果还是产生了频繁的碰撞，会发生什么问题呢？作者注释说，他们使用树来处理频繁的碰撞。   
之前已经提过，在获取HashMap的元素时，基本分两步：

        首先根据hashCode()做hash，然后确定bucket的index
        如果bucket的节点的key不是我们需要的，则通过keys.equals()在链中找
    
　　在Java 8之前的实现中是用链表解决冲突的，在产生碰撞的情况下，进行get时，两步的时间复杂度是O(1)+O(n)。因此，当碰撞很厉害的时候n很大，O(n)的速度显然是影响速度的。  
　　因此在Java 8中，利用红黑树替换链表，这样复杂度就变成了O(1)+O(logn)了，这样在n很大的时候，能够比较理想的解决这个问题。  

##### 6 、RESIZE的实现  
　　当put时，如果发现目前的bucket占用程度已经超过了Load Factor所希望的比例，那么就会发生resize。在resize的过程，简单的说就是把bucket扩充为2倍，之后重新计算index，把节点再放到新的bucket中。  
大致意思就是说，当超过限制的时候会resize，然而又因为我们使用的是2次幂的扩展(指长度扩为原来2倍)，所以，元素的位置要么是在原位置，要么是在原位置再移动2次幂的位置。  

##### 7、总结
- 什么时候会使用HashMap？他有什么特点？  
    　　是基于Map接口的实现，存储键值对时，它可以接收null的键值，是非同步的，HashMap存储着Entry(hash, key, value, next)对象。

- 你知道HashMap的工作原理吗？  
    　　通过hash的方法，通过put和get存储和获取对象。存储对象时，我们将K/V传给put方法时，它调用hashCode计算hash从而得到bucket位置，进一步存储，HashMap会根据当前bucket的占用情况自动调整容量(超过Load Facotr则resize为原来的2倍)。获取对象时，我们将K传给get，它调用hashCode计算hash从而得到bucket位置，并进一步调用equals()方法确定键值对。如果发生碰撞的时候，Hashmap通过链表将产生碰撞冲突的元素组织起来，在Java 8中，如果一个bucket中碰撞冲突的元素超过某个限制(默认是8)，则使用红黑树来替换链表，从而提高速度。

- 你知道get和put的原理吗？equals()和hashCode()的都有什么作用？  
    　　通过对key的hashCode()进行hashing，并计算下标( n-1 & hash)，从而获得buckets的位置。如果产生碰撞，则利用key.equals()方法去链表或树中去查找对应的节点

- 你知道hash的实现吗？为什么要这样实现？  
    　　在Java 1.8的实现中，是通过hashCode()的高16位异或低16位实现的：(h = k.hashCode()) ^ (h >>> 16)，主要是从速度、功效、质量来考虑的，这么做可以在bucket的n比较小的时候，也能保证考虑到高低bit都参与到hash的计算中，同时不会有太大的开销。

- 如果HashMap的大小超过了负载因子(load factor)定义的容量，怎么办？  
    　　如果超过了负载因子(默认0.75)，则会重新resize一个原来长度两倍的HashMap，并且重新调用hash方法。

#### ConcurrentHashMap 的工作原理及代码实现

### 线程
#### 创建线程的方式及实现
##### Java可以用三种方式来创建线程
- 1）继承Thread类创建线程  
- 2）实现Runnable接口创建线程  
- 3）使用Callable和Future创建线程
  
##### 继承Thread类创建线程
- 1）d定义Thread类的子类，并重写该类的run()方法，该方法的方法体就是线程需要完成的任务，run()方法也称为线程执行体。
- 2）创建Thread子类的实例，也就是创建了线程对象
- 3）启动线程，即调用线程的start()方法

##### 实现Runnable接口创建线程
- 1）定义Runnable接口的实现类，一样要重写run()方法，这个run（）方法和Thread中的run()方法一样是线程的执行体
- 2）创建Runnable实现类的实例，并用这个实例作为Thread的target来创建Thread对象，这个Thread对象才是真正的线程对象
- 3）第三部依然是通过调用线程对象的start()方法来启动线程

##### 使用Callable和Future创建线程
*和Runnable接口不一样，Callable接口提供了一个call（）方法作为线程执行体，call()方法比run()方法功能要强大。*  
》call()方法可以有返回值
》call()方法可以声明抛出异常
Java5提供了Future接口来代表Callable接口里call()方法的返回值，并且为Future接口提供了一个实现类FutureTask，这个实现类既实现了Future接口，还实现了Runnable接口，因此可以作为Thread类的target。在Future接口里定义了几个公共方法来控制它关联的Callable任务。  
>boolean cancel(boolean mayInterruptIfRunning)：视图取消该Future里面关联的Callable任务

>V get()：返回Callable里call（）方法的返回值，调用这个方法会导致程序阻塞，必须等到子线程结束后才会得到返回值

>V get(long timeout,TimeUnit unit)：返回Callable里call（）方法的返回值，最多阻塞timeout时间，经过指定时间没有返回抛出TimeoutException

>boolean isDone()：若Callable任务完成，返回True

>boolean isCancelled()：如果在Callable任务正常完成前被取消，返回True

介绍了相关的概念之后，创建并启动有返回值的线程的步骤如下：  
- 1）创建Callable接口的实现类，并实现call()方法，然后创建该实现类的实例（从java8开始可以直接使用Lambda表达式创建Callable对象）。
- 2）使用FutureTask类来包装Callable对象，该FutureTask对象封装了Callable对象的call()方法的返回值
- 3）使用FutureTask对象作为Thread对象的target创建并启动线程（因为FutureTask实现了Runnable接口）
- 4）调用FutureTask对象的get()方法来获得子线程执行结束后的返回值

代码实例：  
```
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

public class Main {
    public static void main(String[] args) {
        Thread th = new Thread();
        //使用Lambda表达式创建Callable对象
        //使用FutureTask类来包装Callable对象
        FutureTask<Integer> future = new FutureTask<Integer>(
                (Callable<Integer>) () -> {
                    return 5;
                }
        );
        //实质上还是以Callable对象来创建并启动线程
        new Thread(future, "有返回值的线程").start();
        try {
            //get()方法会阻塞，直到子线程执行结束才返回
            System.out.println("子线程的返回值：" + future.get());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

##### 三种创建线程方法对比
　　实现Runnable和实现Callable接口的方式基本相同，不过是后者执行call()方法有返回值，后者线程执行体run()方法无返回值，因此可以把这两种方式归为一种这种方式与继承Thread类的方法之间的差别如下：  
- 1、线程只是实现Runnable或实现Callable接口，还可以继承其他类。  
- 2、这种方式下，多个线程可以共享一个target对象，非常适合多线程处理同一份资源的情形。
- 3、但是编程稍微复杂，如果需要访问当前线程，必须调用Thread.currentThread()方法。
- 4、继承Thread类的线程类不能再继承其他父类（Java单继承决定）。

#### sleep()、 wait()、join()、yield()有什么区别
##### 1.sleep()方法
　　在指定时间内让当前正在执行的线程暂停执行，但不会释放“锁标志”。不推荐使用。  
　　sleep()使当前线程进入阻塞状态，在指定时间内不会执行。  

##### 2.wait()方法
　　在其他线程调用对象的notify或notifyAll方法前，导致当前线程等待。线程会释放掉它所占有的“锁标志”，从而使别的线程有机会抢占该锁。  
　　当前线程必须拥有当前对象锁。如果当前线程不是此锁的拥有者，会抛出IllegalMonitorStateException异常。  
　　唤醒当前对象锁的等待线程使用notify或notifyAll方法，也必须拥有相同的对象锁，否则也会抛出IllegalMonitorStateException异常。  
　　waite()和notify()必须在synchronized函数或synchronized　block中进行调用。如果在non-synchronized函数或non-synchronized　block中进行调用，虽然能编译通过，但在运行时会发生IllegalMonitorStateException的异常。  

##### 3.yield方法
　　暂停当前正在执行的线程对象。  
　　yield()只是使当前线程重新回到可执行状态，所以执行yield()的线程有可能在进入到可执行状态后马上又被执行。  
　　yield()只能使同优先级或更高优先级的线程有执行的机会。   

##### 4.join方法
　　等待该线程终止。  
　　等待调用join方法的线程结束，再继续执行。如：t.join();//主要用于等待t线程运行结束，若无此句，main则会执行完毕，导致结果不可预测。  

##### 5.测试代码
```
public class Test {
    public static void main(String[] args) {
        Thread t1 = new MyThread1();
        t1.start();
        for (int i = 0; i < 20; i++) {
            System.out.println("主线程第" + i + "次执行！");
            if (i > 2) {
                try {
                    //t1线程合并到主线程中，主线程停止执行过程，转而执行t1线程，直到t1执行完毕后继续。
                    t1.join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
class MyThread1 extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            System.out.println("线程1第" + i + "次执行！");
        }
    }
}
```

#### 说说 CountDownLatch 原理
#### 说说 CyclicBarrier 原理
#### 说说 Semaphore 原理
#### 说说 Exchanger 原理
#### 说说 CountDownLatch 与 CyclicBarrier 区别
#### ThreadLocal 原理分析
#### 讲讲线程池的实现原理
#### 线程池的几种方式
#### 线程的生命周期

### 锁机制

#### 说说线程安全问题
判断一个程序存不存在线程安全问题的方法：  
1、 程序运行在多线程环境下吗？  
2、 多线程是否会共享一个资源并且对这个共享资源有读和写操作？  

如何解决线程安全问题:  
1、 将对象设置成无状态的  
2、 使用局部对象  
3、 如果对象中不得不使用属性时，那么可以考虑使用ThreadLocal包装属性，包装后的activeTimer就是一个线程安全的，ThreadLocal实际上是为每个线程都重现创建一个activeTimer对象，各线程用自己的activeTimer，也就避免了线程安全问题，当然导致各线程修改的activeTimer不被共享，需要根据自己的业务特点使用。    
4、 当以上3种办法都不适合的时候，终极大招出来了，使用线程同步技术。把读写共享资源的代码块上把锁，给锁起来，让多线程调用这段代码的时候按顺序来访问，这样就不存在线程安全了。Java中实现线程同步（互斥）的方法主要有两种，使用synchronized和lock。  

#### volatile 实现原理
##### 引言
　　在多线程并发编程中synchronized和Volatile都扮演着重要的角色，Volatile是*轻量级的synchronized*，它在多处理器开发中保证了共享变量的“可见性”。可见性的意思是当一个线程修改一个共享变量时，另外一个线程能读到这个修改的值。它在某些情况下比synchronized的开销更小，本文将深入分析在硬件层面上Inter处理器是如何实现Volatile的，通过深入分析能帮助我们正确的使用Volatile变量。

##### 术语定义
| *术语* | *英文单词* | *描述* |
| :------: | :------: | :------: |
| 共享变量 | Shared variable | 在多个线程之间能够被共享的变量被称为共享变量。共享变量包括所有的实例变量，静态变量和数组元素。他们都被存放在堆内存中，Volatile只作用于共享变量。 |
| 内存屏障 | Memory Barriers | 是一组处理器指令，用于实现对内存操作的顺序限制。 |
| 缓冲行 | Cache line | 缓存中可以分配的最小存储单位。处理器填写缓存线时会加载整个缓存线，需要使用多个主内存读周期。 |
| 原子操作 | Atomic operations | 不可中断的一个或一系列操作。 |
| 缓存行填充 | cache line fill | 当处理器识别到从内存中读取操作数是可缓存的，处理器读取整个缓存行到适当的缓存（L1，L2，L3的或所有） |
| 缓存命中 | cache hit | 如果进行高速缓存行填充操作的内存位置仍然是下次处理器访问的地址时，处理器从缓存中读取操作数，而不是从内存。 |
| 写命中 | write hit | 当处理器将操作数写回到一个内存缓存的区域时，它首先会检查这个缓存的内存地址是否在缓存行中，如果存在一个有效的缓存行，则处理器将这个操作数写回到缓存，而不是写回到内存，这个操作被称为写命中。 |
| 写缺失 | write misses the cache | 一个有效的缓存行被写入到不存在的内存区域。 |

##### Volatile的官方定义
　　Java语言规范第三版中对volatile的定义如下： java编程语言允许线程访问共享变量，为了确保共享变量能被准确和一致的更新，线程应该确保通过排他锁单独获得这个变量。Java语言提供了volatile，在某些情况下比锁更加方便。如果一个字段被声明成volatile，java线程内存模型确保所有线程看到这个变量的值是一致的。

##### 为什么要使用Volatile
　　Volatile变量修饰符如果使用恰当的话，它比synchronized的使用和执行成本会更低，因为它不会引起线程上下文的切换和调度。

##### Volatile的实现原理
　　那么Volatile是如何来保证可见性的呢？在x86处理器下通过工具获取JIT编译器生成的汇编指令来看看对Volatile进行写操作CPU会做什么事情。  
Java代码： 	instance = new Singleton();//instance是volatile变量  
汇编代码： 	0x01a3de1d: movb $0x0,0x1104800(%esi);0x01a3de24: lock addl $0x0,(%esp);  

　　有volatile变量修饰的共享变量进行写操作的时候会多第二行汇编代码，通过查IA-32架构软件开发者手册可知，lock前缀的指令在多核处理器下会引发了两件事情。  

   - 将当前处理器缓存行的数据会写回到系统内存。
   - 这个写回内存的操作会引起在其他CPU里缓存了该内存地址的数据无效。

　　处理器为了提高处理速度，不直接和内存进行通讯，而是先将系统内存的数据读到内部缓存（L1,L2或其他）后再进行操作，但操作完之后不知道何时会写到内存，如果对声明了Volatile变量进行写操作，JVM就会向处理器发送一条Lock前缀的指令，将这个变量所在缓存行的数据写回到系统内存。但是就算写回到内存，如果其他处理器缓存的值还是旧的，再执行计算操作就会有问题，所以在多处理器下，为了保证各个处理器的缓存是一致的，就会实现缓存一致性协议，每个处理器通过嗅探在总线上传播的数据来检查自己缓存的值是不是过期了，当处理器发现自己缓存行对应的内存地址被修改，就会将当前处理器的缓存行设置成无效状态，当处理器要对这个数据进行修改操作的时候，会强制重新从系统内存里把数据读到处理器缓存里。  

　　这两件事情在IA-32软件开发者架构手册的第三册的多处理器管理章节（第八章）中有详细阐述。  

　　Lock前缀指令会引起处理器缓存回写到内存。Lock前缀指令导致在执行指令期间，声言处理器的 LOCK# 信号。在多处理器环境中，LOCK# 信号确保在声言该信号期间，处理器可以独占使用任何共享内存。（因为它会锁住总线，导致其他CPU不能访问总线，不能访问总线就意味着不能访问系统内存），但是在最近的处理器里，LOCK＃信号一般不锁总线，而是锁缓存，毕竟锁总线开销比较大。在8.1.4章节有详细说明锁定操作对处理器缓存的影响，对于Intel486和Pentium处理器，在锁操作时，总是在总线上声言LOCK#信号。但在P6和最近的处理器中，如果访问的内存区域已经缓存在处理器内部，则不会声言LOCK#信号。相反地，它会锁定这块内存区域的缓存并回写到内存，并使用缓存一致性机制来确保修改的原子性，此操作被称为“缓存锁定”，缓存一致性机制会阻止同时修改被两个以上处理器缓存的内存区域数据。  

　　一个处理器的缓存回写到内存会导致其他处理器的缓存无效。IA-32处理器和Intel 64处理器使用MESI（修改，独占，共享，无效）控制协议去维护内部缓存和其他处理器缓存的一致性。在多核处理器系统中进行操作的时候，IA-32 和Intel 64处理器能嗅探其他处理器访问系统内存和它们的内部缓存。它们使用嗅探技术保证它的内部缓存，系统内存和其他处理器的缓存的数据在总线上保持一致。例如在Pentium和P6 family处理器中，如果通过嗅探一个处理器来检测其他处理器打算写内存地址，而这个地址当前处理共享状态，那么正在嗅探的处理器将无效它的缓存行，在下次访问相同内存地址时，强制执行缓存行填充。  

#### synchronize 实现原理

#### synchronized 与 lock 的区别
- 1.首先synchronized是java内置关键字，在jvm层面，Lock是个java类；  
- 2.synchronized无法判断是否获取锁的状态，Lock可以判断是否获取到锁；  
- 3.synchronized会自动释放锁(a 线程执行完同步代码会释放锁 ；b 线程执行过程中发生异常会释放锁)，Lock需在finally中手工释放锁（unlock()方法释放锁），否则容易造成线程死锁；  
- 4.用synchronized关键字的两个线程1和线程2，如果当前线程1获得锁，线程2线程等待。如果线程1阻塞，线程2则会一直等待下去，而Lock锁就不一定会等待下去，如果尝试获取不到锁，线程可以不用一直等待就结束了；  
- 5.synchronized的锁可重入、不可中断、非公平，而Lock锁可重入、可判断、可公平（两者皆可）  
- 6.Lock锁适合大量同步的代码的同步问题，synchronized锁适合代码少量的同步问题。  

#### CAS 乐观锁
#### ABA 问题
#### 乐观锁的业务场景及实现方式

## 核心篇

### 数据存储
#### MySQL 索引使用的注意事项
　　MySQL 索引通常是被用于提高 WHERE 条件的数据行匹配时的搜索速度，在索引的使用过程中，存在一些使用细节和注意事项。  

##### 不要在列上使用函数和进行运算
不要在列上使用函数，这将导致索引失效而进行全表扫描。  

    select * from news where year(publish_time) < 2017

为了使用索引，防止执行全表扫描，可以进行改造。  

    select * from news where publish_time < '2017-01-01'

还有一个建议，不要在列上进行运算，这也将导致索引失效而进行全表扫描。  

    select * from news where id / 100 = 1

为了使用索引，防止执行全表扫描，可以进行改造。  

    select * from news where id = 1 * 100

##### 尽量避免使用 != 或 not in或 <> 等否定操作符
　　应该尽量避免在 where 子句中使用 != 或 not in 或 <> 操作符，因为这几个操作符都会导致索引失效而进行全表扫描。  

##### 尽量避免使用 or 来连接条件
　　应该尽量避免在 where 子句中使用 or 来连接条件，因为这会导致索引失效而进行全表扫描。  

    select * from news where id = 1 or id = 2

##### 多个单列索引并不是最佳选择
　　MySQL 只能使用一个索引，会从多个索引中选择一个限制最为严格的索引，因此，为多个列创建单列索引，并不能提高 MySQL 的查询性能。  
　　假设，有两个单列索引，分别为 news_year_idx(news_year) 和 news_month_idx(news_month)。现在，有一个场景需要针对资讯的年份和月份进行查询，那么，SQL 语句可以写成：  

    select * from news where news_year = 2017 and news_month = 1

　　事实上，MySQL 只能使用一个单列索引。为了提高性能，可以使用复合索引 news_year_month_idx(news_year, news_month) 保证 news_year 和 news_month 两个列都被索引覆盖。  

##### 复合索引的最左前缀原则
　　复合索引遵守“最左前缀”原则，即在查询条件中使用了复合索引的第一个字段，索引才会被使用。因此，在复合索引中索引列的顺序至关重要。如果不是按照索引的最左列开始查找，则无法使用索引。  
　　假设，有一个场景只需要针对资讯的月份进行查询，那么，SQL 语句可以写成：  

    select * from news where news_month = 1

　　此时，无法使用 news_year_month_idx(news_year, news_month) 索引，因为遵守“最左前缀”原则，在查询条件中没有使用复合索引的第一个字段，索引是不会被使用的。  

##### 覆盖索引的好处
　　如果一个索引包含所有需要的查询的字段的值，直接根据索引的查询结果返回数据，而无需读表，能够极大的提高性能。因此，可以定义一个让索引包含的额外的列，即使这个列对于索引而言是无用的。  

##### 范围查询对多列查询的影响
　　查询中的某个列有范围查询，则其右边所有列都无法使用索引优化查找。  
　　举个例子，假设有一个场景需要查询本周发布的资讯文章，其中的条件是必须是启用状态，且发布时间在这周内。那么，SQL 语句可以写成：  

    select * from news where publish_time >= '2017-01-02' and publish_time <= '2017-01-08' and enable = 1

　　这种情况下，因为范围查询对多列查询的影响，将导致 news_publish_idx(publish_time, enable) 索引中 publish_time 右边所有列都无法使用索引优化查找。换句话说，news_publish_idx(publish_time, enable) 索引等价于 news_publish_idx(publish_time) 。  
　　对于这种情况，我的建议：对于范围查询，务必要注意它带来的副作用，并且尽量少用范围查询，可以通过曲线救国的方式满足业务场景。  
　　例如，上面案例的需求是查询本周发布的资讯文章，因此可以创建一个news_weekth 字段用来存储资讯文章的周信息，使得范围查询变成普通的查询，SQL 可以改写成：  

    select * from news where     news_weekth = 1 and enable = 1

　　然而，并不是所有的范围查询都可以进行改造，对于必须使用范围查询但无法改造的情况，我的建议：不必试图用 SQL 来解决所有问题，可以使用其他数据存储技术控制时间轴，例如 Redis 的 SortedSet 有序集合保存时间，或者通过缓存方式缓存查询结果从而提高性能。  

##### 索引不会包含有NULL值的列
　　只要列中包含有 NULL 值都将不会被包含在索引中，复合索引中只要有一列含有 NULL值，那么这一列对于此复合索引就是无效的。  
　　因此，在数据库设计时，除非有一个很特别的原因使用 NULL 值，不然尽量不要让字段的默认值为 NULL。  

##### 隐式转换的影响
　　当查询条件左右两侧类型不匹配的时候会发生隐式转换，隐式转换带来的影响就是可能导致索引失效而进行全表扫描。下面的案例中，date_str 是字符串，然而匹配的是整数类型，从而发生隐式转换。  

    select * from news where date_str = 201701    

　　因此，要谨记隐式转换的危害，时刻注意通过同类型进行比较。  

##### like 语句的索引失效问题
　　like 的方式进行查询，在 like “value%” 可以使用索引，但是对于 like “%value%” 这样的方式，执行全表查询，这在数据量小的表，不存在性能问题，但是对于海量数据，全表扫描是非常可怕的事情。所以，根据业务需求，考虑使用 ElasticSearch 或 Solr 是个不错的方案。  

#### 说说反模式设计
　　数据库范式是为解决关系数据库中数据冗余、更新异常、插入异常、删除异常问题而引入的。简单的理解，数据库范式可以避免数据冗余，减少数据库的空间，并且减轻维护数据完整性的麻烦。

##### 第一范式（1NF）
　　第一范式，强调属性的原子性约束，要求属性具有原子性，不可再分解。  
　　举个例子，活动表（活动编码，活动名称，活动地址），假设这个场景中，活动地址可以细分为国家、省份、城市、市区、位置，那么就没有达到第一范式。  

##### 第二范式（2NF）
　　第二范式，强调记录的唯一性约束，表必须有一个主键，并且没有包含在主键中的列必须完全依赖于主键，而不能只依赖于主键的一部分。  
　　举个例子，版本表（版本编码，版本名称，产品编码，产品名称），其中主键是（版本编码，产品编码），这个场景中，数据库设计并不符合第二范式，因为产品名称只依赖于产品编码。存在部分依赖。所以，为了使其满足第二范式，可以改造成两个表：版本表（版本编码，产品编码）和产品表（产品编码，产品名称）。  

##### 第三范式（3NF）
　　第三范式，强调属性冗余性的约束，即非主键列必须直接依赖于主键。  
　　举个例子，订单表（订单编码，顾客编码，顾客名称），其中主键是（订单编码），这个场景中，顾客编码、顾客名称都完全依赖于主键，因此符合第二范式，但是顾客名称依赖于顾客编码，从而间接依赖于主键，所以不能满足第三范式。为了使其满足第三范式，可以拆分两个表：订单表（订单编码，顾客编码）和顾客表（顾客编码，顾客名称），拆分后的数据库设计，就可以完全满足第三范式的要求了。  
　　值得注意的是，第二范式的侧重点是非主键列是否完全依赖于主键，还是依赖于主键的一部分。第三范式的侧重点是非主键列是直接依赖于主键，还是直接依赖于非主键列。  

##### 反模式
　　范式可以避免数据冗余，减少数据库的空间，减轻维护数据完整性的麻烦。  
　　然而，通过数据库范式化设计，将导致数据库业务涉及的表变多，并且可能需要将涉及的业务表进行多表连接查询，这样将导致性能变差，且不利于分库分表。因此，出于性能优先的考量，可能在数据库的结构中需要使用反模式的设计，即空间换取时间，采取数据冗余的方式避免表之间的关联查询。至于数据一致性问题，因为难以满足数据强一致性，一般情况下，使存储数据尽可能达到用户一致，保证系统经过一段较短的时间的自我恢复和修正，数据最终达到一致。  
　　需要谨慎使用反模式设计数据库。一般情况下，尽可能使用范式化的数据库设计，因为范式化的数据库设计能让产品更加灵活，并且能在数据库层保持数据完整性。  
　　有的时候，提升性能最好的方法是在同一表中保存冗余数据，如果能容许少量的脏数据，创建一张完全独立的汇总表或缓存表是非常好的方法。举个例子，设计一张“下载次数表”来缓存下载次数信息，可使在海量数据的情况下，提高查询总数信息的速度。  
　　另外一个比较典型的场景，出于扩展性考虑，可能会使用 BLOB 和 TEXT 类型的列存储 JSON 结构的数据，这样的好处在于可以在任何时候，将新的属性添加到这个字段中，而不需要更改表结构。但是，这个设计的缺点也比较明显，就是需要获取整个字段内容进行解码来获取指定的属性，并且无法进行索引、排序、聚合等操作。因此，如果需要考虑更加复杂的使用场景，更加建议使用 MongoDB 这样的文档型数据库。  

#### 说说分库与分表设计
　　面对海量数据，例如，上千万甚至上亿的数据，查询一次所花费的时间会变长，甚至会造成数据库的单点压力。因此，分库与分表的目的在于，减小数据库的单库单表负担，提高查询性能，缩短查询时间。  

##### 分表概述
　　随着用户数的不断增加，以及数据量的不断增加，会使得单表压力越来越大，面对上千万甚至上亿的数据，查询一次所花费的时间会变长，如果有联合查询的情况下，甚至可能会成为很大的瓶颈。此外，MySQL 存在表锁和行锁，因此更新表数据可能会引起表锁或者行锁，这样也会导致其他操作等待，甚至死锁问题。  
　　通过分表，可以减少数据库的单表负担，将压力分散到不同的表上，同时因为不同的表上的数据量少了，起到提高查询性能，缩短查询时间的作用，此外，可以很大的缓解表锁的问题。  
　　分表策略可以归纳为垂直拆分和水平拆分。  
　　垂直拆分，把表的字段进行拆分，即一张字段比较多的表拆分为多张表，这样使得行数据变小。一方面，可以减少客户端程序和数据库之间的网络传输的字节数，因为生产环境共享同一个网络带宽，随着并发查询的增多，有可能造成带宽瓶颈从而造成阻塞。另一方面，一个数据块能存放更多的数据，在查询时就会减少 I/O 次数。举个例子，假设用户表中有一个字段是家庭地址，这个字段是可选字段，在数据库操作的时候除了个人信息外，并不需要经常读取或是更改这个字段的值。在这种情况下，更建议把它拆分到另外一个表，从而提高性能。  
　　如何设计好垂直拆分，我的建议：  
    - 将不常用的字段单独拆分到另外一张扩展表，例如前面讲解到的用户家庭地址，这个字段是可选字段，在数据库操作的时候除了个人信息外，并不需要经常读取或是更改这个字段的值。
    - 将大文本的字段单独拆分到另外一张扩展表，例如 BLOB 和 TEXT 字符串类型的字段，以及 TINYBLOB、 MEDIUMBLOB、 LONGBLOB、 TINYTEXT、 MEDIUMTEXT、 LONGTEXT字符串类型。这样可以减少客户端程序和数据库之间的网络传输的字节数。
    - 将不经常修改的字段放在同一张表中，将经常改变的字段放在另一张表中。举个例子，假设用户表的设计中，还存在“最后登录时间”字段，每次用户登录时会被更新。这张用户表会存在频繁的更新操作，此外，每次更新时会导致该表的查询缓存被清空。所以，可以把这个字段放到另一个表中，这样查询缓存会增加很多性能。
    - 对于需要经常关联查询的字段，建议放在同一张表中。不然在联合查询的情况下，会带来数据库额外压力。
    
　　水平拆分，把表的行进行拆分。因为表的行数超过几百万行时，就会变慢，这时可以把一张的表的数据拆成多张表来存放。水平拆分，有许多策略，例如，取模分表，时间维度分表，以及自定义 Hash 分表，例如用户 ID 维度分表等。在不同策略分表情况下，根据各自的策略写入与读取。  
　　实际上，垂直拆分后的表依然存在单表数据量过大的问题，需要进行水平拆分。因此，实际情况中，水平拆分往往会和垂直拆分结合使用。假设，随着用户数的不断增加，用户表单表存在上千万的数据，这时可以把一张用户表的数据拆成多张用户表来存放。  
　　常见的水平分表策略归纳起来，可以总结为随机分表和连续分表两种情况。例如，取模分表就属于随机分表，而时间维度分表则属于连续分表。  
　　连续分表可以快速定位到表进行高效查询，大多数情况下，可以有效避免跨表查询。如果想扩展，只需要添加额外的分表就可以了，无需对其他分表的数据进行数据迁移。但是，连续分表有可能存在数据热点的问题，有些表可能会被频繁地查询从而造成较大压力，热数据的表就成为了整个库的瓶颈，而有些表可能存的是历史数据，很少需要被查询到。  
　　随机分表是遵循规则策略进行写入与读取，而不是真正意义上的随机。通常，采用取模分表或者自定义 Hash 分表的方式进行水平拆分。随机分表的数据相对比较均匀，不容易出现热点和并发访问的瓶颈。但是，分表扩展需要迁移旧的数据。此外，随机分表比较容易面临跨表查询的复杂问题。  
　　对于日志场景，可以考虑根据时间维度分表，例如年份维度分表或者月份维度分表，在日志记录表的名字中包含年份和月份的信息，例如 log_2017_01，这样可以在已经没有新增操作的历史表上做频繁地查询操作，而不会影响时间维度分表上新增操作。  
　　对于海量用户场景，可以考虑取模分表，数据相对比较均匀，不容易出现热点和并发访问的瓶颈。  
　　对于租户场景，可以考虑租户维度分表，不同的租户数据独立，而不应该在每张表中添加租户 ID，这是一个不错的选择。  

##### 分库概述
　　库内分表，仅仅是解决了单表数据过大的问题，但并没有把单表的数据分散到不同的物理机上，因此并不能减轻 MySQL 服务器的压力，仍然存在同一个物理机上的资源竞争和瓶颈，包括 CPU、内存、磁盘 IO、网络带宽等。  
　　分库策略也可以归纳为垂直拆分和水平拆分。  
　　垂直拆分，按照业务和功能划分，把数据分别放到不同的数据库中。举个例子，可以划分资讯库、百科库等。  
　　水平拆分，把一张表的数据划分到不同的数据库，两个数据库的表结构一样。实际上，水平分库与水平分表类似，水平拆分有许多策略，例如，取模分库，自定义 Hash 分库等，在不同策略分库情况下，根据各自的策略写入与读取。举个例子，随着业务的增长，资讯库的单表数据过大，此时采取水平拆分策略，根据取模分库。  

#### 分库与分表带来的分布式困境与应对之策
　　随着用户数的不断增加，以及数据量的不断增加，通过分库与分表的方式提高查询性能的同时，带来了一系列分布式困境。

##### 数据迁移与扩容问题
　　前面介绍到水平分表策略归纳总结为随机分表和连续分表两种情况。连续分表有可能存在数据热点的问题，有些表可能会被频繁地查询从而造成较大压力，热数据的表就成为了整个库的瓶颈，而有些表可能存的是历史数据，很少需要被查询到。连续分表的另外一个好处在于比较容易，不需要考虑迁移旧的数据，只需要添加分表就可以自动扩容。随机分表的数据相对比较均匀，不容易出现热点和并发访问的瓶颈。但是，分表扩展需要迁移旧的数据。  
　　针对于水平分表的设计至关重要，需要评估中短期内业务的增长速度，对当前的数据量进行容量规划，综合成本因素，推算出大概需要多少分片。对于数据迁移的问题，一般做法是通过程序先读出数据，然后按照指定的分表策略再将数据写入到各个分表中。  

##### 表关联问题
　　在单库单表的情况下，联合查询是非常容易的。但是，随着分库与分表的演变，联合查询就遇到跨库关联和跨表关系问题。在设计之初就应该尽量避免联合查询，可以通过程序中进行拼装，或者通过反范式化设计进行规避。  

##### 分页与排序问题
　　一般情况下，列表分页时需要按照指定字段进行排序。在单库单表的情况下，分页和排序也是非常容易的。但是，随着分库与分表的演变，也会遇到跨库排序和跨表排序问题。为了最终结果的准确性，需要在不同的分表中将数据进行排序并返回，并将不同分表返回的结果集进行汇总和再次排序，最后再返回给用户。  

##### 分布式事务问题
　　随着分库与分表的演变，一定会遇到分布式事务问题，那么如何保证数据的一致性就成为一个必须面对的问题。目前，分布式事务并没有很好的解决方案，难以满足数据强一致性，一般情况下，使存储数据尽可能达到用户一致，保证系统经过一段较短的时间的自我恢复和修正，数据最终达到一致。  

##### 分布式全局唯一ID
　　在单库单表的情况下，直接使用数据库自增特性来生成主键ID，这样确实比较简单。在分库分表的环境中，数据分布在不同的分表上，不能再借助数据库自增长特性。需要使用全局唯一 ID，例如 UUID、GUID等。关于如何选择合适的全局唯一 ID，我会在后面的章节中进行介绍。  

##### 总结
　　分库与分表主要用于应对当前互联网常见的两个场景：海量数据和高并发。然而，分库与分表是一把双刃剑，虽然很好的应对海量数据和高并发对数据库的冲击和压力，但是却提高的系统的复杂度和维护成本。  
　　因此，我的建议：需要结合实际需求，不宜过度设计，在项目一开始不采用分库与分表设计，而是随着业务的增长，在无法继续优化的情况下，再考虑分库与分表提高系统的性能。  

#### 说说 SQL 优化之道
　　改善性能最好的方式，就是通过数据库中合理地使用索引，换句话说，索引是提高 MySQL 数据库查询性能的主要手段。在下面的章节中，介绍了索引类型、强制索引、全文索引。  

##### 基本索引类型
　　MySQL 索引可以分为单列索引、复合索引、唯一索引、主键索引等。这里，将为读者介绍这几种索引的特点。  

##### 单列索引
　　单列索引：单列索引是最基本的索引，它没有任何限制。    
　　创建一个单列索引，例如：  

    create index index_name on tbl_name(index_col_name);

　　同时，也可以通过修改表结构的方式添加索引，例如：    

    alter table tbl_name add index index_name on (index_col_name);

##### 复合索引
　　复合索引：复合索引是在多个字段上创建的索引。复合索引遵守“最左前缀”原则，即在查询条件中使用了复合索引的第一个字段，索引才会被使用。因此，在复合索引中索引列的顺序至关重要。  
　　创建一个复合索引，例如：  

    create index index_name on tbl_name(index_col_name,...);

　　同时，也可以通过修改表结构的方式添加索引，例如：

    alter table tbl_name add index index_name on (index_col_name,...);

##### 唯一索引
　　唯一索引：唯一索引和单列索引类似，主要的区别在于，唯一索引限制列的值必须唯一，但允许有空值。对于多个字段，唯一索引规定列值的组合必须唯一。  
　　创建一个复合索引，例如：  

    create unique index index_name on tbl_name(index_col_name,...);

　　同时，也可以通过修改表结构的方式添加索引，例如：  

    alter table tbl_name add unique index index_name on (index_col_name,...);

##### 主键索引
　　主键索引：主键索引是一种特殊的唯一索引，不允许有空值。此外， CREATE INDEX 不能创建主键索引，需要使用 ALTER TABLE 代替，例如：  

    alter table tbl_name add primary key(index_col_name);

##### 强制索引

　　有时，因为使用 MySQL 的优化器机制，原本应该使用索引的优化器，反而选择执行全表扫描或者执行的不是预期的索引。此时，可以通过强制索引的方式引导优化器采取正确的执行计划。

　　使用强制索引，SQL 语句只使用建立在 index_col_name 上的索引，而不使用其它的索引。  

    select * from tbl_name force index (index_col_name) …

　　切记，不要滥用强制索引，因为 MySQL 的优化器会同时评估 I/O 和 CPU 的成本，一般情况下，可以自动分析选择最合适的索引。  
　　如果优化器成本评估错误，因而没有选择最佳方案，最好的方法应该是将合适的索引修改得更好。  
　　如果某个 SQL 语句使用强制索引，需要在系统迭代开发过程中时时维护强制索引，一方面，需要保证使用的强制索引最优，另外一面，需要保证所使用的强制索引不能被误删，不然将导致 SQL 报错。  
　　因此，如果某个 SQL 语句必须要使用强制索引，建议在团队内部开展严格地评审后才可以使用。  

##### 全文索引
　　在一般情况下，模糊查询都是通过 like 的方式进行查询。但是，对于海量数据，这并不是一个好办法，在 like “value%” 可以使用索引，但是对于 like “%value%” 这样的方式，执行全表查询，这在数据量小的表，不存在性能问题，但是对于海量数据，全表扫描是非常可怕的事情,所以 like 进行模糊匹配性能很差。  
　　这种情况下，需要考虑使用全文搜索的方式进行优化。全文搜索在 MySQL 中是一个 FULLTEXT 类型索引。 FULLTEXT 索引在 MySQL 5.6 版本之后支持 InnoDB，而之前的版本只支持 MyISAM 表。  
　　假设，有一张应用全文索引表。  

    CREATE TABLE IF NOT EXISTS `app_full_text` (
      `app_id` bigint(20) NOT NULL,
      `app_name_full_text` text NOT NULL,
      `introduce_full_text` text NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

　　现在需要对应用的名称创建全文索引，可以这么设计。  

    alter table `app_full_text` add fulltext key `app_name_intro` (`app_name_full_text`);

　　默认 MySQL 不支持中文全文检索，对此，网上的方案很多，例如添加 MySQL 扩展，或者将内容转换成拼音的方式存储在索引表，或者使用 IKAnalyzer 分词库等，其效果都不是非常的理想。使用拼音分词，虽然可以查询到内容，但是如果拼音相同的情况，是非常致命的，而且分词的粒度也是个很可怕的问题。使用 IKAnalyzer 分词库，效果也不是很好。因为业务的需要，命中率也是非常重要的，有的关键字没有进行分词导致查询不到的问题。  
　　我之前的临时解决方案。如下：  

    为中文内容表提供一个全文索引表，存储全文索引分词信息，两张表根据中文内容表的 ID 进行关联。
    将内容进行分词后，用 base64 编码，保存在全文索引表中。
    关键的一步，如何分词，分词的命中率问题。很简单，自定义分词库，写一个分词算法将所有的组合进行分词，在内容不多的情况下非常有用。举个例子，“梁桂钊”，可以进行自定义分词：[梁、桂、钊、梁桂、桂钊、梁桂钊]。

　　事实上，MySQL 全文搜索只是一个临时方案，对于全文搜索场景，更专业的做法是使用全文搜索引擎，例如 ElasticSearch 或 Solr。  

#### MySQL 遇到的死锁问题
#### 存储引擎的 InnoDB 与 MyISAM
　　作为 MySQL 数据库的两种主要的存储引擎，InnoDB 与 MyISAM 各有长处。  
　　在 MySQL 5.1 及之前的版本中，MyISAM 是默认的存储引擎，而在 MySQL 5.5 版本以后，默认使用 InnoDB 存储引擎。  
　　MyISAM 不支持行级锁，换句话说，MyISAM 会对整张表加锁，而不是针对行。同时，MyISAM 不支持事务和外键。MyISAM 可被压缩，存储空间较小，而且 MyISAM 在筛选大量数据时非常快。  
　　InnoDB 是事务型引擎，当事务异常提交时，会被回滚。同时，InnoDB 支持行锁。此外，InnoDB 需要更多存储空间，会在内存中建立其专用的缓冲池用于高速缓冲数据和索引。InnoDB 支持自动奔溃恢复特性。  
　　InnoDB 与 MyISAM 的主要区别  
| *方面* | *MyISAM* | *InnoDB* |
| :------: | :------: | :------: |
| 事务 | 不支持 | 支持 |
| 外键 | 不支持 | 支持 |
| 行级锁 | 不支持 | 支持 |
| 自动奔溃恢复 | 不支持 | 支持 |

#### 数据库索引的原理
#### 为什么要用 B-tree
#### 聚集索引与非聚集索引的区别
#### limit 20000 加载很慢怎么解决
#### 选择合适的分布式主键方案
#### 选择合适的数据存储方案
　　在服务端会经常遇到数据存储的选型问题，是选择使用关系型数据库 MySQL，还是选择内存数据库 Redis，还是选择文档数据库 MongoDB，还是选择列族数据库 HBase， 还是选择全文搜索引擎 ElasticSearch 呢？本节主要介绍如何选择合适的数据存储方案。　　

##### 关系型数据库 MySQL
　　MySQL 是一个最流行的关系型数据库，在互联网产品中应用比较广泛。一般情况下，MySQL 数据库是选择的第一方案，基本上有 80% ~ 90% 的场景都是基于 MySQL 数据库的。因为，需要关系型数据库进行管理，此外，业务存在许多事务性的操作，需要保证事务的强一致性。同时，可能还存在一些复杂的 SQL 的查询。值得注意的是，前期尽量减少表的联合查询，便于后期数据量增大的情况下，做数据库的分库分表。  

##### 内存数据库 Redis
　　随着数据量的增长，MySQL 已经满足不了大型互联网类应用的需求。因此，Redis 基于内存存储数据，可以极大的提高查询性能，对产品在架构上很好的补充。例如，为了提高服务端接口的访问速度，尽可能将读频率高的热点数据存放在 Redis 中。这个是非常典型的以空间换时间的策略，使用更多的内存换取 CPU 资源，通过增加系统的内存消耗，来加快程序的运行速度。  
　　在某些场景下，可以充分的利用 Redis 的特性，大大提高效率。这些场景包括缓存，会话缓存，时效性，访问频率，计数器，社交列表，记录用户判定信息，交集、并集和差集，热门列表与排行榜，最新动态等。  
　　使用 Redis 做缓存的时候，需要考虑数据不一致与脏读、缓存更新机制、缓存可用性、缓存服务降级、缓存穿透、缓存预热等缓存使用问题。  

##### 文档数据库 MongoDB
　　MongoDB 是对传统关系型数据库的补充，它非常适合高伸缩性的场景，它是可扩展性的表结构。基于这点，可以将预期范围内，表结构可能会不断扩展的 MySQL 表结构，通过 MongoDB 来存储，这就可以保证表结构的扩展性。  
　　此外，日志系统数据量特别大，如果用 MongoDB 数据库存储这些数据，利用分片集群支持海量数据，同时使用聚集分析和 MapReduce 的能力，是个很好的选择。  
　　MongoDB 还适合存储大尺寸的数据，GridFS 存储方案就是基于 MongoDB 的分布式文件存储系统。  

##### 列族数据库 HBase
　　HBase 适合海量数据的存储与高性能实时查询，它是运行于 HDFS 文件系统之上，并且作为 MapReduce 分布式处理的目标数据库，以支撑离线分析型应用。在数据仓库、数据集市、商业智能等领域发挥了越来越多的作用，在数以千计的企业中支撑着大量的大数据分析场景的应用。  

##### 全文搜索引擎 ElasticSearch
　　在一般情况下，关系型数据库的模糊查询，都是通过 like 的方式进行查询。其中，like “value%” 可以使用索引，但是对于 like “%value%” 这样的方式，执行全表查询，这在数据量小的表，不存在性能问题，但是对于海量数据，全表扫描是非常可怕的事情。ElasticSearch 作为一个建立在全文搜索引擎 Apache Lucene 基础上的实时的分布式搜索和分析引擎，适用于处理实时搜索应用场景。此外，使用 ElasticSearch 全文搜索引擎，还可以支持多词条查询、匹配度与权重、自动联想、拼写纠错等高级功能。因此，可以使用 ElasticSearch 作为关系型数据库全文搜索的功能补充，将要进行全文搜索的数据缓存一份到 ElasticSearch 上，达到处理复杂的业务与提高查询速度的目的。  
　　ElasticSearch 不仅仅适用于搜索场景，还非常适合日志处理与分析的场景。著名的 ELK 日志处理方案，由 ElasticSearch、Logstash 和 Kibana 三个组件组成，包括了日志收集、聚合、多维度查询、可视化显示等。  

#### ObjectId 规则
#### 聊聊 MongoDB 使用场景
#### 倒排索引
#### 聊聊 ElasticSearch 使用场景

### 缓存使用

#### Redis 有哪些类型
　　一共有5种类型：string、list、set、sorted set、hash。  

##### string类型
　　string为最简单类型，一个key对应一个value  
```
set mykey "wangzai"             ##设置key，第二次赋值会直接覆盖之前的
setnx mykey "wangzai"           ## 如果mykey存在，则不改变，如果不存在，则创建赋值   
get mykey                       ##获取key的值
setex key1 10 1                 ##给key1设置过期时间为10s，值为1
mset key1 value1 key2 value2    ##设置多个key
mget key1 key2                  ##获取多个key的值
```

##### list类型
　　list是一个链表结构，主要功能是push、pop以及获取一个范围的所有值等。  
　　使用list结构，可以轻松实现最新消息排行，另一个应用是消息队列，可以利用list的push操作，将任务存在list中，然后工作线程再用pop操作将任务取出进行执行。（先进后出）  
```
lpush list1 "wangzai"                   ##在列表中加入一个元素    
lrange list1 0 -1                       ##查看list1里面的所有元素
lpop list1                              ##取出list1最新的元素
linsert list1 before "wangzai" "doubi"  ##在值为"wangzai"的前面插入一个元素为"doubi"
lset list1 3 "hehe"                     ##把第五个元素修改为"hehe"
lindex list1 0                          ##查看第一个元素
llen list1                              ##查看列表中有多少元素
```

##### set类型
　　set是集合，对集合操作有添加删除元素，有对多个集合求交并差等操作。在微博应用中，可以将一个用户关注的所有人放在一个集合里，将所有粉丝放在一个集合里，因为redis为集合提供了求交集、并集、差集等操作，就可以方便的实现如共同关注、共同喜好等功能。  
```
sadd set1 a b c d                      ## 创建集合set1并设置值
smembers set1                          ## 查看集合set1的值
srem set1 a b                          ## 删除set1的值
spop set1                              ## 随机取出一个元素并删除
sinter set1 set2                       ## 交集
sinterstore set1 set2 set3             ## 将交集存储到set3 
sunion set1 set2                       ## 并集
sunionstore set1 set2 set3             ## 把并集存储到set3  
sdiff set1 set2                        ## 差集
sdiffstore set1 set2 set3              ## 把差集存储到set3
sismember set1 c                       ## 判断一个元素是否属于一个集合
srandmember set1                       ## 随机取出一个元素，但不删除
```

##### sorted set类型
　　sorted set是有序集合，比set多了一个权重参数score，使得集合元素能够按score进行有序排列。  
　　例如存储一个班级同学的成绩，其集合value可以是同学的学号，而score可以是其考试的得分，这样在数据插入集合的时候就进行了排序。  
```
zadd zset1 1 a                  ## 增加一个集合zset1,score为1，member为a
zrange zset1 0 -1               ## 按score升序输出member
zrange zset1 0 -1 withscores    ## 带上分值
zrem zset1 a                    ## 删除指定元素
zrank zset1 a                   ## 返回元素的索引值，索引从0开始
zrevrange zset1 0 -1            ## score降序输出member
zcard zset1                     ## 返回集合中所有元素的个数
zcount zset1 1 10               ## 返回分值范围1-10的元素个数
zrangebyscore zset1 1 10        ## 返回分值范围1-10的元素
zremrangebyscore zset1 1 10     ## 删除分值范围1-10的元素
```

##### hash类型
　　把一些结构化的信息打包成hashmap，在客户端序列化后存储为一个字符串的值（一般为json格式），比如用户姓名、年龄、性别等  
```
hset hash1 name wangzai                  ## 建立hash (hset name key value)
hget hash1 name                          ## 获取field值  HGET name key
hgetall hash1                            ## 获取hash1中所有的key和value
hmset hash2 name wangzai age 26 job it   ## 批量建立键值对
hmget hash2 name age job                 ## 批量获取field值
hdel hash2 job                           ## 删除指定field
hkeys hash2                              ## 打印所有的key
hvals hash2                              ## 打印所有的value
hlen hash2                               ## 查看hash2有几个field
```

#### Redis 内部结构
　　Redis数据结构：简单动态字符串，双向链表，字典  

#### Redis 内存淘汰机制
#### 聊聊 Redis 使用场景
#### Redis 持久化机制
#### Redis 如何实现持久化
#### Redis 集群方案与实现
#### Redis 为什么是单线程的
#### 缓存奔溃
#### 缓存降级
#### 使用缓存的合理性问题

### 消息队列
#### 消息队列的使用场景
#### 消息的重发补偿解决思路
#### 消息的幂等性解决思路
#### 消息的堆积解决思路
#### 自己如何实现消息队列
#### 如何保证消息的有序性

## 框架篇

### Spring
#### BeanFactory 和 ApplicationContext 有什么区别
BeanFactory：  
　　是Spring里面最低层的接口，提供了最简单的容器的功能，只提供了实例化对象和拿对象的功能；  
　　BeanFactory负责读取bean配置文档，管理bean的加载，实例化，维护bean之间的依赖关系，负责bean的声明周期。
ApplicationContext：  
　　应用上下文，继承BeanFactory接口，它是Spring的一各更高级的容器，提供了更多的有用的功能；  
    1) 国际化（MessageSource）  
    2) 访问资源，如URL和文件（ResourceLoader）  
    3) 载入多个（有继承关系）上下文 ，使得每一个上下文都专注于一个特定的层次，比如应用的web层    
    4) 消息发送、响应机制（ApplicationEventPublisher）  
    5) AOP（拦截器）  

#### Spring Bean 的生命周期
1. 实例化一个Bean，也就是我们通常说的new
2. 按照Spring上下文对实例化的Bean进行配置，也就是IOC注入
3. 如果这个Bean实现了BeanNameAware接口，会调用它实现的setBeanName(String beanId)方法，此处传递的是Spring配置文件中Bean的ID
4. 如果这个Bean实现了BeanFactoryAware接口，会调用它实现的setBeanFactory()，传递的是Spring工厂本身（可以用这个方法获取到其他Bean）
5. 如果这个Bean实现了ApplicationContextAware接口，会调用setApplicationContext(ApplicationContext)方法，传入Spring上下文，该方式同样可以实现步骤4，但比4更好，以为ApplicationContext是BeanFactory的子接口，有更多的实现方法
6. 如果这个Bean关联了BeanPostProcessor接口，将会调用postProcessBeforeInitialization(Object obj, String s)方法，BeanPostProcessor经常被用作是Bean内容的更改，并且由于这个是在Bean初始化结束时调用After方法，也可用于内存或缓存技术
7. 如果这个Bean在Spring配置文件中配置了init-method属性会自动调用其配置的初始化方法
8. 如果这个Bean关联了BeanPostProcessor接口，将会调用postAfterInitialization(Object obj, String s)方法
注意：以上工作完成以后就可以用这个Bean了，那这个Bean是一个single的，所以一般情况下我们调用同一个ID的Bean会是在内容地址相同的实例
9. 当Bean不再需要时，会经过清理阶段，如果Bean实现了DisposableBean接口，会调用其实现的destroy方法
10. 最后，如果这个Bean的Spring配置中配置了destroy-method属性，会自动调用其配置的销毁方法 

#### Spring IOC 如何实现
　　IOC容器就是具有依赖注入功能的容器，IOC容器负责实例化、定位、配置应用程序中的对象及建立这些对象间的依赖。应用程序无需直接在代码中new相关的对象，应用程序由IOC容器进行组装。在Spring中BeanFactory是IOC容器的实际代表者。

#### 说说 Spring AOP
　　面向切面编程的目标就是分离关注点。什么是关注点呢？就是你要做的事，就是关注点。
　　
#### Spring AOP 实现原理
#### 动态代理（cglib 与 JDK）
#### Spring 事务实现方式
#### Spring 事务底层原理
#### 如何自定义注解实现功能
#### Spring MVC 运行流程
#### Spring MVC 启动流程
#### Spring 的单例实现原理
#### Spring 框架中用到了哪些设计模式
#### Spring 其他产品（Spring Boot、Spring Cloud、Spring Security、Spring Data、Spring AMQP 等）

### Netty

#### 为什么选择 Netty
#### 说说业务中，Netty 的使用场景
#### 原生的 NIO 在 JDK 1.7 版本存在 epoll bug
#### 什么是TCP 粘包/拆包
#### TCP粘包/拆包的解决办法
#### Netty 线程模型
#### 说说 Netty 的零拷贝
#### Netty 内部执行流程
#### Netty 重连实现

## 微服务篇

### 微服务
#### 前后端分离是如何做的
#### 微服务哪些框架
#### 你怎么理解 RPC 框架
#### 说说 RPC 的实现原理
#### 说说 Dubbo 的实现原理
#### 你怎么理解 RESTful
#### 说说如何设计一个良好的 API
#### 如何理解 RESTful API 的幂等性
#### 如何保证接口的幂等性
#### 说说 CAP 定理、 BASE 理论
#### 怎么考虑数据一致性问题
#### 说说最终一致性的实现方案
#### 你怎么看待微服务
#### 微服务与 SOA 的区别
#### 如何拆分服务
#### 微服务如何进行数据库管理
#### 如何应对微服务的链式调用异常
#### 对于快速追踪与定位问题
#### 微服务的安全

### 分布式
#### 谈谈业务中使用分布式的场景
#### Session 分布式方案
#### 分布式锁的场景
#### 分布是锁的实现方案
#### 分布式事务
#### 集群与负载均衡的算法与实现
#### 说说分库与分表设计
#### 分库与分表带来的分布式困境与应对之策

## 安全&性能

### 安全问题

#### 安全要素与 STRIDE 威胁
#### 防范常见的 Web 攻击
#### 服务端通信安全攻防
#### HTTPS 原理剖析
#### HTTPS 降级攻击
#### 授权与认证
#### 基于角色的访问控制
#### 基于数据的访问控制

### 性能优化
#### 性能指标有哪些
#### 如何发现性能瓶颈
#### 性能调优的常见手段
#### 说说你在项目中如何进行性能调优

## 工程篇

### 需求分析
#### 你如何对需求原型进行理解和拆分
#### 说说你对功能性需求的理解
#### 说说你对非功能性需求的理解
#### 你针对产品提出哪些交互和改进意见
#### 你如何理解用户痛点

### 设计能力
#### 说说你在项目中使用过的 UML 图
#### 你如何考虑组件化
#### 你如何考虑服务化
#### 你如何进行领域建模
#### 你如何划分领域边界
#### 说说你项目中的领域建模
#### 说说概要设计

### 设计模式
#### 你项目中有使用哪些设计模式
#### 说说常用开源框架中设计模式使用分析
#### 说说你对设计原则的理解
#### 23种设计模式的设计理念
#### 设计模式之间的异同，例如策略模式与状态模式的区别
#### 设计模式之间的结合，例如策略模式+简单工厂模式的实践
#### 设计模式的性能，例如单例模式哪种性能更好。

### 业务工程
#### 你系统中的前后端分离是如何做的
#### 说说你的开发流程
#### 你和团队是如何沟通的
#### 你如何进行代码评审
#### 说说你对技术与业务的理解
#### 说说你在项目中经常遇到的 Exception
#### 说说你在项目中遇到感觉最难Bug，怎么解决的
#### 说说你在项目中遇到印象最深困难，怎么解决的
#### 你觉得你们项目还有哪些不足的地方
#### 你是否遇到过 CPU 100% ，如何排查与解决
#### 你是否遇到过 内存 OOM ，如何排查与解决
#### 说说你对敏捷开发的实践
#### 说说你对开发运维的实践
#### 介绍下工作中的一个对自己最有价值的项目，以及在这个过程中的角色

### 软实力
#### 说说你的亮点
#### 说说你最近在看什么书
#### 说说你觉得最有意义的技术书籍
#### 工作之余做什么事情
#### 说说个人发展方向方面的思考
#### 说说你认为的服务端开发工程师应该具备哪些能力
#### 说说你认为的架构师是什么样的，架构师主要做什么
#### 说说你所理解的技术专家

## HR 篇

### 你为什么离开之前的公司
### 你为什么要进我们公司
### 说说职业规划
### 你如何看待加班问题
### 谈一谈你的一次失败经历
### 你觉得你最大的优点是什么
### 你觉得你最大的缺点是什么
### 你在工作之余做什么事情
### 你为什么认为你适合这个职位
### 你觉得自己那方面能力最急需提高
### 你来我们公司最希望得到什么
### 你希望从这份工作中获得什么
### 你对现在应聘的职位有什么了解
### 您还有什么想问的
### 你怎么看待自己的职涯
### 谈谈你的家庭情况
### 你有什么业余爱好
### 你计划在公司工作多久
