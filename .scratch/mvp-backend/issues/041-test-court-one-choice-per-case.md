# 041: [TEST] 一局只围绕一个选择

**What to build:** 写失败测试，证明：一局只围绕一个选择。另一个选择必须另开案件，中途不能把案件改成另一个选择。

**Blocked by:** 040 [IMPL] 暂停离开与继续未完成阶段

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.37

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 把案件改成另一个选择的命令被拒绝
- [ ] 原案件的选择对象保持不变
- [ ] 测试失败原因是缺失行为，而不是编译噪音
