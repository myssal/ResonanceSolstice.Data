local View = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesView")
local DataModel = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesDataModel")
local Controller = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  WorldBossBuyTimes_Btn_BG_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  WorldBossBuyTimes_Group_Middle_ScrollGrid_Dikuang_SetGrid = function(element, elementIndex)
    local data = DataModel.cfg.bossTimesCost[elementIndex]
    CommonItem:SetItem(element.Img_Dikuang.Group_Item, {
      id = data.id,
      num = nil
    })
    local have = PlayerData:GetGoodsById(data.id).num
    element.Img_Dikuang.Group_Cost.Txt_Have:SetText(have)
    element.Img_Dikuang.Group_Cost.Txt_Have:SetColor(have >= data.num and Color.white or Color.red)
    element.Img_Dikuang.Group_Cost.Txt_Need:SetText(data.num)
    element.Img_Dikuang.Group_Item.Btn_Item:SetClickParam(data.id)
  end,
  WorldBossBuyTimes_Group_Middle_ScrollGrid_Dikuang_Group_Item_Img_Dikuang_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(tonumber(str))
  end,
  WorldBossBuyTimes_Btn_Confirm_Click = function(btn, str)
    local itemCost = {}
    local canBuy = true
    for k, v in pairs(DataModel.cfg.bossTimesCost) do
      if PlayerData:GetGoodsById(v.id).num < v.num then
        canBuy = false
      end
      itemCost[v.id] = v.num
    end
    if not canBuy then
      CommonTips.OpenTips(80600488)
      return
    end
    Net:SendProto("activity.buy_boss_times", function(json)
      local netData = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
      netData.dailyBuy = netData.dailyBuy - 1
      netData.times = netData.times + 1
      UIManager:GoBack(false)
      PlayerData:RefreshUseItems(itemCost)
      local status = {
        Current = "Chapter",
        squadIndex = PlayerData.BattleInfo.squadIndex
      }
      local t = {}
      t.activityId = DataModel.activityId
      t.refresh = true
      t.isBattleReturn = true
      status.extraUIParamData = t
      PlayerData.BattleInfo.battleStageId = DataModel.levelId
      PlayerData.BattleCallBackPage = "UI/Activity/ActivityWorldBoss/WorldBoss"
      PlayerData.TempCache.tempWorldBossActivityId = tostring(DataModel.activityId)
      UIManager:Open("UI/Squads/Squads", Json.encode(status))
    end, DataModel.activityId, 1)
  end,
  WorldBossBuyTimes_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end
}
return ViewFunction
