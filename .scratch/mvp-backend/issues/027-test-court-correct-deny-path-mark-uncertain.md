# 027: [TEST] 补充、更正、否定路径、标记不确定

**What to build:** 写失败测试，证明：玩家可以补充、更正、澄清、指出角色误解，说明某条路径当时其实不可行，或把某项内容标记为不确定。

**Blocked by:** 026 [IMPL] 继续当前阶段：相关角色或点名，不换主题

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.19-21

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 玩家补充或更正后，后续庭审使用最新确认内容
- [ ] 玩家否定的路径不再作为当时可行选项
- [ ] 标记为不确定的内容不会被填成事实
- [ ] 测试失败原因是缺失行为，而不是编译噪音
