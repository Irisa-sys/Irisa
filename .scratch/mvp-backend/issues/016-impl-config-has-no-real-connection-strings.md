# 016: [IMPL] 配置文件无真实连接串

**What to build:** 用最小实现让 015 [TEST] 变绿：仓库和默认配置文件不写真实中间件地址、账号、密钥或连接串。

**Blocked by:** 015 [TEST] 配置文件无真实连接串

**Status:** ready-for-agent

**TDD:** IMPL

**Seam:** config

**Stories:** 04.24

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 已提交的配置文件不含真实主机、账号、密钥或连接串
- [ ] 第一期测试不读取真实中间件地址也能运行
- [ ] 对应 TEST 变绿，不顺便实现后续切片
