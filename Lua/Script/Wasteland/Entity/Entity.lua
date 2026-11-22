local Class = require("UIDialog/MetatableClass")
local Entity = Class.New("WasteLandEntity")

function Entity:Ctor(entityId, caId)
  self.entityId = entityId
  self.caId = caId
  self.ca = PlayerData:GetFactoryData(caId, "WasteLandEntityFactory")
  self.components = {}
  self.valid = true
end

function Entity:GetViewStateComp()
  return self:GetComponent(WastelandEnum.CompType.ViewStateComponent)
end

function Entity:GetAttrComp()
  return self:GetComponent(WastelandEnum.CompType.AttrComponent)
end

function Entity:GetCaId()
  return self.caId
end

function Entity:GetCa()
  return self.ca
end

function Entity:GetEntityId()
  return self.entityId
end

function Entity:AddComponent(component)
  local compType = component:GetType()
  if self.components[compType] then
    return
  end
  self.components[compType] = component
end

function Entity:RemoveComponent(compType)
  local component = self.components[compType]
  if not component then
    return
  end
  self.components[compType] = nil
end

function Entity:GetComponent(compType)
  return self.components[compType]
end

function Entity:IsValid()
  return self.valid
end

function Entity:GetContainerTrans()
  return self.entityProduct and self.entityProduct:GetContainer()
end

function Entity:GetViewTrans()
  return self.entityProduct and self.entityProduct:GetViewTrans()
end

function Entity:GetPosition()
  if self.entityProduct then
    return self:GetViewTrans().position
  end
end

function Entity:GetViewCA()
  if self.entityProduct and self.entityProduct.view then
    return PlayerData:GetFactoryData(self.entityProduct.view.ca.id, "WasteLandEntityViewFactory")
  end
  return nil
end

function Entity:SetPosition(x, y, z)
  if self.entityProduct then
    if type(x) == "number" then
      self:GetContainerTrans().position = Vector3(x, y, z)
    else
      self:GetContainerTrans().position = x
    end
  end
end

function Entity:SetShadowPosition(x, y, z)
  local shadowEffect = self.entityProduct and self.entityProduct:GetShadowEffect()
  if shadowEffect then
    shadowEffect:SetLocalPosition(x, y, z)
  end
end

function Entity:SetScale(x, y, z)
  if self.entityProduct then
    self.entityProduct:GetViewTrans().localScale = Vector3(x, y, z)
  end
end

function Entity:SetShadowScale(scaleX, scaleY)
  local shadowEffect = self.entityProduct and self.entityProduct:GetShadowEffect()
  if shadowEffect then
    shadowEffect:SetScale(scaleX, scaleY)
  end
end

function Entity:SetActive(active)
  if self.entityProduct then
    self.entityProduct:SetModelActive(active)
  end
  self:SetShadowActive(active)
end

function Entity:SetShadowActive(active)
  local shadowEffect = self.entityProduct and self.entityProduct:GetShadowEffect()
  if shadowEffect then
    shadowEffect:SetActive(active)
  end
end

function Entity:SetSortingLayer(layerName)
  if self.entityProduct then
    self.entityProduct:SetSortingLayer(layerName)
  end
end

function Entity:SetSortOrder(order)
  if self.entityProduct then
    self.entityProduct:SetSortOrder(order)
  end
end

function Entity:SetShadowSortOrder(order)
  local shadowEffect = self.entityProduct and self.entityProduct:GetShadowEffect()
  if shadowEffect then
    shadowEffect:SetSortOrder(order)
  end
end

function Entity:SetViewPosition(localPos)
  if self.entityProduct then
    self.entityProduct:GetViewTrans().localPosition = localPos
  end
end

function Entity:SetHitColor()
  local viewCA = self:GetViewCA()
  if viewCA.mod == "Spine" then
    self.entityProduct:SetColor("#FFFFFF", 1)
  elseif viewCA.mod == "Prefab" then
    self.entityProduct:SetColor("#FFFFFF", 0.5, 2)
  end
end

function Entity:SetDefaultColor()
  local viewCA = self:GetViewCA()
  if viewCA.mod == "Spine" then
    self.entityProduct:SetColor("#FFFFFF", 0)
  elseif viewCA.mod == "Prefab" then
    self.entityProduct:SetColor("#FFFFFF", 1, 0)
  end
end

function Entity:PlayAnim(aniName, callBack)
  if self.entityProduct then
    self.entityProduct:PlayAnim(aniName, callBack)
  end
end

function Entity:PlaySpineAnim(aniName, isLoop, isChangeImmediately, callBack)
  if self.entityProduct then
    if isLoop == nil then
      isLoop = true
    end
    if isChangeImmediately == nil then
      isChangeImmediately = true
    end
    self.entityProduct:PlaySpineAnim(aniName, isLoop, isChangeImmediately, callBack)
  end
end

function Entity:ChangeSpineSkin(skinJson, takeOn)
  if self.entityProduct then
    self.entityProduct:ChangeSpineSkin(skinJson, takeOn)
  end
end

function Entity:ChangeSpineAttachment(attachmentsJson, takeOn)
  if self.entityProduct then
    if takeOn == nil then
      takeOn = true
    end
    self.entityProduct:ChangeSpineAttachment(attachmentsJson, takeOn)
  end
end

function Entity:IsStatic()
  return true
end

function Entity:Recycle()
  for _, comp in pairs(self.components) do
    comp:Recycle()
  end
  if self.entityProduct then
    self.entityProduct:Recycle()
  end
  self.entityProduct = nil
  self.valid = false
end

function Entity:Destroy()
  for _, comp in pairs(self.components) do
    comp:Recycle()
  end
  self.entityProduct = nil
  if self.entityProduct then
    self.entityProduct:Destroy()
  end
  self.valid = false
end

return Entity
