# ADR 0012：基座 ES 只承载玩家级共享语料（LLM 检索）

## 状态

已接受

## 上下文

本域长文若进基座索引，平台会变成各游戏的磁盘。LLM 跨游戏检索要的是自愿交出的共享语料。外域读别人事实走产出方查询 API（ADR-0003），不走这篇语料。

## 决策

1. **两套 ES，两套所有权**
   - **本域**：游戏自己写、自己的查询 API 去读。命令路径里 **MySQL 提交后、emit 前同步写**；失败则本命令失败。基座不管。
   - **共享语料**：仅 LLM。`projection` 填 `CorpusDocument`，`index_job` embedding 后写入 `irisa_corpus`。**异步**。基座不订阅 `game.*` 事件。
2. 领域内核不引用信封、不碰 ES 客户端。本域 ES 在 `game.{slug}.es`；查询门面在 `game.{slug}.query`；共享语料只在 `projection`。
3. `events.yaml` consumers 不含 corpus。
4. `event_log.apply_status` 只表示改分。
5. `AnalysisQuery(playerId, query)` → embed → kNN，filter `player_id`。审计员不得调用。
6. 不交语料、不需要本域长文的游戏可以没有 `es` / `projection`。

## 写顺序（一条命令）

```
MySQL 事务：g_* + ledger（可登记 event 行，尚未对外投递）
提交
同步：本域 es 写读模型（失败 → 命令失败，不 emit 给外域）
然后：emit 领域事件（外域可调 query API）
异步：projection → index_job → irisa_corpus
```

## 后果

- 外域不保证、也不等待共享语料；只保证调产出方 query 时本域读模型已写
- 存量补向量只 scroll `irisa_corpus.body`
