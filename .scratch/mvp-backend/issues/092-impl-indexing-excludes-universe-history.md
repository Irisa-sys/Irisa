# 092: [IMPL] indexing 不含宇宙经历

**What to build:** 用最小实现让 091 [TEST] 变绿：现实资料索引和宇宙专属索引隔离。indexing 不含某宇宙的事件正文、我的行动、宇宙补充或当前状态。

**Blocked by:** 091 [TEST] indexing 不含宇宙经历

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** indexing.materials / indexing.search

**Stories:** 04.30

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 即使存在宇宙时间线事件，materials/search 也不返回宇宙经历
- [ ] 平行经历不会变成现实画像资料
- [ ] 对应 TEST 变绿，不顺便实现后续切片
