local DataModel = {
  remainAutoBattleTime = 3,
  constAutoBattleTime = 3,
  kabaneriAutoBattle = false,
  isBackFromBuyTips = false
}

function DataModel.GetMoney()
  return PlayerData:GetUserInfo().furniture_coins
end

return DataModel
