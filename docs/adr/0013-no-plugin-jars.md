# ADR 0013：游戏是 Modulith 模块，不发布 plugin-api / host-sdk

## 状态

已接受（覆盖 ADR-0009、ADR-0007 中「三个 Maven 模块」、ADR-0001 中「SPI 插件」）

## 上下文

游戏已是同一 JVM 里的业务模块，不是第三方插件。独立契约 jar 把「宿主调游戏 / 游戏调基座」做成发布面，但没有外部实现方。身份、JWT 也不是技术基座。

## 决策

1. Maven **只** `backend/pom.xml` + `irisa-app`。不建 `irisa-plugin-api`、`irisa-host-sdk`。
2. 游戏包 `com.irisa.game.{slug}` 直接依赖 `base`、`identity`，以及他游戏的 **`::query` 命名接口**。
3. 游戏共享的 list/state/action 形状放在 `com.irisa.game.api`（仍是 app 内包，不是 jar）。网关前门依赖该包，不扫描 SPI。
4. 基座端口（ledger / events / corpus / agents / FrameSink / uow / ids / clock / cache）是 `base` 模块的 Java 接口，不是独立工件。
5. **base 不依赖 identity。** 改分在 identity 消费 `event_log`。JWT 在 identity，不在 V-BASE。

## 后果

- 拆进程时再抽 HTTP 合同，不预支两只 jar
- `ApplicationModules.verify()` 管边界，不靠 classpath SPI
- 身份表（player / persona）不进基座首迁
