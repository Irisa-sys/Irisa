# 005: [TEST] 运行标识与过程帧形状

**What to build:** 写失败测试，证明：会触发生成的命令先创建一次运行并返回运行标识。过程帧是展示增量，不是领域事件，也不代表游戏状态已改变。

**Blocked by:** 004 [IMPL] 命令接受或拒绝回执

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** game.runtime

**Stories:** 04.3, 04.26

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 触发生成的命令返回运行标识
- [ ] 过程帧至少包含运行标识、序号、类型、内容、发生时间
- [ ] 帧类型可区分 started / persisted / completed / failed / cancelled 等
- [ ] 发出过程帧本身不改变权威游戏状态
- [ ] 测试失败原因是缺失行为，而不是编译噪音
