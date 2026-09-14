# 112: [IMPL] 平行的你立刻给出行动、不预告后果、服从既定经历

**What to build:** 用最小实现让 111 [TEST] 变绿：让平行的我决定后立刻看到采取了什么行动，不提前看到后果。可选查看为什么这样做，解释只引用本宇宙经历、处境和已确认判断。自动决断先服从本宇宙既定经历。介入后可选填写我这样做是因为。

**Blocked by:** 111 [TEST] 平行的你立刻给出行动、不预告后果、服从既定经历

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.22-25, 07.57

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 交给平行的你后立刻提交采取了什么行动
- [ ] 解释和行动都不预告后果
- [ ] 解释不引用未授权或未确认材料
- [ ] 自动决断优先服从本宇宙既定经历，高于起点设定和 indexing 现实资料
- [ ] 对应 TEST 变绿，不顺便实现后续切片
