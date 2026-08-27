# 04 执念回音壁 (The Obsession Echo)

slug: `echo`

## 玩家体验

热血时写下绝对不想忘的承诺。平时前端完全隐形（导航里只有「立誓」入口，没有列表）。连续摆烂后，下次打开平台突然黑屏，空灵回声拉出当年原话。

## 誓言生命周期

```
WRITTEN ──► DORMANT（本域存原文，UI 不可见）
              │
              │ Cron 每 6h：看病理窗口 + 玩家自报进度
              ▼
            ARMED     （echo:pending:{playerId}=1）
              │
              │ 下次任意页面加载，壳层查 pending
              ▼
            ECHOED    全屏拷问，必须手打原句中的关键词才能关闭
              │
              ▼
            RESOLVED  玩家标记「仍有效 / 正式背弃」
```

## 触发规则（P0，可调，写死在配置）

在最近 5 个有病历的日子里，`SEVERE_SLACK ≥ 3` 且该誓言 `last_eval` 未回声过：武装。

无病历则永不触发——回音壁不靠猜，只靠病理事实。这是刻意设计，避免无输入惊吓。

## 前端

- 立誓页：全屏极简，写完即消失，给一句「它会自己回来」。
- 回音：共享壳层组件 `EchoInterrupt`，任何游戏路由都可被打断。
- 关闭条件：输入誓言里抽出的 2–4 个关键词（服务端校验），防止直接划掉。

## 数据

游戏表 `oath`（或本域 ES 存原文）。可分享誓言经 `projection` 交共享语料。同类近邻是加深项，走共享语料 kNN。

## 信号

emit `echo.oath.written` / `echo.triggered`
consume `pathology.report.issued`；读病历细节只调 `pathology.query`
