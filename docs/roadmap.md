# 路线图

## Phase 0 — 底座能转（约 1 周）· 前端同时画壳

设计：[基座技术方案](./platform/base-tech-design.md)。实施：[plan/irisa-base-plan.md](./platform/plan/irisa-base-plan.md)（基座 V-BASE → 身份 V-ID → 网关 V-GATE → 游戏）。  
契约：[HTTP](./contracts/http-api.md) · [SSE](./contracts/sse-events.md) · [并行评估](./platform/parallel-dev.md)

底座：

- [ ] Spring Boot + Modulith 单体，游戏是包不是独立 jar；无 plugin-api / host-sdk
- [ ] 基座四表 ledger / event_log / index_job / agent_usage；身份表后建
- [ ] mock 登录发 Bearer（身份期）+ `/me` `/persona` `/games`（网关期）
- [ ] Agent 虚拟线程 + ScriptLlmClient；基座 FrameSink → LiteTopic；SSE 由网关持连接
- [ ] 共享语料=index_job + embedding → irisa_corpus（合成文档）；本域 ES 由游戏自管；CacheOps=Redis

前端（并行，不挡底座）：

- [ ] 壳：mock 登录、宫格、画像条、EchoInterrupt
- [ ] 病理病历页 + 法庭 5 席/签名，先吃 fixture
- [ ] C1：切 `localhost:8080`，宫格与画像条走真 stub

## Phase 1 — 病理 + 法庭闭环（约 2 周）

- [ ] 病理 admit → 病历 UI → `pathology.report.issued`
- [ ] 法庭开庭 5 席 3 回合 + 签名板
- [ ] 审计员宣读最近病历与空银行头寸
- [ ] TonePolicy 按健康度变脸
- [ ] **里程碑：病历能当堂被揭发**

## Phase 2 — 代码侧事实（约 2 周）

- [ ] 闹鬼：手动 diff + GitHub webhook
- [ ] 银行：启发式本金/利息 + K 线 + dry-run 破产
- [ ] `haunt.ghost.spawned` 加息、扣信用
- [ ] 审计员能宣读负债 top 3
- [ ] **里程碑：写脏代码能同时闹鬼和欠债**

## Phase 3 — 延迟惊吓与另外两款（约 2 周）

- [ ] 回音：立誓、Cron、全屏打断、关键词解锁
- [ ] 重力：ingest + Canvas 星系（≤40 体流畅）
- [ ] 偏振器：5 回合拳击 SSE
- [ ] **里程碑：七款都能单独玩一局；3 条 P0 联动仍在**

## Phase 4 — 加深，不扩游戏

- JavaParser 调用图
- 收藏夹插件
- 病理可选行为指标
- 破产白名单实打
- 回音向量近邻（同类誓言互相提醒）— 仅当基础触发已稳

## 明确不做（现在）

- 玩家之间对战 / 排行榜公开病历
- 微服务拆分
- 自研向量库（用 ES kNN）
- 统一成一套后台 CRUD 皮肤
- 未开关的自动改别人的 GitHub 仓库
