# 017: [TEST] 提交案件；不足则最多三问后停在需要补充

**What to build:** 写失败测试，证明：玩家提交一个具体选择作为案件。信息不足时最多问三个关键补充问题；补充后仍无法定位则停在需要补充，不能进入庭审。

**Blocked by:** 004 [IMPL] 命令接受或拒绝回执; 006 [IMPL] 运行标识与过程帧形状; 008 [IMPL] 取消当前运行; 012 [IMPL] generation 只出分段文本

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** court.command

**Stories:** 05.1-3

**Spec:** docs/mvp/05-decision-court-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 可提交一个具体选择作为案件
- [ ] 信息不足时最多提出三个关键补充问题
- [ ] 补充后仍无法定位选择时案件停在需要补充
- [ ] 需要补充的案件不能进入庭审
- [ ] 测试失败原因是缺失行为，而不是编译噪音
