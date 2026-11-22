local BtnItem = require("Common/BtnItem")
local View = require("UIBattle_Boss/UIBattle_BossView")
local DataModel = require("UIBattle_Boss/UIBattle_BossDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:ClickBattle()
  local row = DataModel.TurntableList[tonumber(DataModel.SelectIndex)]
  local levelId = row.levelId
  if PlayerData:GetGoodsById(row.itemCost[1].id).num < row.itemCost[1].num then
    local function callback()
      local json = {}
      
      json.shops = PlayerData.ServerData.shops
      json.shopId = 80300004
      if PlayerData.RechargeGoods == nil then
        Net:SendProto("shop.info", function(json)
          UIManager:Open("UI/Store/Store", Json.encode(json))
        end)
      else
        UIManager:Open("UI/Store/Store", Json.encode(json))
      end
    end
    
    CommonTips.OnPrompt(80607449, nil, nil, callback)
    return
  end
  if CommonTips.OpenBuyEnergyTips(levelId) then
    return
  end
  Controller:CloseChooseImgSelect()
  local status = {
    Current = "Chapter",
    squadIndex = PlayerData.BattleInfo.squadIndex,
    hasOpenThreeView = false,
    ttbSid = DataModel.StationId,
    ttbId = DataModel.TurntableCA.id,
    ttbIndex = DataModel.SelectIndex - 1
  }
  PlayerData.Last_Chapter_Parms = {
    turntableId = DataModel.TurntableCA.id,
    stationId = DataModel.StationId,
    index = DataModel.SelectIndex,
    isCityMapIn = true,
    isBossBattle = true,
    levelId = levelId,
    callBack = DataModel.CallBackParms
  }
  PlayerData.TempCache.EventIndex = nil
  PlayerData.BattleInfo.battleStageId = levelId
  PlayerData.BattleCallBackPage = "UI/Chapter/Battle_Boss/Battle_Boss"
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
end

function Controller:RefreshReward(element, elementIndex)
  local dropList = DataModel.dropList
  local dropInfo = dropList[elementIndex]
  BtnItem:SetItem(element.Group_Item, {
    id = dropInfo.id,
    num = ""
  })
  element.Group_Item.Btn_Item:SetClickParam(dropInfo.id)
  element.Group_FirstS:SetActive(dropInfo.isFirstS)
end

function Controller:AutoToPositioning(index, isFirst)
  local parentWidth = View.ScrollView_Select.Viewport.Content.self.Rect.sizeDelta.x / 2
  local parentWidth2 = View.ScrollView_Select.Viewport.Content.Group_Select.self.Rect.sizeDelta.x / 2
  local screenWidth = Screen.width / 5
  local pos = 0
  local dataCount = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self.DataCount
  if index > dataCount then
    if DataModel.isBattleEnd and isFirst then
      dataCount = DataModel:GetLevelIdIndex(DataModel.LastLevelId)
    end
    pos = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:GetChildByIndex(dataCount - 1)
  else
    pos = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:GetChildByIndex(index - 1)
  end
  pos = pos.transform.localPosition
  local x = parentWidth - parentWidth2 - screenWidth - pos.x
  local content = View.ScrollView_Select.Viewport.Content.self
  DOTweenTools.Kill(content.transform)
  DOTweenTools.DOLocalMoveCallback(content.transform, x, -pos.y, 0, 0.5)
end

function Controller:SetContentPosBegin()
  View.ScrollView_Select.self:SetContentAncoredPosValueChanged(function(pos)
    DataModel.TargetTransform = pos
    local content = View.Img_Bg
    local currentPosition = content.transform.localPosition
    local targetPos = Vector3(DataModel.TargetTransform.x, DataModel.TargetTransform.y, currentPosition.z)
    content.transform.localPosition = Vector3.MoveTowards(currentPosition, targetPos * DataModel.OffestNum, DataModel.SpeedNum * Time.fixedDeltaTime)
  end)
end

function Controller:ClickLevelBtn(index)
  if index == DataModel.SelectIndex and View.Group_Right.self.IsActive then
    return
  end
  local row = DataModel.TurntableList[index]
  if row == nil then
    return
  end
  if not row.playerLvAvailable then
    return
  end
  if row.isCan == false then
    CommonTips.OpenTips(80607403)
    return
  end
  View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Return:SetActive(true)
  View.Group_Right.self:SetActive(true)
  View.Btn_Abyss.self:SetActive(false)
  local user_info = PlayerData:GetUserInfo()
  local levelCA = PlayerData:GetFactoryData(row.levelId)
  if user_info.max_energy then
    View.Group_Right.Btn_Energy.Txt_Num:SetText(user_info.energy .. "/" .. user_info.max_energy or 0)
  else
    View.Group_Right.Btn_Energy.Txt_Num:SetText(user_info.energy or 0)
  end
  local element = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid[index]
  element.Img_Select:SetActive(true)
  Controller:CloseChooseImgSelect()
  local Group_Title = View.Group_Right.Group_Title
  Group_Title.Txt_Text:SetText(row.name)
  Group_Title.Txt_Index:SetText(row.index > 9 and row.index or "0" .. row.index)
  local levelNum = DataModel:GetCurrentLevelData(index - 1, row.levelCountMax)
  local levelProgress = PlayerData:GetPreciseDecimalFloor(levelNum / row.levelCountMax * 100, 1)
  Group_Title.Txt_Progress:SetText(levelProgress .. "%")
  local sideId = PlayerData:GetFactoryData(levelCA.bossId).sideId
  local iconPath = PlayerData:GetFactoryData(sideId).iconPath
  Group_Title.Img_Camp:SetSprite(iconPath)
  Group_Title.Btn_Mechanism.Txt_T:SetText(string.format(GetText(80607303), DataModel:GetMechanismNum(levelNum + 1)))
  local Group_Progress = View.Group_Right.Group_Progress
  Group_Progress.Txt_Num:SetText(DataModel:GetCurrentLevelData(index - 1, row.count) .. "/" .. row.count)
  local Group_Des = View.Group_Right.Group_Des
  Group_Des.Txt_Desc:SetText(row.description)
  local Group_Stage = Group_Title.Group_Stage
  for i = 0, 4 do
    local bar_name = "Img_Bar00"
    local obj = Group_Stage.Group_Bar[bar_name .. i]
    obj:SetActive(i < levelNum + 1)
  end
  local Group_Drop = View.Group_Right.Group_Drop
  local dropListNew = PlayerData:GetLevelDropList(levelCA)
  DataModel.dropList = dropListNew
  if row.firstPassAwardS and 0 < table.count(row.firstPassAwardS) then
    for k, v in pairs(row.firstPassAwardS) do
      local row = {}
      row.id = v.id
      row.num = v.num
      row.isFirstS = true
      table.insert(DataModel.dropList, k, row)
    end
  end
  Group_Drop.self:SetActive(false)
  if table.count(dropListNew) ~= 0 then
    Group_Drop.self:SetActive(true)
    Group_Drop.ScrollGrid_Item.grid.self:SetDataCount(table.count(dropListNew))
    Group_Drop.ScrollGrid_Item.grid.self:RefreshAllElement()
    Group_Drop.ScrollGrid_Item.grid.self:MoveToTop()
  end
  local Group_Fight = View.Group_Right.Group_Fight
  local Group_Item = View.Group_Right.Group_Item
  Group_Item.self:SetActive(false)
  if row.itemCost[1] then
    local num = row.itemCost[1].num
    local self_num = PlayerData:GetGoodsById(row.itemCost[1].id).num
    local iconPath = PlayerData:GetFactoryData(row.itemCost[1].id).iconPath
    Group_Fight.Btn_StartFight.Txt_Num:SetText(num)
    Group_Fight.Btn_StartFight.Txt_Num:SetColor(UIConfig.Color.White)
    if num > self_num then
      Group_Fight.Btn_StartFight.Txt_Num:SetColor(UIConfig.Color.Red)
    end
    Group_Fight.Btn_StartFight.Img_Icon:SetSprite(iconPath)
    Group_Item.self:SetActive(true)
    Group_Item.Txt_Num:SetText(self_num)
  end
  local Txt_RecoLevel = Group_Fight.Group_RecoLevel.Txt_RecoLevel
  if row.isEnemyLvEquilsPlayer then
    Txt_RecoLevel:SetText(string.format(GetText(80601531), PlayerData:GetUserInfo().lv))
  else
    Txt_RecoLevel:SetText(string.format(GetText(80601531), row.recomGrade))
  end
  Group_Fight.Group_Energy.Txt_Cost:SetText(row.energyEnd)
  Controller:AutoToPositioning(index)
  DataModel.SelectIndex = index
  View.Group_Best.self:SetActive(false)
  if PlayerData.ServerData.level_record and PlayerData.ServerData.level_record[tostring(row.levelId)] then
    local level_record = PlayerData.ServerData.level_record[tostring(row.levelId)].records
    View.Group_Best.self:SetActive(level_record ~= nil and 0 < #level_record)
    if level_record ~= nil and 0 < #level_record then
      local duration
      for i = 1, #level_record do
        if duration == nil then
          duration = level_record[i].duration
        else
          duration = math.min(duration, level_record[i].duration)
        end
      end
      local hours = math.floor(duration / 3600)
      local minutes = math.floor(duration % 3600 / 60)
      local remainingSeconds = math.floor(duration % 60)
      View.Group_Best.Txt_Time:SetText(string.format("%02d:%02d:%02d", hours, minutes, remainingSeconds))
      View.Group_Best.Btn_Check:SetClickParam(row.levelId)
      View.Group_Best.Btn_Reward:SetActive(0 < #row.timeReward)
      if 0 < #row.timeReward then
        Controller:RefreshClaimBtn(row.levelId, duration)
        View.Group_Best.Btn_Reward:SetClickParam(row.levelId)
      end
    end
  end
  View.Group_CommomBottomLeft:SetActive(false)
  local levelPlayerLvLimit = levelCA.playerLevel
  local isPlayerLvAvailable = levelPlayerLvLimit <= PlayerData:GetPlayerLevel()
  View.Group_Right.Group_Fight.Btn_StartFight:SetActive(isPlayerLvAvailable)
  View.Group_Right.Group_Fight.Group_Lock:SetActive(not isPlayerLvAvailable)
  if not isPlayerLvAvailable then
    View.Group_Right.Group_Fight.Group_Lock.Txt_T:SetText(string.format(GetText(80611295), levelPlayerLvLimit))
  end
end

function Controller:ClickBestBtn(str)
  local level_record = PlayerData.ServerData.level_record[str].records
  UIManager:Open("UI/Battle/PersonalLeaderboards/PersonalLeaderboards", Json.encode({resultList = level_record, levelId = str}))
end

function Controller:Init(index)
  DataModel.SelectIndex = nil
  DataModel.TurntableList = {}
  View.Group_Best.self:SetActive(false)
  View.Group_Right.self:SetActive(false)
  if DataModel.curPeriodId ~= nil then
    View.Btn_Abyss.self:SetActive(true)
    local starRed, rewardRed = PlayerData:GetAbyssRedPoint()
    View.Btn_Abyss.Img_Red:SetActive(starRed or rewardRed)
  end
  View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Return:SetActive(false)
  Controller:BuffListSwitch(false)
  View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:RefreshAllElement()
  if index then
    Controller:ClickLevelBtn(index)
  else
    local count = table.count(DataModel.BatterInfo)
    Controller:AutoToPositioning(count, true)
  end
  View.Img_Bg:SetLocalPosition(Vector3(0, 0, 0))
  DataModel.ListVerticalLayout = View.Group_BuffList.ScrollView_Buff.Viewport.Content.self:GetComponent(typeof(UI.VerticalLayoutGroup))
end

function Controller:OpenTimeRewardPage(str)
  View.Group_TimeReward.self:SetActive(true)
  local ca = PlayerData:GetFactoryData(str)
  View.Group_TimeReward.ScrollGrid_Level.grid.self:SetParentParam(str)
  View.Group_TimeReward.ScrollGrid_Level.grid.self:SetDataCount(#ca.timeReward)
  View.Group_TimeReward.ScrollGrid_Level.grid.self:RefreshAllElement()
  View.Group_TimeReward.ScrollGrid_Level.grid.self:MoveToTop()
end

function Controller:SetRewradParentGrid(element, elementIndex)
  local id = element.ParentParam
  local levelCA = PlayerData:GetFactoryData(id)
  local timeReward = levelCA.timeReward
  local data = timeReward[elementIndex]
  local time = data.time
  local min = math.floor(time / 60)
  local second = time % 60
  local groupTime
  local claimedRewards = PlayerData.ServerData.level_record[id].reward
  local isClaimed = false
  if claimedRewards ~= nil then
    for i = 1, #claimedRewards do
      if claimedRewards[i] + 1 == elementIndex then
        isClaimed = true
      end
    end
  end
  if isClaimed then
    element.Group_Complete:SetActive(true)
    element.Group_Can:SetActive(false)
    element.Group_Not:SetActive(false)
    groupTime = element.Group_Complete.Group_Time
  else
    element.Group_Complete:SetActive(false)
    local level_record = PlayerData.ServerData.level_record[id].records
    local duration
    for i = 1, #level_record do
      if duration == nil then
        duration = level_record[i].duration
      else
        duration = math.min(duration, level_record[i].duration)
      end
    end
    if time >= duration then
      element.Group_Not:SetActive(false)
      element.Group_Can:SetActive(true)
      element.Group_Can.Btn_Click:SetClickParam(id .. ":" .. elementIndex - 1)
      groupTime = element.Group_Can.Group_Time
    else
      element.Group_Not:SetActive(true)
      element.Group_Can:SetActive(false)
      groupTime = element.Group_Not.Group_Time
    end
  end
  groupTime.Txt_M:SetActive(0 < min)
  groupTime.Txt_Fen:SetActive(0 < min)
  if 0 < min then
    groupTime.Txt_M:SetText(min)
  end
  groupTime.Txt_S:SetText(second)
  local rewardsCA = PlayerData:GetFactoryData(data.id)
  element.ScrollGrid_Reward.grid.self:SetParentParam(data.id)
  element.ScrollGrid_Reward.grid.self:SetDataCount(#rewardsCA.rewardList)
  element.ScrollGrid_Reward.grid.self:RefreshAllElement()
  element.ScrollGrid_Reward.grid.self:MoveToTop()
end

function Controller:SetRewradGrid(element, elementIndex)
  local id = element.ParentParam
  local rewardsCA = PlayerData:GetFactoryData(id)
  local data = rewardsCA.rewardList[elementIndex]
  CommonItem:SetItem(element.Group_Item, {
    id = data.id,
    num = data.num
  })
end

function Controller:ClickClaimBtn(str)
  local params = string.split(str, ":")
  Net:SendProto("battle.dur_reward", function(json)
    local claimedRewards = PlayerData.ServerData.level_record[params[1]].reward
    if claimedRewards == nil then
      claimedRewards = {}
      PlayerData.ServerData.level_record[params[1]].reward = claimedRewards
    end
    PlayerData.ServerData.level_record[params[1]].reward[#claimedRewards + 1] = params[2]
    View.Group_TimeReward.ScrollGrid_Level.grid.self:RefreshAllElement()
    local level_record = PlayerData.ServerData.level_record[params[1]].records
    local duration
    for i = 1, #level_record do
      if duration == nil then
        duration = level_record[i].duration
      else
        duration = math.min(duration, level_record[i].duration)
      end
    end
    Controller:RefreshClaimBtn(params[1], duration)
    CommonTips.OpenShowItem(json.reward)
  end, params[1], params[2], DataModel.StationId)
end

function Controller:RefreshClaimBtn(levelId, duration)
  local row = PlayerData:GetFactoryData(levelId)
  local isRedFlag = false
  local claimedMap = {}
  local level_reward = PlayerData.ServerData.level_record[tostring(levelId)].reward or {}
  for i = 1, #level_reward do
    claimedMap[level_reward[i] + 1] = true
  end
  for i = 1, #row.timeReward do
    if claimedMap[i] ~= true then
      local time = row.timeReward[i].time
      if duration <= time then
        isRedFlag = true
        break
      end
    end
  end
  View.Group_Best.Btn_Reward.Img_Red:SetActive(isRedFlag)
end

function Controller:BuffListSwitch(type)
  View.Group_BuffList.self:SetActive(type)
  if type then
    Controller:RefreshBuffList()
  end
end

function Controller:RefreshBuffList(battleView)
  if battleView == nil then
    battleView = View
  end
  local row = DataModel.TurntableList[DataModel.SelectIndex]
  battleView.Group_BuffList.Txt_BossName:SetText(row.bossName)
  local lastSpace = 10
  local every_Txt_Base = 110
  local levelNum = DataModel:GetCurrentLevelData(DataModel.SelectIndex - 1, row.levelCountMax)
  local buffCA = PlayerData:GetFactoryData(row.buffId)
  local enemyBuffDesList = buffCA.enemyBuffDesList
  for i = 0, 4 do
    local buff_name = "Img_EnemyBuff00"
    local obj = battleView.Group_BuffList.ScrollView_Buff.Viewport.Content[buff_name .. i]
    local img_buff, img_ordinal = DataModel:GetBuffImg(i < levelNum + 1)
    obj:SetSprite(img_buff)
    obj.Group_Left.Img_Ordinal:SetSprite(img_ordinal)
    local data = enemyBuffDesList[i + 1]
    obj.Group_Left.Txt_Numeric:SetText(data.numericText)
    obj.Group_Left.Txt_Resistance:SetText(data.resistanceText)
    obj.Txt_Des:SetText(data.buffText)
    local height = obj.Txt_Des:GetHeight()
    if every_Txt_Base < height then
      local diff = height - every_Txt_Base
      lastSpace = lastSpace + diff
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(obj.Txt_Des.Rect)
    LayoutRebuilder.ForceRebuildLayoutImmediate(obj.Rect)
  end
  battleView.Group_BuffList.ScrollView_Buff:SetContentHeight(lastSpace)
  local Content = battleView.Group_BuffList.ScrollView_Buff.Viewport.Content
  Content.self:SetLocalPositionY(0)
  LayoutRebuilder.ForceRebuildLayoutImmediate(battleView.Group_BuffList.ScrollView_Buff.Rect)
end

function Controller:CloseChooseImgSelect()
  if DataModel.SelectIndex then
    local old_element = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid[DataModel.SelectIndex]
    if old_element then
      old_element.Img_Select:SetActive(false)
    end
  end
end

function Controller:RefreshAbyssTime()
  if DataModel.curPeriodId ~= nil then
    local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
    if not TimeUtil:IsActive(curPeriodCA.startTime, curPeriodCA.endTime) then
      DataModel.curPeriodId = nil
    end
  end
  if DataModel.curPeriodId == nil then
    local abyssCA = PlayerData:GetFactoryData(86600001)
    for i = 1, #abyssCA.abyssPeriodList do
      local periodCA = PlayerData:GetFactoryData(abyssCA.abyssPeriodList[i].id)
      if TimeUtil:IsActive(periodCA.startTime, periodCA.endTime) then
        DataModel.curPeriodId = periodCA.id
        break
      end
    end
  end
  local btn = View.ScrollView_Select.Viewport.Content.Group_Select.Btn_Abyss
  local starRed, rewardRed = PlayerData:GetAbyssRedPoint()
  btn.Img_Red:SetActive(starRed or rewardRed)
  if DataModel.curPeriodId == nil then
    btn.Txt_Time:SetText(GetText(80607793))
    View.Btn_Abyss:SetActive(false)
    return
  else
    View.Btn_Abyss.Img_Red:SetActive(starRed or rewardRed)
  end
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  local endTime = curPeriodCA.endTime
  local remainTime = TimeUtil:LastTime(endTime)
  local remainTable = TimeUtil:SecondToTable(remainTime)
  if btn ~= nil then
    if remainTable.day > 0 then
      btn.Txt_Time:SetText(string.format(GetText(80607764), remainTable.day, remainTable.hour))
    elseif 0 < remainTable.hour then
      btn.Txt_Time:SetText(string.format(GetText(80600007), remainTable.hour, remainTable.minute))
    else
      btn.Txt_Time:SetText(string.format(GetText(80600008), remainTable.minute))
    end
  end
end

function Controller:TryOpenAbyssPanel()
  if DataModel.curPeriodId == nil then
    return
  end
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  if curPeriodCA.openLv > PlayerData:GetUserInfo().lv then
    CommonTips.OpenTips(string.format(GetText(80607838), curPeriodCA.openLv))
    return
  end
  UIManager:Open("UI/Chapter/Battle_Abyss/Battle_Abyss", Json.encode({id = 86600001}))
end

return Controller
