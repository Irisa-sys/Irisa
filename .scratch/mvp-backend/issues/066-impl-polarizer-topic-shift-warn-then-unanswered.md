# 066: [IMPL] 转移命题时提醒一次，再次转移记为未回答

**What to build:** 用最小实现让 065 [TEST] 变绿：如果玩家把讨论转到另一个命题，反方提醒一次并拉回。再次转移时把当前问题记为未回答，系统不继续纠缠，也不假装已经解决。

**Blocked by:** 065 [TEST] 转移命题时提醒一次，再次转移记为未回答

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command

**Stories:** 06.14, 06.15

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 第一次转移命题时提醒并拉回当前问题
- [ ] 再次转移时当前问题被标记为未回答
- [ ] 未回答不会被写成已经解决
- [ ] 对应 TEST 变绿，不顺便实现后续切片
