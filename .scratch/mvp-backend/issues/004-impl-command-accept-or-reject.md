# 004: [IMPL] 命令接受或拒绝回执

**What to build:** 用最小实现让 003 [TEST] 变绿：每条命令都得到明确的接受或拒绝，玩家知道这次操作有没有生效。

**Blocked by:** 003 [TEST] 命令接受或拒绝回执

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** game.runtime

**Stories:** 04.2

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 合法命令返回接受回执
- [ ] 非法命令返回拒绝回执，不改变游戏状态
- [ ] 对应 TEST 变绿，不顺便实现后续切片
