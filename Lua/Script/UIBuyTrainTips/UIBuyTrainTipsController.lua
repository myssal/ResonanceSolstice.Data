local View = require("UIBuyTrainTips/UIBuyTrainTipsView")
local DataModel = require("UIBuyTrainTips/UIBuyTrainTipsDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller.Init()
  Controller.InitContentShow()
end

function Controller.InitContentShow()
  View.Group_Slider.Slider_Value:SetMinAndMaxValue(1, DataModel.maxCount)
  local weaponCA = PlayerData:GetFactoryData(DataModel.weaponId, "HomeWeaponFactory")
  if not weaponCA then
    return
  end
  local goodId = DataModel.GetShopGoodId()
  if not goodId then
    return
  end
  local goodsCA = PlayerData:GetFactoryData(goodId, "CommodityFactory")
  DataModel.goodsCA = goodsCA
  if not goodsCA then
    return
  end
  CommonItem:SetItem(View.Group_Item, {
    id = goodsCA.commodityItemList[1].id
  })
  Controller.RefreshCountShow()
  local moneyList = goodsCA.moneyList or {}
  View.Group_Cost.Img_Btm.StaticGrid_.grid.self:SetDataCount(#moneyList)
end

function Controller.RefreshCountShow()
  View.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.curCount)
  View.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.maxCount)
  View.Group_Cost.Img_Btm.StaticGrid_.grid.self:RefreshAllElement()
end

function Controller.RefreshSliderCountShow()
  View.Group_Slider.Slider_Value:SetSliderValue(DataModel.curCount)
end

function Controller.RefreshCostItemElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not DataModel.goodsCA then
    return
  end
  local moneyList = DataModel.goodsCA.moneyList or {}
  local moneyInfo = moneyList[elementIndex]
  if not moneyInfo then
    return
  end
  local price = moneyInfo.moneyNum or 0
  local itemCa = PlayerData:GetFactoryData(moneyInfo.moneyID, "ItemFactory")
  if itemCa and not string.nilorempty(itemCa.buyPath) then
    element.Img_:SetSprite(itemCa.buyPath)
  end
  element.Txt_Num:SetText(price * DataModel.curCount)
end

function Controller.OnMinusMaxBtnClick()
  DataModel.curCount = DataModel.curCount - 10
  if DataModel.curCount < 0 then
    DataModel.curCount = 0
  end
  Controller.RefreshCountShow()
  Controller.RefreshSliderCountShow()
end

function Controller.OnMinusOneBtnClick()
  DataModel.curCount = DataModel.curCount - 1
  if DataModel.curCount < 0 then
    DataModel.curCount = 0
  end
  Controller.RefreshCountShow()
  Controller.RefreshSliderCountShow()
end

function Controller.OnAddMaxBtnClick()
  DataModel.curCount = DataModel.curCount + 10
  if DataModel.curCount > DataModel.maxCount then
    DataModel.curCount = DataModel.maxCount
  end
  Controller.RefreshCountShow()
  Controller.RefreshSliderCountShow()
end

function Controller.OnAddOneBtnClick()
  DataModel.curCount = DataModel.curCount + 1
  if DataModel.curCount > DataModel.maxCount then
    DataModel.curCount = DataModel.maxCount
  end
  Controller.RefreshCountShow()
  Controller.RefreshSliderCountShow()
end

function Controller.OnSaleBtnClick()
  if DataModel.curCount < DataModel.minCount then
    return
  end
  local goodId = DataModel.GetShopGoodId()
  if not goodId then
    return
  end
  local moneyList = DataModel.goodsCA.moneyList or {}
  local moneyInfo = moneyList[1]
  if not moneyInfo then
    return
  end
  local price = moneyInfo.moneyNum or 0
  local costNum = DataModel.curCount * price
  local nowNum = PlayerData:GetGoodsById(moneyInfo.moneyID).num or 0
  if costNum > nowNum then
    CommonTips.OpenTips(80611327)
    return
  end
  Net:SendProto("shop.buy", function(json)
    if json and string.nilorempty(json.rc) then
      CommonTips.OpenShowItem(json.reward)
      PlayerData:RefreshUseItems({
        [moneyInfo.moneyID] = costNum
      })
    end
  end, tostring(DataModel.shopId), 1, DataModel.curCount, goodId)
end

return Controller
