# 078: [IMPL] 按内容范围授权或撤回偏振器材料

**What to build:** 用最小实现让 077 [TEST] 变绿：玩家按内容范围授权档案馆参考，并可随时撤回。结局或授权变更后发布本模块领域事件，payload 使用画像资料字段。

**Blocked by:** 077 [TEST] 按内容范围授权或撤回偏振器材料

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command / polarizer.event

**Stories:** 06.37, 06.38

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可按内容范围授权，而不是只能整局交出
- [ ] 授权变更或撤回后发布画像资料字段的本域事件
- [ ] 撤回后后续事件使对应内容不再对外可见
- [ ] 对应 TEST 变绿，不顺便实现后续切片
