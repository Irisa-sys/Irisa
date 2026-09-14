# 122: [IMPL] 当前状态只包含已确认事实、计划和明确状态

**What to build:** 用最小实现让 121 [TEST] 变绿：当前状态只包含已确认事实、计划和明确状态，看不到心理揣测或未来预测。

**Blocked by:** 121 [TEST] 当前状态只包含已确认事实、计划和明确状态

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.40

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 当前状态可读到已确认事实、计划和明确状态
- [ ] 当前状态不含心理揣测或未来预测
- [ ] 对应 TEST 变绿，不顺便实现后续切片
