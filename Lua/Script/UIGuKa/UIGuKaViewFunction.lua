local View = require("UIGuKa/UIGuKaView")
local DataModel = require("UIGuKa/UIGuKaDataModel")
local Controller = require("UIGuKa/UIGuKaController")
local ViewFunction = {
  GuKa_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.CheckBoardNoConflict() then
      Controller:ConfirmPlaceBlock()
      Controller:ReqDecorate(function()
        UIManager:GoBack()
      end)
    else
      CommonTips.OpenWitchPrompt(GetText(80610248), nil, nil, function()
        DataModel.ResetBlock()
        Controller:ReqDecorate(function()
          UIManager:GoBack()
        end)
      end)
    end
  end,
  GuKa_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  GuKa_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  GuKa_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80306727)
  end,
  GuKa_Group_Pack_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetBagBlockElement(element, elementIndex)
  end,
  GuKa_Group_ControlPanel_Btn_PutAway_Click = function(btn, str)
    Controller:RestoreBlock()
  end,
  GuKa_Group_ControlPanel_Btn_OK_Click = function(btn, str)
    Controller:ConfirmPlaceBlock()
  end,
  GuKa_Group_ControlPanel_Btn_Rotate_Click = function(btn, str)
    Controller:RotateBlock()
  end,
  GuKa_Group_Attr_Btn_Attr_Click = function(btn, str)
    Controller:ShowAttrValue()
  end,
  GuKa_Img_Guka_Drag_Move_BeginDrag = function(direction, dragPos)
    DataModel.DragStartPos = dragPos
  end,
  GuKa_Img_Guka_Drag_Move_EndDrag = function(direction, dragPos)
  end,
  GuKa_Img_Guka_Drag_Move_OnDrag = function(direction, dragPos)
    Controller:OnDragBlock(dragPos)
  end,
  GuKa_Group_Pack_ScrollGrid__Group_Item_Group_GuKa_Btn__Click = function(btn, str)
    Controller:ClickGuKaInBag(tonumber(str))
  end,
  GuKa_Group_Panel_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetBoardElement(element, elementIndex)
  end,
  GuKa_Group_Panel_ScrollGrid__Group_Item_Btn__Click = function(btn, str)
    Controller:ClickGuKaInBoard(tonumber(str))
  end
}
return ViewFunction
