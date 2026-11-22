local SquadElement = require("UISquads/Model_Element")
local DataModel = require("UISquads/UISquadsDataModel")
local DataDetail = require("UISquads/UISquadsDetail")
local View = require("UISquads/UISquadsView")

local function RoundTwoDecimalPlaces(decimal)
  local res = (decimal + 1.0E-4) * 100
  return math.floor(res) * 0.01
end

local module = {
  RefreshRoles = function()
    DataModel.curDetailIndex = DataModel.curDetailIndex or 1
    View.StaticGrid_List.self:RefreshAllElement()
  end,
  SetSquadElemet = function(element, data)
    if next(data) == nil then
      element.Btn_Null.Img_Ban:SetActive(false)
      element.Btn_Null.Txt_ADDCN:SetActive(true)
      element.Btn_Null.self:SetActive(true)
      element.Btn_Null.Spine_Add:SetAction("tianjia", true, true)
      element.Btn_Null.Spine_Bg:SetAction("tianjia2", true, true)
      element.Btn_Character.self:SetActive(false)
      if element.Group_HelpRole then
        element.Group_HelpRole.self:SetActive(false)
      end
      return
    elseif data.isBlocked == true then
      element.Btn_Null.Img_Ban:SetActive(true)
      element.Btn_Null.Txt_ADDCN:SetActive(false)
      element.Btn_Null.self:SetActive(data.isLevelRole ~= true)
      element.Btn_Null.Spine_Add:SetAction("tianjia", true, true)
      element.Btn_Character.self:SetActive(data.isLevelRole == true)
      element.Group_Alternate.self:SetActive(data.isLevelRole == true)
      if data.isLevelRole == true then
        SquadElement:SetElement(element.Btn_Character, data)
      end
      if element.Group_HelpRole then
        element.Group_HelpRole.self:SetActive(data.isHelpRole)
      end
    else
      element.Group_Alternate.self:SetActive(data.isLevelRole == true)
      element.Btn_Null.self:SetActive(false)
      element.Btn_Character.self:SetActive(true)
      SquadElement:SetElement(element.Btn_Character, data)
      if element.Group_HelpRole then
        element.Group_HelpRole.self:SetActive(data.isHelpRole)
      end
    end
  end,
  ShowDetail = function(tabIndex)
    local chargeSpeed = 0
    local squads = DataModel.curSquad
    for k, v in pairs(squads) do
      if next(v) ~= nil and v.isBlocked ~= true then
        chargeSpeed = chargeSpeed + PlayerData:GetFactoryData(v.unitId, "UnitFactory").costRestore_SN
      end
    end
    View.Group_CardYard_Open.Group_NOE.Txt_Num:SetText("12 ")
    local num = string.format("%.2f", RoundTwoDecimalPlaces(chargeSpeed))
    local nDecimal = 100.0
    local nTemp = math.floor(num * nDecimal)
    local nRet = nTemp / nDecimal
    if nRet % 1 < 0.01 then
      nRet = math.floor(nRet)
    end
    View.Group_CardYard_Open.Group_NOR.Txt_Num:SetText(nRet .. "/s")
    View.Group_CardYard_Open.Group_NOR.Txt_Line:SetActive(false)
    View.Group_CardYard_Open.Group_NOR.Txt_Unit:SetActive(false)
    local A = 0
    local B = 0
    local C = 0
    local D = 0
    local now_squad = PlayerData.ServerData.squad[DataModel.curSquadIndex]
    for k, v in pairs(now_squad.role_list) do
      if v.id then
        local unit_id = v.id
        local cardList = PlayerData:GetRoleCardList(unit_id)
        for c, d in pairs(cardList) do
          local cost_SN = PlayerData:GetFactoryData(d.id).cost_SN
          C = C + d.num
          A = A + cost_SN * d.num
        end
      end
    end
    local head_id = now_squad.header
    local average_cost = 0
    if head_id ~= nil and head_id ~= "" then
      local skill_list = PlayerData:GetFactoryData(head_id).skillList
      local leader_data = skill_list[#skill_list]
      local leader_skill_id = leader_data.skillId
      local leader_skill_num = leader_data.num
      local leader_card_id = PlayerData:GetFactoryData(leader_skill_id).cardID
      local header_cost_sn = PlayerData:GetFactoryData(leader_card_id).cost_SN
      B = header_cost_sn * leader_skill_num
      D = leader_skill_num
      average_cost = (A - B) / (C - D)
      average_cost = math.floor(average_cost * 10) / 10
      local t1, t2 = math.modf(average_cost)
      if t2 == 0 then
        average_cost = t1
      end
    end
    View.Group_CardYard_Open.Group_AverageCost.Txt_Num:SetText(average_cost)
  end,
  SetStartActive = function(current)
    View.Btn_Start.self:SetActive(current == DataModel.Enum.Chapter or current == DataModel.Enum.College or current == DataModel.Enum.Monopoly)
    View.Btn_Start.Img_Icon:SetSprite(GetResPath(88300013))
    UIManager:LoadSplitPrefab(View, "UI/Squads/Squads", "Btn_Test")
    View.Btn_Test.self:SetActive(current == DataModel.Enum.MainUI)
    View.Btn_Test:SetNativeSize()
    View.Btn_Test.Img_Icon:SetSprite(GetResPath(88300014))
    UIManager:LoadSplitPrefab(View, "UI/Squads/Squads", "Btn_StartChain")
    View.Btn_StartChain.self:SetActive(current == DataModel.Enum.LevelChain)
    View.Btn_StartChain:SetNativeSize()
    View.Btn_Start.Spine_Start02:SetAction("kaishizuozhan_02", false, true)
  end
}

function module:RefreshGridTab(element, elementIndex)
  local count = DataModel.DefalutSquadsTabCount
  local hasActive = false
  if elementIndex <= count then
    hasActive = true
  end
  element:SetActive(hasActive)
  element.Btn_Tab:SetClickParam(elementIndex)
  if hasActive then
    local data = {}
    local chapterLevel = PlayerData.ServerData.chapter_level
    local squadTabData = PlayerData:GetFactoryData(99900001, "ConfigFactory").Squad[elementIndex]
    data.isLocked = false
    local squad = PlayerData.ServerData.squad[elementIndex]
    if squad == nil or squad.name == nil or squad.name == "" then
      data.name = squadTabData.defaultSquadName
    else
      data.name = squad.name
    end
    element.Btn_Tab.Group_On.Txt_Name:SetText(data.name)
    element.Btn_Tab.Group_Off.Txt_Name:SetText(data.name)
    element.Btn_Tab.Group_On:SetActive(elementIndex == DataModel.curSquadIndex)
    element.Btn_Tab.Group_On.Txt_Num:SetText(9 < elementIndex and elementIndex or "0" .. elementIndex)
    element.Btn_Tab.Group_Off.Txt_Num:SetText(9 < elementIndex and elementIndex or "0" .. elementIndex)
  end
end

function module.RefreshTab(count)
  for i = 1, 4 do
    local element = View.Group_Tab["Btn_Tab_0" .. tostring(i)]
    local data = {}
    local num_Index = (count - 1) * 4 + i
    local chapterLevel = PlayerData.ServerData.chapter_level
    local squadTabData = PlayerData:GetFactoryData(99900001, "ConfigFactory").Squad[num_Index]
    data.isLocked = false
    local squad = PlayerData.ServerData.squad[num_Index]
    if squad.name == nil or squad.name == "" then
      data.name = squadTabData.defaultSquadName
    else
      data.name = squad.name
    end
    element.isLocked = data.isLocked
    element.Img_Lock:SetActive(data.isLocked)
    element.Group_Off.Txt_Num:SetText(9 < num_Index and num_Index or "0" .. num_Index)
    element.Group_On.Txt_Num:SetText(9 < num_Index and num_Index or "0" .. num_Index)
    element.Group_On.Btn_Change.Txt_Name:SetText(data.name)
    element.Group_Off.Txt_Name:SetText(data.name)
    element.Group_On:SetActive(num_Index == DataModel.curSquadIndex)
    element.Group_On.Btn_Change:SetActive(num_Index == DataModel.curSquadIndex and DataModel.Current ~= DataModel.Enum.College)
  end
end

function module.SetTabElement(index, DataController)
  DataModel.hasOpenThreeView = false
  DataModel.isRefreshSkillList = true
  DataController:SetSquadIndex(index)
  DataController:RefreshAll()
end

function module.ModifyNameBtn(index)
  local tab = View.Group_Tab["Btn_Tab_0" .. tostring(index)]
  if tab.isLocked == true then
    local squadTabData = PlayerData:GetFactoryData(99900001, "ConfigFactory").Squad[index + 4 * (DataModel.TopColumn - 1)]
    local levelData = PlayerData:GetFactoryData(squadTabData.unlockLevelId, "LevelFactory")
    local levelChapter = levelData ~= nil and levelData.levelChapter or nil
    CommonTips.OpenTips(string.format(GetText(80600103), levelChapter))
    return
  end
  UIManager:LoadSplitPrefab(View, "UI/Squads/Squads", "Group_ChangeName")
  View.Group_ChangeName.self:SetActive(true)
  View.Group_ChangeName.InputField_ChangeName.self:FocusInputField()
end

function module:ModifyName(limit)
  local newName = View.Group_ChangeName.InputField_ChangeName.self:GetText()
  Net:SendProto("deck.set_name", function()
    PlayerData.ServerData.squad[DataModel.curSquadIndex].name = newName
    local index = DataModel.curSquadIndex % 4
    View.Group_Tab["Btn_Tab_0" .. tostring(index == 0 and 4 or index)].Group_On.Btn_Change.Txt_Name:SetText(newName)
  end, DataModel.curSquadIndex - 1, newName)
end

function module:EnterTest()
  if #DataModel.curSquad == 0 then
    CommonTips.OpenTips(80600066)
    return
  end
  PlayerData.SetIsTest(true)
  DataModel.hasOpenThreeView = false
  
  local function callBack()
    DataModel.curShowIdx = 0
    local DataController = require("UISquads/UISquadsDataController")
    DataController:InitChallengeInfo()
    local isHaveUnlock = false
    local preLevelId
    if PlayerData.ServerData.record_level ~= nil then
      preLevelId = tonumber(PlayerData.ServerData.record_level[EnumDefine.BattleLevelMod.challenge])
    end
    UIManager:LoadSplitPrefab(View, "UI/Squads/Squads", "Group_ProvingGround")
    local idx = -1
    for k, v in pairs(DataModel.ChallengeInfo) do
      if preLevelId ~= nil then
        if preLevelId == v.levelId then
          isHaveUnlock = true
          idx = k
          DataController:ShowChallengeDetail(k)
          break
        end
      elseif v.isUnlock == true then
        isHaveUnlock = true
        idx = k
        DataController:ShowChallengeDetail(k)
        break
      end
    end
    View.Group_ProvingGround.self:SetActive(true)
    View.Group_ProvingGround.Group_EnemyDetail.Group_Blank.self:SetActive(not isHaveUnlock)
    View.Group_ProvingGround.Group_Challenge.self:SetActive(isHaveUnlock)
    View.Group_ProvingGround.Group_Enemy.ScrollGrid_Face.grid.self:SetDataCount(#DataModel.ChallengeInfo)
    View.Group_ProvingGround.Group_Enemy.ScrollGrid_Face.grid.self:SetSacleIndex(idx - 1, 1.2)
    View.Group_ProvingGround.Group_Enemy.ScrollGrid_Face.grid.self:RefreshAllElement()
    View.Group_ProvingGround.Group_Enemy.ScrollGrid_Face.grid.self:MoveToPos(DataModel.curShowIdx)
    DataDetail:CloseDetail()
  end
  
  if DataModel.RoleData and DataModel.RoleData.Squads then
    module:GetDefault_Send(DataModel.curSelectIndex, callBack)
  else
    callBack()
  end
end

function module:GetDefault_Send(index, callBack)
  if module:GetSquadsNum() == 0 then
    DataModel.RoleData = nil
    callBack()
    return
  end
  callBack()
end

function module:GetNewSquadsNum()
  local count = 0
  for k, v in pairs(DataModel.curSquad) do
    if v.unitId then
      count = count + 1
    end
  end
  return count
end

function module:GetSquadsNum()
  local count = 0
  local squad = DataModel.Squads[DataModel.curSquadIndex]
  if DataModel.isUseLevelRole then
    squad = DataModel.currentSquad or {}
  end
  for k, v in pairs(squad) do
    if v and type(v) == "table" and 0 < table.count(v) then
      count = count + 1
    end
  end
  return count
end

function module:GetSquadsNumMax()
  local state = false
  local maxNum = 5
  if DataModel.isUseLevelRole then
    local levelData = PlayerData:GetFactoryData(DataModel.curLevelId)
    if levelData then
      maxNum = maxNum - math.max(levelData.roleNumOffSet - #levelData.levelRoleList, 0)
    end
  end
  if module:GetSquadsNum() == maxNum then
    state = true
  end
  return state
end

function module:ClickTopExpand()
  if View.Img_Base.self.IsActive == true then
    View.Img_Base.self:SetActive(false)
    View.Btn_Close:SetActive(false)
    View.Group_Tab.Btn_Expand:SetLocalScale(Vector3(1, 1, 1))
  else
    View.Img_Base.self:SetActive(true)
    View.Btn_Close:SetActive(true)
    module:RefreshTopGrid()
    View.Group_Tab.Btn_Expand:SetLocalScale(Vector3(1, -1, 1))
  end
end

function module:RefreshTopGrid()
  View.Img_Base.ScrollGrid_Btn.grid.self:SetDataCount(DataModel.DefalutSquadsTabCount)
  View.Img_Base.ScrollGrid_Btn.grid.self:RefreshAllElement()
end

function module:ClickTopGridIndex(elementIndex)
  local column = math.ceil(elementIndex / 4)
  if elementIndex == DataModel.curSquadIndex then
    return
  end
  if DataModel.curSquadIndex then
    local old_element = View.Img_Base.ScrollGrid_Btn.grid.self:GetElementByIndex(DataModel.curSquadIndex - 1)
    old_element.Btn_Tab.Group_On:SetActive(false)
  end
  DataModel.TopColumn = column
  local element = View.Img_Base.ScrollGrid_Btn.grid.self:GetElementByIndex(elementIndex - 1)
  element.Btn_Tab.Group_On:SetActive(true)
end

return module
