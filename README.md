# 华容道小游戏 — HarmonyOS Application

基于 HarmonyOS (OpenHarmony) 开发的华容道（Klotski / Sliding Puzzle）游戏应用。支持**休闲模式**和**排位模式**，包含用户登录/注册、图片拼图、计时计数、排名等完整功能。

---

## 项目文件结构

```
Lab2/
├── .claude/                          # Claude AI 辅助配置
├── .gitignore                        # Git 忽略规则
├── AppScope/                         # 应用级配置
│   ├── app.json5                     # 应用元信息（bundleName、版本号等）
│   └── resources/
│       └── base/
│           └── media/
│               └── app_icon.png      # 应用图标
├── build-profile.json5               # 项目级构建配置
├── code-linter.json5                 # 代码检查配置
├── entry/                            # 主 Entry 模块
│   ├── .gitignore
│   ├── build-profile.json5           # 模块构建配置
│   ├── hvigorfile.ts                 # 模块 Hvigor 构建脚本
│   ├── obfuscation-rules.txt         # 代码混淆规则
│   ├── oh-package.json5              # 模块包配置
│   ├── patch.json                    # 补丁配置
│   └── src/
│       ├── main/
│       │   ├── module.json5          # 模块声明（Ability、权限、设备类型等）
│       │   ├── ets/                  # ArkTS 源码目录
│       │   │   ├── Bean/             # 数据模型
│       │   │   │   ├── ImageModel.ets       # 图片数据模型
│       │   │   │   ├── ImageOrigin.ets      # 图片来源模型
│       │   │   │   └── SubImage.ets         # 拼图子块模型
│       │   │   ├── Components/       # UI 组件
│       │   │   │   ├── ImageList.ets            # 图片选择列表
│       │   │   │   ├── ModeSelector.ets         # 模式选择器
│       │   │   │   ├── RankedModeSelector.ets   # 排位模式选择器
│       │   │   │   ├── GameGrid.ets             # 游戏主网格
│       │   │   │   ├── RankedGameGrid.ets       # 排位模式网格
│       │   │   │   ├── NavigationBar.ets        # 导航栏
│       │   │   │   ├── RankedNavigationBar.ets  # 排位模式导航栏
│       │   │   │   ├── ControlButtons.ets       # 控制按钮组
│       │   │   │   ├── TimerComponent.ets       # 计时器组件
│       │   │   │   ├── DifficultySelector.ets   # 难度选择器
│       │   │   │   └── CustomDialogDemo.ets     # 自定义对话框
│       │   │   ├── Controller/       # 游戏逻辑控制器
│       │   │   │   └── CasualModeController.ets # 休闲模式控制器
│       │   │   ├── Utils/            # 工具类
│       │   │   │   ├── ScreenAdapter.ets        # 屏幕适配工具（响应式尺寸计算）
│       │   │   │   ├── CountInversions.ets      # 逆序数计算（判断拼图可解性）
│       │   │   │   ├── LocalDataService.ets     # 本地数据存储服务
│       │   │   │   └── AxiosRequest.ets         # 网络请求封装
│       │   │   ├── api/              # API 接口层
│       │   │   │   └── Rank.ets                # 排名相关 API
│       │   │   ├── common/           # 公共常量
│       │   │   │   └── Constants.ets           # 全局常量定义
│       │   │   ├── entryability/
│       │   │   │   └── EntryAbility.ets        # 应用入口 Ability
│       │   │   ├── entrybackupability/
│       │   │   │   └── EntryBackupAbility.ets  # 应用备份 Ability
│       │   │   └── pages/            # 页面
│       │   │       ├── Index.ets                # 首页（登录后主界面）
│       │   │       ├── Login.ets                # 登录页
│       │   │       ├── Register.ets             # 注册页
│       │   │       ├── CasualMode.ets           # 休闲模式页
│       │   │       ├── RankedMode.ets           # 排位模式页
│       │   │       └── Rank.ets                 # 排行榜页
│       │   └── resources/            # 资源文件
│       │       ├── base/
│       │       │   ├── element/
│       │       │   │   ├── color.json           # 颜色资源
│       │       │   │   └── string.json          # 字符串资源
│       │       │   ├── media/                   # 图片/图标资源
│       │       │   │   ├── GAME_LOGO.png         # 游戏 Logo
│       │       │   │   ├── Avatar.jpg            # 默认头像
│       │       │   │   ├── CQ1.jpg ~ CQ16.jpg    # 拼图图片素材（16张）
│       │       │   │   ├── StartGame.svg         # 开始游戏图标
│       │       │   │   ├── CasualMode.svg        # 休闲模式图标
│       │       │   │   ├── RankedMode.svg        # 排位模式图标
│       │       │   │   ├── RankedIcon.svg        # 排位图标
│       │       │   │   ├── GameIntro.svg         # 游戏介绍图标
│       │       │   │   ├── AuthorInfo.svg        # 作者信息图标
│       │       │   │   ├── Logout.svg            # 退出登录图标
│       │       │   │   ├── ic_arrow_left.svg     # 返回箭头
│       │       │   │   ├── ic_public_help_filled.svg  # 帮助图标
│       │       │   │   └── level1.svg ~ level4.svg    # 难度等级图标
│       │       │   ├── profile/
│       │       │   │   ├── main_pages.json       # 页面路由配置
│       │       │   │   └── backup_config.json    # 备份配置
│       │       │   └── rawfile/                  # 原始资源
│       │       │       └── CQ1.jpg ~ CQ16.jpg     # 拼图原图（16张）
│       │       ├── en_US/
│       │       │   └── element/
│       │       │       └── string.json           # 英文资源
│       │       └── zh_CN/
│       │           └── element/
│       │               └── string.json           # 中文资源
│       ├── mock/
│       │   └── mock-config.json5                 # Mock 配置
│       ├── ohosTest/
│       │   ├── module.json5                      # 测试模块配置
│       │   └── ets/test/
│       │       ├── Ability.test.ets              # Ability 测试
│       │       └── List.test.ets                 # 测试用例列表
│       └── test/
│           ├── List.test.ets                     # 单元测试列表
│           └── LocalUnit.test.ets                # 本地单元测试
├── hvigor/                           # Hvigor 构建工具配置
├── hvigorfile.ts                     # 项目级 Hvigor 构建脚本
├── LICENSE                           # 开源协议
├── oh-package.json5                  # 项目包管理（依赖：@ohos/axios 等）
├── oh-package-lock.json5             # 包版本锁定
└── README.md                         # 项目说明（本文件）
```

---

## 技术栈

| 类别       | 技术                                         |
| ---------- | -------------------------------------------- |
| 开发语言   | ArkTS (TypeScript 风格声明式 UI)             |
| 框架       | HarmonyOS SDK / ArkUI                        |
| 构建工具   | Hvigor                                       |
| 网络请求   | @ohos/axios                                  |
| 测试框架   | @ohos/hypium + @ohos/hamock                  |
| 目标设备   | Phone / Tablet / 2in1                        |

## 功能特性

- **用户系统**：登录 / 注册 / 退出
- **休闲模式**：选择图片和难度自由游玩
- **排位模式**：在线对战排名
- **排行榜**：查看全球玩家排名
- **多语言**：中文 / 英文
- **拼图验证**：通过逆序数算法判断拼图可解性

## 屏幕适配

针对 **手机（16:9）** 和 **平板（4:3）** 两种屏幕比例进行了 UI 响应式适配。

### 适配方案

通过 `ScreenAdapter` 工具类（`entry/src/main/ets/Utils/ScreenAdapter.ets`），在应用启动时通过 `display.getDefaultDisplaySync()` 获取屏幕真实尺寸（px → vp 换算），自动区分设备类型：

- **手机**：宽度 < 600vp，网格约占屏宽 85%，布局紧凑
- **平板**：宽度 ≥ 600vp，网格约占屏宽 75%（上限 600vp），间距和字号放大

### 具体修改

| 文件 | 原问题 | 适配方式 |
|------|--------|----------|
| `GameGrid.ets` / `RankedGameGrid.ets` | 网格硬编码 `310×250vp` | `ScreenAdapter.getGameGridSize()` 动态计算宽高 |
| `Login.ets` / `Register.ets` | 输入框/按钮 `width(300)` 固定 | → `width('90%')` 百分比宽度 |
| `ControlButtons.ets` | 三个按钮各 `width(110)` 合计 350vp 小屏溢出 | → `layoutWeight(1)` 弹性均分 |
| `NavigationBar.ets` / `RankedNavigationBar.ets` | `margin({left:100})` 硬编码间距 | → `Blank()` + `FlexAlign.SpaceBetween` 弹性布局 |
| `Index.ets` | `margin({top:150})` 固定边距 | → `layoutWeight(1)` 弹性空间垂直居中 |
| `DifficultySelector.ets` | `height(60)` 固定 | → `spacing(60, 70)` 手机/平板差异化 |
| `ModeSelector.ets` / `RankedModeSelector.ets` | `height(40)` 固定 | → `spacing(40, 50)` |
| `ImageList.ets` | `height(130)` 固定 | → `spacing(120, 160)` |
| `CasualMode.ets` / `RankedMode.ets` | 无初始化 | 在 `aboutToAppear()` 中调用 `ScreenAdapter.init()` |
| `ScreenAdapter.ets`（新增） | — | 屏幕信息获取 + 网格尺寸/间距/字号响应式计算 |
