local View = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyView")
local DataModel = require("UIPrisonWarehouseBuy/UIPrisonWarehouseBuyDataModel")
local Controller = {}

function Controller:Init()
  DataModel.BuySpaceNum = 1
  Controller:SwitchExpandSpaceBuyMode(1)
end

function Controller:SwitchExpandSpaceBuyMode(mode)
  View.Group_Diamond:SetActive(mode == 2)
  View.Group_Gold:SetActive(mode == 1)
  DataModel.CurCapacityBuyMode = mode
  Controller:RefreshExpand()
end

function Controller:RefreshExpand()
  local maxNum, minNum
  local isExpand = DataModel.CurCapacityBuyMode == 2
  local remainGoodSpace = DataModel.GoldMaxSpace
  local remainExtraGoodsSpace = DataModel.DiamondMaxSpace
  local prisonCfg = PrisonData.GetPrisonCA()
  local price = isExpand and prisonCfg.extraBuyWarePrice[1] or prisonCfg.buyWarePrice[1]
  if remainGoodSpace <= 0 and remainExtraGoodsSpace <= 0 then
    DataModel.CanBuySpace = false
    CommonTips.OpenTips(80607404)
    View.self:SetActive(false)
    return
  end
  if 0 < remainGoodSpace then
    View.Txt_GoldNum:SetText(string.format(GetText(80607402), remainGoodSpace))
  else
    View.Txt_GoldNum:SetText(GetText(80608958))
  end
  if 0 < remainExtraGoodsSpace then
    View.Txt_DiamondNum:SetText(string.format(GetText(80607402), remainExtraGoodsSpace))
  else
    View.Txt_DiamondNum:SetText(GetText(80608958))
  end
  View.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetGoodsById(11400001).num)
  View.Group_DiamondCount.Txt_Num:SetText(PlayerData:GetGoodsById(11400005).num)
  maxNum = isExpand and remainExtraGoodsSpace or remainGoodSpace
  local canBuyNum = math.floor(PlayerData:GetGoodsById(price.id).num / price.num)
  if maxNum > canBuyNum then
    maxNum = canBuyNum
  end
  DataModel.CanBuySpace = true
  minNum = 1
  minNum = maxNum < minNum and maxNum or minNum
  if minNum == 0 then
    minNum = 1
  end
  View.Group_Slider.Group_Num.Txt_Select:SetText(minNum)
  View.Group_Slider.Group_Num.Txt_Possess:SetText(maxNum)
  View.Group_Slider.Slider_Value.self:SetMinAndMaxValue(minNum, maxNum, true)
  View.Group_Slider.Slider_Value.self:SetSliderValue(minNum)
  Controller:RefreshBuyTipsMoney(minNum)
  DataModel.BuySpaceNum = minNum
end

function Controller:RefreshBuyTipsMoney(num)
  local isExpand = DataModel.CurCapacityBuyMode == 2
  View.Group_Slider.Group_Num.Txt_Select:SetText(num)
  local prisonCfg = PrisonData.GetPrisonCA()
  local price = isExpand and prisonCfg.extraBuyWarePrice[1] or prisonCfg.buyWarePrice[1]
  local cost = num * price.num
  local have = PlayerData:GetGoodsById(price.id).num
  local goldCost = isExpand and 0 or cost <= have and num * price.num or string.format("<color=#CD5454>%d</color>", cost)
  local diamondCost = isExpand and (cost <= have and num * price.num or string.format("<color=#CD5454>%d</color>", cost)) or 0
  View.Group_Gold.Btn_Gold.Group_On.Txt_Gold:SetText(goldCost)
  View.Group_Diamond.Btn_Diamond.Group_Off.Txt_Gold:SetText(goldCost)
  View.Group_Diamond.Btn_Diamond.Group_On.Txt_Mileage:SetText(diamondCost)
  View.Group_Gold.Btn_Gold.Group_Off.Txt_Mileage:SetText(diamondCost)
end

function Controller:ConfirmBuy()
  local wareType
  if DataModel.BuyType == 1 then
    wareType = "material"
  elseif DataModel.BuyType == 2 then
    wareType = "product"
  end
  if DataModel.CurCapacityBuyMode == 1 then
    if DataModel.BuySpaceNum > DataModel.GoldMaxSpace then
      CommonTips.OpenTips(GetText(80607404))
      return
    end
  elseif DataModel.BuySpaceNum > DataModel.DiamondMaxSpace then
    CommonTips.OpenTips(GetText(80607404))
    return
  end
  if DataModel.CurCapacityBuyMode == 2 then
    Net:SendProto("prison.up_extra_ware", function(json)
      if DataModel.BuyType == 1 then
        PlayerData.ServerData.user_prison_info.material_space = PlayerData.ServerData.user_prison_info.material_space + DataModel.BuySpaceNum
      elseif DataModel.BuyType == 2 then
        PlayerData.ServerData.user_prison_info.product_space = PlayerData.ServerData.user_prison_info.product_space + DataModel.BuySpaceNum
      end
      DataModel.StationGoodsProductMaxSpace = PrisonData.GetProductWarehouseMaxCapacity()
      DataModel.StationGoodsMaterialMaxSpace = PrisonData.GetRawMaterialWarehouseMaxCapacity()
      UIManager:GoBack()
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      CommonTips.OpenTips(GetText(80608960))
    end, wareType, tostring(DataModel.BuySpaceNum))
  else
    Net:SendProto("prison.up_ware", function(json)
      UIManager:GoBack()
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      CommonTips.OpenTips(GetText(80608960))
    end, wareType, DataModel.BuySpaceNum)
  end
end

return Controller
