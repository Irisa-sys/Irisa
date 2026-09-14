# 130: [IMPL] 分享脱敏只读，撤销后失效

**What to build:** 用最小实现让 129 [TEST] 变绿：分享前预览脱敏结果。分享链接只读且可撤销。分享页固定说明这是虚构叙事。快照不含资料来源、宇宙检索内容、未脱敏原文或继续推演入口。撤销后原链接不可访问。

**Blocked by:** 129 [TEST] 分享脱敏只读，撤销后失效

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** archive.command

**Stories:** 07.51-53; 04.33

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 分享前可预览脱敏结果，姓名、公司、城市、收入、联系方式不原样公开
- [ ] 分享快照只读，不能继续推演或查看资料来源
- [ ] 分享页包含虚构叙事说明
- [ ] 撤销分享后不能再读到快照
- [ ] 对应 TEST 变绿，不顺便实现后续切片
