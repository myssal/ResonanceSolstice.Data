local View = require("UIBattlePause/UIBattlePauseView")
local DataModel = require("UIBattlePause/UIBattlePauseDataModel")
local ViewFunction = require("UIBattlePause/UIBattlePauseViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local LevelManager = CBus:GetManager(CS.ManagerName.LevelManager)
    local ca = LevelManager.currentLevel.ca
    local isTower = ca.saleLevelType == "Tower"
    local btnXOffset = 0
    View.Group_.Btn_BossSkill.self:SetActive(isTower)
    if isTower ~= true then
      btnXOffset = btnXOffset + 114
    end
    local isCube = ca.saleLevelType == "CubeRogue"
    View.Group_.Btn_CubeRestart.self:SetActive(isCube)
    if isCube == true then
      btnXOffset = btnXOffset - 114
    end
    local luaCA = PlayerData:GetFactoryData(ca.id)
    local defaultConfig = PlayerData:GetFactoryData(99900001, "ConfigFactory")
    local isShowEnemySkill = luaCA.isShowEnemySkill and defaultConfig.IsEnemySkillOpen
    local noSkill = true
    for i = 1, #luaCA.enemyWaveList do
      local waveCA = PlayerData:GetFactoryData(luaCA.enemyWaveList[i].enemyWaveId)
      for j = 1, #waveCA.enemyList do
        local enemyId = waveCA.enemyList[j].id
        local enemyCA = PlayerData:GetFactoryData(enemyId)
        if 0 < #enemyCA.enemySkillList then
          noSkill = false
        end
      end
    end
    if noSkill then
      isShowEnemySkill = false
    end
    View.Group_.Btn_EnemySkill.self:SetActive(isShowEnemySkill)
    if isShowEnemySkill ~= true then
      btnXOffset = btnXOffset - 114
    end
    for i = 0, View.Group_.self.transform.childCount - 1 do
      local btn = View.Group_.self.transform:GetChild(i)
      local idx = i
      if i == View.Group_.self.transform.childCount - 1 and isTower ~= true then
        idx = i - 1
      end
      btn.anchoredPosition = Vector2(-590 + 295 * idx + btnXOffset, btn.anchoredPosition.y)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
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
