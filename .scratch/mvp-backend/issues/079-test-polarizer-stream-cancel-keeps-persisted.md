# 079: [TEST] 流式质疑；取消无半段；刷新只见已提交

**What to build:** 写失败测试，证明：反方质疑一段一段出现。取消当前这次生成后，半段质疑不落库，对打仍停在当前主题。刷新后只看到已提交的质疑和整理。

**Blocked by:** 078 [IMPL] 按内容范围授权或撤回偏振器材料

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** polarizer.command / game.runtime

**Stories:** 06.39-41, 06.48

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 取消当前生成后没有半段质疑落库
- [ ] 取消后仍停在当前主题，不是结束对打
- [ ] 刷新或重读只看到已提交记录
- [ ] 测试失败原因是缺失行为，而不是编译噪音
