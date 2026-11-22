local Controller = {}

function Controller:InitElement(element)
  self.goElement = element
  self:RefreshElement()
end

function Controller:RefreshElement()
  local canUse = LinkPasswordSetHelper.IsCanUse()
  if not canUse then
    return
  end
  local val = LinkPasswordSetHelper.GetRedDot()
  if self.goElement == nil then
    return
  end
  self.goElement.Btn_Func.Img_Tip:SetActive(val == 0)
end

function Controller:OnBtnLinkPasswordSet()
  LinkPasswordSetHelper.SetRedDot(1)
  self:RefreshElement()
  UIManager:Open("UI/Login/Link_Login/LinkPasswordSet")
end

return Controller
