import { imageModel } from '../Bean/ImageModel'
import { router } from '@kit.ArkUI'
import { imageOrigin } from '../Bean/ImageOrigin'

/*
  顶部导航栏组件，包含了返回按钮、步数显示等功能
 */

@Component
struct RankedNavigationBar {
  @Link imageList: imageOrigin[]
  @Link imageModel: imageModel

  build() {
    Row() {
      Image($r('app.media.ic_arrow_left'))
        .size({ width: 30, height: 30 })
        .margin({ left: 10, right: 10 })
        .interpolation(ImageInterpolation.High)
        .onClick(() => {
          router.back()
        })
      Blank()
      Text('步数：' + this.imageModel.steps)
        .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25)
      Blank()
      Image($r('app.media.RankedIcon'))
        .onClick(() => {
          router.pushUrl({ url: 'pages/Rank' })
        })
        .width(30)
        .height(30)
        .margin({ left: 10, right: 10 })
        .interpolation(ImageInterpolation.High)
    }
    .width('100%')
    .height(40)
    .borderRadius(2)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

export { RankedNavigationBar }