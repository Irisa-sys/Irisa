# 116: [IMPL] 资料缺口给出 2-4 个中性事实选项

**What to build:** 用最小实现让 115 [TEST] 变绿：缺少关键资料时看到 2-4 个中性事实选项和自定义补充。补充后看到更新过的当前事件再继续。非关键缺失可以跳过。

**Blocked by:** 115 [TEST] 资料缺口给出 2-4 个中性事实选项

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.28-30

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 关键资料缺口给出 2 到 4 个中性事实选项和自定义补充
- [ ] 补充后当前事件使用新事实再继续
- [ ] 非关键缺失可以跳过并以当前抽象程度继续
- [ ] 对应 TEST 变绿，不顺便实现后续切片
