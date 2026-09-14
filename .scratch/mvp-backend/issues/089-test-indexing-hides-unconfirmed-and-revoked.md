# 089: [TEST] 未确认或已撤回立即不可见

**What to build:** 写失败测试，证明：未确认内容不会出现在 indexing。撤回授权后，后续 materials/search 立即看不到该内容。indexing 在未确认或已撤回时不建立有效投影。

**Blocked by:** 088 [IMPL] 偏振器结局异构为画像资料

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** indexing.materials / indexing.search

**Stories:** 04.12, 04.29

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 未确认内容不会出现在 materials 或 search 中
- [ ] 撤回授权后，后续 materials/search 立即不再返回该内容
- [ ] 未确认或已撤回时不建立有效投影
- [ ] 测试失败原因是缺失行为，而不是编译噪音
