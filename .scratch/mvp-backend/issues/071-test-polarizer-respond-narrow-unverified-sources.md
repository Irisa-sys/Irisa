# 071: [TEST] 回应、限缩；外部材料不算已验证事实

**What to build:** 写失败测试，证明：玩家可以直接回应、提供经历、说明外部材料或他人观点，缩小适用范围，指出反方使用了错误事实，或承认无法回答、不再相信这条命题。外部材料不被自动当成已验证事实。

**Blocked by:** 070 [IMPL] 无新内容可续；五主题不自动结局

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command

**Stories:** 06.24-28

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 玩家可缩小适用范围而不必立刻放弃命题
- [ ] 外部材料在档案中可与已验证依据区分，且不会自动变成已验证事实
- [ ] 承认无法回答或放弃当前表述后，对打可停在该位置
- [ ] 测试失败原因是缺失行为，而不是编译噪音
