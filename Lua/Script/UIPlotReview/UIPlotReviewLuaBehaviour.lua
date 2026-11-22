local View = require("UIPlotReview/UIPlotReviewView")
local DataModel = require("UIPlotReview/UIPlotReviewDataModel")
local ViewFunction = require("UIPlotReview/UIPlotReviewViewFunction")
local Controller = require("UIPlotReview/UIPlotReviewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    Controller.RefreshOnShow()
    DataModel.isAnecdoteJump = false
    if initParams then
      local data = Json.decode(initParams)
      if data.chapterId then
        Controller.InitView("99900078")
        local nowIdx = DataModel.GetAnecdoteSelectIdx(data.chapterId)
        View.Img_Bg1.Group_Tab.ScrollGrid_.grid.self:MoveToPos(nowIdx)
        Controller.ChapterBtn(nowIdx)
        DataModel.isAnecdoteJump = true
      end
    end
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
