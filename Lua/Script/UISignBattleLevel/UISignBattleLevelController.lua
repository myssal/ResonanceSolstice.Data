local View = require("UISignBattleLevel/UISignBattleLevelView")
local DataModel = require("UISignBattleLevel/UISignBattleLevelDataModel")
local Controller = {}

function Controller:Init(id)
  DataModel:Init(id)
  View.Group_SpLevelDetails.self:SetActive(false)
  View.ScrollGrid_Map.grid.self:SetDataCount(DataModel.listCount)
  View.ScrollGrid_Map.grid.self:RefreshAllElement()
  View.ScrollGrid_Map.grid.self:MoveToTop()
  local progress = DataModel.GetCurrentIndex() / #DataModel.activityCA.signLevelList
  progress = 1 < progress and 1 or progress
  View.Txt_Progress:SetText(PlayerData:GetPreciseDecimalFloor(progress * 100, 0) .. "%")
end

function Controller:SetElement(element, elementIndex)
  local index = tonumber(elementIndex)
  element.Group_Start:SetActive(index == 1)
  element.Group_Finish:SetActive(index == DataModel.listCount)
  element.Group_Level:SetActive(1 < index and index < DataModel.listCount)
  element.Group_Level.Group_Current.Btn_Level:SetClickParam(index - 1)
  element.Group_Level.Group_Current.Img_L:SetActive(2 < index)
  element.Group_Level.Group_Finish:SetActive(DataModel.GetFinishIndex(index - 1))
  element.Group_Level.Group_Finish.Img_L:SetActive(2 < index)
  element.Group_Level.Group_Lock:SetActive(index > DataModel.GetUnlockIndex() + 2)
  element.Group_Level.Group_Lock.Img_L:SetActive(2 < index)
  element.Group_Level.Group_Lock.Img_Next:SetActive(index == DataModel.GetUnlockIndex() + 3)
  local currentState = false
  if index == DataModel.GetCurrentIndex() + 2 and DataModel.GetCurrentIndex() <= DataModel.GetUnlockIndex() then
    currentState = not DataModel.GetFinishIndex(index - 1)
  end
  element.Group_Level.Group_Current:SetActive(currentState)
  if element.Group_Level.Group_Finish.IsActive then
    element.Group_Level.Img_Index:SetSprite(DataModel.imgPathFinish .. index - 1)
  else
    element.Group_Level.Img_Index:SetSprite(DataModel.imgPath .. index - 1)
  end
end

function Controller:OpenRightPage(index)
  if index == 0 or index == DataModel.listCount - 1 then
    return
  end
  local data = DataModel.signBattleLevelList[index]
  if data == nil then
    return
  end
  local lastIndex = DataModel.openIndex
  DataModel.openIndex = index
  if index == lastIndex then
    return
  end
  View.ScrollGrid_Map.grid.self:RefreshAllElement()
  View.Group_SpLevelDetails.self:SetActive(true)
  local levelData = PlayerData:GetFactoryData(data.id)
  DataModel.chooseLevelData = levelData
  View.Group_SpLevelDetails.Txt_Name:SetText(levelData.levelName)
  View.Group_SpLevelDetails.Txt_Grade:SetText(string.format(GetText(80609989), levelData.recomGrade))
  View.Group_SpLevelDetails.Txt_Des:SetText(levelData.description)
  DataModel:SetDropList(levelData)
  if table.count(DataModel.dropList) ~= 0 then
    View.Group_SpLevelDetails.ScrollGrid_Reward.self:SetActive(true)
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.dropList))
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:RefreshAllElement()
    View.Group_SpLevelDetails.ScrollGrid_Reward.grid.self:MoveToTop()
  else
    View.Group_SpLevelDetails.ScrollGrid_Reward.self:SetActive(false)
  end
end

function Controller:TryBattle()
  local info = DataModel.chooseLevelData
  local levelId = info.id
  local levelCA = info
  local levelDifficulty = PlayerData:GetLevelDifficulty(levelId)
  
  local function doSquad()
    if CommonTips.OpenBuyEnergyTips(levelId, nil, nil, nil, levelDifficulty) then
      return
    end
    local status = {
      Current = "Chapter",
      squadIndex = PlayerData.BattleInfo.squadIndex,
      hasOpenThreeView = false,
      difficulty = levelDifficulty,
      isAutoBattle = false,
      csActivityId = DataModel.activityCA.id,
      csIndex = DataModel.GetCurrentIndex()
    }
    local t = {}
    t.activityId = DataModel.activityCA.id
    t.index = DataModel.openIndex
    t.isBattleReturn = true
    status.extraUIParamData = t
    PlayerData.BattleInfo.battleStageId = levelId
    PlayerData.BattleCallBackPage = "UI/Activity/ActivitySignBattle/SignBattleLevel"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade + levelCA.extraLevelOffset * (levelDifficulty - 1) - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "SignBattleLevelTip"
    checkTipParam.checkTipType = 1
    checkTipParam.showDanger = true
    checkTipParam.showSafe = true
    CommonTips.OnPrompt(80601227, nil, nil, doSquad, nil, nil, nil, nil, checkTipParam)
  else
    doSquad()
  end
end

function Controller:CloseChoose()
  View.Group_SpLevelDetails.self:SetActive(false)
  View.ScrollGrid_Map.grid.self:RefreshAllElement()
  DataModel.openIndex = nil
end

return Controller
