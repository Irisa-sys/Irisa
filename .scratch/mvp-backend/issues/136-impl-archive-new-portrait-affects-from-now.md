# 136: [IMPL] 新的画像资料只影响当前节点之后

**What to build:** 用最小实现让 135 [TEST] 变绿：新的判断材料只影响既有宇宙当前节点之后，过去的平行经历不被无痕改写。

**Blocked by:** 135 [TEST] 新的画像资料只影响当前节点之后

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 06.50

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 新授权的画像资料不改写已经发生的宇宙事件
- [ ] 后续推演可以使用新的画像资料
- [ ] 对应 TEST 变绿，不顺便实现后续切片
