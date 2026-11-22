local View = require("UIGroup_RapidLeft/UIGroup_RapidLeftView")
local DataModel = require("UIGroup_RapidLeft/UIGroup_RapidLeftDataModel")
local ViewFunction = require("UIGroup_RapidLeft/UIGroup_RapidLeftViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init()
    local count = math.min(DataModel.saveMaxCnt, #DataModel.formulaList)
    View.Img_RmBG.Group_CollectNum.Txt_Num:SetText(count .. "/" .. DataModel.saveMaxCnt)
    count = count < 5 and 5 or count
    View.Img_RmBG.ScrollGrid_.grid.self:SetDataCount(count)
    View.Img_RmBG.ScrollGrid_.grid.self:RefreshAllElement()
    View.Img_RmBG.ScrollGrid_.grid.self:MoveToTop()
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
