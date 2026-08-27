# ADR 0011：游戏调用放在网关前门，不设 runtime 模块

## 状态

已接受（覆盖「独立 runtime 模块」；扫描 SPI 被 ADR-0013 去掉）

## 上下文

调用游戏 `handle` 不是基座能力，也不是工作流编排。单独做 runtime 模块容易长成编排器。拆微服务时，网关应能把「调游戏」换成 HTTP，而不改 Controller。

## 决策

1. **不设 runtime 模块。** 游戏调用放在网关。
2. 网关有一层 **游戏前门**（`gateway.game`）：Controller 只依赖该抽象（list / state / action / streamOpen）。不知道将来是进程内还是 HTTP。
3. **P0 适配**：同进程调 `game.{slug}` 模块的应用服务（形状见 `game.api`）。
4. **以后拆进程**：同一前门换成 HTTP 客户端。HTTP 合同不变。
5. **base** 不扫游戏、不转发 HTTP。**游戏** 步骤仍在本模块内。前门不写 admit/开庭剧本。

## 后果

- 顶层：`gateway` / `identity` / `base` / `game.*`
- 换传输只换前门适配，不换 HTTP 合同
