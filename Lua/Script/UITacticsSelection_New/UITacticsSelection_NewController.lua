local View = require("UITacticsSelection_New/UITacticsSelection_NewView")
local DataModel = require("UITacticsSelection_New/UITacticsSelection_NewDataModel")
local Controller = {}

function Controller:Init()
  View.self:PlayAnimOnce("TacticsSelection_in")
  if DataModel.cubeId == nil then
    DataModel.cubeId = 89400002
  end
  DataModel.cubeData = PlayerData.TempCache.CubeRogueData
  local cubeCA = PlayerData:GetFactoryData(DataModel.cubeId)
  DataModel.cubeCA = cubeCA
  local teamCount = #cubeCA.rogueTeamList
  DataModel.curIndex = nil
  self:RefreshCurInfo()
  View.Group_Selection.StaticGrid_Tactics.grid.self:SetDataCount(teamCount)
  View.Group_Selection.StaticGrid_Tactics.grid.self:RefreshAllElement()
  View.Group_Selection.Img_Title:SetSprite(GetResPath(88300185))
end

function Controller:OnSetTeamGrid(element, elementIndex)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[elementIndex].id)
  element.Txt_Name:SetText(teamCA.name)
  element.Img_Icon:SetSprite(teamCA.iconPath)
  element.Img_Icon:SetAlpha(1)
  local isTimeStart = TimeUtil:IsActive(teamCA.startTime, "")
  element.Btn_Click:SetActive(isTimeStart)
  element.Img_Time:SetActive(false)
  local isSelected = DataModel.curIndex == elementIndex
  element.Group_BG.Group_Lock:SetActive(not isTimeStart)
  element.Group_BG.Group_Off:SetActive(isTimeStart and not isSelected)
  element.Group_BG.Group_On:SetActive(isTimeStart and isSelected)
  element.Txt_Name:SetActive(isTimeStart)
  element.Group_BG.Group_Lock.Img_2:SetActive(false)
  if not isTimeStart then
    local remainStr = ""
    local startTimeStamp = TimeUtil:TimeStamp(teamCA.startTime)
    local curTimeStamp = TimeUtil:GetServerTimeStamp()
    local remainTime = startTimeStamp - curTimeStamp
    local timeTable = TimeUtil:SecondToTable(remainTime)
    element.Img_Icon:SetAlpha(0)
    if timeTable.day < 3 then
      element.Txt_Name:SetActive(true)
      element.Group_BG.Group_Lock.Img_2:SetActive(true)
      element.Img_Time:SetActive(true)
      element.Img_Icon:SetAlpha(0.5)
      if 0 < timeTable.day then
        remainStr = string.format(GetText(80610496), timeTable.day, timeTable.hour)
      elseif 0 < timeTable.hour then
        remainStr = string.format(GetText(80610464), timeTable.hour, timeTable.minute)
      else
        remainStr = string.format(GetText(80610497), timeTable.minute)
      end
    end
    element.Img_Time.Txt_Tips:SetText(remainStr)
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:OnChooseTactics(str)
  local idx = tonumber(str)
  if DataModel.curIndex == idx then
    return
  end
  if DataModel.curIndex == nil then
    View.Group_Selection.Img_MainCard:SetEnableAnimator(true)
    View.self:SelectPlayAnim(View.Group_Selection.Img_MainCard.self, "Img_Card_1", function()
      DataModel.curIndex = idx
      View.Group_Selection.StaticGrid_Tactics.grid.self:RefreshAllElement()
      local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[idx].id)
      View.Group_Selection.Img_MainCard.Img_Card:SetSprite(teamCA.cardIconPath)
      Controller:RefreshCurInfo()
      View.self:PlayAnimOnce("TacticsSelection_show")
    end)
  else
    View.Group_Selection.Img_MainCard:SetEnableAnimator(true)
    View.self:SelectPlayAnim(View.Group_Selection.Img_MainCard.self, "Img_Card_2", function()
      DataModel.curIndex = idx
      View.Group_Selection.StaticGrid_Tactics.grid.self:RefreshAllElement()
      Controller:RefreshCurInfo()
    end)
  end
end

function Controller:RefreshCurInfo()
  local idx = DataModel.curIndex
  if idx == nil then
    View.Group_Selection.Txt_Name:SetActive(false)
    View.Group_Info:SetActive(false)
    return
  end
  View.Group_Selection.Txt_Name:SetActive(true)
  View.Group_Info:SetActive(true)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[idx].id)
  View.Group_Selection.Txt_Name:SetText(teamCA.name)
  View.Group_Selection.Img_MainCard.Img_Card:SetSprite(teamCA.cardIconPath)
  View.Group_Info.Group_Buff.ScrollView_Des.Viewport.Txt_Des:SetText(teamCA.des)
  View.Group_Info.Group_ExtraBuff.Group_Buff.Img_BG.ScrollGrid_ExtraBuff.grid.self:SetDataCount(#teamCA.extraBuffList)
  View.Group_Info.Group_ExtraBuff.Group_Buff.Img_BG.ScrollGrid_ExtraBuff.grid.self:RefreshAllElement()
  local lockIdx = 0
  for i = 1, #teamCA.extraBuffList do
    if not Controller:IsExBuffUnlock(teamCA.extraBuffList[i]) then
      lockIdx = i
      break
    end
  end
  View.Group_Info.Group_ExtraBuff.Group_Lock:SetActive(0 < lockIdx)
  if 0 < lockIdx then
    Controller:RefreshExtraBuffPreposition(lockIdx)
  end
end

function Controller:RefreshExtraBuffPreposition(lockIdx)
  local idx = DataModel.curIndex
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[idx].id)
  local prepositionId = teamCA.extraBuffList[lockIdx].prepositionId
  local prepositionCA = PlayerData:GetFactoryData(prepositionId)
  View.Group_Info.Group_ExtraBuff.Group_Lock.Img_Lock.Txt_Info:SetText(string.format(GetText(80610498), prepositionCA.name, teamCA.extraBuffList[lockIdx].num))
end

function Controller:OnSetInitSkillGrid(element, elementIndex)
  element.Txt_Buff:SetText(DataModel.curDesList[elementIndex])
end

function Controller:OnSetExtraSkillGrid(element, elementIndex)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[DataModel.curIndex].id)
  local buffData = teamCA.extraBuffList[elementIndex]
  local ca = PlayerData:GetFactoryData(buffData.id)
  element.Img_Icon:SetSprite(ca.iconPath)
  element.Img_Icon:SetAlpha(1)
  element.Img_Unlock.Txt_Num:SetText(buffData.num)
  local isUnLock = Controller:IsExBuffUnlock(buffData)
  element.Img_Lock:SetActive(not isUnLock)
  element.Btn_Click:SetClickParam(ca.id)
  if not isUnLock then
    element.Img_Icon:SetAlpha(0.5)
  end
end

function Controller:IsExBuffUnlock(buffData)
  local prepositionId = buffData.prepositionId
  local isPrepositionUnlock = false
  if prepositionId == nil or prepositionId <= 0 then
    isPrepositionUnlock = true
  else
    for k, v in pairs(DataModel.cubeData.outside_buffs) do
      if tostring(k) == tostring(prepositionId) and v.is_act == 1 then
        isPrepositionUnlock = true
      end
    end
  end
  return isPrepositionUnlock
end

function Controller:OnBtnReturn()
  UIManager:GoBack()
  if DataModel.hasPrePanel ~= true then
    UIManager:Open("UI/CubeRogue/DepthSelection/DepthSelection", Json.encode({
      id = PlayerData.TempCache.RogueCache.cubeId,
      initIndex = PlayerData.TempCache.CubeRogueData.difficulty + 1
    }))
  end
end

function Controller:OpenSquads()
  local teamId = DataModel.cubeCA.rogueTeamList[DataModel.curIndex].id
  PlayerData.TempCache.RogueCache.teamId = teamId
  Net:SendProto("cube.team", function(json)
    PlayerData.TempCache.CubeRogueData.team = tostring(teamId)
    UIManager:Open("UI/CubeRogue/Team_Cube/Team_CubeNew", Json.encode({mode = "InitCube", hasPrePanel = true}))
  end, teamId)
end

return Controller
