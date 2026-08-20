# ADR 0003：跨游戏只走事件

## 状态

已接受

## 决策

插件不得读取 `g_{other}_*` 表。需要别人事实时：消费登记事件，或调用底座 `FactQuery`（只读投影）。

事件 type 必须先登记在 `docs/contracts/events.yaml` / `docs/platform/signal-bus.md`。

## 后果

法庭审计员揭发摸鱼，是因为病理发了 `pathology.report.issued` 并写入 ledger，不是法庭 JOIN 病历表。
