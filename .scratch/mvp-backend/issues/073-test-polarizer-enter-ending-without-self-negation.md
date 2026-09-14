# 073: [TEST] 进入结局的方式清楚；认输不等于否定整个人

**What to build:** 写失败测试，证明：完成五个主题、确认足以总结、认输、承认边界或主动结束时进入结局确认。认输只表示不再为当前表述辩护，不等于否定整个人。

**Blocked by:** 072 [IMPL] 回应、限缩；外部材料不算已验证事实

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command

**Stories:** 06.29, 06.30

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 玩家主动结束、认输、承认边界或确认足以总结时进入结局确认
- [ ] 认输后最终立场仍由玩家选择，不被写成否定整个人
- [ ] 测试失败原因是缺失行为，而不是编译噪音
