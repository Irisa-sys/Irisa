# 113: [TEST] 行动一经确认不可改；自定义原文不进时间线

**What to build:** 写失败测试，证明：行动和理由一经确认不可修改。自定义方向的原始输入不出现在时间线，对外只保留忠实的行动描述。

**Blocked by:** 112 [IMPL] 平行的你立刻给出行动、不预告后果、服从既定经历

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.26, 07.27

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 已确认的行动和理由不能被修改
- [ ] 时间线不出现自定义方向的原始输入，只出现忠实的行动描述
- [ ] 测试失败原因是缺失行为，而不是编译噪音
