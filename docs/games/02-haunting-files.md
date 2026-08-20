# 02 项目闹鬼档案 (Project Haunting Files)

slug: `haunt`

## 玩家体验

代码库里看不见的债变成雷达上的幽灵。GitHub webhook 增量吞 diff，模型分析「人类怨气」。点幽灵看生产环境惨案史。

## 幽灵种类

| 种 | 触发启发式（P0） | 视觉 |
| --- | --- | --- |
| 怨灵 | `TODO`/`FIXME` 被重复改期或存活 > 30 天 | 慢闪青白 |
| 僵尸 | 嵌套深度 ≥ 4 或防御性 if 金字塔 | 僵直红点 |
| 灵异抓狂 | 同 commit 改了代码未改邻近 `*.md`/`docs`，或标识符与文档 embedding 漂移 | 不规则抽搐 |

P1 用 JavaParser / tree-sitter 加强；P0 允许正则 + 行变更统计。

## 流程

```
GitHub push/PR webhook
  → WebhookIngress 验签去重
  → HauntPlugin 取 diff（大 diff 截断 + 分片）
  → 分类器（规则先，LLM 后）打 ghostType
  → upsert g_haunt_ghost
  → ES mem_ghost 写案情
  → signal haunt.ghost.spawned
  → Persona 扣 code_credit
```

手动通道：`POST /actions/ingest-diff` 粘贴 unified diff，保证无 GitHub 也能玩。

## 前端

深色赛博雷达。类/文件是点，严重度是闪烁频率。点击：侧栏「惨案历史」（来自 git log 摘要 + 既往幽灵）。

坐标：对 fqcn/path 做稳定哈希映射到极坐标，避免每次刷新乱跳。

## 数据

`g_haunt_ghost(id, player_id, repo, path, ghost_type, severity, first_seen, last_seen, credit_delta)`
`g_haunt_incident` 惨案时间线。

## 与银行

同一 `repo+path` 已有债务凭证时，闹鬼只发信号、不重复发明利率。银行听 `haunt.ghost.spawned` 加息。
