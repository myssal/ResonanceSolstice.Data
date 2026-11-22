local View = require("UIPrisonSpaceUnlockPrompt/UIPrisonSpaceUnlockPromptView")
local DataModel = require("UIPrisonSpaceUnlockPrompt/UIPrisonSpaceUnlockPromptDataModel")
local ViewFunction = require("UIPrisonSpaceUnlockPrompt/UIPrisonSpaceUnlockPromptViewFunction")
local CommonItem = require("Common/BtnItem")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local data = Json.decode(initParams)
      DataModel.RoomIndex = data.roomIndex
    else
      DataModel.RoomIndex = PrisonData.roomIndex
    end
    local prisonCfg = PrisonData.GetPrisonCA()
    local costItem = prisonCfg.buySpacePrice[1]
    local costItemCfg = PlayerData:GetFactoryData(costItem.id)
    View.Group_Prompt.TextIcon_Unlock:SetText(string.format(GetText(80607111), costItemCfg.textIcon, costItem.num))
    View.Group_Prompt.Group_PowerTotal.Group_Total.Txt_Num:SetText(PrisonData.GetCurPower())
    View.Group_Prompt.Group_PowerTotal.Group_Power.Txt_Num:SetText(string.format(GetText(80608430), PrisonData.GetUsePower(), prisonCfg.workshopSpaceOccupyPower))
    CommonItem:SetItem(View.Group_Prompt.Group_Material.Group_Item.Group_Item, {
      id = costItem.id
    })
    View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num1:SetText(DataModel.AddUnit(PlayerData:GetGoodsById(costItem.id).num))
    View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num2:SetText(DataModel.AddUnit(costItem.num))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
