/**
 * 分布式事件总线 — 接口预留
 *
 * 提供跨设备的发布/订阅事件机制。
 * 后续通过 @ohos.distributedObject 或 @ohos.data.distributedKVStore 实现
 * 设备间实时事件传递。
 */
import {
  DistributedEventType,
  ControlCommand,
  DeviceInfo,
  GameSnapshot,
} from './DistributedTypes'

/** 事件处理器类型 */
type EventHandler = (data: string) => void;
type StateHandler = (snapshot: GameSnapshot) => void;
type DeviceHandler = (device: DeviceInfo) => void;
type CommandHandler = (command: ControlCommand, payload: string) => void;

/**
 * 分布式事件总线
 *
 * 每个事件类型可注册多个监听器。
 * emit 方法触发本端所有监听器；后续分布式实现会将事件广播到对端设备。
 */
export class DistributedEventBus {
  private static eventHandlers: Map<number, EventHandler[]> = new Map();
  private static stateHandlers: StateHandler[] = [];
  private static deviceHandlers: DeviceHandler[] = [];
  private static commandHandlers: CommandHandler[] = [];

  // -------- 通用事件 --------

  /**
   * 注册事件监听
   * @param type 事件类型
   * @param handler 处理函数
   */
  static on(type: DistributedEventType, handler: EventHandler): void {
    const key = type as number
    let handlers = DistributedEventBus.eventHandlers.get(key)
    if (handlers == null) {
      handlers = []
      DistributedEventBus.eventHandlers.set(key, handlers)
    }
    handlers.push(handler)
    console.info('[DistributedEventBus] 注册事件:', type, '当前监听器数:', handlers.length)
  }

  /**
   * 触发事件
   * @param type 事件类型
   * @param data 事件数据
   */
  static emit(type: DistributedEventType, data: string): void {
    console.info('[DistributedEventBus] 触发事件:', type)
    const handlers = DistributedEventBus.eventHandlers.get(type as number)
    if (handlers != null) {
      for (let i = 0; i < handlers.length; i++) {
        handlers[i](data)
      }
    }
    // TODO: 通过分布式数据对象将事件广播到对端设备
    //   distributedObject.data = JSON.stringify({ type, data })
  }

  /**
   * 移除事件监听
   * @param type 事件类型
   * @param handler 要移除的处理函数
   */
  static off(type: DistributedEventType, handler: EventHandler): void {
    const key = type as number
    const handlers = DistributedEventBus.eventHandlers.get(key)
    if (handlers != null) {
      const idx = handlers.indexOf(handler)
      if (idx >= 0) {
        handlers.splice(idx, 1)
      }
    }
  }

  // -------- 游戏状态事件 --------

  /**
   * 注册游戏状态变更监听
   */
  static onGameState(handler: StateHandler): void {
    DistributedEventBus.stateHandlers.push(handler)
  }

  /**
   * 触发游戏状态变更
   */
  static emitGameState(snapshot: GameSnapshot): void {
    for (let i = 0; i < DistributedEventBus.stateHandlers.length; i++) {
      DistributedEventBus.stateHandlers[i](snapshot)
    }
  }

  // -------- 设备事件 --------

  /**
   * 注册设备发现监听
   */
  static onDeviceEvent(handler: DeviceHandler): void {
    DistributedEventBus.deviceHandlers.push(handler)
  }

  /**
   * 触发设备发现事件
   */
  static emitDeviceEvent(device: DeviceInfo): void {
    for (let i = 0; i < DistributedEventBus.deviceHandlers.length; i++) {
      DistributedEventBus.deviceHandlers[i](device)
    }
  }

  // -------- 控制指令事件 --------

  /**
   * 注册控制指令监听
   */
  static onControlCommand(handler: CommandHandler): void {
    DistributedEventBus.commandHandlers.push(handler)
  }

  /**
   * 触发控制指令
   */
  static emitControlCommand(command: ControlCommand, payload: string): void {
    for (let i = 0; i < DistributedEventBus.commandHandlers.length; i++) {
      DistributedEventBus.commandHandlers[i](command, payload)
    }
  }

  // -------- 生命周期 --------

  /**
   * 清除所有监听器（会话结束时调用）
   */
  static clear(): void {
    DistributedEventBus.eventHandlers.clear()
    DistributedEventBus.stateHandlers = []
    DistributedEventBus.deviceHandlers = []
    DistributedEventBus.commandHandlers = []
    console.info('[DistributedEventBus] 已清除所有监听器')
  }
}
