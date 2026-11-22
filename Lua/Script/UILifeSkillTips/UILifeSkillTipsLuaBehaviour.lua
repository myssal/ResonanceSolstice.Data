local View = require("UILifeSkillTips/UILifeSkillTipsView")
local DataModel = require("UILifeSkillTips/UILifeSkillTipsDataModel")
local ViewFunction = require("UILifeSkillTips/UILifeSkillTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.decodeParams = Json.decode(initParams)
    DataModel.init()
    local count = #DataModel.life_list
    View.ScrollGrid_SkillList.grid.self:SetDataCount(count)
    View.ScrollGrid_SkillList.grid.self:MoveToTop()
    View.ScrollGrid_SkillList.grid.self:RefreshAllElement()
    if count <= 3 then
      View.ScrollGrid_SkillList.self:SetHeight(DataModel.rolHeight * count)
      View.ScrollGrid_SkillList.self:SetEnable(false)
    else
      View.ScrollGrid_SkillList.self:SetHeight(DataModel.rolHeight * 3.5)
      View.ScrollGrid_SkillList.self:SetEnable(true)
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
