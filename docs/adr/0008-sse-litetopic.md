# ADR 0008：网关持有 SSE，基座经 FrameSink 推帧

## 状态

已接受

## 上下文

SSE 若放在基座，基座会持有浏览器连接，和「领域内核」缠在一起。若用 Redis Stream 扇出，缓存组件承担了消息总线职责，和「Redis 可丢、不当权威」冲突。

## 决策

1. **网关**：鉴权后挂 `SseEmitter`，订阅对应 LiteTopic，本地发 `ping`，把 MQ 消息写成 SSE。SSE 是网关协议，不进基座端口名。
2. **基座 / 游戏**：只调用 `FrameSink.send(playerId, topic, frame)`，实现是 `Producer.send`，禁止碰 emitter / RocketMQ 客户端。
3. Topic：`irisa-frame-{playerId}-{topic}`，LiteTopic，对局级生命周期。
4. 领域事件（改分）仍走 MySQL `event_log` 补偿，**不**进 RocketMQ。记忆走 `index_job`，也**不**进 RocketMQ。
5. 不用 Redis Stream / Pub/Sub 推实时帧。

## 后果

- 一期仍可同 JVM：网关模块订 MQ，基座模块发 MQ，进程内也走 Topic，避免以后拆网关时改游戏。
- 前端合同不变（仍是 `/stream` + 既有 event 名）。
- 启动依赖增加 RocketMQ；MQ 挂了短请求仍可用，开庭流不可用。
