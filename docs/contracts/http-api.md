# HTTP API 冻结稿（P0）

Base path: `/api`  
鉴权: `Authorization: Bearer <jwt>`。未登录 401，body 见错误信封。  
JSON: camelCase。时间 ISO-8601 UTC。

前端和底座 stub 必须同时遵守。改字段先改本文。

## 错误信封

```json
{ "error": { "code": "UNAUTHENTICATED", "message": "..." } }
```

常用 `code`：`UNAUTHENTICATED` `FORBIDDEN` `NOT_FOUND` `VALIDATION` `GAME_DISABLED` `BUDGET_EXHAUSTED` `CONFLICT`

## 鉴权

```
POST /api/auth/mock
  body: { "githubLogin": "fyj" }
  201 {
    "token": "<jwt>",
    "tokenType": "Bearer",
    "expiresIn": 604800
  }

POST /api/auth/logout
  204
  服务端把当前 jti 写入 Redis 黑名单；客户端丢 token

GET  /api/me
  200 { "playerId": 1, "githubLogin": "fyj", "createdAt": "..." }
```

GitHub OAuth 以后加 `GET /api/auth/github`，不改 `/me`。

## 画像与游戏目录

```
GET /api/persona
  200 {
    "codeCredit": 820,
    "mindHealth": 64,
    "energyNet": 12.5,
    "biasTags": ["JAVA_RELIGION"],
    "updatedAt": "..."
  }

GET /api/me/usage
  200 {
    "byGame": [
      { "slug": "pathology", "calls": 12, "tokensIn": 8000, "tokensOut": 3000 }
    ]
  }

GET /api/games
  200 {
    "games": [
      {
        "slug": "pathology",
        "title": "当代病理诊断书",
        "status": "ACTIVE",
        "route": "/games/pathology"
      }
    ]
  }

GET /api/games/{slug}/state
  200  见各游戏。未知 slug → 404 GAME_DISABLED
```

`status`: `ACTIVE` | `DISABLED` | `COMING_SOON`  
前端宫格：`COMING_SOON` 可点进海报页；`DISABLED` 灰掉。

## 回音壳（挂在宿主，不挂游戏路由）

```
GET /api/echo/pending
  200 { "pending": false }
  或 { "pending": true, "oathId": "...", "keywords": ["图形学", "今年"] }
  注意：不返回誓言全文，全文只在触发后的打断流里出现

POST /api/echo/unlock
  body: { "oathId": "...", "phrase": "用户打的词" }
  200 { "ok": true } | 400 VALIDATION
```

任意页面加载先打 `pending`。这是壳层的唯一跨游戏请求。

## 通用动作与 SSE

```
POST /api/games/{slug}/actions/{action}
GET  /api/games/{slug}/stream?topic=...
```

SSE 见 [sse-events.md](./sse-events.md)。`topic` 默认该游戏当前局。

---

## pathology

`GET /state`

```json
{
  "todayReport": null,
  "recent": []
}
```

有报告时 `todayReport` 与单份报告同形：

```json
{
  "reportId": "pr_1",
  "date": "2026-08-20",
  "diagnosisCode": "DA_RECEPTOR_OVERLOAD",
  "title": "确诊为多巴胺受体低级过载丧尸化",
  "findings": [{ "code": "RED_DOT_COMPULSION", "text": "..." }],
  "prescription": [{ "drug": "强制锁屏 45m", "forFinding": "RED_DOT_COMPULSION" }],
  "severity": "SEVERE_SLACK",
  "mindHealthDelta": -12,
  "createdAt": "..."
}
```

`POST /actions/admit`  
body: `{ "date": "2026-08-20", "confession": "..." }`  
202：开始诊断，客户端改订 `GET .../stream?topic=report:{id}`  
200：同步返回完整报告（stub 可直接 200）

同一天再 admit = 修订，`reportId` 变，`date` 不变。

---

## court

`GET /state`

```json
{
  "activeCase": null,
  "lastVerdict": null
}
```

开庭后 `activeCase`：

```json
{
  "caseId": "cs_1",
  "title": "要不要裸辞",
  "status": "IN_SESSION",
  "round": 1,
  "maxRounds": 3,
  "roles": ["COURT_PAST_SELF", "COURT_PESSIMIST", "COURT_OPPORTUNIST", "COURT_AUDITOR", "COURT_CLERK"]
}
```

`status`: `IN_SESSION` | `AWAITING_SIGNATURE` | `SIGNED` | `TRUNCATED`

`POST /actions/open`  
body: `{ "title": "...", "narrative": "...", "extras": [{ "key": "savings", "value": "20w" }] }`  
201 `{ "caseId": "cs_1" }` 随后 SSE `topic=case:cs_1`

`POST /actions/sign`  
body: `{ "caseId": "cs_1", "verdict": "...", "signatureSvg": "<svg...>" }`  
200 `{ "status": "SIGNED" }`

---

## echo（立誓页，打断走壳层）

`POST /actions/swear`  
body: `{ "text": "今年必须啃下图形学" }`  
201 `{ "oathId": "oa_1" }`  
之后列表不可见。`GET /state` → `{ "canSwear": true, "activeCount": 1 }` 只给计数。

---

## haunt

`GET /state` → `{ "ghosts": [ { "id", "path", "ghostType", "severity", "r", "theta" } ] }`  
`ghostType`: `WRAITH` | `ZOMBIE` | `POLTERGEIST`  
`POST /actions/ingest-diff` body: `{ "repo": "irisa", "diff": "..." }` → 202

---

## gravity

`GET /state` → `{ "bodies": [ { "id", "alias", "mass", "charge", "eccentricity", "periodDays" } ], "energyNet": 12.5 }`  
`POST /actions/ingest` body: `{ "text": "聊天或观察" }` → 202

---

## polarizer

`GET /state` → `{ "activeBout": null }`  
`POST /actions/challenge` `{ "proposition": "..." }` → 201 `{ "boutId": "bt_1" }`  
`POST /actions/rebut` `{ "boutId", "text", "evidenceUrls": [] }`  
`POST /actions/close` `{ "boutId", "outcome": "HELD"|"CONCEDED"|"DRAW" }`

---

## bank

`GET /state`

```json
{
  "principal": 120000,
  "interest": 8600,
  "nplRate": 0.18,
  "capacity": 40000,
  "bars": [{ "day": "2026-08-01", "open": 1, "high": 2, "low": 0.9, "close": 1.8 }],
  "topNotes": [{ "path": "Foo.java", "principal": 8000, "interest": 400, "npl": false }]
}
```

`POST /actions/scan` `{ "repo": "irisa" }` → 202  
破产只出 UI 状态：`GET /state` 可带 `"bankruptcy": { "dryRun": true, "reason": "..." }`，没有真实 PR。
