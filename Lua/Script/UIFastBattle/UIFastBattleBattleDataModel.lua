local MainDataModel = require("UIFastBattle/UIFastBattleDataModel")
local DataModel = {
  ChooseRewardList = {},
  StationId = 0,
  isHomeBattleMax = false,
  constAutoBattleTime = 3,
  remainAutoBattleTime = 3,
  monsterLevelAutoBattle = false,
  NpcId = 0,
  BgPath = "",
  DifficultyTextWithColorId = {
    80601782,
    80601783,
    80601784,
    80601785,
    80601786,
    80601787
  },
  DifficultyNumPath = {
    "UI/Home/HomeSafe/Difficulty/icon_num_1",
    "UI/Home/HomeSafe/Difficulty/icon_num_2",
    "UI/Home/HomeSafe/Difficulty/icon_num_3",
    "UI/Home/HomeSafe/Difficulty/icon_num_4",
    "UI/Home/HomeSafe/Difficulty/icon_num_5",
    "UI/Home/HomeSafe/Difficulty/icon_num_6"
  },
  DifficultyBtnImgPath = {
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_1",
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_2",
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_3",
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_4",
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_5",
    "UI/Home/HomeSafe/Difficulty/btn_grade_old_6"
  }
}
DataModel.difficultyBg = {
  [1] = "UI/HomeBattleCenter/easy",
  [2] = "UI/HomeBattleCenter/normal",
  [3] = "UI/HomeBattleCenter/difficult"
}

function DataModel:GetNewLevel()
  if not DataModel.ShowBattleLevelList then
    return
  end
  local count = 1
  for k, v in pairs(DataModel.ShowBattleLevelList) do
    local row = DataModel.ShowBattleLevelList[k]
    if DataModel.ShowBattleLevelList[k - 1] then
      local last_row = DataModel.ShowBattleLevelList[k - 1]
      row.isBattle = PlayerData:GetLevelPass(last_row.id)
      if row.isBattle == true then
        count = k
      end
    end
  end
  local isOpenByOut = false
  DataModel.Index_Init = count
  if MainDataModel.curBattleIndex and MainDataModel.curBattleIndex ~= 0 and count >= MainDataModel.curBattleIndex then
    isOpenByOut = true
    DataModel.Index_Init = MainDataModel.curBattleIndex
  end
  if count == table.count(DataModel.ShowBattleLevelList) then
    DataModel.isHomeBattleMax = true
  end
  if isOpenByOut == false and DataModel.isHomeBattleMax and PlayerData:GetPlayerPrefs("int", "BattleCenterIndex" .. DataModel.StationId) ~= 0 then
    DataModel.Index_Init = PlayerData:GetPlayerPrefs("int", "BattleCenterIndex" .. DataModel.StationId)
  end
  if PlayerData.TempCache.isAutoBattleCenter ~= nil then
    DataModel.isInitAuto = true
    DataModel.Index_Init = PlayerData.TempCache.curIndex
    PlayerData.TempCache.isAutoBattleCenter = nil
    PlayerData.TempCache.curIndex = nil
  else
    DataModel.isInitAuto = false
  end
end

return DataModel
