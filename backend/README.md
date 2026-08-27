# Irisa backend

仓库根不是 Maven。本目录 `pom.xml` 才是 Maven 工程（`irisa-backend`）。只有 `irisa-app`。

```
irisa-app
  gateway / identity / base.corpus / base.messaging
  game.api
  game.{slug}
    内核 + Store          命令：MySQL 提交 → 同步 es → emit
    es                    本域读模型（emit 前写完）
    query                 对外查询；外域只依赖 ::query
    projection            可分享 → CorpusDocument（异步；可选）
```

```bash
cp .env.example .env
mvn test
```
