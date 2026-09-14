# 124: [IMPL] 补充从当前节点生效；冲突写成从现在起

**What to build:** 用最小实现让 123 [TEST] 变绿：补充当前情况后从当前节点生效，过去的事件不被重写。与既定经历冲突的补充被改写成从现在起成立的新变化。

**Blocked by:** 123 [TEST] 补充从当前节点生效；冲突写成从现在起

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.41, 07.42

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 补充当前情况后，已写入事件保持原样
- [ ] 与既定经历冲突的补充不得写成过去一直如此
- [ ] 新变化从当前节点之后生效
- [ ] 对应 TEST 变绿，不顺便实现后续切片
