local SystemManager = {
  systems = {},
  systemList = {}
}

function SystemManager:Init()
  self.systems = {}
  self.systemList = {}
  self:RegisterSystem(require("Wasteland/Systems/ViewSyncSystem").New())
  self:RegisterSystem(require("Wasteland/Systems/HpBarSystem").New())
end

function SystemManager:RegisterSystem(system)
  local systemType = system:GetType()
  if self.systems[systemType] then
    return
  end
  system:Init()
  self.systems[systemType] = system
  table.insert(self.systemList, system)
end

function SystemManager:GetSystem(systemType)
  return self.systems[systemType]
end

function SystemManager:Update()
  for _, system in ipairs(self.systemList) do
    system:Update(Time.deltaTime)
  end
end

function SystemManager:Destroy()
  for _, system in ipairs(self.systemList) do
    system:Destroy()
  end
  self.systems = {}
  self.systemList = {}
end

return SystemManager
