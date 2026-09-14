# 108: [IMPL] 重大决策可介入或交给平行的你；资料不足无后者

**What to build:** 用最小实现让 107 [TEST] 变绿：重大决策时玩家选择我来介入或让平行的我决定。资料不足时不要出现让平行的我决定，系统不会无依据替玩家行动。

**Blocked by:** 107 [TEST] 重大决策可介入或交给平行的你；资料不足无后者

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.16, 07.17

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 资料充足的重大决策可以选择介入或交给平行的你
- [ ] 资料不足时不能选择让平行的你决定
- [ ] 资料不足时宇宙停在等待补充信息
- [ ] 对应 TEST 变绿，不顺便实现后续切片
