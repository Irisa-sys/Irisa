# 030: [IMPL] 新路径未确认不进结案或决策资料事件

**What to build:** 用最小实现让 029 [TEST] 变绿：角色提出的新路径默认是讨论中的假设。玩家确认当时真实可行后，才能进入案件档案和决策资料事件。

**Blocked by:** 029 [TEST] 新路径未确认不进结案或决策资料事件

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** court.command / court.event

**Stories:** 05.22, 05.23

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 角色提出的路径在玩家确认前不会出现在结案档案中
- [ ] 角色提出的路径在玩家确认前不会出现在决策资料事件中
- [ ] 不确认的新路径仍留在讨论记录里
- [ ] 对应 TEST 变绿，不顺便实现后续切片
