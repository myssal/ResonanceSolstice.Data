local View = require("UISignBattleLevelLivia/UISignBattleLevelLiviaView")
local DataModel = require("UISignBattleLevelLivia/UISignBattleLevelLiviaDataModel")
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
  local index = elementIndex
  element.Group_Level.Group_Current.Btn_Level:SetClickParam(index)
  local currentState = false
  if index == DataModel.GetCurrentIndex() + 1 and DataModel.GetCurrentIndex() <= DataModel.GetUnlockIndex() then
    currentState = not DataModel.GetFinishIndex(index)
  end
  element.Group_Level.Group_Current:SetActive(currentState)
  element.Group_Level.Group_Finish:SetActive(DataModel.GetFinishIndex(index))
  element.Group_Level.Group_Lock:SetActive(index > DataModel.GetUnlockIndex() + 1)
  element.Group_Level.Group_UnLock:SetActive(index <= DataModel.GetUnlockIndex() + 1 and not DataModel.GetFinishIndex(index))
  element.Group_Level.Group_Lock.Txt_T:SetActive(index == DataModel.GetUnlockIndex() + 2)
  element.Group_Level.Group_Finish.Img_Index:SetSprite(DataModel.imgPath .. index)
  element.Group_Level.Group_Current.Img_Index:SetSprite(DataModel.imgPath .. index)
  element.Group_Level.Group_Lock.Img_Index:SetSprite(DataModel.imgPath .. index)
  element.Group_Level.Group_UnLock.Img_Index:SetSprite(DataModel.imgPath .. index)
end

function Controller:OpenRightPage(index)
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
    PlayerData.BattleCallBackPage = "UI/Activity/ActivitySignBattle/SignBattleLevelLivia"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end
  
  if not levelCA.isEnemyLvEquilsPlayer and levelCA.recomGrade + levelCA.extraLevelOffset * (levelDifficulty - 1) - PlayerData:GetPlayerLevel() >= 5 then
    local checkTipParam = {}
    checkTipParam.isCheckTip = true
    checkTipParam.checkTipKey = "SignBattleLevelLiviaTip"
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
