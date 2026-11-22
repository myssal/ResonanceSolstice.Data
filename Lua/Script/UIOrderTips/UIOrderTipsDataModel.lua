local View = require("UIOrderTips/UIOrderTipsView")
local CommonItem = require("Common/BtnItem")
local DataModel = {
  ItemId = 0,
  NeedNum = 0,
  OrderUId = "",
  CurNum = 0,
  MinNum = 0,
  MaxNum = 0
}

function DataModel.Init()
  local haveNum = PlayerData:GetGoodsById(DataModel.ItemId).num
  DataModel.MaxNum = math.min(DataModel.NeedNum, haveNum)
  DataModel.MinNum = 0
  CommonItem:SetItem(View.Group_Item, {
    id = DataModel.ItemId
  })
  View.Group_Slider.Slider_Value:SetMinAndMaxValue(1, DataModel.MaxNum)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.05))
    DataModel.CurNum = DataModel.MaxNum
    View.Group_Slider.Slider_Value:SetSliderValue(DataModel.CurNum)
  end))
end

function DataModel.RefreshPanel()
  View.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.CurNum)
  View.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.MaxNum)
  DataModel.SetSlider()
end

function DataModel.SetSlider()
  View.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.CurNum)
  View.Group_Slider.Group_Num.Txt_Possess:SetText(DataModel.MaxNum)
  View.Group_Slider.Slider_Value:SetSliderValue(DataModel.CurNum)
end

return DataModel
