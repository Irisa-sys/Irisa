# Irisa backend

仓库根不是 Maven。本目录 `pom.xml` 才是 Maven 工程（`irisa-backend`）。只有 `irisa-app`。

Spring Modulith 模块以 `docs/mvp/04-backend-spec.md` 为准：

```
identity                 登录
llm                      全局模型网关 generation / embedding
game                     runtime
game.court               command / event
game.polarizer           command / event
indexing                 materials / search
game.archive             command；宇宙 RAG 在模块内
gateway                  REST + SSE
```

```bash
cp .env.example .env
mvn test
```
