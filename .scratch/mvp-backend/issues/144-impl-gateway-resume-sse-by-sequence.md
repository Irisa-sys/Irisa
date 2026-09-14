# 144: [IMPL] 按序号续 SSE

**What to build:** 用最小实现让 143 [TEST] 变绿：前端刷新或重连后，可从上次看到的序号继续接收 SSE，不必从头重看整段生成。

**Blocked by:** 143 [TEST] 按序号续 SSE

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** gateway

**Stories:** 04.7

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可从指定序号之后继续接收同一运行的 SSE
- [ ] 重连后权威状态仍以已提交记录为准
- [ ] 对应 TEST 变绿，不顺便实现后续切片
