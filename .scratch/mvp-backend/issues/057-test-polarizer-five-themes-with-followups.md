# 057: [TEST] 最多五个主要质疑主题，主题内可续问

**What to build:** 写失败测试，证明：一局最多五个主要质疑主题。一个主题不是一次问答，每个主题只处理一个主要问题。

**Blocked by:** 056 [IMPL] 开台校验；改写须确认；情绪不能写成人格

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command

**Stories:** 06.7-9

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 开始第六个主要质疑主题被拒绝
- [ ] 当前主题内可以多次追问
- [ ] 每个主题只暴露一个主要问题
- [ ] 测试失败原因是缺失行为，而不是编译噪音
