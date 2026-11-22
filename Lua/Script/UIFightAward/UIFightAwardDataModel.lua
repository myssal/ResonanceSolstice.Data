local View = require("UIFightAward/UIFightAwardView")
local DataModel = {}
DataModel.reward = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  local reward = {}
  if data.reward then
    for itemType, itemList in pairs(data.reward) do
      for itemId, item in pairs(itemList) do
        local t = Clone(item)
        t.id = itemId
        table.insert(reward, t)
      end
    end
  end
  DataModel.reward = reward
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  View.Txt_HelpNum:SetText(string.format(GetText(80610197), PlayerData:GetUserInfo().fg_being_help_count_rt))
  View.ScrollGrid_Item.grid.self:SetDataCount(#DataModel.reward)
  View.ScrollGrid_Item.grid.self:RefreshAllElement()
end

return DataModel
