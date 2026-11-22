local View = require("UIBattleSkipTips/UIBattleSkipTipsView")
local DataModel = require("UIBattleSkipTips/UIBattleSkipTipsDataModel")
local Controller = {}

function Controller:Init()
  self.canArrestNum = nil
  View.ScrollGrid_Tab.grid.self:SetDataCount(table.count(PlayerData.ServerData.squad))
  Controller:ClickBtnTab(nil)
  View.ScrollGrid_Tab.grid.self:MoveToTop()
end

function Controller:SetElementTab(element, elementIndex)
  local Btn_Tab = element.Btn_Tab
  Btn_Tab:SetClickParam(elementIndex)
  if DataModel.curSquadIndex == elementIndex then
    Btn_Tab.Group_On.self:SetActive(true)
    Btn_Tab.Group_Off.self:SetActive(false)
  else
    Btn_Tab.Group_On.self:SetActive(false)
    Btn_Tab.Group_Off.self:SetActive(true)
  end
  local teamData = PlayerData.ServerData.squad[elementIndex]
  local teamName = teamData.name
  local squadTabData = PlayerData:GetFactoryData(99900001, "ConfigFactory").Squad[elementIndex]
  if teamData == nil or teamData.name == nil or teamData.name == "" then
    teamName = squadTabData.defaultSquadName
  end
  Btn_Tab.Group_Off.Txt_Name:SetText(teamName)
  Btn_Tab.Group_On.Txt_Name:SetText(teamName)
  Btn_Tab.Group_On.Txt_Num:SetText(9 < elementIndex and elementIndex or "0" .. elementIndex)
  Btn_Tab.Group_Off.Txt_Num:SetText(9 < elementIndex and elementIndex or "0" .. elementIndex)
end

function Controller:SetElementRole(element, elementIndex)
  local roleList = DataModel.curSquad.role_list
  local role = roleList[elementIndex]
  if role and role.id then
    element.Group_On.self:SetActive(true)
    element.Group_Off.self:SetActive(false)
    local roleId = role.id
    local roleData = PlayerData:GetRoleById(roleId)
    local roleCA = PlayerData:GetFactoryData(roleId, "UnitFactory")
    element.Group_On.Txt_Name:SetText(roleCA.name)
    element.Group_On.Txt_Lv:SetText("Lv." .. roleData.lv)
    element.Group_On.Img_Captain:SetActive(DataModel.curSquad.header == roleId)
    local viewId = roleData.current_skin[1]
    local viewCA = PlayerData:GetFactoryData(viewId, "UnitViewFactory")
    element.Group_On.Spine_Role:SetData(viewCA.resDir, "stand")
  else
    element.Group_On.self:SetActive(false)
    element.Group_Off.self:SetActive(true)
  end
end

function Controller:ClickBtnTab(elementIndex)
  if elementIndex then
    if elementIndex == DataModel.curSquadIndex then
      return
    end
  else
    elementIndex = DataModel.curSquadIndex
  end
  DataModel.curSquadIndex = elementIndex
  DataModel.curSquad = PlayerData.ServerData.squad[DataModel.curSquadIndex]
  View.Txt_Team:SetText(DataModel.curSquadIndex)
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
  View.Group_Team.StaticGrid_RoleList.grid.self:RefreshAllElement()
end

function Controller:StartSkipWin()
  local curSquadRoleCount = 0
  for index, role in ipairs(DataModel.curSquad.role_list) do
    if role and role.id then
      curSquadRoleCount = curSquadRoleCount + 1
    end
  end
  if curSquadRoleCount == 0 then
    CommonTips.OpenTips(80600066)
    return false
  end
  local levelId = PlayerData.BattleInfo.battleStageId
  if DataModel.Current == DataModel.Enum.College then
    levelId = DataModel.curLevelId
  end
  local levelCA = PlayerData:GetFactoryData(levelId)
  local levelType = 1
  if curSquadRoleCount < levelCA.minRoleNum then
    CommonTips.OpenTips(string.format(GetText(80601995), levelCA.minRoleNum))
    return false
  end
  if DataModel.curSquad.header == nil then
    CommonTips.OpenTips(80600176)
    return false
  end
  local is_line_fail
  if DataModel.level_key then
    local uid = string.split(DataModel.level_key, ":")[1]
    if uid ~= PlayerData:GetUserInfo().uid then
      is_line_fail = true
    end
  end
  if CommonTips.OpenBuyEnergyTips(levelId, nil, nil, is_line_fail) then
    return false
  end
  
  local function callBack()
    local minEnemyLevel = DataModel.minEnemyLevel
    if levelCA.saleLevelType == "pollute" or levelCA.saleLevelType == "twig" or levelCA.saleLevelType == "buoy" then
      local areaId = DataModel.areaId
      if areaId then
        local polluteData = PlayerData.pollute_areas[tostring(areaId)]
        local polluteNum = -1
        if polluteData and polluteData.po_curIndex ~= nil then
          polluteNum = math.ceil(polluteData.po_curIndex)
        end
        local areaCA = PlayerData:GetFactoryData(areaId)
        if areaCA then
          local polluteLvList = areaCA.polluteLvList[polluteNum + 1]
          if polluteLvList then
            minEnemyLevel = polluteLvList.polluteLvMin
          end
        end
      end
    end
    local correspondId = levelCA.CorrespondingList
    local correspondList = PlayerData:GetFactoryData(correspondId, "ListFactory")
    if correspondList ~= nil then
      local levelList
      if levelCA.saleLevelType == "Side" then
        levelList = correspondList.sideQuestList
      elseif levelCA.saleLevelType == "Daily" then
        levelList = correspondList.dayQuestList
      end
      for i = 1, #levelList do
        if levelList[i].id == levelCA.id then
          DataModel.enemyLevel = levelList[i].lv
        end
      end
    end
    local hero_list = {}
    DataModel.enemy_ids = Controller:GetWaves()
    hero_list.enemyIds = DataModel.enemy_ids
    hero_list.enemy_level_min = minEnemyLevel
    hero_list.enemy_level = DataModel.enemyLevel
    hero_list.level_progress = 1
    hero_list.duration_time = 0
    if levelCA.saleLevelType == "CubeRogue" then
      hero_list.role_info_list = PlayerData.BattleInfo.HpPercentList
      hero_list.level_progress = 0.1
    end
    local b_json = Json.encode(hero_list)
    Net:SendProto("battle.skip_battle", function(json)
      local MainDataModel = require("UIMainUI/UIMainUIDataModel")
      MainDataModel.CurBattleEventID = eventId
      PlayerData.TempCache.GuideNoUpdateLimitData[EnumDefine.GuideNoUpdateLimitDataEnum.LevelId] = levelId
      local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
      if DataModel.ttbId ~= nil then
        local itemCost = levelCA.itemCost
        if itemCost[1] then
          PlayerData:RefreshUseItems({
            [itemCost[1].id] = itemCost[1].num
          })
        end
      end
      if levelCA.mod == "\230\183\177\230\184\138\229\133\179\229\141\161" then
        local itemCost = levelCA.itemCost
        local itemMap = {}
        for i = 1, #itemCost do
          itemMap[itemCost[i].id] = itemCost[i].num
        end
        if table.count(itemMap) > 0 then
          PlayerData:RefreshUseItems(itemMap)
        end
      end
      if PlayerData.BattleCallBackPage == "UI/Chapter/Battle_Material/Battle_Material" then
        local UIBattle_MaterialDataModel = require("UIBattle_Material/UIBattle_MaterialDataModel")
        UIBattle_MaterialDataModel:BattleEndSetCurrentNum()
      end
      if PlayerData.BattleCallBackPage == "UI/Chapter/Battle_Material/Battle_EquipmentDay" then
        local UIBattle_EquipmentDayDataModel = require("UIBattle_EquipmentDay/UIBattle_EquipmentDayDataModel")
        UIBattle_EquipmentDayDataModel:BattleEndSetCurrentNum()
      end
      if PlayerData.BattleCallBackPage == "UI/Chapter/Battle_Material/Battle_EquipmentWeek" then
        local UIBattle_EquipmentWeekDataModel = require("UIBattle_EquipmentWeek/UIBattle_EquipmentWeekDataModel")
        UIBattle_EquipmentWeekDataModel:BattleEndSetCurrentNum()
      end
      
      local function cb()
        UIManager:GoBack()
        CommonTips.OpenShowItem(json.reward)
      end
      
      Controller:TryArrest(json.reward)
    end, levelId, DataModel.eventId, DataModel.curSquadIndex - 1, levelType, nil, DataModel.eventId and 1 or 0, DataModel.InitParams and DataModel.InitParams.EventIndex or nil, DataModel.InitParams and DataModel.InitParams.Sid or nil, DataModel.level_key, nil, DataModel.difficulty, DataModel.InitParams and DataModel.InitParams.areaId or nil, nil, DataModel.ttbSid, DataModel.ttbIndex, DataModel.ttbId, nil, nil, nil, DataModel.dialogId, DataModel.friendId, DataModel.gridId, PlayerData.BattleInfo.rbIndex, DataModel.csActivityId, DataModel.csIndex, nil, PlayerData.BattleInfo.activityId, DataModel.serverIdx, nil, 0, b_json, 0, 1, 0)
  end
  
  callBack()
end

function Controller:GetWaves()
  local levelId = PlayerData.BattleInfo.battleStageId
  local levelCA = PlayerData:GetFactoryData(levelId)
  local waves = {}
  if levelCA then
    local enemyWaveList = levelCA.enemyWaveList
    if enemyWaveList and 0 < #enemyWaveList then
      for index, value in ipairs(enemyWaveList) do
        local id = value.enemyWaveId
        table.insert(waves, id)
      end
    end
  end
  return table.concat(waves, ",")
end

function Controller:CheckCanArrest()
  local levelId = PlayerData.BattleInfo.battleStageId
  local levelCA = PlayerData:GetFactoryData(levelId)
  if levelCA.isCatchPrison == true then
    return false
  end
  if PlayerData.ServerData.user_prison_info == nil then
    return false
  end
  if self.canArrestNum == nil or DataModel.canArrestEnemy == nil then
    local arrestNum = 0
    local enemyIds = self:GetWaves()
    if enemyIds ~= nil then
      enemyIds = string.split(enemyIds, ",")
    end
    local bossMap = {}
    for i = 1, #enemyIds do
      local waveCA = PlayerData:GetFactoryData(enemyIds[i])
      for j = 1, #waveCA.enemyList do
        local enemyCA = PlayerData:GetFactoryData(waveCA.enemyList[j].id)
        local pNum = 0
        for k = 1, #enemyCA.prisonerDrop do
          local prisonerCA = PlayerData:GetFactoryData(enemyCA.prisonerDrop[k].id)
          if tonumber(prisonerCA.prisonerRarity) ~= 12601048 then
            pNum = pNum + 1
          elseif not self:IsPrisonerArrested(prisonerCA.id) and bossMap[prisonerCA.id] ~= true then
            pNum = pNum + 1
            bossMap[prisonerCA.id] = true
          end
        end
        arrestNum = arrestNum + pNum
      end
    end
    self.canArrestNum = arrestNum
  end
  return self.canArrestNum > 0, self.canArrestNum
end

function Controller:IsPrisonerArrested(id)
  for k, v in pairs(PlayerData.ServerData.user_prison_info.carrying_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  for k, v in pairs(PlayerData.ServerData.user_prison_info.prison_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  for k, v in pairs(PlayerData.ServerData.user_prison_info.temporary_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  return false
end

function Controller:GetPrisonerCellNum()
  local curNum = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  local maxNum = PrisonData.GetPrisonerBagMaxCapacity()
  return maxNum - curNum
end

function Controller:TryArrest(reward)
  local canArrest, arrestNum = self:CheckCanArrest()
  if not canArrest then
    UIManager:GoBack()
    CommonTips.OpenShowItem(reward)
    return
  end
  local itemId = PrisonData.GetPrisonCA().arrestItem
  local itemNum = PlayerData:GetGoodsById(itemId).num
  if itemNum <= 0 then
    local itemCA = PlayerData:GetFactoryData(itemId)
    CommonTips.OpenTips(string.format(GetText(80600149), itemCA.name))
    UIManager:GoBack()
    CommonTips.OpenShowItem(reward)
    return
  end
  if 0 >= self:GetPrisonerCellNum() then
    CommonTips.OpenTips(GetText(80600201))
    UIManager:GoBack()
    CommonTips.OpenShowItem(reward)
    return
  end
  arrestNum = math.min(arrestNum, itemNum)
  local enemyIds = self:GetWaves()
  UIManager:Open("UI/Prison/ArrestPrisoner/ArrestTips", Json.encode({
    maxNum = arrestNum,
    wave_list = enemyIds,
    arrestItem = itemId,
    isSkip = true,
    reward = reward
  }), function()
  end, function()
    UIManager:GoBack()
    CommonTips.OpenShowItem(reward)
  end)
end

return Controller
