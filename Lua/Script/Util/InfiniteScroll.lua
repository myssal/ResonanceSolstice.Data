local Class = require("UIDialog/MetatableClass")
local Ctrl = Class.New("InfiniteScroll")
local Tool = require("UICubeRogueMain/CubeRoguePublicMethod")

local function SetAnchor(rectTrans)
  local temp = Vector2(0, 1)
  rectTrans.anchorMax = temp
  rectTrans.anchorMin = temp
  rectTrans.pivot = temp
end

local function ShowItem(self, item, dataIndex)
  dataIndex = (dataIndex - 1) % self.dataCount + 1
  if self.showItemCb then
    self.showItemCb(item, dataIndex)
  end
end

local function OnScrollToIndex(self, dataIndex, isInit)
  dataIndex = (dataIndex - 1) % self.dataCount + 1
  if self.scrollToCb then
    self.scrollToCb(dataIndex, isInit)
  end
end

local function MoveToCurItem(self)
  local target
  local itemPos = self.curItem:GetAnchoredPosition()
  local dragPos = self.drag:GetAnchoredPosition()
  if self.isVertical then
    if itemPos.y <= -self.viewSize then
      target = self.viewSize + self.spacing
    else
      target = 0
    end
    if math.abs(dragPos.y - target) > 1 then
      self.isMoving = true
      self.dragTargetPosX = nil
      self.dragTargetPosY = target
      if target > dragPos.y then
        self.movingSpeed = math.abs(self.movingSpeed)
      else
        self.movingSpeed = -math.abs(self.movingSpeed)
      end
    else
      self.drag:SetAnchoredPositionY(target)
    end
  else
    if itemPos.x >= self.viewSize then
      target = -self.viewSize - self.spacing
    else
      target = 0
    end
    if 1 < math.abs(dragPos.x - target) then
      self.isMoving = true
      self.dragTargetPosX = target
      self.dragTargetPosY = nil
      if target > dragPos.x then
        self.movingSpeed = math.abs(self.movingSpeed)
      else
        self.movingSpeed = -math.abs(self.movingSpeed)
      end
    else
      self.drag:SetAnchoredPositionX(target)
    end
  end
end

local function newBeginDrag(self, eventData)
  self.isDragging = true
  self.dragStartPos = self.drag:GetAnchoredPosition()
  self.startPos = eventData.position
  self.startDataIndex = self.curDataIndex
end

local function OnBeginDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  newBeginDrag(self, eventData)
  do return end
  self.isDragging = true
  self.dragStartPos = self.drag:GetAnchoredPosition()
  self.dragChange = Vector2.zero
end

local function newDrag(self, eventData)
  local dragDelta = (eventData.position - self.startPos) * self.dragScale
  local dragPeriod = self.viewSize + self.spacing
  if self.limitDrag then
    dragDelta.x = math.max(math.min(dragPeriod, dragDelta.x), -dragPeriod)
    dragDelta.y = math.max(math.min(dragPeriod, dragDelta.y), -dragPeriod)
  end
  local scrollLimit = self.viewSize * self.scrollLimit
  local change = 0
  local remainder = 0
  local dataChange = 0
  local symbol = 1
  local curDataIndex, nextDataIndex, item1Show, item2Show
  local tempStartPos = 0
  if self.isVertical then
    change = dragDelta.y
    if change == 0 then
      return
    end
    if change < 0 then
      symbol = -1
      tempStartPos = dragPeriod
    end
    remainder = change * symbol % dragPeriod * symbol
    dataChange = math.floor(change * symbol / dragPeriod)
    curDataIndex = self.startDataIndex + dataChange * symbol
    nextDataIndex = curDataIndex + symbol
    if 0 < change then
      self.curItem = self.item1
      self.nextItem = self.item2
      item1Show = curDataIndex
      item2Show = nextDataIndex
    else
      self.curItem = self.item2
      self.nextItem = self.item1
      item1Show = nextDataIndex
      item2Show = curDataIndex
    end
    if scrollLimit < remainder * symbol then
      local tempIndex = curDataIndex
      curDataIndex = nextDataIndex
      nextDataIndex = tempIndex
      local temp = self.curItem
      self.curItem = self.nextItem
      self.nextItem = temp
    end
    if item1Show ~= self.item1Show then
      self.item1Show = item1Show
      ShowItem(self, self.item1, self.item1Show)
    end
    if item2Show ~= self.item2Show then
      self.item2Show = item2Show
      ShowItem(self, self.item2, self.item2Show)
    end
    if curDataIndex ~= self.curDataIndex then
      OnScrollToIndex(self, curDataIndex)
    end
    self.curDataIndex = curDataIndex
    self.nextDataIndex = nextDataIndex
    self.drag:SetAnchoredPositionY(tempStartPos + remainder)
  else
    change = dragDelta.x
    if change == 0 then
      return
    end
    if change < 0 then
      symbol = -1
    else
      tempStartPos = -dragPeriod
    end
    remainder = change * symbol % dragPeriod * symbol
    dataChange = math.floor(change * symbol / dragPeriod)
    curDataIndex = self.startDataIndex - dataChange * symbol
    nextDataIndex = curDataIndex - symbol
    if change < 0 then
      self.curItem = self.item1
      self.nextItem = self.item2
      item1Show = curDataIndex
      item2Show = nextDataIndex
    else
      self.curItem = self.item2
      self.nextItem = self.item1
      item1Show = nextDataIndex
      item2Show = curDataIndex
    end
    if scrollLimit < remainder * symbol then
      local tempIndex = curDataIndex
      curDataIndex = nextDataIndex
      nextDataIndex = tempIndex
      local temp = self.curItem
      self.curItem = self.nextItem
      self.nextItem = temp
    end
    if item1Show ~= self.item1Show then
      self.item1Show = item1Show
      ShowItem(self, self.item1, self.item1Show)
    end
    if item2Show ~= self.item2Show then
      self.item2Show = item2Show
      ShowItem(self, self.item2, self.item2Show)
    end
    if curDataIndex ~= self.curDataIndex then
      OnScrollToIndex(self, curDataIndex)
    end
    self.curDataIndex = curDataIndex
    self.nextDataIndex = nextDataIndex
    self.drag:SetAnchoredPositionX(tempStartPos + remainder)
  end
end

local function OnDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  newDrag(self, eventData)
  do return end
  local dragMax = self.viewSize + self.spacing
  local oldDragChange = self.dragChange * self.dragScale
  local dragDelta = eventData.delta
  if self.maxFrameDrag then
    dragDelta.x = math.max(math.min(self.maxFrameDrag, self.dragChange.x), -self.maxFrameDrag)
    dragDelta.y = math.max(math.min(self.maxFrameDrag, self.dragChange.y), -self.maxFrameDrag)
  end
  self.dragChange = self.dragChange + dragDelta
  if self.limitDrag then
    self.dragChange.x = math.max(math.min(dragMax, self.dragChange.x), -dragMax)
    self.dragChange.y = math.max(math.min(dragMax, self.dragChange.y), -dragMax)
  end
  local curDragChange = self.dragChange * self.dragScale
  local target, oldTarget
  if self.isVertical then
    local isRevert
    if oldDragChange.y < 0 and curDragChange.y >= 0 or oldDragChange.y > 0 and curDragChange.y <= 0 then
      isRevert = true
    end
    target = self.dragStartPos.y + curDragChange.y
    oldTarget = self.dragStartPos.y + oldDragChange.y
    local upLimit = 0
    local downLimit = self.viewSize + self.spacing * 2
    local changeScrollLimit = self.viewSize * self.scrollLimit
    local changeScrollLimit2 = dragMax - self.viewSize * self.scrollLimit
    if oldTarget >= upLimit and target < upLimit then
      self.curItem:SetAnchoredPosition(Vector2(0, -dragMax))
      self.nextItem:SetAnchoredPosition(Vector2.zero)
      local change = target - oldTarget
      if isRevert then
        change = change + oldDragChange.y
        oldTarget = dragMax
        if changeScrollLimit < oldDragChange.y then
          self.curDataIndex = self.curDataIndex - 1
        end
      end
      local dataChange = math.ceil(change / dragMax)
      if dataChange < 0 then
        self.curDataIndex = self.curDataIndex + dataChange
        ShowItem(self, self.curItem, self.curDataIndex)
        OnScrollToIndex(self, self.curDataIndex)
      end
      self.nextDataIndex = self.curDataIndex - 1
      ShowItem(self, self.nextItem, self.nextDataIndex)
      self.dragStartPos.y = dragMax
      self.drag:SetAnchoredPositionY(dragMax + target % -dragMax)
      self.dragChange.y = self.dragChange.y % (-dragMax / self.dragScale)
      if dataChange < 0 then
        target = self.dragChange.y * self.dragScale + self.dragStartPos.y
      end
    elseif downLimit >= oldTarget and downLimit < target then
      self.curItem:SetAnchoredPosition(Vector2.zero)
      self.nextItem:SetAnchoredPosition(Vector2(0, -dragMax))
      local change = target - oldTarget
      if isRevert then
        change = change + oldDragChange.y
        oldTarget = 0
        target = oldTarget + change
        if changeScrollLimit2 > dragMax + oldDragChange.y then
          self.curDataIndex = self.curDataIndex + 1
        end
      end
      local dataChange = math.floor(change / dragMax)
      if 0 < dataChange then
        self.curDataIndex = self.curDataIndex - dataChange
        ShowItem(self, self.curItem, self.curDataIndex)
        OnScrollToIndex(self, self.curDataIndex)
      end
      self.nextDataIndex = self.curDataIndex + 1
      ShowItem(self, self.nextItem, self.nextDataIndex)
      self.dragStartPos.y = 0
      self.drag:SetAnchoredPositionY((target - downLimit) % dragMax + self.spacing)
      self.dragChange.y = self.dragChange.y % (dragMax / self.dragScale)
      if 0 < dataChange then
        target = self.dragChange.y * self.dragScale + self.dragStartPos.y
        oldTarget = oldTarget % dragMax
      end
    else
      self.drag:SetAnchoredPositionY(target)
    end
    if self.dragChange.y > 0 and changeScrollLimit > oldTarget and changeScrollLimit <= target or self.dragChange.y > 0 and changeScrollLimit < oldTarget and changeScrollLimit >= target or self.dragChange.y < 0 and changeScrollLimit2 < oldTarget and changeScrollLimit2 >= target or self.dragChange.y < 0 and changeScrollLimit2 > oldTarget and changeScrollLimit2 <= target then
      local tempIndex = self.curDataIndex
      self.curDataIndex = self.nextDataIndex
      self.nextDataIndex = tempIndex
      local temp = self.curItem
      self.curItem = self.nextItem
      self.nextItem = temp
      OnScrollToIndex(self, self.curDataIndex)
    end
  else
    local isRevert
    if oldDragChange.x < 0 and curDragChange.x >= 0 or oldDragChange.x > 0 and curDragChange.x <= 0 then
      isRevert = true
    end
    target = self.dragStartPos.x + curDragChange.x
    oldTarget = self.dragStartPos.x + oldDragChange.x
    local rightLimit = 0
    local leftLimit = -self.viewSize - self.spacing * 2
    local changeScrollLimit = self.viewSize * -self.scrollLimit
    local changeScrollLimit2 = -dragMax + self.viewSize * self.scrollLimit
    if oldTarget <= rightLimit and target > rightLimit then
      self.curItem:SetAnchoredPosition(Vector2(dragMax, 0))
      self.nextItem:SetAnchoredPosition(Vector2.zero)
      local change = target - oldTarget
      if isRevert then
        change = change + oldDragChange.x
        oldTarget = -dragMax
        target = oldTarget + change
        if changeScrollLimit > oldDragChange.x then
          self.curDataIndex = self.curDataIndex - 1
        end
      end
      local dataChange = math.floor(change / dragMax)
      if 0 < dataChange then
        self.curDataIndex = self.curDataIndex - dataChange
        ShowItem(self, self.curItem, self.curDataIndex)
        OnScrollToIndex(self, self.curDataIndex)
      end
      self.nextDataIndex = self.curDataIndex - 1
      ShowItem(self, self.nextItem, self.nextDataIndex)
      self.dragStartPos.x = -dragMax
      self.drag:SetAnchoredPositionX(-dragMax + target % dragMax)
      self.dragChange.x = self.dragChange.x % (dragMax / self.dragScale)
      if 0 < dataChange then
        target = self.dragChange.x * self.dragScale + self.dragStartPos.x
      end
    elseif leftLimit <= oldTarget and leftLimit > target then
      self.curItem:SetAnchoredPosition(Vector2.zero)
      self.nextItem:SetAnchoredPosition(Vector2(dragMax, 0))
      local change = target - oldTarget
      if isRevert then
        change = change + oldDragChange.x
        oldTarget = 0
        target = oldTarget + change
        if changeScrollLimit2 < -dragMax + oldDragChange.x then
          self.curDataIndex = self.curDataIndex + 1
        end
      end
      local dataChange = math.ceil(change / dragMax)
      if dataChange < 0 then
        self.curDataIndex = self.curDataIndex - dataChange
        ShowItem(self, self.curItem, self.curDataIndex)
        OnScrollToIndex(self, self.curDataIndex)
      end
      self.nextDataIndex = self.curDataIndex + 1
      ShowItem(self, self.nextItem, self.nextDataIndex)
      self.dragStartPos.x = 0
      self.drag:SetAnchoredPositionX(0 + (target - leftLimit) % -dragMax - self.spacing)
      self.dragChange.x = self.dragChange.x % (-dragMax / self.dragScale)
      if dataChange < 0 then
        target = self.dragChange.x * self.dragScale + self.dragStartPos.x
      end
    else
      self.drag:SetAnchoredPositionX(target)
    end
    if self.dragChange.x < 0 and changeScrollLimit < oldTarget and changeScrollLimit >= target or self.dragChange.x < 0 and changeScrollLimit > oldTarget and changeScrollLimit <= target or self.dragChange.x > 0 and changeScrollLimit2 > oldTarget and changeScrollLimit2 <= target or self.dragChange.x > 0 and changeScrollLimit2 < oldTarget and changeScrollLimit2 >= target then
      local tempIndex = self.curDataIndex
      self.curDataIndex = self.nextDataIndex
      self.nextDataIndex = tempIndex
      local temp = self.curItem
      self.curItem = self.nextItem
      self.nextItem = temp
      OnScrollToIndex(self, self.curDataIndex)
    end
  end
end

local function newEndDrag(self, eventData)
  self.tempScrollTime = 0
  self.isDragging = false
  self.dragStartPos = nil
  self.startPos = nil
  self.startDataIndex = nil
  MoveToCurItem(self)
end

local function OnEndDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  newEndDrag(self, eventData)
  do return end
  self.tempScrollTime = 0
  self.isDragging = false
  self.dragStartPos = nil
  self.dragChange = nil
  MoveToCurItem(self)
end

local function OnItemBeginDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  Tool.PassBeginDragEvent(self.drag.self.gameObject, eventData)
end

local function OnItemDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  Tool.PassDragEvent(self.drag.self.gameObject, eventData)
end

local function OnItemEndDrag(self, eventData)
  if not self.canDrag or self.isMoving then
    return
  end
  Tool.PassEndDragEvent(self.drag.self.gameObject, eventData)
end

local function OnItemClick(self, eventData)
  if self.isDragging or self.isMoving then
    return
  end
  local dataIndex = (self.curDataIndex - 1) % self.dataCount + 1
  if self.clickItemCb then
    self.clickItemCb(dataIndex)
  end
end

local function InitEvent(self)
  local dragTrigger = self.drag.self.gameObject:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  if dragTrigger == nil then
    dragTrigger = self.drag.self.gameObject:AddComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  end
  dragTrigger.triggers:Clear()
  local entryBeginDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryBeginDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.BeginDrag
  entryBeginDrag.callback:AddListener(function(e)
    OnBeginDrag(self, e)
  end)
  dragTrigger.triggers:Add(entryBeginDrag)
  local entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
  entryDrag.callback:AddListener(function(e)
    OnDrag(self, e)
  end)
  dragTrigger.triggers:Add(entryDrag)
  local entryEndDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryEndDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.EndDrag
  entryEndDrag.callback:AddListener(function(e)
    OnEndDrag(self, e)
  end)
  dragTrigger.triggers:Add(entryEndDrag)
  local itemTrigger = self.item1.self.gameObject:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  if itemTrigger == nil then
    itemTrigger = self.item1.self.gameObject:AddComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  end
  itemTrigger.triggers:Clear()
  entryBeginDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryBeginDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.BeginDrag
  entryBeginDrag.callback:AddListener(function(e)
    OnItemBeginDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryBeginDrag)
  entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
  entryDrag.callback:AddListener(function(e)
    OnItemDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryDrag)
  entryEndDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryEndDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.EndDrag
  entryEndDrag.callback:AddListener(function(e)
    OnItemEndDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryEndDrag)
  local entryClickUp = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryClickUp.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerClick
  entryClickUp.callback:AddListener(function(e)
    OnItemClick(self, e)
  end)
  itemTrigger.triggers:Add(entryClickUp)
  itemTrigger = self.item2.self.gameObject:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  if itemTrigger == nil then
    itemTrigger = self.item2.self.gameObject:AddComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  end
  itemTrigger.triggers:Clear()
  entryBeginDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryBeginDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.BeginDrag
  entryBeginDrag.callback:AddListener(function(e)
    OnItemBeginDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryBeginDrag)
  entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
  entryDrag.callback:AddListener(function(e)
    OnItemDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryDrag)
  entryEndDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryEndDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.EndDrag
  entryEndDrag.callback:AddListener(function(e)
    OnItemEndDrag(self, e)
  end)
  itemTrigger.triggers:Add(entryEndDrag)
  entryClickUp = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryClickUp.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerClick
  entryClickUp.callback:AddListener(function(e)
    OnItemClick(self, e)
  end)
  itemTrigger.triggers:Add(entryClickUp)
end

function Ctrl:Ctor(uiGroup, isVer, spacing)
  if uiGroup then
    self:InitRoot(uiGroup, isVer, spacing)
  end
end

function Ctrl:InitRoot(uiGroup, isVer, spacing)
  assert(uiGroup ~= nil, "\230\151\160\233\153\144\230\187\154\229\138\168\231\187\132\228\187\182\229\143\130\230\149\176\228\184\186\231\169\186!")
  assert(uiGroup.Group_Drag ~= nil and uiGroup.Group_Drag.Group_Item1 ~= nil and uiGroup.Group_Drag.Group_Item2 ~= nil, "\230\151\160\233\153\144\230\187\154\229\138\168\231\187\132\228\187\182\233\162\132\229\136\182\231\187\147\230\158\132\230\136\150\229\144\141\231\167\176\233\148\153\232\175\175!")
  self.movingSpeed = 10
  self.dragScale = 1
  self.scrollLimit = 0.5
  self.canDrag = nil
  self.root = uiGroup
  self.drag = uiGroup.Group_Drag
  self.item1 = uiGroup.Group_Drag.Group_Item1
  self.item2 = uiGroup.Group_Drag.Group_Item2
  self.isVertical = isVer
  self.spacing = spacing or 0
  InitEvent(self)
end

function Ctrl:Reset()
  local viewSize = self.root.self.Rect.sizeDelta
  SetAnchor(self.drag.self.Rect)
  SetAnchor(self.item1.self.Rect)
  SetAnchor(self.item2.self.Rect)
  self.item1:SetWidthHeight(viewSize.x, viewSize.y)
  self.item2:SetWidthHeight(viewSize.x, viewSize.y)
  self.item1:SetAnchoredPosition(Vector2.zero)
  if self.isVertical then
    self.viewSize = viewSize.y
    local maxSize = viewSize.y * 2 + self.spacing
    self.drag:SetWidthHeight(viewSize.x, maxSize)
    self.item2:SetAnchoredPosition(Vector2(0, -viewSize.y - self.spacing))
  else
    self.viewSize = viewSize.x
    local maxSize = viewSize.x * 2 + self.spacing
    self.drag:SetWidthHeight(maxSize, viewSize.y)
    self.item2:SetAnchoredPosition(Vector2(viewSize.x + self.spacing, 0))
  end
  self.drag:SetAnchoredPosition(Vector2.zero)
  self.curItem = self.item1
  self.nextItem = self.item2
  self.isDragging = false
  self.isMoving = false
  self.canDrag = false
  self.limitDrag = nil
end

function Ctrl:SetData(dataCount, showItemCb, clickItemCb, scrollToCb)
  if dataCount == nil or dataCount <= 0 then
    return
  end
  self:Reset()
  self.dataCount = dataCount
  self.canDrag = self.dataCount > 1
  self.showItemCb = showItemCb
  if self.showItemCb then
    self.showItemCb(self.curItem, 1)
    if 1 < dataCount then
      self.showItemCb(self.nextItem, 2)
    end
  end
  self.curDataIndex = 1
  self.nextDataIndex = 2
  self.item1Show = 1
  self.item2Show = 2
  self.clickItemCb = clickItemCb
  self.scrollToCb = scrollToCb
  if self.scrollToCb then
    self.scrollToCb(1, true)
  end
end

function Ctrl:OnUpdate()
  if not self.isActive then
    return
  end
  if self.isMoving and self.drag then
    local curPos = self.drag:GetAnchoredPosition()
    if self.movingSpeed > 0 then
      if self.dragTargetPosX then
        curPos.x = curPos.x + self.movingSpeed
        if curPos.x > self.dragTargetPosX then
          curPos.x = self.dragTargetPosX
          self.isMoving = nil
          self.dragTargetPosX = nil
        end
      elseif self.dragTargetPosY then
        curPos.y = curPos.y + self.movingSpeed
        if curPos.y > self.dragTargetPosY then
          curPos.y = self.dragTargetPosY
          self.isMoving = nil
          self.dragTargetPosX = nil
        end
      else
        self.isMoving = false
      end
    elseif self.dragTargetPosX then
      curPos.x = curPos.x + self.movingSpeed
      if curPos.x < self.dragTargetPosX then
        curPos.x = self.dragTargetPosX
        self.isMoving = nil
        self.dragTargetPosX = nil
      end
    elseif self.dragTargetPosY then
      curPos.y = curPos.y + self.movingSpeed
      if curPos.y < self.dragTargetPosY then
        curPos.y = self.dragTargetPosY
        self.isMoving = nil
        self.dragTargetPosY = nil
      end
    else
      self.isMoving = false
    end
    self.drag:SetAnchoredPosition(curPos)
  elseif self.autoScroll then
    if self.tempScrollTime >= self.autoScroll then
      self.tempScrollTime = self.tempScrollTime - self.autoScroll
      self:MoveIndex()
    else
      self.tempScrollTime = self.tempScrollTime + Time.fixedDeltaTime
    end
  end
end

function Ctrl:Dtor()
  self.root = nil
  self.drag = nil
  self.item1 = nil
  self.item2 = nil
  self.curItem = nil
  self.nextItem = nil
  self.isMoving = nil
  self.autoScroll = nil
end

function Ctrl:MoveIndex(backForward)
  if self.isMoving or self.isDragging or not self.canDrag then
    return
  end
  local change = 1
  if backForward then
    change = -1
    if self.isVertical then
      self.drag:SetAnchoredPosition(Vector2(0, self.viewSize + self.spacing))
    else
      self.drag:SetAnchoredPosition(Vector2(-self.viewSize - self.spacing, 0))
    end
    self.curItem = self.item1
    self.nextItem = self.item2
    self.nextDataIndex = self.curDataIndex
    self.curDataIndex = self.curDataIndex + change
    self.item1Show = self.curDataIndex
    self.item2Show = self.nextDataIndex
  else
    self.drag:SetAnchoredPosition(Vector2.zero)
    self.curItem = self.item2
    self.nextItem = self.item1
    self.nextDataIndex = self.curDataIndex
    self.curDataIndex = self.curDataIndex + change
    self.item1Show = self.nextDataIndex
    self.item2Show = self.curDataIndex
  end
  ShowItem(self, self.curItem, self.curDataIndex)
  ShowItem(self, self.nextItem, self.nextDataIndex)
  OnScrollToIndex(self, self.curDataIndex)
  MoveToCurItem(self)
end

function Ctrl:AutoScroll(autoTime)
  self.autoScroll = autoTime
  if not self.canDrag then
    self.autoScroll = nil
    return
  end
  self.tempScrollTime = 0
end

function Ctrl:SetScrollLimit(value)
  assert(value ~= nil)
  if self.dataCount == nil or self.dataCount <= 1 then
    return
  end
  self.scrollLimit = math.max(0.1, math.min(1, value))
end

function Ctrl:SetActive(value)
  self.isActive = value
  if not self.root then
    return
  end
  self.root:SetActive(value)
  self.root.self.transform.parent.gameObject:SetActive(value)
end

return Ctrl
