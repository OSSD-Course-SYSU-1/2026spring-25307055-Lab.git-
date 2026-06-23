import { imageModel } from '../Bean/ImageModel'
import { subImage } from '../Bean/SubImage'
import { CasualModeController } from '../Controller/CasualModeController'
import { ScreenAdapter } from '../Utils/ScreenAdapter'

@Component
struct ControlButtons {
  @Link start: boolean
  @Link stop: boolean
  textTimerController: TextTimerController = new TextTimerController()
  @Link imageModel: imageModel
  @Link subImages: subImage[]
  @Link row_col_num: number
  @Prop controller: CasualModeController

  build() {
    Row() {
      Button() {
        Text('开始').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25).fontWeight(FontWeight.Bold).fontColor('#05030a')
      }.height(50).layoutWeight(1).margin({ left: 5, right: 5 }).backgroundColor('#fb9b69')
      .onClick(() => {
        if (this.start) {
          this.textTimerController.start()
          this.stop = false
        } else if (this.stop) {
          this.subImages = this.shuffleSubImages(this.subImages)
          this.start = true
          this.imageModel.steps = 0
          this.textTimerController.start()
        }
      })

      Button() {
        Text('暂停').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25).fontWeight(FontWeight.Bold).fontColor('#05030a')
      }.height(50).layoutWeight(1).margin({ left: 5, right: 5 }).backgroundColor('#fb9b69')
      .onClick(() => {
        this.textTimerController.pause()
        this.stop = true
      })

      Button() {
        Text('重置').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25).fontWeight(FontWeight.Bold).fontColor('#05030a')
      }.height(50).layoutWeight(1).margin({ left: 5, right: 5 }).backgroundColor('#fb9b69')
      .onClick(() => {
        AlertDialog.show({
          message: '已重置，点击“开始”按钮重新开始游戏吧!'
        })
        this.textTimerController.reset()
        this.imageModel.steps = 0
        this.controller.aboutToAppear()
        this.start = false
        this.stop = true
      })
    }
    .width('100%')
    .padding({ left: 10, right: 10 })
    .id('buttonGroup')
    .alignRules({
      top: { anchor: 'timeCounter', align: VerticalAlign.Bottom },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .margin({ top: ScreenAdapter.spacing(5, 15) })
  }

  shuffleSubImages(subImages : subImage[]) : subImage[] {
    subImages = this.imageModel.shuffleArray(subImages)
    subImages.push(new subImage(this.row_col_num * this.row_col_num, this.row_col_num * this.row_col_num, null))
    return subImages
  }
}

export { ControlButtons }
