# 03 当代病理诊断书 (Cyber-Pathology Lab)

slug: `pathology`

## 玩家体验

极简输入框投喂一天摸鱼罪证。赛博精神科主任输出硬核病理术语 + 鬼畜药方。前端是冷白医院电子病历，带点阵打印与心电图。

## 输入

```
POST /actions/admit
  { date, confession, optionalMetrics[] }
```

`optionalMetrics` 可接浏览器插件的红点点击次数、前台时长（P1）。P0 纯文本即可。

## 输出结构（必须结构化，禁止纯散文）

```
diagnosisCode     e.g. DA_RECEPTOR_OVERLOAD
title             确诊为多巴胺受体低级过载丧尸化
findings[]        术语化条款
prescription[]    药方（可荒唐，但每条对应一条行为）
severity          MILD | MODERATE | SEVERE_SLACK
mindHealthDelta   负整数，有上下限
```

长文病历进 ES；以上字段进 ledger `PATHOLOGY`。

## 流程

```
admit → Agent(role=CYBER_CHIEF) → 校验 delta 在 [-20, 0]
      → ledger + ES
      → signal pathology.report.issued
      → Persona 更新 mind_health（下限 0）
```

连续 3 个自然日 `SEVERE_SLACK`：不在本游戏弹窗，只发信号，由回音壁决定要不要黑屏。

## 前端

A4 病历单、等宽点阵字体、撕纸音（用户可关）、顶部心电图用健康度驱动。打印/导出 PDF 为 P1。

## 数据

`g_patho_report(id, player_id, date UNIQUE, code, severity, delta, created_at)`
一天一份；重复提交视为修订，发新 signal 但 businessKey 带 revision。
