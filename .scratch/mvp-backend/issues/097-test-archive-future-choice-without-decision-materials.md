# 097: [TEST] 没有决策资料也能创建未来选择

**What to build:** 写失败测试，证明：不依赖决策资料也能从现在创建未来选择。创建时说明方向、目标和最初行动。未来选择的时间起点是创建时的当前时刻。

**Blocked by:** 096 [IMPL] 历史分叉只用仍授权的决策资料

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.4, 07.5

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 没有决策资料时仍可创建未来选择草稿
- [ ] 未来选择必须说明方向、目标和最初行动
- [ ] 未来选择的时间起点是创建时的当前时刻
- [ ] 测试失败原因是缺失行为，而不是编译噪音
