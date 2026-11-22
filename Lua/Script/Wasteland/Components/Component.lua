local Class = require("UIDialog/MetatableClass")
local Component = Class.New("Component")

function Component:Ctor(entity)
  self.entity = entity
  self.enable = true
end

function Component:GetType()
end

function Component:SetEnable(enable)
  self.enable = enable
  if enable then
    self:OnEnable()
  else
    self:OnDisable()
  end
end

function Component:Init()
end

function Component:OnUpdate()
end

function Component:OnEnable()
end

function Component:OnDisable()
end

function Component:Recycle()
  self:Dispose()
end

function Component:Dtor()
  self.entity = nil
  self.enable = false
end

return Component
