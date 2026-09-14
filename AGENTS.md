# Irisa

平行宇宙档案馆：法庭、偏振器、档案馆。仓库根不是 Maven，也没有根 README。

## 唯一参考

- 产品 / 实现 / 验收只看 `docs/mvp/`。玩法 `00–03`，实现 `04–07`。
- 冲突：产品跟 `00-multiverse-archive.md`，技术跟 `04-backend-spec.md`。
- 不要用 `docs/games`、`docs/adr`、`docs/contracts`、`docs/platform`、旧合同、旧 ADR。工作区已删；git 里若还在，当作废弃。
- 后端模块边界以 `docs/mvp/04-backend-spec.md` 和各模块 `package-info.java` 的 `allowedDependencies` 为准，不以 `V1__base.sql` 为准（那是旧七游戏账本，尚未替换）。

## 目录

- `backend/`：Maven 父工程 `irisa-backend`，唯一模块 `irisa-app`。入口 `com.irisa.IrisaApplication`。
- `front/`：Vue 3 + Vite 原型，未接后端。
- `.scratch/mvp-backend/issues/`：146 张 TDD 票（奇数 TEST，偶数 IMPL）。索引见该目录上级 README。

## 命令

一律在 `backend/` 下跑（CI 同样 `working-directory: backend`）：

```bash
mvn test
mvn -pl irisa-app test -Dtest=com.irisa.ModulithSpec
```

- Java 21。测试是 Spock `*Spec.groovy`，放 `src/test/groovy`，Surefire include `*Spec` / `*Test`。
- 没有 `mvnw`。没有 lint / typecheck 脚本。
- 第一期单测必须用内存适配器，不连 MySQL / ES / Redis / RocketMQ / Apollo / 外部 LLM。`ModulithSpec` 不启 Spring，不需要 `.env`。
- 启动应用才需要 `cp .env.example .env`。`application.properties` 用环境变量占位，提交的配置禁止写真实连接串。

前端：`front/` 下 `npm run dev`（5173）。

## 模块（Spring Modulith，一个 JVM）

按功能竖切，不要按 controller / service / repository 拆包。对外只开 Named Interface。

```
identity                 auth, player
llm                      generation, embedding   # 不知角色 / SSE / 案件
game                     runtime
game.court               command, event          → runtime, llm.generation
game.polarizer           command, event          → 同上
indexing                 materials, search       → court.event, polarizer.event, llm.embedding
game.archive             command                 → runtime, llm, indexing
gateway                  REST + SSE              → auth, runtime, 三款 command
```

硬边界：

- `archive` 不依赖 `court` / `polarizer`。领域里只认决策资料、画像资料、本宇宙经历，不出现案件 / 命题 / 书记员 / 反方。
- `gateway` 不调 `llm`，不实现玩法。
- 游戏自己落权威数据，不依赖 `indexing`。`indexing` 不依赖游戏 `command`。
- 非 MVP 游戏模块（pathology / haunt / bank / echo / gravity）和 `base` 已删，不要加回来。
- 改完模块图后跑 `ModulithSpec`（`verify()` + 仅允许上述 8 个模块）。

## 实现约定

- 当前只有骨架（空包 + `package-info`）。业务从 `.scratch/mvp-backend/issues/` 按阻塞边做：TEST 只写失败测试，IMPL 只让对应 TEST 变绿。
- 现在能开：`001`、`011`、`013`、`015`。法庭 `017–054` 与偏振器 `055–084` 可并行（都等基座）。
- 主测试缝：各游戏 `command`。支撑缝：runtime、llm、本域 `event`、indexing materials/search。不断言提示词、表结构、SDK、SQL。
- 三类“事件”不可混：运行过程帧（SSE 展示）、游戏 `:: event`（indexing 只听这个）、宇宙时间线事件（archive 内部数据）。
- 取消 = 停当前这次流式生成；半段不落库；已 `persisted` 保留。不等于暂停宇宙 / 回退阶段 / 停离线任务。

## 前端

`front/src/App.vue` 是单文件原型，不是 API 客户端。UI 气质跟 `docs/mvp/03-ui-style.md`；命令效果以后端 spec 为准。
