local View = require("UISkinPreview/UISkinPreviewView")
local Controller = {}

function Controller:DeserializeView(initParams)
  ComBtnShareComp.InitButton(View.Btn_Share)
end

function Controller:FocusSkinStart()
  self:SetActiveBtnShare(false)
end

function Controller:FocusSkinEnd()
  self:SetActiveBtnShare(true)
end

function Controller:OnBtnShare()
  self:ShareBefore()
  ComBtnShareComp.OnClickShareWithNoneArgs(View.Btn_Share)
  TimerHelper.StartOnce("UISkinPreviewController_OnBtnShare", 0.04, function()
    self:ShareEnd()
  end)
end

function Controller:ShareBefore()
  self:SetActiveCommonTopLeft2(false)
  self:SetActiveBtnShare(false)
  self:TrySetActiveSliderScale(false)
end

function Controller:ShareEnd()
  self:SetActiveCommonTopLeft2(true)
  self:SetActiveBtnShare(true)
  self:TrySetActiveSliderScale(true)
end

function Controller:SetActiveCommonTopLeft2(a)
  View.Group_CommonTopLeft2:SetActive(a)
end

function Controller:SetActiveBtnShare(a)
  ComBtnShareComp.SetActiveButton(a, View.Btn_Share)
end

function Controller:TrySetActiveSliderScale(a)
  if self:IsSpine2() then
    return
  end
  self:SetActiveSliderScale(a)
end

function Controller:SetActiveSliderScale(a)
  View.Img_Bg.Slider_Scale:SetActive(a)
end

function Controller:IsSpine2()
  if self.isSpine2 == nil or type(self.isSpine2) ~= "number" then
    return false
  end
  return self.isSpine2 == 1
end

function Controller:SetIsSpine2(v)
  self.isSpine2 = v
end

return Controller
