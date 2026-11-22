local SystemBase = require("Wasteland/Systems/SystemBase")
local Class = require("UIDialog/MetatableClass")
local ViewSyncSystem = Class.New("ViewSyncSystem", SystemBase)

function ViewSyncSystem:Ctor()
  self.systemType = WastelandEnum.SystemType.ViewSyncSystem
  self.requiredComponents = {
    WastelandEnum.CompType.ViewStateComponent
  }
end

function ViewSyncSystem:RegisterEvents()
  WastelandEventManager:AddListener(WastelandEnum.Event.OnEntityCreate, self.OnEntityCreate, self)
end

function ViewSyncSystem:OnEntityCreate(entity)
  entity:SetDefaultColor()
end

function ViewSyncSystem:Update(deltaTime)
  local entities = self:GetEntities()
  for _, entity in ipairs(entities) do
    self:UpdateViewState(entity, deltaTime)
  end
end

function ViewSyncSystem:UpdateViewState(entity, deltaTime)
  local viewStateComp = entity:GetViewStateComp()
  if viewStateComp.viewState == WastelandEnum.ViewState.Normal then
  elseif viewStateComp.viewState == WastelandEnum.ViewState.GetHit then
    viewStateComp.hitEffectFrame = viewStateComp.hitEffectFrame - 1
    if viewStateComp.hitEffectFrame == 0 then
      viewStateComp:SetViewState(entity, WastelandEnum.ViewState.Normal)
      entity:SetDefaultColor()
    end
  end
end

return ViewSyncSystem
