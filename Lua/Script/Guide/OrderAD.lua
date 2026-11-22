local Order = {}

function Order:OnStart(ca)
  PlayerData.TempCache.ADPopInfo.StopPop = ca.isBan
end

function Order:IsFinish()
  return true
end

return Order
