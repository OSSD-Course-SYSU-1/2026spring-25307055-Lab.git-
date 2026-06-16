/**
 * 本地数据服务 — 在网络不可用时为应用提供离线数据支持
 * 用户账号和排行榜数据存储在内存中，会话期间有效
 *
 * 注意：ArkTS 限制 —
 *   禁止对象展开 {...obj}
 *   禁止 Map/Set
 *   禁止 any/unknown 类型
 *   对象字面量必须匹配显式声明的接口
 */

export interface LocalUser {
  username: string
  password: string
  score: number
  title: string
}

export interface RankListResult {
  globalRanking: LocalUser[]
  rank: number
  user: LocalUser
}

class LocalDataService {
  private userList: LocalUser[] = []

  /**
   * 离线登录 — 用户存在则验证密码，不存在则自动创建
   */
  login(username: string, password: string): LocalUser | null {
    for (let i = 0; i < this.userList.length; i++) {
      const u = this.userList[i]
      if (u.username === username) {
        if (u.password === password) {
          return this.copyUser(u)
        }
        return null // 密码错误
      }
    }
    // 首次离线使用：自动创建账号
    const newUser: LocalUser = {
      username: username,
      password: password,
      score: 0,
      title: 'Bronze'
    }
    this.userList.push(newUser)
    return this.copyUser(newUser)
  }

  /**
   * 离线注册
   */
  register(username: string, password1: string, password2: string): LocalUser | null {
    for (let i = 0; i < this.userList.length; i++) {
      if (this.userList[i].username === username) {
        return null // 用户名已存在
      }
    }
    if (password1 !== password2) {
      return null // 两次密码不一致
    }
    const user: LocalUser = {
      username: username,
      password: password1,
      score: 0,
      title: 'Bronze'
    }
    this.userList.push(user)
    return this.copyUser(user)
  }

  /**
   * 更新用户分数
   */
  updateScore(username: string, score: number): LocalUser | null {
    for (let i = 0; i < this.userList.length; i++) {
      if (this.userList[i].username === username) {
        this.userList[i].score = score
        this.userList[i].title = this.calcTitle(score)
        return this.copyUser(this.userList[i])
      }
    }
    return null
  }

  /**
   * 获取本地排行榜
   */
  getRankList(username: string): RankListResult | null {
    let foundUser: LocalUser | null = null
    for (let i = 0; i < this.userList.length; i++) {
      if (this.userList[i].username === username) {
        foundUser = this.userList[i]
        break
      }
    }
    if (foundUser === null) {
      return null
    }

    // 按分数降序排序
    const ranking: LocalUser[] = this.sortUsersByScore(this.userList)

    let rank = 0
    for (let i = 0; i < ranking.length; i++) {
      if (ranking[i].username === username) {
        rank = i + 1
        break
      }
    }

    const result: RankListResult = {
      globalRanking: ranking,
      rank: rank,
      user: this.copyUser(foundUser)
    }
    return result
  }

  private sortUsersByScore(list: LocalUser[]): LocalUser[] {
    const sorted: LocalUser[] = []
    for (let i = 0; i < list.length; i++) {
      sorted.push(list[i])
    }
    // 简单选择排序 (ArkTS 对箭头函数支持有限)
    for (let i = 0; i < sorted.length - 1; i++) {
      let maxIdx = i
      for (let j = i + 1; j < sorted.length; j++) {
        if (sorted[j].score > sorted[maxIdx].score) {
          maxIdx = j
        }
      }
      if (maxIdx !== i) {
        const temp = sorted[i]
        sorted[i] = sorted[maxIdx]
        sorted[maxIdx] = temp
      }
    }
    return sorted
  }

  private copyUser(u: LocalUser): LocalUser {
    return {
      username: u.username,
      password: u.password,
      score: u.score,
      title: u.title
    }
  }

  private calcTitle(score: number): string {
    if (score >= 300) {
      return 'King'
    }
    if (score >= 150) {
      return 'Star'
    }
    if (score >= 50) {
      return 'Silver'
    }
    return 'Bronze'
  }
}

const localDataService = new LocalDataService()
export default localDataService
