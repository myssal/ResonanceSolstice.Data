local View = require("UIRegression/UIRegressionView")
local DataModel = require("UIRegression/UIRegressionDataModel")
local ViewFunction = require("UIRegression/UIRegressionViewFunction")
local Controller = require("UIRegression/UIRegressionController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init()
    View.Group_Title.Img_Text:SetSprite(GetResPath(88300123))
    View.Group_Task.Img_Bottom:SetSprite(GetResPath(88300122))
    View.Group_News.Img_NewsBG.Img_Icon:SetSprite(GetResPath(88300124))
    View.Group_News.Img_NewsBG.Img_Title:SetSprite(GetResPath(88300125))
    View.Group_Welcome.Img_BG:SetSprite(GetResPath(88300120))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local isGet = PlayerData.ServerData.return_info and PlayerData.ServerData.return_info.ret_reward
    if isGet then
      View.Group_Welcome:SetActive(false)
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    DataModel.TaskRewardDetailPanel = nil
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
