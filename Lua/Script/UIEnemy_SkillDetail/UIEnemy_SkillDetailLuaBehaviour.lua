local View = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailView")
local DataModel = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailDataModel")
local ViewFunction = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailViewFunction")
local Controller = require("UIEnemy_SkillDetail/UIEnemy_SkillDetailController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.levelId = data.levelId
      DataModel.isInBattle = data.isInBattle
      DataModel.enemyId = data.enemyId
      Controller:Init()
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
