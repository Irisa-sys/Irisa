# 133: [TEST] 档案馆只见决策/画像资料；时间线事件不是领域事件

**What to build:** 写失败测试，证明：档案馆只通过 indexing 读取决策资料和画像资料，领域里不出现案件、命题、书记员、反方。宇宙时间线事件是 archive 内部数据，不是跨模块通知。宇宙 RAG 只保存本宇宙经历，不回写 indexing。

**Blocked by:** 132 [IMPL] 取消当前在线生成不停离线任务

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.58, 07.59; 04.18, 04.27

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] archive 命令接口只看到决策资料和画像资料，看不到来源游戏内部记录
- [ ] 档案馆领域对象和命令不出现案件、命题、书记员、反方
- [ ] 提交宇宙时间线事件不会发布给 indexing 的领域事件
- [ ] 宇宙 RAG 更新不回写 indexing
- [ ] 测试失败原因是缺失行为，而不是编译噪音
