local Class = require("UIDialog/MetatableClass")
local SystemBase = Class.New("SystemBase")

function SystemBase:Ctor()
  self.requiredComponents = {}
end

function SystemBase:Init()
  self:RegisterEvents()
end

function SystemBase:RegisterEvents()
end

function SystemBase:GetType()
  return self.systemType
end

function SystemBase:Update(deltaTime)
end

function SystemBase:GetEntities()
  local t = {}
  local entities = WastelandEntityManager.entities
  for i, entity in pairs(entities) do
    local find = true
    for i, componentType in pairs(self.requiredComponents) do
      if not entity:GetComponent(componentType) then
        find = false
        break
      end
    end
    if find then
      table.insert(t, entity)
    end
  end
  return t
end

function SystemBase:Dtor()
  WastelandEventManager:RemoveListener(self)
end

function SystemBase:Destroy()
  self:Dispose()
end

return SystemBase
