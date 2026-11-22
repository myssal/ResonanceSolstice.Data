local View = require("UIDescent/UIDescentView")
local DataModel = require("UIDescent/UIDescentDataModel")
local Controller = {}

function Controller:Init()
  local cubeCA = PlayerData:GetFactoryData(DataModel.cubeId)
  DataModel.cubeCA = cubeCA
  local curDescentLv = PlayerData.TempCache.CubeRogueData.des_lv or 0
  local dFvo = DataModel.cubeCA.descentMaxLevelList[math.max(1, curDescentLv + 1)]
  View.Group_Using.Group_Descent.Txt_Max:SetText(dFvo.maxLv)
  DataModel.MaxDescent = dFvo.maxLv
  DataModel.curBuffIndex = nil
  local descentBuffList = {}
  for i = 1, #DataModel.cubeCA.descentBuffList do
    descentBuffList[i] = tostring(DataModel.cubeCA.descentBuffList[i].id)
  end
  table.sort(descentBuffList, function(e1, e2)
    return tonumber(e1) > tonumber(e2)
  end)
  DataModel.descentBuffList = descentBuffList
  DataModel.curUsingBuffIndex = nil
  local usingBuffList = {
    "",
    "",
    "",
    "",
    "",
    ""
  }
  DataModel.usingBuffList = usingBuffList
  View.Group_Using.StaticGrid_BuffList.grid.self:SetDataCount(#usingBuffList)
  if next(PlayerData.TempCache.CubeRogueData.debuff) then
    for i = #DataModel.descentBuffList, 1, -1 do
      for k, v in pairs(PlayerData.TempCache.CubeRogueData.debuff) do
        local orderCA = PlayerData:GetFactoryData(k)
        if tostring(orderCA.descent) == DataModel.descentBuffList[i] then
          self:AddUsingBuff(i)
        end
      end
    end
  else
    local str = PlayerData:GetPlayerPrefs("string", "CubeDebuff")
    local curBuffList = string.split(str, ",")
    for i = #DataModel.descentBuffList, 1, -1 do
      for j = 1, #curBuffList do
        if tostring(curBuffList[j]) == DataModel.descentBuffList[i] then
          self:AddUsingBuff(i)
        end
      end
    end
  end
  View.Group_BuffList.ScrollGrid_List.grid.self:SetDataCount(#DataModel.descentBuffList)
  View.Group_BuffList.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_BuffList.ScrollGrid_List.grid.self:MoveToTop()
  View.Group_Using.StaticGrid_BuffList.grid.self:RefreshAllElement()
  local descent = Controller:CalculateTotalDescent()
  View.Group_Using.Group_Descent.Txt_Now:SetText(descent)
  View.Group_Using.Btn_Clear.Img_Off:SetActive(descent <= 0)
  PlayerData.TempCache.CubeDescent = descent
  Controller:RefreshSelectedBuffInfo()
end

function Controller:OnSelectBuff(idx)
  if DataModel.curBuffIndex == idx then
    return
  end
  DataModel.curUsingBuffIndex = nil
  DataModel.curBuffIndex = idx
  View.Group_BuffList.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Using.StaticGrid_BuffList.grid.self:RefreshAllElement()
  Controller:RefreshSelectedBuffInfo()
end

function Controller:OnSelectUsingBuff(idx)
  if DataModel.curUsingBuffIndex == idx then
    return
  end
  DataModel.curBuffIndex = nil
  DataModel.curUsingBuffIndex = idx
  View.Group_BuffList.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Using.StaticGrid_BuffList.grid.self:RefreshAllElement()
  Controller:RefreshSelectedBuffInfo()
end

function Controller:SetBuffListGrid(element, elementIndex)
  local buffId = DataModel.descentBuffList[elementIndex]
  local isOn = DataModel.curBuffIndex == elementIndex
  element.Group_On:SetActive(isOn)
  element.Group_Off:SetActive(not isOn)
  
  local function setBuff(group)
    local buffCA = PlayerData:GetFactoryData(buffId)
    group.Txt_Num:SetText(buffCA.descent)
    group.Img_Icon:SetSprite(buffCA.iconPath)
    group.Group_Name.Txt_Name:SetText(buffCA.name)
    group.Group_Name.Img_Time:SetActive(buffCA.endTime ~= "")
  end
  
  if isOn then
    setBuff(element.Group_On)
  else
    setBuff(element.Group_Off)
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:SetUsingBuffListGrid(element, elementIndex)
  local buffData = DataModel.usingBuffList[elementIndex]
  local isOn = DataModel.curUsingBuffIndex == elementIndex
  element.Img_Selected:SetActive(isOn)
  local isEmpty = buffData == ""
  element.Group_Empty:SetActive(isEmpty)
  element.Group_Active:SetActive(not isEmpty)
  if not isEmpty then
    local group = element.Group_Active
    local buffCA = PlayerData:GetFactoryData(buffData)
    group.Txt_Num:SetText(buffCA.descent)
    group.Img_Icon:SetSprite(buffCA.iconPath)
    group.Group_Name.Txt_Name:SetText(buffCA.name)
    group.Group_Name.Img_Time:SetActive(buffCA.endTime ~= "")
    group.Group_Normal:SetActive(buffCA.endTime == "")
    group.Group_Time:SetActive(buffCA.endTime ~= "")
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:RefreshSelectedBuffInfo()
  local buffId
  local isUsing = false
  if DataModel.curBuffIndex ~= nil then
    buffId = DataModel.descentBuffList[DataModel.curBuffIndex]
  elseif DataModel.curUsingBuffIndex ~= nil then
    buffId = DataModel.usingBuffList[DataModel.curUsingBuffIndex]
    isUsing = true
  end
  if buffId == nil or buffId == "" then
    View.Group_Info:SetActive(false)
    return
  end
  View.Group_Info:SetActive(true)
  local buffCA = PlayerData:GetFactoryData(buffId)
  View.Group_Info.Btn_Use.Group_Use:SetActive(not isUsing)
  View.Group_Info.Btn_Use.Group_Clear:SetActive(isUsing)
  View.Group_Info.Img_Num.Txt_Num:SetText(buffCA.descent)
  View.Group_Info.Img_Icon:SetSprite(buffCA.tipsPath)
  View.Group_Info.Txt_Name:SetText(buffCA.name)
  View.Group_Info.Txt_Des:SetText(buffCA.des)
  local isTime = buffCA.endTime ~= ""
  View.Group_Info.Img_Time:SetActive(isTime)
  View.Group_Info.Group_Time:SetActive(isTime)
  if isTime then
    local lastTime = TimeUtil:LastTime(buffCA.endTime)
    local timeTable = TimeUtil:SecondToTable(lastTime)
    View.Group_Info.Group_Time.Txt_Time:SetText(string.format(GetText(80601059), timeTable.day, timeTable.hour))
  end
end

function Controller:OnclickBtnBuff()
  if DataModel.curBuffIndex ~= nil then
    Controller:AddUsingBuff(DataModel.curBuffIndex)
  elseif DataModel.curUsingBuffIndex ~= nil then
    Controller:RemoveUsingBuff(DataModel.curUsingBuffIndex)
  end
  local descent = Controller:CalculateTotalDescent()
  View.Group_Using.Group_Descent.Txt_Now:SetText(descent)
  View.Group_Using.Btn_Clear.Img_Off:SetActive(descent <= 0)
  View.Group_BuffList.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Using.StaticGrid_BuffList.grid.self:RefreshAllElement()
  Controller:RefreshSelectedBuffInfo()
end

function Controller:AddUsingBuff(buffIndex)
  local buffId = DataModel.descentBuffList[buffIndex]
  if buffId ~= nil and buffId ~= "" then
    local curDescent = Controller:CalculateTotalDescent()
    local buffCA = PlayerData:GetFactoryData(buffId)
    if buffCA then
      curDescent = curDescent + buffCA.descent
    end
    if curDescent > DataModel.MaxDescent then
      CommonTips.OpenTips(GetText(80610713))
      return
    end
    table.remove(DataModel.descentBuffList, buffIndex)
    for i = 1, #DataModel.usingBuffList do
      if DataModel.usingBuffList[i] == "" then
        DataModel.usingBuffList[i] = tostring(buffId)
        break
      end
    end
    View.Group_BuffList.ScrollGrid_List.grid.self:SetDataCount(#DataModel.descentBuffList)
  end
end

function Controller:RemoveUsingBuff(usingOrder)
  local buffId = DataModel.usingBuffList[usingOrder]
  DataModel.usingBuffList[usingOrder] = ""
  if buffId ~= nil and buffId ~= "" then
    table.insert(DataModel.descentBuffList, buffId)
    table.sort(DataModel.descentBuffList, function(e1, e2)
      return tonumber(e1) > tonumber(e2)
    end)
    View.Group_BuffList.ScrollGrid_List.grid.self:SetDataCount(#DataModel.descentBuffList)
  end
end

function Controller:ClearUsingBuff()
  local curBuffId
  if DataModel.curBuffIndex ~= nil then
    curBuffId = DataModel.descentBuffList[DataModel.curBuffIndex]
  end
  for i = 1, #DataModel.usingBuffList do
    local buffId = DataModel.usingBuffList[i]
    DataModel.usingBuffList[i] = ""
    if buffId ~= nil and buffId ~= "" then
      table.insert(DataModel.descentBuffList, buffId)
    end
  end
  table.sort(DataModel.descentBuffList, function(e1, e2)
    return tonumber(e1) > tonumber(e2)
  end)
  if curBuffId ~= nil then
    for i = 1, #DataModel.descentBuffList do
      if DataModel.descentBuffList[i] == curBuffId then
        DataModel.curBuffIndex = i
        break
      end
    end
  end
  View.Group_BuffList.ScrollGrid_List.grid.self:SetDataCount(#DataModel.descentBuffList)
  View.Group_BuffList.ScrollGrid_List.grid.self:RefreshAllElement()
  View.Group_Using.StaticGrid_BuffList.grid.self:RefreshAllElement()
  Controller:RefreshSelectedBuffInfo()
  local descent = Controller:CalculateTotalDescent()
  View.Group_Using.Group_Descent.Txt_Now:SetText(descent)
  View.Group_Using.Btn_Clear.Img_Off:SetActive(descent <= 0)
end

function Controller:CalculateTotalDescent()
  local rt = 0
  for i = 1, #DataModel.usingBuffList do
    local buffId = DataModel.usingBuffList[i]
    local buffCA = PlayerData:GetFactoryData(buffId)
    if buffCA then
      rt = rt + buffCA.descent
    end
  end
  return rt
end

function Controller:SaveUsingBuff(cb)
  local str = ""
  local debuff = {}
  for i = 1, #DataModel.usingBuffList do
    local buffId = DataModel.usingBuffList[i]
    if buffId ~= nil and buffId ~= "" then
      if str ~= "" then
        str = str .. ","
      end
      str = str .. buffId
      local buffCA = PlayerData:GetFactoryData(buffId)
      for j = 1, #buffCA.buffList do
        debuff[buffCA.buffList[j].id] = {effect = 0}
      end
    end
  end
  Net:SendProto("cube.debuff", function(json)
    PlayerData.TempCache.CubeRogueData.debuff = debuff
    if cb then
      cb()
    end
  end, str)
  PlayerData:SetPlayerPrefs("string", "CubeDebuff", str)
end

return Controller
