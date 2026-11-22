local View = require("UIBattlePause/UIBattlePauseView")
local DataModel = require("UIBattlePause/UIBattlePauseDataModel")
local ViewFunction = {
  BattlePause_Btn_BG_Click = function(btn, str)
    DataModel.QuitCancel()
  end,
  BattlePause_Group__Btn_EnemySkill_Click = function(btn, str)
    local BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
    BattleControlManager:Pause(true)
    UIManager:GoBack(false)
    local LevelManager = CBus:GetManager(CS.ManagerName.LevelManager)
    UIManager:Open("UI/Book/Enemy_Illustration/Enemy_SkillDetail", Json.encode({
      levelId = LevelManager.currentLevel.ca.id,
      isInBattle = true
    }))
  end,
  BattlePause_Group__Btn_Exit_Click = function(btn, str)
    CommonTips.OnPrompt("80600065", "80600068", "80600067", DataModel.QuitConfirm, DataModel.QuitCancel, false, false, false)
  end,
  BattlePause_Group__Btn_Config_Click = function(btn, str)
    UIManager:GoBack(false)
    if UIAutoBattle.IsAutoBattleAvailable() then
      local autoBattle = require("UIAutoBattle/UIAutoBattleDataModel")
      UIManager:Open("UI/Battle/AutoBattle/New/AutoBattle", Json.encode({
        teamKey = autoBattle.teamKey,
        roleList = autoBattle.roleList,
        header = tonumber(autoBattle.header),
        isInBattle = true
      }))
    else
      CommonTips.OnPrompt("80602391", "80600068", "80600067", DataModel.QuitCancel, DataModel.QuitCancel, false, false, false)
    end
  end,
  BattlePause_Group__Btn_Resume_Click = function(btn, str)
    DataModel.QuitCancel()
  end,
  BattlePause_Group__Btn_BossSkill_Click = function(btn, str)
    local BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
    BattleControlManager:Pause(true)
    UIManager:GoBack(false)
    UIManager:Open("UI/Chapter/Battle_Boss/TowerBoss")
  end,
  BattlePause_Group__Btn_CubeRestart_Click = function(btn, str)
    local function noCallBack()
      CommonTips.OpenArbitrarilyUI(PlayerData.BattleCallBackPage, PlayerData.Last_Chapter_Parms)
    end
    
    local StartBattle = require("UISquads/View_StartBattle")
    StartBattle:StartBattle(PlayerData.BattleInfo.battleStageId, PlayerData.BattleInfo.levelType, PlayerData.BattleInfo.roleDataList, PlayerData.BattleInfo.squadIndex, PlayerData.BattleInfo.levelIndexStr, PlayerData.BattleInfo.isBattleTest, PlayerData.BattleInfo.eventId, PlayerData.BattleInfo.levelKey, PlayerData.BattleInfo.battleFinishCallback, noCallBack, PlayerData.BattleInfo.enemyLevelMin, PlayerData.BattleInfo.difficulty, PlayerData.BattleInfo.bgId, PlayerData.BattleInfo.enemyLevel, PlayerData.BattleInfo.enemyRn, PlayerData.BattleInfo.weatherIdList, PlayerData.BattleInfo.weatherRateSN, PlayerData.BattleInfo.enemyLevelOffset, PlayerData.BattleInfo.secondWeatherList, PlayerData.BattleInfo.secondWeatherRateSN, PlayerData.BattleInfo.secondWeatherCount, PlayerData.BattleInfo.enemy_ids, PlayerData.BattleInfo.trainWeaponSkill, PlayerData.BattleInfo.ttbSid, PlayerData.BattleInfo.ttbIndex, PlayerData.BattleInfo.ttbId, PlayerData.BattleInfo.dialogId, PlayerData.BattleInfo.friendId, PlayerData.BattleInfo.gridId, PlayerData.BattleInfo.csActivityId, PlayerData.BattleInfo.csIndex, PlayerData.BattleInfo.serverIndex)
  end
}
return ViewFunction
