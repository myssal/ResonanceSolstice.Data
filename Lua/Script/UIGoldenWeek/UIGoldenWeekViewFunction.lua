local View = require("UIGoldenWeek/UIGoldenWeekView")
local DataModel = require("UIGoldenWeek/UIGoldenWeekDataModel")
local CommonItem = require("Common/BtnItem")

local function ShowPanel(panleType)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Interview.Group_Unselected:SetActive(panleType ~= 1)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Trade.Group_UnSelected:SetActive(panleType ~= 2)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Guest.Group_UnSelected:SetActive(panleType ~= 3)
  View.Group_Info.Group_Tv.Group_Tab.Btn_Manufacture.Group_UnSelected:SetActive(panleType ~= 4)
  View.Group_Info.Group_Tv.Group_Information.Group_Interview:SetActive(panleType == 1)
  View.Group_Info.Group_Tv.Img_Live:SetActive(panleType == 1)
  View.Group_Info.Group_Tv.Group_Information.Group_Trade:SetActive(panleType == 2)
  View.Group_Info.Group_Tv.Group_Information.Group_Guest:SetActive(panleType == 3)
  View.Group_Info.Group_Tv.Group_Information.Group_Manufacture:SetActive(panleType == 4)
end

local ViewFunction = {
  GoldenWeek_Group_Info_Group_Tv_Group_Information_Group_Trade_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowTradList[elementIndex]
    CommonItem:SetItem(element.Group_Item.Group_CommonItem, {
      id = data.goodsId,
      num = 1
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Group_CommonItem.Btn_Item:SetClickParam(data.goodsId)
    element.Txt_ItemName:SetText(PlayerData:GetFactoryData(data.goodsId).name)
    element.Group_Price.Txt_MinNum:SetText(string.format("%d%%", math.floor(data.buyQuotationMin * 100)))
    element.Group_Price.Txt_MaxNum:SetText(string.format("%d%%", math.floor(data.sellQuotationMax * 100)))
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Information_Group_Trade_ScrollGrid_Trade_Group_Item_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Information_Group_Guest_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowQueatList[elementIndex]
    element.Group_Text.Img_Icon:SetActive(false)
    local content = data.desc
    if data.isGrade then
      element.Group_Text.Img_Icon:SetActive(true)
      local cfg = PlayerData:GetFactoryData(data.id)
      element.Group_Text.Img_Icon:SetSprite(cfg.showIcon)
      content = cfg.name
    end
    element.Group_Text.Txt_Content:SetText(content)
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Information_Group_Manufacture_ScrollGrid_Trade_SetGrid = function(element, elementIndex)
    local data = DataModel.nowManufactureList[elementIndex]
    CommonItem:SetItem(element.Group_Item.Group_CommonItem, {
      id = data.id,
      num = 1
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Group_CommonItem.Btn_Item:SetClickParam(data.id)
    element.Txt_ItemName:SetText(PlayerData:GetFactoryData(data.id).name)
    element.Group_Price.Txt_Num:SetText(string.format("%d%%", math.floor(data.highCoefficient * 100)))
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Information_Group_Manufacture_ScrollGrid_Trade_Group_Item_Group_Item_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  GoldenWeek_Group_Info_Group_Tv_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(DataModel.helpId)
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Tab_Btn_Interview_Click = function(btn, str)
    ShowPanel(1)
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Tab_Btn_Trade_Click = function(btn, str)
    ShowPanel(2)
    DataModel.GetTradData()
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowTradList)
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Trade.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Tab_Btn_Guest_Click = function(btn, str)
    ShowPanel(3)
    DataModel.GetQueatData()
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowQueatList)
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Guest.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  GoldenWeek_Group_Info_Group_Tv_Group_Tab_Btn_Manufacture_Click = function(btn, str)
    ShowPanel(4)
    DataModel.GetManufactureData()
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:SetDataCount(#DataModel.nowManufactureList)
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:RefreshAllElement()
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture.ScrollGrid_Trade.grid.self:MoveToTop()
  end,
  ShowPanel = ShowPanel
}
return ViewFunction
