local View = require("UIInitChoose/UIInitChooseView")
local DataModel = require("UIInitChoose/UIInitChooseDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init(data)
  DataModel.rbData = data
  DataModel.selectedRoles = {}
  DataModel.selectedEquips = {}
  DataModel.randBattleCA = PlayerData:GetFactoryData(DataModel.rbData.rb_id or 89000001)
  DataModel.curChooseIndex = 1
  View.Group_Choose.Group_Team.StaticGrid_Team.grid.self:SetDataCount(#DataModel.rbData.pre_roles)
  Controller:UpdateChoose()
end

function Controller:UpdateChoose()
  View.Group_Choose.self:SetActive(true)
  View.Group_Captain.self:SetActive(false)
  DataModel.curRoleIndex = 1
  DataModel.curEquipIndex = 1
  Controller:RefreshChooseGroupRole()
  Controller:RefreshGroupTeam()
end

function Controller:RefreshChooseGroupRole()
  DataModel.ChooseMode = 1
  View.Group_Choose.Group_Role.self:SetActive(true)
  View.Group_Choose.Group_Equipment.self:SetActive(false)
  View.Group_Choose.Group_Role.Txt_Title:SetText(string.format(GetText(80609937), DataModel.curChooseIndex))
  local curRoleList = DataModel.rbData.pre_roles[DataModel.curChooseIndex]
  local count = 0
  for i = 1, #curRoleList do
    if curRoleList[i] ~= nil and curRoleList[i] ~= "" then
      count = count + 1
    end
  end
  View.Group_Choose.Group_Role.StaticGrid_Role.grid.self:SetDataCount(count)
  View.Group_Choose.Group_Role.StaticGrid_Role.grid.self:RefreshAllElement()
end

function Controller:OnSetChooseRoleGrid(element, elementIndex)
  Controller:OnSetRoleGrid(element.Group_Character, DataModel.rbData.pre_roles[DataModel.curChooseIndex][elementIndex])
  element.Group_Character.Btn_Item:SetClickParam(elementIndex)
  element.Btn_Select:SetClickParam(elementIndex)
end

function Controller:RefreshChooseGroupEquip()
  DataModel.ChooseMode = 2
  View.Group_Choose.Group_Role.self:SetActive(false)
  View.Group_Choose.Group_Equipment.self:SetActive(true)
  local curEquipList = DataModel.rbData.pre_equips[DataModel.curChooseIndex]
  View.Group_Choose.Group_Equipment.StaticGrid_Equipment.grid.self:SetDataCount(#curEquipList)
  View.Group_Choose.Group_Equipment.StaticGrid_Equipment.grid.self:RefreshAllElement()
end

function Controller:OnSetChooseEquipGrid(element, elementIndex)
  Controller:OnSetEquipGrid(element.Group_Character, DataModel.rbData.pre_equips[DataModel.curChooseIndex][elementIndex].id)
  element.Group_Character.Btn_Item:SetClickParam(elementIndex)
  element.Btn_Select:SetClickParam(elementIndex)
end

function Controller:RefreshGroupTeam()
  View.Group_Choose.Group_Team.StaticGrid_Team.grid.self:RefreshAllElement()
end

function Controller:OnSetChooseTeamGrid(element, elementIndex)
  local roleId = DataModel.selectedRoles[elementIndex]
  element.Group_Role.self:SetActive(roleId ~= nil)
  element.Group_Slected.self:SetActive(DataModel.curChooseIndex == elementIndex)
  if roleId ~= nil then
    local roleCA = PlayerData:GetFactoryData(roleId)
    local viewCA = PlayerData:GetFactoryData(roleCA.viewId)
    element.Group_Role.Img_Face:SetSprite(viewCA.face)
    local quality = roleCA.qualityInt
    element.Group_Role.Img_R:SetActive(quality <= 2)
    element.Group_Role.Img_SR:SetActive(quality == 3)
    element.Group_Role.Img_SSR:SetActive(4 <= quality)
  else
    element.Group_Empty.Txt_Index:SetText(string.format("%02d", elementIndex))
  end
end

function Controller:OnChooseRole(btn, str)
  local index = tonumber(str)
  DataModel.curRoleIndex = index
  DataModel.selectedRoles[#DataModel.selectedRoles + 1] = DataModel.rbData.pre_roles[DataModel.curChooseIndex][DataModel.curRoleIndex]
  Controller:RefreshChooseGroupEquip()
  Controller:RefreshGroupTeam()
end

function Controller:OnClickPreRole(str)
  local index = tonumber(str)
  local id = DataModel.rbData.pre_roles[DataModel.curChooseIndex][index]
  Controller:OpenRoleTip(id, nil, {})
end

function Controller:OnClickPreEquip(str)
  local index = tonumber(str)
  local equipData = DataModel.rbData.pre_equips[DataModel.curChooseIndex][index]
  Controller:OpenEquipTips(equipData)
end

function Controller:OnChooseEquip(btn, str)
  local index = tonumber(str)
  DataModel.curEquipIndex = index
  Controller:OnChooseConfrim()
end

function Controller:OnChooseConfrim()
  DataModel.selectedEquips[#DataModel.selectedEquips + 1] = DataModel.rbData.pre_equips[DataModel.curChooseIndex][DataModel.curEquipIndex]
  DataModel.curChooseIndex = DataModel.curChooseIndex + 1
  if #DataModel.rbData.pre_roles >= DataModel.curChooseIndex and #DataModel.rbData.pre_equips >= DataModel.curChooseIndex then
    Controller:UpdateChoose()
  else
    Controller:UpdateCaptain()
  end
end

function Controller:UpdateCaptain()
  View.Group_Choose.self:SetActive(false)
  View.Group_Captain.self:SetActive(true)
  DataModel.curCaptainIndex = 1
  View.Group_Captain.StaticGrid_Team.grid.self:SetDataCount(#DataModel.selectedRoles)
  View.Group_Captain.StaticGrid_Team.grid.self:RefreshAllElement()
  Controller:RefreshCaptain()
end

function Controller:OnSetTeamCaptainGrid(element, elementIndex)
  Controller:OnSetRoleGrid(element.Group_Character, DataModel.selectedRoles[elementIndex])
  element.Group_Equipment.StaticGrid_Equipment.grid.self:SetParentParam(elementIndex)
  element.Group_Equipment.StaticGrid_Equipment.grid.self:SetDataCount(3)
  element.Group_Equipment.StaticGrid_Equipment.grid.self:RefreshAllElement()
  element.Group_Character.Btn_Item:SetClickParam(elementIndex)
  element.Btn_Select:SetClickParam(elementIndex)
  element.Btn_Select.Group_On:SetActive(DataModel.curCaptainIndex == elementIndex)
end

function Controller:OnSetTeamEquipGrid(element, elementIndex)
  local idx = tonumber(element.ParentParam)
  local equipId = DataModel.selectedEquips[idx].id
  local equipData = PlayerData:GetFactoryData(equipId)
  local typeCA = PlayerData:GetFactoryData(equipData.equipTagId)
  element.Group_Empty.self:SetActive(typeCA.typeID ~= elementIndex)
  element.Group_Have.self:SetActive(typeCA.typeID == elementIndex)
  if typeCA.typeID == elementIndex then
    element.Group_Have.Group_Type.Img_1:SetActive(elementIndex == 1)
    element.Group_Have.Group_Type.Img_2:SetActive(elementIndex == 2)
    element.Group_Have.Group_Type.Img_3:SetActive(elementIndex == 3)
    element.Group_Have.Group_Color.Img_R:SetActive(equipData.qualityInt == 1)
    element.Group_Have.Group_Color.Img_SR:SetActive(equipData.qualityInt == 2)
    element.Group_Have.Group_Color.Img_SSR:SetActive(equipData.qualityInt == 3)
    element.Group_Have.Group_Color.Img_UR:SetActive(equipData.qualityInt == 4)
    element.Group_Have.Img_Item:SetSprite(equipData.iconPath)
    element.Group_Have.Txt_EquipmentLevel:SetText(string.format(GetText(80600474), DataModel.randBattleCA.initEquipList[1].lv))
    element.Group_Have.Btn_Item:SetClickParam(idx)
  end
end

function Controller:OnClickTeamEquip(str)
  local idx = tonumber(str)
  local equipData = DataModel.selectedEquips[idx]
  Controller:OpenEquipTips(equipData)
end

function Controller:OpenEquipTips(equipData, tempData)
  if tempData == nil then
    tempData = DataModel.randBattleCA.initEquipList[1]
  end
  local param = {}
  param.id = equipData.id
  param.lv = tempData.lv
  param.random_affix = equipData.random_affix
  CommonTips.OpenRandomBattleEquipmentTips(param)
end

function Controller:OnChooseCaptain(btn, str)
  local index = tonumber(str)
  DataModel.curCaptainIndex = index
  Controller:RefreshCaptain()
  View.Group_Captain.StaticGrid_Team.grid.self:RefreshAllElement()
end

function Controller:RefreshCaptain()
  local headerId = DataModel.selectedRoles[DataModel.curCaptainIndex]
  local ca = PlayerData:GetFactoryData(headerId)
  local quality = ca.qualityInt
  View.Group_Captain.Group_Confirm.Group_Role.Img_R:SetActive(quality <= 2)
  View.Group_Captain.Group_Confirm.Group_Role.Img_SR:SetActive(quality == 3)
  View.Group_Captain.Group_Confirm.Group_Role.Img_SSR:SetActive(4 <= quality)
  local viewCA = PlayerData:GetFactoryData(ca.viewId)
  View.Group_Captain.Group_Confirm.Group_Role.Img_Face:SetSprite(viewCA.face)
end

function Controller:OnSetEquipGrid(element, id, lv)
  if lv == nil then
    lv = DataModel.randBattleCA.initEquipList[1].lv
  end
  local equipData = PlayerData:GetFactoryData(id)
  if UIConfig.RandomBattleBottom[equipData.qualityInt + 1] then
    element.Img_Bottom:SetActive(true)
    element.Img_Bottom:SetSprite(UIConfig.RandomBattleBottom[equipData.qualityInt + 1])
    if element.Img_Bottom.Group_R ~= nil then
      element.Img_Bottom.Group_R:SetActive(equipData.qualityInt == 1)
    end
    if element.Img_Bottom.Group_SR ~= nil then
      element.Img_Bottom.Group_SR:SetActive(equipData.qualityInt == 2)
    end
    if element.Img_Bottom.Group_SSR ~= nil then
      element.Img_Bottom.Group_SSR:SetActive(equipData.qualityInt == 3)
    end
    if element.Img_Bottom.Group_UR ~= nil then
      element.Img_Bottom.Group_UR:SetActive(equipData.qualityInt == 4)
    end
  else
    element.Img_Bottom:SetActive(false)
  end
  element.Img_Icon:SetSprite(equipData.tipsPath)
  element.Txt_Name:SetText(equipData.name)
  element.Txt_LV:SetText(string.format(GetText(80600474), lv))
  local typeCA = PlayerData:GetFactoryData(equipData.equipTagId)
  element.Group_Type.Img_1:SetActive(typeCA.typeID == 1)
  element.Group_Type.Img_2:SetActive(typeCA.typeID == 2)
  element.Group_Type.Img_3:SetActive(typeCA.typeID == 3)
end

function Controller:OnCaptainConfrim()
  local headerId = DataModel.selectedRoles[DataModel.curCaptainIndex]
  local roleIds = ""
  for i = 1, #DataModel.selectedRoles do
    roleIds = roleIds .. DataModel.selectedRoles[i]
    if i ~= #DataModel.selectedRoles then
      roleIds = roleIds .. ","
    end
  end
  local equipIds = ""
  for i = 1, #DataModel.selectedEquips do
    equipIds = equipIds .. DataModel.selectedEquips[i].id
    if i ~= #DataModel.selectedEquips then
      equipIds = equipIds .. ","
    end
  end
  Net:SendProto("battle.chose", function(json)
    UIManager:ClosePanel(false, "UI/Activity/ActivityRandomBattle/InitChoose")
    UIManager:Open("UI/Activity/ActivityRandomBattle/RandomLevel")
  end, roleIds, equipIds, headerId)
end

function Controller:OnClickBtnRole()
  local headerId = DataModel.selectedRoles[DataModel.curCaptainIndex]
  local equipData = DataModel.selectedEquips[DataModel.curCaptainIndex]
  local param = {}
  param.id = equipData.id
  param.lv = DataModel.randBattleCA.initEquipList[1].lv
  param.random_affix = equipData.random_affix
  Controller:OpenRoleTip(headerId, nil, {param})
end

function Controller:OpenRoleTip(id, tempData, equipList)
  if tempData == nil then
    tempData = DataModel.randBattleCA.initRoleList[1]
  end
  local params = {}
  params.id = id
  params.lv = tempData.lv
  params.awakeLv = tempData["break"]
  params.resonanceLv = tempData.awake
  params.equipList = equipList or {}
  CommonTips.OpenRandomBattleUnitDetail(params)
end

function Controller:OnSetRoleGrid(element, id, tempData)
  if tempData == nil then
    tempData = DataModel.randBattleCA.initRoleList[1]
  end
  element.Txt_LV:SetText(string.format(GetText(80600474), tempData.lv))
  element.Group_Break.StaticGrid_BK.grid.self:RefreshAllElement()
  for i = 0, 4 do
    element.Group_Break.StaticGrid_BK.grid[i + 1].Img_On:SetActive(tempData["break"] >= i + 1)
  end
  element.Group_Awake.Img_Awake:SetSprite(UIConfig.AwakeCommon[tempData.awake + 1])
  local ca = PlayerData:GetFactoryData(id)
  local portraitId = ca.viewId
  local portrailData = PlayerData:GetFactoryData(portraitId, "UnitViewFactory")
  element.Spine_Role:SetData(portrailData.resDir, "stand")
  element.Txt_Name:SetText(ca.name)
  if element.Group_Career ~= nil and element.Group_Career.Img_1 ~= nil then
    local careerCA = PlayerData:GetFactoryData(ca.careerList[1].des)
    element.Group_Career.Img_1:SetActive(careerCA.tagID == 0)
    element.Group_Career.Img_2:SetActive(careerCA.tagID == 1)
    element.Group_Career.Img_3:SetActive(careerCA.tagID == 2)
    element.Group_Career.Img_4:SetActive(careerCA.tagID == 3)
  end
  if UIConfig.RandomBattleBottom[ca.qualityInt] then
    element.Img_Bottom:SetActive(true)
    element.Img_Bottom:SetSprite(UIConfig.RandomBattleBottom[ca.qualityInt])
    if element.Img_Bottom.Group_R ~= nil then
      element.Img_Bottom.Group_R:SetActive(ca.qualityInt == 2)
    end
    if element.Img_Bottom.Group_SR ~= nil then
      element.Img_Bottom.Group_SR:SetActive(ca.qualityInt == 3)
    end
    if element.Img_Bottom.Group_SSR ~= nil then
      element.Img_Bottom.Group_SSR:SetActive(ca.qualityInt == 4)
    end
  else
    element.Img_Bottom:SetActive(false)
  end
  local Group_SkillColor = element.Group_SkillColor
  local cardList = PlayerData:GetRoleCardList(ca.id)
  for i = 1, table.count(cardList) do
    local obj = "Group_SkillColor" .. i
    local cardCA = PlayerData:GetFactoryData(cardList[table.count(cardList) - i + 1].id)
    local color = cardCA.color
    Group_SkillColor[obj].Img_Color:SetSprite(UIConfig.CharacterSkillColor[color])
  end
  local Group_Locate = Group_SkillColor.Group_Locate
  Group_Locate.Img_Line:SetSprite(UIConfig.CharacterLine[ca.line])
end

return Controller
