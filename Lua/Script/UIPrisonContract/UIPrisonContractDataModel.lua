local View = require("UIPrisonContract/UIPrisonContractView")
local DataModel = {}

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  View.ScrollView_.Viewport.Content.Group_Content1.Txt_:SetText(GetText(80607157))
  View.ScrollView_.Viewport.Content.Group_Content2.Txt_:SetText(GetText(80607158))
  View.Txt_Yifang:SetText(string.format(GetText(80607160), PlayerData:GetUserInfo().role_name))
  local prisonCA = PrisonData.GetPrisonCA()
  View.Group_TradeLv.Txt_Num:SetText(string.format(GetText(80600599), prisonCA.initialTradeLevel))
  local costItem = PlayerData:GetFactoryData(prisonCA.initialPriceItem)
  View.Group_Gold.Txt_Num:SetText(prisonCA.initialPrice)
  View.Group_Gold.Img_:SetSprite(costItem.buyPath)
  View.Btn_Confirm:SetActive(not PrisonData.GetSeverPrisonData())
end

return DataModel
