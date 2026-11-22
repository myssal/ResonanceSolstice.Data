local View = require("UIActiveStore/UIActiveStoreView")
local DataModel = require("UIActiveStore/UIActiveStoreDataModel")
local NPCDialog = require("Common/NPCDialog")
local Controller = {}

function Controller:Init(isFirst)
  DataModel.StoreList = {}
  DataModel.CoinList = {}
  if DataModel.StoreCA.shopList and table.count(DataModel.StoreCA.shopList) > 0 then
    for k, v in pairs(DataModel.StoreCA.shopList) do
      local row = {}
      row.num = 0
      row.id = v.id
      row.ca = PlayerData:GetFactoryData(v.id)
      if PlayerData.ServerData.shops ~= nil then
        local shops = PlayerData.ServerData.shops[tostring(DataModel.ShopId)]
        if shops and shops.items then
          for c, d in pairs(shops.items) do
            if tonumber(d.id) == tonumber(v.id) then
              row.num = d.py_cnt
            end
          end
        end
      end
      row.index = k
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(row.ca)
      row.isResidual = 0 >= maxNum - row.num and true or false
      row.residue = 0 < maxNum - row.num and maxNum - row.num or 0
      row.isMax_index = row.isResidual == true and 2 or 1
      table.insert(DataModel.StoreList, row)
    end
    table.sort(DataModel.StoreList, function(a, b)
      if a.isMax_index == b.isMax_index then
        return a.index < b.index
      end
      return a.isMax_index < b.isMax_index
    end)
    if isFirst then
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
        View.Group_Right.NewScrollGrid_CommodityList.grid.self:SetDataCount(table.count(DataModel.StoreList))
        View.Group_Right.NewScrollGrid_CommodityList.grid.self:RefreshAllElement()
        View.Group_Right.NewScrollGrid_CommodityList.grid.self:MoveToTop()
      end))
    else
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:SetDataCount(table.count(DataModel.StoreList))
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:RefreshAllElement()
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:MoveToTop()
    end
  else
    print_r("\231\173\150\229\136\146\231\188\186\229\176\145\233\133\141\231\189\174StoreCA.shopList")
  end
  if DataModel.StoreCA.currencyShow and 0 < table.count(DataModel.StoreCA.currencyShow) then
    for k, v in pairs(DataModel.StoreCA.currencyShow) do
      local row = {}
      row = v
      local ca = PlayerData:GetFactoryData(v.id)
      row.buyPath = ca.buyPath
      row.num = PlayerData:GetGoodsById(v.id).num
      table.insert(DataModel.CoinList, row)
    end
    View.StaticGrid_Coin.grid.self:SetDataCount(table.count(DataModel.CoinList))
    View.StaticGrid_Coin.grid.self:RefreshAllElement()
  else
    print_r("\231\173\150\229\136\146\231\188\186\229\176\145\233\133\141\231\189\174StoreCA.currencyShow")
  end
  if isFirst then
    DataModel.NpcId = PlayerData:GetFactoryData(DataModel.ActivityId).npcId
    NPCDialog.SetNPC(View.Group_NPC, DataModel.NpcId)
    NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.enterText)
  end
end

return Controller
