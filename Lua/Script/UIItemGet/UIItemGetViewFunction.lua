local View = require("UIItemGet/UIItemGetView")
local DataModel = require("UIItemGet/UIItemGetDataModel")
local Controller = require("UIItemGet/UIItemGetController")
local BuffBook = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local EquipBook = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local Enum_QualityEffect = {
  [1] = "Blue",
  [2] = "Purple",
  [3] = "Golden",
  [4] = "Orange"
}
local ViewFunction = {
  ItemGet_Btn__Click = function(btn, str)
    Controller.Clear()
    UIManager:GoBack(false)
    local rogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
    if UIManager:IsPanelOpened("UI/CubeRogue/Main/CubeRogueMain") then
      rogueMain.OnPanelBack()
    elseif rogueMain.TryShowReward() then
    end
  end,
  ItemGet_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    if DataModel.itemType == "Item" then
      local cfg = GetCA(tonumber(data.id), "ItemFactory")
      element.Txt_Name:SetText(cfg.name)
      element.Img_Icon:SetSprite(cfg.iconPath)
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
      element.Img_TypeIcon:SetActive(false)
      element.Img_Type:SetActive(true)
      element.Img_Type:SetSprite("UI/CubeRogue/ItemUse/ItemUseUI/ItemType")
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(GetText(80610767))
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(true)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(false)
      element.Img_Recommend:SetActive(false)
      element.Img_NotGet:SetActive(false)
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Buff_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    else
      local cfg = GetCA(tonumber(data.id), "RogueBuffFactory")
      element.Txt_Name:SetText(cfg.name)
      element.Img_Icon:SetSprite(cfg.iconPath)
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
      local liupaiCfg = GetCA(cfg.correspondingTeam, "RogueTeamFactory")
      element.Img_TypeIcon:SetActive(true)
      element.Img_Type:SetActive(true)
      element.Img_TypeIcon:SetSprite(liupaiCfg.shadePath)
      element.Img_Type:SetSprite(liupaiCfg.tabIconPath)
      element.Btn_:SetClickParam(data.id)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(liupaiCfg.name)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(data.intensify)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(not data.intensify)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(data.intensify)
      if data.intensify then
        element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetText(cfg.intensifyDes)
      else
        element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
      end
      element.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
      element.Img_Recommend:SetActive(false)
      if View.Img_Title.Txt_Intensify.gameObject.activeSelf then
        element.Img_NotGet:SetActive(false)
      else
        element.Img_NotGet:SetActive(BuffBook.GetBookItemIsNew(data.id))
      end
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Buff_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    end
  end,
  ItemGet_ScrollGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
  end,
  ItemGet_ScrollGrid_Weapon_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    local cfg = GetCA(tonumber(data.id), "RogueEquipmentFactory")
    element.Txt_Name:SetText(cfg.name)
    element.Img_Icon:SetSprite(cfg.iconPath)
    if cfg.isNegative then
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/Red")
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Weapon_" .. v]:SetActive(false)
      end
      element.Group_Effect.Group_Weapon_Red:SetActive(true)
    else
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/" .. cfg.quality)
      element.Group_Effect.Group_Weapon_Red:SetActive(false)
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Weapon_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    end
    element.ScrollView_Des.Viewport.Content.Txt_Des:SetText(cfg.des)
    element.Btn_:SetClickParam(data.id)
    element.Img_NotGet:SetActive(EquipBook.GetBookItemIsNew(data.id))
  end,
  ItemGet_ScrollGrid_Weapon_Group_Weapon_Btn__Click = function(btn, str)
  end,
  ItemGet_StaticGrid_Buff_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    if DataModel.itemType == "Item" then
      local cfg = GetCA(tonumber(data.id), "ItemFactory")
      element.Txt_Name:SetText(cfg.name)
      element.Img_Icon:SetSprite(cfg.iconPath)
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
      element.Img_TypeIcon:SetActive(false)
      element.Img_Type:SetActive(true)
      element.Img_Type:SetSprite("UI/CubeRogue/ItemUse/ItemUseUI/ItemType")
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(GetText(80610767))
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(true)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(false)
      element.Img_Recommend:SetActive(false)
      element.Img_NotGet:SetActive(false)
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Buff_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    else
      local cfg = GetCA(tonumber(data.id), "RogueBuffFactory")
      element.Txt_Name:SetText(cfg.name)
      element.Img_Icon:SetSprite(cfg.iconPath)
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
      local liupaiCfg = GetCA(cfg.correspondingTeam, "RogueTeamFactory")
      element.Img_TypeIcon:SetActive(true)
      element.Img_Type:SetActive(true)
      element.Img_TypeIcon:SetSprite(liupaiCfg.shadePath)
      element.Img_Type:SetSprite(liupaiCfg.tabIconPath)
      element.Btn_:SetClickParam(data.id)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(liupaiCfg.name)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(data.intensify)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(not data.intensify)
      element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(data.intensify)
      if data.intensify then
        element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetText(cfg.intensifyDes)
      else
        element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
      end
      element.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
      element.Img_Recommend:SetActive(false)
      if View.Img_Title.Txt_Intensify.gameObject.activeSelf then
        element.Img_NotGet:SetActive(false)
      else
        element.Img_NotGet:SetActive(BuffBook.GetBookItemIsNew(data.id))
      end
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Buff_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    end
  end,
  ItemGet_StaticGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
  end,
  ItemGet_StaticGrid_Weapon_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    local cfg = GetCA(tonumber(data.id), "RogueEquipmentFactory")
    element.Txt_Name:SetText(cfg.name)
    element.Img_Icon:SetSprite(cfg.iconPath)
    if cfg.isNegative then
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/Red")
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Weapon_" .. v]:SetActive(false)
      end
      element.Group_Effect.Group_Weapon_Red:SetActive(true)
    else
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/" .. cfg.quality)
      element.Group_Effect.Group_Weapon_Red:SetActive(false)
      for k, v in pairs(Enum_QualityEffect) do
        element.Group_Effect["Group_Weapon_" .. v]:SetActive(k == cfg.qualityInt + 1)
      end
    end
    element.ScrollView_Des.Viewport.Content.Txt_Des:SetText(cfg.des)
    element.Btn_:SetClickParam(data.id)
    element.Img_NotGet:SetActive(EquipBook.GetBookItemIsNew(data.id))
  end,
  ItemGet_StaticGrid_Weapon_Group_Weapon_Btn__Click = function(btn, str)
  end,
  ItemGet_Group_Buff_Btn__Click = function(btn, str)
  end
}
return ViewFunction
