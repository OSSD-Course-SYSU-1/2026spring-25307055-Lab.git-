/**
 * 分布式流转 — 数据类型定义
 *
 * 预留接口层，定义自由流转所需的所有数据结构。
 * 供后续实现分布式设备发现、会话管理、状态同步等功能使用。
 */

/** 设备信息 */
export interface DeviceInfo {
  /** 设备唯一标识 */
  deviceId: string;
  /** 设备名称（如 "P40"、"MatePad Pro"） */
  deviceName: string;
  /** 设备类型（phone / tablet / 2in1） */
  deviceType: string;
}

/** 设备发现状态 */
export enum DiscoveryState {
  /** 未开始 */
  IDLE = 0,
  /** 搜索中 */
  SCANNING = 1,
  /** 已结束 */
  FINISHED = 2,
}

/** 会话状态 */
export enum SessionState {
  /** 无会话 */
  NONE = 0,
  /** 等待对方加入 */
  WAITING = 1,
  /** 已连接 */
  CONNECTED = 2,
  /** 已断开 */
  DISCONNECTED = 3,
}

/** 流转能力类型 */
export enum FlowCapability {
  /** 迁移 - 将游戏从一台设备无缝转移到另一台 */
  MIGRATION = 0,
  /** 协同 - 多设备同时运行游戏不同部分 */
  COLLABORATION = 1,
  /** 分布式数据同步 */
  DATA_SYNC = 2,
}

/** 游戏难度级别 */
export class DifficultyLevel {
  static readonly EASY = 3;   // 3 x 3
  static readonly NORMAL = 4; // 4 x 4
  static readonly HARD = 5;   // 5 x 5
  static readonly EXPERT = 6; // 6 x 6
}

/** 单张拼图子图的序列化表示 */
export class SubImageData {
  position: number = 0;
  truePosition: number = 0;
  /** 图片资源名称（如 "CQ1.jpg"），流转时通过名称而非 PixelMap 传递 */
  imageName: string = '';
}

/** 可序列化的游戏快照 */
export class GameSnapshot {
  /** 快照版本号，用于兼容性检查 */
  version: number = 1;
  /** 时间戳 */
  timestamp: number = 0;
  /** 拼图子图列表 */
  tiles: SubImageData[] = [];
  /** 网格行列数 */
  gridSize: number = 3;
  /** 是否困难模式 */
  isHard: boolean = false;
  /** 已用步数 */
  steps: number = 0;
  /** 已用时间（ms） */
  elapsedTime: number = 0;
  /** 当前选中的图片资源名 */
  selectedImage: string = '';
  /** 当前积分（排位模式） */
  score: number = 0;
  /** 用户名 */
  username: string = '';
  /** 游戏模式（"casual" / "ranked"） */
  gameMode: string = '';
}

/** 分布式事件类型 */
export enum DistributedEventType {
  /** 设备上线 */
  DEVICE_ONLINE = 0,
  /** 设备离线 */
  DEVICE_OFFLINE = 1,
  /** 收到游戏邀请 */
  INVITATION_RECEIVED = 2,
  /** 游戏状态更新 */
  GAME_STATE_UPDATE = 3,
  /** 控制指令（如"撤销"/"暂停"等） */
  CONTROL_COMMAND = 4,
}

/** 控制指令类型（多设备协同用） */
export enum ControlCommand {
  /** 开始 */
  START = 0,
  /** 暂停 */
  PAUSE = 1,
  /** 重置 */
  RESET = 2,
  /** 切换图片 */
  SWITCH_IMAGE = 3,
  /** 切换难度 */
  TOGGLE_DIFFICULTY = 4,
}

/** 分布式会话信息 */
export class SessionInfo {
  /** 会话 ID */
  sessionId: string = '';
  /** 创建者设备 ID */
  hostDeviceId: string = '';
  /** 加入者设备 ID（协同模式） */
  peerDeviceId: string = '';
  /** 当前状态 */
  state: SessionState = SessionState.NONE;
  /** 所用流转能力 */
  capability: FlowCapability = FlowCapability.MIGRATION;
  /** 会话创建时间 */
  createdAt: number = 0;
}
