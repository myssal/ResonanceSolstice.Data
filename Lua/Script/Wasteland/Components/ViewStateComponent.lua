local Component = require("Wasteland/Components/Component")
local Class = require("UIDialog/MetatableClass")
local ViewStateComponent = Class.New("ViewStateComponent", Component)

function ViewStateComponent:Ctor(entity)
  self.viewState = WastelandEnum.ViewState.Normal
  self.hitEffectFrame = 0
end

function ViewStateComponent:GetType()
  return WastelandEnum.CompType.ViewStateComponent
end

function ViewStateComponent:SetViewState(state)
  self.viewState = state
  if state == WastelandEnum.ViewState.GetHit then
    self.hitEffectFrame = 3
  else
    self.hitEffectFrame = 0
  end
end

return ViewStateComponent
