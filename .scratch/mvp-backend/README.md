# MVP 后端 TDD 票

来源：`docs/mvp/04-backend-spec.md` 到 `07-multiverse-archive-spec.md` 的全部 User Stories，相关故事已合并。

146 张票，73 对。奇数 TEST，偶数 IMPL。目录：`issues/`。

## 现在能开

- `001` 同一身份进入三款游戏
- `011` generation 只出分段文本
- `013` embedding 只出带模型标识的向量
- `015` 配置文件无真实连接串

## 依赖

```
基座 001-016
  ├─ 法庭 017-054        ∥ 偏振器 055-084
  └─ indexing 085-092
        └─ 档案馆 093-136
              └─ gateway 137-146
```

`ModulithSpec` 已覆盖模块边界，不再开票。
