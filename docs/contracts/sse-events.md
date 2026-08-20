# SSE 事件冻结稿（P0）

```
GET /api/games/{slug}/stream?topic=...
Content-Type: text/event-stream
```

每条：

```
id: 17
event: <name>
data: { ...json }

```

`id` 单调。客户端 `Last-Event-ID` 可重放（stub 可忽略）。心跳：`event: ping` 每 15s，`data: {}`。

## 通用

| event | data | 何时 |
| --- | --- | --- |
| `ping` | `{}` | 保活 |
| `error` | `{ "code", "message" }` | 流内失败，随后 `done` |
| `done` | `{ "reason": "COMPLETE"\|"TRUNCATED"\|"BUDGET_EXHAUSTED" }` | 关流 |

## pathology `topic=report:{id}`

| event | data |
| --- | --- |
| `typing` | `{ "partial": "正在出具……" }` |
| `report` | 完整报告对象（同 HTTP） |
| `persona` | `{ "mindHealth": 52, "delta": -12 }` |
| `done` | `{ "reason": "COMPLETE" }` |

stub 可跳过 `typing`，直接 `report` + `persona` + `done`。

## court `topic=case:{id}`

严格顺序：`round_start` → 若干 `utterance` → 可选 `exhibit` → `clerk_digest` → 下一轮或 `awaiting_signature`。

| event | data |
| --- | --- |
| `round_start` | `{ "round": 1, "maxRounds": 3 }` |
| `utterance` | `{ "role": "COURT_PESSIMIST", "seq": 1, "text": "...", "partial": false }` |
| `exhibit` | `{ "role": "COURT_AUDITOR", "text": "...", "sourceRef": { "kind": "PATHOLOGY", "id": "pr_1" } }` |
| `clerk_digest` | `{ "round": 1, "points": ["..."] }` |
| `awaiting_signature` | `{ "caseId": "cs_1" }` |
| `signed` | `{ "caseId": "cs_1" }` |
| `done` | `{ "reason": "COMPLETE" }` |

规则：

- `partial: true` 的 `utterance` 可连发，最后一条 `partial: false` 定稿
- `exhibit` 不是聊天气泡。`sourceRef` 缺省时前端标「未核实」
- `BUDGET_EXHAUSTED` 时仍推 `awaiting_signature`，status 变 `TRUNCATED`

## polarizer `topic=bout:{id}`

| event | data |
| --- | --- |
| `punch` | `{ "side": "ADVOCATE"\|"PLAYER", "seq": 1, "text": "...", "partial": false }` |
| `meter` | `{ "bias": 72 }` 仅装饰 |
| `done` | 回合结束或 close |

## echo 打断（壳层）

回音不走游戏 stream。壳在 `pending=true` 后打开全屏，再订：

```
GET /api/echo/stream?oathId=oa_1
```

| event | data |
| --- | --- |
| `blackout` | `{}` |
| `voice` | `{ "text": "誓言原文", "partial": false }` |
| `wait_unlock` | `{ "keywordsHintCount": 3 }` |
| `released` | `{}` |

## haunt / gravity / bank

P0 可以不推 SSE，HTTP 轮询 `/state` 即可。若做，也只用通用 `done` + 一个 `state_patch`：

`event: state_patch` `data: { ...GET /state 的子集 }`
