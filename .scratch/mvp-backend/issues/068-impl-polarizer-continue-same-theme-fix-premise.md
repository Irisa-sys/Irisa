# 068: [IMPL] 继续不换题；指定角度；纠正前提后不得再用

**What to build:** 用最小实现让 067 [TEST] 变绿：继续当前质疑时反方不得借机换主题。玩家可要求澄清、纠正错误前提或补充说明范围，也可点名允许角度。指出错误前提后，该前提不得再作为后续质疑的既定事实。

**Blocked by:** 067 [TEST] 继续不换题；指定角度；纠正前提后不得再用

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command

**Stories:** 06.16-19, 06.47

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 继续当前质疑时不能更换主题
- [ ] 玩家指定角度后，该次继续只围绕该角度
- [ ] 指出错误前提后，后续提交不得再把该前提当事实
- [ ] 对应 TEST 变绿，不顺便实现后续切片
