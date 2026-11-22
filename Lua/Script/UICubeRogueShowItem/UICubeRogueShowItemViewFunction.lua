local View = require("UICubeRogueShowItem/UICubeRogueShowItemView")
local DataModel = require("UICubeRogueShowItem/UICubeRogueShowItemDataModel")
local Controller = require("UICubeRogueShowItem/UICubeRogueShowItemController")
local Enum_Quality2Img = {
  [1] = "Common",
  [2] = "Blue",
  [3] = "Purple",
  [4] = "Golden",
  [5] = "Orange"
}
local ViewFunction = {
  CubeRogueShowItem_Btn_OK_Click = function(btn, str)
    UIManager:GoBack(false)
    local rogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
    if UIManager:IsPanelOpened("UI/CubeRogue/Main/CubeRogueMain") then
      rogueMain.ShowCoin()
      rogueMain.OnPanelBack()
    elseif rogueMain.TryShowReward() then
    end
  end,
  CubeRogueShowItem_ScrollGrid_Items_SetGrid = function(element, elementIndex)
    local data = DataModel.Data[tonumber(elementIndex)]
    local cfg = PlayerData:GetFactoryData(data.id, "ItemFactory")
    element.Img_Bottom:SetSprite("UI/CubeRogue/ShowItem/qualityBox/" .. Enum_Quality2Img[cfg.qualityInt + 1])
    element.Img_Item:SetSprite(cfg.iconPath or cfg.imagePath)
    element.Group_Num.Txt_Num:SetText(data.num or 1)
    element.Btn_Item:SetClickParam(data.id)
    for k, v in pairs(Enum_Quality2Img) do
      element.Group_Effect["Group_CubeRogueShowItem_effect_" .. v]:SetActive(k == cfg.qualityInt + 1)
    end
  end,
  CubeRogueShowItem_ScrollGrid_Items_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenCubeRogueItemDetails({
      id = tonumber(str)
    })
  end
}
return ViewFunction
