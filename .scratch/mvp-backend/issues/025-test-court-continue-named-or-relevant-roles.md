# 025: [TEST] 继续当前阶段：相关角色或点名，不换主题

**What to build:** 写失败测试，证明：书记员总结后玩家可继续当前阶段。未点名则只让相关角色继续，不是五人全部重来；点名则指定角色追问。继续时不得开启新的阶段主题。

**Blocked by:** 024 [IMPL] 角色输出按阶段主题和资料边界校验

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.15-18

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 继续当前阶段可以点名角色
- [ ] 未点名则只让与未解问题相关的角色继续，而不是默认五人全部重来
- [ ] 继续追问时角色不得开启新的阶段主题
- [ ] 测试失败原因是缺失行为，而不是编译噪音
