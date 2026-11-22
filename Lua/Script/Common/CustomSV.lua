Class = require("UIDialog/MetatableClass")
local CustomSV = Class.New("CustomSV")

local function Ctor(self, gridList, isVertical, callBack)
  self.gridList = gridList
  self.isVertical = isVertical
  self.oldMinIndex = -1
  self.oldMaxIndex = -1
  self.oldY = -10
  self.callBack = callBack
end

local function Search(self, num)
  local left = 1
  local right = self.dataNum
  local mid = math.ceil((left + right) / 2)
  while left ~= mid and right > mid do
    if self.isVertical then
      if num <= self.data[mid].pos and num > self.data[mid + 1].pos then
        break
      end
    elseif num >= self.data[mid].pos and num < self.data[mid + 1].pos then
      break
    end
    if num > self.data[mid].pos then
      if self.isVertical then
        right = mid - 1
      else
        left = mid + 1
      end
    elseif self.isVertical then
      left = mid + 1
    else
      right = mid - 1
    end
    mid = math.ceil((left + right) / 2)
  end
  mid = mid <= 1 and 1 or mid - 1
  return self.data[mid].id
end

local function SetItemShowAndHide(self, currentxory)
  if math.abs(self.oldY - currentxory) < 1 or self.data == nil or self.dataNum == 0 then
    return
  end
  self.oldY = currentxory
  local minIndex = Search(self, -currentxory)
  local maxIndex = minIndex + self.rectNum - 1 > self.dataNum and self.dataNum or minIndex + self.rectNum - 1
  if self.oldMinIndex ~= minIndex or self.oldMaxIndex ~= maxIndex then
    for i = self.oldMinIndex, minIndex - 1 do
      local index = i % self.rectNum
      index = index == 0 and self.rectNum or index
      if self.gridList[index] then
        self.gridList[index]:SetActive(false)
      end
    end
    for i = maxIndex + 1, self.oldMaxIndex do
      local index = i % self.rectNum
      index = index == 0 and self.rectNum or index
      if self.gridList[index] then
        self.gridList[index]:SetActive(false)
      end
    end
    self.oldMinIndex = minIndex
    self.oldMaxIndex = maxIndex
    for i = minIndex, maxIndex do
      local index = i % self.rectNum
      index = index == 0 and self.rectNum or index
      if self.gridList[index] and self.gridList[index].IsActive == false then
        self.gridList[index]:SetActive(true)
        if self.isVertical then
          self.gridList[index].self:SetLocalPositionY(self.data[i].pos)
        else
          self.gridList[index].self:SetLocalPositionX(self.data[i].pos)
        end
        self.callBack(self.gridList[index], i)
      end
    end
  end
end

local function RefreshAllElement(self)
  local minIndex = 1
  local maxIndex = minIndex + self.rectNum - 1
  self.oldMinIndex = minIndex
  self.oldMaxIndex = maxIndex
  for i = minIndex, maxIndex do
    if i <= self.dataNum then
      self.gridList[i]:SetActive(true)
      if self.isVertical then
        self.gridList[i].self:SetLocalPositionY(self.data[i].pos)
      else
        self.gridList[i].self:SetLocalPositionX(self.data[i].pos)
      end
      self.callBack(self.gridList[i], i)
    else
      self.gridList[i]:SetActive(false)
    end
  end
end

local function ElementCallBack(self)
  local minIndex = self.oldMinIndex
  local maxIndex = self.oldMaxIndex > self.dataNum and self.dataNum or self.oldMaxIndex
  for i = minIndex, maxIndex do
    local index = i % self.rectNum
    index = index == 0 and self.rectNum or index
    if self.gridList[index] then
      self.callBack(self.gridList[index], i)
    end
  end
end

local function RefreshAllElementToBottom(self, scrollRect)
  local minIndex = self.dataNum - self.rectNum + 1
  minIndex = 0 < minIndex and minIndex or 1
  local maxIndex = minIndex + self.rectNum - 1
  self.oldMinIndex = minIndex
  self.oldMaxIndex = maxIndex
  for i = minIndex, maxIndex do
    local index = i % self.rectNum
    index = index == 0 and self.rectNum or index
    if i <= self.dataNum then
      self.gridList[index]:SetActive(true)
      if self.isVertical then
        self.gridList[index].self:SetLocalPositionY(self.data[i].pos)
      else
        self.gridList[index].self:SetLocalPositionX(self.data[i].pos)
      end
      self.callBack(self.gridList[index], i)
    else
      self.gridList[index]:SetActive(false)
    end
  end
  if self.isVertical then
    scrollRect.verticalNormalizedPosition = 0
  else
    scrollRect.horizontalNormalizedPosition = 1
  end
end

local function RefreshData(self, data, rectNum)
  self.data = data
  self.dataNum = #data
  self.rectNum = rectNum
end

CustomSV.Ctor = Ctor
CustomSV.SetItemShowAndHide = SetItemShowAndHide
CustomSV.RefreshAllElement = RefreshAllElement
CustomSV.RefreshAllElementToBottom = RefreshAllElementToBottom
CustomSV.RefreshData = RefreshData
CustomSV.ElementCallBack = ElementCallBack
return CustomSV
