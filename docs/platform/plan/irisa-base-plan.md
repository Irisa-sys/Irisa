---
title: Irisa 实施计划
status: 计划草案
type: implementation-plan
scope: 先技术基座，再身份，再网关，再七款游戏
created_time: 2026-08-21
updated_time: 2026-08-24
source:
  - docs/platform/base-tech-design.md
  - docs/adr/0012-memory-projection-not-event-consumer.md
  - docs/adr/0013-no-plugin-jars.md
depends_on:
  - docs/games/
  - docs/contracts/
  - docs/adr/
---

# Irisa 实施计划

## 1. 计划说明

四段，互不混进同一退出标准：

| 段 | 是什么 | 不是什么 |
| --- | --- | --- |
| **基座 `base`** | 账本、事件 append、共享语料（向量）、Agent、FrameSink、缓存、ids/clock/uow | 身份、JWT、HTTP、SSE、本域 ES、游戏 |
| **身份 `identity`** | 玩家、画像、JWT、改分消费 | 技术管道、网关 |
| **网关 `gateway`** | HTTP/SSE、游戏前门 | 玩法、改分 |
| **游戏 `game.*`** | 玩法 + 本域 ES（同步）+ query API + 可选 corpus projection | SPI 插件、直连他游戏 ES |

无 `irisa-plugin-api` / `irisa-host-sdk`（ADR-0013）。Maven 只 `irisa-app`。游戏是 Modulith 模块，直接调 `base` / `identity` 端口。

不包含：独立网关集群、多活 SSE、Kafka、未开开关的真实仓破产写、对战排行。

### 1.1 拆分原则

1. **先模块**：`base` → `identity` → `gateway` → 各 `game.{slug}`。
2. **模块内按功能**：一项 = 一个可命名行为。不写文件级。
3. **可单独单测**：Spock。禁止用联调代替本任务测试。禁止 H2。
4. **本域同步、外域调查询、语料异步**：MySQL 提交 → 同步本域 ES → emit；外域只调 `::query`；共享语料走 `index_job`。

勾选：做完且单测绿后把 `- [ ]` 改成 `- [x]`。

| 段 | 含义 |
| --- | --- |
| ID | 稳定引用 |
| 单测 | 本任务独立断言 |
| 前置 | 必须先绿的 ID |
| 估 | 乐观／常规／悲观，人日 |

## 2. 估算口径

乐观：中间件符合预期。常规：实现、测试、一次修正。悲观：边界修正，不含需求重做。基座常规约 **16 人日**，身份约 **4 人日**，网关约 **6 人日**，七款游戏约 **28 人日**。

## 3. 实施顺序

```
B1 工程 → B2 基座端口 → B3 账本/事件 append → B4 共享语料（向量） → B5 Agent → B6 通道
       → V-BASE
       → ID1 身份（玩家 / JWT / 画像 / 改分）
       → V-ID
       → GW1 游戏前门 → GW2 短请求 → GW3 SSE
       → V-GATE
       → 游戏（本域 ES + 可选 corpus projection）
```

## 4. 里程碑

| 期          |                            目标 |     乐观 |     常规 |     悲观 | 前置      |
| ---------- | ----------------------------: | -----: | -----: | -----: | ------- |
| B1         |               工程可构建、Flyway 四表 |      1 |      2 |      3 | 无       |
| B2         |         基座端口（app 内接口，无独立 jar） |      1 |      2 |      3 | B1      |
| B3         |             账本、事件 append（不改分） |      1 |      2 |      3 | B2      |
| B4 | 共享语料：index_job → embedding → irisa_corpus | 1 | 3 | 4 | B3 |
| B5         |      Script Agent、FactTool、用量 |      2 |      4 |      6 | B2      |
| B6         |        FrameSink → LiteTopic |      1 |      2 |      3 | B2      |
| **V-BASE** |            无 HTTP / 无身份 / 无游戏 |        |        |        | B1–B6   |
| ID1        |              玩家、JWT、默认画像、改分消费 |      2 |      3 |      5 | V-BASE  |
| **V-ID**   |             建号 + token + 合成改分 |        |        |        | ID1     |
| GW1        |                        网关游戏前门 |      1 |      2 |      3 | V-ID    |
| GW2        | 鉴权 HTTP：mock/me/persona/games |      1 |      2 |      3 | GW1     |
| GW3        |                        网关 SSE |      1 |      2 |      3 | GW2、B6  |
| **V-GATE** |                   空宫格可演示进站与通道 |        |        |        | GW1–GW3 |
| B11        |                  GitHub OAuth |      1 |      2 |      4 | GW2     |
| B12        |                    OpenAI 适配器 |      1 |      2 |      3 | B5、GW3  |
| G1         |        病理：本域 ES + 可选语料 |      2 |      4 |      6 | V-GATE  |
| G2         |        法庭：本域 ES + 可选语料 |      3 |      5 |      8 | G1、GW3  |
| G3         |                       闹鬼 + 银行 |      3 |      5 |      8 | G1      |
| G4         |        回音：本域 ES + 可选语料 |      2 |      3 |      5 | G1、GW3  |
| G5         |     重力本域 ES；偏振无语料 projection |      2 |      4 |      6 | G1、GW3  |
| G6         |                       Webhook |      1 |      2 |      4 | G3      |
| H1         |                            硬化 |      2 |      3 |      5 | G5、G6   |
| **合计**     |                               | **31** | **56** | **89** |         |

B11/B12 可与游戏并行，不挡 V-BASE。OAuth HTTP 面依赖 V-GATE。

---

# 第一期：技术基座

## 5. B1 工程

- [x] **ENG-01** Maven：仅 `irisa-app` 可构建；无 plugin-api / host-sdk 模块
  - 单测：`mvn test` 编译；reactor 无那两模块
  - 前置：无 · 估：0.5／1／2

- [x] **ENG-02** 顶层 Modulith：`base` 不依赖 `identity`；游戏互依仅 `::query`
  - 单测：`ApplicationModules.verify()`
  - 前置：ENG-01 · 估：0.5／1／2

- [x] **ENG-03** 游戏不得依赖他游戏内核/es/Store、gateway、LLM SDK、RocketMQ
  - 单测：verify 拦截非 query 依赖
  - 前置：ENG-02 · 估：0.25／0.5／1

- [x] **CFG-01** 配置只引用 `IRISA_*`；无 yaml 明文密钥；Apollo 仅 `bootstrap.properties`
  - 单测：资源扫描
  - 前置：ENG-01 · 估：0.25／0.5／1

- [x] **CFG-02** 连不上 MySQL 拒启
  - 单测：错误 URL 启动失败
  - 前置：CFG-01 · 估：0.25／0.5／1

- [ ] **DATA-01** Flyway 基座四表：ledger_entry / event_log / index_job / agent_usage；软删两列；无 session、无 player、无 persona
  - 单测：information_schema
  - 前置：CFG-02 · 估：0.5／1／1.5

- [x] **DATA-02** 游戏表不进首迁；已发布迁移不改
  - 单测：V1 无 `g_`、无 `oath`、无 `player`
  - 前置：DATA-01 · 估：0.25／0.5／0.5

### cache（基座能力，身份稍后使用）

Redis 可丢。禁止 Pub/Sub、Stream 做 SSE。

- [x] **CACHE-01** set / get / delete + TTL
  - 单测：过期后读不到
  - 前置：CFG-02 · 估：0.25／0.5／1

- [x] **CACHE-02** `setIfAbsent`（NX）
  - 单测：二次写入失败
  - 前置：CACHE-01 · 估：0.25／0.5／0.75

- [x] **CACHE-03** Redis 不可用时写路径抛错
  - 单测：不得返回成功
  - 前置：CACHE-01 · 估：0.25／0.5／1

- [x] **CACHE-04** 锁 `lock:{domain}:{id}` 超时释放
  - 单测：过期后可再获取
  - 前置：CACHE-01 · 估：0.25／0.5／0.75

## 6. B2 基座端口

接口放在 `base` 包内，不是独立 Maven 模块。无 jdbc 泄漏给游戏。无游戏 DTO。无 persona 写/读端口（画像在 identity）。

- [ ] **PORT-01** ids / clock / uow
  - 单测：无 Emitter、无模型/MQ 客户端类型
  - 前置：ENG-01 · 估：0.25／0.5／1

- [ ] **PORT-02** ledger：append + 按业务键查询（形状）
  - 单测：记录形状固定
  - 前置：PORT-01 · 估：0.25／0.5／0.75

- [ ] **PORT-03** events：emit（type / producer / playerId / businessKey / payload）
  - 单测：未登记 type 可在端口层表达拒绝
  - 前置：PORT-01 · 估：0.25／0.5／0.75

- [ ] **PORT-04** agents：submit（role、`FACT_` 工具、预算、frameTopic）
  - 单测：字段齐全
  - 前置：PORT-01 · 估：0.25／0.5／0.75

- [ ] **PORT-05** `FrameSink.send(playerId, topic, frame)`（在 `base.messaging`）
  - 单测：无 SSE / Emitter 类型；类型名不含 Sse
  - 前置：PORT-01 · 估：0.25／0.5／0.75

- [ ] **PORT-06** corpus：`submit(CorpusDocument)` + `AnalysisQuery(playerId, query)`
  - 单测：无游戏 DTO；无 PRIVATE/needVec 字段
  - 前置：PORT-01 · 估：0.25／0.5／0.75

- [ ] **PORT-07** `base` 模块不依赖 `identity`、不暴露 PersonaWriter
  - 单测：Modulith + 包扫描
  - 前置：ENG-02 · 估：0.25／0.5／0.5

## 7. B3 账本与事件 append

不改分。`apply_status` 只标记「待身份消费」。用合成事件测 append / 幂等。

### ledger

- [ ] **LEDGER-01** 只增一行（payload JSON + 可选 sha256）
  - 单测：按 id 读回
  - 前置：DATA-01 · 估：0.25／0.5／1

- [ ] **LEDGER-02** 幂等 `(game_slug, type, business_key, is_deleted)`
  - 单测：同键第二次不新增
  - 前置：LEDGER-01 · 估：0.25／0.5／1

- [ ] **LEDGER-03** 禁止改历史行
  - 单测：无更新或调用失败
  - 前置：LEDGER-01 · 估：0.25／0.5／0.5

- [ ] **LEDGER-04** 软删行不参与幂等与对账
  - 单测：软删不挡新键
  - 前置：LEDGER-02 · 估：0.25／0.5／0.75

### event

- [ ] **EVENT-01** 白名单与 `docs/contracts/events.yaml` 一致；consumers 无 `memory`
  - 单测：yaml 每个 type 可 emit；无 memory 听众
  - 前置：PORT-03 · 估：0.25／0.5／1

- [ ] **EVENT-02** 未登记 type 不落库
  - 单测：未知 type 拒绝
  - 前置：EVENT-01 · 估：0.25／0.5／0.75

- [ ] **EVENT-03** emit 时 `apply_status=PENDING`
  - 单测：新行状态
  - 前置：EVENT-01 · 估：0.25／0.5／0.5

- [ ] **EVENT-04** 幂等 `(producer, type, business_key, is_deleted)`
  - 单测：重复 emit 无第二行
  - 前置：EVENT-03 · 估：0.25／0.5／0.75

- [ ] **EVENT-05** `base` 无改分 worker、不扫 PENDING 改 persona
  - 单测：包扫描无 persona 写入
  - 前置：EVENT-03、PORT-07 · 估：0.25／0.5／0.75

## 8. B4 共享语料（`base.corpus`）

基座不订阅游戏事件、不写本域索引。本期用**合成 CorpusDocument**。进管道即 embedding。

- [ ] **MEM-01** 共享索引 `irisa_corpus`：player_id / ref_id / source / body / sha256 / vec；查询必带 player_id
  - 单测：缺 player_id 拒绝
  - 前置：CFG-02、PORT-06 · 估：0.25／0.5／1

- [ ] **MEM-02** upsert 按 `_id=source+ref_id` 幂等；worker 对 body 做 embedding 写 vec
  - 单测：写两次同一文档；vec 非空
  - 前置：MEM-01 · 估：0.5／1／1.5

- [ ] **MEM-07** `submit` 只入 `index_job`，调用线程不碰 ES、不做 embedding
  - 单测：submit 后 job=PENDING；无 ES / embed 请求
  - 前置：DATA-01、PORT-06 · 估：0.5／1／1.5

- [ ] **MEM-08** worker 只扫 `index_job` PENDING → INDEXED / DEAD
  - 单测：不读 event_log；失败累加 attempt_count
  - 前置：MEM-07、MEM-02 · 估：0.5／1／1.5

- [ ] **MEM-03** 索引失败不回写 `event_log.apply_status`
  - 单测：模拟 ES / embed 失败；event 仍 PENDING
  - 前置：EVENT-03、MEM-08 · 估：0.25／0.5／1

- [ ] **MEM-04** 按 index_job.sha256 对账；模型变更可 scroll body 重算 vec
  - 单测：sha 不一致则补；重算不改 body
  - 前置：MEM-08、LEDGER-01 · 估：0.25／0.5／1

- [ ] **MEM-05** `AnalysisQuery` 跨 player 拒绝
  - 单测：错 player_id 空
  - 前置：MEM-01 · 估：0.25／0.5／0.75

- [ ] **MEM-06** DELETE op 后文档删除
  - 单测：再检索无命中
  - 前置：MEM-08 · 估：0.25／0.5／1

- [ ] **MEM-09** `AnalysisQuery(playerId, query)`：embed(query) → kNN
  - 单测：语义相近命中；无关 query 可空
  - 前置：MEM-02 · 估：0.5／1／1.5

- [ ] **MEM-10** `base.corpus` 无游戏事件监听、无 `g_*` Mapper、无本域索引名（mem_pathology 等）
  - 单测：包扫描
  - 前置：MEM-08 · 估：0.25／0.5／0.75

- [ ] **MEM-11** 审计员 / `FACT_*` 路径不得调 `AnalysisQuery`
  - 单测：审计员工具白名单无检索
  - 前置：AGENT-01、MEM-09 · 估：0.25／0.5／0.75

## 9. B5 Agent

不持连接、不存 Persona。无外网用 Script。TonePolicy 吃 `int mindHealth`，不读 identity。

- [ ] **AGENT-01** `submit` 校验 tools 全 `FACT_`
  - 单测：非法工具立刻失败
  - 前置：PORT-04 · 估：0.25／0.5／0.75

- [ ] **AGENT-02** 超时 → `BUDGET_EXHAUSTED`
  - 单测：超 timeoutMs
  - 前置：AGENT-01 · 估：0.25／0.5／1

- [ ] **AGENT-03** TonePolicy 按 mindHealth 三段（入参，不查表）
  - 单测：高/中/低档不同
  - 前置：AGENT-01 · 估：0.25／0.5／1

- [ ] **AGENT-04** 审计员角色无文学语气
  - 单测：约束断言
  - 前置：AGENT-03 · 估：0.25／0.5／0.75

- [ ] **AGENT-05** 每次调用写 `agent_usage`（含失败/超时/Script）；无 prompt 正文
  - 单测：四类各一行
  - 前置：DATA-01 · 估：0.25／0.5／1

- [ ] **AGENT-06** 按 player+game 聚合次数与 token；无用量时为空列表
  - 单测：两游戏分开；空聚合
  - 前置：AGENT-05 · 估：0.25／0.5／0.75

- [ ] **AGENT-07** Micrometer：game/role/provider/status，无正文标签
  - 单测：标签白名单
  - 前置：AGENT-05 · 估：0.25／0.5／1

- [ ] **AGENT-08** Script 按 role 读 classpath
  - 单测：已知有输出；未知可空
  - 前置：AGENT-01 · 估：0.5／1／1.5

- [ ] **AGENT-09** Script 可整段或按行
  - 单测：两种模式
  - 前置：AGENT-08 · 估：0.25／0.5／1

- [ ] **AGENT-10** FactTool 按名调用；未注册回 error JSON，不抛进程
  - 单测：未知名不炸
  - 前置：PORT-04 · 估：0.25／0.5／1

- [ ] **AGENT-11** FactTool 内部异常也回 JSON error
  - 单测：吞成 JSON
  - 前置：AGENT-10 · 估：0.25／0.5／0.75

## 10. B6 帧通道（`FrameSink`）

不是 SSE。实现只 `Producer.send`。SSE 在 GW3。

- [ ] **MSG-01** send 到 `irisa-frame-{playerId}-{topic}`
  - 单测：topic 字符串精确
  - 前置：PORT-05 · 估：0.5／1／1.5

- [ ] **MSG-02** 载荷 `{id,event,data}`，单 topic FIFO
  - 单测：顺序与字段
  - 前置：MSG-01 · 估：0.25／0.5／1

- [ ] **MSG-03** send 失败不回写 MySQL 冒充已推
  - 单测：MQ 失败后无「已推」状态
  - 前置：MSG-01 · 估：0.25／0.5／1

- [ ] **MSG-04** 游戏包无 RocketMQ 依赖
  - 单测：Modulith
  - 前置：MSG-01 · 估：0.25／0.5／0.75

## 11. 基座退出 V-BASE

同时满足（**无 HTTP、无身份表、无游戏表**）：

- 合成 playerId 可 append ledger / event_log
- 合成 `CorpusDocument` → `index_job` → embedding → `irisa_corpus`；不改 `event_log.apply_status`
- Script `submit` 写 usage
- `FrameSink` 发 LiteTopic（不要求网关消费；无 SSE 类型）
- `base` 不依赖 `identity`；无改分 worker
- `mvn test` 绿

---

# 第二期：身份（V-BASE 之后）

## 12. ID1 身份子域（`identity`）

### player

- [ ] **DATA-ID** Flyway：player / persona；软删两列
  - 单测：information_schema；V1 仍无这两表
  - 前置：DATA-01 · 估：0.25／0.5／1

- [ ] **PLAYER-01** 按 `github_login` 建号；已存在则复用
  - 单测：同 login 两次同一 id
  - 前置：DATA-ID · 估：0.25／0.5／1

- [ ] **PLAYER-02** 按 id 读活跃行（`is_deleted=0`）
  - 单测：软删后读不到
  - 前置：PLAYER-01 · 估：0.25／0.5／0.75

- [ ] **PLAYER-03** 软删后同一 login 可再注册
  - 单测：唯一键含 `is_deleted`
  - 前置：PLAYER-02 · 估：0.25／0.5／1

### auth

- [ ] **AUTH-00** JWT 密钥 &lt;32 拒启
  - 单测：短密钥启动失败
  - 前置：CFG-01 · 估：0.25／0.5／1

- [ ] **AUTH-01** 签发 HS256：`sub` / `login` / `jti` / `exp`
  - 单测：解析四字段齐全
  - 前置：AUTH-00 · 估：0.25／0.5／1

- [ ] **AUTH-02** 验签：坏签、过期、缺 jti 失败
  - 单测：三条否定
  - 前置：AUTH-01 · 估：0.25／0.5／1

- [ ] **AUTH-03** mock 登录：建号 + 默认画像 + 发 token（端口，不经 HTTP）
  - 单测：新 login 有 player 与默认 persona
  - 前置：PLAYER-01、PERSONA-01、AUTH-01 · 估：0.5／1／1.5

- [ ] **AUTH-04** 登出写 `auth:deny:{jti}`，TTL=剩余 exp；Redis 失败则登出失败
  - 单测：TTL 对齐；失败不得当成功
  - 前置：CACHE-01、AUTH-02 · 估：0.25／0.5／1

- [ ] **AUTH-05** 黑名单 jti 鉴权失败
  - 单测：logout 后再验 empty
  - 前置：AUTH-04 · 估：0.25／0.5／0.75

- [ ] **AUTH-06** mock 开关关闭则 mock 不可用
  - 单测：开关 false 拒绝
  - 前置：AUTH-03 · 估：0.25／0.5／0.5

### persona

- [ ] **PERSONA-01** 建号默认 800 / 80 / 0 / `[]`
  - 单测：新玩家四字段
  - 前置：PLAYER-01 · 估：0.25／0.5／0.75

- [ ] **PERSONA-02** 只读快照（identity 端口；游戏可依赖）
  - 单测：四字段 + updatedAt
  - 前置：PERSONA-01 · 估：0.25／0.5／0.5

- [ ] **PERSONA-03** `base` / 游戏无 UPDATE persona
  - 单测：包扫描
  - 前置：PORT-07 · 估：0.25／0.5／0.75

### 改分（identity 消费 event_log；合成事件）

- [ ] **EVENT-06** identity 扫 PENDING；条件更新 `PENDING → DONE`，并发不双扣
  - 单测：两次 apply 分数一次
  - 前置：EVENT-03、PERSONA-01 · 估：0.5／1／1.5

- [ ] **EVENT-07** 失败累加 `attempt_count` + `apply_error`
  - 单测：人为失败 +1
  - 前置：EVENT-06 · 估：0.25／0.5／0.75

- [ ] **EVENT-08** 超限 `DEAD` 并打点，不再改分
  - 单测：达上限后分数不变
  - 前置：EVENT-07 · 估：0.25／0.5／1

- [ ] **PERSONA-04** `pathology.report.issued`：mind_health += delta，夹紧 0–100
  - 单测：-12、打到 0、不超过 100
  - 前置：EVENT-06 · 估：0.25／0.5／1

- [ ] **PERSONA-05** `haunt.ghost.spawned`：credit -= 10×severity(1–5)，夹紧 0–1000
  - 单测：边界与下限 0
  - 前置：EVENT-06 · 估：0.25／0.5／1

- [ ] **PERSONA-06** `gravity.graph.updated`：energy_net **覆盖**
  - 单测：非累加
  - 前置：EVENT-06 · 估：0.25／0.5／0.75

- [ ] **PERSONA-07** `polarizer.round.closed`：增删 `bias_tags`
  - 单测：增、删、空数组
  - 前置：EVENT-06 · 估：0.25／0.5／1

- [ ] **PERSONA-08** 热缓存 `persona:hot:{id}` TTL 60s；改分失效
  - 单测：改分后读到新值
  - 前置：CACHE-01、PERSONA-04 · 估：0.25／0.5／1

- [ ] **EVENT-09** `apply_status` 不表示 ES 成功
  - 单测：index_job 失败时改分仍可为 DONE
  - 前置：EVENT-06、MEM-08 · 估：0.25／0.5／1

## 13. 身份退出 V-ID

- mock 登录端口：建号 + 默认画像 + JWT
- 合成 `pathology.report.issued` 后健康度变
- 游戏 / base 不能写 persona
- `mvn test` 绿

---

# 第三期：网关（V-ID 之后）

## 14. GW1 游戏前门

Controller 只依赖前门抽象。P0 = 进程内调 `game.api` 应用服务。拆服务换 HTTP，合同不变。不写玩法。无游戏时列表为空合法。

- [ ] **FRONT-01** 列出已注册游戏；无游戏时列表为空
  - 单测：空 classpath 空列表；有桩则出现
  - 前置：ENG-02 · 估：0.25／0.5／1

- [ ] **FRONT-02** 按 slug 分发；未知或 DISABLED → 404 `GAME_DISABLED`
  - 单测：假 slug、DISABLED
  - 前置：FRONT-01 · 估：0.25／0.5／1

- [ ] **FRONT-03** 错误信封 `{error:{code,message}}`；STATE / ACTION / STREAM_OPEN 形状在 `game.api`
  - 单测：成功码与 code 形状
  - 前置：ENG-02 · 估：0.25／0.5／0.75

- [ ] **FRONT-04** `ids()` 按前缀发号
  - 单测：同前缀唯一
  - 前置：PORT-01 · 估：0.25／0.5／0.5

- [ ] **FRONT-05** `clock()` 可注入
  - 单测：固定时钟
  - 前置：PORT-01 · 估：0.25／0.5／0.5

- [ ] **FRONT-06** `uow()` 只包 MySQL（私有表 + ledger）；事务内禁 LLM / 睡 / FrameSink / ES / 对外 emit
  - 单测：回调内 send 失败
  - 前置：PORT-01 · 估：0.25／0.5／1

- [ ] **FRONT-07** 基座无 `g_` 表 Mapper
  - 单测：包扫描
  - 前置：ENG-02 · 估：0.25／0.5／1

- [ ] **FRONT-08** 单游戏抛错不影响其他分发
  - 单测：坏桩 + 好桩
  - 前置：FRONT-02 · 估：0.25／0.5／1

- [ ] **FRONT-09** 前门不调用 `corpus.submit`；投影不在应用服务命令路径
  - 单测：state/action 桩无 corpus 调用
  - 前置：FRONT-02、PORT-06 · 估：0.25／0.5／0.75

## 15. GW2 网关短请求

不写账本、不调模型。无游戏时 `/games` 为空数组。

- [ ] **GW-01** 错误信封映射约定 code
  - 单测：状态与 code 对齐
  - 前置：FRONT-03 · 估：0.25／0.5／0.75

- [ ] **GW-02** 无 Bearer / 非法 token → 401 `UNAUTHENTICATED`
  - 单测：缺头、坏签、过期
  - 前置：AUTH-02 · 估：0.25／0.5／1

- [ ] **GW-03** CORS：Authorization / Content-Type / Last-Event-ID
  - 单测：OPTIONS 与响应头
  - 前置：GW-01 · 估：0.25／0.5／0.75

- [ ] **GW-04** `POST /api/auth/mock` → 201；空 login → 400 `VALIDATION`
  - 单测：camelCase token 合同
  - 前置：AUTH-03 · 估：0.25／0.5／1

- [ ] **GW-05** `POST /api/auth/logout` → 204；黑名单失败非 204
  - 单测：Redis 失败
  - 前置：AUTH-04 · 估：0.25／0.5／1

- [ ] **GW-06** `GET /api/me`
  - 单测：只读当前玩家
  - 前置：PLAYER-02、GW-02 · 估：0.25／0.5／0.75

- [ ] **GW-07** `GET /api/persona`
  - 单测：camelCase，biasTags 数组
  - 前置：PERSONA-02 · 估：0.25／0.5／0.75

- [ ] **GW-08** `GET /api/games`（无游戏则 `[]`）
  - 单测：空列表合法
  - 前置：FRONT-01 · 估：0.25／0.5／0.75

- [ ] **GW-09** `GET /api/games/{slug}/state` 转发；未知 slug → 404 `GAME_DISABLED`
  - 单测：无游戏时任意 slug 404
  - 前置：FRONT-02 · 估：0.25／0.5／1

- [ ] **GW-10** `POST /api/games/{slug}/actions/{action}` 原样出站
  - 单测：无游戏 404
  - 前置：FRONT-02 · 估：0.25／0.5／1

- [ ] **GW-11** `GET /api/me/usage`；无用量 `byGame=[]`
  - 单测：空聚合
  - 前置：AGENT-06 · 估：0.25／0.5／0.75

- [ ] **GW-12** mock 关闭 → mock 404
  - 单测：开关 false
  - 前置：AUTH-06 · 估：0.25／0.5／0.5

- [ ] **MSG-05** MQ 挂起时短请求仍可用
  - 单测：mock/me 在 MQ down 时成功
  - 前置：MSG-01、GW-06 · 估：0.25／0.5／1

## 16. GW3 网关 SSE

可对空游戏验收：鉴权、归属、本地 ping、退订。

- [ ] **GW-13** `/stream` 鉴权；topic 归属当前 playerId
  - 单测：订他人 topic → 403
  - 前置：AUTH-02、MSG-01 · 估：0.5／1／1.5

- [ ] **GW-14** 本地 `ping` 每 15s，不进 LiteTopic
  - 单测：MQ 无 ping
  - 前置：GW-13 · 估：0.25／0.5／1

- [ ] **GW-15** 消费 LiteTopic 写成 `id/event/data`
  - 单测：一帧入一帧出
  - 前置：GW-13、MSG-02 · 估：0.5／1／1.5

- [ ] **GW-16** 断连退订
  - 单测：关闭后不再投递
  - 前置：GW-15 · 估：0.25／0.5／1

## 17. 网关退出 V-GATE

- mock 登录、`/me`、`/persona`、空 `/games`
- send LiteTopic → 网关 SSE；ping 不进 MQ
- 无游戏表
- `mvn test` 绿

## 18. B11 / B12 加深（不挡 V-BASE；HTTP 面要 V-GATE）

- [ ] **AUTH-07** GitHub OAuth 落到同一 `github_login`，不新建号
  - 单测：已有 login 不 insert
  - 前置：AUTH-03 · 估：0.5／1／2

- [ ] **AUTH-08** OAuth scope 默认无 repo
  - 单测：请求 scope
  - 前置：AUTH-07 · 估：0.25／0.5／1

- [ ] **GW-17** `GET /api/auth/github`；`/me` 不变
  - 单测：合同
  - 前置：AUTH-07、GW-06 · 估：0.5／1／1.5

- [ ] **AGENT-12** OpenAI 兼容同一 `LlmClient`
  - 单测：切 provider 不改 submit
  - 前置：AGENT-08 · 估：0.5／1.5／2

- [ ] **AGENT-13** 流式只经 FrameSink
  - 单测：无 Emitter
  - 前置：AGENT-12、MSG-01 · 估：0.25／0.5／1

- [ ] **AGENT-14** 无 key 时 openai 失败，不静默回 Script
  - 单测：FAILED
  - 前置：AGENT-12 · 估：0.25／0.5／1

- [ ] **AGENT-15** 仅 agent 包依赖模型 SDK
  - 单测：Modulith
  - 前置：AGENT-12 · 估：0.25／0.5／0.75

- [ ] **CACHE-05** webhook 去重键 TTL 24h（入口可先 501，游戏期再接）
  - 单测：同 deliveryId 第二次 NX 失败
  - 前置：CACHE-02 · 估：0.25／0.5／0.75

---

# 第四期：游戏（V-GATE 之后）

包：内核 + `es`（emit 前同步写）+ `query`（外域只依赖这个）+ `projection`（可选，异步交语料）。偏振无 `es`/`projection`。

## 19. G1 病理

- [ ] **PATHO-01** ACTIVE；STATE：todayReport / recent
  - 单测：空 recent=[]
  - 前置：FRONT-01 · 估：0.25／0.5／0.75

- [ ] **PATHO-02** Flyway `g_patho_report`；Store 只在本模块
  - 单测：同日两 revision；base 无该 Mapper
  - 前置：DATA-02 · 估：0.25／0.5／1

- [ ] **PATHO-03** admit 校验 date+confession
  - 单测：缺字段 400
  - 前置：PATHO-02 · 估：0.25／0.5／0.75

- [ ] **PATHO-04** Agent `CYBER_CHIEF`；delta ∈ [-20,0]
  - 单测：超范围拒入账
  - 前置：AGENT-08、PATHO-03 · 估：0.5／1／1.5

- [ ] **PATHO-05** 事务内：报告 + ledger；**提交后同步 es，再 emit**；事务内无 corpus / 无对外 emit
  - 单测：回滚则都无；es 失败则无外域事件
  - 前置：LEDGER-02、EVENT-03、FRONT-06 · 估：0.5／1／1.5

- [ ] **PATHO-06** 同日再 admit 升 revision
  - 单测：新 reportId，date 不变
  - 前置：PATHO-05 · 估：0.25／0.5／1

- [ ] **PATHO-07** 日志无 confession 全文
  - 单测：日志断言
  - 前置：PATHO-05 · 估：0.25／0.5／0.75

- [ ] **PATHO-08** 补偿后二次 admit 再扣血
  - 单测：健康度两次下降
  - 前置：PATHO-06、PERSONA-04 · 估：0.25／0.5／1

- [ ] **PATHO-09** `game.pathology.es` 在 emit 前写完；`query` 可读全文
  - 单测：基座无 mem_pathology；query 在 emit 后非空
  - 前置：PATHO-05 · 估：0.5／1／1.5

- [ ] **PATHO-11** `game.pathology.query` 给外域（最近报告 / severity）；不暴露 ES 类型
  - 单测：接口无 ES 客户端类型
  - 前置：PATHO-09 · 估：0.25／0.5／0.75

- [ ] **PATHO-10** `projection` 仅交可分享片段 → `CorpusDocument`（异步）
  - 单测：emit 成功时 job 可尚未 INDEXED
  - 前置：MEM-07、PATHO-09 · 估：0.5／1／1.5

## 20. G2 法庭

- [ ] **COURT-01** STATE：activeCase / lastVerdict
  - 单测：无案 null
  - 前置：FRONT-01 · 估：0.25／0.5／0.5

- [ ] **COURT-02** Flyway case / utterance；Store 本模块
  - 单测：软删列；base 无该 Mapper
  - 前置：DATA-02 · 估：0.25／0.5／1

- [ ] **COURT-03** open → 201 + ledger CASE_OPENED
  - 单测：缺 title 400
  - 前置：COURT-02、LEDGER-01 · 估：0.5／1／1.5

- [ ] **COURT-04** IN_SESSION，3 回合，五角色
  - 单测：state 字段
  - 前置：COURT-03 · 估：0.25／0.5／0.75

- [ ] **COURT-05** SSE 顺序 round_start → utterance → exhibit? → clerk_digest
  - 单测：乱序失败
  - 前置：MSG-02、AGENT-08 · 估：0.5／1／1.5

- [ ] **COURT-06** 审计员只 `FACT_*`；无数据「卷宗空白」
  - 单测：空账本
  - 前置：AGENT-01、AGENT-10 · 估：0.5／1／1.5

- [ ] **COURT-07** 有病历 exhibit：调 `pathology.query` / `FACT_*`，不碰病理 ES
  - 单测：有/无报告；court 无 pathology.es 依赖
  - 前置：COURT-06、PATHO-11 · 估：0.25／0.5／1

- [ ] **COURT-08** 银行头寸经 `bank.query` / `FACT_BANK_POSITION`
  - 单测：empty 合法；court 无 bank 表 Mapper
  - 前置：COURT-06 · 估：0.25／0.5／1

- [ ] **COURT-09** 预算耗尽仍 awaiting_signature，TRUNCATED
  - 单测：BUDGET_EXHAUSTED
  - 前置：AGENT-02、COURT-05 · 估：0.25／0.5／1

- [ ] **COURT-10** sign → SIGNED + `court.verdict.signed`
  - 单测：无签名拒绝
  - 前置：COURT-03、EVENT-01 · 估：0.5／1／1.5

- [ ] **COURT-11** utterance 只存摘要；全文 `court.es` 在 emit 前写完
  - 单测：MySQL 无全文；query 可读
  - 前置：COURT-02 · 估：0.25／0.5／0.75

- [ ] **COURT-12** 可分享笔录片段才 `projection` → 共享语料；审计员仍只 `FACT_*`
  - 单测：命令路径无 CorpusDocument；审计员工具无 AnalysisQuery
  - 前置：MEM-07、COURT-05 · 估：0.25／0.5／1

## 21. G3 闹鬼 + 银行

- [ ] **HAUNT-01** STATE ghosts=[]
  - 单测：空列表
  - 前置：FRONT-01 · 估：0.25／0.5／0.5

- [ ] **HAUNT-02** Flyway 本模块
  - 单测：软删列
  - 前置：DATA-02 · 估：0.25／0.5／1

- [ ] **HAUNT-03** TODO/FIXME → WRAITH
  - 单测：含 TODO 的 diff
  - 前置：HAUNT-02 · 估：0.25／0.5／1

- [ ] **HAUNT-04** 嵌套/if 金字塔 → ZOMBIE
  - 单测：深度≥4
  - 前置：HAUNT-02 · 估：0.25／0.5／1

- [ ] **HAUNT-05** 改代码未改文档 → POLTERGEIST
  - 单测：对照 diff
  - 前置：HAUNT-02 · 估：0.25／0.5／1

- [ ] **HAUNT-06** path 稳定哈希 → r/theta
  - 单测：同 path 坐标相同
  - 前置：HAUNT-03 · 估：0.25／0.5／0.75

- [ ] **HAUNT-07** ingest 幂等 + `haunt.ghost.spawned`；不连扣
  - 单测：同 path
  - 前置：EVENT-04、PERSONA-05 · 估：0.5／1／1.5

- [ ] **HAUNT-08** 无 GitHub 手动 ingest 可玩一局
  - 单测：仅 HTTP
  - 前置：HAUNT-07 · 估：0.25／0.5／0.75

- [ ] **HAUNT-09** 案情：emit 前同步本域 es；`haunt.query` 给银行；可分享才 projection
  - 单测：基座无 mem_ghost；bank 无 haunt.es
  - 前置：HAUNT-07 · 估：0.25／0.5／1

- [ ] **BANK-01** STATE 零值 + 空数组
  - 单测：空仓
  - 前置：FRONT-01 · 估：0.25／0.5／0.75

- [ ] **BANK-02** Flyway 本模块
  - 单测：软删列
  - 前置：DATA-02 · 估：0.25／0.5／1

- [ ] **BANK-03** scan 本金（行变更 + 闹鬼加成）
  - 单测：有幽灵 path 更高
  - 前置：HAUNT-07、BANK-02 · 估：0.5／1／1.5

- [ ] **BANK-04** 同 path 加息，不重复发明利率
  - 单测：已有 note 只加息
  - 前置：BANK-03 · 估：0.25／0.5／1

- [ ] **BANK-05** 日终计息 + K 线
  - 单测：一天一行 OHLC
  - 前置：BANK-03 · 估：0.25／0.5／1

- [ ] **BANK-06** 超阈 dry-run；live-writes 默认 false
  - 单测：无真实 PR
  - 前置：BANK-05 · 估：0.25／0.5／1

- [ ] **BANK-07** `FACT_BANK_POSITION` top3 或 empty
  - 单测：审计员可读
  - 前置：AGENT-10、BANK-03 · 估：0.25／0.5／1

- [ ] **BANK-08** `bank.position.updated` / `bank.bankruptcy.filed`
  - 单测：白名单
  - 前置：EVENT-01 · 估：0.25／0.5／0.75

## 22. G4 回音

- [ ] **ECHO-01** STATE：canSwear + hasActiveOath，无原文、数量或武装状态
  - 单测：不泄露誓言文本与触发信息
  - 前置：FRONT-01 · 估：0.25／0.5／0.75

- [ ] **ECHO-02** Flyway `oath` 随本游戏
  - 单测：不在 V1
  - 前置：DATA-02 · 估：0.25／0.5／1

- [ ] **ECHO-03** swear：事务提交 → 同步本域 es → emit
  - 单测：es 失败则无 `echo.oath.written`
  - 前置：EVENT-03 · 估：0.5／1／1.5

- [ ] **ECHO-08** 可分享誓言才 `projection` → 共享语料（进管道即向量化）
  - 单测：AnalysisQuery 可命中；基座无 mem_oath
  - 前置：ECHO-03、MEM-07 · 估：0.25／0.5／1

- [ ] **ECHO-04** 无病历永不 ARMED
  - 单测：从不 admit → pending=false
  - 前置：ECHO-03、PATHO-01 · 估：0.25／0.5／1

- [ ] **ECHO-05** 近 5 病历日 SEVERE≥3：听事件 + 调 `pathology.query`，不碰病理 ES
  - 单测：窗口边界；echo 无 pathology.es 依赖
  - 前置：ECHO-04、PATHO-11、CACHE-01 · 估：0.5／1／1.5

- [ ] **ECHO-06** 关键词解锁；错词 400
  - 单测：2–4 词
  - 前置：ECHO-05 · 估：0.25／0.5／1

- [ ] **ECHO-07** `echo.triggered`（武装）与 `echo.resolved`
  - 单测：白名单
  - 前置：EVENT-01 · 估：0.25／0.5／0.5

- [ ] **GW-ECHO-01** `GET /api/echo/pending` 无全文和关键词
  - 单测：仅 oathId + keywordCount
  - 前置：ECHO-04 · 估：0.25／0.5／0.75

- [ ] **GW-ECHO-02** `POST /api/echo/unlock`
  - 单测：对/错词

- [ ] **GW-ECHO-03** `POST /api/echo/resolve`：续约、改写或放下
  - 单测：同一病理周期续约后不重复武装
  - 前置：ECHO-06 · 估：0.25／0.5／0.75

- [ ] **GW-ECHO-04** `GET /api/echo/stream` 壳层事件名
  - 单测：blackout / voice / wait_unlock / released
  - 前置：GW-15、ECHO-06 · 估：0.25／0.5／1

## 23. G5 重力 + 偏振

- [ ] **GRAV-01** STATE：bodies + energyNet，无聊天原文
  - 单测：无原文
  - 前置：FRONT-01 · 估：0.25／0.5／0.75

- [ ] **GRAV-02** Flyway 本模块
  - 单测：软删列
  - 前置：DATA-02 · 估：0.25／0.5／0.75

- [ ] **GRAV-03** ingest 强制 JSON 四字段
  - 单测：非 JSON 拒绝
  - 前置：AGENT-08、GRAV-02 · 估：0.5／1／1.5

- [ ] **GRAV-04** energyNet = Σ(mass×charge)，覆盖画像
  - 单测：与 persona 一致
  - 前置：GRAV-03、PERSONA-06 · 估：0.25／0.5／1

- [ ] **GRAV-05** 聊天：emit 前同步本域 ES TTL 30d；默认不交共享语料
  - 单测：表无原文；基座无 mem_social
  - 前置：GRAV-03 · 估：0.25／0.5／1

- [ ] **POL-01** STATE activeBout
  - 单测：空 null
  - 前置：FRONT-01 · 估：0.25／0.5／0.5

- [ ] **POL-02** Flyway 本模块
  - 单测：软删列
  - 前置：DATA-02 · 估：0.25／0.5／0.75

- [ ] **POL-03** challenge SSE `punch` 不是 message
  - 单测：事件名
  - 前置：MSG-01、POL-02 · 估：0.5／1／1.5

- [ ] **POL-04** 最多 5 回合
  - 单测：第 6 次拒绝
  - 前置：POL-03 · 估：0.25／0.5／1

- [ ] **POL-05** close HELD/CONCEDED/DRAW + bias_tags
  - 单测：非法 outcome 400
  - 前置：PERSONA-07、EVENT-01 · 估：0.25／0.5／1

- [ ] **POL-06** 人身攻击/跑题护栏
  - 单测：输出校验
  - 前置：POL-03 · 估：0.25／0.5／1

- [ ] **POL-07** 对打不交共享语料；无 `projection` / 无 corpus.submit
  - 单测：偏振模块无 corpus.submit
  - 前置：POL-05、MEM-10 · 估：0.25／0.5／0.5

## 24. G6 Webhook

- [ ] **GW-WH-01** `POST /api/webhooks/{provider}` 只转发已验签载荷
  - 单测：本层不解析玩法
  - 前置：CACHE-05 · 估：0.25／0.5／1

- [ ] **WH-01** 验签失败不入库；同 deliveryId 不重复haunt
  - 单测：假重放、坏签名
  - 前置：HAUNT-07、GW-WH-01 · 估：0.5／1／2

## 25. H1 硬化

- [ ] **SEC-01** 越权 slug / 他玩家隔离
  - 单测：403/空
  - 前置：GW-09、MEM-05 · 估：0.5／1／1.5

- [ ] **SEC-02** 日志无 confession/聊天/誓言
  - 单测：关键字
  - 前置：PATHO-07、GRAV-05 · 估：0.25／0.5／0.75

- [ ] **OPS-01** 5xx、补偿失败、index_job DEAD、SSE 连接打点
  - 单测：指标存在
  - 前置：EVENT-08、MEM-08、GW-15 · 估：0.25／0.5／1

- [ ] **OPS-02** 镜像不含中间件；live-writes 默认 false
  - 单测：配置断言
  - 前置：BANK-06 · 估：0.25／0.5／1

- [ ] **E2E-01** 登录 → admit → 开庭 → 签字
  - 单测：契约顺序
  - 前置：G2 · 估：0.5／1／2

- [ ] **E2E-02** 七款无 webhook 各一局
  - 单测：七条路径
  - 前置：G5 · 估：0.5／1／2

---

## 26. 检查点

- [ ] **V-BASE** 合成账本/事件/共享语料 kNN、Script、FrameSink；无 HTTP / 无身份 / 无游戏
  - 必须完成：B1–B6

- [ ] **V-ID** 建号、JWT、合成改分
  - 必须完成：ID1

- [ ] **V-GATE** mock 登录、画像、空宫格、SSE
  - 必须完成：GW1–GW3

- [ ] **V2 病理** admit 出病历，健康度下降；可分享片段进共享语料
  - 必须完成：G1

- [ ] **V3 法庭** 开庭 SSE，审计员引用病历，签字
  - 必须完成：G2

- [ ] **V4 真模型** 切 provider 主路径仍在
  - 必须完成：B12

- [ ] **V5 七款可玩** 无 webhook 七局
  - 必须完成：G3–G5

- [ ] **V6 发布候选** webhook、安全、镜像
  - 必须完成：G6、H1

## 27. 控制规则

- 基座未退出前不开身份；身份未退出前不开网关；网关未退出前不开游戏。
- 任务完成 = 本任务单测绿。
- 契约变化先改 `docs/contracts/`。
- 变更须改本计划：新增游戏、改网关/身份/基座边界、外域直连他游戏 ES/表、emit 早于本域 ES、内核调用 `corpus.submit`、基座订阅游戏事件、基座依赖 identity、Redis 推实时帧、游戏接模型 SDK、游戏写 `irisa_corpus`、基座持有 `g_*` Mapper、再引入 plugin-api/host-sdk jar。

## 28. 发布门禁

- [ ] V-BASE 通过
- [ ] V-ID 通过
- [ ] V-GATE 通过
- [ ] V2–V6 通过
- [ ] 无密钥进 git
- [ ] 单活 SSE 写入 README
- [ ] live-writes 默认 false
