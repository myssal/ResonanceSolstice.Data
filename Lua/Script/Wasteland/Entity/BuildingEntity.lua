local EntityBase = require("Wasteland/Entity/Entity")
local Class = require("UIDialog/MetatableClass")
local Entity = Class.New("BuildingEntity", EntityBase)

function Entity:Ctor(entityId, caId)
  self:InitDirection()
end

function Entity:AddPort(localPos, dir, inOut)
  if inOut == 0 then
    return
  end
  local pos = string.format("%d_%d", localPos.x, localPos.y)
  self.port[pos] = self.port[pos] or {pos = localPos}
  self.port[pos][inOut] = self.port[pos][inOut] or {}
  dir = dir % 4
  local xOff = 0
  local yOff = 0
  if dir == 0 then
    yOff = -1
  elseif dir == 1 then
    xOff = -1
  elseif dir == 2 then
    yOff = 1
  elseif dir == 3 then
    xOff = 1
  end
  table.insert(self.port[pos][inOut], Vector2Int(xOff, yOff))
end

function Entity:InitDirection()
  self.port = {}
  if self.ca.buildingType == "conveyerBelt" then
    return
  end
  local curDir = self.data.direct
  local eWidth = self.ca.width
  local eHeight = self.ca.height
  if curDir % 2 == 0 then
    self.leftDownPosXOff = 1 - math.floor((eWidth + 1) / 2)
    self.leftDownPosYOff = 1 - math.floor((eHeight + 1) / 2)
  else
    self.leftDownPosXOff = 1 - math.floor((eHeight + 1) / 2)
    self.leftDownPosYOff = 1 - math.floor((eWidth + 1) / 2)
  end
  for k, v in pairs(self.ca.interfaceList) do
    local xAxis = v.xAxis
    local yAxis = v.yAxis
    if curDir == 1 then
      xAxis = v.yAxis
      yAxis = eWidth - v.xAxis + 1
    elseif curDir == 2 then
      xAxis = eWidth - v.xAxis + 1
      yAxis = eHeight - v.yAxis + 1
    elseif curDir == 3 then
      xAxis = eHeight - v.yAxis + 1
      yAxis = v.xAxis
    end
    self:AddPort(Vector2Int(xAxis, yAxis), 0 + curDir, v.lowerEdgeInt)
    self:AddPort(Vector2Int(xAxis, yAxis), 1 + curDir, v.leftEdgeInt)
    self:AddPort(Vector2Int(xAxis, yAxis), 2 + curDir, v.upperEdgeInt)
    self:AddPort(Vector2Int(xAxis, yAxis), 3 + curDir, v.rightEdgeInt)
  end
end

function Entity:HighLightPort(active, posX, posY)
  self:ForeachAllPort(function(entity, portX, portY, inOut, off)
    WasteLandSearchGameManager.tileHandler:TileActive(portX, portY, active)
    local cell = WasteLandSearchGameManager:GetCellEntity(portX, portY)
    if cell == nil then
      return
    end
    cell.isPort = active
    cell.from = nil
    cell.to = nil
    if active then
      if inOut == 1 then
        cell.from = nil
        cell.to = Vector2Int(-off.x, -off.y)
        WasteLandSearchGameManager.tileHandler:TileSelectedShow(portX, portY)
      elseif inOut == 2 then
        cell.from = Vector2Int(-off.x, -off.y)
        cell.to = nil
        WasteLandSearchGameManager.tileHandler:TileConflictShow(portX, portY)
      end
    end
  end, posX, posY)
end

function Entity:ForeachAllPort(action, posX, posY)
  local centerOffX, centerOffY
  local viewCom = self:GetComponent(WastelandEnum.CompType.BuildingViewComponent)
  if viewCom == nil then
    if self.data.initPos then
      posX = self.data.initPos.x
      posY = self.data.initPos.y
    end
    local width = self.ca.width
    local height = self.ca.height
    if self.data.direct % 2 > 0 then
      width = self.ca.height
      height = self.ca.width
    end
    centerOffX = math.floor((width - 1) / 2)
    centerOffY = math.floor((height - 1) / 2)
  else
    posX = posX or viewCom.curPosX
    posY = posY or viewCom.curPosY
    centerOffX = viewCom.centerOffX
    centerOffY = viewCom.centerOffY
  end
  for k, posData in pairs(self.port) do
    local worldX = posX - centerOffX + posData.pos.x - 1
    local worldY = posY - centerOffY + posData.pos.y - 1
    if posData[1] then
      for m, off in pairs(posData[1]) do
        local portX = worldX + off.x
        local portY = worldY + off.y
        if action then
          action(self, portX, portY, 1, off)
        end
      end
    end
    if posData[2] then
      for m, off in pairs(posData[2]) do
        local portX = worldX + off.x
        local portY = worldY + off.y
        if action then
          action(self, portX, portY, 2, off)
        end
      end
    end
  end
end

function Entity:Dtor()
  self.port = nil
  self.valid = false
end

return Entity
