local View = require("UIKeepsakeTips/UIKeepsakeTipsView")
local DataModel = require("UIKeepsakeTips/UIKeepsakeTipsDataModel")
local ViewFunction = {
  KeepsakeTips_Btn_BG_Click = function(btn, str)
    UIManager:CloseTip("UI/Common/KeepsakeTips")
  end,
  KeepsakeTips_Group_Show_Btn_Access_Click = function(btn, str)
    local data = {}
    data.itemID = DataModel.Id
    data.posX = 270
    data.posY = -130
    View.Group_Show.Btn_Access.Img_On:SetActive(true)
    UIManager:Open("UI/Common/Group_GetWay", Json.encode(data), function()
      View.Group_Show.Btn_Access.Img_On:SetActive(false)
    end)
  end
}
return ViewFunction
