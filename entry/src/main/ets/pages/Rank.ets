import { getRankList } from '../api/Rank'
import { router } from '@kit.ArkUI'
import { LocalUser } from '../Utils/LocalDataService'

@Entry
@Component
struct Rank {
  @StorageProp('CurrentUsername') currentUsername: string = ''
  @State rankingData: LocalUser[] = []
  @State currentUser: LocalUser = { username: '', score: 0, title: '', password: '' }
  @State currentRank: number = 0
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.initData()
    console.log('数据已加载完毕')
  }

  initData() {
    if (!this.currentUsername) {
      console.warn('当前用户名为空，无法加载数据');
      return;
    }

    this.isLoading = true;

    const result = getRankList(this.currentUsername);
    if (result !== null) {
      this.currentRank = result.rank;
      this.currentUser = result.user;
      this.rankingData = result.globalRanking;

      console.log('当前用户信息:', this.currentUser);
      console.log('本地排行榜信息:', this.rankingData);
    } else {
      console.error('未获取到排名数据');
    }

    this.isLoading = false;
  }

  build() {
    Column() {
      //导航栏
      Row() {
        Image($r('app.media.ic_arrow_left'))
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })

        Text('本地排行榜')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 40 })
      }
      .width('100%')
      .height(47)
      .justifyContent(FlexAlign.Start)
      .margin({ top: 10 })

      // 排行榜列表头
      Row() {
        Text('排名')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(14)
          .fontColor('#989a9c')
          .width('20%')
        Text('荣誉称号')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(14)
          .fontColor('#989a9c')
          .width('35%')
        Text('用户名')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(14)
          .fontColor('#989a9c')
          .width('35%')
        Text('积分')
          .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(14)
          .fontColor('#989a9c')
          .width('20%')
      }.width('90%')
      .padding(15)

      // 排行榜列表
      Column() {
        List() {
          ForEach(this.rankingData, (item: LocalUser, index: number) => {
            ListItem() {
              Row() {
                Text((index + 1).toString())
                  .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(20)
                  .width('20%')
                Image($r(`app.media.${item.title}`))
                  .width(30)
                  .height(30)
                  .margin({ right: 60 })
                Text(item.username)
                  .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(20)
                  .width('40%')
                Text(item.score.toString())
                  .fontFamily('serif').fontWeight(FontWeight.Medium).fontSize(20)
                  .width('20%')
              }
              .padding(10)
              .backgroundColor(item.username === this.currentUser.username ? '#c8c6b6' : '#f1f3f5')
            }
          })
        }
        .width('90%')
        .padding(15)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f1f3f5')
    }
  }
}
