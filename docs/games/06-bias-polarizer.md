# 06 个人偏见偏振器 (Bias Polarizer)

slug: `polarizer`

## 玩家体验

拒绝情绪价值的思想拳击台。输入一句深信不疑的结论，底座拉起杠精分身，用逻辑和流式 SSE 逼你补齐论据。

## 一局

```
POST /actions/challenge { proposition }
  → 开台，SSE 推反方第一拳
玩家 POST /actions/rebut { text, evidenceUrls[] }
  → 反方再打，最多 5 回合或玩家认输/守住
POST /actions/close { outcome: HELD | CONCEDED | DRAW }
  → signal polarizer.round.closed
  → bias_tags 增删（例如 JAVA_RELIGION）
```

杠精分身工具：可检索玩家收藏文章（P1 插件同步）。P0 无工具，只靠命题与玩家当场论据。禁止人身攻击、禁止转移话题超过一次（书记员式护栏在 system prompt + 输出校验）。

## 前端

左侧机械「偏见度盘」（0–100，随回合根据模型自评更新，仅装饰，权威在结局）。右侧拳击台双栏，反方流式打字。不要做成普通 chat。

## 浏览器插件（P1）

只同步书签 URL + 标题 + 文件夹名，进偏振本域存储。深挖正文需玩家对单篇授权后，才可经 `projection` 交共享语料。

## 数据

`g_pol_bout` / `g_pol_punch` 摘要；对打全文本域自管。不默认交共享语料。
