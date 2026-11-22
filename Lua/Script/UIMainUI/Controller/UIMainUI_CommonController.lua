local View = require("UIMainUI/UIMainUIView")
local Controller = {}

function Controller:Init()
  self:InitBtnCommunity()
end

function Controller:GetBtnCommunity()
  return View.Group_Common.Btn_Community
end

function Controller:InitBtnCommunity()
  if not self:IsKR() then
    return
  end
  local Btn_Community = self:GetBtnCommunity()
  if Btn_Community == nil then
    return
  end
  Btn_Community:SetActive(true)
end

function Controller:OnBtnCommunity()
  SdkHelper.Community()
end

function Controller:IsKR()
  return SdkRegionHelper.IsRegionKR()
end

return Controller
