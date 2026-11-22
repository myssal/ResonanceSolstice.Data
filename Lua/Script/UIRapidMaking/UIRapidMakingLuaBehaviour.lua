local View = require("UIRapidMaking/UIRapidMakingView")
local DataModel = require("UIRapidMaking/UIRapidMakingDataModel")
local ViewFunction = require("UIRapidMaking/UIRapidMakingViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    local isFurOpen = true
    if initParams then
      isFurOpen = Json.encode(initParams).isFurOpen
    end
    DataModel.Init(isFurOpen)
    DataModel.GetUnLockFormulas(DataModel.tabIdx)
    local cnt = DataModel.tabIdx == 1 and #DataModel.makeFurList[1] or #DataModel.makeFurList[DataModel.tabIdx].unLockList
    View.Group_Left.ScrollGrid_Item.grid.self:SetDataCount(cnt)
    View.Group_Left.ScrollGrid_Item.grid.self:RefreshAllElement()
    View.Group_Left.ScrollGrid_Item.grid.self:MoveToTop()
    View.Group_Left.Group_Bottum:SetActive(0 < cnt)
    View.ScrollGrid_.grid.self:SetDataCount(#DataModel.makeFurList)
    View.ScrollGrid_.grid.self:RefreshAllElement()
    View.ScrollGrid_.grid.self:MoveToTop()
    local gridHeight = View.ScrollGrid_.grid.self.ScrollRect.content.sizeDelta.y
    local scrollHeight = gridHeight <= DataModel.scrollHeight and gridHeight or DataModel.scrollHeight
    View.ScrollGrid_.self:SetHeight(scrollHeight)
  end,
  awake = function()
    DataModel.scrollHeight = View.ScrollGrid_.self.Rect.sizeDelta.y
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
