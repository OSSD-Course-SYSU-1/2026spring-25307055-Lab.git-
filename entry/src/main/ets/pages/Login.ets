import { router } from '@kit.ArkUI'
import localDB, { LocalUser } from '../Utils/LocalDataService'

@Entry
@Component
struct Login {
  private username: string = ''
  private password: string = ''

  userLogin() {
    const localUser: LocalUser | null = localDB.login(this.username, this.password)
    if (localUser !== null) {
      AppStorage.setOrCreate('CurrentUsername', localUser.username)
      AppStorage.setOrCreate('CurrentScore', localUser.score)
      router.pushUrl({ url: 'pages/Index' })
    } else {
      AlertDialog.show({
        message: '用户名或密码错误'
      })
    }
  }

  build() {
    Column() {
      Image($r('app.media.GAME_LOGO'))
        .width('100%')
        .height('35%')
        .margin({ bottom: 20 })

      Column() {
        Text('欢迎体验游戏')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(20)
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25)
          .fontColor('#fff80000')
          .margin({ bottom: 30, top: 20 })
        TextInput({ placeholder: '请输入用户名' })
          .width(300)
          .height(48)
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 16 })
          .onChange((value: string) => {
            this.username = value
          })
        TextInput({ placeholder: '请输入密码' })
          .width(300)
          .height(48)
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 16 })
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value
          })
        Button('登录')
          .width(300)
          .height(48)
          .backgroundColor('#ff45d7ea')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
          .fontColor('#FFFFFF')
          .margin({ bottom: 16 })
          .onClick(() => {
            console.log('登录')
            this.userLogin()
          })
        Button('注册')
          .width(300)
          .height(48)
          .backgroundColor('#ff17bc9b')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
          .fontColor('#FFFFFF')
          .margin({ bottom: 16 })
          .onClick(() => {
            console.log('注册')
            router.pushUrl({ url: 'pages/Register' })
          })
      }
      .width('90%')
      .height('50%')
      .padding({ left: 10, right: 10 })
      .borderRadius(10)
      .shadow({
        radius: 10,
        color: '#000000',
        offsetX: 4,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
