# 054: [IMPL] 新增现实资料不抹掉讨论经过

**What to build:** 用最小实现让 053 [TEST] 变绿：新增现实资料可以补充案件，但不能抹掉已经发生的讨论经过。修正不等于改历史。

**Blocked by:** 053 [TEST] 新增现实资料不抹掉讨论经过

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** court.command

**Stories:** 05.59

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 新增资料后案件可以使用新的确认内容
- [ ] 此前讨论记录仍可回看，不被删除或改写成从未发生
- [ ] 对应 TEST 变绿，不顺便实现后续切片
