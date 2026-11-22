local View = require("UIMonopolyGrade/UIMonopolyGradeView")
local DataModel = require("UIMonopolyGrade/UIMonopolyGradeDataModel")
local ViewFunction = require("UIMonopolyGrade/UIMonopolyGradeViewFunction")
local UIMonopolyGradeController = require("UIMonopolyGrade/UIMonopolyGradeController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local isOpenByMap = Json.decode(initParams).isOpenByMap
    DataModel.isOpenByMap = isOpenByMap
    UIMonopolyGradeController.Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    UIMonopolyGradeController.Release()
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
