# 096: [IMPL] 历史分叉只用仍授权的决策资料

**What to build:** 用最小实现让 095 [TEST] 变绿：历史分叉只能从 indexing 中当前仍授权的决策资料创建，且只使用玩家确认且当时可行的未选路径或自定义替代行动。不在 indexing 中或已撤回的决策资料不能创建历史分叉。

**Blocked by:** 095 [TEST] 历史分叉只用仍授权的决策资料

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.2, 07.3

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 不在 indexing 中或已撤回的决策资料不能创建历史分叉
- [ ] 未确认路径不能作为替代行动
- [ ] 历史分叉的时间起点是原选择时刻，不是今天
- [ ] 对应 TEST 变绿，不顺便实现后续切片
