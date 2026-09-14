# 141: [TEST] 过程帧转为 SSE

**What to build:** 写失败测试，证明：游戏发出的运行过程帧由网关转为 SSE。SSE 不是权威来源。不把事件名当成玩法规则。

**Blocked by:** 006 [IMPL] 运行标识与过程帧形状; 140 [IMPL] REST 命令进入游戏并返回运行标识

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** gateway

**Stories:** 04.3, 04.28

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 过程帧能从运行面转出为 SSE
- [ ] SSE 展示增量不单独成为已提交事实
- [ ] 不断言具体路径或事件名等于玩法规则
- [ ] 测试失败原因是缺失行为，而不是编译噪音
