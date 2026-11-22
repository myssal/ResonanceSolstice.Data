local View = require("UIKabaneriMain/UIKabaneriMainView")
local DataModel = require("UIKabaneriMain/UIKabaneriMainDataModel")
local ViewFunction = require("UIKabaneriMain/UIKabaneriMainViewFunction")
local Controller = require("UIKabaneriMain/UIKabaneriMainController")

local function Unrequire(path)
  for key, _ in pairs(package.preload) do
    if string.find(tostring(key), path) == 1 then
      package.preload[key] = nil
    end
  end
  for key, _ in pairs(package.loaded) do
    if string.find(tostring(key), path) == 1 then
      package.loaded[key] = nil
    end
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Unrequire("FactoryRegister/Propertys/KabaneriMapFactory")
    Unrequire("FactoryRegister/Propertys/TrainBattleUnitFactory")
    Unrequire("FactoryRegister/Propertys/KabaneriBuffFactory")
    Unrequire("FactoryRegister/Propertys/KabaneriEventFactory")
    require("FactoryRegister/Propertys/KabaneriMapFactory")
    require("FactoryRegister/Propertys/TrainBattleUnitFactory")
    require("FactoryRegister/Propertys/KabaneriBuffFactory")
    require("FactoryRegister/Propertys/KabaneriEventFactory")
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    Controller.Update()
  end,
  ondestroy = function()
    Controller.ClearData()
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
