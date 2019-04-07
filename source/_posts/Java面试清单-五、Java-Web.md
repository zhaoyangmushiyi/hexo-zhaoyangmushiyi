---
title: Java面试清单(五、Java Web)
date: 2019-04-07 19:39:44
tags:
    - Java
categories:
    - Java
---
## jsp 和 servlet 有什么区别？
1.jsp经编译后就变成了Servlet.(JSP的本质就是Servlet，JVM只能识别java的类，不能识别JSP的代码,Web容器将JSP的代码编译成JVM能够识别的java类)  
2.jsp更擅长表现于页面显示,servlet更擅长于逻辑控制.  
3.Servlet中没有内置对象，Jsp中的内置对象都是必须通过HttpServletRequest对象，HttpServletResponse对象以及HttpServlet对象得到.  
Jsp是Servlet的一种简化，使用Jsp只需要完成程序员需要输出到客户端的内容，Jsp中的Java脚本如何镶嵌到一个类中，由Jsp容器完成。而Servlet则是个完整的Java类，这个类的Service方法用于生成对客户端的响应。  
联系：  
JSP是Servlet技术的扩展，本质上就是Servlet的简易方式。JSP编译后是“类servlet”。Servlet和JSP最主要的不同点在于，Servlet的应用逻辑是在Java文件中，并且完全从表示层中的HTML里分离开来。而JSP的情况是Java和HTML可以组合成一个扩展名为.jsp的文件。JSP侧重于视图，Servlet主要用于控制逻辑  
<!-- more -->
## jsp 有哪些内置对象？作用分别是什么？
Page，pageContext，request，response，session，application，out，config，exception  
Page指的是JSP被翻译成Servlet的对象的引用.  
pageContext对象可以用来获得其他8个内置对象,还可以作为JSP的域范围对象使用.pageContext中存的值是当前的页面的作用范围》  
request代表的是请求对象,可以用于获得客户机的信息,也可以作为域对象来使用，使用request保存的数据在一次请求范围内有效。  
Session代表的是一次会话，可以用于保存用户的私有的信息,也可以作为域对象使用，使用session保存的数据在一次会话范围有效   
Application：代表整个应用范围,使用这个对象保存的数据在整个web应用中都有效。  
Response是响应对象,代表的是从服务器向浏览器响应数据.  
Out:JSPWriter是用于向页面输出内容的对象  
Config：指的是ServletConfig用于JSP翻译成Servlet后 获得Servlet的配置的对象.  
Exception:在页面中设置isErrorPage=”true”，即可使用，是Throwable的引用.用来获得页面的错误信息。  

## 说一下 jsp 的 4 种作用域？
application  在所有应用程序中有效  
session  在当前会话中有效  
request  在当前请求中有效  
page  在当前页面有效  

## session 和 cookie 有什么区别？
1、cookie数据存放在客户的浏览器上，session数据放在服务器上。  
2、cookie不是很安全，别人可以分析存放在本地的COOKIE并进行COOKIE欺骗。考虑到安全应当使用session。  
3、session会在一定时间内保存在服务器上。当访问增多，会比较占用你服务器的性能。考虑到减轻服务器性能方面，应当使用COOKIE。  
4、单个cookie保存的数据不能超过4K，很多浏览器都限制一个站点最多保存20个cookie。  

## 说一下 session 的工作原理？


## 如果客户端禁止 cookie 能实现 session 还能用吗？
Cookie与 Session，一般认为是两个独立的东西，Session采用的是在服务器端保持状态的方案，而Cookie采用的是在客户端保持状态的方案。但为什么禁用Cookie就不能得到Session呢？因为Session是用Session ID来确定当前对话所对应的服务器Session，而Session ID是通过Cookie来传递的，禁用Cookie相当于失去了Session ID，也就得不到Session了。  

假定用户关闭Cookie的情况下使用Session，其实现途径有以下几种：  
   1》 设置php.ini配置文件中的“session.use_trans_sid = 1”，或者编译时打开打开了“--enable-trans-sid”选项，让PHP自动跨页传递Session ID。  
   2》 手动通过URL传值、隐藏表单传递Session ID。  
   3》 用文件、数据库等形式保存Session ID，在跨页过程中手动调用。  
## spring mvc 和 struts 的区别是什么？
一、拦截机制的不同  
　　Struts2是类级别的拦截，每次请求就会创建一个Action，和Spring整合时Struts2的ActionBean注入作用域是原型模式prototype，然后通过setter，getter吧request数据注入到属性。Struts2中，一个Action对应一个request，response上下文，在接收参数时，可以通过属性接收，这说明属性参数是让多个方法共享的。Struts2中Action的一个方法可以对应一个url，而其类属性却被所有方法共享，这也就无法用注解或其他方式标识其所属方法了，只能设计为多例。  
　　SpringMVC是方法级别的拦截，一个方法对应一个Request上下文，所以方法直接基本上是独立的，独享request，response数据。而每个方法同时又何一个url对应，参数的传递是直接注入到方法中的，是方法所独有的。处理结果通过ModeMap返回给框架。在Spring整合时，SpringMVC的Controller Bean默认单例模式Singleton，所以默认对所有的请求，只会创建一个Controller，有应为没有共享的属性，所以是线程安全的，如果要改变默认的作用域，需要添加@Scope注解修改。  
　　Struts2有自己的拦截Interceptor机制，SpringMVC这是用的是独立的Aop方式，这样导致Struts2的配置文件量还是比SpringMVC大。  

二、底层框架的不同  
　　Struts2采用Filter（StrutsPrepareAndExecuteFilter）实现，SpringMVC（DispatcherServlet）则采用Servlet实现。Filter在容器启动之后即初始化；服务停止以后坠毁，晚于Servlet。Servlet在是在调用时初始化，先于Filter调用，服务停止后销毁。  

三、性能方面  
　　Struts2是类级别的拦截，每次请求对应实例一个新的Action，需要加载所有的属性值注入，SpringMVC实现了零配置，由于SpringMVC基于方法的拦截，有加载一次单例模式bean注入。所以，SpringMVC开发效率和性能高于Struts2。  

四、配置方面  
　　spring MVC和Spring是无缝的。从这个项目的管理和安全上也比Struts2高。  

附注：拦截器与过滤器的区别 ：  

    拦截器是基于java的反射机制的，而过滤器是基于函数回调。
    拦截器不依赖与servlet容器，过滤器依赖与servlet容器。
    拦截器只能对action请求起作用，而过滤器则可以对几乎所有的请求起作用。
    拦截器可以访问action上下文、值栈里的对象，而过滤器不能访问。
    在action的生命周期中，拦截器可以多次被调用，而过滤器只能在容器初始化时被调用一次

## 如何避免 sql 注入？
1、PreparedStatement  
2、正则表达式  
3、字符串过滤  
4、不安全字符屏蔽  

## 什么是 XSS 攻击，如何避免？
将一段JavaScript代码注入网页。然后当其他用户访问该页面时，他们将运行黑客编写的JS代码来实现一些帐户控制。有很多方法，例如：关键字判断当有一个关键字如脚本、src来代替损坏；返回内容时进行转码，转码尖括号采用Unicode编码格式  

## 什么是 CSRF 攻击，如何避免？
CSRF（Cross-site request forgery）跨站请求伪造，解决方案是向表单添加字段标记。黑客无法猜出已经改变的令牌，所以即使你添加一个UUID令牌，将它保存到服务器会话，黑客也不可能猜出随机令牌，就无法构造出能实现功能的链接了。  