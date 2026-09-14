# 007: [TEST] 取消当前运行

**What to build:** 写失败测试，证明：玩家可以取消当前这次流式生成。取消停止继续生成和后续增量帧，运行以 cancelled 结束。

**Blocked by:** 006 [IMPL] 运行标识与过程帧形状

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** game.runtime

**Stories:** 04.4

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 取消后运行以 cancelled 结束
- [ ] 取消后不再发送后续增量帧
- [ ] 取消不等于删除案件、命题或宇宙
- [ ] 测试失败原因是缺失行为，而不是编译噪音
