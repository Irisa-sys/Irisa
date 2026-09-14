# 093: [TEST] 开始前确认这是虚构平行宇宙叙事

**What to build:** 写失败测试，证明：玩家在开始前看到这是虚构平行宇宙叙事，不会把它当成现实预测或人生建议。

**Blocked by:** 006 [IMPL] 运行标识与过程帧形状; 008 [IMPL] 取消当前运行; 012 [IMPL] generation 只出分段文本; 014 [IMPL] embedding 只出带模型标识的向量; 086 [IMPL] 结案事件异构为决策资料 materials/search; 088 [IMPL] 偏振器结局异构为画像资料

**Status:** ready-for-agent

**TDD:** TEST

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
- [ ] 测试失败原因是缺失行为，而不是编译噪音
