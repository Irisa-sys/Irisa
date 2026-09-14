# 062: [IMPL] 至少一次文字回应或明确承认某前提未验证

**What to build:** 用最小实现让 061 [TEST] 变绿：玩家不能只靠按钮打完一局，必须至少一次文字回应，或明确承认某前提未验证。

**Blocked by:** 061 [TEST] 至少一次文字回应或明确承认某前提未验证

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command

**Stories:** 06.12

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 从未文字回应也未承认前提未验证时，进入结局被拒绝
- [ ] 一次文字回应或一次明确承认未验证后，该门槛被满足
- [ ] 对应 TEST 变绿，不顺便实现后续切片
