local View = require("UIGoldLevel/UIGoldLevelView")
local DataModel = require("UIGoldLevel/UIGoldLevelDataModel")
local ViewFunction = require("UIGoldLevel/UIGoldLevelViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if DataModel.isInit == true then
      return
    end
    DataModel.levelManager = CBus:GetManager(CS.ManagerName.LevelManager)
    DataModel.levelCA = PlayerData:GetFactoryData(DataModel.levelManager.currentLevel.ca.id)
    local correspondingActivityCA = PlayerData:GetFactoryData(DataModel.levelCA.correspondingActivity)
    local isGoldLevel = DataModel.levelCA.saleLevelType == "Infinite" and correspondingActivityCA and correspondingActivityCA.isGoldLevel
    DataModel.isGoldLevel = isGoldLevel
    View.Img_BG:SetActive(isGoldLevel)
    if DataModel.isGoldLevel then
      DataModel.curWave = 0
      DataModel.curReward = 0
      View.Img_BG.Txt_:SetText(0)
    end
    DataModel.isInit = true
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    if not DataModel.isGoldLevel then
      return
    end
    DataModel.remainTime = DataModel.remainTime - 0.02
    if DataModel.remainTime <= 0 then
      if DataModel.curWave < DataModel.levelManager.currentEnemyWave - 1 then
        DataModel.curWave = DataModel.levelManager.currentEnemyWave - 1
        local enemyWaveList = DataModel.levelManager.currentLevel.enemyWaveList
        local waveId = enemyWaveList[(DataModel.curWave - 1) % enemyWaveList.Count].enemyWaveId.id
        local waveCA = PlayerData:GetFactoryData(waveId)
        local curDifficulty = PlayerData.BattleInfo.difficulty
        if waveCA ~= nil and curDifficulty <= #waveCA.dropTableList then
          local dropId = waveCA.dropTableList[curDifficulty].listId
          local dropCA = PlayerData:GetFactoryData(dropId)
          if dropCA ~= nil and 1 <= #dropCA.leveldropList then
            DataModel.curReward = DataModel.curReward + dropCA.leveldropList[1].numMax
          end
        end
        local maxReward = DataModel.levelCA.maxGold
        if maxReward <= DataModel.curReward then
          local lm = CBus:GetManager(CS.ManagerName.LevelManager)
          PlayerData.SetIsTest(false)
          lm:GameOver(false)
        end
        View.Img_BG.Group_Effect.self.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem)):Play()
        View.Img_BG.Txt_:SetText(math.min(DataModel.curReward, maxReward))
      end
      DataModel.remainTime = DataModel.constTime
    end
  end,
  ondestroy = function()
    DataModel.isInit = nil
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
