# 106: [IMPL] 在线一步只提交一个完整事件

**What to build:** 用最小实现让 105 [TEST] 变绿：每次在线继续只出现一个新事件。普通事件自动完成并写入时间线。一次成功推进一步，只提交一个完整时间线事件。

**Blocked by:** 105 [TEST] 在线一步只提交一个完整事件

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.14, 07.15

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 在线一步最多新增一个完整事件
- [ ] 普通事件自动写入时间线，不必每次都做选择
- [ ] 事件包含稳定标识、宇宙内顺序、宇宙内时间、标题和叙事
- [ ] 对应 TEST 变绿，不顺便实现后续切片
