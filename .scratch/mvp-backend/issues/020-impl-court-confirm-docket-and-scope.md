# 020: [IMPL] 开庭前确认卷宗与资料范围

**What to build:** 用最小实现让 019 [TEST] 变绿：开庭前玩家确认时间、实际路径、候选路径、事实和不确定内容，并选择本次可用资料范围；可逐项修正卷宗。

**Blocked by:** 019 [TEST] 开庭前确认卷宗与资料范围

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** court.command

**Stories:** 05.4-6

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 开庭前可确认或修正时间、实际路径、候选路径、事实和不确定内容
- [ ] 玩家可选择本次庭审可用的个人资料范围
- [ ] 未确认卷宗前不能开始阶段庭审
- [ ] 对应 TEST 变绿，不顺便实现后续切片
