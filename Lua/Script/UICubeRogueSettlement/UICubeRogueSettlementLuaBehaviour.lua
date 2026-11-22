local View = require("UICubeRogueSettlement/UICubeRogueSettlementView")
local DataModel = require("UICubeRogueSettlement/UICubeRogueSettlementDataModel")
local ViewFunction = require("UICubeRogueSettlement/UICubeRogueSettlementViewFunction")
local Controller = require("UICubeRogueSettlement/UICubeRogueSettlementController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    
    local function cb(json)
      PlayerData:DeletePlayerPrefs("CubeRogueFaceAnimation")
      local cfg = GetCA(89400002, "CubeRogueFactory")
      local oldExp = PlayerData.TempCache.CubeRogueData.exp or 0
      local oldLv = PlayerData.TempCache.CubeRogueData.lv or 0
      data.reward = json.reward
      data.specialItemNum = PlayerData:GetGoodsById(cfg.specialItemId).num
      PlayerData:RefreshUseItems({
        [cfg.specialItemId] = data.specialItemNum
      })
      if data.reward.item then
        local skillPointId = tostring(cfg.skillItem)
        data.addSkillPoint = data.reward.item[skillPointId] and data.reward.item[skillPointId].num or 0
        data.reward.item[skillPointId] = nil
        local weeklyPointId = tostring(cfg.weeklyExperienceItem)
        data.addWeeklyPoint = data.reward.item[weeklyPointId] and data.reward.item[weeklyPointId].num or 0
        data.reward.item[weeklyPointId] = nil
      else
        data.addSkillPoint = 0
        data.addWeeklyPoint = 0
      end
      local addExp
      if data.reward.rg_exp then
        local expId = tostring(cfg.commonExperienceItem)
        addExp = data.reward.rg_exp[expId] and data.reward.rg_exp[expId].num or 0
        data.reward.rg_exp[expId] = nil
      else
        addExp = 0
      end
      local nextLevel = oldLv + 1
      local nextLevelExp
      data.expStartRate = {}
      data.expEndRate = {}
      data.startLv = oldLv
      data.endLv = oldLv
      data.addExp = addExp
      local endExp = addExp
      DataModel.cfg = cfg
      local curExp = oldExp + addExp
      local i = 1
      while i <= #cfg.commonLevelStageList do
        local list = GetCA(cfg.commonLevelStageList[i].stageList, "ActivityFactory").rewardsList
        local listCount = #list
        if nextLevel > listCount then
          nextLevel = nextLevel - listCount
        else
          nextLevelExp = list[nextLevel].requiredNum
        end
        if nextLevelExp then
          table.insert(data.expStartRate, oldExp / nextLevelExp)
          curExp = curExp - nextLevelExp
          if 0 <= curExp then
            table.insert(data.expEndRate, 1)
            data.endLv = nextLevel
            if curExp == 0 then
              endExp = 0
              break
            else
              oldLv = nextLevel
              nextLevel = nextLevel + 1
              i = i - 1
              nextLevelExp = nil
              oldExp = 0
            end
          else
            endExp = curExp + nextLevelExp
            table.insert(data.expEndRate, endExp / nextLevelExp)
            data.endLv = oldLv
            break
          end
        end
        i = i + 1
      end
      data.score = json.total_score
      local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
      data.press = RogueController.GetMaxDescent()
      Controller.ShowPanel(data)
      PlayerData.TempCache.CubeRogueData.lv = data.endLv
      PlayerData.TempCache.CubeRogueData.exp = endExp
    end
    
    local tempJson = data.json
    data.json = nil
    if tempJson == nil then
      Net:SendProto("cube.end_cube", function(json)
        tempJson = json
        cb(tempJson)
      end, data.isWin)
    else
      cb(tempJson)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
    Controller.ClearData()
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
