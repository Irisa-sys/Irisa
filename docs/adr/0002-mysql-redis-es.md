# ADR 0002：三存储职责锁定

## 状态

已接受

## 决策

- MySQL：身份、画像权威值、ledger、event_log、债务与案件元数据
- Redis：只做缓存、锁、JWT 黑名单、Cron 游标；可丢。**不做 SSE**
- ES：长文本与向量（誓言、笔录、幽灵、病历、社交、文章）
- RocketMQ LiteTopic：仅实时 SSE 帧，网关消费；不是领域事件总线

分数不以 ES 为准。故事不以 MySQL TEXT 堆为准。

## 后果

画像仪表盘不依赖 ES。回音原文不依赖 MySQL。重建 Redis 有文档化路径。
