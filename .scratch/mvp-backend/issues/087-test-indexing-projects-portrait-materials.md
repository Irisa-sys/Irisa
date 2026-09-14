# 087: [TEST] 偏振器结局异构为画像资料

**What to build:** 写失败测试，证明：indexing 监听偏振器本域事件，异构为画像资料。结构化结局投影后仍是画像资料这一种。

**Blocked by:** 086 [IMPL] 结案事件异构为决策资料 materials/search

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** indexing.materials / indexing.search

**Stories:** 04.20

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 已结局且仍授权的画像资料可通过 materials 读到
- [ ] 已结局且仍授权的画像资料可被 search 命中
- [ ] 读到的是判断、范围、失效与更新条件、授权范围，而不是命题对打记录
- [ ] 测试失败原因是缺失行为，而不是编译噪音
