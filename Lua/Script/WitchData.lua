local WitchesMapDataModel = require("UIWitchesMap/UIWitchesMapDataModel")
local WitchData = {}
local this = WitchData
local defaultActivityId = 86000051
local defaultParkMapId = 60600002
local defaultSceneName = "WitchesPark_Asset"
local activeGameActivityId = defaultActivityId
local activityCACache = {}
local parkMapIdCache = {}
local parkMapCACache = {}
WitchData.gridId = nil
WitchData.inWitchMap = false

local function getValidActivityId(activityId)
  return tonumber(activityId) or activeGameActivityId or defaultActivityId
end

function WitchData.SetActiveGameActivityId(activityId)
  activeGameActivityId = tonumber(activityId) or defaultActivityId
  WitchData.GetWitchesData(activeGameActivityId)
end

function WitchData.GetActivityId()
  return activeGameActivityId
end

function WitchData.GetActivityCA(activityId)
  activityId = getValidActivityId(activityId)
  if activityCACache[activityId] == nil then
    activityCACache[activityId] = PlayerData:GetFactoryData(activityId, "ActivityFactory")
  end
  return activityCACache[activityId]
end

function WitchData.GetParkMapId(activityId)
  activityId = getValidActivityId(activityId)
  if parkMapIdCache[activityId] == nil then
    local currentActivityCA = WitchData.GetActivityCA(activityId)
    local currentParkMapId = currentActivityCA and currentActivityCA.witchesGameMap or defaultParkMapId
    if not currentParkMapId or tonumber(currentParkMapId) == 0 then
      currentParkMapId = defaultParkMapId
    end
    parkMapIdCache[activityId] = currentParkMapId
  end
  return parkMapIdCache[activityId]
end

function WitchData.GetParkMapCA(activityId)
  activityId = getValidActivityId(activityId)
  if parkMapCACache[activityId] == nil then
    parkMapCACache[activityId] = PlayerData:GetFactoryData(WitchData.GetParkMapId(activityId), "ParkMapFactory")
  end
  return parkMapCACache[activityId]
end

function WitchData.GetSceneName(activityId)
  local currentParkMapCA = WitchData.GetParkMapCA(activityId)
  if currentParkMapCA and not string.nilorempty(currentParkMapCA.name) then
    return currentParkMapCA.name
  end
  return defaultSceneName
end

function WitchData.GetTimes(activityId)
  local currentParkMapCA = WitchData.GetParkMapCA(activityId)
  return currentParkMapCA and currentParkMapCA.times or 1
end

function WitchData.GetUIPath(uiPath, activityId)
  local uiRoot = "UI/Witches"
  local isWitchUIPath = not string.nilorempty(uiPath) and string.sub(uiPath, 1, #uiRoot) == uiRoot and (#uiPath == #uiRoot or string.sub(uiPath, #uiRoot + 1, #uiRoot + 1) == "/")
  if not isWitchUIPath then
    return uiPath
  end
  local currentParkMapCA = WitchData.GetParkMapCA(activityId)
  local seasonPath = currentParkMapCA and currentParkMapCA.seasonPath or ""
  seasonPath = string.gsub(seasonPath, "^/+", "")
  seasonPath = string.gsub(seasonPath, "/+$", "")
  if seasonPath == "" then
    return uiPath
  end
  local uiSuffix = string.sub(uiPath, #uiRoot + 1)
  return uiRoot .. "/" .. seasonPath .. uiSuffix
end

function WitchData.GetActivityUIPath(activityId)
  local currentActivityCA = WitchData.GetActivityCA(activityId)
  return currentActivityCA and currentActivityCA.showUI
end

function WitchData.GetWitchesData(activityId)
  activityId = getValidActivityId(activityId)
  local allWitchesData = PlayerData.ServerData.user_witches_all
  if allWitchesData ~= nil then
    local witchesData = allWitchesData[tostring(activityId)] or allWitchesData[activityId]
    if witchesData == nil then
      witchesData = {}
      allWitchesData[tostring(activityId)] = witchesData
    end
    if activityId == activeGameActivityId then
      PlayerData.ServerData.user_witches = witchesData
    end
    return witchesData
  end
  return PlayerData.ServerData.user_witches or {}
end

function WitchData.SetWitchesData(data, activityId)
  activityId = getValidActivityId(activityId)
  PlayerData.ServerData.user_witches_all = PlayerData.ServerData.user_witches_all or {}
  PlayerData.ServerData.user_witches_all[tostring(activityId)] = data
  if activityId == activeGameActivityId then
    PlayerData.ServerData.user_witches = data
  end
end

function WitchData.InitData(newData)
  local data = {}
  if newData.witches_id then
    data.witches_id = newData.witches_id
  end
  if newData.map then
    data.map = newData.map
  end
  if newData.ticket_id then
    data.ticket_id = newData.ticket_id
  end
  if newData.stamina then
    data.stamina = newData.stamina
  end
  if newData.stamina_max then
    data.stamina_max = newData.stamina_max
  end
  if newData.day_ticket then
    data.day_ticket = newData.day_ticket
  end
  if newData.revive then
    data.revive = newData.revive
  end
  if newData.user_loc then
    data.user_loc = newData.user_loc
  end
  if newData.float_loc then
    data.float_loc = newData.float_loc
  end
  if newData.float_route then
    data.float_route = newData.float_route
  end
  if newData.other_grid then
    data.other_grid = newData.other_grid
  end
  if newData.end_events then
    data.end_events = newData.end_events
  end
  if newData.user_seal then
    data.user_seal = newData.user_seal
  end
  if newData.other_seal then
    data.other_seal = newData.other_seal
  end
  if newData.witchItems then
    data.witchItems = newData.witchItems
  end
  if newData.guka then
    data.guka = newData.guka
  end
  if newData.wearing then
    data.wearing = newData.wearing
  end
  if newData.direction then
    data.direction = newData.direction
  end
  if newData.start_id then
    data.start_id = newData.start_id
  end
  if newData.temp_select then
    data.temp_select = newData.temp_select
  end
  if newData.buff then
    data.buff = newData.buff
  end
  if newData.coin then
    data.coin = newData.coin
  end
  if newData.guka_num then
    data.guka_num = newData.guka_num
  end
  if newData.effect_items then
    data.effect_items = newData.effect_items
  end
  if newData.npc_handbook then
    data.npc_handbook = newData.npc_handbook
  end
  if newData.seal_handbook then
    data.seal_handbook = newData.seal_handbook
  end
  if newData.boss_times then
    data.boss_times = newData.boss_times
  end
  if newData.boss_damage then
    data.boss_damage = newData.boss_damage
  end
  if newData.max_damage then
    data.max_damage = newData.max_damage
  end
  if newData.free_guka_refresh then
    data.free_guka_refresh = newData.free_guka_refresh
    local DataModel = require("UIGuKaHandbook/UIGuKaHandbookDataModel")
    DataModel.InitGuKaData()
    local num = DataModel.GuKaTotalCount == DataModel.GuKaUnlockCount and 1 or 0
    DataModel.InitSealData()
    num = num + (DataModel.SealTotalCount == DataModel.SealUnlockCount and 1 or 0)
    DataModel.InitEventData()
    num = num + (DataModel.EventTotalCount == DataModel.EventUnlockCount and 1 or 0)
    data.max_free_guka_refresh = num
  end
  if newData.pay_guka_refresh then
    data.pay_guka_refresh = newData.pay_guka_refresh
  end
  WitchData.SetWitchesData(data)
  this.inWitchMap = true
end

function WitchData.GetRewardSelectList()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.temp_select
end

function WitchData.GetItems()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.witchItems
end

function WitchData.RefreshGuKaData(items)
  local witchesData = WitchData.GetWitchesData()
  if not witchesData.guka then
    witchesData.guka = {}
  end
  for i, v in pairs(items) do
    witchesData.guka[i] = v
  end
end

function WitchData.RefreshCoinData(items)
  local witchesData = WitchData.GetWitchesData()
  local coin = witchesData.coin or 0
  for i, v in pairs(items) do
    coin = coin + v.num
  end
  witchesData.coin = coin
end

function WitchData.GetCoin()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.coin or 0
end

function WitchData.RefreshRewardItemData(itemId, itemData)
  local witchesData = WitchData.GetWitchesData()
  local itemCA = PlayerData:GetFactoryData(itemId)
  local parkMapCA = WitchData.GetParkMapCA()
  if itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\233\129\147\229\133\183" then
    if itemCA.parkItemType == "coin" then
      local coin = witchesData.coin or 0
      coin = coin + itemData.num
      witchesData.coin = coin
    elseif itemCA.parkItemType == "action" then
      local stamina = witchesData.stamina or 0
      stamina = stamina + itemData.num
      if stamina > witchesData.stamina_max then
        stamina = witchesData.stamina_max
      end
      witchesData.stamina = stamina
    elseif itemCA.parkItemType == "seal" then
      local seal = witchesData.user_seal or {}
      local otherSeal = witchesData.other_seal or {}
      if #seal < parkMapCA.sealNumMax then
        table.insert(seal, tostring(itemId))
      else
        table.insert(otherSeal, tostring(itemId))
      end
      witchesData.user_seal = seal
      witchesData.other_seal = otherSeal
    elseif itemCA.parkItemType == "gukaUpgrade" then
      local gukaNum = witchesData.guka_num or 0
      gukaNum = gukaNum + itemData.num
      witchesData.guka_num = gukaNum
    end
  elseif itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\229\143\175\228\189\191\231\148\168\233\129\147\229\133\183" then
    if not witchesData.witchItems then
      witchesData.witchItems = {}
    end
    local witchItems = this.GetItems()
    local data = witchItems[tostring(itemId)]
    if not data then
      witchItems[tostring(itemId)] = itemData
    else
      local num = itemData.num or 1
      data.num = data.num + num
    end
  end
end

function WitchData.MoveEndRefreshData()
  local witchesData = WitchData.GetWitchesData()
  witchesData.guka_num = 0
  witchesData.end_events = {}
  if witchesData.effect_items then
    for k, v in pairs(witchesData.effect_items) do
      if v.round then
        v.round = v.round - 1
        if v.round == 0 then
          witchesData.effect_items[k] = nil
        end
      end
    end
  end
end

function WitchData.GetRestBuffData()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.buff and witchesData.buff.rest
end

function WitchData.GetStamina()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.stamina or 0
end

function WitchData.GetStaminaMax()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.stamina_max or 0
end

function WitchData.SetStamina(num)
  local witchesData = WitchData.GetWitchesData()
  if num < 0 then
    num = 0
  end
  if num > witchesData.stamina_max then
    num = witchesData.stamina_max
  end
  witchesData.stamina = num
end

function WitchData.DealEventReduceStamina(eventId)
  local witchesData = WitchData.GetWitchesData()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  if eventCA.mod == "\233\173\148\229\165\179\229\175\185\232\175\157" and eventCA.actionReduceList > 0 then
    this.SetStamina(witchesData.stamina - eventCA.actionReduceList)
  end
  if UIManager:IsPanelOpened(WitchData.GetUIPath("UI/Witches/Main/WitchMain")) then
    local View = require("UIWitchMain/UIWitchMainView")
    View.Group_Stamina.Txt_Num:SetText(witchesData.stamina .. "/" .. witchesData.stamina_max)
  end
end

function WitchData.GetReviveNum()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.revive or 0
end

function WitchData.GetTicketTotalNum(activityId)
  local parkCA = WitchData.GetParkMapCA(activityId)
  local num = PlayerData:GetGoodsById(parkCA.ticketList[1].id).num
  num = num + PlayerData:GetGoodsById(parkCA.ticketBuyItem[1].id).num
  return num
end

function WitchData.GetDayBuyNum(activityId)
  local witchesData = WitchData.GetWitchesData(activityId)
  return witchesData.day_ticket or 0
end

function WitchData.GetDayRemainTicketBuyNum(activityId)
  local parkMapCA = WitchData.GetParkMapCA(activityId)
  local witchesData = WitchData.GetWitchesData(activityId)
  local dayBuyNum = witchesData and witchesData.day_ticket or 0
  return parkMapCA.ticketLimit - dayBuyNum
end

function WitchData.GetRemainBossBattleTimes()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.boss_times or 0
end

function WitchData.ReduceBossBattleTimes()
  local witchesData = WitchData.GetWitchesData()
  local times = witchesData.boss_times or 0
  if 0 < times then
    times = times - 1
  end
  witchesData.boss_times = times
end

function WitchData.GetHistoryBossDamageMax()
  local witchesData = WitchData.GetWitchesData()
  local curDamage = witchesData.max_damage or 0
  return curDamage
end

function WitchData.GetBossDamageMax()
  local witchesData = WitchData.GetWitchesData()
  local curDamage = witchesData.boss_damage and witchesData.boss_damage.damage_total or 0
  return curDamage
end

function WitchData.RefreshBossDamageMax(damage)
  local witchesData = WitchData.GetWitchesData()
  local curDamage = witchesData.boss_damage and witchesData.boss_damage.damage_total or 0
  if damage > curDamage then
    if not witchesData.boss_damage then
      witchesData.boss_damage = {}
    end
    witchesData.boss_damage.damage_total = damage
  end
end

function WitchData.IsJoin()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.ticket_id and witchesData.ticket_id ~= ""
end

function WitchData.IsSelectActionType()
  local witchesData = WitchData.GetWitchesData()
  return witchesData.stamina ~= -1
end

function WitchData.IsStaminaEnough(need)
  local witchesData = WitchData.GetWitchesData()
  return need <= witchesData.stamina
end

function WitchData.IsCanRevive()
  local parkCA = WitchData.GetParkMapCA()
  local witchesData = WitchData.GetWitchesData()
  local revive = witchesData.revive or 0
  return revive < parkCA.reviveLimit
end

function WitchData.ReqJoinActivity(itemId, useNum, limitItem, callBack)
  Net:SendProto("activity.req_join", function(json)
    if limitItem then
      PlayerData:RefreshUseItems({
        [tostring(limitItem)] = useNum
      })
    else
      PlayerData:RefreshUseItems({
        [tostring(itemId)] = useNum
      })
    end
    local witchesData = WitchData.GetWitchesData()
    if json.ticket_id then
      witchesData.ticket_id = json.ticket_id
    end
    if json.free_guka_refresh then
      witchesData.free_guka_refresh = json.free_guka_refresh
    else
      local num = 0
      local DataModel = require("UIGuKaHandbook/UIGuKaHandbookDataModel")
      DataModel.InitGuKaData()
      num = num + (DataModel.GuKaTotalCount == DataModel.GuKaUnlockCount and 1 or 0)
      DataModel.InitSealData()
      num = num + (DataModel.SealTotalCount == DataModel.SealUnlockCount and 1 or 0)
      DataModel.InitEventData()
      num = num + (DataModel.EventTotalCount == DataModel.EventUnlockCount and 1 or 0)
      witchesData.free_guka_refresh = num
      witchesData.max_free_guka_refresh = num
    end
    if json.pay_guka_refresh then
      witchesData.pay_guka_refresh = json.pay_guka_refresh
    else
      witchesData.pay_guka_refresh = WitchData.GetParkMapCA().payRefreshNum
    end
    if callBack then
      callBack(json)
    end
  end, WitchData.GetActivityId(), limitItem)
end

function WitchData.ReqBuyTicket(buyNum, callBack, activityId)
  activityId = tonumber(activityId) or WitchData.GetActivityId()
  local parkCA = WitchData.GetParkMapCA(activityId)
  Net:SendProto("activity.buy_ticket", function(json)
    local costInfo = parkCA.ticketCostList[1]
    PlayerData:RefreshUseItems({
      [costInfo.id] = costInfo.num * buyNum
    })
    local witchesData = WitchData.GetWitchesData(activityId)
    witchesData.day_ticket = witchesData.day_ticket or 0
    witchesData.day_ticket = witchesData.day_ticket + buyNum
    if callBack then
      callBack(json)
    end
  end, buyNum, activityId)
end

function WitchData.ReqSelectActionType(index, callBack)
  index = tonumber(index)
  local parkMapCA = WitchData.GetParkMapCA()
  local info = parkMapCA.initialEnergyList[index]
  local num = PlayerData:GetGoodsById(parkMapCA.extraEnergyCostList[1].id).num
  if num < info.extraCost then
    CommonTips.OpenWitchTip(80600488)
    return
  end
  Net:SendProto("activity.select_init", function(json)
    local witchesData = WitchData.GetWitchesData()
    witchesData.stamina = info.num
    witchesData.stamina_max = info.num
    if callBack then
      callBack(json)
    end
  end, index - 1, WitchData.GetActivityId())
end

WitchData.ELeftType = {
  Abandon = "abandon",
  Revive = "revive",
  Temp = "temp",
  Victory = "victory"
}

function WitchData.ReqLeftActivity(leftType, callBack)
  Net:SendProto("activity.left_func", function(json)
    local parkCA = WitchData.GetParkMapCA()
    local witchesData = WitchData.GetWitchesData()
    if leftType == this.ELeftType.Abandon then
      witchesData.ticket_id = ""
      witchesData.stamina = -1
    end
    if leftType == this.ELeftType.Revive then
      local revive = witchesData.revive + 1
      local costInfo = parkCA.reviveCost[revive]
      if costInfo then
        PlayerData:RefreshUseItems({
          [costInfo.id] = costInfo.num
        })
      end
      witchesData.stamina = parkCA.reviveAction
      witchesData.revive = revive
    end
    if callBack then
      callBack(json)
    end
  end, leftType, WitchData.GetActivityId())
end

function WitchData.GetDirection()
  return WitchData.GetWitchesData().direction
end

function WitchData.GetFloatLoc()
  local loc = WitchData.GetWitchesData().float_loc
  if loc ~= nil then
    loc = tonumber(loc)
  end
  return loc
end

function WitchData.SetFloatLoc(id)
  WitchData.GetWitchesData().float_loc = tostring(id)
end

function WitchData.GetUserSeal(index)
  return WitchData.GetWitchesData().user_seal[index]
end

function WitchData.GetSealCount()
  return table.count(WitchData.GetWitchesData().user_seal)
end

function WitchData.GetItemNumById(itemId)
  local witchesData = WitchData.GetWitchesData()
  local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not itemCA then
    return 0
  end
  if itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\233\129\147\229\133\183" or itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\229\177\128\229\134\133\228\187\163\229\184\129" then
    return witchesData[itemCA.parkItemType] or 0
  elseif itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\229\143\175\228\189\191\231\148\168\233\129\147\229\133\183" then
    local witchItems = this.GetItems()
    local data = witchItems[tostring(itemId)]
    return data and data.num or 0
  else
    return PlayerData:GetGoodsById(itemId).num
  end
end

function WitchData.RefreshUseItems(items)
  local witchesData = WitchData.GetWitchesData()
  for itemId, num in pairs(items) do
    local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
    if itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\233\129\147\229\133\183" then
      if witchesData[itemCA.parkItemType] then
        witchesData[itemCA.parkItemType] = witchesData[itemCA.parkItemType] - num
      end
    elseif itemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\229\143\175\228\189\191\231\148\168\233\129\147\229\133\183" then
      local witchItems = this.GetItems()
      if witchItems[tostring(itemId)] then
        local curNum = witchItems[tostring(itemId)].num - num
        if curNum <= 0 then
          witchItems[tostring(itemId)] = nil
        else
          witchItems[tostring(itemId)].num = curNum
        end
      end
    else
      PlayerData:RefreshUseItems({
        [itemId] = num
      })
    end
  end
end

function WitchData.IsEventNeedDeal(eventId)
  local witchesData = WitchData.GetWitchesData()
  if witchesData.end_events then
    for i, v in pairs(witchesData.end_events) do
      if tostring(eventId) == v then
        return false
      end
    end
  end
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  if eventCA.mod == "\233\173\148\229\165\179\229\175\185\232\175\157" then
    if #eventCA.rewardList > 0 or 0 < #eventCA.randomRewardList then
      return true
    elseif 0 < eventCA.actionReduceList then
      return true
    end
  end
  return false
end

function WitchData.IsInEndOverList(gridId, eventId)
  local witchesData = WitchData.GetWitchesData()
  local gridData = witchesData.map[tostring(gridId)]
  local eventCA = PlayerData:GetFactoryData(gridData.event, "MonopolyEventFactory")
  for i, v in ipairs(eventCA.overDialogList) do
    if v.id == tonumber(eventId) then
      return true
    end
  end
  return false
end

function WitchData.GetSealReward(reward)
  local items = reward.item or {}
  for i, v in pairs(items) do
    local itemCA = PlayerData:GetFactoryData(i, "ItemFactory")
    if itemCA.parkItemType == "seal" then
      return i
    end
  end
end

function WitchData.GetGukaUpgradeReward(reward)
  local items = reward.item or {}
  for i, v in pairs(items) do
    local itemCA = PlayerData:GetFactoryData(i, "ItemFactory")
    if itemCA.parkItemType == "gukaUpgrade" then
      return i
    end
  end
end

function WitchData.GetUpgradeGuKaList()
  local list = {}
  local witchesData = WitchData.GetWitchesData()
  for i, v in pairs(witchesData.guka) do
    if v.had == 1 then
      local cfg = PlayerData:GetFactoryData(i, "GuKaFactory")
      if v.lv < cfg.maxLv then
        table.insert(list, {
          id = i,
          lv = v.lv,
          maxLv = cfg.maxLv
        })
      end
    end
  end
  return list
end

function WitchData.OpenShowItem(reward, closeSealCallBack)
  local sealId = this.GetSealReward(reward)
  local gukaUpgradeId = this.GetGukaUpgradeReward(reward)
  if sealId then
    local function yesFun()
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/Seal"), nil, closeSealCallBack)
    end
    
    if table.count(reward.item) == 1 then
      yesFun()
    else
      reward.item[sealId] = nil
      CommonTips.OpenShowItem(reward, yesFun)
    end
  elseif gukaUpgradeId then
    local function yesFun()
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaUpgrade"))
    end
    
    if table.count(this.GetUpgradeGuKaList()) > 0 then
      if table.count(reward.item) == 1 then
        yesFun()
      else
        reward.item[gukaUpgradeId] = nil
        CommonTips.OpenShowItem(reward, yesFun)
      end
    elseif table.count(reward.item) > 1 then
      reward.item[gukaUpgradeId] = nil
      CommonTips.OpenShowItem(reward)
    end
  else
    CommonTips.OpenShowItem(reward)
  end
end

function WitchData.GetGridId()
  return this.gridId
end

function WitchData.SetGridId(gridId)
  this.gridId = tonumber(gridId)
end

function WitchData.GetGridData(gridId)
  local witchesData = WitchData.GetWitchesData()
  local data = witchesData.map[tostring(gridId)]
  return data
end

function WitchData.ClearData()
  this.gridId = nil
end

function WitchData.ResetData()
  this.inWitchMap = false
end

function WitchData.FinishClearData()
  local witchesData = WitchData.GetWitchesData()
  local guka = witchesData.guka
  local sealHandBook = witchesData.seal_handbook
  local npcHandbook = witchesData.npc_handbook
  local dayTicket = witchesData.day_ticket or 0
  local curSealEffect = WitchData.GetSealEffect(witchesData.user_seal)
  for i, id in ipairs(curSealEffect) do
    if sealHandBook[tostring(id)] == nil then
      sealHandBook[tostring(id)] = {read = 0}
    end
  end
  local data = {
    guka = guka,
    seal_handbook = sealHandBook,
    npc_handbook = npcHandbook,
    day_ticket = dayTicket
  }
  WitchData.SetWitchesData(data)
  this.inWitchMap = false
end

function WitchData.ReqDealBroomEvent(eventId, gridId, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.deal_witches_events", function(json)
    local gridData = witchesData.map[tostring(this.gridId)]
    if gridData then
      gridData.com = 1
    end
    if json.terminus_grid then
      this.SetGridId(json.terminus_grid)
    end
    if json.dialogEvent then
      this.start_id = json.dialogEvent
    end
    local end_events = witchesData.end_events or {}
    table.insert(end_events, tostring(eventId))
    witchesData.end_events = end_events
    WitchesMapDataModel:RefreshFloatInquiryRounds()
    if callBack then
      callBack(json)
    end
  end, eventId, gridId, WitchData.GetActivityId())
end

function WitchData.ReqDealEvent(eventId, callBack, sealId)
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.deal_witches_events", function(json)
    local end_events = witchesData.end_events or {}
    if eventCA.mod ~= "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
      table.insert(end_events, tostring(eventId))
    end
    witchesData.end_events = end_events
    if json.temp_select then
      witchesData.temp_select = json.temp_select
    end
    this.DealEventReduceStamina(eventId)
    if callBack then
      callBack(json)
    end
  end, eventId, nil, WitchData.GetActivityId(), sealId)
end

function WitchData.ReqEndOverEvent(eventId, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.com_grid", function(json)
    local gridData = witchesData.map[tostring(this.gridId)]
    if gridData then
      gridData.com = 1
    end
    local end_events = witchesData.end_events or {}
    table.insert(end_events, tostring(eventId))
    witchesData.end_events = end_events
    if callBack then
      callBack(json)
    end
  end, eventId, WitchData.GetActivityId())
end

function WitchData.ReqSelectShopItem(selectIndex, num, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.select_reward", function(json)
    if 0 < num then
      local data = witchesData.temp_select.shop[selectIndex]
      local eventCA = PlayerData:GetFactoryData(data.dialog_id, "MonopolyEventFactory")
      local goodInfo
      for i, v in ipairs(eventCA.goodsList) do
        if v.index == data.index then
          goodInfo = v
          break
        end
      end
      this.RefreshUseItems({
        [goodInfo.currencyId] = goodInfo.currencyNum
      })
      data.limit = data.limit - num
    else
      local gridData = witchesData.map[tostring(this.gridId)]
      gridData.com = 1
      witchesData.temp_select.shop = nil
    end
    if callBack then
      callBack(json)
    end
  end, "shop", selectIndex - 1, num, WitchData.GetActivityId())
end

function WitchData.ReqSelectResetBuff(selectIndex, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.select_reward", function(json)
    if not witchesData.buff then
      witchesData.buff = {}
    end
    local buffId = witchesData.temp_select.rest[selectIndex]
    witchesData.buff.rest = buffId
    witchesData.temp_select.rest = nil
    local gridData = witchesData.map[tostring(this.gridId)]
    gridData.com = 1
    if callBack then
      callBack(json)
    end
  end, "rest", selectIndex - 1, nil, WitchData.GetActivityId())
end

function WitchData.ReqSelectGuKa(selectIndex, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.select_reward", function(json)
    witchesData.temp_select.guka = nil
    local gridData = witchesData.map[tostring(this.gridId)]
    gridData.com = 1
    if callBack then
      callBack(json)
    end
  end, "guka", selectIndex - 1, nil, WitchData.GetActivityId())
end

function WitchData.ReqSelectItemGuKa(selectIndex, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.select_reward", function(json)
    witchesData.temp_select.item_guka = nil
    if callBack then
      callBack(json)
    end
  end, "item_guka", selectIndex - 1, nil, WitchData.GetActivityId())
end

function WitchData.ReqGiveUpBattle(eventId, levelId, callBack)
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.give_up_dialog", function(json)
    local end_events = witchesData.end_events or {}
    if eventCA.mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
      table.insert(end_events, tostring(eventId) .. ":" .. "lose")
    elseif eventCA.mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
      for i, v in ipairs(eventCA.levelIDList) do
        if v.id == levelId then
          table.insert(end_events, tostring(eventId) .. ":" .. tostring(i - 1) .. "lose")
          break
        end
      end
    end
    witchesData.end_events = end_events
    if callBack then
      callBack(json)
    end
  end, eventId, levelId, WitchData.GetActivityId())
end

function WitchData.ReqUseBroomItem(itemId, num, gridId, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.use_items", function(json)
    this.RefreshUseItems({
      [itemId] = num
    })
    if json.terminus_grid then
      this.SetGridId(json.terminus_grid)
    end
    if json.dialogEvent then
      this.start_id = json.dialogEvent
    end
    if callBack then
      callBack(json)
    end
  end, itemId, num, gridId, nil, nil, WitchData.GetActivityId())
end

function WitchData.ReqUseFastPassItem(itemId, num, eventId, levelId, callBack)
  local witchesData = WitchData.GetWitchesData()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  Net:SendProto("activity.use_items", function(json)
    if mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
      local end_events = witchesData.end_events or {}
      table.insert(end_events, tostring(eventId) .. "win")
      witchesData.end_events = end_events
      witchesData.start_id = ""
    elseif mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
      local index = 1
      for i, v in ipairs(eventCA.levelIDList) do
        if v.id == levelId then
          index = i
          break
        end
      end
      local end_events = witchesData.end_events or {}
      table.insert(end_events, tostring(eventId) .. tostring(index - 1) .. "win")
      witchesData.end_events = end_events
      witchesData.start_id = ""
    end
    this.RefreshUseItems({
      [itemId] = num
    })
    if callBack then
      callBack(json)
    end
  end, itemId, num, nil, eventId, levelId, WitchData.GetActivityId())
end

function WitchData.ReqBuyAndUseFastPassItem(buyType, eventId, levelId, callBack)
  local witchesData = WitchData.GetWitchesData()
  local parkMapCA = WitchData.GetParkMapCA()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  Net:SendProto("activity.buy_and_use_items", function(json)
    local buyFastPassItemInfo = parkMapCA.fastpassBattleItemCostList[1]
    local costItemId = buyFastPassItemInfo.id
    local costNum = buyFastPassItemInfo.num
    WitchData.RefreshUseItems({
      [costItemId] = costNum
    })
    if mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
      local end_events = witchesData.end_events or {}
      table.insert(end_events, tostring(eventId) .. "win")
      witchesData.end_events = end_events
      witchesData.start_id = ""
    elseif mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
      local index = 1
      for i, v in ipairs(eventCA.levelIDList) do
        if v.id == levelId then
          index = i
          break
        end
      end
      local end_events = witchesData.end_events or {}
      table.insert(end_events, tostring(eventId) .. tostring(index - 1) .. "win")
      witchesData.end_events = end_events
      witchesData.start_id = ""
    end
    if callBack then
      callBack(json)
    end
  end, buyType, eventId, levelId, WitchData.GetActivityId())
end

function WitchData.ReqUseItem(itemId, num, callBack)
  local witchesData = WitchData.GetWitchesData()
  Net:SendProto("activity.use_items", function(json)
    this.RefreshUseItems({
      [itemId] = num
    })
    local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
    if itemCA.playerParkItemType == "energizer" then
      this.SetStamina(witchesData.stamina + itemCA.parkEnergyNum)
    end
    if json.effect_items then
      witchesData.effect_items = json.effect_items
    end
    if json.grid_info then
      for k, v in pairs(json.grid_info) do
        if witchesData.map[k] then
          witchesData.map[k] = v
        end
      end
    end
    if json.temp_select then
      witchesData.temp_select = json.temp_select
    end
    if callBack then
      callBack(json)
    end
  end, itemId, num, nil, nil, nil, WitchData.GetActivityId())
end

function WitchData.GetSealEffectWeight(activityId)
  local legacySealEffectWeight = {
    ["11400422"] = 1000,
    ["11400421"] = 100,
    ["11400423"] = 10,
    ["11400424"] = 1
  }
  local sealEffectWeight = {}
  local singleSealList = WitchData.GetParkMapCA(activityId).singleSealList
  for i, v in ipairs(singleSealList) do
    local cfg = PlayerData:GetFactoryData(v.id)
    local itemId = tostring(cfg.itemId)
    local weight = tonumber(v.weight)
    if weight == nil or weight <= 0 then
      weight = legacySealEffectWeight[itemId] or 10 ^ (#singleSealList - i)
    end
    sealEffectWeight[itemId] = weight
  end
  return sealEffectWeight
end

function WitchData.GetSealEffect(sealList)
  local sealEffectWeight = WitchData.GetSealEffectWeight()
  local singleSealEffectList = {}
  local combineSealEffectList = {}
  local singleSeal = WitchData.GetParkMapCA().singleSealList
  for i, v in ipairs(singleSeal) do
    local cfg = PlayerData:GetFactoryData(v.id)
    singleSealEffectList[tostring(cfg.itemId)] = tostring(v.id)
  end
  local combineSeal = WitchData.GetParkMapCA().combineSealList
  for i, v in ipairs(combineSeal) do
    local weight = 0
    local combineCfg = PlayerData:GetFactoryData(v.id)
    local combineList = combineCfg.combineSeal
    for index, seal in ipairs(combineList) do
      local effectWeight = 0
      if sealEffectWeight and sealEffectWeight[tostring(seal.id)] then
        effectWeight = sealEffectWeight[tostring(seal.id)]
      end
      weight = weight + effectWeight
    end
    combineSealEffectList[tostring(weight)] = tostring(v.id)
  end
  local effectList = {}
  if table.count(sealList) == 4 then
    local weight = 0
    for i, v in ipairs(sealList) do
      local effectWeight = 0
      if sealEffectWeight and sealEffectWeight[tostring(v)] then
        effectWeight = sealEffectWeight[tostring(v)]
      end
      weight = weight + effectWeight
    end
    if combineSealEffectList[tostring(weight)] then
      table.insert(effectList, combineSealEffectList[tostring(weight)])
      return effectList
    end
  else
    for i, v in ipairs(sealList) do
      if singleSealEffectList[tostring(v)] then
        table.insert(effectList, singleSealEffectList[tostring(v)])
      end
    end
    return effectList
  end
  return effectList
end

function WitchData.GetRankDailyId()
  local activityRankList = WitchData.GetActivityCA().activityRankList or {}
  local info = activityRankList[2] or {}
  return info.id or 0
end

function WitchData.GetRankForeverId()
  local activityRankList = WitchData.GetActivityCA().activityRankList or {}
  local info = activityRankList[1] or {}
  return info.id or 0
end

function WitchData.GetSelfLevelTween(rankId)
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  if not rankCA then
    return ""
  end
  if #rankCA.gradeSectionList == 0 then
    return ""
  end
  local userLv = PlayerData:GetUserInfo().lv
  local minLv = 0
  for i, v in ipairs(rankCA.gradeSectionList) do
    if rankCA.sectionType == "onebased" then
      minLv = 1
    elseif i == 1 then
      minLv = 1
    else
      minLv = rankCA.gradeSectionList[i - 1].grade + 1
    end
    if userLv >= minLv and userLv <= v.grade then
      return minLv .. "-" .. rankCA.gradeSectionList[i].grade
    end
  end
end

return WitchData
