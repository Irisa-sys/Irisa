# 084: [IMPL] 画像事件不含未确认推测

**What to build:** 用最小实现让 083 [TEST] 变绿：本域事件只包含玩家确认且当前仍授权的判断、范围、依据、保护价值、失效条件和立场。未确认推测不出现。有边界的判断不被扩张成绝对性格。

**Blocked by:** 083 [TEST] 画像事件不含未确认推测

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.event

**Stories:** 06.43, 06.44, 06.46

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 未确认推测不出现在画像资料事件中
- [ ] 事件 payload 使用画像资料字段
- [ ] 带范围的判断在事件中仍带范围，不被写成绝对性格
- [ ] 对应 TEST 变绿，不顺便实现后续切片
