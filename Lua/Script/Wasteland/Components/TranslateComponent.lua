local Component = require("Wasteland/Components/Component")
local Class = require("UIDialog/MetatableClass")
local TranslateComponent = Class.New("TranslateComponent", Component)

function TranslateComponent:Ctor(entity)
end

function TranslateComponent:GetType()
  return WastelandEnum.CompType.TranslateComponent
end

return TranslateComponent
