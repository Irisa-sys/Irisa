# 099: [TEST] 追问 2-3 个关键问题；非关键可暂不确定

**What to build:** 写失败测试，证明：系统追问 2-3 个影响起点成立的关键问题。非关键问题可以暂不确定，不必填完所有细节才能开始。

**Blocked by:** 098 [IMPL] 没有决策资料也能创建未来选择

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.6, 07.7

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 创建时会追问 2 到 3 个关键问题
- [ ] 非关键问题可标记为暂不确定
- [ ] 关键问题未回答时不能确认设定
- [ ] 测试失败原因是缺失行为，而不是编译噪音
