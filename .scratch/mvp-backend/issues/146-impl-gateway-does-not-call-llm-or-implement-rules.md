# 146: [IMPL] gateway 不调 llm、不实现玩法

**What to build:** 用最小实现让 145 [TEST] 变绿：网关只转发命令和流式帧。不依赖 llm，不实现玩法规则。

**Blocked by:** 145 [TEST] gateway 不调 llm、不实现玩法

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** gateway

**Stories:** 04.28

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] gateway 模块不调用 llm.generation 或 llm.embedding
- [ ] 玩法拒绝规则仍由游戏命令接口决定，网关不另写一套
- [ ] 对应 TEST 变绿，不顺便实现后续切片
