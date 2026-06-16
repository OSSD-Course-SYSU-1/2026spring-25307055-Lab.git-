import { router } from '@kit.ArkUI'
import localDB, { LocalUser } from '../Utils/LocalDataService'

@Entry
@Component
struct Register {
  private username: string = ''
  private password1: string = ''
  private password2: string = ''

  userRegister() {
    const localUser: LocalUser | null = localDB.register(this.username, this.password1, this.password2)
    if (localUser !== null) {
      AlertDialog.show({
        message: '注册成功，请登录'
      })
      router.pushUrl({ url: 'pages/Login' })
    } else {
      if (this.password1 !== this.password2) {
        AlertDialog.show({
          message: '两次密码输入不一致，请重新输入'
        })
      } else {
        AlertDialog.show({
          message: '用户名已存在，请换一个用户名'
        })
      }
    }
  }

  build() {
    Column() {
      Text('注册专属游戏帐号').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(28).margin({ bottom: 25 })
      TextInput({ placeholder:'请输入用户名'})
        .type(InputType.Normal)
        .height(48)
        .width(300)
        .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
        .margin({ top: 16 })
        .onChange((value: string) => {
          this.username = value
        })
      TextInput({ placeholder:'请输入密码'})
        .type(InputType.Password)
        .height(48)
        .width(300)
        .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
        .margin({ top: 16 })
        .onChange((value: string) => {
          this.password1 = value
        })
      TextInput({ placeholder:'请再次输入密码'})
        .type(InputType.Password)
        .height(48)
        .width(300)
        .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
        .margin({ top: 16, bottom: 25 })
        .onChange((value: string) => {
          this.password2 = value
        })
      Row() {
        Text('已有账号，去').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
        Text('登录').fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16).fontColor('#ff45d7ea').onClick(() => {
          router.pushUrl({ url: 'pages/Login' })
        })
      }
      Button('确认注册')
        .width(300)
        .height(48)
        .backgroundColor('#ff17bc9b')
        .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(16)
        .fontColor('#FFFFFF')
        .margin({ bottom: 16, top: 16 })
        .onClick(() => {
          this.userRegister()
        })
    }
    .width('100%')
    .padding(30)
  }
}
