# 07 技术债中央银行 (Tech Debt Central Bank)

slug: `bank`

## 玩家体验

坏味道金融化。脏代码是贷款本金；高入度是复利；作者 6 个月无提交是坏账。前端彭博风格 K 线。利息破交付阈值则破产清算。

## 计量（先规则，后图）

```
principal     = smellScore(file)            // 行数、圈复杂度代理、幽灵加成
rate          = baseRate * (1 + inDegree/k)
interest      = principal * ((1+rate)^ageMonths - 1)
npl           = lastAuthorCommitAge > 180d
capacity      = 玩家设定的「本周可还债小时」或默认 8h 折算额度
bankrupt if   interest + principal > capacity * weeksOpen * wageProxy
```

P0：`inDegree` 用简单 import 计数；`smellScore` 用行变更 + 闹鬼信号。
P1：JavaParser AST + 调用图。

## 流程

```
CI / push webhook 或手动 POST /actions/scan
  → 解析 → upsert g_bank_debt_note
  → 日终 Cron 计息
  → signal bank.position.updated
  → 若超阈且开关允许：
        dry-run 默认
        开启后：Slack 红牌 + 开 [BANKRUPTCY] PR（改目录名为 高利贷重灾区 仅限沙箱仓）
        signal bank.bankruptcy.filed
```

**生产仓库改名/开 PR 默认关闭。** 文档与开关必须写明。演示用独立 demo repo。

## 前端

黑底橙字终端。顶部：总负债、NPL 率、信用分。主图：按日聚合的负债 K 线。点蜡烛看 top 10 债笔记。破产时全屏红牌，可关闭。

## 数据

`g_bank_debt_note(id, repo, path, principal, rate, interest, in_degree, npl, last_author_at)`
`g_bank_daily_bar(repo, day, open, high, low, close)` — K 线预聚合。

## 对外查询

`bank.query` / `FACT_BANK_POSITION` → `{principal, interest, nplCount, topNotes[3]}`。法庭只调这个，不读银行表。
