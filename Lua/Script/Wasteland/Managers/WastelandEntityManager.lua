local Entity = require("Wasteland/Entity/Entity")
local ViewStateComponent = require("Wasteland/Components/ViewStateComponent")
local BuildingViewComponent = require("Wasteland/Components/BuildingViewComponent")
local AttrComponent = require("Wasteland/Components/AttrComponent")
local Manager = {}

function Manager:Init()
  self.entities = {}
end

function Manager:CreateEntity(caId)
  local entityId = WasteLandUtility.GenerateEntityId()
  local entityCA = PlayerData:GetFactoryData(caId, "WasteLandEntityFactory")
  local entityType = entityCA.entityType
  local entity = Entity.New(entityId, caId)
  local entityProduct = WasteLandManager:CreateEntity(91500001, entityId)
  local viewId = self:GetEntityViewId(caId)
  if viewId then
    entityProduct:ChangeView(viewId)
  end
  entity.entityProduct = entityProduct
  if entityType == WastelandEnum.EntityType.Item then
    entity:GetViewTrans():GetChild(1).gameObject:SetActive(false)
  end
  self:InitComponents(entity)
  self.entities[entityId] = entity
  WastelandEventManager:Trigger(WastelandEnum.Event.OnEntityCreate, entity)
  return entity
end

function Manager:InitComponents(entity)
  local ca = entity:GetCa()
  entity:AddComponent(ViewStateComponent.New(entity))
  entity:AddComponent(AttrComponent.New(entity))
  for i, component in pairs(entity.components) do
    component:Init()
  end
end

function Manager:GetEntityViewId(caId)
  local entityCA = PlayerData:GetFactoryData(caId, "WasteLandEntityFactory")
  local data = entityCA.view[1] or entityCA.spriteView[1]
  return data and data.id
end

function Manager:GetEntity(entityId)
  return self.entities[entityId]
end

function Manager:GetEntitiesByPos(x, y, entityType)
  local t = {}
  for i, entity in pairs(self.entities) do
    local pos = entity:GetPosition()
    if pos.x == x and pos.y == y then
      if entityType then
        if entity.ca.entityType == entityType then
          table.insert(t, entity)
        end
      else
        table.insert(t, entity)
      end
    end
  end
  return t
end

function Manager:RecycleEntity(entity)
  local entityCA = entity.ca
  local entityType = entityCA.entityType
  if entityType == WastelandEnum.EntityType.Item then
    entity:GetViewTrans():GetChild(1).gameObject:SetActive(true)
  end
  entity:Recycle()
  self.entities[entity:GetEntityId()] = nil
end

function Manager:RecycleEntities(entityType)
  if entityType then
    local recycleMap = {}
    for k, entity in pairs(self.entities) do
      if entity.ca.entityType == entityType then
        recycleMap[k] = entity
      end
    end
    for k, entity in pairs(recycleMap) do
      self.entities[k] = nil
      entity:Recycle()
    end
  else
    for i, entity in pairs(self.entities) do
      entity:Recycle()
    end
    self.entities = {}
  end
end

function Manager:Destroy()
  for i, v in pairs(self.entities) do
    v:Destroy()
  end
  self.entities = {}
end

return Manager
