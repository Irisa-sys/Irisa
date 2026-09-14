# 046: [IMPL] 结案档案区分当时路径、现在评价，不含未确认假设

**What to build:** 用最小实现让 045 [TEST] 变绿：结案档案包含当时资源、限制、看重的东西、起作用的理由和后来结果，并写明现在如何理解这次选择。今天的评价不能替代当时真实做出的选择。未确认假设正文不进入结案档案。

**Blocked by:** 045 [TEST] 结案档案区分当时路径、现在评价，不含未确认假设

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** court.command / court.event

**Stories:** 05.44-46, 05.60

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 结案档案能区分实际路径和未选择路径
- [ ] 结案档案能区分当时选择和现在评价
- [ ] 结案档案不含未确认假设正文
- [ ] 对应 TEST 变绿，不顺便实现后续切片
