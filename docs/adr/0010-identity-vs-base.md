# ADR 0010：身份子域与技术基座分离

## 状态

已接受

## 上下文

身份、画像是用户信息，不是「平台运行时」。

## 决策

1. **identity**：`auth` / `player` / `persona`。画像跟随玩家，只由事件改分。JWT 在本模块。**不进基座里程碑。**
2. **base**：ledger、event、agent、memory（index_job 管道）、messaging、cache、ids/clock/uow。不扫游戏、不订阅 game.* 事件、不持有游戏私有表、**不依赖 identity**。
3. 改分：identity 消费 `event_log`，base 只 append。
4. 网关依赖 identity（登录/me/persona）。游戏转发见 ADR-0011。

## 后果

- 用户数据在 identity；技术能力在 base
