# ADR 0002：三存储职责锁定

## 状态

已接受

## 决策

- MySQL：身份、画像权威值、ledger、event_log、index_job、债务与案件元数据
- Redis：只做缓存、锁、JWT 黑名单、Cron 游标；可丢。**不做实时通道**
- ES 两套所有权：
  - **游戏私有索引**：该游戏模块自己写（本域长文）。基座不解释。
  - **共享语料索引**：仅 LLM 检索；`index_job` worker embedding 后写入。不扫 `event_log`
- RocketMQ LiteTopic：仅实时帧（`FrameSink`）；网关消费后写成 SSE；不是领域事件总线

分数不以 ES 为准。故事不以 MySQL TEXT 堆为准。

## 后果

画像仪表盘不依赖 ES。回音原文不依赖 MySQL。重建 Redis 有文档化路径。
