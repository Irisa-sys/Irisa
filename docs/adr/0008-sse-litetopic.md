# ADR 0008：网关持有 SSE，基座经 RocketMQ LiteTopic 推帧

## 状态

已接受

## 上下文

SSE 若放在基座，基座会持有浏览器连接，和「领域内核」缠在一起。若用 Redis Stream 扇出，缓存组件承担了消息总线职责，和「Redis 可丢、不当权威」冲突。

## 决策

1. **网关**：鉴权后挂 `SseEmitter`，订阅对应 LiteTopic，本地发 `ping`，把 MQ 消息写成 SSE。
2. **基座 / 插件**：只调用 `SseSink.emit`，实现是 `Producer.send`，禁止碰 emitter。
3. Topic：`irisa-sse-{playerId}-{topic}`，LiteTopic，对局级生命周期。
4. 领域事件（改分、账本）仍走 MySQL `event_log` + outbox，**不**进 RocketMQ。
5. 不用 Redis Stream / Pub/Sub 推 SSE。

## 后果

- 一期仍可同 JVM：网关模块订 MQ，基座模块发 MQ，进程内也走 Topic，避免以后拆网关时改插件。
- 前端合同不变（仍是 `/stream` + 既有 event 名）。
- 启动依赖增加 RocketMQ；MQ 挂了短请求仍可用，开庭流不可用。
