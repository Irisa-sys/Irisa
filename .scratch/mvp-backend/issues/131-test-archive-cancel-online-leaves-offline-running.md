# 131: [TEST] 取消当前在线生成不停离线任务

**What to build:** 写失败测试，证明：取消当前这次在线生成后，半个事件不会写入时间线，已经在跑的离线任务不受影响。打开长期暂停的宇宙时先看到停在哪个宇宙时间。

**Blocked by:** 130 [IMPL] 分享脱敏只读，撤销后失效

**Status:** ready-for-agent

**TDD:** TEST

**Seam:** archive.command / game.runtime

**Stories:** 07.54-56

**Spec:** docs/mvp/07-multiverse-archive-spec.md

**TDD 规则:**
- TEST 票只写失败测试，不写生产代码。
- IMPL 票只写让对应 TEST 变绿的最小实现。
- 最小 diff，不限一文件。
- 第一期使用内存适配器，不连接 MySQL、ES、Redis、RocketMQ、Apollo 或外部语言模型。
- 只断言命令之后可观察的结果。不断言提示词原文、表结构、SDK 调用、SQL、检索实现或配置中心客户端。
- 不把 HTTP 路径或事件名当成玩法规则。

**Acceptance criteria:**

- [ ] 取消当前在线生成后当前未完成事件不提交
- [ ] 取消当前在线生成不停已经在跑的离线任务
- [ ] 打开长期暂停的宇宙时先看到停在哪个宇宙时间
- [ ] 测试失败原因是缺失行为，而不是编译噪音
