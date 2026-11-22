local View = require("UIBuildLevel/UIBuildLevelView")
local DataModel = require("UIBuildLevel/UIBuildLevelDataModel")
local ViewFunction = require("UIBuildLevel/UIBuildLevelViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local t = Json.decode(initParams)
      local buildingId = t.buildingId
      local buildCA = PlayerData:GetFactoryData(buildingId)
      DataModel.BuildCA = buildCA
      DataModel.IsCityMapIn = t.IsCityMapIn
      DataModel.IsActivityMainIn = t.IsActivityMainIn
      DataModel.initIndex = t.initIndex or 1
    end
    if DataModel.BuildCA ~= nil then
      DataModel:Init()
    end
    View.Group_Level.Group_Level1.Img_Complete:SetSprite(GetResPath(88300039))
    View.Group_Level.Group_Level2.Img_Complete:SetSprite(GetResPath(88300039))
    View.Group_Level.Group_Level3.Img_Complete:SetSprite(GetResPath(88300039))
    View.Group_Level.Group_Level4.Img_Complete:SetSprite(GetResPath(88300039))
    View.Group_Level.Group_Level5.Img_Complete:SetSprite(GetResPath(88300039))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.monsterLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      DataModel:RefreshRemainTime()
    end
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
