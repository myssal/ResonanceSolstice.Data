local DataModel = {
  QTEResultType = {
    PlayerMiss = 0,
    PlayerBigWin = 1,
    PlayerSmallWin = 2,
    PlayerSmallLose = 3,
    PlayerBigLose = 4
  },
  isStart = false,
  triggerSpeed = 2,
  teamID = 0,
  VolleyGameManager = nil
}
return DataModel
