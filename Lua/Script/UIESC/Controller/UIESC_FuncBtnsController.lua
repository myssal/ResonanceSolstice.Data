local View = require("UIESC/UIESCView")
local Controller = {}

function Controller:Init()
  self:InitBtnCustomerService()
end

function Controller:GetBtnCustomerService()
  return View.Btn_Friends.Btn_CustomerService
end

function Controller:InitBtnCustomerService()
  local isShow = self:IsKR() or SdkRegionHelper.IsRegionUS()
  if not isShow then
    return
  end
  local Btn_CustomerService = self:GetBtnCustomerService()
  if Btn_CustomerService == nil then
    return
  end
  Btn_CustomerService:SetActive(true)
end

function Controller:OnBtnCustomerService()
  SdkHelper.Services()
end

function Controller:IsKR()
  return SdkRegionHelper.IsRegionKR()
end

return Controller
