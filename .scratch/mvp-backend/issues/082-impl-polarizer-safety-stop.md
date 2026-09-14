# 082: [IMPL] 安全边界触发后立即停台

**What to build:** 用最小实现让 081 [TEST] 变绿：涉及自伤、他伤、违法或极端危险时立即停止对打，不生成后续质疑，不形成可授权的判断材料，并提示寻求支持。

**Blocked by:** 081 [TEST] 安全边界触发后立即停台

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command

**Stories:** 06.42

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 安全边界触发后对打状态为因安全边界停止
- [ ] 不能继续对打或生成后续质疑
- [ ] 不形成可授权的判断材料
- [ ] 对应 TEST 变绿，不顺便实现后续切片
