# 013: [TEST] embedding 只出带模型标识的向量

**What to build:** 写失败测试，证明：Embedding 端口只把给定文本转为向量，并带上模型标识、版本和维度。

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** llm.embedding

**Stories:** 04.21

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 给定文本返回向量
- [ ] 向量记录包含模型标识、版本和维度
- [ ] 该端口不写入游戏状态或 indexing 文档
- [ ] 测试失败原因是缺失行为，而不是编译噪音
