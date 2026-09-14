# 140: [IMPL] REST 命令进入游戏并返回运行标识

**What to build:** 用最小实现让 139 [TEST] 变绿：玩家通过 REST 发出命令。服务端创建一次运行并返回运行标识。HTTP 只测命令能进入游戏模块，不把路径名当成玩法规则。

**Blocked by:** 139 [TEST] REST 命令进入游戏并返回运行标识

**Status:** ready-for-agent

**TDD:** IMPL

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
- [ ] 对应 TEST 变绿，不顺便实现后续切片
