# ADR 0003：跨游戏只走事件 + 产出方查询 API

## 状态

已接受

## 决策

游戏不得读取 `g_{other}_*`，不得使用他游戏的本域 ES。需要别人事实时：

1. 消费已登记领域事件（「发生了」）；或
2. 调用 **产出方模块公开的查询 API**（`game.{slug}.query`）。调用方不关心底下是表还是 ES。

事件 type 必须先登记在 `docs/contracts/events.yaml`。

产出方写路径：**MySQL 提交 → 同步写本域读模型（ES/表）→ 再 emit**。这样外域听到事件再调查询 API 时，读模型已就绪。查询失败不是外域去补异构。

全局 LLM 检索不走这条，走共享语料（ADR-0012）。

## 后果

- 法庭揭发摸鱼：听 `pathology.report.issued` 或调病理查询 API / `FACT_*`（封装该 API），不是 JOIN 病历表、不是搜病理 ES
- Modulith：只允许依赖他游戏的 `::query` 命名接口，禁止依赖内核 / es / Store
