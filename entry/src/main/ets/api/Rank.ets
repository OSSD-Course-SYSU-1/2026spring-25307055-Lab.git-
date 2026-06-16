import localDB, { RankListResult } from '../Utils/LocalDataService'

export interface UpdateScoreResult {
  msg: string
}

export function getRankList(username: string): RankListResult | null {
  return localDB.getRankList(username)
}

export function updateScore(username: string, score: number): UpdateScoreResult {
  localDB.updateScore(username, score)
  const result: UpdateScoreResult = {
    msg: '本地保存成功'
  }
  return result
}
