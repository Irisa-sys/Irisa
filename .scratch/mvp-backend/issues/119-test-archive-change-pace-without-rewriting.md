# 119: [TEST] 改节奏不回写已经发生的事件

**What to build:** 写失败测试，证明：玩家可选择细致、正常或快速节奏。改节奏不回写已经发生的事件，过去的粒度保持原样。

**Blocked by:** 118 [IMPL] 离线按步数推进；决策或缺口即停；同一宇宙单任务

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.38, 07.39

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可以设置细致、正常或快速节奏并影响之后事件
- [ ] 改节奏后已经发生的事件内容和粒度不变
- [ ] 测试失败原因是缺失行为，而不是编译噪音
