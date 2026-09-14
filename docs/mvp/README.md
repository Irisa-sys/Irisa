# MVP 文档索引

`docs/mvp/` 是本项目后续产品设计、实现和验收的唯一参考范围。

## 当前文档

玩法与界面：

- [平行宇宙档案馆](./00-multiverse-archive.md)：主产品玩法、领域规则和 MVP 范围。
- [人生决策法庭](./01-decision-court.md)：法庭 MVP 玩法及其向档案馆提供的历史分叉材料。
- [个人偏见偏振器](./02-bias-polarizer.md)：偏振器 MVP 玩法及其向档案馆提供的判断材料。
- [UI 风格](./03-ui-style.md)：档案馆界面和交互视觉规范。

实现与验收：

- [后端总约束 Spec](./04-backend-spec.md)：Spring Modulith、LLM 网关、indexing、宇宙 RAG、运行与 SSE、授权、取消、单测替身。
- [人生决策法庭 Spec](./05-decision-court-spec.md)：法庭命令与可观察效果。
- [个人偏见偏振器 Spec](./06-bias-polarizer-spec.md)：偏振器命令与可观察效果。
- [平行宇宙档案馆 Spec](./07-multiverse-archive-spec.md)：档案馆命令与可观察效果。

## 文档优先级

- 本目录是后续产品设计、实现和验收的唯一参考。
- 已删除的旧玩法、旧合同、旧 ADR 和旧技术方案不再作为参考。
- 玩法以 `00` 到 `03` 为准；实现与验收以 `04` 到 `07` 为准。
- 如果本目录内文档之间出现冲突，产品边界遵循 `00-multiverse-archive.md`，技术约束遵循 `04-backend-spec.md`，并在相关专题文档中修正冲突。
