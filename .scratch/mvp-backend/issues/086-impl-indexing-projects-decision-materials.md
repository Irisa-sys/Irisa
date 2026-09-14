# 086: [IMPL] 结案事件异构为决策资料 materials/search

**What to build:** 用最小实现让 085 [TEST] 变绿：indexing 监听法庭本域事件，异构为决策资料，提供结构化读取和语义检索。只索引已确认且当前仍授权的内容。

**Blocked by:** 085 [TEST] 结案事件异构为决策资料 materials/search

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** indexing.materials / indexing.search

**Stories:** 04.18, 04.20, 04.29

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 已结案且仍授权的决策资料可通过 materials 读到
- [ ] 已结案且仍授权的决策资料可被 search 命中
- [ ] materials 和 search 看不到来源游戏内部记录或阶段/角色语义作为领域概念
- [ ] 对应 TEST 变绿，不顺便实现后续切片
