local View = require("UITarget/UITargetView")
local DataModel = require("UITarget/UITargetDataModel")
local ViewFunction = require("UITarget/UITargetViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local levelManager = CBus:GetManager(CS.ManagerName.LevelManager)
    local curLevel = levelManager.currentLevel
    local coreId = curLevel.ca.levelCoreId.id
    local coreCA = PlayerData:GetFactoryData(coreId)
    DataModel.coreCA = coreCA
    local serverInfo = PlayerData.ServerData.engines[tostring(coreId)]
    local curLv = serverInfo.lv
    DataModel.curLv = curLv
    DataModel.isComplete = false
    View.Group_Target.Group_Complete.self:SetActive(false)
    local targetLevel = curLv + 1
    for i = targetLevel, #coreCA.coreExpList do
      if coreCA.coreExpList[i].isBreak then
        targetLevel = i
        break
      end
    end
    if coreCA.coreExpList[targetLevel] ~= nil then
      View.Group_Target.Group_Not.Group_Num.Txt_:SetText(string.format(GetText(80608791), targetLevel))
      View.Group_Target.Group_Not.Group_Num.Txt_Num:SetText(coreCA.coreExpList[targetLevel].num)
      if coreCA.coreExpList[targetLevel].isBreak then
        local curNum = serverInfo.num
        if curNum >= coreCA.coreExpList[targetLevel].num then
          View.Group_Target.Group_Complete.self:SetActive(true)
          DataModel.isComplete = true
        end
      end
    else
      View.Group_Target.Group_Complete.self:SetActive(true)
      DataModel.isComplete = true
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if not DataModel.isComplete then
      local coreCA = DataModel.coreCA
      local curLv = DataModel.curLv
      local targetLevel = curLv + 1
      for i = targetLevel, #coreCA.coreExpList do
        if coreCA.coreExpList[i].isBreak then
          targetLevel = i
          break
        end
      end
      if coreCA.coreExpList[targetLevel] ~= nil then
        local levelManager = CBus:GetManager(CS.ManagerName.LevelManager)
        local curLevel = levelManager.currentLevel
        local targetNum = coreCA.coreExpList[targetLevel].num
        local levelNum = tonumber(curLevel:GetCoreBuffStr())
        if targetNum <= levelNum then
          View.Group_Target.Group_Complete.self:SetActive(true)
          DataModel.isComplete = true
        end
      end
    end
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
