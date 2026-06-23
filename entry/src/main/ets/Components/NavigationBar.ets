import { imageModel } from '../Bean/ImageModel'
import { router } from '@kit.ArkUI'
import { imageOrigin } from '../Bean/ImageOrigin'

/*
  顶部导航栏组件，包含了返回按钮、步数显示等功能
 */

@Component
struct NavigationBar {
  @Link imageList: imageOrigin[]
  @Link imageModel: imageModel
  @Link selected_img_index: number
  @Link customPopup: boolean

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
      Image($r('app.media.ic_public_help_filled'))
        .width(30)
        .height(30)
        .margin({ left: 10, right: 10 })
        .interpolation(ImageInterpolation.High)
        .onClick(() => {
          this.customPopup = !this.customPopup
        })
        .bindPopup(this.customPopup, {
          builder: this.popupBuilder,
          placement: Placement.Bottom,
          popupColor: Color.Pink
        })
    }
    .width('100%')
    .height(40)
    .borderRadius(2)
    .justifyContent(FlexAlign.SpaceBetween)
  }
  @Builder
  popupBuilder() {
    Row({ space: 2 }) {
      Column() {
        Text('给您一点提示哈，再次点击图标可关闭')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
          .fontWeight(900)
          .fontColor(Color.Black)
          .width('100%')
          .fontWeight(FontWeight.Bold)
          .margin({left: 10})
        Image(this.imageList[this.selected_img_index + 1].imgSource).width(300)
          .height(300).interpolation(ImageInterpolation.High)
      }
    }.width(320).height(360).padding(5)
  }
}

export { NavigationBar }