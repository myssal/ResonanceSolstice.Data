local DataModel = require("UIWitchMain/UIWitchMainDataModel")
local Controller = {
  floatList = {},
  floatListCount = -1,
  index = -1,
  isMoving = false,
  hasNext = false,
  isInitialized = false,
  moveNumList = {},
  moveTime = -1,
  occupiedGridEventState = {}
}
local getPrevGrid

local function getRouteGrid(gridId)
  local grid = DataModel.gridList[gridId] or DataModel.gridList[tostring(gridId)]
  if grid ~= nil then
    return grid
  end
  local gridCA = PlayerData:GetFactoryData(gridId, "ParkGridFactory")
  if gridCA ~= nil then
    return {
      id = gridCA.id,
      posX = gridCA.x,
      posY = gridCA.y
    }
  end
end

local function lookAtGrid(view, grid)
  local target = Vector3(grid.posX, view.transform.position.y, grid.posY)
  local direction = (target - view.transform.position).normalized
  direction.y = 0
  view.transform.forward = direction
end

local function playFloatAnim(animName)
  for _, floatData in ipairs(Controller.floatList) do
    if floatData.animator ~= nil then
      floatData.animator:Play(animName)
    end
  end
end

local function syncOccupiedGridEventView()
  local occupiedGrid = {}
  local head = Controller.floatList[1]
  local currentGrid = head and getRouteGrid(head.gridId)
  local parkMapCA = WitchData.GetParkMapCA()
  local carLengthNum = parkMapCA and tonumber(parkMapCA.carLengthNum) or 0
  local direction = WitchData.GetDirection() or 1
  for i = 1, carLengthNum do
    if currentGrid == nil then
      break
    end
    for gridId, gridData in pairs(DataModel.gridList) do
      if gridData.posX == currentGrid.posX and gridData.posY == currentGrid.posY then
        occupiedGrid[gridId] = true
      end
    end
    currentGrid = getPrevGrid(currentGrid, direction)
  end
  for gridId, eventState in pairs(Controller.occupiedGridEventState) do
    if not occupiedGrid[gridId] then
      if eventState.view ~= nil then
        eventState.view:SetActive(eventState.wasActive)
      end
      Controller.occupiedGridEventState[gridId] = nil
    end
  end
  for gridId in pairs(occupiedGrid) do
    if not Controller.occupiedGridEventState[gridId] then
      local grid = DataModel.gridList[gridId]
      if grid and grid.eventView ~= nil then
        Controller.occupiedGridEventState[gridId] = {
          view = grid.eventView,
          wasActive = grid.eventView.activeSelf
        }
        grid.eventView:SetActive(false)
      end
    end
  end
end

local function updateOccupiedGrid(headGridId)
  for i = Controller.floatListCount, 2, -1 do
    Controller.floatList[i].gridId = Controller.floatList[i - 1].gridId
  end
  Controller.floatList[1].gridId = headGridId
  syncOccupiedGridEventView()
end

local function getGridIndex(id, list)
  local index = -1
  for k, v in pairs(list) do
    if v.id == id then
      index = k
      break
    end
  end
  return index
end

function getPrevGrid(curGrid, dir)
  local floatRouteId = WitchData.GetWitchesData().float_route
  local floatRouteList = PlayerData:GetFactoryData(floatRouteId, "ListFactory").carRouteList
  local curIndex = getGridIndex(curGrid.id, floatRouteList)
  if 0 < dir then
    curIndex = curIndex - 1
    if curIndex < 1 then
      curIndex = table.count(floatRouteList)
    end
  else
    curIndex = curIndex + 1
    if curIndex > table.count(floatRouteList) then
      curIndex = 1
    end
  end
  local id = floatRouteList[curIndex].id
  return getRouteGrid(id)
end

local function getNextGrid(curGrid, dir)
  local floatRouteId = WitchData.GetWitchesData().float_route
  local floatRouteList = PlayerData:GetFactoryData(floatRouteId, "ListFactory").carRouteList
  local curIndex = getGridIndex(curGrid.id, floatRouteList)
  if dir < 0 then
    curIndex = curIndex - 1
    if curIndex < 1 then
      curIndex = table.count(floatRouteList)
    end
  else
    curIndex = curIndex + 1
    if curIndex > table.count(floatRouteList) then
      curIndex = 1
    end
  end
  local id = floatRouteList[curIndex].id
  return getRouteGrid(id)
end

local function updateHead(head)
  if Controller.hasNext then
    Controller.hasNext = false
    local grid = Controller.moveNumList[1]
    DOTweenTools.DOLocalMoveCallback(head.view.transform, grid.posX, DataModel.defualtAxisY, grid.posY, Controller.moveTime, function()
      table.remove(Controller.moveNumList, 1)
      updateOccupiedGrid(grid.id)
      local direction = WitchData.GetDirection()
      local next = getNextGrid(grid, direction)
      lookAtGrid(head.view, next)
      if table.count(Controller.moveNumList) > 0 then
        Controller.hasNext = true
      else
        WitchData.SetFloatLoc(grid.id)
        Controller.hasNext = false
        Controller.isMoving = false
        playFloatAnim("Idle")
      end
    end)
  end
end

local function calculateFloatPos(current, parent)
  local x = parent.posX
  local y = parent.posY
  if parent.posX ~= current.posX and parent.posY ~= current.posY then
    local resultX = math.abs(parent.posX - current.posX)
    local resultY = math.abs(parent.posY - current.posY)
    local diff = resultX + resultY - current.interval
    if current.isMoveX == true then
      if parent.posX > current.posX then
        x = current.posX + diff
        x = math.max(x, current.posX)
        x = math.min(x, parent.posX)
      else
        x = current.posX - diff
        x = math.max(x, parent.posX)
        x = math.min(x, current.posX)
      end
      y = current.posY
    else
      if parent.posY > current.posY then
        y = current.posY + diff
        y = math.max(y, current.posY)
        y = math.min(y, parent.posY)
      else
        y = current.posY - diff
        y = math.max(y, parent.posY)
        y = math.min(y, current.posY)
      end
      x = current.posX
    end
  elseif parent.posX == current.posX then
    if parent.posY > current.posY then
      y = parent.posY - current.interval
    else
      y = parent.posY + current.interval
    end
    current.isMoveX = false
  elseif parent.posY == current.posY then
    if parent.posX > current.posX then
      x = parent.posX - current.interval
    else
      x = parent.posX + current.interval
    end
    current.isMoveX = true
  end
  current.posX = x
  current.posY = y
  current.view.transform.position = Vector3(x, 0.0, y)
  DataModel.LookAt(current.view, parent.view)
end

function Controller:Init()
  self.isInitialized = false
  self.isMoving = false
  self.hasNext = false
  local floats = CS.UnityEngine.GameObject.Find("huache")
  if floats ~= nil then
    local floatHeadLoc = WitchData.GetWitchesData().float_loc
    floatHeadLoc = tonumber(floatHeadLoc)
    local floatViewcount = floats.transform.childCount
    local parent
    for i = 1, floatViewcount do
      local view = floats.transform:GetChild(i - 1).gameObject
      local floatData = {}
      floatData.interval = 1.5
      floatData.posX = view.transform.position.x
      floatData.posY = view.transform.position.z
      floatData.view = view
      floatData.animator = view:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
      floatData.parent = parent
      table.insert(self.floatList, floatData)
      parent = floatData
    end
    local floatDirection = WitchData.GetDirection()
    if floatDirection == nil then
      floatDirection = 1
    end
    local curGrid = getRouteGrid(floatHeadLoc)
    local head = self.floatList[1]
    if curGrid ~= nil and head ~= nil then
      local nextGrid = getNextGrid(curGrid, floatDirection)
      head.posX = curGrid.posX
      head.posY = curGrid.posY
      head.gridId = curGrid.id
      head.view.transform.position = Vector3(curGrid.posX, 0, curGrid.posY)
      lookAtGrid(head.view, nextGrid)
      local countFloatList = table.count(self.floatList)
      for i = 2, countFloatList do
        local child = self.floatList[i]
        curGrid = getPrevGrid(curGrid, floatDirection)
        child.posX = curGrid.posX
        child.posY = curGrid.posY
        child.gridId = curGrid.id
        child.view.transform.position = Vector3(curGrid.posX, 0, curGrid.posY)
        child.isMoveX = child.posX ~= head.posX
        head = child
      end
      self.floatListCount = countFloatList
      self.isInitialized = true
      syncOccupiedGridEventView()
      playFloatAnim("Idle")
      self.isMoving = true
      DOTweenTools.Delay(1, function()
        self.isMoving = false
      end)
    end
  end
end

function Controller:DoMove()
  if not self.isInitialized then
    return
  end
  self.moveNumList = {}
  local direction = WitchData.GetDirection()
  local moveCount = DataModel.float_moveNum
  local floatLoc = WitchData.GetFloatLoc()
  local grid = getRouteGrid(floatLoc)
  for i = 1, moveCount do
    grid = getNextGrid(grid, direction)
    table.insert(self.moveNumList, grid)
  end
  self.moveTime = 1.0 / moveCount
  self.hasNext = true
  self.isMoving = true
  playFloatAnim("Walk")
end

function Controller:OnUpdate()
  if self.isInitialized and self.isMoving then
    local head = self.floatList[1]
    if head == nil or head.view == nil then
      self.isInitialized = false
      self.isMoving = false
      return
    end
    head.posX = head.view.transform.position.x
    head.posY = head.view.transform.position.z
    updateHead(head)
    for i = 2, self.floatListCount do
      local current = self.floatList[i]
      calculateFloatPos(current, current.parent)
    end
  end
end

function Controller:Clear()
  for _, eventState in pairs(self.occupiedGridEventState) do
    if eventState.view ~= nil then
      eventState.view:SetActive(eventState.wasActive)
    end
  end
  self.occupiedGridEventState = {}
  for _, v in pairs(self.floatList) do
    v.view = nil
    v.animator = nil
    v.parent = nil
  end
  self.floatList = {}
  self.floatListCount = -1
  self.index = -1
  self.isInitialized = false
  self.isMoving = false
  self.hasNext = false
  self.moveNumList = {}
  self.moveTime = -1
end

return Controller
