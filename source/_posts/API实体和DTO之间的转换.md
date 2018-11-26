---
title: Spring REST API实体和DTO之间的转换
date: 2018-11-26 11:00:30
tags: 
    - Spring
categories:
    - Spring
---

# Spring REST API实体和DTO之间的转换

## 1. 概览

在本教程中，我们将处理在Spring应用程序的内部实体和被发送到客户端的外部DTO（数据传输对象）之间的转换。

## 2. ModelMapper

首先，让我们看看用来执行实体-DTO转换的主要类库——ModelMapper。

我们需要在pom.xml中添加这个依赖：

``` maven pom.xml
<dependency>
    <groupId>org.modelmapper</groupId>
    <artifactId>modelmapper</artifactId>
    <version>2.3.1</version>
</dependency>
```
<!-- more -->
如果需要检查这个库是否有更新的版本， 请[点击这里](https://search.maven.org/classic/#search|gav|1|g%3A%22org.modelmapper%22%20AND%20a%3A%22modelmapper%22)。

然后，我们将在Spring配置中定义ModelMapperbean：

``` java
@Bean
public ModelMapper modelMapper() {
    return new ModelMapper();
}
```

## 3. DTO

话分两头，接下来让我们来看看本例使用的DTO——PostDto。

``` java PostDto.java
public class PostDto {
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private Long id;

    private String title;

    private String url;

    private String date;

    private UserDto user;

    public Date getSubmissionDateConverted(String timezone) throws ParseException {
        dateFormat.setTimeZone(TimeZone.getTimeZone(timezone));
        return dateFormat.parse(this.date);
    }

    public void setSubmissionDate(Date date, String timezone) {
        dateFormat.setTimeZone(TimeZone.getTimeZone(timezone));
        this.date = dateFormat.format(date);
    }

    // standard getters and setters
}
```

请注意，上面与日期相关的两个方法，它们是用来处理客户端和服务器之间日期数据转换的：

```
    getSubmissionDateConverted()方法将日期字符串转换为服务器所在时区中的日期，以便将其用于持久化Post实体
    setSubmissionDate()方法是将DTO的日期设置为当前用户所在时区的Post日期
```

## 4. 服务层

现在让我们看一下服务层的操作——它显然是与实体（而不是DTO）一起工作：
``` java
public List<Post> getPostsList(
  int page, int size, String sortDir, String sort) {

    PageRequest pageReq
     = new PageRequest(page, size, Sort.Direction.fromString(sortDir), sort);

    Page<Post> posts = postRepository
      .findByUser(userService.getCurrentUser(), pageReq);
    return posts.getContent();
}
```
## 5. 控制器层

下面让我们来看看服务层上面的控制器层，这才是转换操作实际触发的地方。  
现在，让我们来看一个标准的控制器，一个暴露Post资源的REST API。  

我们将在这里展示一些简单的CRUD操作：创建、更新、获取一条和全部记录。考虑到操作非常简单，并且我们特别感兴趣的是实体-DTO转换方面：  

``` java PostRestController.java
@Controller
class PostRestController {

    @Autowired
    private IPostService postService;

    @Autowired
    private IUserService userService;

    @Autowired
    private ModelMapper modelMapper;

    @RequestMapping(method = RequestMethod.GET)
    @ResponseBody
    public List<PostDto> getPosts(...) {
        //...
        List<Post> posts = postService.getPostsList(page, size, sortDir, sort);
        return posts.stream()
          .map(post -> convertToDto(post))
          .collect(Collectors.toList());
    }

    @RequestMapping(method = RequestMethod.POST)
    @ResponseStatus(HttpStatus.CREATED)
    @ResponseBody
    public PostDto createPost(@RequestBody PostDto postDto) {
        Post post = convertToEntity(postDto);
        Post postCreated = postService.createPost(post));
        return convertToDto(postCreated);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    @ResponseBody
    public PostDto getPost(@PathVariable("id") Long id) {
        return convertToDto(postService.getPostById(id));
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
    @ResponseStatus(HttpStatus.OK)
    public void updatePost(@RequestBody PostDto postDto) {
        Post post = convertToEntity(postDto);
        postService.updatePost(post);
    }
}
```

这是我们从Post实体到PostDto的转换：
``` java
private PostDto convertToDto(Post post) {
    PostDto postDto = modelMapper.map(post, PostDto.class);
    postDto.setSubmissionDate(post.getSubmissionDate(), 
        userService.getCurrentUser().getPreference().getTimezone());
    return postDto;
}
```
这是从DTO到实体的转换：
``` java
private Post convertToEntity(PostDto postDto) throws ParseException {
    Post post = modelMapper.map(postDto, Post.class);
    post.setSubmissionDate(postDto.getSubmissionDateConverted(
      userService.getCurrentUser().getPreference().getTimezone()));

    if (postDto.getId() != null) {
        Post oldPost = postService.getPostById(postDto.getId());
        post.setRedditID(oldPost.getRedditID());
        post.setSent(oldPost.isSent());
    }
    return post;
}
```
因此，正如您所看到的，在modelmapper库的帮助下，转换逻辑是快速且简单的——我们使用了modelMapper的map API，并且在不编写任何转换逻辑的情况下完成了数据转换。

## 6. 单元测试

最后，让我们做一个非常简单的测试，以确保实体和DTO之间的转换可以很好地工作：

``` java PostDtoUnitTest.java
public class PostDtoUnitTest {

    private ModelMapper modelMapper = new ModelMapper();

    @Test
    public void whenConvertPostEntityToPostDto_thenCorrect() {
        Post post = new Post();
        post.setId(Long.valueOf(1));
        post.setTitle(randomAlphabetic(6));
        post.setUrl("www.test.com");

        PostDto postDto = modelMapper.map(post, PostDto.class);
        assertEquals(post.getId(), postDto.getId());
        assertEquals(post.getTitle(), postDto.getTitle());
        assertEquals(post.getUrl(), postDto.getUrl());
    }

    @Test
    public void whenConvertPostDtoToPostEntity_thenCorrect() {
        PostDto postDto = new PostDto();
        postDto.setId(Long.valueOf(1));
        postDto.setTitle(randomAlphabetic(6));
        postDto.setUrl("www.test.com");

        Post post = modelMapper.map(postDto, Post.class);
        assertEquals(postDto.getId(), post.getId());
        assertEquals(postDto.getTitle(), post.getTitle());
        assertEquals(postDto.getUrl(), post.getUrl());
    }
}
```
