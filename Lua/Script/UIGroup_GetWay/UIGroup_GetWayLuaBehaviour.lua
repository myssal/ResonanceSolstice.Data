local View = require("UIGroup_GetWay/UIGroup_GetWayView")
local DataModel = require("UIGroup_GetWay/UIGroup_GetWayDataModel")
local ViewFunction = require("UIGroup_GetWay/UIGroup_GetWayViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel:init(initParams)
    View.Img_WayBg.ScrollGrid_.grid.self:SetDataCount(#DataModel.getwayList)
    View.Img_WayBg.ScrollGrid_.grid.self:RefreshAllElement()
    View.Img_WayBg.ScrollGrid_.grid.self:MoveToTop()
    local canvasWidth = View.self.CachedTransform.rect.width
    local panelWidth = View.Img_WayBg.Rect.rect.width
    if DataModel.posX < 0 then
      DataModel.posX = -DataModel.posX + panelWidth / 2 > canvasWidth / 2 and -canvasWidth / 2 + panelWidth / 2 or DataModel.posX
    end
    if DataModel.posX > 0 then
      DataModel.posX = DataModel.posX + panelWidth / 2 > canvasWidth / 2 and canvasWidth / 2 - panelWidth / 2 or DataModel.posX
    end
    View.Img_WayBg:SetAnchoredPosition(Vector2(DataModel.posX, DataModel.posY))
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
