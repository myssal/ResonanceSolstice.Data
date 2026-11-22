local View = require("UIActivitySignBattleLevelDRamisSkin/UIActivitySignBattleLevelDRamisSkinView")
local DataModel = require("UIActivitySignBattleLevelDRamisSkin/UIActivitySignBattleLevelDRamisSkinDataModel")
local ViewFunction = require("UIActivitySignBattleLevelDRamisSkin/UIActivitySignBattleLevelDRamisSkinViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    DataModel:Init()
    View.Group_Main.Txt_Time:SetText("")
    Net:SendProto("activity.get_cs_activity", function(json)
      DataModel:SetSignBattleData(json)
      if DataModel.signBattleData[tostring(DataModel.activityId)] then
        local end_ts = DataModel.signBattleData[tostring(DataModel.activityCA.id)].end_ts
        DataModel.end_Ts = end_ts
        local time = TimeUtil:GetNewTimeTable(end_ts)
        local show_time = time.month .. "/" .. time.day .. " " .. time.hour .. ":" .. time.min
        View.Group_Main.Txt_Time:SetText(string.format(GetText(80610042), tostring(show_time)))
      end
      
      local function callback_progress(activityId)
        local cur = 0
        local cs_activity = DataModel.signBattleData
        local data = cs_activity[tostring(activityId)]
        if data then
          cur = #data.pass_level_index
        end
        local activityCA = PlayerData:GetFactoryData(activityId)
        local progress = cur / #activityCA.signLevelList
        progress = 1 < progress and 1 or progress
        return progress
      end
      
      local function callback(activityId, node_progress, rewardStateKey, activityCA, node_reward)
        local progress = callback_progress(activityId)
        node_progress:SetText(PlayerData:GetPreciseDecimalFloor(progress * 100, 0) .. "%")
        local state = DataModel:GetRewardButtonIsActive(activityId)
        DataModel[rewardStateKey] = state
        if 0 < #activityCA.signBattleRewards then
          node_reward.Group_Lock.self:SetActive(state == DataModel.BtnEnm.unFinish)
          node_reward.Group_On.self:SetActive(state == DataModel.BtnEnm.finish)
          node_reward.Group_Got.self:SetActive(state == DataModel.BtnEnm.receive)
        else
          node_reward.Group_Lock.self:SetActive(progress < 1)
          node_reward.Group_On.self:SetActive(false)
          node_reward.Group_Got.self:SetActive(progress == 1)
        end
        if state == DataModel.BtnEnm.finish and 0 < #activityCA.signBattleRewards then
          Net:SendProto("activity.rec_cs_reward", function(json)
            DataModel[rewardStateKey] = DataModel.BtnEnm.receive
            CommonTips.OpenShowItem(json.reward)
            node_reward.Group_On.self:SetActive(false)
            node_reward.Group_Got.self:SetActive(true)
            local ActivityMainController = require("UIActivityMain/UIActivityMainController")
            ActivityMainController:RefreshLeftRedState()
          end, activityId)
        end
      end
      
      callback(DataModel.activityId, View.Group_Main.Btn_StartSkin.Txt_Progress, "rewardState", DataModel.activityCA, View.Group_Main.Group_RewardSkin.Btn_Reward)
      callback(DataModel.activityId2, View.Group_Main.Btn_StartRole.Txt_Progress, "rewardState2", DataModel.activityCA2, View.Group_Main.Group_RewardRole.Btn_Reward)
      View.Group_Bg.Img_Bg.Img_Logo1:SetSprite(GetResPath(88300288))
      View.Group_Bg.Img_Bg.Img_Logo2:SetSprite(GetResPath(88300289))
    end)
    local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
    local isQuestFinish = DataModel.activityCA.questId ~= -1 and ActivityMainDataModel:QuestIsFinish(DataModel.activityCA.questId) == true or DataModel.activityCA.questId == -1
    DataModel.isQuestFinish = isQuestFinish
    View.Group_Main.Btn_Gacha:SetActive(isQuestFinish and TimeUtil:IsActive(DataModel.activityCA.startTime, DataModel.activityCA.endTime))
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
