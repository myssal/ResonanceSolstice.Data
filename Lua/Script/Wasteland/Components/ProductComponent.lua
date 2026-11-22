local Component = require("Wasteland/Components/Component")
local Class = require("UIDialog/MetatableClass")
local ProductComponent = Class.New("ProductComponent", Component)

function ProductComponent:Ctor(entity)
end

function ProductComponent:GetType()
  return WastelandEnum.CompType.ProductComponent
end

return ProductComponent
