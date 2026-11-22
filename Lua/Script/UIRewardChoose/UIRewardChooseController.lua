local View = require("UIRewardChoose/UIRewardChooseView")
local DataModel = require("UIRewardChoose/UIRewardChooseDataModel")
local ChooseController = require("UIInitChoose/UIInitChooseController")
local Controller = {}

function Controller:Init(data)
  DataModel.rbData = data.melee
  DataModel.randBattleCA = PlayerData:GetFactoryData(DataModel.rbData.rb_id or 89000001)
  DataModel.levelIndex = data.index - 1
  DataModel.equipList = {}
  for k, v in pairs(data.melee.pre_levels[data.index].l_equips) do
    DataModel.equipList[#DataModel.equipList + 1] = v
  end
  View.Btn_Back:SetActive(true)
  DataModel.curEquipIndex = 1
  View.Group_Equipment.self:SetActive(true)
  View.Group_Equip.self:SetActive(false)
  View.Group_Equipment.StaticGrid_Equipment.grid.self:SetDataCount(#DataModel.equipList)
  View.Group_Equipment.StaticGrid_Equipment.grid.self:RefreshAllElement()
end

function Controller:SetEquipGrid(element, elementIndex)
  local equipData = DataModel.equipList[elementIndex]
  ChooseController:OnSetEquipGrid(element.Group_Character, equipData.id, DataModel.randBattleCA.initEquipList[1].lv)
  element.Btn_Select:SetClickParam(elementIndex)
  element.Group_Character.Btn_Item:SetClickParam(elementIndex)
end

function Controller:OnClickPreEquip(str)
  local index = tonumber(str)
  local equipData = DataModel.equipList[index]
  ChooseController:OpenEquipTips(equipData, DataModel.randBattleCA.initEquipList[1])
end

function Controller:OnClickEquip(btn, str)
  local index = tonumber(str)
  DataModel.curEquipIndex = index
  Controller:OpenEquipGroup()
end

function Controller:OpenEquipGroup()
  View.Btn_Back:SetActive(false)
  View.Group_Equipment.self:SetActive(false)
  View.Group_Equip.self:SetActive(true)
  DataModel.curRoleIndex = 1
  local roleList = {}
  for k, v in pairs(DataModel.rbData.choice) do
    roleList[#roleList + 1] = {id = k, info = v}
  end
  DataModel.roleList = roleList
  View.Group_Equip.StaticGrid_Team.grid.self:SetDataCount(#DataModel.roleList)
  View.Group_Equip.StaticGrid_Team.grid.self:RefreshAllElement()
  Controller:InitCurEquip()
  Controller:RefreshCurRole()
end

function Controller:SetRoleGrid(element, elementIndex)
  ChooseController:OnSetRoleGrid(element.Group_Character, DataModel.roleList[elementIndex].id, DataModel.randBattleCA.initRoleList[1])
  element.Group_Equipment.StaticGrid_Equipment.grid.self:SetParentParam(elementIndex)
  element.Group_Equipment.StaticGrid_Equipment.grid.self:SetDataCount(3)
  element.Group_Equipment.StaticGrid_Equipment.grid.self:RefreshAllElement()
  element.Btn_Select.Group_On.self:SetActive(elementIndex == DataModel.curRoleIndex)
  element.Btn_Select:SetClickParam(elementIndex)
  element.Group_Character.Btn_Item:SetClickParam(elementIndex)
end

function Controller:SetRoleEquipGrid(element, elementIndex)
  local idx = tonumber(element.ParentParam)
  local eList = DataModel.roleList[idx].info.eid
  element.Group_Empty.self:SetActive(true)
  element.Group_Have.self:SetActive(false)
  for k, v in pairs(eList) do
    local equipId = k
    local equipData = PlayerData:GetFactoryData(equipId)
    local typeCA = PlayerData:GetFactoryData(equipData.equipTagId)
    if typeCA.typeID == elementIndex then
      element.Group_Empty.self:SetActive(false)
      element.Group_Have.self:SetActive(true)
      element.Group_Have.Btn_Item:SetClickParam(Json.encode({
        id = k,
        random_affix = v or {}
      }))
      Controller:SetEquipElement(element.Group_Have, equipData, typeCA, DataModel.randBattleCA.initEquipList[1].lv)
      break
    end
  end
end

function Controller:OnClickRoleEquip(str)
  local equipData = Json.decode(str)
  ChooseController:OpenEquipTips(equipData, DataModel.randBattleCA.initEquipList[1])
end

function Controller:SetEquipElement(element, equipData, typeCA, lv)
  element.Group_Type.Img_1:SetActive(typeCA.typeID == 1)
  element.Group_Type.Img_2:SetActive(typeCA.typeID == 2)
  element.Group_Type.Img_3:SetActive(typeCA.typeID == 3)
  element.Group_Color.Img_R:SetActive(equipData.qualityInt == 1)
  element.Group_Color.Img_SR:SetActive(equipData.qualityInt == 2)
  element.Group_Color.Img_SSR:SetActive(equipData.qualityInt == 3)
  element.Group_Color.Img_UR:SetActive(equipData.qualityInt == 4)
  element.Img_Item:SetSprite(equipData.tipsPath)
  element.Txt_EquipmentLevel:SetText(string.format(GetText(80600474), lv))
end

function Controller:OnClickRole(btn, str)
  local index = tonumber(str)
  DataModel.curRoleIndex = index
  Controller:RefreshCurRole()
  View.Group_Equip.StaticGrid_Team.grid.self:RefreshAllElement()
end

function Controller:RefreshCurRole()
  local ca = PlayerData:GetFactoryData(DataModel.roleList[DataModel.curRoleIndex].id)
  local quality = ca.qualityInt
  View.Group_Equip.Group_Confirm.Group_Role.Img_R:SetActive(quality <= 2)
  View.Group_Equip.Group_Confirm.Group_Role.Img_SR:SetActive(quality == 3)
  View.Group_Equip.Group_Confirm.Group_Role.Img_SSR:SetActive(4 <= quality)
  local viewCA = PlayerData:GetFactoryData(ca.viewId)
  View.Group_Equip.Group_Confirm.Group_Role.Img_Face:SetSprite(viewCA.face)
end

function Controller:InitCurEquip()
  local curEquipId = DataModel.equipList[DataModel.curEquipIndex].id
  local element = View.Group_Equip.Group_Confirm.Group_Equipment
  local equipData = PlayerData:GetFactoryData(curEquipId)
  local typeCA = PlayerData:GetFactoryData(equipData.equipTagId)
  Controller:SetEquipElement(element, equipData, typeCA, DataModel.randBattleCA.initEquipList[1].lv)
end

function Controller:OnConfirmReplqceEquip()
  local curEquipId = DataModel.equipList[DataModel.curEquipIndex].id
  local curRoleId = DataModel.roleList[DataModel.curRoleIndex].id
  Net:SendProto("battle.replace_equip", function()
    UIManager:GoBack()
  end, curEquipId, curRoleId, DataModel.levelIndex)
end

return Controller
