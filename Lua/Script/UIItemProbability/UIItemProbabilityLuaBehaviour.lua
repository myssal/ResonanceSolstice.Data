local View = require("UIItemProbability/UIItemProbabilityView")
local DataModel = require("UIItemProbability/UIItemProbabilityDataModel")
local ViewFunction = require("UIItemProbability/UIItemProbabilityViewFunction")
local customSV = require("Common/CustomSV")
local param
local Luabehaviour = {
  serialize = function()
    return param
  end,
  deserialize = function(initParams)
    param = initParams
    local itemId = initParams
    DataModel.init(itemId)
    View.CustomScrollGrid_List.self:UpdateGridWidthOrHeight(DataModel.height)
    View.myCustomSV:RefreshData(DataModel.itemPosList, View.CustomScrollGrid_List.self.viewportCount)
    View.CustomScrollGrid_List.self.scrollRect.verticalNormalizedPosition = 1
    View.myCustomSV:RefreshAllElement()
  end,
  awake = function()
    View.myCustomSV = customSV.New(View.CustomScrollGrid_List.grid, true, function(element, index)
      local data = DataModel.itemPosList[index]
      element.Group_Title:SetActive(data.isFirst)
      DataModel.nowIndx = index
      element.Group_List.StaticGrid_Card.grid.self:RefreshAllElement(#data.list)
      if data.isFirst then
        element.Group_Title.Img_Quality:SetSprite(UIConfig.WeaponQuality[data.quality + 1])
        element.Group_Title.Img_Quality:SetNativeSize()
      end
    end)
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
