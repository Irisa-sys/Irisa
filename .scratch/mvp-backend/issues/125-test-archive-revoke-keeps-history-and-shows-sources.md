# 125: [TEST] 撤回不改已发生经历；可看来源快照

**What to build:** 写失败测试，证明：随时撤回某项资料授权后，后续推演不再使用它，已经发生的事件保持原样。玩家可查看本宇宙资料来源，以解释它从什么材料起步。快照不等于后续仍可继续读取被撤回的资料。

**Blocked by:** 124 [IMPL] 补充从当前节点生效；冲突写成从现在起

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command

**Stories:** 07.43-45; 04.11

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 撤回授权后后续生成不得再检索该资料
- [ ] 已写入事件和当前已确认状态保持原样
- [ ] 可查看本宇宙创建时使用的资料来源快照
- [ ] 测试失败原因是缺失行为，而不是编译噪音
