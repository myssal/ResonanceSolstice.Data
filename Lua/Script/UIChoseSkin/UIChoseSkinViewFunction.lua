local CommonItem = require("Common/BtnItem")
local View = require("UIChoseSkin/UIChoseSkinView")
local Controller = require("UIChoseSkin/UIChoseSkinController")
local DataModel = require("UIChoseSkin/UIChoseSkinDataModel")
local ViewFunction = {
  ChoseSkin_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ChoseSkin_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ChoseSkin_Btn_Sale_Click = function(btn, str)
    local data = DataModel.CurrentData
    if data.SkinType == DataModel.EnumSkinType.CarSkin and data.isHave then
      CommonTips.OpenTips(GetText(80611334))
      return
    end
    UIManager:Open("UI/Common/ChoseSkin/ChoseSkinTip", Json.encode({
      id = data.skin,
      img = data.skinshow,
      free = data.skinfree,
      isHave = data.isHave,
      itemId = DataModel.ItemId,
      index = DataModel.ChooseIndex
    }))
  end,
  ChoseSkin_Group_Show_Btn_Check_Click = function(btn, str)
  end,
  ChoseSkin_ScrollGrid_List_SetGrid = function(element, elementIndex)
  end,
  ChoseSkin_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  ChoseSkin_Group_SkinCho_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:SetElement(element, elementIndex)
  end,
  ChoseSkin_Group_SkinCho_ScrollGrid_List_Group_Item_Btn__Click = function(btn, str)
    Controller:ClickSkin(tonumber(str))
  end
}
return ViewFunction
