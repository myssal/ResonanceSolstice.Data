local View = require("UIOpenRoomSuccess/UIOpenRoomSuccessView")
local DataModel = require("UIOpenRoomSuccess/UIOpenRoomSuccessDataModel")
local ViewFunction = {
  OpenRoomSuccess_Btn_Mask_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end
}
return ViewFunction
