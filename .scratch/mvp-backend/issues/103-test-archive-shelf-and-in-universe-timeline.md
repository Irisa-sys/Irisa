# 103: [TEST] 书架列出宇宙；打开后按宇宙内时间阅读

**What to build:** 写失败测试，证明：书架上看到编号、名称和状态。打开宇宙后按宇宙内时间阅读事件。事件按时间、标题、正文、我的行动排列。

**Blocked by:** 102 [IMPL] 确认设定后才分配编号并开始第一次生成

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.11-13

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 书架可看到编号、名称和状态
- [ ] 打开后事件按宇宙内时间顺序排列
- [ ] 事件可见时间、标题、正文和可选的我的行动
- [ ] 测试失败原因是缺失行为，而不是编译噪音
