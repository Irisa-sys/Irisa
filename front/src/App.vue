<script setup>
import {
  computed,
  nextTick,
  onBeforeUnmount,
  onMounted,
  ref,
  watch,
} from "vue";
import {
  Activity,
  ArrowLeft,
  ArrowRight,
  BookOpen,
  Brain,
  Building2,
  Check,
  ChevronRight,
  CircleHelp,
  Clock3,
  Code2,
  Command,
  FileText,
  Flame,
  Gauge,
  Github,
  Hexagon,
  Home,
  Landmark,
  LayoutGrid,
  LogOut,
  Maximize2,
  MessageCircle,
  Minimize2,
  MoreHorizontal,
  Orbit,
  Pause,
  PenLine,
  Play,
  Plus,
  Radar,
  RefreshCw,
  Scale,
  Send,
  Settings2,
  Shield,
  Share2,
  Sparkles,
  Target,
  Terminal,
  Trash2,
  TrendingDown,
  TrendingUp,
  Users,
  Upload,
  WalletCards,
  X,
  Zap,
} from "lucide-vue-next";
import {
  forceCollide,
  forceSimulation,
} from "d3";

const iconMap = {
  Home,
  FileText,
  Scale,
  Sparkles,
  Radar,
  Landmark,
  Orbit,
  Target,
};

const games = [
  {
    slug: "pathology",
    label: "病理诊断书",
    short: "PATHOLOGY",
    title: "当代病理诊断书",
    icon: FileText,
    accent: "mint",
    status: "ACTIVE",
    description: "把今天的摸鱼罪证，打印成一份不会替你开脱的病历。",
  },
  {
    slug: "court",
    label: "人生法庭",
    short: "COURT",
    title: "人生决策法庭",
    icon: Scale,
    accent: "amber",
    status: "ACTIVE",
    description: "五个版本的你同时出庭，最后由你签下判决。",
  },
  {
    slug: "echo",
    label: "执念回音",
    short: "ECHO",
    title: "执念回音壁",
    icon: Sparkles,
    accent: "lavender",
    status: "ACTIVE",
    description: "写下誓言，等它在你最想逃避的时候回来。",
  },
  {
    slug: "haunt",
    label: "项目闹鬼",
    short: "HAUNT",
    title: "项目闹鬼档案",
    icon: Radar,
    accent: "cyan",
    status: "COMING_SOON",
    description: "代码里看不见的债，变成雷达上不肯离开的幽灵。",
  },
  {
    slug: "bank",
    label: "技术债银行",
    short: "BANK",
    title: "技术债中央银行",
    icon: Landmark,
    accent: "orange",
    status: "COMING_SOON",
    description: "坏味道金融化，每一次延期都在复利。",
  },
  {
    slug: "gravity",
    label: "关系黑洞",
    short: "GRAVITY",
    title: "人际关系黑洞拉扯图",
    icon: Orbit,
    accent: "blue",
    status: "COMING_SOON",
    description: "把关系的拉扯画成一张只属于你的星图。",
  },
  {
    slug: "polarizer",
    label: "偏见偏振器",
    short: "POLARIZER",
    title: "个人偏见偏振器",
    icon: Target,
    accent: "red",
    status: "COMING_SOON",
    description: "把你深信不疑的结论，交给一个不提供情绪价值的对手。",
  },
];

const navItems = [
  { slug: "overview", label: "总览", icon: Home },
  ...games.map((game) => ({ ...game, label: game.label })),
];

const activeTab = ref("overview");
const mobileNavOpen = ref(false);
const toast = ref("");
const showHelp = ref(false);
const showProfile = ref(false);
const profileName = ref("fyj");
const lastSync = ref("刚刚");

const persona = ref({
  codeCredit: 820,
  mindHealth: 64,
  energyNet: 12.5,
  biasTags: ["JAVA_RELIGION"],
  updatedAt: "2026-08-20T04:00:00Z",
});
const activity = ref([
  {
    id: 1,
    kind: "pathology",
    title: "病理报告已归档",
    meta: "SEVERE_SLACK · 心智健康 -12",
    time: "今天 12:04",
  },
  {
    id: 2,
    kind: "court",
    title: "法庭等待你的签名",
    meta: "案号 CS-001 · 第 3 回合",
    time: "昨天 21:33",
  },
  {
    id: 3,
    kind: "echo",
    title: "誓言进入休眠",
    meta: "下次触发需要病理信号",
    time: "8 月 18 日",
  },
]);

const pathology = ref({
  confession: "",
  report: null,
  admitting: false,
  showForm: true,
});
const court = ref({
  title: "",
  narrative: "",
  extras: "",
  active: false,
  round: 0,
  signed: false,
  signature: "",
  feed: [],
  showForm: true,
});
const echo = ref({
  text: "",
  saved: false,
  pending: false,
  keywords: [],
  unlock: "",
});
const haunt = ref({ diff: "", ghosts: [], ingested: false });
const bank = ref({
  repo: "irisa",
  scanning: false,
  scanned: false,
  bankruptcy: true,
  dismissed: false,
});
const gravity = ref({
  text: "",
  source: "chat",
  importedFile: "",
  importedPreview: "",
  importing: false,
  ingested: false,
  bodies: [
    { alias: "自己", mass: 0, charge: 0, eccentricity: 0.12, color: "self" },
    {
      alias: "工作群",
      mass: 72,
      charge: -0.7,
      eccentricity: 0.32,
      color: "hole",
    },
    {
      alias: "老朋友",
      mass: 48,
      charge: 0.8,
      eccentricity: 0.22,
      color: "planet",
    },
    {
      alias: "家人",
      mass: 36,
      charge: 0.65,
      eccentricity: 0.18,
      color: "planet",
    },
  ],
});
const gravityCanvas = ref(null);
const gravityPaused = ref(false);
const gravityHover = ref(null);
const gravityHoverPinned = ref(false);
const gravityHoverPos = ref({ x: 0, y: 0, side: "right" });
const gravityTargets = ref([]);
const gravityTargetElements = new Map();
const gravityLegendHover = ref(null);
const gravityAnalysis = ref({
  quality: 72,
  drain: 29,
  interactions: 18,
  confidence: 78,
  summary: "等待一段互动描述，模型会把情感质量与消耗拆成可读指标。",
});
const gravityGraphSvg = ref(null);
const gravityGraphWrap = ref(null);
const gravityGraphNodes = ref([]);
const gravityGraphLinks = ref([]);
const gravityGraphFocus = ref(null);
const gravityGraphEvents = ref([
  { id: 1, type: "system", text: "力场已建立，等待新的互动信号" },
]);
let gravityGraphSimulation = null;
let gravityGraphResizeObserver = null;
let gravityGraphSize = { width: 900, height: 460 };
let gravityGraphHasMeasured = false;
const gravityGraphBusy = ref(false);
const gravityGraphFullscreen = ref(false);
const gravityGraphView = ref({ x: 0, y: 0, scale: 1, panning: false, pointerX: 0, pointerY: 0 });
let gravityGraphOrbitRaf = 0;
let gravityGraphOrbitStartedAt = 0;
// Seed the first frame so the graph is never an empty panel while the SVG initializes.
gravityGraphNodes.value = gravity.value.bodies.map((body, index) => ({
  ...body,
  id: body.alias,
  kind: gravityBodyKind(body),
  radius:
    body.color === "self" ? 46 : Math.max(25, Math.min(40, 17 + body.mass / 6)),
  x: gravityGraphStartPosition(body.alias, index).x,
  y: gravityGraphStartPosition(body.alias, index).y,
}));
const gravityScene = {
  raf: 0,
  retryTimer: 0,
  resizeObserver: null,
  startedAt: 0,
  stars: [],
  orbitOffset: 0,
  dragging: false,
  dragX: 0,
  dragY: 0,
  didDrag: false,
  hitBodies: [],
};
const polarizer = ref({
  proposition: "",
  rebut: "",
  active: false,
  round: 0,
  bias: 48,
  punches: [],
});

const currentGame = computed(() =>
  games.find((game) => game.slug === activeTab.value),
);
const gravityRelationNodes = computed(() =>
  gravityGraphNodes.value.filter((node) => node.kind !== "self"),
);
const healthTone = computed(() =>
  persona.value.mindHealth < 40
    ? "critical"
    : persona.value.mindHealth < 65
      ? "watch"
      : "good",
);
const healthLabel = computed(() =>
  persona.value.mindHealth < 40
    ? "需要休息"
    : persona.value.mindHealth < 65
      ? "注意消耗"
      : "状态稳定",
);
const syncedAt = computed(() => lastSync.value);

function navigate(slug) {
  activeTab.value = slug;
  mobileNavOpen.value = false;
  window.location.hash = slug;
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function notify(message) {
  toast.value = message;
  window.clearTimeout(notify.timer);
  notify.timer = window.setTimeout(() => {
    toast.value = "";
  }, 2800);
}

function addActivity(kind, title, meta) {
  activity.value.unshift({ id: Date.now(), kind, title, meta, time: "刚刚" });
  lastSync.value = "刚刚";
}

function admitPathology() {
  if (!pathology.value.confession.trim())
    return notify("请先写下一条今天的罪证");
  pathology.value.admitting = true;
  window.setTimeout(() => {
    const report = {
      reportId: `pr_${Date.now().toString().slice(-4)}`,
      date: new Date().toISOString().slice(0, 10),
      diagnosisCode: "DA_RECEPTOR_OVERLOAD",
      title: "确诊为多巴胺受体低级过载丧尸化",
      findings: [
        {
          code: "RED_DOT_COMPULSION",
          text: "红点强迫性扫描，间歇期小于 90 秒",
        },
        { code: "PSEUDO_LABOR", text: "以微调间距伪装生产行为" },
        {
          code: "DELAYED_START",
          text: "将真正的开始推迟到一个不存在的“准备好”",
        },
      ],
      prescription: [
        { drug: "强制锁屏 45m", forFinding: "RED_DOT_COMPULSION" },
        { drug: "禁止打开样式面板直至有测试失败", forFinding: "PSEUDO_LABOR" },
        {
          drug: "先交付一个粗糙版本，再允许继续优化",
          forFinding: "DELAYED_START",
        },
      ],
      severity: "SEVERE_SLACK",
      mindHealthDelta: -12,
      createdAt: new Date().toISOString(),
    };
    pathology.value.report = report;
    pathology.value.admitting = false;
    persona.value.mindHealth = Math.max(
      0,
      persona.value.mindHealth + report.mindHealthDelta,
    );
    addActivity(
      "pathology",
      "新的病理报告已归档",
      `SEVERE_SLACK · 心智健康 ${report.mindHealthDelta}`,
    );
    notify("报告已出具，心智健康度已更新");
  }, 650);
}

function openCourt() {
  if (!court.value.title.trim() || !court.value.narrative.trim())
    return notify("案由和叙事都需要填写");
  court.value.active = true;
  court.value.round = 1;
  court.value.signed = false;
  court.value.showForm = false;
  court.value.feed = [
    { type: "round", round: 1 },
    {
      type: "utterance",
      role: "过去的你",
      tone: "past",
      text: "你当初说要做能睡得着的系统。现在这份案由里，那个承诺在哪？",
    },
    {
      type: "utterance",
      role: "悲观主义者",
      tone: "pessimist",
      text: "如果你现在离开，三个月没有收入。你的跑道够长吗？",
    },
    {
      type: "utterance",
      role: "机会主义者",
      tone: "opportunist",
      text: "窗口就现在。再干一年，你只会更不敢。",
    },
    {
      type: "exhibit",
      text: `昨日病历：${pathology.value.report?.severity || "SEVERE_SLACK"}，心智健康度 ${persona.value.mindHealth}。`,
      source: "PATHOLOGY · pr_1",
    },
    {
      type: "digest",
      points: ["初心与跑道冲突", "账本只支持“正在消耗”这一条"],
    },
  ];
  addActivity(
    "court",
    "人生决策法庭已开庭",
    `案号 CS-${Date.now().toString().slice(-3)} · 第 1 回合`,
  );
  notify("法庭已开庭，五席正在入场");
}

function nextCourtRound() {
  if (!court.value.active || court.value.round >= 3) return;
  court.value.round += 1;
  const additions =
    court.value.round === 2
      ? [
          { type: "round", round: 2 },
          {
            type: "utterance",
            role: "过去的你",
            tone: "past",
            text: "你不是没钱，你是不敢用那笔钱买时间。",
          },
          {
            type: "exhibit",
            text: `代码信用分 ${persona.value.codeCredit}。无在途破产。`,
            source: "PERSONA · credit",
          },
          { type: "digest", points: ["钱不是主因"] },
        ]
      : [
          { type: "round", round: 3 },
          {
            type: "utterance",
            role: "悲观主义者",
            tone: "pessimist",
            text: "法庭记录三次提到“以后再说”。以后就是永不。",
          },
          { type: "digest", points: ["可结案"] },
        ];
  court.value.feed.push(...additions);
  if (court.value.round === 3) notify("最后一轮结束，等待你的签名");
}

function signCourt() {
  if (!court.value.signature) return notify("请在签名板上留下你的签名");
  court.value.signed = true;
  addActivity("court", "法庭判决已签署", "VERDICT · 事实进入长期账本");
  notify("判决已签署，这个选择会留在你的账本里");
}

function resetCourt() {
  court.value = {
    title: "",
    narrative: "",
    extras: "",
    active: false,
    round: 0,
    signed: false,
    signature: "",
    feed: [],
    showForm: true,
  };
}

function saveOath() {
  if (!echo.value.text.trim()) return notify("誓言不能为空");
  echo.value.saved = true;
  echo.value.keywords = echo.value.text
    .split(/\s+/)
    .filter((word) => word.length > 1)
    .slice(0, 3);
  if (!echo.value.keywords.length) echo.value.keywords = ["坚持", "兑现"];
  addActivity(
    "echo",
    "新的誓言已进入休眠",
    "ECHO.OATH.WRITTEN · 原文不会出现在列表里",
  );
  notify("誓言已写入，它会自己回来");
}

function triggerEcho() {
  echo.value.pending = true;
  notify("演示模式：回音已被唤醒");
}

function ingestDiff() {
  if (!haunt.value.diff.trim()) return notify("粘贴一段 diff，才能让幽灵现身");
  haunt.value.ghosts = [
    {
      path: "src/runtime/AgentRouter.java",
      type: "WRAITH",
      label: "怨灵",
      severity: 4,
      r: 32,
      theta: 42,
      detail: "TODO 在 6 次提交中被延期",
    },
    {
      path: "src/web/LegacyController.java",
      type: "ZOMBIE",
      label: "僵尸",
      severity: 3,
      r: 48,
      theta: 174,
      detail: "嵌套深度 5，异常处理互相吞咽",
    },
    {
      path: "docs/README.md",
      type: "POLTERGEIST",
      label: "灵异抓狂",
      severity: 2,
      r: 62,
      theta: 282,
      detail: "代码变了，邻近文档没有",
    },
  ];
  haunt.value.ingested = true;
  persona.value.codeCredit = Math.max(0, persona.value.codeCredit - 40);
  addActivity("haunt", "检测到 3 个技术幽灵", "CODE_CREDIT -40 · 手动 diff");
  notify("幽灵已归档，代码信用分下降 40");
}

function scanBank() {
  bank.value.scanning = true;
  window.setTimeout(() => {
    bank.value.scanning = false;
    bank.value.scanned = true;
    notify("债务扫描完成，K 线已更新");
  }, 700);
}

function clampGravityScore(value) {
  return Math.max(4, Math.min(96, Math.round(value)));
}

function analyzeGravityText(text) {
  const source = text.toLowerCase();
  const positiveSignals = (
    source.match(
      /支持|理解|开心|安心|感谢|帮助|成长|充电|舒服|倾听|尊重|鼓励|谢谢|哈哈/g,
    ) || []
  ).length;
  const drainSignals = (
    source.match(
      /焦虑|内耗|催|必须|亏欠|失望|冷暴力|加班|拒绝|控制|指责|生气|累|不想回|压力/g,
    ) || []
  ).length;
  const quality = clampGravityScore(
    58 +
      positiveSignals * 7 -
      drainSignals * 4 +
      Math.min(14, text.length / 80),
  );
  const drain = clampGravityScore(
    24 +
      drainSignals * 8 -
      positiveSignals * 3 +
      Math.min(18, text.length / 120),
  );
  const interactions = Math.max(
    5,
    Math.round(text.length / 11) + positiveSignals + drainSignals,
  );
  const confidence = clampGravityScore(
    54 + Math.min(34, text.length / 15) + (positiveSignals + drainSignals) * 2,
  );
  return {
    quality,
    drain,
    interactions,
    confidence,
    summary:
      drain > quality
        ? "剥离信号暂时占上风，优先观察那些让你反复解释、延迟回复或持续透支的互动。"
        : "补充信号更清晰，关系正在提供恢复感；继续记录具体发生过的动作，而不是给关系贴标签。",
  };
}

function gravityBodyMetrics(alias, analysis) {
  const presets = {
    工作群: {
      quality: Math.max(20, analysis.quality - 27),
      drain: Math.min(94, analysis.drain + 35),
      mass: 72,
      charge: -0.7,
      color: "hole",
    },
    老朋友: {
      quality: Math.min(94, analysis.quality + 13),
      drain: Math.max(8, analysis.drain - 18),
      mass: 48,
      charge: 0.8,
      color: "planet",
    },
    家人: {
      quality: Math.min(90, analysis.quality + 5),
      drain: Math.max(10, analysis.drain - 10),
      mass: 36,
      charge: 0.65,
      color: "planet",
    },
    新项目: {
      quality: Math.max(24, analysis.quality - 11),
      drain: Math.min(88, analysis.drain + 18),
      mass: 24,
      charge: -0.2,
      color: "hole",
    },
  };
  return presets[alias];
}

function buildGravityBodies(analysis) {
  const names = ["工作群", "老朋友", "家人", "新项目"];
  return [
    {
      alias: "自己",
      mass: 0,
      charge: 0,
      eccentricity: 0.12,
      color: "self",
      quality: analysis.quality,
      drain: 0,
    },
    ...names.map((alias) => ({
      alias,
      eccentricity: alias === "新项目" ? 0.44 : 0.2,
      ...gravityBodyMetrics(alias, analysis),
    })),
  ];
}

function ingestGravity() {
  if (!gravity.value.text.trim())
    return notify("写下一段关系观察，才能开始量化");
  const analysis = analyzeGravityText(gravity.value.text);
  gravityAnalysis.value = analysis;
  gravity.value.ingested = true;
  gravity.value.bodies = buildGravityBodies(analysis);
  persona.value.energyNet = Number(
    ((analysis.quality - analysis.drain) / 10).toFixed(1),
  );
  gravityGraphEvents.value.unshift({
    id: Date.now(),
    type: "analysis",
    text: `AI 解析 ${analysis.interactions} 条互动 · 置信度 ${analysis.confidence}%`,
  });
  addActivity(
    "gravity",
    "关系图谱已重算",
    `关系强度 ${analysis.quality} · 消耗 ${analysis.drain}`,
  );
  syncGravityGraph();
  notify(
    `星图已更新：情感质量 ${analysis.quality} / 消耗指数 ${analysis.drain}`,
  );
}

function handleChatImport(event) {
  const file = event.target.files?.[0];
  if (!file) return;
  gravity.value.importing = true;
  gravity.value.importedFile = file.name;
  gravity.value.source = "chat";
  const reader = new FileReader();
  reader.onload = () => {
    gravity.value.text = String(reader.result || "");
    gravity.value.importedPreview = gravity.value.text.slice(0, 180);
    gravity.value.importing = false;
    notify(`已导入 ${file.name}，可以继续编辑后再量化`);
  };
  reader.onerror = () => {
    gravity.value.importing = false;
    gravity.value.importedFile = "";
    notify("文件读取失败，请换一个文本文件");
  };
  reader.readAsText(file);
  event.target.value = "";
}

function clearChatImport() {
  gravity.value.importedFile = "";
  gravity.value.importedPreview = "";
  gravity.value.text = "";
}

function graphNodeRadius(node) {
  if (node.kind === "self") return 25;
  const influence = Math.abs(node.charge || 0) * (node.mass || 0);
  return Math.max(28, Math.min(58, 22 + Math.sqrt(influence) * 4.2));
}

function gravityGraphStartPosition(alias, index) {
  const cx = gravityGraphSize.width / 2;
  const cy = gravityGraphSize.height / 2;
  if (alias === "自己") return { x: cx, y: cy };
  const angle = [-2.3, -0.82, 0.46, 2.1, 2.86][(index - 1) % 5];
  const radiusX = Math.min(gravityGraphSize.width * 0.32, 420);
  const radiusY = Math.min(gravityGraphSize.height * 0.34, 230);
  const point = [
    cx + Math.cos(angle) * radiusX,
    cy + Math.sin(angle) * radiusY,
  ];
  return { x: point[0], y: point[1] };
}

function gravityGraphNode(kind, body, index, previous) {
  const origin = gravityGraphStartPosition(body.alias, index);
  const anchorX = previous?.anchorX ?? origin.x;
  const anchorY = previous?.anchorY ?? origin.y;
  const isSelf = kind === "self";
  return {
    ...body,
    id: body.alias,
    kind,
    influence: Math.abs(body.charge || 0) * (body.mass || 0),
    radius: graphNodeRadius({ ...body, kind }),
    x: previous?.x ?? origin.x,
    y: previous?.y ?? origin.y,
    anchorX,
    anchorY,
    fx: isSelf ? null : anchorX,
    fy: isSelf ? null : anchorY,
  };
}

function syncGravityGraph() {
  if (!gravityGraphSvg.value) return;
  const previous = new Map(
    gravityGraphNodes.value.map((node) => [node.id, node]),
  );
  const nodes = gravity.value.bodies.map((body, index) =>
    gravityGraphNode(
      gravityBodyKind(body),
      body,
      index,
      previous.get(body.alias),
    ),
  );
  const selfNode = nodes.find((node) => node.kind === "self");
  const links = nodes
    .filter((node) => node.kind !== "self" && selfNode)
    .map((node) => ({
      source: selfNode,
      target: node,
      strength: node.influence,
    }));
  gravityGraphNodes.value = nodes;
  gravityGraphLinks.value = links;
  gravityGraphSimulation?.stop();
  gravityGraphSimulation = forceSimulation(nodes)
    .velocityDecay(0.72)
    .alphaDecay(0.018)
    .force("personal-gravity", createPersonalGravityForce(nodes))
    .force("collide", forceCollide((node) => node.radius + 12).iterations(3))
    .on("tick", () => {
      for (const node of nodes) {
        node.x = Math.max(
          node.radius + 8,
          Math.min(gravityGraphSize.width - node.radius - 8, node.x),
        );
        node.y = Math.max(
          node.radius + 18,
          Math.min(gravityGraphSize.height - node.radius - 18, node.y),
        );
      }
      gravityGraphNodes.value = [...nodes];
    });
}

function createPersonalGravityForce(nodes) {
  return (alpha) => {
    const self = nodes.find((node) => node.kind === "self");
    if (!self || self.__dragging) return;
    for (const relation of nodes) {
      if (relation.kind === "self") continue;
      const dx = relation.x - self.x;
      const dy = relation.y - self.y;
      const distance = Math.max(42, Math.hypot(dx, dy));
      const pull = Math.min(
        1.05,
        (relation.influence * 150) / (distance * distance),
      );
      self.vx += (dx / distance) * pull * alpha;
      self.vy += (dy / distance) * pull * alpha;
    }
  };
}

function graphLinkId(link) {
  const source = typeof link.source === "string" ? link.source : link.source.id;
  const target = typeof link.target === "string" ? link.target : link.target.id;
  return `${source}-${target}`;
}

function graphLinkPoint(value) {
  return typeof value === "string"
    ? gravityGraphNodes.value.find((node) => node.id === value)
    : value;
}

function gravityGraphLinkPath(link) {
  const source = graphLinkPoint(link.source);
  const target = graphLinkPoint(link.target);
  if (!source || !target) return "";
  const dx = target.x - source.x;
  const dy = target.y - source.y;
  const distance = Math.hypot(dx, dy) || 1;
  const curve = (target.charge < 0 ? -1 : 1) * Math.min(55, distance * 0.23);
  const cx = (source.x + target.x) / 2 - (dy / distance) * curve;
  const cy = (source.y + target.y) / 2 + (dx / distance) * curve;
  return `M ${source.x} ${source.y} Q ${cx} ${cy} ${target.x} ${target.y}`;
}

function gravityGraphLinkStyle(link) {
  const target = graphLinkPoint(link.target);
  const influence = target?.influence || 0;
  return {
    "--link-weight": `${Math.min(2.4, 0.55 + influence / 34)}px`,
    "--link-alpha": Math.min(0.7, 0.18 + influence / 115),
  };
}

function gravityRelationLinkPath(relation) {
  const self = gravityGraphNodes.value.find((node) => node.kind === "self");
  return self ? gravityGraphLinkPath({ source: self, target: relation }) : "";
}

function gravityRelationLinkStyle(relation) {
  return gravityGraphLinkStyle({ target: relation });
}

function gravityRelationIsFocused(relation) {
  const focusedId = gravityGraphFocus.value?.id;
  return focusedId === relation.id || focusedId === "自己";
}

function graphLinkTouchesFocus(link) {
  const focusedId = gravityGraphFocus.value?.id;
  if (!focusedId) return false;
  const source = typeof link.source === "string" ? link.source : link.source.id;
  const target = typeof link.target === "string" ? link.target : link.target.id;
  return source === focusedId || target === focusedId;
}

function gravityInfluenceRadius(node) {
  if (node.kind === "self") return node.radius + 7;
  return node.radius + 18 + Math.min(46, node.influence * 0.65);
}

function startGravityGraph() {
  const svg = gravityGraphSvg.value;
  if (!svg) return;
  const previousSize = gravityGraphSize;
  const rect = svg.getBoundingClientRect();
  gravityGraphSize = {
    width: Math.max(640, Math.round(rect.width)),
    height: Math.max(360, Math.round(rect.height)),
  };
  resizeGravityGraphNodes(previousSize, gravityGraphSize);
  gravityGraphHasMeasured = true;
  svg.setAttribute(
    "viewBox",
    `0 0 ${gravityGraphSize.width} ${gravityGraphSize.height}`,
  );
  gravityGraphResizeObserver?.disconnect();
  if (typeof ResizeObserver !== "undefined") {
    gravityGraphResizeObserver = new ResizeObserver(() => {
      const previousSize = gravityGraphSize;
      const next = svg.getBoundingClientRect();
      gravityGraphSize = {
        width: Math.max(640, Math.round(next.width)),
        height: Math.max(360, Math.round(next.height)),
      };
      resizeGravityGraphNodes(previousSize, gravityGraphSize);
      svg.setAttribute(
        "viewBox",
        `0 0 ${gravityGraphSize.width} ${gravityGraphSize.height}`,
      );
      syncGravityGraph();
    });
    gravityGraphResizeObserver.observe(svg);
  }
  syncGravityGraph();
}

function resizeGravityGraphNodes(previousSize, nextSize) {
  if (!gravityGraphHasMeasured) {
    gravityGraphNodes.value = [];
    return;
  }
  const ratioX = nextSize.width / Math.max(previousSize.width, 1);
  const ratioY = nextSize.height / Math.max(previousSize.height, 1);
  for (const node of gravityGraphNodes.value) {
    node.x *= ratioX;
    node.y *= ratioY;
    if (node.anchorX != null) node.anchorX *= ratioX;
    if (node.anchorY != null) node.anchorY *= ratioY;
  }
}

function stopGravityGraph() {
  gravityGraphSimulation?.stop();
  gravityGraphSimulation = null;
  gravityGraphResizeObserver?.disconnect();
  gravityGraphResizeObserver = null;
}

function graphPointFromEvent(event) {
  const svg = gravityGraphSvg.value;
  if (!svg) return { x: 0, y: 0 };
  const rect = svg.getBoundingClientRect();
  const scaleX = gravityGraphSize.width / Math.max(rect.width, 1);
  const scaleY = gravityGraphSize.height / Math.max(rect.height, 1);
  return {
    x: (event.clientX - rect.left) * scaleX,
    y: (event.clientY - rect.top) * scaleY,
  };
}

function startGravityGraphPan(event) {
  if (event.button !== 0 || activeGravityGraphDragNode()) return;
  event.currentTarget.setPointerCapture?.(event.pointerId);
  gravityGraphView.value.panning = true;
  gravityGraphView.value.pointerX = event.clientX;
  gravityGraphView.value.pointerY = event.clientY;
}

function moveGravityGraphPan(event) {
  if (!gravityGraphView.value.panning) return;
  const svg = gravityGraphSvg.value;
  if (!svg) return;
  const rect = svg.getBoundingClientRect();
  const scaleX = gravityGraphSize.width / Math.max(rect.width, 1);
  const scaleY = gravityGraphSize.height / Math.max(rect.height, 1);
  gravityGraphView.value.x += (event.clientX - gravityGraphView.value.pointerX) * scaleX;
  gravityGraphView.value.y += (event.clientY - gravityGraphView.value.pointerY) * scaleY;
  gravityGraphView.value.pointerX = event.clientX;
  gravityGraphView.value.pointerY = event.clientY;
}

function endGravityGraphPan() {
  gravityGraphView.value.panning = false;
}

function zoomGravityGraph(event, targetScale) {
  const point = graphPointFromEvent(event);
  const previousScale = gravityGraphView.value.scale;
  const nextScale = Math.max(
    0.7,
    Math.min(2.75, targetScale ?? previousScale * (event.deltaY > 0 ? 0.9 : 1.11)),
  );
  const localX = (point.x - gravityGraphView.value.x) / previousScale;
  const localY = (point.y - gravityGraphView.value.y) / previousScale;
  gravityGraphView.value.x = point.x - localX * nextScale;
  gravityGraphView.value.y = point.y - localY * nextScale;
  gravityGraphView.value.scale = nextScale;
}

function resetGravityGraphView() {
  gravityGraphView.value.x = 0;
  gravityGraphView.value.y = 0;
  gravityGraphView.value.scale = 1;
}

function toggleGravityGraphZoom(event) {
  zoomGravityGraph(
    event,
    gravityGraphView.value.scale > 1.05 ? 1 : 1.65,
  );
}

async function toggleGravityGraphFullscreen() {
  const wrap = gravityGraphWrap.value;
  if (!wrap) return;
  try {
    if (document.fullscreenElement) await document.exitFullscreen();
    else if (wrap.requestFullscreen) await wrap.requestFullscreen();
    else gravityGraphFullscreen.value = !gravityGraphFullscreen.value;
  } catch {
    gravityGraphFullscreen.value = !gravityGraphFullscreen.value;
  }
  nextTick(startGravityGraph);
}

function syncGravityGraphFullscreen() {
  gravityGraphFullscreen.value = document.fullscreenElement === gravityGraphWrap.value;
  nextTick(startGravityGraph);
}

function focusGravityGraphNode(node) {
  gravityGraphFocus.value = node;
}

function dragGravityGraphStart(event, node) {
  if (!gravityGraphSimulation) return;
  event.currentTarget.setPointerCapture?.(event.pointerId);
  node.fx = node.x;
  node.fy = node.y;
  node.__dragging = true;
  gravityGraphSimulation.alphaTarget(0.25).restart();
  dragGravityGraphMove(event, node);
}

function dragGravityGraphMove(event, node) {
  if (!node || !node.__dragging) return;
  const point = graphPointFromEvent(event);
  node.fx = (point.x - gravityGraphView.value.x) / gravityGraphView.value.scale;
  node.fy = (point.y - gravityGraphView.value.y) / gravityGraphView.value.scale;
  gravityGraphNodes.value = [...gravityGraphNodes.value];
}

function dragGravityGraphEnd(_event, node) {
  if (!node || !node.__dragging) return;
  node.__dragging = false;
  if (node.kind === "self") {
    node.fx = null;
    node.fy = null;
  } else {
    node.anchorX = node.x;
    node.anchorY = node.y;
    node.fx = node.x;
    node.fy = node.y;
  }
  gravityGraphSimulation?.alphaTarget(0);
}

function activeGravityGraphDragNode() {
  return gravityGraphNodes.value.find((node) => node.__dragging);
}

function mergeGravityBodies(first, second) {
  const totalMass = first.mass + second.mass;
  const mergedCharge = Number(
    (
      (first.charge * first.mass + second.charge * second.mass) /
      totalMass
    ).toFixed(2),
  );
  const merged = {
    alias: `${first.alias} × ${second.alias}`,
    mass: Math.round(totalMass * 0.86),
    charge: mergedCharge,
    eccentricity: Math.min(0.5, (first.eccentricity + second.eccentricity) / 2),
    color: mergedCharge < 0 ? "hole" : "planet",
    quality: Math.round(
      ((first.quality || 50) * first.mass +
        (second.quality || 50) * second.mass) /
        totalMass,
    ),
    drain: Math.round(
      ((first.drain || 20) * first.mass + (second.drain || 20) * second.mass) /
        totalMass,
    ),
    mergedFrom: [first.alias, second.alias],
  };
  merged.kind = gravityBodyKind(merged);
  gravity.value.bodies = [
    gravity.value.bodies[0],
    merged,
    ...gravity.value.bodies
      .slice(1)
      .filter(
        (body) => body.alias !== first.alias && body.alias !== second.alias,
      ),
  ];
  gravityGraphEvents.value.unshift({
    id: Date.now(),
    type: "merge",
    text: `${first.alias} 与 ${second.alias} 碰撞合并为 ${merged.alias}`,
  });
  syncGravityGraph();
  gravityGraphFocus.value = gravityGraphNodes.value.find(
    (node) => node.id === merged.alias,
  );
  notify(`生态事件：${merged.alias} 已形成`);
}

function triggerGravityCollision() {
  if (gravityGraphBusy.value) return;
  const candidates = gravity.value.bodies.filter(
    (body) => body.color !== "self",
  );
  if (candidates.length < 2) return notify("当前没有足够的关系体可发生碰撞");
  const [first, second] = candidates.slice(-2);
  gravityGraphBusy.value = true;
  gravityGraphEvents.value.unshift({
    id: Date.now(),
    type: "collision",
    text: `${first.alias} 正在接近 ${second.alias} · 碰撞检测中`,
  });
  const firstNode = gravityGraphNodes.value.find(
    (node) => node.id === first.alias,
  );
  const secondNode = gravityGraphNodes.value.find(
    (node) => node.id === second.alias,
  );
  if (firstNode && secondNode) {
    const cx = gravityGraphSize.width / 2;
    const cy = gravityGraphSize.height / 2;
    firstNode.fx = cx - 22;
    firstNode.fy = cy;
    secondNode.fx = cx + 22;
    secondNode.fy = cy;
    gravityGraphSimulation?.alpha(0.8).restart();
  }
  window.setTimeout(() => {
    mergeGravityBodies(first, second);
    gravityGraphBusy.value = false;
  }, 900);
}

function shareGravityGraph() {
  const text = `关系黑洞 · 情感质量 ${gravityAnalysis.value.quality} · 消耗指数 ${gravityAnalysis.value.drain} · ${gravity.value.bodies.length - 1} 个关系体`;
  if (navigator.clipboard) navigator.clipboard.writeText(text).catch(() => {});
  notify("图谱摘要已复制，可分享给你的复盘伙伴");
}

function gravityBodyKind(body) {
  if (body?.color === "self") return "self";
  if (body?.color === "hole" || body?.charge < 0) return "black-hole";
  return "star";
}

function gravityEnergy(body) {
  return Math.max(
    1,
    Math.round(Math.abs((body?.mass || 0) * (body?.charge || 0))),
  );
}

function gravityTypeLabel(kind) {
  return kind === "self"
    ? "核心行星 · 你"
    : kind === "star"
      ? "恒星 · 补充关系"
      : "黑洞 · 剥离关系";
}

function gravityHoverTitle(item) {
  if (!item) return "";
  return item.kind === "self"
    ? "核心行星：你的位置由合力决定"
    : item.kind === "star"
      ? `${item.alias}：补充型关系`
      : `${item.alias}：剥离型关系`;
}

function gravityHoverDetail(item) {
  if (!item) return "";
  if (item.kind === "self") return "核心行星不产生引力，会向所有关系体的合力平衡位置偏移。";
  if (item.kind === "black-hole")
    return `剥离能量 -${gravityEnergy(item)} kJ · 越靠近视界，关系消耗越集中。`;
  return `补充能量 +${gravityEnergy(item)} kJ · 恒星越亮、半径越大，引力越强。`;
}

function gravityLegendInfo(kind) {
  const info = {
    star: {
      title: "恒星 / 你",
      text: "金色、带尖芒的光体。它是当前观察的能量起点，不代表关系好坏。",
    },
    planet: {
      title: "行星 / 补充能量",
      text: "蓝色球体和轨道。正 charge 表示互动后净能量增加，数值越大补充越强。",
    },
    "black-hole": {
      title: "黑洞 / 剥离能量",
      text: "紫红环绕黑体。负 charge 表示互动后净能量减少，绝对值越大剥离越强。",
    },
  };
  return info[kind];
}

function positionGravityTooltip(hit, width, height) {
  const panelWidth = width <= 520 ? 205 : 230;
  const panelHeight = 166;
  const gap = 14;
  const useLeft = hit.x + hit.radius + gap + panelWidth > width - 12;
  gravityHoverPos.value = {
    x: useLeft
      ? Math.max(12, hit.x - hit.radius - gap - panelWidth)
      : Math.min(width - panelWidth - 12, hit.x + hit.radius + gap),
    y: Math.min(
      Math.max(12, hit.y - panelHeight * 0.5),
      height - panelHeight - 12,
    ),
    side: useLeft ? "left" : "right",
  };
}

function refreshGravityTooltip(width, height) {
  if (!gravityHover.value) return;
  const activeBody = gravityScene.hitBodies.find(
    (item) =>
      item.alias === gravityHover.value.alias &&
      item.kind === gravityHover.value.kind,
  );
  if (!activeBody) return;
  gravityHover.value = activeBody;
  positionGravityTooltip(activeBody, width, height);
}

function updateGravityHover(event) {
  if (gravityScene.dragging) return;
  const canvas = gravityCanvas.value;
  if (!canvas) return;
  const rect = canvas.getBoundingClientRect();
  const x = event.clientX - rect.left;
  const y = event.clientY - rect.top;
  const hit = gravityScene.hitBodies.find(
    (item) =>
      Math.hypot(item.x - x, item.y - y) <= Math.max(item.radius + 18, 30),
  );
  if (!hit) {
    if (!gravityHoverPinned.value) gravityHover.value = null;
    return;
  }
  gravityHoverPinned.value = false;
  gravityHover.value = hit;
  positionGravityTooltip(hit, rect.width, rect.height);
  nextTick(() => positionGravityTooltip(hit, rect.width, rect.height));
}

function clearGravityHover() {
  if (!gravityScene.dragging && !gravityHoverPinned.value)
    gravityHover.value = null;
}

function currentGravityTarget(alias) {
  return gravityScene.hitBodies.find((body) => body.alias === alias);
}

function setGravityTargetElement(alias, element) {
  if (element) gravityTargetElements.set(alias, element);
  else gravityTargetElements.delete(alias);
}

function syncGravityTargets() {
  const currentAliases = gravityScene.hitBodies.map((body) => body.alias);
  const hasSameTargets =
    gravityTargets.value.length === currentAliases.length &&
    gravityTargets.value.every(
      (target, index) => target.alias === currentAliases[index],
    );

  if (!hasSameTargets) {
    // Node elements are created only when the relationship set changes, never per animation frame.
    gravityTargets.value = gravityScene.hitBodies.map((body) => ({
      alias: body.alias,
      kind: body.kind,
    }));
    nextTick(syncGravityTargets);
  }

  for (const body of gravityScene.hitBodies) {
    const element = gravityTargetElements.get(body.alias);
    if (!element) continue;
    const hitSize = Math.max(body.radius * 2.8, 76);
    element.style.left = `${body.x}px`;
    element.style.top = `${body.y}px`;
    element.style.width = `${hitSize}px`;
    element.style.height = `${hitSize}px`;
    element.dataset.kind = body.kind;
  }
}

function revealGravityTarget(alias) {
  const canvas = gravityCanvas.value;
  const target = currentGravityTarget(alias);
  if (!canvas || !target || gravityScene.dragging) return;
  gravityHoverPinned.value = false;
  gravityHover.value = target;
  const rect = canvas.getBoundingClientRect();
  positionGravityTooltip(target, rect.width, rect.height);
}

function pinGravityTarget(alias) {
  const canvas = gravityCanvas.value;
  const target = currentGravityTarget(alias);
  if (!canvas || !target) return;
  gravityHoverPinned.value = true;
  gravityHover.value = target;
  const rect = canvas.getBoundingClientRect();
  positionGravityTooltip(target, rect.width, rect.height);
}

function setGravityLegendHover(kind) {
  gravityLegendHover.value = kind;
}

function seedGravityStars(count = 180) {
  gravityScene.stars = Array.from({ length: count }, (_, index) => ({
    x: (index * 47.17) % 1,
    y: (index * 83.73) % 1,
    size: 0.35 + ((index * 13) % 10) / 10,
    alpha: 0.25 + ((index * 17) % 70) / 100,
    twinkle: 0.8 + ((index * 23) % 14) / 10,
  }));
}

function resizeGravityCanvas() {
  const canvas = gravityCanvas.value;
  if (!canvas) return;
  const rect = canvas.getBoundingClientRect();
  const ratio = window.devicePixelRatio || 1;
  canvas.width = Math.max(1, Math.floor(rect.width * ratio));
  canvas.height = Math.max(1, Math.floor(rect.height * ratio));
}

function drawGravityScene(timestamp) {
  const canvas = gravityCanvas.value;
  if (!canvas) return;
  const ratio = window.devicePixelRatio || 1;
  const width = canvas.width / ratio;
  const height = canvas.height / ratio;
  if (width < 24 || height < 24) {
    gravityScene.raf = requestAnimationFrame(drawGravityScene);
    return;
  }
  const ctx = canvas.getContext("2d");
  if (!ctx) return;
  ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
  const elapsed = (timestamp - gravityScene.startedAt) / 1000;
  const motion = gravityPaused.value ? 0 : elapsed;
  const orbitAngle = motion * 0.18 + gravityScene.orbitOffset;
  const cx = width * 0.5;
  const cy = height * 0.51;
  const scale = Math.min(width, height) / 520;
  gravityScene.hitBodies = [];

  const background = ctx.createRadialGradient(
    cx,
    cy,
    10,
    cx,
    cy,
    Math.max(width, height) * 0.72,
  );
  background.addColorStop(0, "#182f4e");
  background.addColorStop(0.42, "#10233d");
  background.addColorStop(1, "#081322");
  ctx.fillStyle = background;
  ctx.fillRect(0, 0, width, height);
  for (const star of gravityScene.stars) {
    const flicker =
      star.alpha + Math.sin(motion * star.twinkle + star.x * 20) * 0.12;
    ctx.globalAlpha = Math.max(0.08, flicker);
    ctx.fillStyle = star.size > 1 ? "#cce4ff" : "#87b5df";
    ctx.beginPath();
    ctx.arc(star.x * width, star.y * height, star.size, 0, Math.PI * 2);
    ctx.fill();
  }
  ctx.globalAlpha = 1;

  const halo = ctx.createRadialGradient(cx, cy, 8 * scale, cx, cy, 120 * scale);
  halo.addColorStop(0, "rgba(94, 181, 255, .18)");
  halo.addColorStop(0.45, "rgba(58, 125, 205, .1)");
  halo.addColorStop(1, "rgba(20, 64, 120, 0)");
  ctx.fillStyle = halo;
  ctx.beginPath();
  ctx.arc(cx, cy, 140 * scale, 0, Math.PI * 2);
  ctx.fill();

  // The central object is the user's energy core. A black hole only represents a draining relationship.
  const sunRadius = 31 * scale;
  const sunGlow = ctx.createRadialGradient(
    cx,
    cy,
    2 * scale,
    cx,
    cy,
    104 * scale,
  );
  sunGlow.addColorStop(0, "rgba(255,249,194,.95)");
  sunGlow.addColorStop(0.16, "rgba(255,203,75,.72)");
  sunGlow.addColorStop(0.42, "rgba(255,138,44,.28)");
  sunGlow.addColorStop(1, "rgba(255,122,34,0)");
  ctx.fillStyle = sunGlow;
  ctx.beginPath();
  ctx.arc(cx, cy, 104 * scale, 0, Math.PI * 2);
  ctx.fill();
  ctx.save();
  ctx.translate(cx, cy);
  ctx.rotate(orbitAngle * 0.28);
  ctx.shadowBlur = 28 * scale;
  ctx.shadowColor = "#ffb632";
  const sun = ctx.createRadialGradient(
    -sunRadius * 0.32,
    -sunRadius * 0.4,
    2,
    0,
    0,
    sunRadius,
  );
  sun.addColorStop(0, "#fff8bd");
  sun.addColorStop(0.38, "#ffd25f");
  sun.addColorStop(0.78, "#ff9a32");
  sun.addColorStop(1, "#e86526");
  ctx.fillStyle = sun;
  ctx.beginPath();
  ctx.arc(0, 0, sunRadius, 0, Math.PI * 2);
  ctx.fill();
  ctx.shadowBlur = 0;
  ctx.strokeStyle = "rgba(255,239,161,.86)";
  ctx.lineWidth = 1.4 * scale;
  for (let ray = 0; ray < 12; ray += 1) {
    const angle = (ray * Math.PI) / 6;
    ctx.beginPath();
    ctx.moveTo(
      Math.cos(angle) * sunRadius * 1.1,
      Math.sin(angle) * sunRadius * 1.1,
    );
    ctx.lineTo(
      Math.cos(angle) * sunRadius * 1.55,
      Math.sin(angle) * sunRadius * 1.55,
    );
    ctx.stroke();
  }
  ctx.restore();
  ctx.strokeStyle = "rgba(255,222,133,.74)";
  ctx.lineWidth = 1.3 * scale;
  ctx.beginPath();
  ctx.ellipse(
    cx,
    cy,
    62 * scale,
    19 * scale,
    orbitAngle * 0.28,
    0,
    Math.PI * 2,
  );
  ctx.stroke();
  ctx.fillStyle = "rgba(255,239,176,.98)";
  ctx.font = `600 ${Math.max(12, 14 * scale)}px "PingFang SC", "Noto Sans SC", sans-serif`;
  ctx.textAlign = "center";
  ctx.fillText("你 · 恒星核心", cx, cy + 70 * scale);
  gravityScene.hitBodies.push({
    alias: "自己",
    kind: "star",
    mass: 100,
    charge: 1,
    x: cx,
    y: cy,
    radius: 58 * scale,
  });

  const bodies = gravity.value.bodies.slice(1);
  bodies.forEach((body, index) => {
    const distance = (108 + index * 42) * scale;
    const bodyAngle =
      orbitAngle * (0.7 + index * 0.13) + (index * Math.PI) / 2.1 + 0.35;
    const orbitY = distance * (0.58 + index * 0.04);
    const kind = gravityBodyKind(body);
    ctx.save();
    ctx.translate(cx, cy);
    ctx.rotate(orbitAngle * 0.12);
    ctx.strokeStyle =
      kind === "black-hole"
        ? "rgba(219,104,164,.58)"
        : kind === "star"
          ? "rgba(255,218,117,.56)"
          : "rgba(96,190,237,.42)";
    ctx.lineWidth = kind === "black-hole" ? 1.6 * scale : 1.2 * scale;
    ctx.beginPath();
    ctx.ellipse(0, 0, distance, orbitY, 0, 0, Math.PI * 2);
    ctx.stroke();
    ctx.restore();
    const x = cx + Math.cos(bodyAngle) * distance;
    const y = cy + Math.sin(bodyAngle) * orbitY;
    const radius =
      Math.max(
        kind === "star" ? 10 : 8,
        body.mass / (kind === "black-hole" ? 7 : 6),
      ) * scale;
    if (kind === "star") {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(bodyAngle * 0.6);
      const glow = ctx.createRadialGradient(0, 0, 2, 0, 0, radius * 2.8);
      glow.addColorStop(0, "rgba(255,248,188,.98)");
      glow.addColorStop(0.28, "rgba(255,189,65,.9)");
      glow.addColorStop(1, "rgba(255,137,45,0)");
      ctx.fillStyle = glow;
      ctx.beginPath();
      ctx.arc(0, 0, radius * 2.8, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 20 * scale;
      ctx.shadowColor = "#ffc85a";
      ctx.fillStyle = "#ffd76f";
      ctx.beginPath();
      ctx.arc(0, 0, radius * 0.72, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;
      ctx.strokeStyle = "rgba(255,235,158,.9)";
      ctx.lineWidth = 1.3 * scale;
      for (let ray = 0; ray < 8; ray += 1) {
        const a = (ray * Math.PI) / 4;
        ctx.beginPath();
        ctx.moveTo(Math.cos(a) * radius * 0.9, Math.sin(a) * radius * 0.9);
        ctx.lineTo(Math.cos(a) * radius * 1.55, Math.sin(a) * radius * 1.55);
        ctx.stroke();
      }
      ctx.restore();
    } else if (kind === "black-hole") {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(bodyAngle * 0.45);
      ctx.scale(1, 0.42);
      const ring = ctx.createRadialGradient(
        0,
        0,
        radius * 0.58,
        0,
        0,
        radius * 2.2,
      );
      ring.addColorStop(0, "rgba(4,5,13,1)");
      ring.addColorStop(0.3, "rgba(9,5,22,.98)");
      ring.addColorStop(0.44, "rgba(238,87,157,.94)");
      ring.addColorStop(0.58, "rgba(255,177,88,.72)");
      ring.addColorStop(0.7, "rgba(109,82,215,.36)");
      ring.addColorStop(1, "rgba(66,37,123,0)");
      ctx.fillStyle = ring;
      ctx.beginPath();
      ctx.arc(0, 0, radius * 2.2, 0, Math.PI * 2);
      ctx.fill();
      ctx.strokeStyle = "rgba(255,126,185,.98)";
      ctx.lineWidth = 2 * scale;
      ctx.beginPath();
      ctx.ellipse(0, 0, radius * 1.85, radius * 0.8, 0, 0, Math.PI * 2);
      ctx.stroke();
      ctx.strokeStyle = "rgba(255,211,127,.86)";
      ctx.lineWidth = 0.9 * scale;
      ctx.beginPath();
      ctx.ellipse(0, 0, radius * 1.38, radius * 0.56, 0, 0, Math.PI * 2);
      ctx.stroke();
      ctx.restore();
      ctx.fillStyle = "#01030a";
      ctx.shadowBlur = 25 * scale;
      ctx.shadowColor = "#d85cae";
      ctx.beginPath();
      ctx.arc(x, y, radius * 0.72, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;
    } else {
      // Layered planet material: ocean base, lit continents, cloud bands and atmospheric rim.
      ctx.save();
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, Math.PI * 2);
      ctx.clip();
      const planet = ctx.createRadialGradient(
        x - radius * 0.42,
        y - radius * 0.48,
        radius * 0.05,
        x + radius * 0.18,
        y + radius * 0.18,
        radius * 1.45,
      );
      planet.addColorStop(0, "#d9fbff");
      planet.addColorStop(0.18, "#69d4ea");
      planet.addColorStop(0.48, "#237fb5");
      planet.addColorStop(0.8, "#123b73");
      planet.addColorStop(1, "#071b40");
      ctx.shadowBlur = 22 * scale;
      ctx.shadowColor = "#43bfe9";
      ctx.fillStyle = planet;
      ctx.fillRect(x - radius * 1.5, y - radius * 1.5, radius * 3, radius * 3);
      ctx.shadowBlur = 0;
      const seed = body.alias.length * 17 + index * 31;
      ctx.globalAlpha = 0.7;
      ctx.fillStyle = body.alias.length % 2 ? "#86d17e" : "#d5c66c";
      for (let land = 0; land < 4; land += 1) {
        const lx = x + Math.cos(seed + land * 2.1) * radius * 0.48;
        const ly = y + Math.sin(seed * 0.7 + land * 1.6) * radius * 0.52;
        ctx.beginPath();
        ctx.ellipse(
          lx,
          ly,
          radius * (0.2 + land * 0.025),
          radius * (0.1 + land * 0.02),
          land * 0.7,
          0,
          Math.PI * 2,
        );
        ctx.fill();
      }
      ctx.globalAlpha = 0.36;
      ctx.strokeStyle = "#f1fdff";
      ctx.lineWidth = Math.max(1, radius * 0.08);
      for (let cloud = -1; cloud <= 1; cloud += 1) {
        ctx.beginPath();
        ctx.ellipse(
          x + cloud * radius * 0.12,
          y + cloud * radius * 0.34,
          radius * 0.9,
          radius * 0.1,
          -0.18,
          0,
          Math.PI * 2,
        );
        ctx.stroke();
      }
      ctx.restore();
      ctx.globalAlpha = 1;
      ctx.strokeStyle = "rgba(164,242,255,.9)";
      ctx.lineWidth = Math.max(1, scale);
      ctx.beginPath();
      ctx.arc(x, y, radius * 1.04, -0.9, 2.15);
      ctx.stroke();
      if (body.mass > 55) {
        ctx.strokeStyle = "rgba(206,236,255,.7)";
        ctx.lineWidth = Math.max(1, scale * 0.7);
        ctx.beginPath();
        ctx.ellipse(x, y, radius * 1.55, radius * 0.38, -0.25, 0, Math.PI * 2);
        ctx.stroke();
      }
    }
    gravityScene.hitBodies.push({
      ...body,
      kind,
      x,
      y,
      radius: Math.max(radius * 1.55, 14 * scale),
    });
    ctx.fillStyle = "rgba(240,248,255,.96)";
    ctx.font = `600 ${Math.max(12, 13 * scale)}px "PingFang SC", "Noto Sans SC", sans-serif`;
    ctx.textAlign = "center";
    ctx.fillText(body.alias, x, y + radius + 20 * scale);
  });
  // Keep the same HTML targets alive while the Canvas animates underneath them.
  syncGravityTargets();
  refreshGravityTooltip(width, height);
  ctx.fillStyle = "rgba(221,238,255,.86)";
  ctx.font = '600 12px "Space Grotesk", "PingFang SC", sans-serif';
  ctx.textAlign = "left";
  ctx.fillText("LIVE ORBIT MODEL", 18, 24);
  ctx.textAlign = "right";
  ctx.fillText(gravityPaused.value ? "PAUSED" : "ROTATING", width - 18, 24);
  gravityScene.raf = requestAnimationFrame(drawGravityScene);
}

function startGravityScene() {
  const canvas = gravityCanvas.value;
  if (!canvas) {
    window.clearTimeout(gravityScene.retryTimer);
    gravityScene.retryTimer = window.setTimeout(startGravityScene, 90);
    return;
  }
  if (gravityScene.raf) cancelAnimationFrame(gravityScene.raf);
  gravityScene.startedAt = performance.now();
  seedGravityStars();
  resizeGravityCanvas();
  gravityScene.resizeObserver?.disconnect();
  canvas.removeEventListener("pointermove", updateGravityHover);
  canvas.removeEventListener("pointerleave", clearGravityHover);
  canvas.addEventListener("pointermove", updateGravityHover);
  canvas.addEventListener("pointerleave", clearGravityHover);
  if (typeof ResizeObserver !== "undefined") {
    gravityScene.resizeObserver = new ResizeObserver(resizeGravityCanvas);
    gravityScene.resizeObserver.observe(canvas);
  }
  gravityScene.raf = requestAnimationFrame(drawGravityScene);
}

function stopGravityScene() {
  gravityCanvas.value?.removeEventListener("pointermove", updateGravityHover);
  gravityCanvas.value?.removeEventListener("pointerleave", clearGravityHover);
  if (gravityScene.raf) cancelAnimationFrame(gravityScene.raf);
  gravityScene.raf = 0;
  window.clearTimeout(gravityScene.retryTimer);
  gravityScene.retryTimer = 0;
  gravityScene.resizeObserver?.disconnect();
  gravityScene.resizeObserver = null;
  gravityTargets.value = [];
  gravityTargetElements.clear();
}

function focusGravityBody(event) {
  const canvas = gravityCanvas.value;
  if (!canvas) return;
  const rect = canvas.getBoundingClientRect();
  const x = event.clientX - rect.left;
  const y = event.clientY - rect.top;
  const hit = gravityScene.hitBodies.find(
    (item) =>
      Math.hypot(item.x - x, item.y - y) <= Math.max(item.radius + 18, 30),
  );
  gravityHoverPinned.value = Boolean(hit);
  gravityHover.value = hit || null;
  if (hit) positionGravityTooltip(hit, rect.width, rect.height);
}
function startGravityDrag(event) {
  gravityScene.dragging = true;
  gravityScene.dragX = event.clientX;
  gravityScene.dragY = event.clientY;
  gravityScene.didDrag = false;
  event.currentTarget.setPointerCapture?.(event.pointerId);
}
function moveGravityDrag(event) {
  if (!gravityScene.dragging) return;
  const deltaX = event.clientX - gravityScene.dragX;
  const deltaY = event.clientY - gravityScene.dragY;
  if (Math.abs(deltaX) > 3 || Math.abs(deltaY) > 3) gravityScene.didDrag = true;
  gravityScene.orbitOffset += deltaX * 0.006;
  gravityScene.dragX = event.clientX;
  gravityScene.dragY = event.clientY;
}
function handleGravityPointerMove(event) {
  moveGravityDrag(event);
  updateGravityHover(event);
}
function endGravityDrag(event) {
  const wasDrag = gravityScene.didDrag;
  gravityScene.dragging = false;
  if (!wasDrag && event) focusGravityBody(event);
}
function toggleGravityAnimation() {
  gravityPaused.value = !gravityPaused.value;
}

function challengePolarizer() {
  if (!polarizer.value.proposition.trim())
    return notify("先提交一句你深信不疑的结论");
  polarizer.value.active = true;
  polarizer.value.round = 1;
  polarizer.value.bias = 64;
  polarizer.value.punches = [
    {
      side: "opponent",
      text: "你说“效率更重要”，那你愿意用什么事实证明它没有把代价转嫁给未来的自己？",
    },
  ];
  notify("偏振器已启动，反方第一拳来了");
}

function rebutPolarizer() {
  if (!polarizer.value.rebut.trim()) return notify("没有论据，就没有下一回合");
  polarizer.value.punches.push({ side: "player", text: polarizer.value.rebut });
  polarizer.value.punches.push({
    side: "opponent",
    text:
      polarizer.value.round >= 3
        ? "这次论据完整。你可以选择守住它，也可以承认它只是一个暂时有效的判断。"
        : "那我们再把边界缩小一点：什么情况下，这条结论会失效？",
  });
  polarizer.value.rebut = "";
  polarizer.value.round += 1;
  polarizer.value.bias = Math.min(92, polarizer.value.bias + 8);
}

function closePolarizer(outcome) {
  polarizer.value.active = false;
  addActivity(
    "polarizer",
    `偏振器对局：${outcome}`,
    "POLARIZER.ROUND.CLOSED · 标签已更新",
  );
  notify(`对局已结束：${outcome}`);
}

function logout() {
  showProfile.value = false;
  notify("已退出 mock 账号");
}
function iconFor(kind) {
  return iconMap[kind] || Activity;
}

onMounted(() => {
  document.addEventListener("fullscreenchange", syncGravityGraphFullscreen);
  const hash = window.location.hash.slice(1);
  if (hash && (hash === "overview" || games.some((game) => game.slug === hash)))
    activeTab.value = hash;
  if (activeTab.value === "gravity") {
    nextTick(() => {
      startGravityGraph();
    });
  }
});
watch(
  activeTab,
  (value) => {
    window.location.hash = value;
    if (value === "gravity")
      nextTick(() => {
        startGravityGraph();
      });
    else {
      stopGravityGraph();
    }
  },
  { flush: "post" },
);
onBeforeUnmount(() => {
  document.removeEventListener("fullscreenchange", syncGravityGraphFullscreen);
  stopGravityGraph();
});
</script>

<template>
  <div
    class="app-shell"
    :class="[`view-${activeTab}`, { immersive: activeTab !== 'overview' }]"
  >
    <aside class="sidebar" :class="{ open: mobileNavOpen }">
      <div class="brand-row">
        <button
          class="brand"
          aria-label="返回总览"
          @click="navigate('overview')"
        >
          <span class="brand-mark"><Hexagon :size="19" /></span
          ><span>IRISA</span>
        </button>
        <button
          class="icon-button sidebar-close"
          aria-label="关闭导航"
          @click="mobileNavOpen = false"
        >
          <X :size="18" />
        </button>
      </div>
      <div class="workspace-switcher">
        <span class="workspace-avatar">F</span
        ><span class="workspace-copy"
          ><b>个人工作台</b><small>本地 mock 环境</small></span
        ><ChevronRight :size="15" />
      </div>
      <div class="nav-section-label">工作台</div>
      <nav class="main-nav" aria-label="主导航">
        <button
          v-for="item in navItems"
          :key="item.slug"
          class="nav-item"
          :class="{ active: activeTab === item.slug }"
          @click="navigate(item.slug)"
        >
          <component :is="item.icon" :size="17" stroke-width="1.9" /><span>{{
            item.label
          }}</span>
          <span
            v-if="item.slug === 'echo' && echo.saved"
            class="nav-dot"
          ></span>
          <span v-if="item.status === 'COMING_SOON'" class="nav-soon"
            >soon</span
          >
        </button>
      </nav>
      <div class="sidebar-bottom">
        <button class="nav-item muted" @click="showHelp = true">
          <CircleHelp :size="17" /><span>使用说明</span>
        </button>
        <button class="nav-item muted">
          <Settings2 :size="17" /><span>偏好设置</span>
        </button>
        <div class="sidebar-footer">
          <span class="status-pulse"></span><span>Mock API 在线</span
          ><small>v0.1</small>
        </div>
      </div>
    </aside>

    <main class="main-area">
      <header class="topbar">
        <button
          class="icon-button mobile-menu"
          aria-label="打开导航"
          @click="mobileNavOpen = true"
        >
          <LayoutGrid :size="19" />
        </button>
        <div class="breadcrumbs">
          <button
            v-if="activeTab !== 'overview'"
            class="back-to-overview"
            @click="navigate('overview')"
            aria-label="返回总览"
          >
            <ArrowLeft :size="15" /></button
          ><span>{{
            activeTab === "overview" ? "个人工作台" : currentGame?.short
          }}</span
          ><ChevronRight :size="14" /><strong>{{
            activeTab === "overview" ? "总览" : currentGame?.label
          }}</strong>
        </div>
        <div class="topbar-actions">
          <div class="sync-state">
            <span class="status-pulse"></span>已同步 {{ syncedAt }}
          </div>
          <button
            class="icon-button"
            aria-label="使用说明"
            @click="showHelp = true"
          >
            <CircleHelp :size="18" />
          </button>
          <div class="profile-wrap">
            <button
              class="profile-button"
              aria-label="打开个人菜单"
              @click="showProfile = !showProfile"
            >
              <span class="profile-avatar">F</span
              ><span class="profile-name">{{ profileName }}</span
              ><ChevronRight :size="14" :class="{ rotate: showProfile }" />
            </button>
            <div v-if="showProfile" class="profile-menu">
              <div class="profile-menu-head">
                <span class="profile-avatar large">F</span
                ><span
                  ><b>{{ profileName }}</b
                  ><small>Mock Player #01</small></span
                >
              </div>
              <button @click="logout"><LogOut :size="15" />退出当前会话</button>
            </div>
          </div>
        </div>
      </header>

      <div class="content-wrap">
        <Transition name="page-turn" mode="out-in">
          <div :key="activeTab" class="page-stage">
            <section v-if="activeTab === 'overview'" class="page overview-page">
              <div class="page-heading hero-heading">
                <div>
                  <p class="eyebrow">PERSONAL OPERATING SYSTEM · 08.21</p>
                  <h1>把今天，交给事实。</h1>
                  <p class="heading-copy">
                    Irisa 把模糊的自我感受，拆成可以面对的证据、选择和下一步。
                  </p>
                </div>
                <div class="heading-actions">
                  <button
                    class="button button-secondary"
                    @click="showHelp = true"
                  >
                    <CircleHelp :size="16" />怎么开始</button
                  ><button
                    class="button button-primary"
                    @click="navigate('pathology')"
                  >
                    <Plus :size="17" />记录今天
                  </button>
                </div>
              </div>
              <div class="persona-strip">
                <div class="persona-intro">
                  <div class="avatar-ring"><span>F</span><i></i></div>
                  <div>
                    <span class="section-kicker">你的当前画像</span>
                    <h2>今天也在观察自己</h2>
                    <p>最后更新于 {{ syncedAt }}</p>
                  </div>
                </div>
                <div class="persona-metrics">
                  <div class="metric">
                    <span class="metric-label">心智健康</span
                    ><strong
                      >{{ persona.mindHealth }}<small>/100</small></strong
                    >
                    <div class="metric-bar">
                      <i
                        :style="{ width: `${persona.mindHealth}%` }"
                        :class="healthTone"
                      ></i>
                    </div>
                    <em :class="healthTone"
                      ><Activity :size="13" />{{ healthLabel }}</em
                    >
                  </div>
                  <div class="metric">
                    <span class="metric-label">代码信用</span
                    ><strong
                      >{{ persona.codeCredit }}<small>/1000</small></strong
                    >
                    <div class="metric-bar">
                      <i
                        class="credit"
                        :style="{ width: `${persona.codeCredit / 10}%` }"
                      ></i>
                    </div>
                    <em><Code2 :size="13" />保持交付</em>
                  </div>
                  <div class="metric">
                    <span class="metric-label">能量净值</span
                    ><strong>{{ persona.energyNet }}<small>kJ</small></strong
                    ><em class="positive"
                      ><TrendingUp :size="13" />较上周 +6.2</em
                    >
                  </div>
                </div>
              </div>
              <div class="lower-grid">
                <section class="panel activity-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">EVENT LOG</span>
                      <h2>最近发生</h2>
                    </div>
                    <button
                      class="text-button"
                      @click="notify('完整账本将在后续版本开放')"
                    >
                      查看全部 <ArrowRight :size="14" />
                    </button>
                  </div>
                  <div class="activity-list">
                    <div
                      v-for="item in activity.slice(0, 4)"
                      :key="item.id"
                      class="activity-row"
                    >
                      <span class="activity-icon" :class="item.kind"
                        ><component :is="iconFor(item.kind)" :size="15" /></span
                      ><span class="activity-main"
                        ><b>{{ item.title }}</b
                        ><small>{{ item.meta }}</small></span
                      ><time>{{ item.time }}</time>
                    </div>
                  </div>
                </section>
                <section class="panel next-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">NEXT MOVE</span>
                      <h2>下一步建议</h2>
                    </div>
                    <Sparkles :size="17" class="panel-heading-icon" />
                  </div>
                  <div class="next-content">
                    <div class="next-marker">01</div>
                    <div>
                      <span class="recommendation-label"
                        >基于最近的病理信号</span
                      >
                      <h3>把一个真正重要的选择，交给法庭。</h3>
                      <p>
                        你的健康度已经连续两次下降。与其继续在脑中排练，不如给它一个案号。
                      </p>
                      <button
                        class="button button-dark"
                        @click="navigate('court')"
                      >
                        开一宗新案 <ArrowRight :size="15" />
                      </button>
                    </div>
                  </div>
                </section>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'pathology'"
              class="page game-page pathology-page"
            >
              <div class="game-hero">
                <div>
                  <span class="game-label mint"
                    ><FileText :size="15" /> CYBER-PATHOLOGY LAB</span
                  >
                  <h1>当代病理诊断书</h1>
                  <p>把今天的摸鱼罪证，交给一位不会替你开脱的主任。</p>
                </div>
                <div class="game-hero-stamp">
                  <span>CASE FILE</span
                  ><b>{{
                    pathology.report
                      ? pathology.report.reportId.toUpperCase()
                      : "NEW / 001"
                  }}</b
                  ><small>REV. 01</small>
                </div>
              </div>
              <div
                v-if="!pathology.report"
                class="split-layout pathology-input-layout"
              >
                <div class="panel input-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">ADMIT EVIDENCE</span>
                      <h2>投喂一日罪证</h2>
                    </div>
                    <span class="date-chip"
                      ><Clock3 :size="13" />{{
                        new Date().toLocaleDateString("zh-CN", {
                          month: "short",
                          day: "numeric",
                        })
                      }}</span
                    >
                  </div>
                  <p class="panel-lead">
                    不需要写得漂亮。越具体，病理越准确。今天你把时间花在了哪里？
                  </p>
                  <textarea
                    v-model="pathology.confession"
                    class="large-textarea"
                    placeholder="例如：打开编辑器准备写接口，先花了 40 分钟换主题；午饭后刷了 17 次红点；把真正的任务挪到了明天……"
                    rows="9"
                  ></textarea>
                  <div class="input-meta">
                    <span
                      ><PenLine :size="14" />{{ pathology.confession.length }} /
                      1000</span
                    ><span>仅用于本次诊断 · 不会进入公开记录</span>
                  </div>
                  <button
                    class="button button-primary button-wide"
                    :disabled="pathology.admitting"
                    @click="admitPathology"
                  >
                    <RefreshCw
                      v-if="pathology.admitting"
                      :size="16"
                      class="spin"
                    /><Send v-else :size="16" />{{
                      pathology.admitting
                        ? "主任正在阅片…"
                        : "提交病历，开始诊断"
                    }}
                  </button>
                </div>
                <div class="side-note">
                  <div class="note-icon"><Shield :size="18" /></div>
                  <h3>这里没有标准答案</h3>
                  <p>
                    病理不是给你贴标签，而是把你已经知道、但不想承认的行为，整理成一份可以处理的清单。
                  </p>
                  <div class="note-rule"></div>
                  <span>输入是临时材料<br />报告会进入长期账本</span>
                </div>
              </div>
              <div v-else class="report-sheet">
                <div class="report-header">
                  <div>
                    <span class="report-kicker"
                      >IRISA CLINICAL RECORD ·
                      {{ pathology.report.reportId }}</span
                    >
                    <h2>{{ pathology.report.title }}</h2>
                  </div>
                  <span class="severity-badge severe"
                    ><Activity :size="13" />{{
                      pathology.report.severity
                    }}</span
                  >
                </div>
                <div class="report-meta">
                  <span
                    >诊断日期 <b>{{ pathology.report.date }}</b></span
                  ><span
                    >诊断编码 <b>{{ pathology.report.diagnosisCode }}</b></span
                  ><span
                    >健康度变化
                    <b class="negative">{{
                      pathology.report.mindHealthDelta
                    }}</b></span
                  >
                </div>
                <div class="report-columns">
                  <div>
                    <h3><span>01</span>临床发现</h3>
                    <div
                      v-for="finding in pathology.report.findings"
                      :key="finding.code"
                      class="finding-row"
                    >
                      <code>{{ finding.code }}</code>
                      <p>{{ finding.text }}</p>
                    </div>
                  </div>
                  <div>
                    <h3><span>02</span>处方建议</h3>
                    <div
                      v-for="prescription in pathology.report.prescription"
                      :key="prescription.drug"
                      class="prescription-row"
                    >
                      <span class="prescription-check"
                        ><Check :size="13"
                      /></span>
                      <p>{{ prescription.drug }}</p>
                    </div>
                  </div>
                </div>
                <div class="report-footer">
                  <span
                    ><BookOpen
                      :size="15"
                    />此报告已写入长期账本，可在法庭中作为证据引用。</span
                  ><button
                    class="button button-secondary"
                    @click="
                      pathology.report = null;
                      pathology.confession = '';
                    "
                  >
                    <Plus :size="15" />提交另一条病历
                  </button>
                </div>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'court'"
              class="page game-page court-page"
            >
              <div class="game-hero court-hero">
                <div>
                  <span class="game-label amber"
                    ><Scale :size="15" /> THE DECISION COURT</span
                  >
                  <h1>人生决策法庭</h1>
                  <p>五个版本的你同时出庭。最后，由你签下判决。</p>
                </div>
                <div class="court-docket">
                  <span>DOCKET NO.</span
                  ><b>{{ court.active ? "CS-001 / OPEN" : "CS-001 / READY" }}</b
                  ><small>SESSION 01</small>
                </div>
              </div>
              <div v-if="court.showForm" class="split-layout court-open-layout">
                <div class="panel input-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">OPEN A CASE</span>
                      <h2>把选择写成案由</h2>
                    </div>
                    <span class="round-pill">5 席 · 3 回合</span>
                  </div>
                  <label
                    >案由标题<input
                      v-model="court.title"
                      placeholder="例如：要不要在今年离开现在的工作？" /></label
                  ><label
                    >案情叙事<textarea
                      v-model="court.narrative"
                      rows="6"
                      placeholder="把背景、你知道的事实和真正担心的事写下来。法庭只读这一份案卷。"
                    ></textarea></label
                  ><label
                    >补充材料 <span class="optional">可选</span
                    ><input
                      v-model="court.extras"
                      placeholder="例如：存款 20w · runway 6 个月"
                  /></label>
                  <div class="court-note">
                    <Shield :size="16" /><span
                      >审计员只会引用已归档的病理、画像和债务事实。没有数据时，法庭会说“卷宗空白”。</span
                    >
                  </div>
                  <button
                    class="button button-primary button-wide"
                    @click="openCourt"
                  >
                    <Play :size="16" />开庭
                  </button>
                </div>
                <div class="court-roster">
                  <div class="roster-header">
                    <span class="section-kicker">THE BENCH</span>
                    <h2>五席已就位</h2>
                    <p>每个席位只负责一种声音，书记员会在每回合后整理争议。</p>
                  </div>
                  <div class="roster-list">
                    <div
                      v-for="(seat, index) in [
                        ['过去的你', '拷问初心', 'past'],
                        ['悲观主义者', '寻找最坏结果', 'pessimist'],
                        ['机会主义者', '放大窗口', 'opportunist'],
                        ['审计员', '宣读真实账本', 'auditor'],
                        ['书记员', '整理争议点', 'clerk'],
                      ]"
                      :key="seat[0]"
                      class="roster-row"
                    >
                      <span class="seat-number">0{{ index + 1 }}</span
                      ><span class="seat-avatar" :class="seat[2]">{{
                        seat[0].slice(0, 1)
                      }}</span
                      ><span
                        ><b>{{ seat[0] }}</b
                        ><small>{{ seat[1] }}</small></span
                      ><span class="seat-ready"><i></i>READY</span>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="court-session">
                <div class="session-top">
                  <div>
                    <span class="section-kicker">CASE CS-001 · IN SESSION</span>
                    <h2>{{ court.title }}</h2>
                  </div>
                  <div class="round-progress">
                    <span>回合</span><b>{{ court.round }}<small>/3</small></b>
                    <div>
                      <i
                        v-for="n in 3"
                        :key="n"
                        :class="{ done: n <= court.round }"
                      ></i>
                    </div>
                  </div>
                </div>
                <div class="session-grid">
                  <div class="court-feed">
                    <div
                      v-for="(item, index) in court.feed"
                      :key="index"
                      :class="['feed-item', item.type]"
                    >
                      <template v-if="item.type === 'round'"
                        ><div class="round-divider">
                          <span>ROUND {{ item.round }}</span
                          ><i></i></div></template
                      ><template v-else-if="item.type === 'utterance'"
                        ><div class="utterance-head">
                          <span class="seat-avatar small" :class="item.tone">{{
                            item.role.slice(0, 1)
                          }}</span
                          ><b>{{ item.role }}</b
                          ><span class="live-dot"></span>
                        </div>
                        <p>{{ item.text }}</p></template
                      ><template v-else-if="item.type === 'exhibit'"
                        ><div class="exhibit-card">
                          <div class="exhibit-top">
                            <span><FileText :size="14" />呈堂证供</span
                            ><code>{{ item.source }}</code>
                          </div>
                          <p>{{ item.text }}</p>
                          <span class="exhibit-foot"
                            >FACT TOOL · 可追溯来源</span
                          >
                        </div></template
                      ><template v-else
                        ><div class="digest-card">
                          <span><BookOpen :size="14" />书记员摘要</span>
                          <ul>
                            <li v-for="point in item.points" :key="point">
                              {{ point }}
                            </li>
                          </ul>
                        </div></template
                      >
                    </div>
                    <div v-if="court.round < 3" class="session-action">
                      <span>下一回合将继续质询</span
                      ><button
                        class="button button-secondary"
                        @click="nextCourtRound"
                      >
                        继续开庭 <ArrowRight :size="15" />
                      </button>
                    </div>
                  </div>
                  <aside class="signature-panel">
                    <div class="panel-heading">
                      <div>
                        <span class="section-kicker">FINAL ACT</span>
                        <h3>
                          {{ court.signed ? "判决已签署" : "法官签名板" }}
                        </h3>
                      </div>
                      <PenLine :size="17" />
                    </div>
                    <p v-if="!court.signed">
                      三回合结束后，用指针或触控留下你的签名。签名即代表你愿意承担这个选择。
                    </p>
                    <div
                      class="signature-pad"
                      :class="{ signed: court.signed }"
                    >
                      <span v-if="!court.signature && !court.signed"
                        >在这里签名</span
                      ><span v-else class="signature-script">{{
                        court.signature || "fyj"
                      }}</span>
                    </div>
                    <div v-if="!court.signed" class="signature-tools">
                      <button class="text-button" @click="court.signature = ''">
                        <Trash2 :size="13" />清除</button
                      ><button
                        class="button button-dark"
                        :disabled="court.round < 3"
                        @click="
                          court.signature = 'fyj';
                          signCourt();
                        "
                      >
                        <PenLine :size="14" />签署判决
                      </button>
                    </div>
                    <div v-else class="signed-state">
                      <Check :size="17" />VERDICT SIGNED
                    </div>
                    <button
                      v-if="court.signed"
                      class="text-button restart-case"
                      @click="resetCourt"
                    >
                      <Plus :size="14" />开启下一宗案
                    </button>
                  </aside>
                </div>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'echo'"
              class="page game-page echo-page"
            >
              <div class="echo-layout">
                <div class="echo-copy">
                  <span class="game-label lavender"
                    ><Sparkles :size="15" /> THE OBSESSION ECHO</span
                  >
                  <h1>执念回音壁</h1>
                  <p>
                    写下你在巅峰时刻相信的事。它会在你最想逃避的时候，回来找你。
                  </p>
                  <div class="echo-rule"></div>
                  <span class="echo-footnote"
                    >休眠状态 · 列表不会显示誓言原文</span
                  >
                </div>
                <div class="echo-card">
                  <div class="echo-card-top">
                    <span class="section-kicker">WRITE AN OATH</span
                    ><span class="oath-state" :class="{ active: echo.saved }"
                      ><i></i>{{ echo.saved ? "DORMANT" : "READY" }}</span
                    >
                  </div>
                  <textarea
                    v-model="echo.text"
                    :disabled="echo.saved"
                    placeholder="今年，我一定要……"
                    rows="5"
                  ></textarea>
                  <div v-if="!echo.saved" class="echo-card-foot">
                    <span>写完即消失</span
                    ><button class="button button-light" @click="saveOath">
                      <Sparkles :size="15" />立下誓言
                    </button>
                  </div>
                  <div v-else class="oath-saved">
                    <Check :size="17" />
                    <div>
                      <b>誓言已经休眠</b
                      ><span
                        >它不会出现在你的列表里，但还在等待一次真实的病理信号。</span
                      >
                    </div>
                    <button
                      class="icon-button dark"
                      aria-label="演示触发回音"
                      title="演示触发回音"
                      @click="triggerEcho"
                    >
                      <Play :size="15" />
                    </button>
                  </div>
                </div>
              </div>
              <div v-if="echo.pending" class="echo-interrupt">
                <div class="interrupt-noise"></div>
                <div class="interrupt-content">
                  <span class="interrupt-label">THE ECHO IS AWAKE</span>
                  <h2>你还记得你说过什么吗？</h2>
                  <p>{{ echo.text || "今年，我一定会兑现那个承诺。" }}</p>
                  <input
                    v-model="echo.unlock"
                    placeholder="输入誓言中的关键词"
                  /><button
                    class="button button-light"
                    @click="
                      echo.unlock
                        ? ((echo.pending = false),
                          notify('回音已释放，誓言仍然有效'))
                        : notify('请先输入一个关键词')
                    "
                  >
                    <Check :size="15" />释放回音</button
                  ><button
                    class="text-button light-text"
                    @click="echo.pending = false"
                  >
                    暂时离开
                  </button>
                </div>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'haunt'"
              class="page game-page haunt-page"
            >
              <div class="game-hero dark-hero">
                <div>
                  <span class="game-label cyan"
                    ><Radar :size="15" /> PROJECT HAUNTING FILES</span
                  >
                  <h1>项目闹鬼档案</h1>
                  <p>代码里看不见的债，会在雷达上留下光。</p>
                </div>
                <div class="dark-counter">
                  <span>GHOSTS DETECTED</span
                  ><b>{{ haunt.ghosts.length.toString().padStart(2, "0") }}</b>
                </div>
              </div>
              <div class="haunt-layout">
                <div class="radar-panel">
                  <div class="radar-grid">
                    <div class="radar-sweep"></div>
                    <div class="radar-center"><Hexagon :size="18" /></div>
                    <span
                      v-for="ghost in haunt.ghosts"
                      :key="ghost.path"
                      class="ghost-dot"
                      :class="ghost.type.toLowerCase()"
                      :style="{
                        left: `${50 + (Math.cos((ghost.theta * Math.PI) / 180) * ghost.r) / 1.7}%`,
                        top: `${50 + (Math.sin((ghost.theta * Math.PI) / 180) * ghost.r) / 1.7}%`,
                      }"
                    ></span
                    ><span class="radar-label top">LIVE REPOSITORY SCAN</span
                    ><span class="radar-label bottom">IRISA / MAIN</span>
                  </div>
                  <div class="ghost-legend">
                    <span><i class="wraith"></i>怨灵</span
                    ><span><i class="zombie"></i>僵尸</span
                    ><span><i class="poltergeist"></i>灵异抓狂</span>
                  </div>
                </div>
                <div class="panel haunt-input">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">MANUAL INGEST</span>
                      <h2>粘贴一段 diff</h2>
                    </div>
                    <span class="coming-badge">P0 手动通道</span>
                  </div>
                  <p class="panel-lead">
                    没有 GitHub 也能玩。规则分析会把
                    TODO、嵌套和文档漂移变成幽灵。
                  </p>
                  <textarea
                    v-model="haunt.diff"
                    class="code-textarea"
                    rows="9"
                    placeholder="@@ src/runtime/AgentRouter.java\n+ // TODO: refactor before launch\n+ if (retry) { if (fallback) { ..."
                  ></textarea
                  ><button
                    class="button button-cyan button-wide"
                    @click="ingestDiff"
                  >
                    <Radar :size="16" />{{
                      haunt.ingested ? "再次扫描这段 diff" : "开始扫描"
                    }}
                  </button>
                  <div v-if="haunt.ghosts.length" class="ghost-list">
                    <div
                      v-for="ghost in haunt.ghosts"
                      :key="ghost.path"
                      class="ghost-row"
                    >
                      <span
                        class="ghost-type"
                        :class="ghost.type.toLowerCase()"
                      ></span
                      ><span
                        ><b>{{ ghost.path }}</b
                        ><small>{{ ghost.detail }}</small></span
                      ><strong>SEV.{{ ghost.severity }}</strong>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'bank'"
              class="page game-page bank-page"
            >
              <div class="game-hero bank-hero">
                <div>
                  <span class="game-label orange"
                    ><Landmark :size="15" /> TECH DEBT CENTRAL BANK</span
                  >
                  <h1>技术债中央银行</h1>
                  <p>坏味道金融化。每一次延期，都在复利。</p>
                </div>
                <div class="bank-live">
                  <span><i></i>MARKET OPEN</span><b>IRISA / MAIN</b>
                </div>
              </div>
              <div class="bank-summary">
                <div>
                  <span>总负债</span
                  ><b>¥{{ bank.scanned ? "136,480" : "120,000" }}</b
                  ><small><TrendingUp :size="13" /> +13.7% 本月</small>
                </div>
                <div>
                  <span>利息累计</span
                  ><b>¥{{ bank.scanned ? "10,840" : "8,600" }}</b
                  ><small>按日复利</small>
                </div>
                <div>
                  <span>NPL 率</span><b>18.0%</b
                  ><small class="negative">3 笔坏账</small>
                </div>
                <div>
                  <span>本周偿还额度</span><b>40h</b><small>默认容量</small>
                </div>
              </div>
              <div class="bank-layout">
                <div class="panel chart-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">DEBT INDEX · 30D</span>
                      <h2>债务 K 线</h2>
                    </div>
                    <div class="chart-legend">
                      <span><i></i>总负债</span
                      ><span class="negative"><i></i>坏账区间</span>
                    </div>
                  </div>
                  <div class="fake-chart">
                    <div class="chart-y">
                      <span>150k</span><span>100k</span><span>50k</span
                      ><span>0</span>
                    </div>
                    <div class="chart-area">
                      <div class="chart-grid-lines"></div>
                      <svg
                        viewBox="0 0 700 220"
                        preserveAspectRatio="none"
                        aria-label="债务趋势图"
                      >
                        <path
                          d="M0 182 L52 169 L105 174 L158 146 L210 152 L263 129 L316 135 L369 118 L421 126 L474 90 L526 106 L579 76 L632 82 L700 45"
                          fill="none"
                          stroke="#e67e22"
                          stroke-width="3"
                        />
                        <path
                          d="M0 182 L52 169 L105 174 L158 146 L210 152 L263 129 L316 135 L369 118 L421 126 L474 90 L526 106 L579 76 L632 82 L700 45 L700 220 L0 220Z"
                          fill="url(#bankFill)"
                          opacity=".16"
                        />
                        <defs>
                          <linearGradient
                            id="bankFill"
                            x1="0"
                            y1="0"
                            x2="0"
                            y2="1"
                          >
                            <stop offset="0" stop-color="#e67e22" />
                            <stop
                              offset="1"
                              stop-color="#e67e22"
                              stop-opacity="0"
                            />
                          </linearGradient>
                        </defs>
                      </svg>
                      <div class="chart-x">
                        <span>08.01</span><span>08.08</span><span>08.15</span
                        ><span>08.21</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="panel scan-panel">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">REPOSITORY</span>
                      <h2>扫描新债务</h2>
                    </div>
                    <Terminal :size="17" />
                  </div>
                  <label>仓库标识<input v-model="bank.repo" /></label>
                  <p>扫描会读取启发式 smell score，不会向真实仓库写入 PR。</p>
                  <button
                    class="button button-orange button-wide"
                    :disabled="bank.scanning"
                    @click="scanBank"
                  >
                    <RefreshCw
                      v-if="bank.scanning"
                      :size="15"
                      class="spin"
                    /><Code2 v-else :size="15" />{{
                      bank.scanning ? "正在计算利息…" : "运行一次扫描"
                    }}
                  </button>
                </div>
              </div>
              <div
                v-if="bank.bankruptcy && !bank.dismissed"
                class="bankruptcy-alert"
              >
                <div>
                  <span><Flame :size="17" />RISK ALERT · DRY RUN</span>
                  <h3>利息 + 本金已接近本周偿还阈值</h3>
                  <p>系统只会生成红牌，不会修改仓库或创建真实 PR。</p>
                </div>
                <button
                  class="icon-button"
                  aria-label="关闭风险提示"
                  @click="bank.dismissed = true"
                >
                  <X :size="17" />
                </button>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'gravity'"
              class="page game-page gravity-page"
            >
              <div class="game-hero gravity-hero">
                <div>
                  <span class="game-label blue"
                    ><Orbit :size="15" /> SOCIAL GRAVITY</span
                  >
                  <h1>人际关系黑洞拉扯图</h1>
                  <p>恒星与黑洞共同牵引你的核心行星，关系越强，影响越近。</p>
                </div>
                <div class="energy-badge">
                  <span>ENERGY NET</span><b>+{{ persona.energyNet }}</b
                  ><small>kJ / current</small>
                </div>
              </div>
              <div class="gravity-layout">
                <div class="orbit-panel">
                  <div class="scene-toolbar">
                    <span><i></i>关系体正在公转</span
                    ><button
                      class="icon-button scene-control"
                      :aria-label="gravityPaused ? '继续旋转' : '暂停旋转'"
                      :title="gravityPaused ? '继续旋转' : '暂停旋转'"
                      @click="toggleGravityAnimation"
                    >
                      <Play v-if="gravityPaused" :size="14" /><Pause
                        v-else
                        :size="14"
                      />
                    </button>
                  </div>
                  <div
                    class="orbit-system"
                    @pointermove="handleGravityPointerMove"
                    @pointerleave="clearGravityHover"
                  >
                    <canvas
                      ref="gravityCanvas"
                      class="gravity-canvas"
                      @pointerdown="startGravityDrag"
                      @pointerup="endGravityDrag"
                      @pointercancel="endGravityDrag"
                    ></canvas>
                    <div
                      class="gravity-target-layer"
                      aria-label="关系体互动区域"
                    >
                      <button
                        v-for="target in gravityTargets"
                        :key="target.alias"
                        :ref="
                          (element) =>
                            setGravityTargetElement(target.alias, element)
                        "
                        class="gravity-target"
                        :class="`is-${target.kind}`"
                        type="button"
                        :aria-label="`查看${target.alias}的关系信息`"
                        @pointerenter="revealGravityTarget(target.alias)"
                        @pointermove.stop
                        @focus="revealGravityTarget(target.alias)"
                        @click.stop="pinGravityTarget(target.alias)"
                      ></button>
                    </div>
                    <span class="scene-hint"
                      >拖动改变视角 · 悬停查看能量 · 自动公转中</span
                    >
                    <div
                      v-if="gravityHover"
                      :class="['gravity-tooltip', `is-${gravityHoverPos.side}`]"
                      :style="{
                        left: `${gravityHoverPos.x}px`,
                        top: `${gravityHoverPos.y}px`,
                      }"
                      role="tooltip"
                    >
                      <span class="tooltip-type">{{
                        gravityTypeLabel(gravityHover.kind)
                      }}</span
                      ><b>{{ gravityHoverTitle(gravityHover) }}</b
                      ><strong
                        :class="
                          gravityHover.charge < 0 ? 'negative' : 'positive'
                        "
                        >{{ gravityHover.charge < 0 ? "-" : "+"
                        }}{{ gravityEnergy(gravityHover) }} kJ</strong
                      >
                      <p>{{ gravityHoverDetail(gravityHover) }}</p>
                      <small
                        >质量 {{ gravityHover.mass }} · charge
                        {{ gravityHover.charge > 0 ? "+" : ""
                        }}{{ gravityHover.charge }}</small
                      >
                    </div>
                  </div>
                  <div class="orbit-caption">
                    <span
                      class="gravity-legend-item"
                      @mouseenter="setGravityLegendHover('star')"
                      @mouseleave="gravityLegendHover = null"
                      ><i class="dot-self"></i>恒星 / 你</span
                    ><span
                      class="gravity-legend-item"
                      @mouseenter="setGravityLegendHover('planet')"
                      @mouseleave="gravityLegendHover = null"
                      ><i class="dot-planet"></i>行星 / 补充</span
                    ><span
                      class="gravity-legend-item"
                      @mouseenter="setGravityLegendHover('black-hole')"
                      @mouseleave="gravityLegendHover = null"
                      ><i class="dot-hole"></i>黑洞 / 剥离</span
                    ><span class="caption-tip">黑洞越大，关系消耗越重</span>
                    <div v-if="gravityLegendHover" class="legend-tooltip">
                      <b>{{ gravityLegendInfo(gravityLegendHover).title }}</b
                      ><span>{{
                        gravityLegendInfo(gravityLegendHover).text
                      }}</span
                      ><em>悬停星体可查看具体 kJ</em>
                    </div>
                  </div>
                </div>
                <section
                  class="gravity-ecosystem"
                  aria-labelledby="ecosystem-title"
                >
                  <div class="ecosystem-head">
                    <div>
                      <span class="section-kicker">D3 · FORCE FIELD</span>
                      <h2 id="ecosystem-title">关系生态实时演化</h2>
                      <p>
                        补充关系呈现为恒星，剥离关系呈现为黑洞；你会向它们的合力平衡位置移动。
                      </p>
                    </div>
                    <div class="ecosystem-actions">
                      <button
                        class="icon-button"
                        type="button"
                        title="触发一次关系碰撞"
                        aria-label="触发一次关系碰撞"
                        :disabled="gravityGraphBusy"
                        @click="triggerGravityCollision"
                      >
                        <Zap :size="15" />
                      </button>
                      <button
                        class="icon-button"
                        type="button"
                        title="复制图谱摘要"
                        aria-label="复制图谱摘要"
                        @click="shareGravityGraph"
                      >
                        <Share2 :size="15" />
                      </button>
                    </div>
                  </div>
                  <div class="gravity-metrics">
                    <div>
                      <span>情感质量分</span><b>{{ gravityAnalysis.quality }}</b
                      ><i
                        ><em
                          :style="{ width: `${gravityAnalysis.quality}%` }"
                        ></em
                      ></i>
                    </div>
                    <div>
                      <span>消耗指数</span
                      ><b :class="{ danger: gravityAnalysis.drain > 60 }">{{
                        gravityAnalysis.drain
                      }}</b
                      ><i class="drain"
                        ><em
                          :style="{ width: `${gravityAnalysis.drain}%` }"
                        ></em
                      ></i>
                    </div>
                    <div>
                      <span>互动样本</span
                      ><b>{{ gravityAnalysis.interactions }}</b
                      ><small>条</small>
                    </div>
                    <div>
                      <span>模型置信度</span
                      ><b>{{ gravityAnalysis.confidence }}%</b>
                    </div>
                  </div>
                  <div
                    ref="gravityGraphWrap"
                    class="force-graph-wrap"
                    :class="{ 'is-fullscreen': gravityGraphFullscreen }"
                  >
                    <div class="graph-canvas-actions">
                      <button
                        class="icon-button"
                        type="button"
                        title="重置视图"
                        aria-label="重置视图"
                        @click="resetGravityGraphView"
                      >
                        <RefreshCw :size="15" />
                      </button>
                      <button
                        class="icon-button"
                        type="button"
                        :title="gravityGraphFullscreen ? '退出全屏' : '全屏查看关系图'"
                        :aria-label="gravityGraphFullscreen ? '退出全屏' : '全屏查看关系图'"
                        @click="toggleGravityGraphFullscreen"
                      >
                        <Minimize2 v-if="gravityGraphFullscreen" :size="15" />
                        <Maximize2 v-else :size="15" />
                      </button>
                    </div>
                    <svg
                      ref="gravityGraphSvg"
                      viewBox="0 0 900 360"
                      class="force-graph"
                      role="img"
                      aria-label="关系体力导向图"
                      :class="{ panning: gravityGraphView.panning }"
                      @pointerdown="startGravityGraphPan"
                      @pointermove="moveGravityGraphPan($event); dragGravityGraphMove($event, activeGravityGraphDragNode())"
                      @pointerup="endGravityGraphPan(); dragGravityGraphEnd($event, activeGravityGraphDragNode())"
                      @pointercancel="endGravityGraphPan(); dragGravityGraphEnd($event, activeGravityGraphDragNode())"
                      @wheel.prevent="zoomGravityGraph"
                      @dblclick="toggleGravityGraphZoom"
                    >
                      <defs>
                        <radialGradient id="galaxy-core" cx="35%" cy="28%">
                          <stop offset="0" stop-color="#fffde8" />
                          <stop offset=".18" stop-color="#ffe48a" />
                          <stop offset=".52" stop-color="#f7a234" />
                          <stop offset="1" stop-color="#a94b1f" />
                        </radialGradient>
                        <radialGradient id="galaxy-self" cx="30%" cy="23%">
                          <stop offset="0" stop-color="#f4ffff" />
                          <stop offset=".2" stop-color="#8df0ff" />
                          <stop offset=".6" stop-color="#1297bd" />
                          <stop offset="1" stop-color="#082752" />
                        </radialGradient>
                        <radialGradient id="galaxy-planet" cx="30%" cy="23%">
                          <stop offset="0" stop-color="#e5fbff" />
                          <stop offset=".26" stop-color="#79e0f3" />
                          <stop offset=".7" stop-color="#177eb5" />
                          <stop offset="1" stop-color="#09294f" />
                        </radialGradient>
                        <radialGradient id="galaxy-hole" cx="50%" cy="50%">
                          <stop offset="0" stop-color="#01030a" />
                          <stop offset=".56" stop-color="#060716" />
                          <stop offset=".72" stop-color="#8c2576" />
                          <stop offset="1" stop-color="#ec68af" />
                        </radialGradient>
                        <linearGradient id="accretion-disk" x1="0" x2="1">
                          <stop offset="0" stop-color="#b73a91" stop-opacity=".1" />
                          <stop offset=".2" stop-color="#ff65bd" />
                          <stop offset=".48" stop-color="#ffe0f3" />
                          <stop offset=".68" stop-color="#ff65bd" />
                          <stop offset="1" stop-color="#b73a91" stop-opacity=".1" />
                        </linearGradient>
                        <filter
                          id="graph-glow"
                          x="-100%"
                          y="-100%"
                          width="300%"
                          height="300%"
                        >
                          <feGaussianBlur stdDeviation="3" result="blur" />
                          <feMerge>
                            <feMergeNode in="blur" />
                            <feMergeNode in="SourceGraphic" />
                          </feMerge>
                        </filter>
                        <filter id="nebula-blur">
                          <feGaussianBlur stdDeviation="34" />
                        </filter>
                        <radialGradient id="space-depth" cx="50%" cy="48%">
                          <stop offset="0" stop-color="#071d31" />
                          <stop offset=".55" stop-color="#041321" />
                          <stop offset="1" stop-color="#020913" />
                        </radialGradient>
                        <pattern
                          id="star-field"
                          width="113"
                          height="97"
                          patternUnits="userSpaceOnUse"
                        >
                          <circle
                            cx="12"
                            cy="17"
                            r=".8"
                            fill="#d9efff"
                            opacity=".8"
                          />
                          <circle
                            cx="73"
                            cy="31"
                            r=".55"
                            fill="#ffffff"
                            opacity=".6"
                          />
                          <circle
                            cx="99"
                            cy="79"
                            r="1"
                            fill="#99cef6"
                            opacity=".45"
                          />
                          <circle
                            cx="37"
                            cy="70"
                            r=".45"
                            fill="#ffffff"
                            opacity=".7"
                          />
                        </pattern>
                      </defs>
                      <rect
                        width="100%"
                        height="100%"
                        fill="url(#space-depth)"
                      />
                      <rect
                        width="100%"
                        height="100%"
                        fill="url(#star-field)"
                        opacity=".58"
                      />
                      <g transform="translate(450 230)">
                        <g class="galaxy-atmosphere">
                          <ellipse
                            class="galaxy-nebula nebula-one"
                            rx="246"
                            ry="92"
                            transform="rotate(-19)"
                            filter="url(#nebula-blur)"
                          />
                          <ellipse
                            class="galaxy-nebula nebula-two"
                            rx="176"
                            ry="58"
                            transform="rotate(33)"
                            filter="url(#nebula-blur)"
                          />
                          <ellipse
                            class="galaxy-orbit orbit-a"
                            rx="292"
                            ry="112"
                            transform="rotate(-19)"
                          />
                          <ellipse
                            class="galaxy-orbit orbit-b"
                            rx="218"
                            ry="78"
                            transform="rotate(33)"
                          />
                          <ellipse
                            class="galaxy-orbit orbit-c"
                            rx="144"
                            ry="52"
                            transform="rotate(-19)"
                          />
                          <path
                            class="galaxy-arm arm-one"
                            d="M-275 42 C-142-116 52-141 259-19"
                          />
                          <path
                            class="galaxy-arm arm-two"
                            d="M-235-78 C-49 110 129 124 279 31"
                          />
                        </g>
                      </g>
                      <g
                        class="force-graph-viewport"
                        :transform="`translate(${gravityGraphView.x} ${gravityGraphView.y}) scale(${gravityGraphView.scale})`"
                      >
                        <path
                          v-for="node in gravityRelationNodes"
                          :key="node.id"
                          class="force-link"
                          :class="{
                            drain: node.charge < 0,
                            active: gravityRelationIsFocused(node),
                          }"
                          :d="gravityRelationLinkPath(node)"
                          :style="gravityRelationLinkStyle(node)"
                          fill="none"
                          stroke-width="1.8"
                          stroke-opacity=".6"
                        />
                        <path
                          v-for="node in gravityRelationNodes"
                          :key="node.id + '-current'"
                          class="force-link-current"
                          :class="{
                            drain: node.charge < 0,
                            active: gravityRelationIsFocused(node),
                          }"
                          :d="gravityRelationLinkPath(node)"
                          :style="gravityRelationLinkStyle(node)"
                          fill="none"
                        />
                        <g
                          v-for="node in gravityGraphNodes"
                          :key="node.id"
                          class="force-node"
                          :class="[
                            `is-${node.kind}`,
                            { focused: gravityGraphFocus?.id === node.id },
                          ]"
                          :transform="`translate(${node.x},${node.y})`"
                          tabindex="0"
                          role="button"
                          :aria-label="`查看${node.alias}的关系指标`"
                          @mouseenter="focusGravityGraphNode(node)"
                          @focus="focusGravityGraphNode(node)"
                          @pointerdown.stop="focusGravityGraphNode(node)"
                          @click="focusGravityGraphNode(node)"
                        >
                        <g class="force-node-motion">
                        <circle
                          class="force-influence-field"
                          :r="gravityInfluenceRadius(node)"
                        />
                        <circle class="force-node-halo" :r="node.radius + 8" />
                        <circle
                          class="force-node-core"
                          :r="node.radius"
                          filter="url(#graph-glow)"
                        />
                        <g
                          v-if="node.kind === 'star'"
                          class="force-star-rotation"
                        >
                          <path
                            class="force-star-flare"
                            :d="`M0 ${-node.radius * 1.65} L0 ${node.radius * 1.65} M${-node.radius * 1.65} 0 L${node.radius * 1.65} 0 M${-node.radius * 1.12} ${-node.radius * 1.12} L${node.radius * 1.12} ${node.radius * 1.12} M${-node.radius * 1.12} ${node.radius * 1.12} L${node.radius * 1.12} ${-node.radius * 1.12}`"
                          />
                          <ellipse
                            class="force-star-latitude"
                            :rx="node.radius * 1.14"
                            :ry="node.radius * 0.34"
                          />
                        </g>
                        <circle
                          v-if="node.kind === 'self'"
                          class="force-self-atmosphere"
                          :r="node.radius + 3"
                        />
                        <g
                          v-if="node.kind === 'black-hole'"
                          class="force-hole-accretion"
                        >
                          <ellipse
                            class="force-hole-disk-glow"
                            :rx="node.radius * 1.9"
                            :ry="node.radius * 0.4"
                          />
                          <ellipse
                            class="force-node-ring force-node-ring-outer"
                            :rx="node.radius * 1.86"
                            :ry="node.radius * 0.35"
                          />
                          <ellipse
                            class="force-node-ring force-node-ring-inner"
                            :rx="node.radius * 1.48"
                            :ry="node.radius * 0.22"
                          />
                        </g>
                        <circle
                          v-if="node.kind === 'black-hole'"
                          class="force-hole-event-horizon"
                          :r="node.radius * 0.62"
                        />
                        </g>
                        <text class="force-node-label" :y="node.radius + 17">
                          {{ node.alias }}
                        </text>
                        </g>
                      </g>
                    </svg>
                    <div v-if="gravityGraphFocus" class="graph-focus-card">
                      <span class="tooltip-type">{{
                        gravityTypeLabel(gravityGraphFocus.kind)
                      }}</span>
                      <b>{{ gravityGraphFocus.alias }}</b>
                      <div>
                        <span>{{
                          gravityGraphFocus.kind === "self"
                            ? "不产生引力"
                            : "引力强度 " + gravityGraphFocus.influence
                        }}</span
                        ><strong
                          :class="gravityGraphFocus.charge < 0 ? 'negative' : 'positive'"
                          >{{
                            gravityGraphFocus.kind === "self"
                              ? "受合力牵引"
                              : (gravityGraphFocus.charge < 0 ? "-" : "+") + gravityEnergy(gravityGraphFocus) + " kJ"
                          }}</strong
                        >
                      </div>
                      <small>{{
                        gravityGraphFocus.kind === "self"
                          ? "自己是观察核心，位置由所有关系体共同牵引。"
                          : "数值越大，星体越大、影响范围越广，自己会更靠近它。"
                      }}</small>
                    </div>
                  </div>
                  <div class="ecosystem-foot">
                    <span
                      ><i class="event-dot collision"></i
                      >{{ gravityGraphEvents[0]?.text }}</span
                    ><small>D3 forceSimulation · personal gravity field</small>
                  </div>
                  <p class="analysis-summary">{{ gravityAnalysis.summary }}</p>
                </section>
                <div class="panel gravity-input">
                  <div class="panel-heading">
                    <div>
                      <span class="section-kicker">AI ANALYSIS SOURCE</span>
                      <h2>输入互动描述</h2>
                    </div>
                    <MessageCircle :size="17" />
                  </div>
                  <div class="source-tabs" role="tablist">
                    <button
                      :class="{ active: gravity.source === 'chat' }"
                      @click="gravity.source = 'chat'"
                    >
                      <Upload :size="14" />聊天记录</button
                    ><button
                      :class="{ active: gravity.source === 'note' }"
                      @click="gravity.source = 'note'"
                    >
                      <PenLine :size="14" />观察日志
                    </button>
                  </div>
                  <div v-if="gravity.source === 'chat'" class="chat-import">
                    <input
                      id="gravity-file"
                      class="file-input"
                      type="file"
                      accept=".txt,.md,.json,.csv,text/plain,application/json,text/csv"
                      @change="handleChatImport"
                    /><label for="gravity-file" class="import-dropzone"
                      ><Upload :size="19" /><span
                        ><b>{{
                          gravity.importing
                            ? "正在读取文件…"
                            : "选择聊天记录文件"
                        }}</b
                        ><small>.txt · .md · .json · .csv</small></span
                      ><ChevronRight :size="15"
                    /></label>
                    <div v-if="gravity.importedFile" class="imported-file">
                      <FileText :size="15" /><span>{{
                        gravity.importedFile
                      }}</span
                      ><button
                        class="icon-button"
                        aria-label="清除已导入文件"
                        @click="clearChatImport"
                      >
                        <X :size="14" />
                      </button>
                    </div>
                  </div>
                  <textarea
                    v-model="gravity.text"
                    rows="7"
                    :placeholder="
                      gravity.source === 'chat'
                        ? '也可以直接粘贴聊天快照，例如：\n工作群 23:10：明早能上线吗？\n我 23:12：可以……'
                        : '例如：工作群在晚上 11 点突然活跃；老朋友每次见面都让我重新有力气……'
                    "
                  ></textarea>
                  <p>
                    这里的内容只用于本次关系分析：提取互动信号，生成情感质量分、消耗指数和关系节点。
                  </p>
                  <button
                    class="button button-blue button-wide"
                    @click="ingestGravity"
                  >
                    <Orbit :size="16" />{{
                      gravity.ingested ? "重新计算星图" : "开始量化关系"
                    }}
                  </button>
                  <div class="body-list">
                    <div v-for="body in gravity.bodies" :key="body.alias">
                      <span
                        class="body-dot"
                        :class="gravityBodyKind(body)"
                      ></span
                      ><span>{{ body.alias }}</span
                      ><small v-if="body.color === 'self'"
                        >观察核心 · 受合力牵引</small
                      ><small v-else
                        >引力强度 {{ gravityEnergy(body) }} ·
                        {{ body.charge > 0 ? "补充" : "剥离" }}
                        {{ body.charge > 0 ? "+" : "-"
                        }}{{ gravityEnergy(body) }} kJ</small
                      >
                    </div>
                  </div>
                </div>
              </div>
            </section>

            <section
              v-else-if="activeTab === 'polarizer'"
              class="page game-page polarizer-page"
            >
              <div class="game-hero polarizer-hero">
                <div>
                  <span class="game-label red"
                    ><Target :size="15" /> BIAS POLARIZER</span
                  >
                  <h1>个人偏见偏振器</h1>
                  <p>拒绝情绪价值。输入一句结论，让杠精分身来找漏洞。</p>
                </div>
                <div class="bias-gauge">
                  <span>BIAS INDEX</span><b>{{ polarizer.bias }}</b>
                  <div><i :style="{ width: `${polarizer.bias}%` }"></i></div>
                </div>
              </div>
              <div class="polarizer-layout">
                <div class="bias-dial">
                  <div class="dial">
                    <div class="dial-markers">
                      <span>0</span><span>50</span><span>100</span>
                    </div>
                    <div
                      class="dial-needle"
                      :style="{
                        transform: `rotate(${polarizer.bias * 1.8 - 90}deg)`,
                      }"
                    ></div>
                    <div class="dial-center">{{ polarizer.bias }}</div>
                  </div>
                  <span class="dial-label">偏见度盘 · 仅作过程参考</span>
                  <div class="dial-tags">
                    <span v-for="tag in persona.biasTags" :key="tag"
                      >#{{ tag }}</span
                    >
                  </div>
                </div>
                <div class="panel boxing-panel">
                  <div class="boxing-head">
                    <div>
                      <span class="section-kicker">THE RING</span>
                      <h2>
                        {{ polarizer.active ? "正在交锋" : "提交你的结论" }}
                      </h2>
                    </div>
                    <span class="round-pill">{{
                      polarizer.active
                        ? `ROUND ${polarizer.round} / 5`
                        : "最多 5 回合"
                    }}</span>
                  </div>
                  <div v-if="!polarizer.active" class="proposition-form">
                    <textarea
                      v-model="polarizer.proposition"
                      rows="5"
                      placeholder="例如：远程工作一定比坐班更高效。"
                    ></textarea
                    ><button
                      class="button button-red button-wide"
                      @click="challengePolarizer"
                    >
                      <Target :size="16" />发起挑战
                    </button>
                  </div>
                  <div v-else>
                    <div class="punch-stream">
                      <div
                        v-for="(punch, index) in polarizer.punches"
                        :key="index"
                        class="punch"
                        :class="punch.side"
                      >
                        <span>{{
                          punch.side === "opponent" ? "杠精分身" : "你"
                        }}</span>
                        <p>{{ punch.text }}</p>
                      </div>
                    </div>
                    <div v-if="polarizer.round <= 5" class="rebut-form">
                      <textarea
                        v-model="polarizer.rebut"
                        rows="3"
                        placeholder="补充事实、边界或一个真正的例外……"
                      ></textarea
                      ><button
                        class="button button-dark"
                        @click="rebutPolarizer"
                      >
                        <Send :size="15" />回击
                      </button>
                    </div>
                    <div class="boxing-actions">
                      <button
                        class="text-button"
                        @click="closePolarizer('CONCEDED')"
                      >
                        承认我站不住</button
                      ><button
                        class="button button-secondary"
                        @click="closePolarizer('HELD')"
                      >
                        <Shield :size="14" />守住这个判断
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </Transition>
      </div>
    </main>

    <div v-if="showHelp" class="modal-backdrop" @click.self="showHelp = false">
      <div class="help-modal">
        <button
          class="icon-button modal-close"
          aria-label="关闭"
          @click="showHelp = false"
        >
          <X :size="18" /></button
        ><span class="help-symbol"><Command :size="21" /></span
        ><span class="section-kicker">IRISA / QUICK START</span>
        <h2>先从一条事实开始</h2>
        <p>
          总览是统一入口。病理、法庭、回音三款模块已支持完整 mock
          体验；其余四款可以预览和手动走通核心动作。
        </p>
        <div class="help-steps">
          <div>
            <b>01</b><span>记录今天</span
            ><small>写下具体罪证，生成结构化病历</small>
          </div>
          <div>
            <b>02</b><span>开一宗案</span><small>把犹豫交给五个不同的你</small>
          </div>
          <div>
            <b>03</b><span>留下签名</span><small>让选择进入长期账本</small>
          </div>
        </div>
        <button
          class="button button-primary button-wide"
          @click="
            showHelp = false;
            navigate('pathology');
          "
        >
          开始第一步 <ArrowRight :size="16" />
        </button>
      </div>
    </div>
    <Transition name="toast"
      ><div v-if="toast" class="toast-message">
        <Check :size="15" />{{ toast }}
      </div></Transition
    >
  </div>
</template>
