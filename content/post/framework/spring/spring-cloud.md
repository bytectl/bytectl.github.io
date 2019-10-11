---
author: "wuxingzhong"
title: "Spring Cloud"
date: 2019-10-11T17:01:53+08:00
draft: false
tags: ["java", "spring"]
categories:  ["java"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


##  start

- spring-boot-starter-web：全栈Web开发模块，包含嵌入式Tomcat、Spring MVC。
- spring-boot-starter-test：通用测试模块，包含JUnit、Hamcrest、Mockito
- Starter POMs采用spring-boot-starter-*的命名方式

```
http://start.spring.io/
```
- src/main/java：主程序入口 HelloApplication，可以通过直接运行该类来启动Spring Boot应用。
- src/main/resources：配置目录，该目录用来存放应用的一些配置信息，比如应用名、服务端口、数据库链接等。由于我们引入了Web模块，因此产生了static目录与templates目录，前者用于存放静态资源，如图片、CSS、JavaScript等；后者用于存放Web页面的模板文件，这里我们主要演示提供RESTful API，所以这两个目录并不会用到。
- src/test/：单元测试目录，生成的HelloApplicationTests通过JUnit 4实现，可以直接用运行Spring 
- 在项目依赖dependencies配置中，包含了下面两项 starter POMS。
    * spring-boot-starter-web：全栈Web开发模块，包含嵌入式Tomcat、Spring MVC。
    * spring-boot-starter-test：通用测试模块，包含JUnit、Hamcrest、Mockito

##  run

引入 spring-boot-maven-plugin插件
```
<build>
	<plugins>
		<plugin>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-maven-plugin</artifactId>
		</plugin>
	</plugins>
</build>
```
```
mvn spring-boot:run
```

## 配置

###  yaml

- YAML目前还有一些不足，它无法通过@PropertySource注解来加载配置。
- YAML将属性加载到内存中保存的时候是有序的，所以当配置文件中的信息需要具备顺序含义时，YAML的配置方式比起properties配置文件更有优势。

###  参数

除了可以在Spring Boot的配置文件中设置各个Starter模块中预定义的配置属性，也可以在配置文件中定义一些我们需要的自定义属性。比如在application.properties中添加：
```
book.name=SpringCloudInAction
book.author=wuxingzhong
```
然后，在应用中可以通过@Value注解来加载这些自定义的参数，比如：
```java
@Component
public class Book {
    @Value（"${book.name}"）
    private String name;
    @Value（"${book.author}"）
    private String author;
    //省略getter和setter
}
```
@Value注解加载属性值的时候可以支持两种表达式来进行配置，如下所示。
- 一种是上面介绍的PlaceHolder方式，格式为${...}，大括号内为PlaceHolder。
- 另一种是使用SpEL表达式（Spring Expression Language），格式为#{...}，大括号内为SpEL表达式

### 参数引用

```
book.name=SpringCloud
book.author=wuxingzhong
# PlaceHolder的方式进行引用
book.desc=${book.author} is writing《${book.name}》
```
### 使用随机数

```

# 随机字符串
com.value=${random.value}
# 随机int
com.number=${random.int}
# 随机long
com.bignumber=${random.long}
# 10以内的随机数
com.test1=${random.int(10)}
# 10～20的随机数
com.test2=${random.int[10,20]}

# 该配置方式可以设置应用端口等场景，以避免在本地调试时出现端口冲突的麻烦

```
### 命令行参数

在用命令行方式启动 Spring Boot 应用时，连续的两个减号--就是对application.properties 中的属性值进行赋值的标识.
```
java -jar xxx.jar --server.port=8888  --com.name=wuxingzhong

```

### 多环境配置

在 Spring Boot 中，多环境配置的文件名需要满足 application-{profile}.properties的格式，其中{profile}对应你的环境标识
```
# 开发环境
application-dev.properties
# 测试环境
application-test.properties
# 生产环境
application-prod.properties
```

```
vim application.properties 
# 加载application-test.properties配置文件
spring.profiles.active=test
# 或者
java-jar xxx.jar --spring.profiles.active=test

```

### 加载顺序

1. 在命令行中传入的参数。
2. SPRING_APPLICATION_JSON 中的属性。SPRING_APPLICATION_JSON 是以JSON格式配置在系统环境变量中的内容。
3. java:comp/env中的JNDI属性。
4. Java的系统属性，可以通过System.getProperties（）获得的内容。
5. 操作系统的环境变量。
6. 通过random.*配置的随机属性。
7. 位于当前应用 jar 包之外，针对不同{profile}环境的配置文件内容，例如application-{profile}.properties或是YAML定义的配置文件。
8. 位于当前应用 jar 包之内，针对不同{profile}环境的配置文件内容，例如application-{profile}.properties或是YAML定义的配置文件。
9. 位于当前应用jar包之外的application.properties和YAML配置内容。
10. 位于当前应用jar包之内的application.properties和YAML配置内容。
11. 在@Configuration注解修改的类中，通过@PropertySource注解定义的属性。
12. 应用默认属性，使用 SpringApplication.setDefaultProperties 定义的内容。
13. 
优先级按上面的顺序由高到低，数字越小优先级越高。

其中第7项和第9项都是从应用jar包之外读取配置文件，所以，实现外部化配置的原理就是从此切入.

## 监控与管理
`spring-boot-starter-actuator`引入该模块能够自动为Spring Boot 构建的应用提供一系列用于监控的端点。同时，Spring Cloud 在实现各个微服务组件的时候，进一步为该模块做了不少扩展，比如，为原生端点增加了更多的指标和度量信息（比如在整合 Eureka 的时候会为/health 端点增加相关的信息），并且根据不同的组件还提供了更多有空的端点（比如，为API网关组件Zuul提供了/routes端点来返回路由信息）。
`spring-boot-starter-actuator`模块的实现对于实施微服务的中小团队来说，可以有效地省去或大大减少监控系统在采集应用指标时的开发量。当然，它也并不是万能的，有时候也需要对其做一些简单的扩展来帮助我们实现自身系统个性化的监控需求。所以，在本节将详细介绍一些关于spring-boot-starter-actuator模块的内容，包括原生提供的端点以及一些常用的扩展和配置方式等。


### 初识actuator

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```
### 原生端点

- 应用配置类： 获取应用程序中加载的应用配置、环境变量、自动化配置报告等与Spring Boot应用密切相关的配置类信息。
- 度量指标类： 获取应用程序运行过程中用于监控的度量指标，比如内存信息、线程池信息、HTTP请求统计等。
- 操作控制类： 提供了对应用的关闭等操作类功能。



## 服务治理：Spring Cloud Eureka

### 服务治理
由于Eureka服务端的服务治理机制提供了完备的RESTful API，所以它也支持将非Java语言构建的微服务应用纳入Eureka的服务治理体系中来。只是在使用其他语言平台的时候，需要自己来实现Eureka的客户端程序。不过庆幸的是，在目前几个较为流行的开发平台上，都已经有了一些针对 Eureka 注册中心的客户端实现框架，比如.NET 平台的 Steeltoe、Node.js 的eureka-js-client等。

### 搭建服务注册中心
eureka-server
```java
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.3.7.RELEASE</version>
    <relativePath/>
</parent>
    
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka-server</artifactId>
    </dependency>    
</dependencies>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Brixton.SR5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```
配置

```
在默认设置下，该服务注册中心也会将自己作为客户端来尝试注册它自己，所以我们需要禁用它的客户端注册行为，只需在application.properties中增加如下配置：
server.port=1111
eureka.instance.hostname=localhost
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
eureka.client.serviceUrl.defaultZone=http://${eureka.instance.hostname}:${serve r.port}/eureka/
```
- 服务注册中心的端口通过server.port属性设置为1111。
- eureka.client.register-with-eureka：由于该应用为注册中心，所以设置为false，代表不向注册中心注册自己。
- eureka.client.fetch-registry：由于注册中心的职责就是维护服务实例，它并不需要去检索服务，所以也设置为false。


通过@EnableEurekaServer注解启动一个服务注册中心提供给其他应用进行对话。这一步非常简单，只需在一个普通的Spring Boot应用中添加这个注解就能开启此功能，比如下面的例子：
```
@EnableEurekaServer
@SpringBootApplication
public class Application {
public static void main（String[]args）{
        new SpringApplicationBuilder(Application.class).web(true).run(args);
    }
}
```

### 注册服务提供者

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>

```
control 信息打印
```java
@RestController
public class HelloController {
    private final Logger logger=Logger.getLogger(getClass());
    @Autowired
    private DiscoveryClient client;
    @RequestMapping(value="/hello",method=RequestMethod.GET)
    public String index() {
        ServiceInstance     instance=client.getLocalServiceInstance();
        logger.info("/hello,host:"+instance.getHost()+",    service_id:"+instance.getServiceId());
        return "Hello World";
    }
}
```

```
// 主类
@EnableDiscoveryClient
@SpringBootApplication
public class HelloApplication {
    public static void main(String[]args){
        SpringApplication.run(HelloApplication.class,args);
    }
}
```

```
# 配置 服务器名和eureka注册中心
spring.application.name=hello-service
eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/
```

### 高可用注册中心

Eureka Server的高可用实际上就是将自己作为服务向其他服务注册中心注册自己，这样就可以形成一组互相注册的服务注册中心，以实现服务清单的互相同步，达到高可用的效果。下面我们就来尝试搭建高可用服务注册中心的集群。可以在本章第1节中实现的服务注册中心的基础之上进行扩展，构建一个双节点的服务注册中心集群。多注册中心

### 服务发现与消费

Ribbon来实现服务消费


创建应用主类ConsumerApplication，通过@EnableDiscoveryClient注解让该应用注册为Eureka客户端应用，以获得服务发现的能力。同时，在该主类中创建RestTemplate的Spring Bean实例，并通过@LoadBalanced注解开启客户端负载均衡。
```
@EnableDiscoveryClient
@SpringBootApplication
public class ConsumerApplication {
@Bean
@LoadBalanced
RestTemplate restTemplate(){
    return new RestTemplate();
}
public static void main(String[] args){
        SpringApplication.run(ConsumerApplication.class,args);
    }
}
```

创建ConsumerController类并实现/ribbon-consumer接口。在该接口中，通过在上面创建的 RestTemplate 来实现对 HELLO-SERVICE 服务提供的/hello接口进行调用。可以看到这里访问的地址是服务名HELLO-SERVICE，而不是一个具体的地址，在服务治理框架中，这是一个非常重要的特性，也符合在本章一开始对服务治理的解释。
```
@RestController
public class ConsumerController {
@Autowired
RestTemplate restTemplate;
@RequestMapping(value="/ribbon-consumer",method=RequestMethod.GET)
public String helloConsumer(){
        return restTemplate.getForEntity("http://HELLO-SERVICE/hello",String.class).getBody();
     }
}
```


## 客户端负载均衡：Spring Cloud Ribbon

Spring Cloud Ribbon虽然只是一个工具类框架，它不像服务注册中心、配置中心、API 网关那样需要独立部署，但是它几乎存在于每一个Spring Cloud构建的微服务和基础设施中。因为微服务间的调用，API网关的请求转发等内容，实际上都是通过Ribbon来实现的，包括后续我们将要介绍的Feign，它也是基于Ribbon实现的工具。所以，对Spring Cloud Ribbon的理解和使用，对于我们使用Spring Cloud来构建微服务非常重要

### 客户端负载均衡

客户端负载均衡和服务端负载均衡最大的不同点在于上面所提到的服务清单所存储的位置。在客户端负载均衡中，所有客户端节点都维护着自己要访问的服务端清单，而这些服务端的清单来自于服务注册中心.同服务端负载均衡的架构类似，在客户端负载均衡中也需要心跳去维护服务端清单的健康性，只是这个步骤需要与服务注册中心配合完成。

通过Spring Cloud Ribbon的封装，我们在微服务架构中使用客户端负载均衡调用非常简单，只需要如下两步：
- 服务提供者只需要启动多个服务实例并注册到一个注册中心或是多个相关联的服务注册中心。
- 服务消费者直接通过调用被@LoadBalanced注解修饰过的RestTemplate来实现面向服务的接口调用。

这样，我们就可以将服务提供者的高可用以及服务消费者的负载均衡调用一起实现了。

## 服务容错保护：Spring Cloud Hystrix
在微服务架构中，我们将系统拆分成了很多服务单元，各单元的应用间通过服务注册与订阅的方式互相依赖。由于每个单元都在不同的进程中运行，依赖通过远程调用的方式执行，这样就有可能因为网络原因或是依赖服务自身问题出现调用故障或延迟，而这些问题会直接导致调用方的对外服务也出现延迟，若此时调用方的请求不断增加，最后就会因等待出现故障的依赖方响应形成任务积压，最终导致自身服务的瘫痪。


在分布式架构中，断路器模式的作用也是类似的，当某个服务单元发生故障（类似用电器发生短路）之后，通过断路器的故障监控（类似熔断保险丝），向调用方返回一个错误响应，而不是长时间的等待。这样就不会使得线程因调用故障服务被长时间占用不释放，避免了故障在分布式系统中的蔓延。

针对上述问题，Spring Cloud Hystrix实现了断路器、线程隔离等一系列服务保护功能。它也是基于Netflix的开源框架 Hystrix实现的，该框架的目标在于通过控制那些访问远程系统、服务和第三方库的节点，从而对延迟和故障提供更强大的容错能力。Hystrix具备服务降级、服务熔断、线程和信号隔离、请求缓存、请求合并以及服务监控等强大功能。
接下来，我们就从一个简单示例开始对Spring Cloud Hystrix的学习与使用。


### 快速开始
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-hystrix</artifactId>
</dependency>
```
```
@EnableCircuitBreaker
@EnableDiscoveryClient
@SpringBootApplication
```
ribbon-consumer 工程的主类 中使用`@EnableCircuitBreaker`注解开启断路器功能

注意：这里还可以使用Spring Cloud应用中的`@SpringCloudApplication`注解来修饰应用主类，该注解的具体定义如下所示。可以看到，该注解中包含了上述我们所引用的三个注解，这也意味着一个Spring Cloud标准应用应包含服务发现以及断路器。

指定回调函数
```
@HystrixCommand(fallbackMethod="helloFallback")
public String helloService(){
    return restTemplate.getForEntity("http://HELLO-SERVICE/hello",
String.class).getBody();
}
public String helloFallback(){
    return "error";
}

```

### hystrix 仪表盘 
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
</dependency>
```
 - 为应用主类加上`@EnableHystrixDashboard`，启用Hystrix Dashboard功能。

## Turbine集群监控

构建监控聚合服务

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-turbine</artifactId>
</dependency>

```
创建应用主类 TurbineApplication，并使用`@EnableTurbine`注解开启Turbine。

```java
@EnableTurbine
@EnableDiscoveryClient
```

## 声明式服务调用：Spring Cloud Feign

基于Netflix Feign实现，整合了Spring Cloud Ribbon与Spring Cloud Hystrix，除了提供这两者的强大功能之外，它还提供了一种声明式的Web服务客户端定义方式。

在pom.xml中引入`spring-cloud-starter-eureka`和 `spring-cloud-starter-feign`依赖
主类通过`@EnableFeignClients`注解开启Spring Cloud Feign的支持功能。

## API网关服务：Spring Cloud Zuul

```java
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zuul</artifactId>
</dependency>
```
创建应用主类，使用`@EnableZuulProxy`注解开启Zuul的API网关服务功能。
```java
@EnableZuulProxy
@SpringCloudApplication
```
### 路由配置

传统路由方式

```conf
zuul.routes.api-a-url.path=/api-a-url/**
zuul.routes.api-a-url.url=http://localhost:8080/
```

面向服务的路由
```conf
zuul.routes.api-a.path=/api-a/**
zuul.routes.api-a.serviceId=hello-service
zuul.routes.api-b.path=/api-b/**
zuul.routes.api-b.serviceId=feign-consumer
eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka
```

### 请求过滤

Zuul允许开发者在API网关上通过定义过滤器来实现对请求的拦截与过滤，实现的方法非常简单，我们只需要继承ZuulFilter抽象类并实现它定义的4个抽象函数就可以完成对请求的拦截和过滤了。
下面的代码定义了一个简单的 Zuul 过滤器，它实现了在请求被路由之前检查HttpServletRequest中是否有accessToken参数，若有就进行路由，若没有就拒绝访问，返回401 Unauthorized错误。
```java

public class AccessFilter extends ZuulFilter {
    private static Logger log=LoggerFactory.getLogger(AccessFilter.class);
    @Override
    public String filterType(){
        return "pre";
    }
    @Override
    public int filterOrder(){
        return 0;
    }
    @Override
    public boolean shouldFilter(){
        return true;
    }
    @Override
    public Object run(){
        RequestContext ctx=RequestContext.getCurrentContext();
        HttpServletRequest request=ctx.getRequest();
        log.info("send {} request to {}",request.getMethod(),
        request.getRequestURL().toString());
        Object accessToken=request.getParameter("accessToken");
        if(accessToken==null){
            log.warn("access token is empty");
            ctx.setSendZuulResponse(false);
            ctx.setResponseStatusCode(401);
            return null;
        }
        
        log.info("access token ok");
        return null;
        }
    }
}           

                

```

- filterType：过滤器的类型，它决定过滤器在请求的哪个生命周期中执行。这里定义为pre，代表会在请求被路由之前执行。
- filterOrder：过滤器的执行顺序。当请求在一个阶段中存在多个过滤器时，需要根据该方法返回的值来依次执行。
- shouldFilter：判断该过滤器是否需要被执行。这里我们直接返回了 true，因此该过滤器对所有请求都会生效。实际运用中我们可以利用该函数来指定过滤器的有效范围。
- run：过滤器的具体逻辑。这里我们通过ctx.setSendZuulResponse（false）令 zuul 过滤该请求，不对其进行路由，然后通过 ctx.setResponseStatusCode（401）设置了其返回的错误码，当然也可以进一步优化我们的返回，比如，通过ctx.setResponseBody（body）对返回的body内容进行编辑等。

在实现了自定义过滤器之后，它并不会直接生效，我们还需要为其创建具体的 Bean才能启动该过滤器，比如，在应用主类中增加如下内容：
```java
@EnableZuulProxy
@SpringCloudApplication
public class Application {
	public static void main(String[]args){
		new SpringApplicationBuilder(Application.class).web(true).run(args);
	
	}
	@Bean
	public AccessFilter accessFilter(){
		return new AccessFilter();
	}
}
```

###  禁用过滤器
在Zuul中特别提供了一个参数来禁用指定的过滤器，该参数的配置格式如下：

```
zuul.<SimpleClassName>.<filterType>.disable=true
```

##  分布式配置中心：Spring Cloud Config

```
@EnableConfigServer
@SpringBootApplication
public class Application {
public static void main(String[]args){
        new SpringApplicationBuilder(Application.class).web(true).run(args);
    }
}
```

配置

```bash
spring.cloud.config.server.git.uri：配置Git仓库位置
spring.cloud.config.server.git.searchPaths：配置仓库路径下的相对搜索位置，可以配置多个
spring.cloud.config.server.git.username：访问Git仓库的用户名
spring.cloud.config.server.git.password：访问Git仓库的用户密码

```
## 消息总线：Spring Cloud Bus

当前版本的Spring Cloud Bus仅支持两款中间件产品：RabbitMQ和Kafka。在下面的章节中，我们将分别介绍如何使用这两款消息中间件与Spring Cloud Bus配合实现消息总线。

RabbitMQ实现消息总线

```
spring-boot-starter-amqp 用于支持RabbitMQ

```

```bash
spring.application.name=rabbitmq-hello
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=springcloud
spring.rabbitmq.password=123456
```
### 整合Spring Cloud Bus

Spring Cloud Bus 与 Spring Cloud Config 的整合

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bus-amqp</artifactId>
</dependency>

```
## 消息驱动的微服务：Spring Cloud Stream

Spring Cloud Stream为一些供应商的消息中间件产品提供了个性化的自动化配置实现，并且引入了发布-订阅、消费组以及分区这三个核心概念。

## 分布式服务跟踪：Spring Cloud Sleuth
通过之前各章节介绍的Spring Cloud组件，实际上我们已经能够通过使用它们搭建起一个基础的微服务架构系统来实现业务需求了。但是，随着业务的发展，系统规模也会变得越来越大，各微服务间的调用关系也变得越来越错综复杂。通常一个由客户端发起的请求在后端系统中会经过多个不同的微服务调用来协同产生最后的请求结果，在复杂的微服务架构系统中，几乎每一个前端请求都会形成一条复杂的分布式服务调用链路，在每条链路中任何一个依赖服务出现延迟过高或错误的时候都有可能引起请求最后的失败。这时候，对于每个请求，全链路调用的跟踪就变得越来越重要，通过实现对请求调用的跟踪可以帮助我们快速发现错误根源以及监控分析每条请求链路上的性能瓶颈等。

针对上面所述的分布式服务跟踪问题，Spring Cloud Sleuth 提供了一套完整的解决方案。在本章中，我们将详细介绍如何使用Spring Cloud Sleuth来为微服务架构增加分布式服务跟踪的能力。

### 与Logstash整合

通过之前的准备与整合，我们已经为trace-1和trace-2引入了Spring Cloud Sleuth的基础模块spring-cloud-starter-sleuth，实现了在各个微服务的日志信息中添加跟踪信息的功能。但是，由于日志文件都离散地存储在各个服务实例的文件系统之上，仅仅通过查看日志文件来分析我们的请求链路依然是一件相当麻烦的事，所以我们还需要一些工具来帮助集中收集、存储和搜索这些跟踪信息。引入基于日志的分析系统是一个不错的选择，比如ELK平台，它可以轻松地帮助我们收集和存储这些跟踪日志，同时在需要的时候我们也可以根据Trace ID来轻松地搜索出对应请求链路相关的明细日志。


###  与Zipkin整合

虽然通过ELK平台提供的收集、存储、搜索等强大功能，我们对跟踪信息的管理和使用已经变得非常便利。但是，在ELK平台中的数据分析维度缺少对请求链路中各阶段时间延迟的关注，很多时候我们追溯请求链路的一个原因
