local Component = require("Wasteland/Components/Component")
local Class = require("UIDialog/MetatableClass")
local ViewComponent = Class.New("BuildingViewComponent", Component)

function ViewComponent:Ctor(entity)
  local entityCA = self.entity.ca
  local entityViewCA = self.entity:GetViewCA()
  local entityProduct = self.entity.entityProduct
  self.posOffX = 0
  self.posOffY = 0
  if entityProduct.width % 2 == 0 then
    self.posOffX = 0.5
  end
  if entityProduct.height % 2 == 0 then
    self.posOffY = 0.5
  end
  self.centerOffX = math.floor((entityProduct.width - 1) / 2)
  self.centerOffY = math.floor((entityProduct.height - 1) / 2)
end

function ViewComponent:GetType()
  return WastelandEnum.CompType.BuildingViewComponent
end

function ViewComponent:SetPosition(worldPos, changeData)
  changeData = changeData == nil and true or changeData
  if changeData then
    self:ForeachAllGrid(function(worldX, worldY, entity)
    end)
    self.entity:ForeachAllPort(function(entity, portX, portY, inOut, off)
    end)
  end
  self.curPosX = worldPos.x
  self.curPosY = worldPos.y
  if changeData then
    self:ForeachAllGrid(function(worldX, worldY, entity)
    end)
    self.entity:ForeachAllPort(function(entity, portX, portY, inOut, off)
    end)
  end
  self.entity:SetPosition(worldPos.x + self.posOffX, worldPos.y + self.posOffY, worldPos.z)
end

function ViewComponent:ShowImpactGrid(active, posX, posY, force)
  local entityProduct = self.entity.entityProduct
  local oldPosX = self.curShowPosX or self.curPosX
  local oldPosY = self.curShowPosY or self.curPosY
  local curPosX = posX or self.curPosX
  local curPosY = posY or self.curPosY
  local startX = oldPosX - self.centerOffX
  local startY = oldPosY - self.centerOffY
  local width = entityProduct.width
  local height = entityProduct.height
  local posChanged = curPosX ~= oldPosX or curPosY ~= oldPosY
  if not active or posChanged then
    for i = 0, width - 1 do
      for j = 0, height - 1 do
        local tempX = startX + i
        local tempY = startY + j
        WasteLandManager:ShowTile(tempX, tempY, 0, false)
      end
    end
    self.entity:HighLightPort(false, oldPosX, oldPosY)
  end
  if not active then
    return true
  end
  local canBuild = true
  if force or posChanged then
    self.curShowPosX = curPosX
    self.curShowPosY = curPosY
    startX = self.curShowPosX - self.centerOffX
    startY = self.curShowPosY - self.centerOffY
    for i = 0, width - 1 do
      for j = 0, height - 1 do
        local tempX = startX + i
        local tempY = startY + j
        local _type = 1
        if WasteLandSearchGameManager:CheckCellEntity(Vector2Int(tempX, tempY), self.entity:GetEntityId()) then
          _type = 2
          canBuild = false
        end
        WasteLandManager:ShowTile(tempX, tempY, _type, true)
      end
    end
  end
  self.entity:ForeachAllPort(function(entity, portX, portY, inOut, off)
    local _type = 1
    if WasteLandSearchGameManager:CheckCellEntity(Vector2Int(portX, portY), entity:GetEntityId()) then
      _type = 2
      canBuild = false
    end
    WasteLandManager:ShowTile(portX, portY, _type, true)
  end, curPosX, curPosY)
  return canBuild
end

function ViewComponent:ForeachAllGrid(call)
  local entityProduct = self.entity.entityProduct
  local startX = self.curPosX - self.centerOffX
  local startY = self.curPosY - self.centerOffY
  local width = entityProduct.width
  local height = entityProduct.height
  for i = 0, width - 1 do
    for j = 0, height - 1 do
      local tempX = startX + i
      local tempY = startY + j
      if call then
        call(tempX, tempY, self.entity)
      end
    end
  end
end

function ViewComponent:Dtor()
end

return ViewComponent
