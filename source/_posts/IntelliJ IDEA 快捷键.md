---
title: IntelliJ IDEA 快捷键
date: 2018-11-23 11:02:29
tags: 
    - IDEA
categories:
    - IDEA
---
### Idea快捷键
#### 一、跳转
1.ctrl+Alt+[] 项目之间跳转  
2.ctrl+e 最近的文件  
3.ctrl+shift+e 最近编辑的文件  
4.ctrl+shift+backspace 浏览修改位置的跳转  
5.ctrl+shift+左箭头（win10会改变屏幕方向） 最新浏览位置的修改  
6.使用书签进行跳转  
    ```bash
    ctrl+shift+数字或字母 标记书签  
    ctrl+数字或者字母 跳转书签  
    shift+F11 总览书签  
    ```
7.Ctrl+Up/Down 光标中转到当前界面第一行或最后一行下  
8.Ctrl+[OR] 可以跑到大括号的开头与结尾  
9.F2 1跳转到错误位置  
<!-- more -->
#### 二、高效定位代码
1.ctrl+n 定位类  
2.ctrl+shift+n 定位文件  
3.ctrl+shift+alt+n 定位函数或者属性  
4.ctrl+shift+f 定位字符串  
#### 三、列操作
1.ctrl+shift+alt+j 列操作（多行逻辑操作、批量操作）  
2.Ctrl+←(→) 移动到一个词的开始(结尾)  
3.Ctrl+Shift+←(→) 从后到前（从前到后）选中一个词  
4.Ctrl+Home 第一行代码  
5.Ctrl+End 最后一行代码  
6.ctrl+alt+l 代码格式化  
#### 四、Livetemplate
1.Livetemplate 自定义代码模块快捷键和内容  
```bash
位置:ctrl+shift+a查找livetemplates,回车  
    $VAR1第一个值$VAR2第一个值$VAR2第二个值  
    $END$鼠标停留位置  
    回车跳转到到下个值
```
 
#### 五、Postfix
1.postfix 参数后面点函数回车，生成代码位置:ctrl+shift+a查找postfix,回车name.field——可自动添加this.name=name以及private String name;  
  常用：  
   ```bash
    -foo.fori for(int i = 0; i < foo; i++){}
    -foo.return return foo;
    -foo.sout System.out.println(foo);
    -foo.field private Foo foo; this.foo = foo;
    -foo.nn if(user!=null){}
   ```
#### 六、Alter+enter
1.Alter+enter 智能提示  
    ```bash
    -自动创建函数
    -list replace 列表替换优化
    -字符串format或者build 字符串格式化，build优化减小内存
    -接口实现 在接口上回车可自动创建实现类
    -单词拼写 波浪线为存在单词问题，可校对单词
    -导包
    -不知道怎么做就试试Alter+enter
    ```
#### 七、重构  
1.shift+F6 重构，将某个参数全部修改。  
    ```bash
    -重构变量
    -重构方法
    ```
#### 八、抽取  
1.抽取，将常用数据抽取出来变成简单变量或函数。  
    -抽取变量 Ctrl+Alt+V  
    -抽取静态变量 Ctrl+Alt+C  
    -抽取成员变量 Ctrl+Alt+F  
    -抽取方法参数 Ctrl+Alt+P  
    -抽取函数 Ctrl+Alt+M  
#### 九、寻找修改轨迹  
1.annotate代码前右击，选中annotate，可以找到代码的所有者，更进一步点击，还可以找到该作者的修改记录  
2.Ctrl+Alt+Shift+上下箭头 寻找改动的地方  
3.Ctrl+Alt+Z 撤销，包括单个和项目改动之处  
4.Local history idea本地历史记录  
    ```bash
    Put Label 本地存档说明
    Put Label可以用Ctrl+Alt+A的Local History里找到
    ```
#### 十、关联  
1.spring关联  
    ```bash
    Ctrl+Alt+Shift+S 中的Facets配置。
    可在代码前的行数中看到Spring的关系
    ```
2.与数据库关联  
    ```bash
    添加Database在mapper输入时可以自动提示Database字段。
    Shinf+f6重构改表名mapper也可以改。或者直接改。
    ```
#### 十一、断点调试  
1.Ctrl+F8 添加删除断点  
2.Shift +f9 dubug运行  
3.F8 单步运行  
4.F9 跳到下一个断点  
5.Ctrl+Shift+F8 查看所有断点位置（在有断点的位置为设置条件断点）  
6.Alt+F8 查看当前变量值和表达式求值  
7.Alt+F9 运行到光标位置  
8.setValue 在debug页面按F2动态设置传递的值  
9.Ctrl+Shift+f9 运行光标最小上下文  
10.Shift+Alt+F9 最近运行的历史列表选择运行  
#### 十二、文件操作  
1.Ctrl+Alt+Insert 新建文件  
2.F5 复制文件  
3.F6 移动文件  
#### 十三、文本操作  
1.Ctrl+C 复制文件名  
2.Ctrl+Shift+C 复制文件路径  
3.Ctrl+Shift+V 剪切板（历史复制）  
#### 十四、结构图  
1.Ctrl+F12 查看当前field,method大纲  
2.Ctrl+alt+Shift+U查看maven依赖，类图  
3.Ctrl+H，查看类的继承关系  
4.Ctrl+Alt+H，查看方法的调用和被调用关系  
#### 十五、其他快捷键  
1.Alt+Q 可以看到当前方法的声明  
2.Alt+Insert 可以生成构造器/Getter/Setter等  
3.Ctrl+/或Ctrl+Shift+/ 注释（//或者/**/）  
4.Ctrl+J 自动代码（例如：serr）  
5.Ctrl+Shift+J 整合两行  
6.Ctrl+Shift+U 大小写转化  
7.Ctrl+Y 删除当前行  
8.Ctrl+D 复制当前行  
9.Shift+Enter 向下插入新行  
10.Ctrl+”+/-”，当前方法展开、折叠  
11.Ctrl+Shift+”+/-”，全部展开、折叠