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

　　本章将讲述何时以及如何盖这些非`final`的`Object`方法。本章不再讨论`finalize`方法，因为Item 8已经讨论过这个方法了。而`Comparable.compareTo`虽然不是`Object`方法，但是本章也对它进行讨论，因为它具有类似的特征。
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
　　那么，什么时候应该覆盖`Object.equals`呢？如果类具有自己特有的“逻辑相等”概念（不同于对象等同的概念),而且超类还没有覆盖`equals`以实现期望的行为。这时我们就需要覆盖`equals`方法。这通常属于“值类（`value class`）”的情形。值类仅仅是一个表示值的类，例如`Integer`或者`Date`。程序员在利用`equals`方法来比较对象的引用时，希望知道它们在逻辑上是否相等，而不是想了解它们是否指向同一个对象。为了满足程序员的要求，不仅必需覆盖`equals`方法，而且这样做也使得这个类的实例可以被用做映射表(`map`)的键(`key`)，或者集合（`set`）的元素，使映射或者集合表现出预期的行为。

　　有一种“值类”不需要覆盖`equals`方法，即用实例受控（Item 1）确保“每个值至多只存在一个对象”的类。枚举类型（Item 34）就属于这种类。对于这样的类而言，逻辑相同与对象等同是一回事，因此`Object`的`equals`方法等同于逻辑意义上的`equals`方法。

　　在覆盖`equals`方法的时候，你必须要遵守它的通用约定。下面是约定的内容，来自`Object`的规范[JavaSE6]: 
 
　　`equals`方法实现了等价关系(`equivalence relation`):

- 自反性(`reflexive`)。对于任何非`null`的引用值，`x.equals(x)`必须返回`true`。
- 对称性(`symmetric`)。对于任何非`null`的引用值x和Y，当且仅当`y.equals(x)`返回`true`时，
`x.equals(y)`必须返回`true`。
- 传递性(`transitive`)。对于任何非`null`的引用值x、y和z,如果`x.equals(y)`返回`true`，并
且`y.equals(z)`也返回true，那么`x.equals(z)`也必须返回`true`。
- 一致性：(`consistent`)。对于任何非`null`的引用值x和y，只要`equals`的比较操作在对象中
所用的信息没有被修改多次调用`x.equals(y)`就会一致地返回`true`，或者一致地返回`false`。
- 对于任何非`null`的引用值x，`x.equals(null)`必须返回`false`。

    　　除非你对数学特别感兴，否则这些规定看起来可能有点让人感到恐惧，但是绝对不要忽视这些规定！如果你违反了它们，就会发现你的程序将会表现不正常，甚至崩溃，而且很难找到失败的根源。用John Donne的话说，没有哪个类是孤立的。一个类的实例通常会被频繁地传递给另一个类的实例。有许多类，包括所有的集合类（`collection class`)在内，都依赖于传递给它们的对象是否遵守了`equals`约定。

　　现在你已经知道了违反`equals`约定有多么可怕，现在我们就来更细致地讨论这些约定。值得欣慰的是，这些约定虽然看起来很吓人，实际上并不十分复杂。一旦理解了这些约定，要遵守它们并不困难。现在我们按照顺序逐一查看以下5个要求：

　　**自反性（`reflexivity`)**——第一个要求仅仅说明对象必须等于其自身。很难想像会无意识地违反这一条。假如违背了这一条，然后把该类的实例添加到集合(`collection`)中，该集合的`contain`方法将果断地告诉你，该集合不包含你刚刚添加的实例。

　　**对称性(`symmetry`)**——第二个要求是说，任何两个对象对于“它们是否相等”的问题都必须保持一致。与第一个要求不同，若无意中违反这一条，这种情形倒是不难想像。例如，考虑下面的类，它实现了一个区分大小写的字符串。字符串由`toString`保存，但在比较操作中被忽略。
    ``` java CaseInsensitiveString.java
    // Broken - violates symmetry!
    public final class CaseInsensitiveString {
        private final String s;
    
        public CaseInsensitiveString(String s) {
            this.s = Objects.requireNonNull(s);
        }
    
        // Broken - violates symmetry!
        @Override public boolean equals(Object o) {
            if (o instanceof CaseInsensitiveString)
                return s.equalsIgnoreCase(
                        ((CaseInsensitiveString) o).s);
            if (o instanceof String)  // One-way interoperability!
                return s.equalsIgnoreCase((String) o);
            return false;
        }
    
        // Demonstration of the problem (Page 40)
        public static void main(String[] args) {
            CaseInsensitiveString cis = new CaseInsensitiveString("Polish");
            String s = "polish";
    
            List<CaseInsensitiveString> list = new ArrayList<>();
            list.add(cis);
    
            System.out.println(list.contains(s));
        }
    
    //    // Fixed equals method (Page 40)
    //    @Override public boolean equals(Object o) {
    //        return o instanceof CaseInsensitiveString &&
    //                ((CaseInsensitiveString) o).s.equalsIgnoreCase(s);
    //    }
    }
    ```
　　在这个类中，`equals`方法的意图非常好，它企图与普通的字符串(`String`)对象进行互操作。假设我们有一个不区分大小写的字符串和一个普通的字符串：
    ``` java 
    CaseInsensitiveString cis = new CaseInsensitiveString("PoliSh");
    String s = "polish";
    ```
　　正如所料，`cis.equals(s)`返回`true`。问题在于，虽然`CaseInsensitiveString`类中的`equals`方法知道普通的字符串(`String`)对象，但是，`String`类中的`equals`方法却并不知道不区分大小写的字符串。因此，`s.equals(cis)`返回`false`，显然违反了对称性，假设你把不区分大小写的字符串对象放到一个集合中：
    ``` java
    List<CaseInsensitiveString> list = new ArrayList<CaseInsensitiveString>();
    list.add(ics);
    ```
　　此时`list.contains(s)`会返回什么结果呢？没人知道。在OpenJDK的当前实现中，它碰巧返回`false`，但这只是这个特定实现得出的结果而已。在其他的实现中，它有可能返回`true`，或者抛出一个运行时(`runtime`)异常。**一旦违反了`equals`约定，当其他对象面对你的对象时，你完全不知道这些对象的行为会怎么样。**

　　为了解决这个问题，只需把企图与`String`互操作的这段代码从`equals`方法中去掉就可以了。这样做之后，就可以重构该方法，使它变成一条单独的返回句：
    ``` java
    @Override public boolean equals(Object o) {
        return o instanceof CaseInsensitiveString &&
            ((CaseInsensitiveString) o).s.equalsIgnoreCase(s);
    }
    ```
　　**传递性(`transitivity`)**——`equals`约定的第三个要求是，如果一个对象等于第二个对象，并且第二个对象又等于第三个对象，则第一个对象一定等于第三个对象。同样地，无意识地违反这条规则的情形也不难想像。考虑子类的情形，它将一个新的值组件(`value component`)添加到了超类中。换句话说，子类增加的信息会影响到`equals`的比较结果。我们首先以一个简单的不可变的二维整数型`Point`类作为开始：
        ``` java
        // Simple immutable two-dimensional integer point class (Page 37)
        public class Point {
            private final int x;
            private final int y;
    
            public Point(int x, int y) {
                this.x = x;
                this.y = y;
            }
    
            @Override public boolean equals(Object o) {
                if (!(o instanceof Point))
                    return false;
                Point p = (Point)o;
                return p.x == x && p.y == y;
            }
    
        //    // Broken - violates Liskov substitution principle (page 43)
        //    @Override public boolean equals(Object o) {
        //        if (o == null || o.getClass() != getClass())
        //            return false;
        //        Point p = (Point) o;
        //        return p.x == x && p.y == y;
        //    }
    
            // See Item 11
            @Override public int hashCode()  {
                return 31 * x + y;
            }
        }
        ```
　　假设你想要扩展这个类，为一个点添加颜色信息：
        ``` java
        // Adds a value component without violating the equals contract (page 44)
        public class ColorPoint {
            private final Point point;
            private final Color color;
    
            public ColorPoint(int x, int y, Color color) {
                point = new Point(x, y);
                this.color = Objects.requireNonNull(color);
            }
    
            /**
            * Returns the point-view of this color point.
            */
            public Point asPoint() {
                return point;
            }
    
            @Override public boolean equals(Object o) {
                if (!(o instanceof ColorPoint))
                    return false;
                ColorPoint cp = (ColorPoint) o;
                return cp.point.equals(point) && cp.color.equals(color);
            }
    
            @Override public int hashCode() {
                return 31 * point.hashCode() + color.hashCode();
            }
        }
        ```
　　`equals`方法会怎么样呢？如果完全不提供`equals`方法，而是直接从`Point`继承过来，在`equals`做比较的时候颜色信息就被忽略掉了，虽然这样做不会违反`equals`约定，但是很明显这是无法接受的。假设你编写了一个`equals`方法，只有当它的参数是另一个有色点，并且具有同样的位置和颜色时，它才会返回`true`：
        ``` java
        // Broken - violates symmetry!
        @Override public boolean equals(Object o) {
            if (!(o instanceof ColorPoint))
                return false;
            return super.equals(o) && ((ColorPoint) o).color == color;
        }
        ```
　　这个方法的问题在于，你在比较普通点和有色点，以及相反的情形时，可能会得到不同的结果。前一种比较忽略了颜色信息，而后一种比较则总是返回`false`，因为参数的类型不正确。为了直观地说明问题所在，我们创建一个普通点和一个有色点！
        ``` java
        Point p = new Point(1, 2);
        ColorPoint cp = new ColorPoint(1, 2, Color.RED);
        ```
　　然后，`p.equals(cp)`返回`true`，`cp.equals(p)`则返回`false`。你可以做这样的尝试来修正这个问题，让`ColorPoint.equals`在进行“混合比较”时忽略颜色信息:
        ``` java
        // Broken - violates transitivity!
        @Override public boolean equals(Object o) {
            if (!(o instanceof Point))
                return false;
            // If o is a normal Point, do a color-blind comparison
            if (!(o instanceof ColorPoint))
                return o.equals(this);
            // o is a ColorPoint; do a full comparison
            return super.equals(o) && ((ColorPoint) o).color == color;
        }
        ```
　　这种方法确实提供了对称性，但是却牺牲了传递性：
        ``` java
        ColorPoint p1 = new ColorPoint(1, 2, Color.RED);
        Point p2 = new Point(1, 2);
        ColorPoint p3 = new ColorPoint(1, 2, Color.BLUE);
        ```
　　此时，`p1.equalS(p2)`和`p2.equals(p3)`都返回`true`，但是`p1.equals(p3)`则返回`false`，很显然违反了传递性。前两种比较不考虑颜色信息（“色盲”），而第三种比较中则考虑了倾色信息。

　　怎么解决呢？事实上，这是面向对象语言中关于等价关系的一个基本问题。**我们无法在扩展可实例化的类的同时，既增加新的值组件，同时又保留`equals`约定**，除非愿意放弃面向对象的抽象所带来的优势。

　　你可能听说，在`equals`方法中用`getClass`测试代替`instanceof`测试，可以扩展可实例化的类和增加新的值组件，同时保留`equals`约定：
        ``` java
        // Broken - violates Liskov substitution principle (page 43)
        @Override public boolean equals(Object o) {
            if (o == null || o.getClass() != getClass())
                return false;
            Point p = (Point) o;
            return p.x == x && p.y == y;
        }
        ```
　　这段程序只有当对象具有相同的实现时，才能使对象等同。虽然这样也不算太槽糕，但是结果却是无法接受的。假设我们要编写一个方法，以检验某个整值点是否处在单位圆中。下面是可以采用的其中一种方法，
        ``` java
        // Initialize unitCircle to contain all Points on the unit circle
        private static final Set<Point> unitCircle = Set.of(
            new Point( 1, 0), new Point( 0, 1),
            new Point(-1, 0), new Point( 0, -1));
        public static boolean onUnitCircle(Point p) {
            return unitCircle.contains(p);
        }
        ```
　　虽然这可能不是实现这种功能的最快方式，不过它的效果很好。但是假设你通过某种不添加值组件的方式扩展了`Point`，例如让它的构造器记录创建了多少个实例：
        ``` java
        public class CounterPoint extends Point {
            private static final AtomicInteger counter =
                new AtomicInteger();
            public CounterPoint(int x, int y) {
                super(x, y);
                counter.incrementAndGet();
            }
            public static int numberCreated() { return counter.get(); }
        }
        ```
　　**里氏替换原则（Liskov substitution principle）** 认为，一个类型的任何重要属性也将适用于它的子类型，因此为该类型编写的任何方法，在它的子类型上也应该同样运行得很好[Liskov87]。但是假设我们将`CounterPoint`实例传给了`onUnitCircle`方法。如果`Point`类使用了基于`getClass`的`equals`方法，无论`CounterPoint`实例的x和y值是什么，`onUnitCircle`方法都会返回`false`。之所以如此，是因为像`onUnitCircle`方法所用的`HashSet`这样的集合，利用`equals`方法检验包含条件，没有任何`CounterPoint`实例与任何`Point`对应。但是，如果在`Point`上使用适当的基于`instanceof`的`equals`方法，当遇到`Counterpoint`时，相同的`onUnitCircle`方法就会工作得很好。

　　虽然没有一种令人满意的办法可以既扩展不可实例化的类，又增加值组件，但还是有一种不错的权宜之计（`workaround`)。根据Item 18的建议：复合优先于继承。我们不再让`ColorPoint`扩展`Point`，而是在`ColorPoint`中加人一个私有的`Point`域，以及一个公有的视图(`view`)方法（Item 6），此方法返回一个与该有色点处在相同位置的普通`Point`对象：
        ``` java
        // Adds a value component without violating the equals contract
        public class ColorPoint {
            private final Point point;
            private final Color color;
            public ColorPoint(int x, int y, Color color) {
                point = new Point(x, y);
                this.color = Objects.requireNonNull(color);
            }
            /**
            * Returns the point-view of this color point.
            */
            public Point asPoint() {
                return point;
            }
            @Override public boolean equals(Object o) {
                if (!(o instanceof ColorPoint))
                    return false;
                ColorPoint cp = (ColorPoint) o;
                return cp.point.equals(point) && cp.color.equals(color);
            }
            ... // Remainder omitted
        }
        ```
　　在Java平台类库中，有一些类扩展了可实例化的类，并添加了新的值组件。例如，`java.sql.Timestamp`对`java.util.Date`进行了扩展，并增加了`nanoseconds`域，`Timestamp`的`equals`实现确实违反了对称性，如果`Timestamp`和`Date`对象被用于同一个集合中，或者以其他方式被混合在一起，则会引起不正确的行为。`Timestamp`类有一个免责声明，告诫程序员不要混合使用`Date`和`Timestamp`对象。只要你不把它们混合在一起，就不会有麻烦，除此之外没有其他的措施可以防止你这么做，而且结果导致的错误将很难调试。`Timestamp`的这种行为是个错误，不值得仿效。

　　注意，你可以在一个抽象(`abstract`)类的子类中增加新的值组件，而不会违反`equals`约定。对于Item 23的建议“用类层次(`class hierarchies`)代替标签类(`tagged class`)”而得到的那种类层次结构来说，这一点非常重要。例如，你可能有一个抽象的`Shape`类，它没有任何值组件，`Circle`子类添加了一个`radiust`域，`Rectangle`子类添加了`length`和`width`域。只要不可能直接创建超类的实例，前面所述的种种问题就都不会发生。

- 一致性(`consistency`)——`equals`约定的第四个要求是，如果两个对象相等，它们就必须始终保持相等，除非它们中有一个对象（或者两个都）被修改了。换句话说，可变对象在不同的时候可以与不同的对象相等，而不可变对象则不会这样。当你在写一个类的时候，应该仔细考虑它是否应该是不可变的（Item 17）。如果认为它应该是不可变的，就必须保证`equals`方法满足这样的限制条件：相等的对象永远相等，不相等的对象永远不相等。

    　　无论类是否是不可变的，都不要使`equals`方法依赖于不可靠的资源。如果违反了这条禁令，要想满足一致性的要求就十分困难了。例如，`java.net.URL`的`equals`方法依赖于对URL中主机IP地址的比较。将一个主机名转变成IP地址可能需要访问网络，随着时间的推移，不确保会产生相同的结果．这样会导致URL的`equals`方法违反`equals`约定，在实践中有可能引发一些问题。（遗憾的是，因为兼容性的要求，这一行为无法被改变。）除了极少数的例外情况，`equals`方法都应该对驻留在内存中的对象执行确定性的计算。

- 非空性(`Non-nullity`)——最后一个要求没有名称，我姑且称它为“非空性(`Non-nullity`)”，意思是指所有的对象都必须不等于`null`。尽管很难想像什么情况下`o.equals(null)`调用会意外地返回`true`，但是意外抛出`NullPointerException`异常的情形却不难想像。通用约定不允许抛出`NullPointerException`异常。许多类的`equals`方法都通过一个显式的null测试来防止这种情况:
    ``` java
    @Override public boolean equals(Object o) {
        `if (o == null)
            return false;
        ...
    }
    ```
    　　这项测试是不必要的。为了测试其参数的等同性，`equals`方法必须先把参数转换成适当的类型，以便可以调用它的访问方法(`accessor`),或者访问它的域。在进行转换之前，`equals`方法必须使用`instanceof`操作符，检查其参数是否为正确的类型：
    ``` java
        @Override public boolean equals(Object o) {
            if (!(o instanceof MyType))
                return false;
        MyType mt = (MyType) o;
        ...
    }
    ```
    　　如果漏掉了这一步的类型检查，并且传递给`equals`方法的参数又是错误的类型，那么`equals`方法将会抛出`ClassCastException`异常，这就违反了`equals`的约定但是，如果`instanceof`的第一个操作数为`null`，那么，不管第二个操作数是哪种类型，`instanceof`操作符都指定应该返回`false`[JLS, 15.20.2]。因此，如果把`null`传给`equals`方法，类型检查就会返回`false`，所以不需要单独的`null`检查。
    
　　结合所有这些要求，得出了以下实现高质量`equals`方法的诀窍：

　　1．**使用==操作符检查“参數是否为这个对象的引用”**。如果是，则返回`true`。这只不过是一种性能优化，如果比较操作有可能很昂贵，就值得这么做。

　　2．**使用`instanceof`操作符检查“参數是否为正确的类型”**。如果不是、则返回`false`。一般说来，所谓“正确的类型”是指`equals`方法所在的那个类。有些情况下，是指该类所实现的某个接口。如果类实现的接口改进了`equals`约定，允许在实现了该接口的类之间进行比较，那么就使用接口。集合接口(`collection interface`)如`Set`、`List`、`Map`和`MapEntry`具有这样的特性。

　　3．**把参数转换成正确的类型**。因为转换之前进行过`instanceof`测试，所以确保会成功。

　　4．**对于该类中的每个“关键(`significant`)"域，检查参数中的域是否与该对象中对应的域相匹配**。如果这些测试全部成功，则返回否則返回`false`。如果第2步中的类型是个接口，就必须通过接口方法访问参数中的域，如果该类型是个类，也许就能够直接访问参数中的域，这要取决干它们的可访问性。

　　对于既不是`float`也不是`double`类型的基本类型域，可以使用==操作符进行比较；对于对象引用域，可以递归地调用`equals`这方法；对于`float`域，可以使用`Float.compare`方法；对于`double`域，则使用`Double.compare`。对`float`和`double`域进行特殊的处理是有必要的，因为存在着`Float.NaN`、`-0.0f`及类似的`double`常量；详细信息请参考[JLS 15.21.1]或`Float.equals`的文档。对于数组域，则要把以上这些指导原则应用到每个元素上。如果数组域中的每个元素都很重要，就可以使用其中一个`Arrays.equals`方法。

　　有些对象引用域包含`null`可能是合法的，所以，为了避兔可能导致`NullPointerException`异常，则使用静态方法`Objects.equals(Object, Object)`来检查这样的域。

　　对干有些类，比如前面提到的`CaseInsensitiveString`类，域的比较要比简单的等同性测试复杂得多，如果是这种情况，可能会希望保存该域的一个“范式(`canonical form`)”，这样`equals`方法就可以根据这些范式进行低开销的精确比较，而不是高开销的非精确比较。这种方法对于不可变类（Item 17）是最为合适的；如果对象可能发生化，必须使其范式保持最新。

　　域的比较顺序可能会影响到`equals`方法的性能。为了获得最隹的性能，应该最先比较最有可能不一致的域，或者是开销最低的域，最理想的情况是两个条件同时满足的域，你不应该去比较那些不属于对象逻辑状态的域，例如用于同步操作的`Lock`域。也不需要比较冗余域(`redundant field`)，因为这些冗余域可以由“关键域”计算获得，但是这样做有可能提高`equals`方法的性能。如果冗余域代表了整个对象的综合描述，比较这个域可以节省当比较失败时去比较实际数据所需要的开销。例如，假设有一个`Polygon`类，并缓存了该区域。如果两个多边形有着不同的区域，就没有必要去比较它们的边和至高点。

　　5.**当你编写完成了`equals`方法之后，应该问自己三个问题：它是否是对称的、传递的、一致的**？并且不要只是自问，还要编写单元测试来检验这些特性！如果答案是否定的，就要找出原因，再相应地修改`equals`方法的代码。当然，`equals`方法也必须满足其他两个特性（自反性和非空性），但是这两种特性通常会自动满足。

　　下面是一个根据上面的诀窍构建的`equals`方法的具体例子，在一个简单的PhoneNumber类里面：
        ``` java
        // Class with a typical equals method
        public final class PhoneNumber {
            private final short areaCode, prefix, lineNum;
    
            public PhoneNumber(int areaCode, int prefix, int lineNum) {
                this.areaCode = rangeCheck(areaCode, 999, "area code");
                this.prefix = rangeCheck(prefix, 999, "prefix");
                this.lineNum = rangeCheck(lineNum, 9999, "line num");
            }
    
            private static short rangeCheck(int val, int max, String arg) {
                if (val < 0 || val > max)
                    throw new IllegalArgumentException(arg + ": " + val);
                return (short) val;
            }
    
            @Override
            public boolean equals(Object o) {
                if (o == this)
                    return true;
                if (!(o instanceof PhoneNumber))
                    return false;
                PhoneNumber pn = (PhoneNumber) o;
                return pn.lineNum == lineNum && pn.prefix == prefix
                        && pn.areaCode == areaCode;
            }
            ... // Remainder omitted
        }
        ```
　下面是最后的一些告诚:

- **覆盖`equals`时总要覆`hashCode`**（Item 9）。

- **不要企图让`equals`方法过于智能**。如果只是简单地测试域中的值是否相等，则不难做到遵守`equals`约定。如果想过度地去寻求各种等价关系，则很容易陷人麻烦之中。把任何一种别名形式考虑到等价的范围内，往往不会是个好主意。例如，`File`类不应该试图把指向同一个文件的符号链接(`symbolic link`)当作相等的对象来看待。所幸`File`类没有这样做。

- **不要将`equals`声明中的`Object`对象替换为其他的类型**。程序员编写出下面这样的`equals`方法并不鲜见，这会使程序员花上数个小时都搞不清为什么它不能正常工作：
    ``` java
    // Broken - parameter type must be Object!
    public boolean equals(MyClass o) {
        ...
    }
    ```
    　　问题在于，这个方法并没有覆盖`Object.equals`，因为它的参数应该是`Object`类型，相反，它重载(`overload`)了`Object.equals`（Item 52）。在原有`equals`方法的基础上，再提供一个“强类型(`strongly typed`)”的`equals`方法，即使这两个方法返回同样的结果（没有强制的理由必须这样做），这也是不可以接受的。因为它能导致`@Override`注解在子类生成误报并提供错误的安全感。
    
    　　`@Override`注解的用法一致，就如本条目中所示，可以防止犯这种错误（Item 40）。这个`equals`方法不能编译，错误消息会告诉你到底哪里出了问题：
     ``` java
     // Still broken, but won’t compile
     @Override public boolean equals(MyClass o) {
         ...
     }
     ```
    　　编写和测试`equals`（和`hashCode`）方法很繁琐，结果代码很平常。手动编写和测试这些方法的一个很好的替代方法是使用Google的开源`AutoValue`框架，该框架会自动为您生成这些方法，由类中的单个注释触发。在大多数情况下，`AutoValue`生成的方法与您自己编写的方法基本相同。
    
    　　IDE也有生成`equals`和`hashCode`方法的工具，但生成的源代码比使用`AutoValue`的代码更冗长，更不易读，不会自动跟踪类中的更改，因此需要测试。也就是说，让IDE生成`equals`（和`hashCode`）方法通常比手动实现它们更可取，因为IDE不会造成粗心的错误，大多数人也会这样做。
    
    　　总之，不要覆盖`equals`方法，除非你必须：在许多情况下，从`Object`继承的实现完全符合您的要求。如果你确实覆盖了`equals`，请确保比较所有类的重要字段，并以保留`equals`约定的所有五个条款的方式对它们进行比较。