# 094: [IMPL] 开始前确认这是虚构平行宇宙叙事

**What to build:** 用最小实现让 093 [TEST] 变绿：玩家在开始前看到这是虚构平行宇宙叙事，不会把它当成现实预测或人生建议。

**Blocked by:** 093 [TEST] 开始前确认这是虚构平行宇宙叙事

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.1

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 创建宇宙前必须看到虚构叙事说明
- [ ] 未确认该说明时不能分配宇宙编号或开始推演
- [ ] 对应 TEST 变绿，不顺便实现后续切片
