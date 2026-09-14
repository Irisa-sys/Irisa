# 137: [TEST] 鉴权后把 playerId 传给游戏命令

**What to build:** 写失败测试，证明：网关鉴权后把 playerId 传给游戏模块。网关只转发命令，不实现玩法。

**Blocked by:** 002 [IMPL] 同一身份进入三款游戏

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** gateway

**Stories:** 04.1, 04.28

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 未鉴权请求不能进入游戏命令
- [ ] 鉴权成功后游戏命令收到的是该玩家的 playerId
- [ ] 测试失败原因是缺失行为，而不是编译噪音
