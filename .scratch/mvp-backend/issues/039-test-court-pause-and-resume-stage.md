# 039: [TEST] 暂停离开与继续未完成阶段

**What to build:** 写失败测试，证明：玩家可在阶段未完成时离开，稍后从当前阶段未解决问题继续。

**Blocked by:** 038 [IMPL] 更正后仍保留原先说法作为痕迹

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.35, 05.36

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 暂停后案件仍为审理中，当前阶段进度保留
- [ ] 继续时从当前阶段未解决问题接着进行
- [ ] 测试失败原因是缺失行为，而不是编译噪音
