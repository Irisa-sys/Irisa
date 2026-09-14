# 047: [TEST] 按范围授权或撤回并发布决策资料事件

**What to build:** 写失败测试，证明：玩家按内容范围选择档案馆可以使用哪些材料，并可随时撤回。结案、授权变更或撤回后发布本模块领域事件，payload 已是决策资料字段。

**Blocked by:** 046 [IMPL] 结案档案区分当时路径、现在评价，不含未确认假设

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command / court.event

**Stories:** 05.47, 05.48; 04.9, 04.10

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可按内容范围授权，而不是只能整局一键交出
- [ ] 结案或授权变更后发布决策资料字段的本域事件
- [ ] 撤回后后续决策资料事件使对应字段不再对外可见
- [ ] 测试失败原因是缺失行为，而不是编译噪音
