local View = require("UIJapanPay/UIJapanPayView")
local ViewController = {}

function ViewController:DeserializeView(initParams)
  if Net.overseas_priority_ocweb_recharge_pop == 0 then
    self:OnBtnCancel()
    return
  end
  local data = Json.decode(initParams)
  self.name = data.name
  self.price = data.price
  View.Txt_Name:SetText(self.name)
  View.Txt_cost:SetText(self.price)
  View.Txt_Name:SetText(self.name)
  if not PlatformHelper.IsIPhone() then
    View.Group_PayWay.Group_apple:SetActive(false)
  else
    View.Group_PayWay.Group_google2.Txt_:SetText("APPLE STORE")
  end
  self.lastPType = self:GetLastPType()
  self:TogglePType(self.lastPType)
end

function ViewController:OnBtnConfirm()
  View.self:CloseUI()
  PlayerData:SetPlayerPrefs("string", "UIJapanPayType", self.lastPType)
  if self.lastPType == "native" then
    View.self:Cancel()
  else
    OfficialWebPayHelper.SetPayType(self.lastPType)
    View.self:Confirm()
  end
end

function ViewController:OnBtnCancel()
  View.self:CloseUI()
  View.self:Cancel()
end

function ViewController:OnBtnCard()
  self:TogglePType(OfficialWebPayHelper.PTYPE_CARD)
end

function ViewController:OnBtnGoogle()
  self:TogglePType(OfficialWebPayHelper.PTYPE_GOOGLE)
end

function ViewController:OnBtnApple()
  self:TogglePType(OfficialWebPayHelper.PTYPE_APPLE)
end

function ViewController:OnBtnNative()
  self:TogglePType("native")
end

function ViewController:TogglePType(ptype)
  if ptype == nil then
    return
  end
  self.lastPType = ptype
  View.Group_PayWay.Group_visa.Img_On:SetActive(ptype == OfficialWebPayHelper.PTYPE_CARD)
  View.Group_PayWay.Group_apple.Img_On:SetActive(ptype == OfficialWebPayHelper.PTYPE_APPLE)
  View.Group_PayWay.Group_google1.Img_On:SetActive(ptype == OfficialWebPayHelper.PTYPE_GOOGLE)
  View.Group_PayWay.Group_google2.Img_On:SetActive(ptype == "native")
end

function ViewController:GetLastPType()
  if self.lastPType == nil then
    local saveLastType = PlayerData:GetPlayerPrefs("string", "UIJapanPayType", self.lastPType)
    if saveLastType ~= nil and saveLastType ~= "" then
      return saveLastType
    end
    return OfficialWebPayHelper.PTYPE_CARD
  else
    return self.lastPType
  end
end

function ViewController:SetLastPType(ptype)
  self.lastPType = ptype
end

return ViewController
