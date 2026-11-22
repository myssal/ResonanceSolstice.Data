local View = require("UITeam_Cube/UITeam_CubeView")
local DataModel = require("UITeam_Cube/UITeam_CubeDataModel")
local autoBattle = require("UIAutoBattle/UIAutoBattleDataModel")
local autoBattleVF = require("UIAutoBattle/UIAutoBattleViewFunction")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local Controller = {}

function Controller:GetDataModel()
  return DataModel
end

function Controller:Init(isReopen)
  if isReopen ~= true then
    DataModel.curLevelIndex = -1
    DataModel.dragIdx = {}
    DataModel.roleCheckMap = {}
    DataModel.levelRoleList = {
      -1,
      -1,
      -1,
      -1,
      -1
    }
    DataModel.levelSquadIndex = -1
  end
  DataModel.AutoBattleData = nil
  if DataModel.mode ~= "InitCube" then
    local roleList = PlayerData.TempCache.CubeRogueData.deck
    for k in pairs(roleList) do
      Controller:AddRoleToTeam(k, true)
    end
    for i = 2, #DataModel.levelRoleList do
      if roleList[DataModel.levelRoleList[i]] ~= nil and roleList[DataModel.levelRoleList[i]].header == 1 then
        Controller:ExchangeSingleRole(1, 1, 1, i)
        break
      end
    end
  end
  local roleList1 = Controller:GetRoleIdNumberList()
  autoBattleVF.SetTeamData("Cube", roleList1, roleList1[1])
  DataModel.AutoBattleData = autoBattle.CurrentData
  self:InitFilterSetting()
  self:RefreshRoleListByFilter()
  DataModel.curSortType = nil
  DataModel.sortReverseMap = {
    [1] = false,
    [2] = false,
    [3] = false
  }
  self:SetRoleSortType(1, true)
  local squads = {}
  for i = 1, #PlayerData.ServerData.squad do
    if #PlayerData.ServerData.squad[i].role_list > 0 then
      squads[#squads + 1] = {
        idx = i,
        header = PlayerData.ServerData.squad[i].header,
        name = PlayerData.ServerData.squad[i].name
      }
      local roleList = {}
      for j = 1, #PlayerData.ServerData.squad[i].role_list do
        local roleId = PlayerData.ServerData.squad[i].role_list[j].id
        if roleId ~= nil then
          roleId = tostring(roleId)
          if roleId == PlayerData.ServerData.squad[i].header and 0 < #roleList then
            local firstId = roleList[1]
            roleList[1] = roleId
            roleList[#roleList + 1] = firstId
          else
            roleList[#roleList + 1] = roleId
          end
        end
      end
      squads[#squads].roleList = roleList
    end
  end
  DataModel.Squads = squads
  DataModel.selectMode = nil
  self:SetSelectMode(1)
  Controller:OnClickSelectLevel(1)
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
  View.Group_Select.Group_Check.Btn_Team:SetActive(DataModel.mode == "InitCube")
  View.Btn_Battle:SetActive(DataModel.mode == "InitCube" or DataModel.levelId ~= nil)
end

function Controller:GetRoleIdNumberList()
  local roleList1 = {}
  local roleList = DataModel.levelRoleList
  for j = 1, #roleList do
    roleList1[#roleList1 + 1] = tonumber(roleList[j])
  end
  return roleList1
end

function Controller:InitFilterSetting()
  DataModel.FilterMap = {
    Group_Career = {
      maxCount = 0,
      list = {}
    },
    Group_Group = {
      maxCount = 0,
      list = {}
    },
    Group_Rarity = {
      maxCount = 0,
      list = {}
    }
  }
  self:InitCareerGroup()
  self:InitCampGroup()
  self:InitRarityGroup()
end

function Controller:RefreshRoleListByFilter()
  DataModel.Roles = {}
  local roles = PlayerData.ServerData.roles
  if DataModel.mode ~= "InitCube" then
    roles = PlayerData.TempCache.CubeRogueData.roles
  end
  for k in pairs(roles) do
    local roleCA = PlayerData:GetFactoryData(k)
    if (not (table.count(DataModel.FilterMap.Group_Career.list) > 0) or DataModel.FilterMap.Group_Career.list[roleCA.line] == true) and (not (0 < table.count(DataModel.FilterMap.Group_Group.list)) or DataModel.FilterMap.Group_Group.list[PlayerData:SearchRoleCampInt(roleCA.sideId)] == true) and (not (0 < table.count(DataModel.FilterMap.Group_Rarity.list)) or DataModel.FilterMap.Group_Rarity.list[roleCA.qualityInt] == true) then
      table.insert(DataModel.Roles, tostring(k))
    end
  end
  local isFilterOn = false
  for k, v in pairs(DataModel.FilterMap) do
    if table.count(v.list) > 0 then
      isFilterOn = true
    end
  end
  local btnFilter = View.Group_Select.Group_RoleList.Btn_Screen
  btnFilter.Img_N:SetActive(not isFilterOn)
  btnFilter.Img_P:SetActive(isFilterOn)
end

function Controller:InitCareerGroup()
  local config = PlayerData:GetFactoryData(99900017).enumJobList
  local group = View.Screen_Chapter.Group_Career
  for k, v in pairs(group) do
    if k ~= "self" and k ~= "Txt_" and k ~= "Btn_All" then
      v.self:SetActive(false)
    end
  end
  local length = 0
  for k, v in pairs(config) do
    local btn = "Btn_C0" .. k
    local row = PlayerData:GetFactoryData(v.tagId)
    if group[btn] then
      group[btn].self:SetActive(true)
      group[btn].Txt_:SetText(row.tagName)
      group[btn]:SetClickParam(k)
      length = length + 1
    end
  end
  DataModel.FilterMap.Group_Career.maxCount = length
end

function Controller:InitCampGroup()
  local config = PlayerData:GetRoleCampFilterList()
  local group = View.Screen_Chapter.Group_Group
  for k, v in pairs(group) do
    if k ~= "self" and k ~= "Txt_" and k ~= "Btn_All" then
      v.self:SetActive(false)
    end
  end
  local length = 0
  for k, v in ipairs(config) do
    local btn = "Btn_G0" .. k
    if group[btn] then
      group[btn].self:SetActive(true)
      group[btn].Txt_:SetText(v.sideName)
      group[btn]:SetClickParam(k)
      length = length + 1
    end
  end
  DataModel.FilterMap.Group_Group.maxCount = length
end

function Controller:InitRarityGroup()
  local group = View.Screen_Chapter.Group_Rarity
  local length = 0
  for k, v in pairs(group) do
    if k ~= "self" and k ~= "Txt_" and k ~= "Btn_All" then
      length = length + 1
    end
  end
  for i = 1, length do
    local btn = "Btn_R0" .. i
    group[btn]:SetClickParam(i)
  end
  DataModel.FilterMap.Group_Rarity.maxCount = length
end

function Controller:AddFilterMap(btn, key, val)
  if DataModel.FilterMap[key].list[val] == true then
    DataModel.FilterMap[key].list[val] = nil
  else
    DataModel.FilterMap[key].list[val] = true
  end
  if table.count(DataModel.FilterMap[key].list) >= DataModel.FilterMap[key].maxCount then
    DataModel.FilterMap[key].list = {}
  end
  self:RefreshFilterBtn(key)
end

function Controller:OnClickBtnAll(key)
  DataModel.FilterMap[key].list = {}
  self:RefreshFilterBtn(key)
end

function Controller:RefreshFilterBtn(key)
  local group = View.Screen_Chapter[key]
  for i = 1, DataModel.FilterMap[key].maxCount do
    local btn
    if key == "Group_Rarity" then
      btn = "Btn_R0" .. i
    elseif key == "Group_Group" then
      btn = "Btn_G0" .. i
    elseif key == "Group_Career" then
      btn = "Btn_C0" .. i
    end
    group[btn].Img_Select:SetActive(DataModel.FilterMap[key].list[i] == true)
  end
  group.Btn_All.Img_Select:SetActive(table.count(DataModel.FilterMap[key].list) == 0)
end

function Controller:OpenRoleFilter()
  local oldFilterMap = {}
  for k, v in pairs(DataModel.FilterMap) do
    oldFilterMap[k] = Clone(v.list)
    self:RefreshFilterBtn(k)
  end
  DataModel.oldFilterMap = oldFilterMap
  View.Screen_Chapter:SetActive(true)
end

function Controller:ExitRoleFilter(isConfirm)
  if isConfirm ~= true then
    for k, v in pairs(DataModel.FilterMap) do
      v.list = DataModel.oldFilterMap[k]
    end
  end
  DataModel.oldFilterMap = nil
  View.Screen_Chapter:SetActive(false)
  self:RefreshRoleListByFilter()
  local sortType = DataModel.curSortType
  DataModel.curSortType = nil
  self:SetRoleSortType(sortType, true)
  local selectMode = DataModel.selectMode
  DataModel.selectMode = nil
  self:SetSelectMode(selectMode)
end

function Controller:SetRoleSortType(bType, isInit)
  if DataModel.curSortType ~= bType then
    DataModel.curSortType = bType
  else
    DataModel.sortReverseMap[bType] = not DataModel.sortReverseMap[bType]
  end
  self:RefreshBtnBySortType(View.Group_Select.Group_RoleList.Btn_Level, 1)
  self:RefreshBtnBySortType(View.Group_Select.Group_RoleList.Btn_Rarity, 2)
  self:RefreshBtnBySortType(View.Group_Select.Group_RoleList.Btn_Time, 3)
  if bType == 1 then
    self:SortRolesByLevel(DataModel.sortReverseMap[bType])
  elseif bType == 2 then
    self:SortRolesByQuality(DataModel.sortReverseMap[bType])
  elseif bType == 3 then
    self:SortRolesByObtainTime(DataModel.sortReverseMap[bType])
  end
  if isInit ~= true then
    View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  end
end

function Controller:RefreshBtnBySortType(btn, btnType)
  local curType = DataModel.curSortType
  btn.Img_DeP.self:SetActive(curType == btnType and not DataModel.sortReverseMap[btnType])
  btn.Img_DeN.self:SetActive(curType ~= btnType and not DataModel.sortReverseMap[btnType])
  btn.Img_AP.self:SetActive(curType == btnType and DataModel.sortReverseMap[btnType])
  btn.Img_AN.self:SetActive(curType ~= btnType and DataModel.sortReverseMap[btnType])
end

function Controller:SortRolesByLevel(isReverse)
  table.sort(DataModel.Roles, function(e1, e2)
    local roleData1 = PlayerData.ServerData.roles[e1]
    local roleData2 = PlayerData.ServerData.roles[e2]
    if roleData1.lv ~= roleData2.lv then
      return roleData1.lv > roleData2.lv
    end
    local roleCA1 = PlayerData:GetFactoryData(e1)
    local roleCA2 = PlayerData:GetFactoryData(e2)
    if roleCA1.qualityInt ~= roleCA2.qualityInt then
      return roleCA1.qualityInt > roleCA2.qualityInt
    end
    return tonumber(e1) > tonumber(e2)
  end)
  if isReverse then
    DataModel.Roles = ReverseTable(DataModel.Roles)
  end
end

function Controller:SortRolesByQuality(isReverse)
  table.sort(DataModel.Roles, function(e1, e2)
    local roleCA1 = PlayerData:GetFactoryData(e1)
    local roleCA2 = PlayerData:GetFactoryData(e2)
    if roleCA1.qualityInt ~= roleCA2.qualityInt then
      return roleCA1.qualityInt > roleCA2.qualityInt
    end
    local roleData1 = PlayerData.ServerData.roles[e1]
    local roleData2 = PlayerData.ServerData.roles[e2]
    if roleData1.lv ~= roleData2.lv then
      return roleData1.lv > roleData2.lv
    end
    return tonumber(e1) > tonumber(e2)
  end)
  if isReverse then
    DataModel.Roles = ReverseTable(DataModel.Roles)
  end
end

function Controller:SortRolesByObtainTime(isReverse)
  table.sort(DataModel.Roles, function(e1, e2)
    local roleData1 = PlayerData.ServerData.roles[e1]
    local roleData2 = PlayerData.ServerData.roles[e2]
    if roleData1.obtain_time ~= roleData2.obtain_time then
      return roleData1.obtain_time > roleData2.obtain_time
    end
    if roleData1.lv ~= roleData2.lv then
      return roleData1.lv > roleData2.lv
    end
    local roleCA1 = PlayerData:GetFactoryData(e1)
    local roleCA2 = PlayerData:GetFactoryData(e2)
    if roleCA1.qualityInt ~= roleCA2.qualityInt then
      return roleCA1.qualityInt > roleCA2.qualityInt
    end
    return tonumber(e1) > tonumber(e2)
  end)
  if isReverse then
    DataModel.Roles = ReverseTable(DataModel.Roles)
  end
end

function Controller:SetSelectMode(mode)
  if DataModel.selectMode == mode then
    return
  end
  local groupCheck = View.Group_Select.Group_Check
  groupCheck.Btn_Role.Group_On.self:SetActive(mode == 1)
  groupCheck.Btn_Role.Group_Off.self:SetActive(mode ~= 1)
  groupCheck.Btn_Team.Group_On.self:SetActive(mode == 2)
  groupCheck.Btn_Team.Group_Off.self:SetActive(mode ~= 2)
  DataModel.selectMode = mode
  if DataModel.selectMode == 1 then
    self:UpdateRoleList()
  elseif DataModel.selectMode == 2 then
    self:UpdateTeamList()
  end
end

function Controller:UpdateRoleList()
  View.Group_Select.Group_RoleList.self:SetActive(true)
  View.Group_Select.Group_TeamList.self:SetActive(false)
  View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:SetDataCount(#DataModel.Roles)
  View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:MoveToTop()
end

function Controller:OnSetRoleGrid(element, elementIndex)
  local roleId = DataModel.Roles[elementIndex]
  self:SetRoleGrid(element, roleId)
end

function Controller:SetRoleGrid(element, roleId)
  local roleData = PlayerData.ServerData.roles[roleId]
  if roleData == nil then
    return
  end
  element.Txt_Lv:SetText(string.format(GetText(80601968), roleData.lv))
  local currentSkin = roleData.current_skin[1]
  local viewCA = PlayerData:GetFactoryData(currentSkin, "UnitViewFactory")
  if element.Img_Head == nil then
    element.Img_Mask.Img_Head:SetSprite(viewCA.face)
  else
    element.Img_Head:SetSprite(viewCA.face)
  end
  local roleCA = PlayerData:GetFactoryData(roleId)
  if element.Txt_Name then
    element.Txt_Name:SetText(roleCA.name)
  end
  if DataModel.roleCheckMap[roleId] ~= nil then
    element.Group_InTeam:SetActive(true)
    local teamIdx = DataModel.roleCheckMap[roleId].team
    element.Group_InTeam.Txt_Team:SetText(string.format(GetText(80607584), 1))
    if element.Group_Bg ~= nil then
      element.Group_Bg.Img_1:SetActive(teamIdx == 1)
      element.Group_Bg.Img_2:SetActive(teamIdx == 2)
    end
  else
    element.Group_InTeam:SetActive(false)
    if element.Group_Bg ~= nil then
      element.Group_Bg.Img_1:SetActive(false)
      element.Group_Bg.Img_2:SetActive(false)
    end
  end
  if element.Btn_Click ~= nil then
    element.Btn_Click:SetClickParam(roleId)
  end
end

function Controller:OnClickRoleBtn(roleId, notSave)
  local teamIndex = DataModel.curLevelIndex
  local curRoleTeam = DataModel.roleCheckMap[roleId]
  local curTeamIndex
  if curRoleTeam ~= nil then
    curTeamIndex = curRoleTeam.team
    self:RemoveRoleToTeam(roleId, notSave)
  end
  if teamIndex ~= -1 and curTeamIndex ~= teamIndex then
    self:AddRoleToTeam(roleId, notSave)
  end
  if DataModel.selectMode == 1 then
    View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  elseif DataModel.selectMode == 2 then
    View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:RefreshAllElement()
  end
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
end

function Controller:AddRoleToTeam(roleId, notSave)
  local tRoleList = DataModel.levelRoleList
  local order
  for i = 1, #tRoleList do
    if tRoleList[i] == -1 then
      tRoleList[i] = roleId
      order = i
      break
    end
  end
  if order == nil then
    return
  end
  DataModel.isDataChange = true
  DataModel.roleCheckMap[roleId] = {team = 1, idx = order}
  DataModel.levelSquadIndex = -1
  if DataModel.AutoBattleData ~= nil then
    autoBattle:AddCardsByUnitId(DataModel.AutoBattleData, tonumber(roleId))
    if notSave ~= true then
      local str = Json.encode(DataModel.AutoBattleData)
      local autoKey = "CardAIDataCube"
      PlayerData:SetPlayerPrefs("string", autoKey, str, true)
      local cData = autoBattleVF:GetCloudData(autoKey)
      if cData.is_open and cData.is_open == "1" then
        autoBattleVF:SaveCloudData(autoKey, str)
      end
    end
  end
end

function Controller:RemoveRoleToTeam(roleId, notSave)
  local curTeam = DataModel.roleCheckMap[roleId]
  if curTeam ~= nil then
    DataModel.isDataChange = false
    local curRoleList = DataModel.levelRoleList
    curRoleList[curTeam.idx] = -1
    DataModel.roleCheckMap[roleId] = nil
    DataModel.levelSquadIndex = -1
    if DataModel.AutoBattleData ~= nil then
      autoBattle:RemoveCardsByUnitId(DataModel.AutoBattleData, tonumber(roleId))
      if notSave ~= true then
        local str = Json.encode(DataModel.AutoBattleData)
        local autoKey = "CardAIDataCube"
        PlayerData:SetPlayerPrefs("string", autoKey, str, true)
        local cData = autoBattleVF:GetCloudData(autoKey)
        if cData.is_open and cData.is_open == "1" then
          autoBattleVF:SaveCloudData(autoKey, str)
        end
      end
    end
  end
end

function Controller:ExchangeSingleRole(fromTeam, fromIndex, toTeam, toIndex)
  local fromRoleId = DataModel.levelRoleList[fromIndex]
  local toRoleId = DataModel.levelRoleList[toIndex]
  if fromRoleId ~= -1 and toRoleId ~= -1 then
    DataModel.isDataChange = true
  else
    DataModel.isDataChange = false
  end
  DataModel.levelRoleList[toIndex] = fromRoleId
  if fromRoleId ~= -1 then
    DataModel.roleCheckMap[fromRoleId] = {team = toTeam, idx = toIndex}
  end
  DataModel.levelRoleList[fromIndex] = toRoleId
  if toRoleId ~= -1 then
    DataModel.roleCheckMap[toRoleId] = {team = fromTeam, idx = fromIndex}
  end
  DataModel.levelSquadIndex = -1
  if DataModel.selectMode == 1 then
    View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  elseif DataModel.selectMode == 2 then
    View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:RefreshAllElement()
  end
end

function Controller:UpdateTeamList()
  View.Group_Select.Group_RoleList.self:SetActive(false)
  View.Group_Select.Group_TeamList.self:SetActive(true)
  View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:SetDataCount(#DataModel.Squads)
  View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:RefreshAllElement()
  View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:MoveToTop()
end

function Controller:OnSetTeamGrid(element, elementIndex)
  local teamData = DataModel.Squads[elementIndex]
  if teamData.name == nil or teamData.name == "" then
    local squadTabData = PlayerData:GetFactoryData(99900001, "ConfigFactory").Squad[teamData.idx]
    element.Txt_Name:SetText(squadTabData.defaultSquadName)
  else
    element.Txt_Name:SetText(teamData.name)
  end
  element.StaticGrid_Role.grid.self:SetParentParam(elementIndex)
  element.StaticGrid_Role.grid.self:SetDataCount(#teamData.roleList)
  element.StaticGrid_Role.grid.self:RefreshAllElement()
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:OnSetTeamRoleGrid(element, elementIndex)
  local teamData = DataModel.Squads[tonumber(element.ParentParam)]
  local roleId = teamData.roleList[elementIndex]
  self:SetRoleGrid(element, roleId)
end

function Controller:OnClickTeamBtn(str)
  local curSquadIndex = DataModel.levelSquadIndex
  self:ClearTeamByIndex(true)
  local squadIndex = tonumber(str)
  if curSquadIndex == squadIndex then
    DataModel.levelSquadIndex = -1
  else
    local teamData = DataModel.Squads[squadIndex]
    for i = 1, #teamData.roleList do
      self:OnClickRoleBtn(teamData.roleList[i], true)
    end
    DataModel.levelSquadIndex = squadIndex
  end
  local autoKey = "CardAIData" .. DataModel.Squads[squadIndex].idx
  local dataStr = PlayerData:GetPlayerPrefs("string", autoKey, true)
  local cData = autoBattleVF:GetCloudData(autoKey)
  if cData.is_open and cData.is_open == "1" then
    local cStr = autoBattleVF:GetCloudStr(autoKey)
    dataStr = cStr
  end
  if dataStr ~= nil and 1 <= string.getLength(dataStr) then
    local Data = Json.decode(dataStr)
    if Data.discardType == nil then
      Data.discardType = autoBattle.DefaultValue.discardType
    end
    if Data.keepCardNum == nil then
      Data.keepCardNum = autoBattle.DefaultValue.keepCardNum
    end
    if Data.otherCard == nil then
      Data.otherCard = autoBattle.DefaultValue.otherCard
    end
    if Data.cardList == nil then
      Data.cardList = {}
    end
    if Data.cardIdMap == nil then
      Data.cardIdMap = {}
    end
    DataModel.AutoBattleData = Data
    local autoStr = Json.encode(DataModel.AutoBattleData)
    local tKey = "CardAIDataCube"
    PlayerData:SetPlayerPrefs("string", tKey, autoStr, true)
    local cData = autoBattleVF:GetCloudData(tKey)
    if cData.is_open and cData.is_open == "1" then
      autoBattleVF:SaveCloudData(tKey, autoStr)
    end
  end
  if DataModel.selectMode == 2 then
    View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:RefreshAllElement()
  end
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
end

function Controller:ClearTeamByIndex(notSave)
  local curTeam = DataModel.levelRoleList
  for i = 1, #curTeam do
    self:RemoveRoleToTeam(curTeam[i], true)
  end
  if notSave ~= true then
    local autoStr = Json.encode(DataModel.AutoBattleData)
    local tKey = "CardAIDataCube"
    PlayerData:SetPlayerPrefs("string", tKey, autoStr, true)
    local cData = autoBattleVF:GetCloudData(tKey)
    if cData.is_open and cData.is_open == "1" then
      autoBattleVF:SaveCloudData(tKey, autoStr)
    end
  end
end

function Controller:ClearAllTeam(notSave)
  self:ClearTeamByIndex(notSave)
end

function Controller:SelectLevel(index)
  DataModel.curLevelIndex = index
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
  View.Group_Select.self:SetActive(0 < index)
  View.Group_Level.Img_Mask:SetActive(0 < index)
end

function Controller:OnSetLevelGrid(element, elementIndex)
  element.Group_Off.self:SetActive(DataModel.curLevelIndex > 0 and elementIndex ~= DataModel.curLevelIndex)
  element.Txt_Index:SetText(elementIndex)
  element.StaticGrid_RoleList.grid.self:SetParentParam(elementIndex)
  element.StaticGrid_RoleList.grid.self:SetDataCount(#DataModel.levelRoleList)
  element.StaticGrid_RoleList.grid.self:RefreshAllElement()
  element.Btn_Select:SetClickParam(elementIndex)
  element.Btn_Auto:SetClickParam(elementIndex)
end

function Controller:OnSetLevelRoleGrid(element, elementIndex)
  local levelRoleList = DataModel.levelRoleList
  local roleId = levelRoleList[elementIndex]
  element.Btn_Click:SetClickParam(elementIndex)
  if roleId == -1 or DataModel.isDrag == true and DataModel.dragIdx.role == elementIndex then
    element.Group_On:SetActive(false)
    element.Group_Off:SetActive(true)
    return
  end
  element.Group_On:SetActive(true)
  element.Group_Off:SetActive(false)
  local roleData = PlayerData.ServerData.roles[roleId]
  local currentSkin = roleData.current_skin[1]
  local viewCA = PlayerData:GetFactoryData(currentSkin, "UnitViewFactory")
  element.Group_On.Spine_Role:SetData(viewCA.resDir, "stand")
end

function Controller:OnBtnBattle()
  if DataModel.mode == "InitCube" then
    self:TryBattle()
  elseif DataModel.levelId ~= nil then
    if DataModel.isDataChange == true then
      Controller:SaveCubeDeck(function()
        RogueController:StartBattle(DataModel.levelId)
      end)
    else
      RogueController:StartBattle(DataModel.levelId)
    end
  end
end

function Controller:TryBattle()
  local roleCountMap = {}
  for j = 1, #DataModel.levelRoleList do
    local roleId = DataModel.levelRoleList[j]
    if roleId == -1 then
      CommonTips.OpenTips(80607586)
      return
    end
    if roleCountMap[roleId] == nil then
      roleCountMap[roleId] = 1
    else
      CommonTips.OpenTips(80607587)
      return
    end
  end
  PlayerData.TempCache.RogueCache.roleList = DataModel.levelRoleList
  local ridStr = self:GetCurRidStr()
  Net:SendProto("cube.deck", function(json)
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      PlayerData.TempCache.CubeRogueData.reward = json.reward
      CBus:ChangeScene("RubikCube", function()
        UIManager:Open("UI/CubeRogue/Main/CubeRogueMain")
      end)
    end)
  end, ridStr, tostring(DataModel.levelRoleList[1]))
  return true
end

function Controller:GetCurRidStr()
  local ridStr = ""
  for i = 1, #DataModel.levelRoleList do
    if ridStr ~= "" then
      ridStr = ridStr .. ","
    end
    ridStr = ridStr .. DataModel.levelRoleList[i]
  end
  return ridStr
end

function Controller:SaveCubeDeck(cb)
  if DataModel.mode == "InitCube" or DataModel.isDataChange ~= true then
    return false
  end
  DataModel.isDataChange = false
  local ridStr = self:GetCurRidStr()
  Net:SendProto("cube.deck", function(json)
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      PlayerData.TempCache.CubeRogueData.reward = json.reward
      if cb ~= nil then
        cb()
      end
    end)
  end, ridStr, tostring(DataModel.levelRoleList[1]))
  return true
end

function Controller:UpdateCubeDeckCache()
  PlayerData.TempCache.CubeRogueData.deck = {}
  for i = 1, #DataModel.levelRoleList do
    local roleId = tostring(DataModel.levelRoleList[i])
    PlayerData.TempCache.CubeRogueData.deck[roleId] = PlayerData.TempCache.CubeRogueData.roles[roleId]
  end
end

function Controller:BeginDrag(teamIndex, roleIndex)
  if DataModel.curFrameMouseUp then
    return
  end
  local roleId = DataModel.levelRoleList[roleIndex]
  if roleId == -1 then
    return
  end
  DataModel.isDrag = true
  DataModel.dragIdx = {team = teamIndex, role = roleIndex}
  local pos = Controller:GetMousePos()
  View.Group_RoleTemp.self:SetLocalPosition(pos)
  local roleData = PlayerData.ServerData.roles[roleId]
  local currentSkin = roleData.current_skin[1]
  local viewCA = PlayerData:GetFactoryData(currentSkin, "UnitViewFactory")
  View.Group_RoleTemp.Group_On.Spine_Role:SetData(viewCA.resDir, "stun")
  View.Group_RoleTemp.self:SetActive(true)
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
end

function Controller:CalcDragingPos()
  local toIdx = -1
  local groupLevel = View.Group_Level.Group_Level
  local groupRoleList = groupLevel.StaticGrid_RoleList
  local pos = groupRoleList.self.transform:InverseTransformPoint(View.Group_RoleTemp.self.transform.position)
  for j = 1, groupRoleList.self.DataCount do
    local gridPos = groupRoleList.grid[j].self.transform.localPosition
    if math.abs(gridPos.x - pos.x) <= 60 and math.abs(gridPos.y - pos.y) <= 100 then
      toIdx = j
      break
    end
  end
  return 1, toIdx
end

function Controller:DragEnd()
  local toTeam, toIdx = Controller:CalcDragingPos()
  if toTeam ~= -1 and toIdx ~= -1 and (DataModel.dragIdx.team ~= toTeam or DataModel.dragIdx.role ~= toIdx) then
    Controller:ExchangeSingleRole(DataModel.dragIdx.team, DataModel.dragIdx.role, toTeam, toIdx)
  end
  DataModel.dragIdx = {}
  View.Group_RoleTemp.self:SetActive(false)
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
end

function Controller:GetMousePos()
  local minScale = math.min(GameSetting.scaleWidth, GameSetting.scaleHeight)
  local position = Input.mousePosition
  position = Vector3((position.x - Screen.width * 0.5) / minScale, (position.y - Screen.height * 0.5) / minScale, position.z)
  return position
end

function Controller:OnClickReturn()
  Controller:SaveCubeDeck()
  if DataModel.levelId then
    RogueController.cacheLevelId = DataModel.levelId
    RogueController.OnOtherPanelClose(RogueController.Enum_Continue.OpenSquadPanel)
  end
  View.self:PlayAnimOnce("Animation_out", function()
    View.self:SetAlpha(1)
    UIManager:GoBack(false)
  end)
end

function Controller:OnClickHome()
  Controller:SaveCubeDeck()
  local curLevelIndex = DataModel.curLevelIndex
  if curLevelIndex ~= -1 then
    View.self:PlayAnimOnce("Animation_SelectClose", function()
      Controller:SelectLevel(-1)
    end)
    return
  end
  UIManager:GoHome()
end

function Controller:OnClickSelectLevel(str)
  local curLevelIndex = DataModel.curLevelIndex
  Controller:SelectLevel(tonumber(str))
  if curLevelIndex == -1 then
    View.self:PlayAnimOnce("Animation_SelectOpen")
  end
end

function Controller:OnClickLevelBtn()
  Controller:ClearAllTeam()
  if DataModel.selectMode == 1 then
    View.Group_Select.Group_RoleList.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  elseif DataModel.selectMode == 2 then
    View.Group_Select.Group_TeamList.ScrollGrid_TeamList.grid.self:RefreshAllElement()
  end
  Controller:OnSetLevelGrid(View.Group_Level.Group_Level, 1)
end

function Controller:OnClickBtnAuto()
  Controller:SaveCubeDeck()
  local roleList = DataModel.levelRoleList
  local aiRoleList = {}
  for i = 1, #roleList do
    aiRoleList[#aiRoleList + 1] = tonumber(roleList[i])
  end
  local roles = PlayerData.ServerData.roles
  if DataModel.mode ~= "InitCube" then
    roles = PlayerData.TempCache.CubeRogueData.roles
  end
  UIManager:Open("UI/Battle/AutoBattle/New/AutoBattle", Json.encode({
    teamKey = "Cube",
    roleList = aiRoleList,
    header = aiRoleList[1],
    usableRoles = roles
  }))
end

function Controller:OnClickLevelRole(str)
  local roleIndex = tonumber(str)
  Controller:OnClickRoleBtn(DataModel.levelRoleList[roleIndex])
end

return Controller
