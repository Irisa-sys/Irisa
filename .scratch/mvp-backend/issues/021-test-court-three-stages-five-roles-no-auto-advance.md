# 021: [TEST] 三阶段；首次五角色；不自动推进

**What to build:** 写失败测试，证明：法庭按事实、路径、判断三阶段进行。首次进入阶段时五个角色依次发言。角色都发过言也不自动进入下一阶段。

**Blocked by:** 020 [IMPL] 开庭前确认卷宗与资料范围

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.7, 05.8, 05.14

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可见阶段只有事实、路径、判断
- [ ] 首次进入阶段时五个角色依次发言
- [ ] 角色发言完毕后阶段仍停在进行中，直到玩家确认
- [ ] 测试失败原因是缺失行为，而不是编译噪音
