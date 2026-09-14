# 145: [TEST] gateway 不调 llm、不实现玩法

**What to build:** 写失败测试，证明：网关只转发命令和流式帧。不依赖 llm，不实现玩法规则。

**Blocked by:** 140 [IMPL] REST 命令进入游戏并返回运行标识

**Status:** ready-for-agent

**TDD:** TEST

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
- [ ] 测试失败原因是缺失行为，而不是编译噪音
