local DataModel = {}

function DataModel.Init(initParams)
  DataModel.activityId = Json.decode(initParams).id
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local index = ActivityMainDataModel.GetActivityTipsIndex(DataModel.activityId)
  DataModel.index = index
end

function DataModel.IsFinish()
  local activeCA = PlayerData:GetFactoryData(86000005)
  if activeCA.correspondingCity[1] then
    local stationCA = PlayerData:GetFactoryData(activeCA.correspondingCity[1].id)
    local turntableBattleCA = PlayerData:GetFactoryData(stationCA.turntableId)
    local firstParagraphid = PlayerData.plot_paragraph[tostring(turntableBattleCA.FirstParagraphid)]
    if PlayerData:GetUserInfo().lv >= turntableBattleCA.openLv and PlayerData:GetActivityAct(86000005) == false and PlayerData:GetPlayerPrefs("string", "IsBattleBossFirstTip") == "" and firstParagraphid == nil then
      return true
    end
  end
  return false
end

return DataModel
