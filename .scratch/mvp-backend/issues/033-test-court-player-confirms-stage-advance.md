# 033: [TEST] 玩家确认后才进入下一阶段

**What to build:** 写失败测试，证明：玩家接受当前整理后才进入下一阶段。未确认进入下一阶段时仍停在当前阶段。

**Blocked by:** 032 [IMPL] 无新内容时提示，但仍可继续当前阶段

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.26

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 未确认进入下一阶段时仍停在当前阶段
- [ ] 确认后才进入下一阶段
- [ ] 阶段不会因为角色发言次数或书记员判断而自动推进
- [ ] 测试失败原因是缺失行为，而不是编译噪音
