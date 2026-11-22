local View = require("UIQuickSet/UIQuickSetView")
local DataModel = require("UIQuickSet/UIQuickSetDataModel")
local Controller = require("UIQuickSet/UIQuickSetController")
local ViewFunction = {
  QuickSet_Btn_BG_Click = function(btn, str)
  end,
  QuickSet_Img_Mask_StaticGrid_Set_SetGrid = function(element, elementIndex)
    Controller:OnSetTagGird(element, elementIndex)
  end,
  QuickSet_Img_Mask_Img_Bg_Img_Switch_Btn_Click_Click = function(btn, str)
  end,
  QuickSet_Btn_Cancel_Click = function(btn, str)
    View.self:PlayAnimOnce("QuickSetHide", function()
      UIManager:ClosePanel()
    end)
  end,
  QuickSet_Btn_Confirm_Click = function(btn, str)
    View.self:PlayAnimOnce("QuickSetHide", function()
      View.self:Confirm()
      UIManager:ClosePanel()
    end)
  end,
  QuickSet_Img_Mask_Group_Row_Group_Main_Btn_Click_Click = function(btn, str)
  end,
  QuickSet_Img_Mask_Group_Row_Group_Main_Btn_Click_LongPress = function(btn, str)
  end,
  QuickSet_Img_Mask_StaticGrid_Set_Group_Row_Group_Main_Btn_Click_Click = function(btn, str)
  end,
  QuickSet_Img_Mask_StaticGrid_Set_Group_Row_Group_Main_Btn_Click_LongPress = function(btn, str)
    Controller:BeginDrag(tonumber(str))
  end
}
return ViewFunction
