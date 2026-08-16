# Irisa Backend

这是 Irisa Agent MVP 的 Spring Boot 模块化单体后端。工程按 `docs/mvp/design/technical-solution-mvp.md` 的模块边界组织，当前只提供可启动的工程基线，业务流程实现按 M1-M10 计划逐步填充。

## 技术基线

- Java 17
- Spring Boot 3.5
- Spring Modulith 1.4
- MySQL 8 + Flyway + MyBatis-Plus
- Redis 7、MongoDB 7
- LangChain4j 低层模型 API（仅 `agent.foundation` 使用）
- Apollo Config Service 与 Spring Cloud Bootstrap

## 本地运行

需要提供 MySQL 8（数据库名 `irisa`）和可选的 Redis、MongoDB。数据库连接可通过环境变量覆盖：

```bash
cd backend
export IRISA_DB_URL='jdbc:mysql://localhost:3306/irisa?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC'
export IRISA_DB_USERNAME=irisa
export IRISA_DB_PASSWORD=irisa
mvn spring-boot:run
```

首次启动会由 Flyway 执行 `src/main/resources/db/migration/V1__mvp_baseline.sql`。没有数据库时可先执行 `mvn -DskipTests package` 验证工程构建。

## 启动期配置

`bootstrap.properties` 在主应用上下文创建前加载，承载应用名、Apollo 配置中心，以及后续服务注册与发现的连接配置。`application.properties` 只保留本地运行期默认值。

部署时通过环境变量提供 Apollo 元数据：

```bash
export APOLLO_META='http://apollo-config-service:8080'
export APOLLO_APP_ID='irisa-backend-prod'
mvn spring-boot:run
```

Apollo 默认加载 `application` 与 `irisa` 两个 Namespace；新增 Namespace 时修改 `bootstrap.properties` 的 `apollo.bootstrap.namespaces`。注册中心接入时也将其地址、命名空间和认证参数写入 `bootstrap.properties`，敏感值则由部署环境或 Apollo 的受控 Namespace 提供，不提交到仓库。

## 包结构

```text
com.irisa.backend
├── common                         # ID、时间、错误、加密、观测、限流
├── platform.identity              # 本地账号、游客、JWT、同意记录
├── platform.notification          # 邮件模板与投递
├── agent.foundation               # 模型网关、路由、成本元数据
├── runtime                        # access/conversation/memory/context/artifact/execution/react/spi/port
├── domain.psychology              # 心理领域节点、风险闸门、结果校验
├── infrastructure                 # MySQL、消息与外部适配器
└── delivery                       # HTTP/SSE 出口，按功能划分接口
```

`delivery` 对应设计文档中的 `interface.*` 协议层；Java 关键字 `interface` 不能作为包名，因此不直接使用该名称。
