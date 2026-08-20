# 05 人际关系黑洞拉扯图 (Social Gravity)

slug: `gravity`

## 玩家体验

把社交关系映射成天体。粘贴聊天快照或写观察日志。自己是恒星；正能量是行星；消耗者是暗紫黑洞，拉扯并剥离能量光晕。

## 量化（模型必须吐 JSON）

| 字段 | 含义 | 视觉 |
| --- | --- | --- |
| `mass` | 重要性 0–100 | 星球半径 |
| `charge` | 正负能量 -1..+1 | 行星 vs 黑洞 |
| `eccentricity` | 情绪不稳定 0–1 | 轨道椭圆扁平度 |
| `periodDays` | 互动频率 | 公转速度 |

P0 单段文本一次性抽取联系人列表。P1 支持多段增量合并。

## 隐私

聊天原文只进 ES `mem_social`，默认 30 天 TTL。前端星系图只有匿名化后的显示名（玩家自己起的别名）。导出/分享默认关闭。

## 流程

```
POST /actions/ingest
  → Agent 抽取 contacts[]
  → upsert g_gravity_body
  → 重算 energy_net = Σ(mass * charge)
  → signal gravity.graph.updated
```

## 前端

HTML5 Canvas。中心恒星光晕强度 = `energy_net`。黑洞用粒子剥离动画，但 60fps 预算内，联系人 > 40 时降级为静态点 + 悬停详情。

## 联动

P0 只写 persona.energy_net。P1 法庭机会主义者会点名「你最重的黑洞」。
