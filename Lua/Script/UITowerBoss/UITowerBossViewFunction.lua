local View = require("UITowerBoss/UITowerBossView")
local DataModel = require("UITowerBoss/UITowerBossDataModel")
local ViewFunction = {
  TowerBoss_Btn_Bg_Click = function(btn, str)
    local BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
    BattleControlManager:Pause(false)
    UIManager:GoBack(false)
  end,
  TowerBoss_Group_BuffList_Btn_Close_Click = function(btn, str)
  end
}
return ViewFunction
