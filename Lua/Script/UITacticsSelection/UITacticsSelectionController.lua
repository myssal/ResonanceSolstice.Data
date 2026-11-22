local View = require("UITacticsSelection/UITacticsSelectionView")
local DataModel = require("UITacticsSelection/UITacticsSelectionDataModel")
local Controller = {}

function Controller:Init()
  if DataModel.cubeId == nil then
    DataModel.cubeId = 89400002
  end
  local cubeCA = PlayerData:GetFactoryData(DataModel.cubeId)
  DataModel.cubeCA = cubeCA
  DataModel.isShowTip = false
  View.Group_Info.self:SetActive(false)
  local teamCount = #cubeCA.rogueTeamList
  View.ScrollGrid_List.self:SetActive(5 < teamCount)
  View.StaticGrid_List.self:SetActive(teamCount <= 5)
  if 5 < teamCount then
    View.ScrollGrid_List.grid.self:SetDataCount(teamCount)
    View.ScrollGrid_List.grid.self:RefreshAllElement()
  else
    View.StaticGrid_List.grid.self:SetDataCount(teamCount)
    View.StaticGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller:OnSetTeamGrid(element, elementIndex)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[elementIndex].id)
  element.Txt_Name:SetText(teamCA.name)
  element.Img_Icon:SetSprite(teamCA.iconPath)
  element.Txt_Des:SetText(teamCA.des)
  local isTimeStart = TimeUtil:IsActive(teamCA.startTime, "")
  element.Btn_Choose:SetActive(isTimeStart)
  element.Group_Time:SetActive(not isTimeStart)
  if not isTimeStart then
    local remainStr = ""
    local startTimeStamp = TimeUtil:TimeStamp(teamCA.startTime)
    local curTimeStamp = TimeUtil:GetServerTimeStamp()
    local remainTime = startTimeStamp - curTimeStamp
    local timeTable = TimeUtil:SecondToTable(remainTime)
    if timeTable.day < 3 then
      if timeTable.day > 0 then
        remainStr = string.format(GetText(80610215), timeTable.day, timeTable.hour)
      else
        remainStr = string.format(GetText(80610216), timeTable.hour, timeTable.minute)
      end
    end
    element.Group_Time.Txt_Time:SetText(remainStr)
  end
  element.Btn_Choose:SetClickParam(elementIndex)
end

function Controller:OnClickBtnChoose(str)
  local idx = tonumber(str)
  View.Group_Info.self:SetActive(true)
  DataModel.isShowTip = true
  DataModel.curIndex = idx
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[idx].id)
  View.Group_Info.Group_Tactics.Txt_Name:SetText(teamCA.name)
  View.Group_Info.Group_Tactics.Img_Icon:SetSprite(teamCA.iconPath)
  View.Group_Info.Group_Tactics.Txt_Des:SetText(teamCA.des)
  if #teamCA.initialEffectList > 0 then
    Controller:OnSetInitSkillGrid(View.Group_Info.Group_Detail.Txt_Buff, 1)
  else
    View.Group_Info.Group_Detail.Txt_Buff:SetText("")
  end
  View.Group_Info.Group_Detail.Group_Combo.ScrollGrid_Buff.grid.self:SetDataCount(teamCA.extraBuffList)
  View.Group_Info.Group_Detail.Group_Combo.ScrollGrid_Buff.grid.self:RefreshAllElement()
end

function Controller:OnSetInitSkillGrid(element, elementIndex)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[DataModel.curIndex].id)
  local ca = PlayerData:GetFactoryData(teamCA.initialEffectList[elementIndex].id)
  element:SetText(ca.description)
end

function Controller:OnSetExtraSkillGrid(element, elementIndex)
  local teamCA = PlayerData:GetFactoryData(DataModel.cubeCA.rogueTeamList[DataModel.curIndex].id)
  local ca = PlayerData:GetFactoryData(teamCA.extraBuffList[elementIndex].id)
  element:SetSprite(ca.iconPath)
end

function Controller:OnBtnReturn()
  if DataModel.isShowTip then
    View.Group_Info.self:SetActive(false)
    DataModel.curIndex = nil
    DataModel.isShowTip = false
  else
    UIManager:GoBack()
    UIManager:Open("UI/CubeRogue/DepthSelection/DepthSelection", Json.encode({
      id = PlayerData.TempCache.RogueCache.cubeId
    }))
  end
end

function Controller:OnCloseTip()
  View.Group_Info.self:SetActive(false)
end

function Controller:OpenSquads()
  local teamId = DataModel.cubeCA.rogueTeamList[DataModel.curIndex].id
  PlayerData.TempCache.RogueCache.teamId = teamId
  Net:SendProto("cube.team", function(json)
    PlayerData.TempCache.CubeRogueData.team = tostring(teamId)
    UIManager:Open("UI/CubeRogue/Team_Cube/Team_CubeNew", Json.encode({mode = "InitCube"}))
  end, teamId)
end

return Controller
