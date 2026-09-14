# 001: [TEST] 同一身份进入三款游戏

**What to build:** 写失败测试，证明：同一个登录身份进入法庭、偏振器和档案馆，案件、命题和宇宙都属于该玩家。

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** identity.auth / identity.player

**Stories:** 04.1

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 同一 playerId 可打开三款游戏的命令面
- [ ] 一款游戏写入的资料不会变成另一玩家的资料
- [ ] 测试失败原因是缺失行为，而不是编译噪音
