# ADR 0001：单体 JVM + SPI 插件

## 状态

已接受

## 上下文

七个游戏都要实现统一底座接口，且有 Agent、Webhook、Cron。过早拆微服务会让信号总线和本地事务变复杂。

## 决策

P0/P1 全部游戏以 SPI 插件形式活在同一个 Spring Boot 进程。用 classpath 隔离逻辑，不用进程隔离。银行 AST、闹鬼消费若成为 CPU 热点，再拆 Worker，仍共享同一 MySQL/ES。

## 后果

- 部署简单，本地能跑完整矩阵
- 插件故障靠 try/catch 与线程池隔离，不是网络隔离
- 禁止插件互相 import 包
