local View = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesView")
local DataModel = require("UIWorldBossBuyTimes/UIWorldBossBuyTimesDataModel")
local Controller = {}

function Controller.ShowPanel()
  View.Group_Middle.ScrollGrid_Dikuang.grid.self:SetDataCount(#DataModel.cfg.bossTimesCost)
  View.Group_Middle.ScrollGrid_Dikuang.grid.self:RefreshAllElement()
  View.Group_Middle.Txt_Count:SetText(string.format(GetText(80611357), PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)].dailyBuy))
end

return Controller
