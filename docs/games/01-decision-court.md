# 01 人生决策法庭 (The Decision Court)

slug: `court`

## 玩家体验

把「要不要裸辞 / 该不该买房」开成一案。提交案由后，后台拉起 5 个 Agent 线程开庭。3 回合交叉质询结束，玩家在签名板上以法官身份结案。

## NPC

| 角色 | role | 工具 | 职责 |
| --- | --- | --- | --- |
| 过去的你 | `COURT_PAST_SELF` | 无（只读案由） | 拷问初心 |
| 悲观主义者 | `COURT_PESSIMIST` | 无 | 极限施压找漏洞 |
| 机会主义者 | `COURT_OPPORTUNIST` | 无 | 煽动冒险 |
| 审计员 | `COURT_AUDITOR` | **仅** `FACT_*` | 宣读真实账本：负债、病历、信用分 |
| 书记员 | `COURT_CLERK` | 无 | 每回合整理争议点，不站队 |

审计员被限制：温度低、禁止比喻、每句必须 `sourceRef`。没有数据时只能说「卷宗空白，无可奉告」，禁止编造。

## 一局流程

```
POST /actions/open
  body: { title, narrative, extras[] }   // extras 可含财务数字
        │
        ▼
  ledger: CASE_OPENED
  Redis: court:session:{caseId}  初始化 5 席
        │
        ▼
  3 rounds × 并行 Agent
    每回合：四位辩手发言 → 书记员摘要 → SSE 推前端
    审计员插入「呈堂证供」卡片（独立 UI，不是聊天气泡）
        │
        ▼
  POST /actions/sign
    body: { verdict, signatureSvg }
        │
        ▼
  ledger: VERDICT
  signal: court.verdict.signed
```

## 前端

- 布局：上方案号与倒计时，中间速记卷轴，右侧证人席，底部签名板（必须手写/指针轨迹，不能点按钮代替）。
- 审计员证供用牛皮纸/卷宗卡片，点开看 `sourceRef`。
- 健康度 < 40 时，悲观主义者话术升级，书记员开始阴阳。

## 数据

`g_court_case(id, player_id, title, status, rounds, verdict, signature_svg, created_at)`
`g_court_utterance` 只存摘要；全文 `court.es` 在 emit 前写完。外域调 `court.query`。可分享片段异步交共享语料。审计员只 `FACT_*`（封装病理/银行 query）。

## P0 / P1

P0：5 角色、3 回合、签名、审计员读 persona + 最近病历 + 银行头寸。
P1：玩家可中途拍槌打断、传唤某个 NPC 追加一轮。
