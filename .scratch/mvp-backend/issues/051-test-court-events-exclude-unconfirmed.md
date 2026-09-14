# 051: [TEST] 未结案或未确认假设不发可检索决策资料

**What to build:** 写失败测试，证明：只有已结案且玩家确认的决策资料进入本域事件。未结案案件不发可检索的决策资料。未确认假设即使仍在庭审记录中，也不进入事件。

**Blocked by:** 050 [IMPL] 流式生成；取消无半段；刷新只见已提交

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.event

**Stories:** 05.53, 05.54, 05.56

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 未结案案件不发布可检索的决策资料事件
- [ ] 未确认假设不出现在决策资料事件中
- [ ] 事件 payload 使用决策资料字段，不含阶段或角色语义作为消费前提
- [ ] 测试失败原因是缺失行为，而不是编译噪音
