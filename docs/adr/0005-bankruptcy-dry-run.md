# ADR 0005：破产清算默认 dry-run

## 状态

已接受

## 决策

`bank.bankruptcy.filed` 可以发。对真实 GitHub/Slack 的写操作（开 PR、改目录名、发红牌）默认关闭。演示仓库白名单 + 玩家显式开关才能实打。

## 后果

玩法完整可演示（红牌 UI + 假 PR URL），不会误伤玩家主仓。
