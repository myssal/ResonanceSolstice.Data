local View = require("UIHomeStickerStore/UIHomeStickerStoreView")
local DataModel = require("UIHomeStickerStore/UIHomeStickerStoreDataModel")
local Controller = {}

function Controller:Init()
  DataModel:Init()
  local scrollViewGrid = View.ScrollGrid_Item.grid.self
  scrollViewGrid:SetDataCount(#DataModel.ItemList)
  scrollViewGrid:RefreshAllElement()
  self:RefreshHBPNum()
end

function Controller:RefreshHBPNum()
  View.Img_HBPNum.Txt_Num:SetText(math.ceil(PlayerData:GetSpecialCurrencyById(11400100) or 0))
end

function Controller:GeneralBuyClickItem(str)
  local idx = tonumber(str)
  local row = DataModel.ItemList[idx]
  row.commoditData = PlayerData:GetFactoryData(row.id)
  row.index = idx - 1
  row.shopid = DataModel.ShopId
  row.name = row.commoditData.commodityName
  row.image = row.commoditData.commodityView
  row.storeType = PlayerData:GetFactoryData(DataModel.ShopId, "StoreFactory").storeType
  row.qualityInt = row.commoditData.qualityInt + 1
  local item = PlayerData:GetGoodsById(tostring(row.commoditData.moneyList[1].moneyID))
  local newNum = item.num - math.ceil(row.commoditData.moneyList[1].moneyNum)
  CommonTips.OpenBuyTips(row, function(cnt)
    local it = PlayerData:GetGoodsById(tostring(row.commoditData.moneyList[1].moneyID))
    it.num = newNum
    local homeStickerView = require("UIHomeSticker/UIHomeStickerView")
    homeStickerView.Img_HBP.Txt_Num:SetText(math.ceil(PlayerData:GetSpecialCurrencyById(11400100) or 0))
    self:RefreshHBPNum()
  end)
end

return Controller
