---
title: Spring源码学习笔记
date: 2021-03-25 17:05:00
tags:
    - Java
    - Spring
categories:
    - Java
    - Spring
---

# Spring源码学习笔记

## Spring IoC介绍

IoC 全称为 `Inversion of Control`，翻译为 “控制反转”，它还有一个别名为 DI（`Dependency Injection`）,即依赖注入。

> **所谓 IoC ，就是由 Spring IoC 容器来负责对象的生命周期和对象之间的关系**

1. **谁控制谁**：在传统的开发模式下，我们都是采用直接 new 一个对象的方式来创建对象，也就是说你依赖的对象直接由你自己控制，但是有了 IoC 容器后，则直接由 IoC 容器来控制。所以“谁控制谁”，当然是 IoC 容器控制对象
2. **控制什么**：控制对象。
3. **为何是反转**：没有 IoC 的时候我们都是在自己对象中主动去创建被依赖的对象，这是正转。但是有了 IoC 后，所依赖的对象直接由 IoC 容器创建后注入到被注入的对象中，依赖的对象由原来的主动获取变成被动接受，所以是反转。
4. **哪些方面反转了**：所依赖对象的获取被反转了。

<!-- more -->

## 调试环境搭建

### 依赖工具

- Gradle
- Git
- JDK1.8+
- IntelliJ IDEA

### 源码拉取

```shell
git clone https://github.com/spring-projects/spring-framework.git
```

### 预编译 `spring-oxm` 项目

```shell
./gradlew :spring-oxm:compileTestJava
```

## Spring 统一资源加载策略

### 统一资源：Resource

`org.springframework.core.io.Resource` 为 Spring 框架所有资源的抽象和访问接口，它继承 `org.springframework.core.io.InputStreamSource`接口。作为所有资源的统一抽象，Resource 定义了一些通用的方法，由子类 `AbstractResource` 提供统一的默认实现。

如果我们想要实现自定义的 Resource ，记住不要实现 Resource 接口，而应该继承 AbstractResource 抽象类，然后根据当前的具体资源特性覆盖相应的方法即可。

### 统一资源定位：ResourceLoader

`org.springframework.core.io.ResourceLoader` 为 Spring 资源加载的统一抽象，具体的资源加载则由相应的实现类来完成，所以我们可以将 ResourceLoader 称作为统一资源定位器。

```java
public interface ResourceLoader {

	String CLASSPATH_URL_PREFIX = ResourceUtils.CLASSPATH_URL_PREFIX; // CLASSPATH URL 前缀。默认为："classpath:"

	Resource getResource(String location);

	ClassLoader getClassLoader();

}
```

- `#getResource(String location)`方法，根据所提供资源的路径 location 返回 Resource 实例，但是它不确保该 Resource 一定存在，需要调用`Resource#exist()`方法来判断。
  - 该方法支持以下模式的资源加载：
    - URL位置资源，如 `"file:C:/test.dat"` 。
    - ClassPath位置资源，如 `"classpath:test.dat"` 。
    - 相对路径资源，如 `"WEB-INF/test.dat"` ，此时返回的Resource 实例，根据实现不同而不同。
  - 该方法的主要实现是在其子类 DefaultResourceLoader 中实现，具体过程我们在分析 DefaultResourceLoader 时做详细说明。
- `#getClassLoader()` 方法，返回 ClassLoader 实例，对于想要获取 ResourceLoader 使用的 ClassLoader 用户来说，可以直接调用该方法来获取。在分析 Resource 时，提到了一个类 ClassPathResource ，这个类是可以根据指定的 ClassLoader 来加载资源的。

### 小结

至此 Spring 整个资源记载过程已经分析完毕。下面简要总结下：

- Spring 提供了 Resource 和 ResourceLoader 来统一抽象整个资源及其定位。使得资源与资源的定位有了一个更加清晰的界限，并且提供了合适的 Default 类，使得自定义实现更加方便和清晰。
- AbstractResource 为 Resource 的默认抽象实现，它对 Resource 接口做了一个统一的实现，子类继承该类后只需要覆盖相应的方法即可，同时对于自定义的 Resource 我们也是继承该类。
- DefaultResourceLoader 同样也是 ResourceLoader 的默认实现，在自定 ResourceLoader 的时候我们除了可以继承该类外还可以实现 ProtocolResolver 接口来实现自定资源加载协议。
- DefaultResourceLoader 每次只能返回单一的资源，所以 Spring 针对这个提供了另外一个接口 ResourcePatternResolver ，该接口提供了根据指定的 locationPattern 返回多个资源的策略。其子类 PathMatchingResourcePatternResolver 是一个集大成者的 ResourceLoader ，因为它即实现了 `Resource getResource(String location)` 方法，也实现了 `Resource[] getResources(String locationPattern)` 方法。

## 加载 BeanDefinition

先看一段熟悉的代码：

```java
ClassPathResource resource = new ClassPathResource("bean.xml"); // <1>
DefaultListableBeanFactory factory = new DefaultListableBeanFactory(); // <2>
XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(factory); // <3>
reader.loadBeanDefinitions(resource); // <4>
```

这段代码是 Spring 中编程式使用 IoC 容器，通过这四段简单的代码，我们可以初步判断 IoC 容器的使用过程。

1. 获取资源
2. 获取 BeanFactory
3. 根据新建的 BeanFactory 创建一个 BeanDefinitionReader 对象，该 Reader 对象为资源的**解析器**
4. 装载资源

整个过程就分为三个步骤：资源定位、装载、注册：

- **资源定位**。我们一般用外部资源来描述 Bean 对象，所以在初始化 IoC 容器的第一步就是需要定位这个外部资源。
- **装载**。装载就是 BeanDefinition 的载入。BeanDefinitionReader 读取、解析 Resource 资源，也就是将用户定义的 Bean 表示成 IoC 容器的内部数据结构：BeanDefinition 。
  - 在 IoC 容器内部维护着一个 BeanDefinition Map 的数据结构
  - 在配置文件中每一个 `<bean>` 都对应着一个 BeanDefinition 对象。
  - 本文，我们分享的就是**装载**这个步骤。
- **注册**。向 IoC 容器注册在第二步解析好的 BeanDefinition，这个过程是通过 BeanDefinitionRegistry 接口来实现的。在 IoC 容器内部其实是将第二个过程解析得到的 BeanDefinition 注入到一个 HashMap 容器中，IoC 容器就是通过这个 HashMap 来维护这些 BeanDefinition 的。
  - 在这里需要注意的一点是这个过程并没有完成依赖注入（Bean 创建），Bean 创建是发生在应用第一次调用 `#getBean(...)` 方法，向容器索要 Bean 时。
  - 当然我们可以通过设置预处理，即对某个 Bean 设置 `lazyinit = false` 属性，那么这个 Bean 的依赖注入就会在容器初始化的时候完成。

> 简单的说，上面步骤的结果是，XML Resource => XML Document => Bean Definition 。

###  loadBeanDefinitions

资源定位在前面已经分析了，下面我们直接分析**加载**，上面看到的 `reader.loadBeanDefinitions(resource)` 代码，才是加载资源的真正实现，所以我们直接从该方法入手。代码如下：

```
// XmlBeanDefinitionReader.java
@Override
public int loadBeanDefinitions(Resource resource) throws BeanDefinitionStoreException {
	return loadBeanDefinitions(new EncodedResource(resource));
}
```

- 从指定的 xml 文件加载 Bean Definition ，这里会先对 Resource 资源封装成 `org.springframework.core.io.support.EncodedResource` 对象。这里为什么需要将 Resource 封装成 EncodedResource 呢？主要是为了对 Resource 进行编码，保证内容读取的正确性。
- 然后，再调用 `#loadBeanDefinitions(EncodedResource encodedResource)` 方法，执行真正的逻辑实现。

```java
/**
 * 当前线程，正在加载的 EncodedResource 集合。
 */
private final ThreadLocal<Set<EncodedResource>> resourcesCurrentlyBeingLoaded = new NamedThreadLocal<>("XML bean definition resources currently being loaded");

public int loadBeanDefinitions(EncodedResource encodedResource) throws BeanDefinitionStoreException {
	Assert.notNull(encodedResource, "EncodedResource must not be null");
	if (logger.isTraceEnabled()) {
		logger.trace("Loading XML bean definitions from " + encodedResource);
	}

	// <1> 获取已经加载过的资源
	Set<EncodedResource> currentResources = this.resourcesCurrentlyBeingLoaded.get();
	if (currentResources == null) {
		currentResources = new HashSet<>(4);
		this.resourcesCurrentlyBeingLoaded.set(currentResources);
	}
	if (!currentResources.add(encodedResource)) { // 将当前资源加入记录中。如果已存在，抛出异常
		throw new BeanDefinitionStoreException("Detected cyclic loading of " + encodedResource + " - check your import definitions!");
	}
	try {
		// <2> 从 EncodedResource 获取封装的 Resource ，并从 Resource 中获取其中的 InputStream
		InputStream inputStream = encodedResource.getResource().getInputStream();
		try {
			InputSource inputSource = new InputSource(inputStream);
			if (encodedResource.getEncoding() != null) { // 设置编码
				inputSource.setEncoding(encodedResource.getEncoding());
			}
			// 核心逻辑部分，执行加载 BeanDefinition
			return doLoadBeanDefinitions(inputSource, encodedResource.getResource());
		} finally {
			inputStream.close();
		}
	} catch (IOException ex) {
		throw new BeanDefinitionStoreException("IOException parsing XML document from " + encodedResource.getResource(), ex);
	} finally {
		// 从缓存中剔除该资源 <3>
		currentResources.remove(encodedResource);
		if (currentResources.isEmpty()) {
			this.resourcesCurrentlyBeingLoaded.remove();
		}
	}
}
```

- `<1>`处，通过`resourcesCurrentlyBeingLoaded.get()`代码，来获取已经加载过的资源，然后将`encodedResource`加入其中，如果`resourcesCurrentlyBeingLoaded`中已经存在该资源，则抛出 BeanDefinitionStoreException 异常。
  - 为什么需要这么做呢？答案在 `"Detected cyclic loading"` ，避免一个 EncodedResource 在加载时，还没加载完成，又加载自身，从而导致**死循环**。
  - 也因此，在 `<3>` 处，当一个 EncodedResource 加载完成后，需要从缓存中剔除。
- `<2>` 处理，从 `encodedResource` 获取封装的 Resource 资源，并从 Resource 中获取相应的 InputStream ，然后将 InputStream 封装为 InputSource ，最后调用 `#doLoadBeanDefinitions(InputSource inputSource, Resource resource)` 方法，执行加载 Bean Definition 的真正逻辑。

### doLoadBeanDefinitions

```java
/**
 * Actually load bean definitions from the specified XML file.
 * @param inputSource the SAX InputSource to read from
 * @param resource the resource descriptor for the XML file
 * @return the number of bean definitions found
 * @throws BeanDefinitionStoreException in case of loading or parsing errors
 * @see #doLoadDocument
 * @see #registerBeanDefinitions
 */
protected int doLoadBeanDefinitions(InputSource inputSource, Resource resource)
		throws BeanDefinitionStoreException {
	try {
		// <1> 获取 XML Document 实例
		Document doc = doLoadDocument(inputSource, resource);
		// <2> 根据 Document 实例，注册 Bean 信息
		int count = registerBeanDefinitions(doc, resource);
		if (logger.isDebugEnabled()) {
			logger.debug("Loaded " + count + " bean definitions from " + resource);
		}
		return count;
	} catch (BeanDefinitionStoreException ex) {
		throw ex;
	} catch (SAXParseException ex) {
		throw new XmlBeanDefinitionStoreException(resource.getDescription(),
                "Line " + ex.getLineNumber() + " in XML document from " + resource + " is invalid", ex);
	} catch (SAXException ex) {
		throw new XmlBeanDefinitionStoreException(resource.getDescription(),
				"XML document from " + resource + " is invalid", ex);
	} catch (ParserConfigurationException ex) {
		throw new BeanDefinitionStoreException(resource.getDescription(),
				"Parser configuration exception parsing XML from " + resource, ex);
	} catch (IOException ex) {
		throw new BeanDefinitionStoreException(resource.getDescription(),
				"IOException parsing XML document from " + resource, ex);
	} catch (Throwable ex) {
		throw new BeanDefinitionStoreException(resource.getDescription(),
				"Unexpected exception parsing XML document from " + resource, ex);
	}
}
```

- 在 `<1>` 处，调用 `#doLoadDocument(InputSource inputSource, Resource resource)` 方法，根据 xml 文件，获取 Document 实例。
- 在 `<2>` 处，调用 `#registerBeanDefinitions(Document doc, Resource resource)` 方法，根据获取的 Document 实例，注册 Bean 信息。

### doLoadDocument

```java
/**
 * 获取 XML Document 实例
 *
 * Actually load the specified document using the configured DocumentLoader.
 * @param inputSource the SAX InputSource to read from
 * @param resource the resource descriptor for the XML file
 * @return the DOM Document
 * @throws Exception when thrown from the DocumentLoader
 * @see #setDocumentLoader
 * @see DocumentLoader#loadDocument
 */
protected Document doLoadDocument(InputSource inputSource, Resource resource) throws Exception {
	return this.documentLoader.loadDocument(inputSource, getEntityResolver(), this.errorHandler,
			getValidationModeForResource(resource), isNamespaceAware());
}
```

1. 调用 `#getValidationModeForResource(Resource resource)` 方法，获取指定资源（xml）的**验证模式**。详细解析，见 [《获取验证模型》](#获取验证模型-ValidationMode) 。

2. 调用 `DocumentLoader#loadDocument(InputSource inputSource, EntityResolver entityResolver, ErrorHandler errorHandler, int validationMode, boolean namespaceAware)` 方法，获取 XML Document 实例。详细解析，见 [《获取 Document 对象》](#获取 Document 对象) 。

### registerBeanDefinitions

该方法的详细解析，见 [《注册 BeanDefinition》](#注册 BeanDefinition) 。

## 获取验证模型(ValidationMode)

在核心逻辑方法 `#doLoadBeanDefinitions(InputSource inputSource, Resource resource)` 方法中，中主要是做三件事情：

1. 调用 `#getValidationModeForResource(Resource resource)` 方法，获取指定资源（xml）的**验证模式**。
2. 调用 `DocumentLoader#loadDocument(InputSource inputSource, EntityResolver entityResolver,ErrorHandler errorHandler, int validationMode, boolean namespaceAware)` 方法，获取 XML Document 实例。
3. 调用 `#registerBeanDefinitions(Document doc, Resource resource)` 方法，根据获取的 Document 实例，注册 Bean 信息。

这章主要**第 1 步**，分析获取 xml 文件的验证模式。为什么需要获取验证模式呢？原因如下：

> XML 文件的验证模式保证了 XML 文件的正确性。

### DTD 与 XSD 的区别

#### DTD

DTD(Document Type Definition)，即文档类型定义，为 XML 文件的验证机制，属于 XML 文件中组成的一部分。DTD 是一种保证 XML 文档格式正确的有效验证方式，它定义了相关 XML 文档的元素、属性、排列方式、元素的内容类型以及元素的层次结构。其实 DTD 就相当于 XML 中的 “词汇”和“语法”，我们可以通过比较 XML 文件和 DTD 文件 来看文档是否符合规范，元素和标签使用是否正确。

要在 Spring 中使用 DTD，需要在 Spring XML 文件头部声明：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE beans PUBLIC  "-//SPRING//DTD BEAN//EN"  "http://www.springframework.org/dtd/spring-beans.dtd">
```

DTD 在一定的阶段推动了 XML 的发展，但是它本身存在着一些**缺陷**：

1. 它没有使用 XML 格式，而是自己定义了一套格式，相对解析器的重用性较差；而且 DTD 的构建和访问没有标准的编程接口，因而解析器很难简单的解析 DTD 文档。
2. DTD 对元素的类型限制较少；同时其他的约束力也叫弱。
3. DTD 扩展能力较差。
4. 基于正则表达式的 DTD 文档的描述能力有限。

#### XSD

针对 DTD 的缺陷，W3C 在 2001 年推出 XSD。XSD（XML Schemas Definition）即 XML Schema 语言。XML Schema 本身就是一个 XML文档，使用的是 XML 语法，因此可以很方便的解析 XSD 文档。相对于 DTD，XSD 具有如下**优势**：

1. XML Schema 基于 XML ，没有专门的语法。
2. XML Schema 可以象其他 XML 文件一样解析和处理。
3. XML Schema 比 DTD 提供了更丰富的数据类型。
4. XML Schema 提供可扩充的数据模型。
5. XML Schema 支持综合命名空间。
6. XML Schema 支持属性组。

### getValidationModeForResource

```java
// XmlBeanDefinitionReader.java

// 禁用验证模式
public static final int VALIDATION_NONE = XmlValidationModeDetector.VALIDATION_NONE;
// 自动获取验证模式
public static final int VALIDATION_AUTO = XmlValidationModeDetector.VALIDATION_AUTO;
// DTD 验证模式
public static final int VALIDATION_DTD = XmlValidationModeDetector.VALIDATION_DTD;
// XSD 验证模式
public static final int VALIDATION_XSD = XmlValidationModeDetector.VALIDATION_XSD;
	
/**
 * 验证模式。默认为自动模式。
 */
private int validationMode = VALIDATION_AUTO;
	
protected int getValidationModeForResource(Resource resource) {
	// <1> 获取指定的验证模式
	int validationModeToUse = getValidationMode();
	// 首先，如果手动指定，则直接返回
	if (validationModeToUse != VALIDATION_AUTO) {
		return validationModeToUse;
	}
	// 其次，自动获取验证模式
	int detectedMode = detectValidationMode(resource);
	if (detectedMode != VALIDATION_AUTO) {
		return detectedMode;
	}
	// 最后，使用 VALIDATION_XSD 做为默认
	// Hmm, we didn't get a clear indication... Let's assume XSD,
	// since apparently no DTD declaration has been found up until
	// detection stopped (before finding the document's root tag).
	return VALIDATION_XSD;
}
```

## 获取 Document 对象

在 `XmlBeanDefinitionReader#doLoadDocument(InputSource inputSource, Resource resource)` 方法，中做了两件事情：

- 调用`#getValidationModeForResource(Resource resource)`方法，获取指定资源（xml）的验证模式。
- 调用 `DocumentLoader#loadDocument(InputSource inputSource, EntityResolver entityResolver, ErrorHandler errorHandler, int validationMode, boolean namespaceAware)` 方法，获取 XML Document 实例。

### DocumentLoader

获取 Document 的策略，由接口 `org.springframework.beans.factory.xml.DocumentLoader` 定义。代码如下：

```java
public interface DocumentLoader {

	Document loadDocument(
			InputSource inputSource, EntityResolver entityResolver,
			ErrorHandler errorHandler, int validationMode, boolean namespaceAware)
			throws Exception;

}
```

- `inputSource` 方法参数，加载 Document 的 Resource 资源。
- `entityResolver` 方法参数，解析文件的解析器。
- `errorHandler` 方法参数，处理加载 Document 对象的过程的错误。
- `validationMode` 方法参数，验证模式。
- `namespaceAware` 方法参数，命名空间支持。如果要提供对 XML 名称空间的支持，则需要值为 `true` 。

#### DefaultDocumentLoader

该方法由 DocumentLoader 的默认实现类 `org.springframework.beans.factory.xml.DefaultDocumentLoader` 实现。代码如下：

```java
/**
 * Load the {@link Document} at the supplied {@link InputSource} using the standard JAXP-configured
 * XML parser.
 */
@Override
public Document loadDocument(InputSource inputSource, EntityResolver entityResolver,
		ErrorHandler errorHandler, int validationMode, boolean namespaceAware) throws Exception {
	// <1> 创建 DocumentBuilderFactory
	DocumentBuilderFactory factory = createDocumentBuilderFactory(validationMode, namespaceAware);
	if (logger.isTraceEnabled()) {
		logger.trace("Using JAXP provider [" + factory.getClass().getName() + "]");
	}
	// <2> 创建 DocumentBuilder
	DocumentBuilder builder = createDocumentBuilder(factory, entityResolver, errorHandler);
	// <3> 解析 XML InputSource 返回 Document 对象
	return builder.parse(inputSource);
}
```

- 首先，调用 #`createDocumentBuilderFactory(...)` 方法，创建 `javax.xml.parsers.DocumentBuilderFactory` 对象。代码如下：

  ```java
  /**
   * JAXP attribute used to configure the schema language for validation.
   */
  private static final String SCHEMA_LANGUAGE_ATTRIBUTE = "http://java.sun.com/xml/jaxp/properties/schemaLanguage";
  /**
   * JAXP attribute value indicating the XSD schema language.
   */
  private static final String XSD_SCHEMA_LANGUAGE = "http://www.w3.org/2001/XMLSchema";
  protected DocumentBuilderFactory createDocumentBuilderFactory(int validationMode, boolean namespaceAware)
          throws ParserConfigurationException {
      // 创建 DocumentBuilderFactory
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware(namespaceAware); // 设置命名空间支持
      if (validationMode != XmlValidationModeDetector.VALIDATION_NONE) {
          factory.setValidating(true); // 开启校验
          // XSD 模式下，设置 factory 的属性
          if (validationMode == XmlValidationModeDetector.VALIDATION_XSD) {
              // Enforce namespace aware for XSD...
              factory.setNamespaceAware(true); // XSD 模式下，强制设置命名空间支持
              // 设置 SCHEMA_LANGUAGE_ATTRIBUTE
              try {
                  factory.setAttribute(SCHEMA_LANGUAGE_ATTRIBUTE, XSD_SCHEMA_LANGUAGE);
              } catch (IllegalArgumentException ex) {
                  ParserConfigurationException pcex = new ParserConfigurationException(
                          "Unable to validate using XSD: Your JAXP provider [" + factory +
                          "] does not support XML Schema. Are you running on Java 1.4 with Apache Crimson? " +
                          "Upgrade to Apache Xerces (or Java 1.5) for full XSD support.");
                  pcex.initCause(ex);
                  throw pcex;
              }
          }
      }
      return factory;
  }
  ```

- 然后，调用 `#createDocumentBuilder(DocumentBuilderFactory factory, EntityResolver entityResolver,ErrorHandler errorHandler)` 方法，创建 `javax.xml.parsers.DocumentBuilder` 对象。代码如下：

  ```
  protected DocumentBuilder createDocumentBuilder(DocumentBuilderFactory factory,
  		@Nullable EntityResolver entityResolver, @Nullable ErrorHandler errorHandler)
  		throws ParserConfigurationException {
  	// 创建 DocumentBuilder 对象
  	DocumentBuilder docBuilder = factory.newDocumentBuilder();
  	// <x> 设置 EntityResolver 属性
  	if (entityResolver != null) {
  		docBuilder.setEntityResolver(entityResolver);
  	}
  	// 设置 ErrorHandler 属性
  	if (errorHandler != null) {
  		docBuilder.setErrorHandler(errorHandler);
  	}
  	return docBuilder;
  }
  ```

  - 在 `<x>` 处，设置 DocumentBuilder 的 **EntityResolver** 属性。

- 最后，调用 `DocumentBuilder#parse(InputSource)` 方法，解析 InputSource ，返回 Document 对象。

## 注册 BeanDefinitions

获取 XML Document 对象后，会根据该对象和 Resource 资源对象调用 `XmlBeanDefinitionReader#registerBeanDefinitions(Document doc, Resource resource)` 方法，开始注册 BeanDefinitions 之旅。代码如下：

```java
// AbstractBeanDefinitionReader.java
private final BeanDefinitionRegistry registry;

// XmlBeanDefinitionReader.java
public int registerBeanDefinitions(Document doc, Resource resource) throws BeanDefinitionStoreException {
	// <1> 创建 BeanDefinitionDocumentReader 对象
	BeanDefinitionDocumentReader documentReader = createBeanDefinitionDocumentReader();
	// <2> 获取已注册的 BeanDefinition 数量
	int countBefore = getRegistry().getBeanDefinitionCount();
	// <3> 创建 XmlReaderContext 对象
	// <4> 注册 BeanDefinition
	documentReader.registerBeanDefinitions(doc, createReaderContext(resource));
	// 计算新注册的 BeanDefinition 数量
	return getRegistry().getBeanDefinitionCount() - countBefore;
}
```

- `<1>` 处，调用 `#createBeanDefinitionDocumentReader()` 方法，实例化 BeanDefinitionDocumentReader 对象。

- `<2>` 处，调用 `BeanDefinitionRegistry#getBeanDefinitionCount()` 方法，获取**已注册**的 BeanDefinition 数量。
- `<3>` 处，调用 `#createReaderContext(Resource resource)` 方法，创建 XmlReaderContext 对象。
- `<4>` 处，调用 `BeanDefinitionDocumentReader#registerBeanDefinitions(Document doc, XmlReaderContext readerContext)` 方法，读取 XML 元素，注册 BeanDefinition 们。
- `<5>` 处，计**算新注册**的 BeanDefinition 数量。

### createBeanDefinitionDocumentReader

`#createBeanDefinitionDocumentReader()`，实例化 BeanDefinitionDocumentReader 对象。代码如下：

```java
/**
 * documentReader 的类
 *
 * @see #createBeanDefinitionDocumentReader() 
 */
private Class<? extends BeanDefinitionDocumentReader> documentReaderClass = DefaultBeanDefinitionDocumentReader.class;

protected BeanDefinitionDocumentReader createBeanDefinitionDocumentReader() {
	return BeanUtils.instantiateClass(this.documentReaderClass);
}
```

- `documentReaderClass` 的默认值为 `DefaultBeanDefinitionDocumentReader.class` 。关于它，我们在后续的文章，详细解析。

###  registerBeanDefinitions

`BeanDefinitionDocumentReader#registerBeanDefinitions(Document doc, XmlReaderContext readerContext)` 方法，注册 BeanDefinition ，在接口 BeanDefinitionDocumentReader 中定义。代码如下：

```java
public interface BeanDefinitionDocumentReader {

	/**
	 * Read bean definitions from the given DOM document and
	 * register them with the registry in the given reader context.
	 * @param doc the DOM document
	 * @param readerContext the current context of the reader
	 * (includes the target registry and the resource being parsed)
	 * @throws BeanDefinitionStoreException in case of parsing errors
	 */
	void registerBeanDefinitions(Document doc, XmlReaderContext readerContext)
			throws BeanDefinitionStoreException;

}
```

**从给定的 Document 对象中解析定义的 BeanDefinition 并将他们注册到注册表中**。方法接收两个参数：

- `doc` 方法参数：待解析的 Document 对象。
- `readerContext` 方法，解析器的当前上下文，包括目标注册表和被解析的资源。

####  DefaultBeanDefinitionDocumentReader

BeanDefinitionDocumentReader 有且只有一个默认实现类 DefaultBeanDefinitionDocumentReader 。它对 `#registerBeanDefinitions(...)` 方法的实现代码如下：

DefaultBeanDefinitionDocumentReader 对该方法提供了实现：

```java
@Nullable
private XmlReaderContext readerContext;

@Nullable
private BeanDefinitionParserDelegate delegate;
    
/**
 * This implementation parses bean definitions according to the "spring-beans" XSD
 * (or DTD, historically).
 * <p>Opens a DOM Document; then initializes the default settings
 * specified at the {@code <beans/>} level; then parses the contained bean definitions.
 */
@Override
public void registerBeanDefinitions(Document doc, XmlReaderContext readerContext) {
    this.readerContext = readerContext;
    // 获得 XML Document Root Element
    // 执行注册 BeanDefinition
    doRegisterBeanDefinitions(doc.getDocumentElement());
}

/**
 * Register each bean definition within the given root {@code <beans/>} element.
 */
@SuppressWarnings("deprecation")  // for Environment.acceptsProfiles(String...)
protected void doRegisterBeanDefinitions(Element root) {
    // Any nested <beans> elements will cause recursion in this method. In
    // order to propagate and preserve <beans> default-* attributes correctly,
    // keep track of the current (parent) delegate, which may be null. Create
    // the new (child) delegate with a reference to the parent for fallback purposes,
    // then ultimately reset this.delegate back to its original (parent) reference.
    // this behavior emulates a stack of delegates without actually necessitating one.
    // 记录老的 BeanDefinitionParserDelegate 对象
    BeanDefinitionParserDelegate parent = this.delegate;
    // <1> 创建 BeanDefinitionParserDelegate 对象，并进行设置到 delegate
    this.delegate = createDelegate(getReaderContext(), root, parent);
    // <2> 检查 <beans /> 根标签的命名空间是否为空，或者是 http://www.springframework.org/schema/beans
    if (this.delegate.isDefaultNamespace(root)) {
        // <2.1> 处理 profile 属性。可参见《Spring3自定义环境配置 <beans profile="">》http://nassir.iteye.com/blog/1535799
        String profileSpec = root.getAttribute(PROFILE_ATTRIBUTE);
        if (StringUtils.hasText(profileSpec)) {
            // <2.2> 使用分隔符切分，可能有多个 profile 。
            String[] specifiedProfiles = StringUtils.tokenizeToStringArray(
                    profileSpec, BeanDefinitionParserDelegate.MULTI_VALUE_ATTRIBUTE_DELIMITERS);
            // <2.3> 如果所有 profile 都无效，则不进行注册
            // We cannot use Profiles.of(...) since profile expressions are not supported
            // in XML config. See SPR-12458 for details.
            if (!getReaderContext().getEnvironment().acceptsProfiles(specifiedProfiles)) {
                if (logger.isDebugEnabled()) {
                    logger.debug("Skipped XML bean definition file due to specified profiles [" + profileSpec +
                            "] not matching: " + getReaderContext().getResource());
                }
                return;
            }
        }
    }

    // <3> 解析前处理
    preProcessXml(root);
    // <4> 解析
    parseBeanDefinitions(root, this.delegate);
    // <5> 解析后处理
    postProcessXml(root);

    // 设置 delegate 回老的 BeanDefinitionParserDelegate 对象
    this.delegate = parent;
}
```

- `<1>` 处，创建 BeanDefinitionParserDelegate 对象，并进行设置到 `delegate` 。BeanDefinitionParserDelegate 是一个重要的类，它负责**解析 BeanDefinition**。代码如下：

  ```java
  protected BeanDefinitionParserDelegate createDelegate(
          XmlReaderContext readerContext, Element root, @Nullable BeanDefinitionParserDelegate parentDelegate) {
      // 创建 BeanDefinitionParserDelegate 对象
      BeanDefinitionParserDelegate delegate = new BeanDefinitionParserDelegate(readerContext);
      // 初始化默认
      delegate.initDefaults(root, parentDelegate);
      return delegate;
  }
  ```

- `<2>` 处，检查 `<beans />` **根**标签的命名空间是否为空，或者是 http://www.springframework.org/schema/beans 。

  - `<2.1>` 处，判断是否 `<beans />` 上配置了 `profile` 属性。
  - `<2.2>` 处，使用分隔符切分，可能有**多个** profile 。
  - `<2.3>` 处，判断，如果所有 profile 都无效，则 `return` 不进行注册。

- `<4>` 处，调用 `#parseBeanDefinitions(Element root, BeanDefinitionParserDelegate delegate)` 方法，进行解析逻辑。详细解析，见 [「3.1 parseBeanDefinitions」](http://svip.iocoder.cn/Spring/IoC-register-BeanDefinitions/#) 。

- `<3>` / `<5>` 处，解析**前后**的处理，目前这两个方法都是空实现，交由子类来实现。代码如下：

  ```java
  protected void preProcessXml(Element root) {}
  
  protected void postProcessXml(Element root) {}
  ```

##### parseBeanDefinitions

`#parseBeanDefinitions(Element root, BeanDefinitionParserDelegate delegate)` 方法，进行解析逻辑。代码如下：

```java
/**
 * Parse the elements at the root level in the document:
 * "import", "alias", "bean".
 * @param root the DOM root element of the document
 */
protected void parseBeanDefinitions(Element root, BeanDefinitionParserDelegate delegate) {
    // <1> 如果根节点使用默认命名空间，执行默认解析
    if (delegate.isDefaultNamespace(root)) {
        // 遍历子节点
        NodeList nl = root.getChildNodes();
        for (int i = 0; i < nl.getLength(); i++) {
            Node node = nl.item(i);
            if (node instanceof Element) {
                Element ele = (Element) node;
                // <1> 如果该节点使用默认命名空间，执行默认解析
                if (delegate.isDefaultNamespace(ele)) {
                    parseDefaultElement(ele, delegate);
                // 如果该节点非默认命名空间，执行自定义解析
                } else {
                    delegate.parseCustomElement(ele);
                }
            }
        }
    // <2> 如果根节点非默认命名空间，执行自定义解析
    } else {
        delegate.parseCustomElement(root);
    }
}
```

- Spring 有两种Bean 声明方式：

  - 配置文件式声明：`<bean id="studentService" class="org.springframework.core.StudentService" />` 。对应 `<1>` 处。
  - 自定义注解方式：`<tx:annotation-driven>` 。对应 `<2>` 处。

- `<1>` 处，如果**根**节点或**子**节点**使用**默认命名空间，调用 `#parseDefaultElement(Element ele, BeanDefinitionParserDelegate delegate)` 方法，执行默认解析。代码如下：

  ```java
  private void parseDefaultElement(Element ele, BeanDefinitionParserDelegate delegate) {
  	if (delegate.nodeNameEquals(ele, IMPORT_ELEMENT)) { // import
  		importBeanDefinitionResource(ele);
  	} else if (delegate.nodeNameEquals(ele, ALIAS_ELEMENT)) { // alias
  		processAliasRegistration(ele);
  	} else if (delegate.nodeNameEquals(ele, BEAN_ELEMENT)) { // bean
  		processBeanDefinition(ele, delegate);
  	} else if (delegate.nodeNameEquals(ele, NESTED_BEANS_ELEMENT)) { // beans
  		// recurse
  		doRegisterBeanDefinitions(ele);
  	}
  }
  ```

  - 详细的解析，见后续文章。

- `<2>` 处，如果**根**节点或**子**节点**不使用**默认命名空间，调用`BeanDefinitionParserDelegate#parseCustomElement(Element ele)` 方法，执行**自定义**解析。详细的解析，见后续文章。

### createReaderContext

`#createReaderContext(Resource resource)` 方法，创建 XmlReaderContext 对象。代码如下：

```java
private ProblemReporter problemReporter = new FailFastProblemReporter();

private ReaderEventListener eventListener = new EmptyReaderEventListener();

private SourceExtractor sourceExtractor = new NullSourceExtractor();

@Nullable
private NamespaceHandlerResolver namespaceHandlerResolver;

/**
 * Create the {@link XmlReaderContext} to pass over to the document reader.
 */
public XmlReaderContext createReaderContext(Resource resource) {
	return new XmlReaderContext(resource, this.problemReporter, this.eventListener,
			this.sourceExtractor, this, getNamespaceHandlerResolver());
}
```

关于 XmlReaderContext 的详细解析，见后续文章。

