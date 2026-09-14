# 050: [IMPL] 流式生成；取消无半段；刷新只见已提交

**What to build:** 用最小实现让 049 [TEST] 变绿：角色发言一段一段出现。取消当前这次生成后，半段发言不落库；已提交发言和总结仍在。刷新后只看到已提交状态。取消后仍能继续当前阶段。

**Blocked by:** 049 [TEST] 流式生成；取消无半段；刷新只见已提交

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** court.command / game.runtime

**Stories:** 05.49-52; 04.5, 04.6, 04.8

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 取消当前生成后没有半段发言落库
- [ ] 已经 persisted 的发言和总结仍在
- [ ] 刷新或重读只看到已提交记录
- [ ] 取消后仍可对同一案件继续当前阶段
- [ ] 对应 TEST 变绿，不顺便实现后续切片
