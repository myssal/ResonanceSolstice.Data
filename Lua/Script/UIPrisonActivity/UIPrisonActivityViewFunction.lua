local View = require("UIPrisonActivity/UIPrisonActivityView")
local DataModel = require("UIPrisonActivity/UIPrisonActivityDataModel")
local Controller = require("UIPrisonActivity/UIPrisonActivityController")
local ViewFunction = {
  PrisonActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    Controller:AddActivity()
  end,
  PrisonActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  PrisonActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PrisonActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    Controller:OpenCardPage()
  end,
  PrisonActivity_Group_Join_Group_Exchange_Btn__Click = function(btn, str)
    local shopList = {}
    local prisonCfg = PrisonData.GetPrisonCA()
    for i, v in ipairs(prisonCfg.prisonStoreList) do
      table.insert(shopList, v.id)
    end
    local shopIds = table.concat(shopList, ",")
    Net:SendProto("shop.info", function(json)
      PlayerData:RefreshShops(json.shops)
      UIManager:Open("UI/Prison/PrisonShop/PrisonShop", Json.encode({openTab = 2}))
    end, shopIds)
  end,
  PrisonActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  PrisonActivity_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    Controller:OpenPrison()
  end
}
return ViewFunction
