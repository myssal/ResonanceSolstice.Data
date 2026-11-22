local View = require("UIMoonthCard/UIMoonthCardView")
local DataModel = {DropAwardList = nil}

local function ShowReward()
  Net:SendProto("main.monthly_card", function(json)
    DataModel.DropAwardList = PlayerData:SortShowItem(json.reward)
    if PlayerData.ServerData.monthly_card and PlayerData.ServerData.monthly_card["11400018"] then
      local t = PlayerData.ServerData.monthly_card["11400018"]
      local diff = 0
      local timeTable = TimeUtil:GetLogicServerDayTable()
      local year = timeTable.year
      local month = timeTable.month
      local day = timeTable.day
      local curDayStamp = os.time({
        year = year,
        month = month,
        day = day,
        hour = 5,
        minute = 0,
        second = 0
      }) + TimeUtil:GetLocalTimeZone() * 3600
      diff = t.deadline - curDayStamp
      if not PlayerData.ServerData.monthly_sign[tostring(month)] then
        PlayerData.ServerData.monthly_sign[tostring(month)] = {}
      end
      PlayerData.ServerData.monthly_sign[tostring(month)][tostring(day)] = {m_card = true, day = true}
      if 0 < diff then
        local time = TimeUtil:SecondToTable(diff)
        View.Group_Reward.Group_Time.Txt_Time:SetText(string.format(GetText(80601102), time.day))
        View.Group_Reward.self:SetActive(true)
        View.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.DropAwardList))
        View.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
        View.self:PlayAnim("MonthCardDotAnim")
      end
    end
  end)
end

function DataModel.ClickBG()
  if View.Group_Reward.self.IsActive == false then
    ShowReward()
    return
  end
  UIManager:CloseTip("UI/Common/MoonthCard/MoonthCard")
end

return DataModel
