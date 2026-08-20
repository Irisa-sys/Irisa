# ADR 0007：基座技术栈锁定（Modulith / JWT / Spock / 自备中间件）

## 状态

已接受（覆盖手册里曾写的 Session 表、yaml、JUnit、compose 起中间件、第一周 HashMap 降级）

## 决策

1. 用 **Spring Modulith** 做模块边界。Maven 只留 `irisa-spi` + `irisa-app`。游戏是包，不是独立 jar。
2. 鉴权用 **JWT Bearer**，不用 `session` 表。登出 = 丢 token + Redis `jti` 黑名单。
3. 配置用 **`application.properties`**，密钥只走环境变量 / `.env`。
4. 测试主框架 **Spock**。
5. MySQL / Redis / ES / RocketMQ **用已部署实例**。仓库只 Docker 化业务进程。
6. **不降级**：`MemoryStore`→ES，`CacheOps`→Redis，Agent→虚拟线程。Script LLM 与 mock 登录是端口的第一实现。
7. **SSE 与基座解耦**：网关持有浏览器连接；基座只向 RocketMQ **LiteTopic** `send` 帧。禁止 Redis Stream / Pub/Sub 做 SSE。

## 后果

- HTTP 合同从 Cookie 改为 `Authorization: Bearer`
- 基座 P0 启动前必须能连上三套已有中间件
- 前端 mock 登录改读 JSON 里的 `token`
