# 063: [TEST] 选择一种允许的质疑方向

**What to build:** 写失败测试，证明：玩家可以选择定义、范围、证据、因果、反例、代价或更新中的一种质疑方向，每次追问有明确角度。

**Blocked by:** 062 [IMPL] 至少一次文字回应或明确承认某前提未验证

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command

**Stories:** 06.13

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 玩家指定允许角度后，该次继续只围绕该角度
- [ ] 不允许的角度被拒绝
- [ ] 测试失败原因是缺失行为，而不是编译噪音
