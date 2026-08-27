# ADR 0001：单体 JVM + Modulith 游戏模块

## 状态

已接受（「SPI 插件」被 [ADR-0013](./0013-no-plugin-jars.md) 覆盖；仍是单进程）

## 上下文

七个游戏都要实现统一底座接口，且有 Agent、Webhook、Cron。过早拆微服务会让信号总线和本地事务变复杂。

## 决策

P0/P1 全部游戏以 **Spring Modulith 模块** 活在同一个 Spring Boot 进程。用包边界隔离逻辑，不用进程隔离，不发布 SPI jar。银行 AST、闹鬼消费若成为 CPU 热点，再拆 Worker，仍共享同一 MySQL/ES。

## 后果

- 部署简单，本地能跑完整矩阵
- 模块故障靠 try/catch 与线程池隔离，不是网络隔离
- 禁止游戏模块互相 import 包
- 游戏私有表由该游戏模块自己存取；基座不持有 `g_*` Mapper
