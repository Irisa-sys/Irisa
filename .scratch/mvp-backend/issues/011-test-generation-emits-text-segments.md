# 011: [TEST] generation 只出分段文本

**What to build:** 写失败测试，证明：LLM 生成端口只回调分段文本和完整结果，不知道角色、阶段、SSE 帧名、案件或命题，也不能改玩家事实。

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** llm.generation

**Stories:** 04.21, 04.31

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 端口只返回分段文本和完整结果
- [ ] 端口类型不含角色、阶段、案件、命题或 SSE 帧名
- [ ] 调用该端口不会修改玩家身份、授权或游戏状态
- [ ] 测试失败原因是缺失行为，而不是编译噪音
