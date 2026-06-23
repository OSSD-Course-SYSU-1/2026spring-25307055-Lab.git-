/**
 * 屏幕适配工具类
 *
 * 提供获取屏幕尺寸、判断设备类型（手机/平板）、计算响应式尺寸的静态方法。
 * 在页面 aboutToAppear 或 onPageShow 中调用一次 ScreenAdapter.init() 即可。
 */
import { display } from '@kit.ArkUI';

class ScreenInfo {
  /** 屏幕宽度（vp） */
  widthVp: number = 360;
  /** 屏幕高度（vp） */
  heightVp: number = 780;
  /** 是否为平板（宽度 >= 600vp） */
  isTablet: boolean = false;
  /** 屏幕宽高比（width / height） */
  aspectRatio: number = 0.462;
}

export class GridSize {
  width: number = 310;
  height: number = 250;
}

export class ScreenAdapter {
  static screen: ScreenInfo = new ScreenInfo();
  static initialized: boolean = false;

  /**
   * 初始化屏幕信息（只执行一次）
   */
  static init(): void {
    if (ScreenAdapter.initialized) {
      return;
    }
    try {
      const d = display.getDefaultDisplaySync();
      const density = d.densityPixels;
      ScreenAdapter.screen.widthVp = Math.round(d.width / density);
      ScreenAdapter.screen.heightVp = Math.round(d.height / density);
      ScreenAdapter.screen.aspectRatio = ScreenAdapter.screen.widthVp / ScreenAdapter.screen.heightVp;
      // 宽度 >= 600vp 视为平板
      ScreenAdapter.screen.isTablet = ScreenAdapter.screen.widthVp >= 600;
      ScreenAdapter.initialized = true;
      console.info('ScreenAdapter initialized:', JSON.stringify(ScreenAdapter.screen));
    } catch (err) {
      console.error('ScreenAdapter init error:', JSON.stringify(err));
    }
  }

  /**
   * 获取游戏网格的推荐尺寸（vp），根据屏幕宽度动态计算
   */
  static getGameGridSize(): GridSize {
    ScreenAdapter.init();
    const sw = ScreenAdapter.screen.widthVp;
    const sh = ScreenAdapter.screen.heightVp;

    // 网格宽度：手机约 85% 屏宽，平板约 75% 屏宽，上限 600vp
    const maxGridW = Math.min(sw * (ScreenAdapter.screen.isTablet ? 0.75 : 0.85), 600);
    // 高度不超过屏幕高度的 55%，同时保持约 5:4 的宽高比
    const maxGridH = sh * 0.55;
    const idealH = maxGridW * 0.82;
    const gs = new GridSize();
    gs.width = Math.round(maxGridW);
    gs.height = Math.round(Math.min(idealH, maxGridH));
    return gs;
  }

  /**
   * 获取响应式字体大小
   * @param phoneSize  手机端字号（fp）
   * @param tabletSize 平板端字号（fp）
   */
  static fontSize(phoneSize: number, tabletSize: number): number {
    ScreenAdapter.init();
    return ScreenAdapter.screen.isTablet ? tabletSize : phoneSize;
  }

  /**
   * 获取响应式间距（用于 margin / padding）
   * @param phoneVal  手机端值（vp）
   * @param tabletVal 平板端值（vp）
   */
  static spacing(phoneVal: number, tabletVal: number): number {
    ScreenAdapter.init();
    return ScreenAdapter.screen.isTablet ? tabletVal : phoneVal;
  }
}
