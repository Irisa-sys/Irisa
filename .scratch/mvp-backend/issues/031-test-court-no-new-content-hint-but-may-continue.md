# 031: [TEST] 无新内容时提示，但仍可继续当前阶段

**What to build:** 写失败测试，证明：连续追问没有新内容时得到明确提示，玩家仍可继续当前阶段。系统不能替玩家结束。

**Blocked by:** 030 [IMPL] 新路径未确认不进结案或决策资料事件

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.24, 05.25

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 连续追问没有新内容时给出明确提示
- [ ] 即使没有新内容，继续命令仍被接受且阶段不自动结束
- [ ] 测试失败原因是缺失行为，而不是编译噪音
