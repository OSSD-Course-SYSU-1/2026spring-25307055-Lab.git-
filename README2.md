# 分布式流转接口层 — 技术文档

为华容道小游戏预留的 HarmonyOS **自由流转（分布式多设备协同）** 接口层。

---

## 概述

本模块为后续实现以下分布式场景预留完整接口：

- **游戏迁移**：在手机上开始游戏，无缝转移到平板上继续，游戏状态（网格、步数、用时、积分）完整保留
- **多端协同**：平板展示游戏网格，手机作为遥控器操作（开始/暂停/重置/切换图片）
- **数据同步**：排位积分在多设备间实时同步，排行榜跨设备一致

---

## 文件结构

```
entry/src/main/ets/Distributed/
├── DistributedTypes.ets           # 数据类型（DeviceInfo、GameSnapshot、SessionInfo 等）
├── DistributedGameService.ets     # 核心服务（设备发现、会话管理、状态同步、迁移）
└── DistributedEventBus.ets        # 事件总线（发布/订阅、跨设备事件传递）
```

---

## 核心接口

### DistributedTypes.ets — 数据类型

| 类型 | 说明 | 关键字段 |
|------|------|----------|
| `DeviceInfo` | 设备信息 | `deviceId`, `deviceName`, `deviceType` |
| `GameSnapshot` | 游戏快照（可序列化） | `tiles[]`, `gridSize`, `isHard`, `steps`, `elapsedTime`, `score`, `gameMode` |
| `SessionInfo` | 分布式会话 | `sessionId`, `hostDeviceId`, `peerDeviceId`, `state`, `capability` |
| `SubImageData` | 拼图子图序列化表示 | `position`, `truePosition`, `imageName` |
| `FlowCapability` | 流转能力枚举 | `MIGRATION`, `COLLABORATION`, `DATA_SYNC` |
| `SessionState` | 会话状态枚举 | `NONE`, `WAITING`, `CONNECTED`, `DISCONNECTED` |
| `DistributedEventType` | 事件类型枚举 | `DEVICE_ONLINE`, `INVITATION_RECEIVED`, `GAME_STATE_UPDATE` 等 |
| `ControlCommand` | 控制指令枚举 | `START`, `PAUSE`, `RESET`, `SWITCH_IMAGE`, `TOGGLE_DIFFICULTY` |

### DistributedGameService.ets — 核心服务

| 方法 | 说明 | 后续对接 API |
|------|------|-------------|
| `init()` | 初始化分布式服务 | `@ohos.distributedDeviceManager` |
| `startDiscovery()` | 开始搜索附近设备 | `deviceManager.getAvailableDeviceListSync()` |
| `stopDiscovery()` | 停止设备搜索 | `deviceManager.off()` |
| `createSession()` | 创建游戏会话，邀请设备加入 | 分布式数据对象 / RPC |
| `joinSession()` | 加入已有会话 | 分布式数据对象 / RPC |
| `leaveSession()` | 离开当前会话 | 关闭数据通道 |
| `pushGameState()` | 推送游戏快照到对端 | `@ohos.data.distributedKVStore` |
| `onGameStateReceived()` | 注册状态接收回调 | 分布式数据变更监听 |
| `saveContinuationState()` | 保存游戏迁移快照 | `@ohos.distributedMissionManager` |
| `getContinuationState()` | 获取迁移快照 | `@ohos.distributedMissionManager` |
| `migrateToDevice()` | 发起游戏迁移到目标设备 | `distributedMissionManager` |
| `sendControlCommand()` | 发送控制指令（协同模式） | `DistributedEventBus` |

### DistributedEventBus.ets — 事件总线

| 方法 | 说明 |
|------|------|
| `on(type, handler)` | 注册事件监听 |
| `emit(type, data)` | 触发事件（本端 + 后续跨设备广播） |
| `onGameState(handler)` | 注册游戏状态变更监听 |
| `onDeviceEvent(handler)` | 注册设备事件监听 |
| `onControlCommand(handler)` | 注册控制指令监听 |
| `clear()` | 清除所有监听器 |

---

## 已有集成

| 集成点 | 修改内容 |
|--------|----------|
| `EntryAbility.ets` | `onCreate()` 中调用 `DistributedGameService.init()` |
| `module.json5` | 新增分布式权限声明：`DISTRIBUTED_DATASYNC`（含 `usedScene` 配置） |
| 多语言资源 | 新增 `distributed_datasync_reason` 字符串（中/英） |

---

## 后续开发指引

1. **设备发现**：在 `startDiscovery()` 中接入 `@ohos.distributedDeviceManager`
2. **数据同步**：在 `pushGameState()` 中接入 `@ohos.data.distributedKVStore`
3. **迁移**：在 `migrateToDevice()` 中接入 `@ohos.distributedMissionManager`
4. **事件广播**：在 `DistributedEventBus.emit()` 中接入 `@ohos.distributedObject`
5. **UI 入口**：在游戏的设置页面或首页添加"多设备"按钮，调用 `startDiscovery()`

---

## 权限说明

```json5
{
  "name": "ohos.permission.DISTRIBUTED_DATASYNC",
  "reason": "$string:distributed_datasync_reason",
  "usedScene": {
    "abilities": ["EntryAbility"],
    "when": "always"
  }
}
```
