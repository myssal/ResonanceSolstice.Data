local View = require("UIDescentPop/UIDescentPopView")
local DataModel = require("UIDescentPop/UIDescentPopDataModel")
local ViewFunction = {
  DescentPop_Btn_Close_Click = function(btn, str)
    UIManager:CloseTip()
  end,
  DescentPop_Img_Main_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local buffCA = DataModel.buffList[elementIndex]
    element.Img_Main.Img_Icon:SetSprite(buffCA.iconPath)
    element.Img_Main.Txt_Name:SetText(buffCA.name)
    element.Img_Main.Txt_Des:SetText(buffCA.des)
  end
}
return ViewFunction
