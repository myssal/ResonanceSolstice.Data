local View = require("UICardYard/UICardYardView")
local DataModel = require("UICardYard/UICardYardDataModel")
local module = {}

function module.RefreshUI()
  View.Btn_CardYard.Group_Off.Txt_Num:SetText(DataModel.DeckCount)
  View.Btn_CardYard.Img_On.Txt_Num:SetText(DataModel.DeckCount)
  View.Btn_CardCemetery.Group_Off.Txt_Num:SetText(DataModel.GraveyardCount)
  View.Btn_CardCemetery.Img_On.Txt_Num:SetText(DataModel.GraveyardCount)
end

return module
