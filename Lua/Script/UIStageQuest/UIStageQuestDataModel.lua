local homeCommon = require("Common/HomeCommon")
local View = require("UIStageQuest/UIStageQuestView")
local DataModel = {
  TopList = {},
  InitConfig = {},
  CurrentData = {},
  QuestList = {},
  BattleList = {},
  CurrentInfo = {},
  MyOrderInfo = {},
  OtherOrderInfo = {},
  SpecialOrderInfo = {},
  RightList = {},
  TopIndex = nil,
  StageStateE = {
    lock = 1,
    finish = 2,
    receive = 3
  },
  CurrentStageState = 1,
  CurrentStageIndex = 1,
  CurrentStageMax = 1,
  CurrentOrderIndex = 0,
  CurrentOrderTab = 1,
  CurrentStageId = nil,
  TotalScoreInfo = {},
  ScoreInfo = {},
  TitleType = {
    Daily = 1,
    Stage = 2,
    Battle = 3,
    Order = 4
  },
  DailyStateE = {
    lock = 1,
    finish = 2,
    receive = 3
  },
  TitleChoose = nil,
  BattleCurrentNum = 0,
  OrderCanInviteFriendList = {},
  OrderChooseFriendList = {},
  CurrentSelectOrderUId = "",
  UnlockFormationList = {},
  CurrentOrderResetSelect = 1,
  UnlockOrderGridCount = 0,
  OrderBuffList = {},
  OrderGridCount = 9
}
DataModel.OrderType = {
  Single = 1,
  Team = 2,
  Special = 3
}
DataModel.OrderState = {
  None = 1,
  Doing = 2,
  Complete = 3,
  CanSubmit = 4,
  OutTime = 5
}
local defalutCA

function DataModel:SetScoreInfo()
  local comfortScore = 0
  local foodScore = 0
  local petScore = 0
  local plantScore = 0
  local playScore = 0
  local fishScore = 0
  local medicalScore = 0
  local coach = PlayerData.ServerData.user_home_info.coach
  local furniture = PlayerData.ServerData.user_home_info.furniture
  for k, v in pairs(coach) do
    for k1, v1 in pairs(v.location) do
      local tempfurniture = furniture[tostring(v1.id)]
      if tempfurniture then
        local furCA = PlayerData:GetFactoryData(tempfurniture.id)
        local scoresWithAllBuff = PlayerData.GetFurScoreWithAllBuff(v1.id, furCA.bag)
        comfortScore = comfortScore + scoresWithAllBuff.comfort
        foodScore = foodScore + scoresWithAllBuff.food
        petScore = petScore + scoresWithAllBuff.pet
        plantScore = plantScore + scoresWithAllBuff.plant
        playScore = playScore + scoresWithAllBuff.play
        fishScore = fishScore + scoresWithAllBuff.fish
        medicalScore = medicalScore + scoresWithAllBuff.medical
      end
    end
  end
  local nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  if nowActivity then
    local gradelList = require("UIGroup_EventWeek/WeekActivityData").GetGradelList(nowActivity)
    for i1, v1 in ipairs(gradelList) do
      local buffCfg = PlayerData:GetFactoryData(v1.id)
      if buffCfg.buffType == "endComfortGrade" then
        comfortScore = MathEx.roundToDecimalPlaces(comfortScore + comfortScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPlantGrade" then
        plantScore = MathEx.roundToDecimalPlaces(plantScore + plantScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endFishGrade" then
        fishScore = MathEx.roundToDecimalPlaces(fishScore + fishScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPetGrade" then
        petScore = MathEx.roundToDecimalPlaces(petScore + petScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endFoodGrade" then
        foodScore = MathEx.roundToDecimalPlaces(foodScore + foodScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPlayGrade" then
        playScore = MathEx.roundToDecimalPlaces(playScore + playScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "enMedicalGrade" then
        medicalScore = MathEx.roundToDecimalPlaces(medicalScore + medicalScore * buffCfg.param, 1)
      end
    end
  end
  local list = {}
  list.comfortScore = comfortScore
  list.foodScore = foodScore
  list.petScore = petScore
  list.plantScore = plantScore
  list.playScore = playScore
  list.fishScore = fishScore
  list.medicalScore = medicalScore
  list.comfort = comfortScore
  list.food = foodScore
  list.pet = petScore
  list.plant = plantScore
  list.play = playScore
  list.fish = fishScore
  list.medical = medicalScore
  return list
end

function DataModel:StageInit()
  DataModel.TopIndex = nil
  DataModel.TopList = {}
  DataModel.CurrentStageIndex = 1
  DataModel.CurrentStageMax = 1
  local StageQuestConfig = PlayerData:GetFactoryData(99900007).StageQuestConfig
  for k, v in pairs(StageQuestConfig) do
    local row = {}
    row.config = PlayerData:GetFactoryData(v.id)
    row.text = GetText(v.textId)
    row.id = v.id
    local stageId = row.config.stageQuestList[1].id
    row.level = PlayerData:GetFactoryData(stageId).unLockLv
    row.isHaveRed = DataModel:GetRedPoint(k, DataModel.TitleType.Stage)
    table.insert(DataModel.TopList, row)
  end
  DataModel.ScoreInfo = DataModel:SetScoreInfo()
  DataModel.TotalScoreInfo = homeCommon.GetTotalFurScoreInfo(-1)
  DataModel.tradeLv = PlayerData:GetHomeInfo().trade_lv or 0
  DataModel.nowGoodsNum = PlayerData:GetUserInfo().space_info.now_train_goods_num or 0
  DataModel.totalGoods = PlayerData.GetMaxTrainGoodsNum() or 0
  DataModel.passengerLv = PlayerData:GetHomeInfo().tran_lv or 0
  DataModel.passengersNum = PlayerData:GetCurPassengerNum() or 0
  DataModel.totalPassengersNum = PlayerData:GetMaxPassengerNum() or 0
  DataModel.comfortScore = math.floor(DataModel.ScoreInfo.comfortScore)
  DataModel.foodScore = math.floor(DataModel.ScoreInfo.foodScore)
  DataModel.petScore = math.floor(DataModel.ScoreInfo.petScore)
  DataModel.plantScore = math.floor(DataModel.ScoreInfo.plantScore)
  DataModel.entScore = math.floor(DataModel.ScoreInfo.playScore)
  DataModel.fishScore = math.floor(DataModel.ScoreInfo.fishScore)
  DataModel.compoundLv = PlayerData:GetHomeInfo().compound_lv or 0
  DataModel.industryLv = 0
  DataModel.disneylandLv = 0
  DataModel.islandLv = 0
  if PlayerData:GetHomeInfo().playground then
    DataModel.islandLv = CommonCoachData.GetCurPlaygroundServerInfo(87300002).lv
  end
  DataModel.prisonLv = PrisonData.GetPrisonLv() or 0
  DataModel.OrderBuffList = {}
  local nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  if next(nowActivity) ~= nil then
    local orderBuffList = require("UIGroup_EventWeek/WeekActivityData").GetOrderData(nowActivity)
    for i, v in pairs(orderBuffList) do
      DataModel.OrderBuffList[tostring(v.id)] = 1
    end
  end
end

function DataModel.Init()
  DataModel.TitleChoose = DataModel.TitleType.Daily
  DataModel:DailyInit()
  DataModel:BattleInit()
  DataModel.IsRefreshSatage = true
  Net:SendProto("quest.stage_quests", function(json)
    DataModel.StageInit()
    DataModel.IsRefreshSatage = false
  end)
end

function DataModel:BattleInit()
  local stageBattleLabel = PlayerData:GetFactoryData(99900001).stageBattleLabel
  for k, v in pairs(stageBattleLabel) do
    DataModel.BattleList[k] = {}
    DataModel.BattleList[k].nameText = GetText(v.nameText)
    DataModel.BattleList[k].desText = GetText(v.desText)
    DataModel.BattleList[k].nodeName = v.nodeName
    DataModel.BattleList[k].prefabPath = v.prefabPath
    View.Group_Battle.Group_Right[v.nodeName]:SetActive(false)
    local path = string.split(v.prefabPath, "/")[4]
    local modelPath = "UI" .. path .. "/UI" .. path .. "DataModel"
    local levelConfig = require(modelPath).GetConfig()
    local materialLevelGroupList = levelConfig.materialLevelGroupList
    DataModel.BattleList[k].modelPath = modelPath
    DataModel.BattleList[k].materialLevelTimes = levelConfig.materialLevelTimes
    local materialRefreshType = levelConfig.materialRefreshType
    local targetTime
    if materialRefreshType == "Week" then
      targetTime = TimeUtil:GetNextWeekTime(1, 5)
    else
      targetTime = TimeUtil:GetNextSpecialTimeStamp(5, 0, 0, TimeUtil:GetServerTimeStamp())
    end
    DataModel.BattleList[k].targetTime = targetTime
    DataModel.BattleList[k].data = {}
    for c, d in pairs(materialLevelGroupList) do
      local levelCA = PlayerData:GetFactoryData(d.id)
      local row = {}
      row.index = c
      row.id = d.id
      row.cost = levelCA.cost
      row.name = levelCA.name
      row.spineScale = levelCA.spineScale
      row.spineX = levelCA.spineX
      row.spineY = levelCA.spineY
      row.resDir = PlayerData:GetFactoryData(levelCA.bossViewId).resDir
      row.rewardViewList = levelCA.rewardViewList
      local isActivity = false
      row.openDay = levelCA.openDay
      row.minDay = nil
      if 0 < #levelCA.openDay then
        for m, n in pairs(levelCA.openDay) do
          if TimeUtil:CheckWDay(n.week, 5) == true then
            isActivity = true
            break
          end
          row.minDay = row.minDay == nil and n.week or math.min(row.minDay, n.week)
        end
      else
        isActivity = true
      end
      row.isActivity = isActivity
      row.isActivityInt = isActivity == true and 1 or 0
      row.closedTextId = levelCA.closedTextId
      table.insert(DataModel.BattleList[k].data, row)
    end
    table.sort(DataModel.BattleList[k].data, function(a, b)
      if a.isActivityInt == 0 and b.isActivityInt == 0 then
        if a.minDay == b.minDay then
          return a.index < b.index
        end
        return a.minDay < b.minDay
      end
      if a.isActivityInt == 1 and b.isActivityInt == 1 then
        return a.index < b.index
      end
      return a.isActivityInt > b.isActivityInt
    end)
  end
  DataModel.BattleLeftIndex = 1
  DataModel.BattleRightIndex = nil
  DataModel.ChooseLeftData = {}
end

function DataModel:DailyInit()
  local info = TimeUtil:GetDailyRefreshTimeHour()
  local targetTime = TimeUtil:GetNextSpecialTimeStamp(info.hour, info.minute, info.second)
  DataModel.DailyTargetTime = targetTime
  DataModel.TargetTimeCountDown = targetTime - TimeUtil:GetServerTimeStamp()
  DataModel.RewardShowIndex = nil
  DataModel.DailyQuestList = {}
  defalutCA = defalutCA or PlayerData:GetFactoryData(99900010)
  local dailyQuestList = defalutCA.dailyQuestList
  for k, v in pairs(dailyQuestList) do
    local row = {}
    row.index = k
    row.id = v.id
    local questCA = PlayerData:GetFactoryData(v.id)
    row.des = questCA.describe
    row.numMax = questCA.num
    row.numNow = 0
    row.isSwitchUI = questCA.isSwitchUI
    row.switchUI = questCA.switchUI
    row.switchParameter = questCA.switchParameter
    row.ap = questCA.rewardsList[1] and questCA.rewardsList[1].num or 0
    if questCA.isFURNQuest then
      row.type = PlayerData.GetQuestState(v.id)
      row.numMax = tonumber(questCA.conditionList[1].val)
      if row.type ~= 2 then
        local checkOk, numNow = homeCommon.CheckClientScoreQuest(DataModel.ScoreInfo, questCA)
        row.numNow = numNow
        row.type = EnumDefine.EQuestState.UnFinish
        if checkOk then
          row.type = EnumDefine.EQuestState.Finish
        end
      end
    else
      local type, numNow = PlayerData.GetQuestState(v.id)
      row.type = type
      row.numNow = numNow
    end
    if row.type == 0 or row.type == 3 then
      row.index = 200 + row.index
    elseif row.type == 1 then
      row.index = 100 + row.index
    elseif row.type == 2 then
      row.index = 300 + row.index
    end
    table.insert(DataModel.DailyQuestList, row)
  end
  table.sort(DataModel.DailyQuestList, function(a, b)
    return a.index < b.index
  end)
  DataModel.ApRewardList = {}
  DataModel.MaxApNum = 1
  for k, v in pairs(defalutCA.apRewardList) do
    local row = {}
    row.ap = v.ap
    row.id = v.id
    row.num = v.num
    row.state = DataModel:GetDailyRewardState(k)
    table.insert(DataModel.ApRewardList, row)
  end
  DataModel.MaxApNum = defalutCA.apRewardList[#DataModel.ApRewardList].ap
end

function DataModel.OrderInit()
  DataModel.CurrentSelectOrderUId = ""
  DataModel.CurrentOrderResetSelect = 1
  DataModel.UpdateOrderData()
  DataModel.InitUnlockFormationList()
end

function DataModel.UpdateOrderGridUnlockCount()
  DataModel.UnlockOrderGridCount = 0
  local list = PlayerData:GetFactoryData(99900134).repCountList
  local rep = PlayerData.ServerData.user_info.future_base_info.history_rep_num or 0
  local levelCount = table.count(list)
  for i = levelCount, 1, -1 do
    if rep >= list[i].repNum then
      DataModel.UnlockOrderGridCount = list[i].orderNum
      break
    end
  end
end

function DataModel.InitUnlockFormationList()
  DataModel.UnlockFormationList = {}
  local ownList = PlayerData.ServerData.formula_items or {}
  for k, v in pairs(ownList) do
    DataModel.UnlockFormationList[tostring(v)] = true
  end
end

function DataModel.UpdateOrderData()
  DataModel.MyOrderInfo = {}
  DataModel.OtherOrderInfo = {}
  DataModel.SpecialOrderInfo = {}
  local serverBaseData = PlayerData.ServerData.user_info.future_base_info
  local serverJoinMyData = PlayerData.ServerData.user_info.join_my_orders
  local serverJoinOtherData = PlayerData.ServerData.user_info.join_other_orders
  local activityData = PlayerData.ServerData.user_info.all_user_future_activity
  DataModel.UpdateOrderGridUnlockCount()
  View.Group_Order.Img_Bottom.Group_Reputation.Txt_Num:SetText(serverBaseData.history_rep_num or 0)
  for i = 1, DataModel.OrderGridCount do
    if serverBaseData.grad[tostring(i)] then
      local orderData = serverBaseData.grad[tostring(i)]
      local data = {
        id = orderData.order_id,
        uid = orderData.order_uid,
        isJoin = false,
        isFinish = false,
        team = {},
        endTime = -1,
        gridId = tostring(i),
        isOutTime = false
      }
      if serverJoinMyData[orderData.order_uid] then
        if serverJoinMyData[orderData.order_uid].end_ts < TimeUtil:GetServerTimeStamp() then
          data.isJoin = true
          data.isOutTime = true
          data.endTime = serverJoinMyData[orderData.order_uid].end_ts
          table.insert(DataModel.MyOrderInfo, data)
        elseif serverBaseData.rec_reward_orders and serverBaseData.rec_reward_orders[orderData.order_uid] ~= nil then
          table.insert(DataModel.MyOrderInfo, {})
        else
          data.isJoin = true
          data.endTime = serverJoinMyData[orderData.order_uid].end_ts
          table.insert(DataModel.MyOrderInfo, data)
          local orderCfg = PlayerData:GetFactoryData(orderData.order_id)
          if data.isJoin and orderCfg.isTeam then
            local requireCount = DataModel.GetOrderRequireCount(data.uid, data.id)
            local teamData = serverJoinMyData[orderData.order_uid]
            for uid, playerData in pairs(teamData.deliver_queue) do
              if PlayerData:GetUserInfo().uid ~= uid then
                local t = {
                  uid = uid,
                  avatar = playerData.avatar,
                  name = playerData.role_name,
                  rep = playerData.history_rep_num,
                  deliverCount = 0,
                  deliverPercent = 0
                }
                t.deliverCount = playerData.deliver_list and playerData.deliver_list[1].num or 0
                t.deliverPercent = t.deliverCount / requireCount
                table.insert(data.team, t)
              end
            end
            local curDeliver = DataModel.GetOrderDeliverCount(data.uid)
            local percent = curDeliver / requireCount
            if 1 <= percent then
              data.isFinish = true
            end
          end
        end
      else
        table.insert(DataModel.MyOrderInfo, data)
      end
    else
      table.insert(DataModel.MyOrderInfo, {})
    end
  end
  for i, v in pairs(serverJoinOtherData) do
    local data = {
      uid = i,
      id = v.order_id,
      team = {},
      endTime = v.end_ts,
      isFinish = false,
      isReward = false,
      isKick = false,
      myDeliverCount = 0
    }
    if serverBaseData.rec_reward_orders and serverBaseData.rec_reward_orders[data.uid] ~= nil then
      table.insert(DataModel.OtherOrderInfo, {})
    elseif data.endTime < TimeUtil:GetServerTimeStamp() then
      data.isOutTime = true
      table.insert(DataModel.OtherOrderInfo, data)
    else
      local requireCount = DataModel.GetOrderRequireCount(data.uid, data.id)
      local isInTeam = false
      for uid, playerData in pairs(v.deliver_queue) do
        if PlayerData:GetUserInfo().uid ~= uid then
          local t = {
            uid = uid,
            avatar = playerData.avatar,
            name = playerData.role_name,
            rep = playerData.history_rep_num,
            deliverCount = 0,
            deliverPercent = 0
          }
          t.deliverCount = playerData.deliver_list and playerData.deliver_list[1].num or 0
          t.deliverPercent = t.deliverCount / requireCount
          table.insert(data.team, t)
        else
          isInTeam = true
        end
      end
      data.isKick = not isInTeam
      if data.isKick and v.my_deliver_list and 0 < table.count(v.my_deliver_list) then
        data.myDeliverCount = v.my_deliver_list[1].num
      end
      local curDeliver = DataModel.GetOrderDeliverCount(data.uid)
      local percent = curDeliver / requireCount
      if 1 <= percent then
        data.isFinish = true
      end
      table.insert(DataModel.OtherOrderInfo, data)
    end
  end
  if table.count(DataModel.OtherOrderInfo) < DataModel.OrderGridCount then
    for i = table.count(DataModel.OtherOrderInfo) + 1, DataModel.OrderGridCount do
      table.insert(DataModel.OtherOrderInfo, {})
    end
  end
  for i, activity in pairs(activityData) do
    for j, orderData in pairs(activity.grad) do
      local data = {
        id = orderData.order_id,
        uid = orderData.order_uid,
        isJoin = serverJoinMyData[orderData.order_uid] ~= nil,
        isFinish = false,
        team = {},
        activityId = activity.activity_id,
        gridId = tostring(j)
      }
      if data.isJoin then
        data.endTime = serverJoinMyData[orderData.order_uid].end_ts
      end
      table.insert(DataModel.SpecialOrderInfo, data)
    end
  end
  if table.count(DataModel.SpecialOrderInfo) < DataModel.OrderGridCount then
    for i = table.count(DataModel.SpecialOrderInfo) + 1, DataModel.OrderGridCount do
      table.insert(DataModel.SpecialOrderInfo, {})
    end
  end
end

function DataModel.GetOrderReward(uid, id)
  local result = {}
  local orderCfg = PlayerData:GetFactoryData(id)
  local rewardList = orderCfg.rewardsList
  local factor = DataModel.GetOrderFactorValue(uid)
  local nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  local upOrderData = require("UIGroup_EventWeek/WeekActivityData").GetOrderData(nowActivity)
  local isUpOrder = upOrderData and upOrderData[id] ~= nil
  for i, v in ipairs(rewardList) do
    local num = v.num * factor * (isUpOrder and 1 + upOrderData[id].param or 1)
    num = math.floor(num + 0.5)
    table.insert(result, {
      id = v.id,
      num = num
    })
  end
  return result
end

function DataModel.GetOrderDeliverCount(uid)
  local result = 0
  if PlayerData.ServerData.user_info.join_my_orders[uid] then
    local deliverQueue = PlayerData.ServerData.user_info.join_my_orders[uid].deliver_queue
    for k, v in pairs(deliverQueue) do
      if v.deliver_list and 0 < table.count(v.deliver_list) then
        for index, data in ipairs(v.deliver_list) do
          result = result + data.num
        end
      end
    end
    return result
  end
  if PlayerData.ServerData.user_info.join_other_orders[uid] then
    local deliverQueue = PlayerData.ServerData.user_info.join_other_orders[uid].deliver_queue
    for k, v in pairs(deliverQueue) do
      if v.deliver_list and 0 < table.count(v.deliver_list) then
        for index, data in ipairs(v.deliver_list) do
          result = result + data.num
        end
      end
    end
    return result
  end
  return result
end

function DataModel.GetOrderRequireCount(uid, id)
  local result = 0
  local orderCfg = PlayerData:GetFactoryData(id)
  local factor = DataModel.GetOrderFactorValue(uid)
  for i, v in ipairs(orderCfg.requireItemList) do
    result = result + v.num
  end
  return result * factor
end

function DataModel.RefreshDeliverItems(deliverList)
  if not deliverList or table.count(deliverList) == 0 then
    return
  end
  for i, v in ipairs(deliverList) do
    local item = PlayerData:GetGoodsById(tostring(v.id))
    item.num = item.num - v.num
  end
end

function DataModel.GetOrderBuffValue(memberCount)
  local cfg = PlayerData:GetFactoryData(99900134)
  local buffList = cfg.teamBuff
  if buffList[memberCount] then
    return math.floor(buffList[memberCount].buff * 100)
  end
  return 0
end

function DataModel.RefreshInviteFriendData(serverData)
  DataModel.InviteFriendData = {}
  if not serverData or table.count(serverData) == 0 then
    return
  end
  for i, v in pairs(serverData) do
    local data = {
      uid = i,
      avatar = v.avatar,
      rep = v.history_rep_num,
      name = v.role_name
    }
    table.insert(DataModel.OrderCanInviteFriendList, data)
  end
end

function DataModel.GetOrderFactorValue(uid)
  if not uid then
    return 1
  end
  local strs = string.split(uid, "_")
  if table.count(strs) == 2 then
    local factorValue = tonumber(strs[2])
    return factorValue
  end
  return 1
end

function DataModel.CheckFormationUnlock(orderId)
  local orderCfg = PlayerData:GetFactoryData(orderId)
  local productionCfg = PlayerData:GetFactoryData(orderCfg.requireProduction)
  if productionCfg.unlock and productionCfg.unlock > 0 and not DataModel.UnlockFormationList[tostring(productionCfg.unlock)] then
    return false
  end
  return true
end

function DataModel.GetFormulaRequireItem(orderId)
  local orderCfg = PlayerData:GetFactoryData(orderId)
  local production = PlayerData:GetFactoryData(orderCfg.requireProduction)
  local formulaCfg = PlayerData:GetFactoryData(production.condition[1].id)
  if formulaCfg.drawForm and table.count(formulaCfg.drawForm) > 0 then
    return formulaCfg.drawForm
  else
    return {}
  end
end

function DataModel.IsOrderOwner(uid)
  if PlayerData.ServerData.user_info.join_my_orders[uid] then
    return true
  end
  return false
end

function DataModel.GetOrderInfo(index)
  index = index or DataModel.CurrentOrderIndex
  if DataModel.CurrentOrderTab == 1 then
    return DataModel.MyOrderInfo[index]
  elseif DataModel.CurrentOrderTab == 2 then
    return DataModel.OtherOrderInfo[index]
  else
    return DataModel.SpecialOrderInfo[index]
  end
end

function DataModel.GetOrderType(id)
  local orderCfg = PlayerData:GetFactoryData(id)
  if orderCfg.isTeam then
    return DataModel.OrderType.Team
  elseif orderCfg.isSpecial then
    return DataModel.OrderType.Special
  else
    return DataModel.OrderType.Single
  end
end

function DataModel.GetOrderState(index)
  local state = DataModel.OrderState.None
  local order
  if DataModel.CurrentOrderTab == 1 then
    order = DataModel.MyOrderInfo[index]
  elseif DataModel.CurrentOrderTab == 2 then
    order = DataModel.OtherOrderInfo[index]
  else
    order = DataModel.SpecialOrderInfo[index]
  end
  if not order then
    return state
  end
  if not order.isJoin and DataModel.CurrentOrderTab ~= 2 then
    return state
  end
  if order.isFinish or order.isKick then
    return DataModel.OrderState.Complete
  end
  local requireCount = DataModel.GetOrderRequireCount(order.uid, order.id)
  local curDeliver = DataModel.GetOrderDeliverCount(order.uid)
  local orderCfg = PlayerData:GetFactoryData(order.id)
  local haveNum = PlayerData:GetGoodsById(orderCfg.requireItemList[1].id).num or 0
  if requireCount >= curDeliver and 0 < haveNum then
    if not orderCfg.isTeam then
      return requireCount <= haveNum and DataModel.OrderState.CanSubmit or DataModel.OrderState.Doing
    else
      return DataModel.OrderState.CanSubmit
    end
  else
    return DataModel.OrderState.Doing
  end
end

function DataModel.CheckOrderCanRefresh(uid, id)
  if DataModel.CurrentOrderTab == 2 or DataModel.CurrentOrderTab == 3 then
    return false
  end
  local orderCfg = PlayerData:GetFactoryData(id)
  if orderCfg.isTeam then
    local curDeliverCount = DataModel.GetOrderDeliverCount(uid)
    if 0 < curDeliverCount then
      return false
    end
  end
  return true
end

function DataModel.CheckRedPoint(type)
  if type == "invite" then
    return PlayerData.ServerData.user_info.being_invite_data and table.count(PlayerData.ServerData.user_info.being_invite_data) > 0
  elseif type == "myOrder" then
    return
  end
end

function DataModel.UpdateApRewardList()
  for k, v in pairs(DataModel.ApRewardList) do
    if v.state == DataModel.DailyStateE.finish then
      PlayerData.ServerData.liveness_rewards[tostring(k - 1)] = TimeUtil:GetServerTimeStamp()
      v.state = DataModel:GetDailyRewardState(k, v.ap)
    end
  end
end

function DataModel:RefreshCurrentData(index)
  DataModel.TopIndex = index
  DataModel.CurrentStageId = nil
  DataModel.CurrentData = DataModel.TopList[DataModel.TopIndex]
  local stageQuestList = DataModel.CurrentData.config.stageQuestList
  local countUnLock = 0
  local countReceive = 0
  local nowIndex = 1
  for k, v in pairs(stageQuestList) do
    if PlayerData:GetStageQuest()[tostring(v.id)] then
      if PlayerData:GetStageQuest()[tostring(v.id)].status == 1 then
        countReceive = countReceive + 1
        nowIndex = k
      end
      countUnLock = countUnLock + 1
    end
  end
  DataModel.CurrentStageMax = countUnLock
  DataModel.CurrentStageIndex = nowIndex
  if nowIndex < countUnLock and countReceive == nowIndex then
    DataModel.CurrentStageIndex = nowIndex + 1
  end
end

function DataModel:RefreshStageInfo()
  local id = DataModel.CurrentData.config.stageQuestList[DataModel.CurrentStageIndex].id
  DataModel.CurrentStageId = id
  DataModel.CurrentData.isHaveRed = false
  local CA = PlayerData:GetFactoryData(id)
  DataModel.CurrentInfo = CA
  DataModel.CurrentStageNum = 0
  DataModel.CurrentStageState = DataModel.StageStateE.lock
  local list = CA.questList
  DataModel.QuestList = {}
  for k, v in pairs(list) do
    local row = {}
    row.index = k
    row.id = v.id
    local questCA = PlayerData:GetFactoryData(v.id)
    row.des = questCA.describe
    row.numMax = questCA.num
    row.numNow = 0
    row.rewardsList = questCA.rewardsList
    row.isSwitchUI = questCA.isSwitchUI
    row.switchUI = questCA.switchUI
    row.switchParameter = questCA.switchParameter
    if questCA.isFURNQuest then
      row.type = PlayerData.GetQuestState(v.id)
      row.numMax = tonumber(questCA.conditionList[1].val)
      if row.type ~= 2 then
        local checkOk, numNow = homeCommon.CheckClientScoreQuest(DataModel.ScoreInfo, questCA)
        row.numNow = numNow
        row.type = EnumDefine.EQuestState.UnFinish
        if checkOk then
          row.type = EnumDefine.EQuestState.Finish
          DataModel.CurrentData.isHaveRed = true
        end
      end
    else
      local type, numNow = PlayerData.GetQuestState(v.id)
      if type == EnumDefine.EQuestState.Finish then
        DataModel.CurrentData.isHaveRed = true
      end
      row.type = type
      row.numNow = numNow
    end
    if row.type == 2 then
      DataModel.CurrentStageNum = DataModel.CurrentStageNum + 1
    end
    if row.type == 0 then
      row.index = 200 + row.index
    end
    if row.type == 1 then
      row.index = 100 + row.index
    end
    if row.type == 2 then
      row.index = 300 + row.index
    end
    table.insert(DataModel.QuestList, row)
  end
  if DataModel.CurrentStageNum == table.count(DataModel.QuestList) then
    DataModel.CurrentStageState = DataModel.StageStateE.finish
    DataModel.CurrentData.isHaveRed = true
  end
  if PlayerData:GetStageQuest()[tostring(DataModel.CurrentStageId)] and PlayerData:GetStageQuest()[tostring(DataModel.CurrentStageId)].status == 1 then
    DataModel.CurrentStageState = DataModel.StageStateE.receive
    DataModel.CurrentData.isHaveRed = false
  end
  table.sort(DataModel.QuestList, function(a, b)
    return a.index < b.index
  end)
end

local ResList = {}

local function GetBattleInfoRed()
  local timeStemp = PlayerData:GetPlayerPrefs("int", "BattleInfoTimeStamp")
  if TimeUtil:GetServerTimeStamp() < TimeUtil:GetNextSpecialTimeStamp(5, 0, 0, timeStemp) then
    return false
  end
  local stageBattleLabel = PlayerData:GetFactoryData(99900001).stageBattleLabel
  for k, v in pairs(stageBattleLabel) do
    local path = string.split(v.prefabPath, "/")[4]
    local modelPath = "UI" .. path .. "/UI" .. path .. "DataModel"
    local modelData = require(modelPath)
    local materialLevelTimes = modelData.GetConfig().materialLevelTimes
    local currentNum = modelData.CurrentNum
    if 0 < materialLevelTimes - currentNum then
      return true
    end
  end
  return false
end

local function GetOrderInfoRed()
  local configCfg = PlayerData:GetFactoryData(99900134)
  local requireLv = configCfg.openlevel
  local playerLv = PlayerData:GetPlayerLevel()
  if requireLv > playerLv then
    return false
  end
  if DataModel.GetMyOrderRedPoint() == true then
    return true
  end
  if DataModel.GetInviteOrderRedPoint() == true then
    return true
  end
  if DataModel.GetActivityRedPoint() == true then
    return true
  end
  if DataModel.GetSpecialOrderRedPoint() == true then
    return true
  end
  return false
end

function DataModel.GetMyOrderRedPoint()
  local configCfg = PlayerData:GetFactoryData(99900134)
  local requireLv = configCfg.openlevel
  local playerLv = PlayerData:GetPlayerLevel()
  if requireLv > playerLv then
    return false
  end
  local timeStemp = PlayerData:GetPlayerPrefs("int", "OrderMyInfoTimeStamp")
  if timeStemp == 0 or timeStemp >= TimeUtil:GetFutureTimeByServerTimeStamp(1, 5) then
    return true
  end
  return false
end

function DataModel.GetInviteOrderRedPoint()
  local configCfg = PlayerData:GetFactoryData(99900134)
  local requireLv = configCfg.openlevel
  local playerLv = PlayerData:GetPlayerLevel()
  if requireLv > playerLv then
    return false
  end
  if PlayerData.ServerData.user_info.being_invite_data and table.count(PlayerData.ServerData.user_info.being_invite_data) > 0 then
    return true
  end
  return false
end

function DataModel.GetSpecialOrderRedPoint()
  local configCfg = PlayerData:GetFactoryData(99900134)
  local requireLv = configCfg.openlevel
  local playerLv = PlayerData:GetPlayerLevel()
  if requireLv > playerLv then
    return false
  end
  if PlayerData.ServerData.user_info.all_user_future_activity == nil or table.count(PlayerData.ServerData.user_info.all_user_future_activity) == 0 then
    return false
  end
  local timeStemp = PlayerData:GetPlayerPrefs("int", "OrderSpecialInfoTimeStamp")
  if timeStemp == 0 or timeStemp >= TimeUtil:GetNextWeekTime(1, 5) then
    return true
  end
  return false
end

function DataModel.GetActivityRedPoint()
  local configCfg = PlayerData:GetFactoryData(99900134)
  local requireLv = configCfg.openlevel
  local playerLv = PlayerData:GetPlayerLevel()
  if requireLv > playerLv then
    return false
  end
  if PlayerData.ServerData.user_info.all_user_future_activity == nil or table.count(PlayerData.ServerData.user_info.all_user_future_activity) == 0 then
    return false
  end
  local orderActivityRead = PlayerData:GetPlayerPrefs("string", "OrderActivityRead")
  if orderActivityRead == nil or orderActivityRead == "" then
    return true
  end
  local readList = Json.decode(orderActivityRead)
  if readList == nil or table.count(readList) == 0 then
    return true
  end
  for k, v in pairs(PlayerData.ServerData.user_info.all_user_future_activity) do
    if readList[tostring(v.activity_id)] == nil then
      return true
    end
  end
  return false
end

function DataModel:GetRedPoint(index, state)
  if state and state == DataModel.TitleType.Battle then
    return GetBattleInfoRed()
  end
  if state and state == DataModel.TitleType.Order then
    return GetOrderInfoRed()
  end
  if index == nil and state == nil and (GetBattleInfoRed() == true or GetOrderInfoRed() == true) then
    return true
  end
  if state and state == DataModel.TitleType.Order then
    return false
  end
  local StageQuestConfig = PlayerData:GetFactoryData(99900007).StageQuestConfig
  local RedNum = 0
  local TotalScoreInfo = homeCommon.GetTotalFurScoreInfo(-1)
  ResList = {}
  for k, v in pairs(StageQuestConfig) do
    local row = {}
    row.isHaveRed = false
    local stageQuestList = PlayerData:GetFactoryData(v.id).stageQuestList
    for k, v in pairs(stageQuestList) do
      if PlayerData:GetStageQuest()[tostring(v.id)] and PlayerData:GetStageQuest()[tostring(v.id)].status == 0 then
        local questList = PlayerData:GetFactoryData(v.id).questList
        local questMax = table.count(questList)
        local questFinsh = 0
        for k, v in pairs(questList) do
          local questCA = PlayerData:GetFactoryData(v.id)
          if questCA.isFURNQuest then
            row.type = PlayerData.GetQuestState(v.id)
            if row.type ~= EnumDefine.EQuestState.Receive then
              local checkOk = homeCommon.CheckClientScoreQuest(TotalScoreInfo, questCA)
              if checkOk then
                row.isHaveRed = true
                RedNum = RedNum + 1
                break
              end
            end
          else
            row.type = PlayerData.GetQuestState(v.id)
            if row.type == EnumDefine.EQuestState.Finish then
              row.isHaveRed = true
              RedNum = RedNum + 1
              break
            end
          end
          if row.type == EnumDefine.EQuestState.Receive then
            questFinsh = questFinsh + 1
          end
        end
        if questFinsh == questMax then
          row.isHaveRed = true
          RedNum = RedNum + 1
          break
        end
      end
    end
    table.insert(ResList, row)
  end
  if index and ResList[index] then
    return ResList[index].isHaveRed
  elseif state == DataModel.TitleType.Stage then
    return 0 < RedNum
  elseif state == DataModel.TitleType.Daily then
    RedNum = 0
  end
  defalutCA = defalutCA or PlayerData:GetFactoryData(99900010)
  local dailyQuestList = defalutCA.dailyQuestList
  for k, v in pairs(dailyQuestList) do
    local row = {}
    local questCA = PlayerData:GetFactoryData(v.id)
    if questCA.isFURNQuest then
      row.type = PlayerData.GetQuestState(v.id)
      if row.type ~= 2 then
        local checkOk, numNow = homeCommon.CheckClientScoreQuest(DataModel.ScoreInfo, questCA)
        if checkOk then
          RedNum = RedNum + 1
          break
        end
      end
    else
      local type, numNow = PlayerData.GetQuestState(v.id)
      if type == EnumDefine.EQuestState.Finish then
        RedNum = RedNum + 1
        break
      end
    end
  end
  local isReceiveAll = true
  for k, v in pairs(defalutCA.apRewardList) do
    if DataModel:GetDailyRewardState(k) == DataModel.DailyStateE.finish then
      isReceiveAll = false
      RedNum = RedNum + 1
      break
    end
    if DataModel:GetDailyRewardState(k) ~= DataModel.DailyStateE.receive then
      isReceiveAll = false
    end
  end
  if 0 < RedNum and isReceiveAll == false then
    return true
  end
  return false
end

function DataModel:GetDailyRewardState(index, row_ap)
  local ap = row_ap or defalutCA.apRewardList[tonumber(index)].ap
  if ap > PlayerData:GetDailyVitality() then
    return DataModel.DailyStateE.lock
  elseif PlayerData.ServerData.liveness_rewards == nil or table.count(PlayerData.ServerData.liveness_rewards) == 0 or PlayerData.ServerData.liveness_rewards[tostring(index - 1)] == nil then
    return DataModel.DailyStateE.finish
  else
    return DataModel.DailyStateE.receive
  end
end

function DataModel:GetRefreshDaily()
  if DataModel.DailyTargetTime and DataModel.DailyTargetTime < TimeUtil:GetServerTimeStamp() then
    return true
  end
  return false
end

function DataModel:GetRefreshBattle()
  local function callback()
    DataModel.BattleTargetTime = nil
    
    local stageBattleLabel = PlayerData:GetFactoryData(99900001).stageBattleLabel
    for k, v in pairs(stageBattleLabel) do
      local path = string.split(v.prefabPath, "/")[4]
      local modelPath = "UI" .. path .. "/UI" .. path .. "DataModel"
      local levelConfig = require(modelPath).GetConfig()
      local materialRefreshType = levelConfig.materialRefreshType
      local targetTime
      if materialRefreshType == "Week" then
        targetTime = TimeUtil:GetNextWeekTime(1, 5)
      else
        targetTime = TimeUtil:GetNextSpecialTimeStamp(5, 0, 0, TimeUtil:GetServerTimeStamp())
      end
      DataModel.BattleTargetTime = DataModel.BattleTargetTime == nil and targetTime or math.min(targetTime, DataModel.BattleTargetTime)
      DataModel.BattleList[k].targetTime = targetTime
    end
  end
  
  if not DataModel.BattleTargetTime or DataModel.BattleTargetTime < TimeUtil:GetServerTimeStamp() then
    callback()
    return true
  end
  return false
end

function DataModel:SetBattleLeftListIndex(index)
  index = index or 1
  DataModel.BattleLeftIndex = index
  local currentData = DataModel.BattleList[DataModel.BattleLeftIndex]
  DataModel.ChooseLeftData = currentData.data
  local modelPath = currentData.modelPath
  DataModel.BattleCurrentNum = require(modelPath).CurrentNum
end

return DataModel
