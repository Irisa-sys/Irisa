# ADR 索引

| 编号 | 标题 | 状态 |
| --- | --- | --- |
| [0001](./0001-plugin-monolith.md) | 单体 JVM + Modulith 游戏模块，不做微服务 | 已接受 |
| [0002](./0002-mysql-redis-es.md) | MySQL 账本 / Redis 调度 / ES 记忆 | 已接受 |
| [0003](./0003-signal-not-direct-read.md) | 跨游戏只走事件 | 已接受 |
| [0004](./0004-fact-vs-narrative.md) | 事实工具与叙事 Agent 隔离 | 已接受 |
| [0005](./0005-bankruptcy-dry-run.md) | 破产清算默认 dry-run | 已接受 |
| [0006](./0006-ship-order.md) | 先病理与法庭，再代码侧，再彩蛋 | 已接受 |
| [0007](./0007-stack-lock.md) | Modulith / JWT / Spock / 自备中间件 / 不降级 | 已接受 |
| [0008](./0008-sse-litetopic.md) | 网关持 SSE，基座经 FrameSink 推帧 | 已接受 |
| [0009](./0009-plugin-api-host-sdk.md) | 契约拆成 plugin-api 与 host-sdk | **已废弃**（见 0013） |
| [0010](./0010-identity-vs-base.md) | 身份子域与技术基座分离 | 已接受 |
| [0011](./0011-runtime-not-orchestrator.md) | 游戏调用放在网关前门，不设 runtime | 已接受 |
| [0012](./0012-memory-projection-not-event-consumer.md) | 基座 ES 只承载玩家级共享语料（LLM 检索） | 已接受 |
| [0013](./0013-no-plugin-jars.md) | 游戏是 Modulith 模块，不发布 plugin-api / host-sdk | 已接受 |
