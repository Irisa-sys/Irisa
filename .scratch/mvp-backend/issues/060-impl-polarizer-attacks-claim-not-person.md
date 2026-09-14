# 060: [IMPL] 反方只攻击命题、证据和推理，不编造事实

**What to build:** 用最小实现让 059 [TEST] 变绿：反方尖锐但只攻击命题、证据和推理，不羞辱或攻击身份，也不凭空添加玩家没有提供的事实。

**Blocked by:** 059 [TEST] 反方只攻击命题、证据和推理，不编造事实

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** polarizer.command

**Stories:** 06.10, 06.11

**Spec:** docs/mvp/06-bias-polarizer-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 提交的反方质疑若攻击身份或羞辱玩家则被拒绝
- [ ] 提交的反方质疑若添加玩家未提供的事实则被拒绝
- [ ] 对应 TEST 变绿，不顺便实现后续切片
