local View = require("UIRevive/UIReviveView")
local DataModel = require("UIRevive/UIReviveDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local TeamDataModel = require("UITeam_Battle/UITeam_BattleDataModel")
local Controller = {}

function Controller:Init(openData)
  View.Img_Title:SetSprite(GetResPath(88300193))
  local Cfg = PlayerData:GetFactoryData(openData.eventId, "CubeEventFactory")
  local roleList = {}
  local roleDeck = PlayerData.TempCache.CubeRogueData.roles
  for k, v in pairs(roleDeck) do
    local hp = v.hp
    if hp <= 0 then
      roleList[#roleList + 1] = {id = k, hp = 0}
    end
  end
  DataModel.reviveAnimDic = {}
  DataModel.roleList = roleList
  DataModel.selectedIndex = {}
  View.ScrollGrid_RoleList.grid.self:SetDataCount(#DataModel.roleList)
  View.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  DataModel.costId = -1
  DataModel.costNum = 0
  if 0 < #Cfg.resurgencePriceNList then
    View.Group_Cost:SetActive(true)
    local costData = Cfg.resurgencePriceNList[1]
    DataModel.costId = costData.id
    DataModel.priceList = {
      [0] = Cfg.resurgencePriceNList,
      [1] = Cfg.resurgencePriceNList,
      [2] = Cfg.resurgencePriceRList,
      [3] = Cfg.resurgencePriceSRList,
      [4] = Cfg.resurgencePriceSSRList
    }
    local costCA = PlayerData:GetFactoryData(DataModel.costId)
    View.Group_Cost.Group_Icon.Img_Coin:SetSprite(costCA.iconPath)
    Controller:RefreshCost()
  else
    View.Group_Cost:SetActive(false)
  end
end

function Controller:RefreshCost()
  local needNum = 0
  for k, v in pairs(DataModel.selectedIndex) do
    if v == true then
      local roleCA = PlayerData:GetFactoryData(DataModel.roleList[tonumber(k)].id)
      needNum = needNum + DataModel.priceList[roleCA.qualityInt][1].num
    end
  end
  DataModel.costNum = needNum
  View.Group_Cost.Txt_Cost:SetText(DataModel.costNum)
  local hasNum = PlayerData:GetGoodsById(DataModel.costId).num
  View.Group_Cost.Txt_Own:SetText(hasNum)
  if hasNum < DataModel.costNum then
    View.Group_Cost.Txt_Cost:SetColor("#CD5454")
    View.Group_Cost.Txt_0:SetColor("#CD5454")
    View.Group_Cost.Txt_Own:SetColor("#CD5454")
  else
    View.Group_Cost.Txt_Cost:SetColor("#FFFFFF")
    View.Group_Cost.Txt_0:SetColor("#FFFFFF")
    View.Group_Cost.Txt_Own:SetColor("#FFFFFF")
  end
end

function Controller:OnClickRoleBtn(str)
  if DataModel.selectedIndex[str] == true then
    DataModel.selectedIndex[str] = false
  else
    DataModel.selectedIndex[str] = true
  end
  Controller:RefreshCost()
  View.ScrollGrid_RoleList.grid.self:RefreshAllElement()
end

function Controller:OnSetRoleGrid(element, elementIndex)
  local roleId = DataModel.roleList[elementIndex].id
  element.Btn_Click:SetClickParam(elementIndex)
  local roleData = PlayerData.ServerData.roles[roleId]
  local currentSkin = roleData.current_skin[1]
  local viewCA = PlayerData:GetFactoryData(currentSkin, "UnitViewFactory")
  element.Group_Info.Img_Role:SetActive(true)
  element.Group_Info.Img_Role.Img_Role:SetSprite(viewCA.roleListResUrl)
  element.Group_Info.Group_LV.Txt_Num:SetText(math.max(roleData.lv, 60))
  local roleCA = PlayerData:GetFactoryData(roleId)
  element.Group_Info.Txt_Name:SetText(roleCA.name)
  local awakeLv = roleData.awake_lv or 1
  element.Group_Info.Group_Break.StaticGrid_BK.grid.self:SetDataCount(5)
  for i = 0, 4 do
    element.Group_Info.Group_Break.StaticGrid_BK.grid[i + 1].Img_On:SetActive(awakeLv >= i + 1)
  end
  local qualityInt = roleCA.qualityInt
  local bgPath = TeamDataModel.RoleQualityBigPath[qualityInt]
  local maskPath = TeamDataModel.RoleQualityBigMaskPath[qualityInt]
  element.Group_Info.Img_Quality:SetSprite(bgPath)
  element.Group_Info.Img_Mask:SetSprite(maskPath)
  local hp = DataModel.roleList[elementIndex].hp
  if 0 < hp then
    local hpStatus = 1
    if hp < 0.6 and 0.2 <= hp then
      hpStatus = 2
    elseif hp < 0.2 then
      hpStatus = 3
    end
    element.Group_Info.Group_Health:SetActive(true)
    element.Group_Info.Group_Health.Group_Num.Txt_Num:SetText(100 * hp)
    element.Group_Info.Group_Health.Img_Bar.Img_Red:SetActive(hpStatus == 3)
    element.Group_Info.Group_Health.Img_Bar.Img_Orange:SetActive(hpStatus == 2)
    element.Group_Info.Group_Health.Img_Bar.Img_Green:SetActive(hpStatus == 1)
    element.Group_Info.Img_Role.Img_Role:SetMaterial(nil)
  else
    element.Group_Info.Group_Health:SetActive(false)
    element.Group_Info.Img_Role.Img_Role:SetMaterial("Shader/UI/UI-ImageGray")
  end
  element.Group_Selected:SetActive(DataModel.selectedIndex[tostring(elementIndex)] == true)
  if DataModel.reviveAnimDic[tostring(elementIndex)] == true then
    View.self:SelectPlayAnim(element.self, "Group_BattleTeamRole_revive")
    DataModel.reviveAnimDic[tostring(elementIndex)] = nil
  end
end

function Controller:OnBtnRevive()
  if table.count(DataModel.selectedIndex) <= 0 then
    return
  end
  local hasNum = PlayerData:GetGoodsById(DataModel.costId).num
  if hasNum < DataModel.costNum then
    return
  end
  local rids = ""
  for k in pairs(DataModel.selectedIndex) do
    if 0 >= DataModel.roleList[tonumber(k)].hp then
      if rids ~= "" then
        rids = rids .. ","
      end
      rids = rids .. DataModel.roleList[tonumber(k)].id
    end
  end
  if rids == "" then
    return
  end
  Net:SendProto("cube.rebirth", function()
    Controller:OnReviveSuccess()
  end, rids)
end

function Controller:OnReviveSuccess()
  PlayerData:RefreshUseItems({
    [DataModel.costId] = DataModel.costNum
  })
  RogueController.ShowCoin()
  for k, v in pairs(DataModel.selectedIndex) do
    if v == true then
      DataModel.reviveAnimDic[k] = true
      DataModel.roleList[tonumber(k)].hp = 1
      PlayerData.TempCache.CubeRogueData.roles[DataModel.roleList[tonumber(k)].id].hp = 1
    end
  end
  View.ScrollGrid_RoleList.grid.self:RefreshAllElement()
end

return Controller
