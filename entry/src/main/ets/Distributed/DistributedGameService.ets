/**
 * 分布式游戏服务 — 接口预留
 *
 * 提供自由流转的核心能力接口，包括：
 * - 设备发现与连接管理
 * - 会话创建、加入与退出
 * - 游戏快照的推送与接收
 * - 游戏迁移（continuation）
 * - 多设备协同控制
 *
 * 当前为接口预留阶段，方法体以日志占位。
 * 后续基于 @ohos.distributedDeviceManager / @ohos.distributedMissionManager 等实现。
 */
import { DistributedEventBus } from './DistributedEventBus'
import {
  DeviceInfo,
  DiscoveryState,
  SessionState,
  FlowCapability,
  GameSnapshot,
  SessionInfo,
  ControlCommand,
} from './DistributedTypes'

/** 设备发现回调 */
export interface DeviceDiscoveryCallback {
  onDeviceFound: (device: DeviceInfo) => void;
  onDeviceLost: (device: DeviceInfo) => void;
  onError: (err: string) => void;
}

/** 游戏状态接收回调 */
export interface GameStateCallback {
  onStateReceived: (snapshot: GameSnapshot, fromDeviceId: string) => void;
}

/** 会话事件回调 */
export interface SessionEventCallback {
  onSessionStateChanged: (state: SessionState, session: SessionInfo) => void;
  onInvitationReceived: (fromDevice: DeviceInfo, sessionId: string) => void;
}

/**
 * 分布式游戏服务单例
 *
 * 使用方法：
 *   DistributedGameService.init()
 *   DistributedGameService.startDiscovery({ ... })
 *   DistributedGameService.createSession(deviceId)
 *   DistributedGameService.pushGameState(snapshot)
 */
export class DistributedGameService {
  // -------- 状态 --------

  /** 已发现的设备列表 */
  static discoveredDevices: DeviceInfo[] = [];
  /** 当前发现状态 */
  static discoveryState: DiscoveryState = DiscoveryState.IDLE;
  /** 当前会话信息 */
  static currentSession: SessionInfo | null = null;

  // -------- 发现回调持有 --------
  private static discoveryCallback: DeviceDiscoveryCallback | null = null;
  private static stateCallback: GameStateCallback | null = null;
  private static sessionCallback: SessionEventCallback | null = null;

  // -------- 初始化 --------

  /**
   * 初始化分布式服务
   * 应当应用启动时（EntryAbility.onCreate）调用一次
   */
  static init(): void {
    console.info('[DistributedGameService] 分布式服务初始化（预留接口）')
    // TODO: 后续接入分布式设备管理:
    //   import { deviceManager } from '@kit.DistributedServiceKit'
    //   1. 创建 DeviceManager 实例
    //   2. 注册设备状态监听
    //   3. 申请分布式权限
    DistributedGameService.currentSession = null
  }

  // -------- 设备发现 --------

  /**
   * 开始搜索附近设备
   * @param callback 设备发现回调
   */
  static startDiscovery(callback: DeviceDiscoveryCallback): void {
    DistributedGameService.discoveryCallback = callback
    DistributedGameService.discoveryState = DiscoveryState.SCANNING
    console.info('[DistributedGameService] 开始设备发现（预留接口）')
    // TODO:
    //   1. deviceManager.getAvailableDeviceListSync() 获取在线设备
    //   2. 调用 callback.onDeviceFound 逐一通知
    //   3. 监听 deviceManager.on('deviceOnline'/'deviceOffline')
    DistributedGameService.discoveryState = DiscoveryState.FINISHED
  }

  /**
   * 停止设备搜索
   */
  static stopDiscovery(): void {
    DistributedGameService.discoveryState = DiscoveryState.IDLE
    console.info('[DistributedGameService] 停止设备发现（预留接口）')
    // TODO: deviceManager.off('deviceOnline'/'deviceOffline')
  }

  // -------- 会话管理 --------

  /**
   * 创建游戏会话，邀请指定设备加入
   * @param targetDevice 目标设备信息
   * @returns 是否成功创建
   */
  static createSession(targetDevice: DeviceInfo): boolean {
    console.info('[DistributedGameService] 创建会话 ->', targetDevice.deviceName)
    // TODO:
    //   1. 生成 sessionId
    //   2. 通过 DistributedDataObject 或 RPC 发送邀请
    //   3. 等待对方确认
    const session = new SessionInfo()
    session.sessionId = 'session_' + new Date().getTime()
    session.hostDeviceId = targetDevice.deviceId
    session.state = SessionState.WAITING
    session.capability = FlowCapability.COLLABORATION
    session.createdAt = new Date().getTime()
    DistributedGameService.currentSession = session

    if (DistributedGameService.sessionCallback != null) {
      DistributedGameService.sessionCallback.onSessionStateChanged(
        SessionState.WAITING, session)
    }
    return true
  }

  /**
   * 加入一个游戏会话
   * @param sessionId 会话 ID
   * @returns 是否成功加入
   */
  static joinSession(sessionId: string): boolean {
    console.info('[DistributedGameService] 加入会话 ->', sessionId)
    // TODO: 接受远程邀请，建立双向数据通道
    if (DistributedGameService.currentSession != null) {
      DistributedGameService.currentSession.state = SessionState.CONNECTED
      if (DistributedGameService.sessionCallback != null) {
        DistributedGameService.sessionCallback.onSessionStateChanged(
          SessionState.CONNECTED, DistributedGameService.currentSession)
      }
    }
    return true
  }

  /**
   * 离开当前会话
   */
  static leaveSession(): void {
    console.info('[DistributedGameService] 离开会话')
    if (DistributedGameService.currentSession != null) {
      DistributedGameService.currentSession.state = SessionState.DISCONNECTED
      if (DistributedGameService.sessionCallback != null) {
        DistributedGameService.sessionCallback.onSessionStateChanged(
          SessionState.DISCONNECTED, DistributedGameService.currentSession)
      }
    }
    DistributedGameService.currentSession = null
    // TODO: 关闭数据通道
  }

  /**
   * 注册会话事件监听
   */
  static setSessionCallback(callback: SessionEventCallback): void {
    DistributedGameService.sessionCallback = callback
  }

  // -------- 游戏状态同步 --------

  /**
   * 推送游戏快照到对端设备
   * @param snapshot 当前游戏快照
   */
  static pushGameState(snapshot: GameSnapshot): void {
    console.info('[DistributedGameService] 推送游戏状态（预留接口）')
    // TODO: 通过 DistributedDataObject 或 DistributedKVStore 同步
    //   1. 序列化 snapshot 为 JSON
    //   2. 通过数据通道发送
    //   3. 对端通过 onStateReceived 接收
  }

  /**
   * 注册游戏状态接收回调
   * @param callback 收到游戏快照时的回调
   */
  static onGameStateReceived(callback: GameStateCallback): void {
    DistributedGameService.stateCallback = callback
    // TODO: 注册分布式数据变更监听
  }

  // -------- 游戏迁移 --------

  /**
   * 保存游戏快照，用于跨设备迁移
   * @param snapshot 当前游戏快照
   */
  static saveContinuationState(snapshot: GameSnapshot): void {
    console.info('[DistributedGameService] 保存迁移状态（预留接口）')
    // TODO: 通过 continuationManager 或 DistributedKVStore 保存
    //   continuationManager.saveData(sessionId, JSON.stringify(snapshot))
  }

  /**
   * 获取之前保存的迁移快照
   * @returns 游戏快照，若无则返回 null
   */
  static getContinuationState(): GameSnapshot | null {
    console.info('[DistributedGameService] 获取迁移状态（预留接口）')
    // TODO: 从 continuationManager 读取
    return null
  }

  /**
   * 发起游戏迁移到目标设备
   * @param targetDevice 目标设备
   * @param snapshot 当前游戏快照
   */
  static migrateToDevice(targetDevice: DeviceInfo, snapshot: GameSnapshot): void {
    console.info('[DistributedGameService] 迁移游戏到 ->', targetDevice.deviceName)
    DistributedGameService.saveContinuationState(snapshot)
    // TODO:
    //   1. 通过 distributedMissionManager 发起迁移
    //   2. 本端进入后台或关闭
    //   3. 对端恢复游戏状态
  }

  /**
   * 发送控制指令到对端设备（协同模式用）
   * @param command 控制指令
   * @param payload 附加数据
   */
  static sendControlCommand(command: ControlCommand, payload: string): void {
    console.info('[DistributedGameService] 发送控制指令:', command, payload)
    DistributedEventBus.emitControlCommand(command, payload)
  }

  // -------- 工具方法 --------

  /**
   * 将游戏状态序列化为 JSON 字符串
   */
  static serializeSnapshot(snapshot: GameSnapshot): string {
    return JSON.stringify(snapshot)
  }

  /**
   * 从 JSON 字符串反序列化游戏快照
   * TODO: 后续使用 ArkTS 兼容方式（如 @ohos.data.distributedKVStore）替代 JSON.parse
   */
  static deserializeSnapshot(json: string): GameSnapshot | null {
    console.info('[DistributedGameService] 反序列化快照（预留接口）:', json)
    // TODO: 接入分布式数据存储后，通过结构化方式反序列化
    return null
  }
}
