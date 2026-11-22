local HaoPlayReporter = {}
local EvtName = {
  LevelUpOneHour = "stdhour1",
  LevelUpThreeHour = "stdhour3",
  LevelUpOneDay = "stdlevel",
  FirstUseStamina = "stdexhausted",
  BuyStaminaTwiceOneDay = "stdstaminapurchase",
  OpenUIStore = "stdrechargeprompt",
  FirstRecharge = "stdrecharge",
  BuyMonthCard = "stdmonthly",
  DrawCardHundredTime = "stdlackofdiamonds",
  DrawCardTensByDiamond = "dupspend1600",
  BuyUAV = "uavpurchase",
  CostDiamond2000 = "stdspend2000",
  FirstUseEnergy = "fatigueadded",
  BuyEnergyTwiceOneDay = "fatiguepurchase2s",
  BuyStaminaMax = "staminapurchase8s",
  BuyEnergyMax = "fatiguepurchase8s"
}
local staminaBuyTime = 0
local energyBuyTime = 0

function HaoPlayReporter.TrackLevelUp(levelNow)
  local oneHourLv = 15
  local threeHourLv = 25
  local oneDayLv = 30
  if levelNow >= oneDayLv then
    HaoPlayReporter.EvtTrack(EvtName.LevelUpOneDay)
  elseif levelNow >= threeHourLv then
    HaoPlayReporter.EvtTrack(EvtName.LevelUpThreeHour)
  elseif levelNow >= oneHourLv then
    HaoPlayReporter.EvtTrack(EvtName.LevelUpOneHour)
  end
end

function HaoPlayReporter.TrackOpenUIStore()
  HaoPlayReporter.EvtTrack(EvtName.OpenUIStore)
end

function HaoPlayReporter.TrackBuySuccss(productId)
  HaoPlayReporter.TrackFirstRecharge()
  if tostring(productId) == "82100027" then
    HaoPlayReporter.EvtTrack(EvtName.BuyUAV)
  end
  if tostring(productId) == "82100020" then
    HaoPlayReporter.TrackBuyMonthCard()
  end
end

function HaoPlayReporter.TrackBuyMonthCard()
  HaoPlayReporter.EvtTrack(EvtName.BuyMonthCard)
end

function HaoPlayReporter.TrackFirstRecharge()
  HaoPlayReporter.EvtTrack(EvtName.FirstRecharge)
end

function HaoPlayReporter.TrackDrawCard(drawNum)
  if drawNum == 10 then
    HaoPlayReporter.TrackDrawCardTensByDiamond()
  end
  local numNow = PlayerData:GetPlayerPrefs("int", "DrawCardTotalNum", true)
  if 100 <= numNow then
    HaoPlayReporter.TrackDrawCardHundredTime()
  end
  PlayerData:SetPlayerPrefs("int", "DrawCardTotalNum", numNow + drawNum)
end

function HaoPlayReporter.TrackDrawCardHundredTime()
  HaoPlayReporter.EvtTrack(EvtName.DrawCardHundredTime)
end

function HaoPlayReporter.TrackDrawCardTensByDiamond()
  HaoPlayReporter.EvtTrack(EvtName.DrawCardTensByDiamond)
end

function HaoPlayReporter.TrackCostDiamond(num, reason)
  if num == nil then
    Debug.Log("[SDK][HaoPlayReporter]TrackCostDiamond failed : num is nil")
    return
  end
  local diamondNumNow = PlayerData:GetGoodsById(11400005).num
  if reason == "stamina" then
    local rockcfg_id = 99900001
    local rockConfig = PlayerData:GetFactoryData(rockcfg_id, "ConfigFactory")
    local energyAddMax = #rockConfig.energyMoneyCost
    local rock_RemainNum = energyAddMax - PlayerData.ServerData.user_info.buy_energy_cnt
    HaoPlayReporter.EvtTrack(EvtName.FirstUseStamina)
    staminaBuyTime = staminaBuyTime + 1
    if 2 <= staminaBuyTime then
      HaoPlayReporter.EvtTrack(EvtName.BuyStaminaTwiceOneDay)
    end
    if rock_RemainNum <= 1 then
      HaoPlayReporter.EvtTrack(EvtName.BuyStaminaMax)
    end
  elseif reason == "energy" then
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    local allDiamondUseNum = #homeConfig.orderCost
    local maxDiamondUseNum = allDiamondUseNum - PlayerData:GetHomeInfo().meal_info.order_num
    HaoPlayReporter.EvtTrack(EvtName.FirstUseEnergy)
    energyBuyTime = energyBuyTime + 1
    if 2 <= energyBuyTime then
      HaoPlayReporter.EvtTrack(EvtName.BuyEnergyTwiceOneDay)
    end
    if maxDiamondUseNum <= 1 then
      HaoPlayReporter.EvtTrack(EvtName.BuyEnergyMax)
    end
  end
  local numNow = PlayerData:GetPlayerPrefs("int", "CostDiamondNum", true)
  if 2000 <= numNow then
    HaoPlayReporter.EvtTrack(EvtName.CostDiamond2000)
    return
  end
  PlayerData:SetPlayerPrefs("int", "CostDiamondNum", numNow + num)
end

function HaoPlayReporter.EvtTrack(strEventName)
  if SdkHelper.IsChannelHaoPlay() then
    CS.GameSdkLuaface.HaoPlayTrack(strEventName)
  end
end

return HaoPlayReporter
