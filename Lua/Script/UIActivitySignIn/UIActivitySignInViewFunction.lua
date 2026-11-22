local View = require("UIActivitySignIn/UIActivitySignInView")
local Controller = require("UIActivitySignIn/UIActivitySignInController")
local DataModel = require("UIActivitySignIn/UIActivitySignInDataModel")
local ViewFunction = {
  ActivitySignIn_Group_EventSignIn_ScrollGrid_Board_SetGrid = function(element, elementIndex)
    Controller:SignInSetElement(element, elementIndex)
  end,
  ActivitySignIn_Group_EventSignIn_ScrollGrid_Board_Group_Item_Group_Item_BtnPolygon_BG_Click = function(btn, str)
    Controller:SignInClickElement(tonumber(str))
  end,
  ActivitySignIn_Group_EventSignIn_Group_Decorate_Btn_Details_Click = function(btn, str)
  end
}
return ViewFunction
