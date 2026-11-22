local View = require("UIGroup_EventWeek/UIGroup_EventWeekView")
local DataModel = require("UIGroup_EventWeek/UIGroup_EventWeekDataModel")
local CommonItem = require("Common/BtnItem")

local function ShowPanel(panleType)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Interview.Group_Unselected:SetActive(panleType ~= 1)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Trade.Group_UnSelected:SetActive(panleType ~= 2)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Guest.Group_UnSelected:SetActive(panleType ~= 3)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Manufacture.Group_UnSelected:SetActive(panleType ~= 4)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Order.Group_UnSelected:SetActive(panleType ~= 5)
  View.Group_Info.Group_Tv.Group_Information.Group_Interview:SetActive(panleType == 1)
  View.Group_Info.Group_Tv.Img_Live:SetActive(panleType == 1)
  View.Group_Info.Group_Tv.Group_Information.Group_Trade:SetActive(panleType == 2)
  View.Group_Info.Group_Tv.Group_Information.Group_Guest:SetActive(panleType == 3)
  View.Group_Info.Group_Tv.Group_Information.Group_Manufacture:SetActive(panleType == 4)
  View.Group_Info.Group_Tv.Group_Information.Group_Order:SetActive(panleType == 5)
end

local ViewFunction = {
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Trade_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowTradList[elementIndex]
    CommonItem:SetItem(element.Group_Item.Group_CommonItem, {
      id = data.goodsId,
      num = 1
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Group_CommonItem.Btn_Item:SetClickParam(data.goodsId)
    element.Txt_ItemName:SetText(PlayerData:GetFactoryData(data.goodsId).name)
    local goods = PlayerData.ServerData.server_resident["86000010"].goods
    local goodsInfo = goods[tostring(data.goodsId)] or data
    element.Group_Price.Txt_MinNum:SetActive(goodsInfo.buy_price)
    element.Group_Price.Txt_:SetActive(goodsInfo.buy_price)
    element.Group_Price.Txt_MaxNum:SetActive(goodsInfo.buy_price)
    element.Group_Price.Txt_No:SetActive(goodsInfo.buy_price == nil)
    if goodsInfo.buy_price then
      element.Group_Price.Txt_MinNum:SetText(string.format("%d%%", math.floor(goodsInfo.buy_price.min_quota * 100)))
      element.Group_Price.Txt_MaxNum:SetText(string.format("%d%%", math.floor(goodsInfo.buy_price.max_quota * 100)))
    end
    element.Group_Price.Txt_SelllMinNum:SetActive(goodsInfo.sell_price)
    element.Group_Price.Txt_Sell:SetActive(goodsInfo.sell_price)
    element.Group_Price.Txt_SellMaxNum:SetActive(goodsInfo.sell_price)
    element.Group_Price.Txt_SellNo:SetActive(goodsInfo.sell_price == nil)
    if goodsInfo.sell_price then
      element.Group_Price.Txt_SelllMinNum:SetText(string.format("%d%%", math.floor(goodsInfo.sell_price.min_quota * 100)))
      element.Group_Price.Txt_SellMaxNum:SetText(string.format("%d%%", math.floor(goodsInfo.sell_price.max_quota * 100)))
    end
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Trade_ScrollGrid_Trade_Group_Item_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Guest_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowQueatList[elementIndex]
    element.Group_Text.Img_Icon:SetActive(false)
    local content = data.desc
    element.Group_Text.Img_Mask:SetWidth(485)
    if data.showIcon then
      element.Group_Text.Img_Mask:SetWidth(430)
      element.Group_Text.Img_Icon:SetActive(true)
      local cfg = PlayerData:GetFactoryData(data.id)
      element.Group_Text.Img_Icon:SetSprite(cfg.showIcon)
      content = cfg.name
      content = data.desc .. content
    end
    element.Group_Text.Img_Mask.Txt_Circle:SetText(content)
    local startposx = element.Group_Text.Img_Mask.Rect.rect.width
    local txtWidth = element.Group_Text.Img_Mask.Txt_Circle:GetWidth()
    element.Group_Text.Img_Mask.Txt_Circle:SetAnchoredPositionX(0)
    DOTweenTools.Kill(element.Group_Text.Img_Mask.Txt_Circle.transform)
    if startposx < txtWidth then
      element.Group_Text.Img_Mask.Txt_Circle:SetText(content .. "    " .. content)
      local spaceWidth = math.floor(element.Group_Text.Img_Mask.Txt_Circle.Txt.fontSize / 5) + 1
      local spaceNum = 4
      local txtWidth = element.Group_Text.Img_Mask.Txt_Circle:GetWidth()
      local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
      DOTweenTools.DOLocalMoveX(element.Group_Text.Img_Mask.Txt_Circle.transform, -endposx, 8):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
    end
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Manufacture_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowManufactureList[elementIndex]
    CommonItem:SetItem(element.Group_Item.Group_CommonItem, {
      id = data.id,
      num = 1
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Group_CommonItem.Btn_Item:SetClickParam(data.id)
    element.Txt_ItemName:SetText(PlayerData:GetFactoryData(data.id).name)
    element.Group_Price.Txt_Num:SetText(math.floor(data.highCoefficient * data.basePrice))
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Manufacture_ScrollGrid_Trade_Group_Item_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Interview_Click = function(btn, str)
    ShowPanel(1)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Trade_Click = function(btn, str)
    ShowPanel(2)
    DataModel.GetTradData()
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowTradList)
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Guest_Click = function(btn, str)
    ShowPanel(3)
    DataModel.GetQueatData()
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowQueatList)
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Manufacture_Click = function(btn, str)
    ShowPanel(4)
    DataModel.GetManufactureData()
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowManufactureList)
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  ShowPanel = ShowPanel,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Order_ScrollGrid_Order_SetGrid = function(element, elementIndex)
    local data = DataModel.nowOrderList[elementIndex]
    local cfg = PlayerData:GetFactoryData(data.id)
    local requireItemId = cfg.requireItemList[1].id
    CommonItem:SetItem(element.Group_Item.Group_CommonItem, {id = requireItemId})
    element.Txt_ItemName:SetText(cfg.name)
    element.Group_Price.Txt_Num:SetText(math.floor(data.param * 100) .. "%")
    element.Group_Item.Group_CommonItem.Btn_Item:SetClickParam(requireItemId)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Information_Group_Order_ScrollGrid_Order_Group_Item_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Order_Click = function(btn, str)
    ShowPanel(5)
    DataModel.GetOrderData()
    View.Group_Info.Group_Tv.Group_Information.Group_Order.ScrollGrid_Order.grid.self:SetDataCount(#DataModel.nowOrderList)
    View.Group_Info.Group_Tv.Group_Information.Group_Order.ScrollGrid_Order.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Order.ScrollGrid_Order.grid.self:MoveToTop()
  end
}
return ViewFunction
