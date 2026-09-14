# 055: [TEST] 开台校验；改写须确认；情绪不能写成人格

**What to build:** 写失败测试，证明：玩家输入一句命题并说明它更接近核心信念、情境判断还是尚不确定。命题不清时可看到更明确的候选说法，必须经玩家确认。情绪描述不能被改写成人格结论。人身攻击、歧视、伤害主张或过宽命题不能开台。

**Blocked by:** 004 [IMPL] 命令接受或拒绝回执; 006 [IMPL] 运行标识与过程帧形状; 008 [IMPL] 取消当前运行; 012 [IMPL] generation 只出分段文本

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command

**Stories:** 06.1-6

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 不合格命题不能开台
- [ ] 系统给出的更明确说法必须经玩家确认才开始
- [ ] 情绪描述不能被改写成人格结论
- [ ] 人身攻击、歧视或伤害主张被拒绝开台
- [ ] 测试失败原因是缺失行为，而不是编译噪音
