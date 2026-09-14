# 139: [TEST] REST 命令进入游戏并返回运行标识

**What to build:** 写失败测试，证明：玩家通过 REST 发出命令。服务端创建一次运行并返回运行标识。HTTP 只测命令能进入游戏模块，不把路径名当成玩法规则。

**Blocked by:** 018 [IMPL] 提交案件；不足则最多三问后停在需要补充; 056 [IMPL] 开台校验；改写须确认；情绪不能写成人格; 102 [IMPL] 确认设定后才分配编号并开始第一次生成

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** gateway

**Stories:** 04.2, 04.28

**Spec:** docs/mvp/04-backend-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] REST 命令能进入对应游戏命令接口
- [ ] 触发生成的命令返回运行标识
- [ ] 拒绝的命令不改变游戏状态
- [ ] 测试失败原因是缺失行为，而不是编译噪音
