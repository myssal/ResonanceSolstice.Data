local View = require("UITokenPayTips/UITokenPayTipsView")
local ViewController = {}

function ViewController:DeserializeView(initParams)
  local data = Json.decode(initParams)
  self.data = data
  self.name = data.name
  self.price = data.price
  self.payAmount = data.payAmount
  local nowWCoinNum = OfficialWebCoinPayHelper.GetNowWCoinAmount()
  local iNowWCoinNum = math.floor(nowWCoinNum) or 0
  local ratio = OfficialWebCoinPayHelper.GetCoinRatio()
  View.Group_Top.Txt_Name:SetText(self.name)
  View.Group_Top.Txt_Price:SetText(self.price)
  View.Img_Num.Txt_Num:SetText(iNowWCoinNum)
  local actualPayAmount = self.payAmount * ratio
  if GameSetting.fromRes == "EN" then
    actualPayAmount = math.floor(self.payAmount * ratio + 0.5)
  end
  local tipStr = string.format(GetText(80608780), actualPayAmount)
  View.Txt_Tips:SetText(tipStr)
end

function ViewController:OK()
  View.self:CloseUI()
  View.self:Confirm()
end

function ViewController:Cancel()
  View.self:CloseUI()
  View.self:Cancel()
end

return ViewController
