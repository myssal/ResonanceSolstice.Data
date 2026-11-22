local ViewController = {}
local View = require("UIEmailLogin/UIEmailLoginView")
local Controller = require("UIEmailLogin/UIEmailLoginController")
local Timer = require("Common/Timer")

function ViewController:ResetProps()
  self.COUNT_EMAIL_CODE = 60
  self.counterEmailCode = 0
  self.isShowBtnForgetPassword = false
  self.isToggleUserAgreement = false
  self.urlUserAgreement = "https://www.rzns.jp/terms/"
  self.urlPrivacy = "https://www.rzns.jp/privacy/"
  self.urlTwAccountRebinding = "https://tc.soli-reso.com?ingame=1"
  if SdkRegionHelper.IsRegionTW() then
    self.urlUserAgreement = "https://tc.soli-reso.com/terms/"
    self.urlPrivacy = "https://tc.soli-reso.com/privacy/"
  end
end

function ViewController:DeserializeView()
  self:ResetProps()
end

function ViewController:AwakeView()
  self:ResetProps()
  self.timerEmailCode = Timer.New(1, function()
    self:UpdateTimerEmailCode()
  end)
  ViewController:SwitchPanelLogin()
  View.Group_NewLoginAndJoin.Btn_Close:SetActive(false)
  View.Group_NewLoginAndJoin.Group_Login.Btn_Back:SetActive(false)
  View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:ShowPassword(false)
  View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:SetCharacterLimit(EmailLoginHelper.LoginCharaterLimit)
  View.Group_NewLoginAndJoin.Group_Join.InputField_PassWord:SetCharacterLimit(EmailLoginHelper.JoinCharaterLimit)
  View.Group_NewLoginAndJoin.Group_Join.InputField_CheckPassWord:SetCharacterLimit(EmailLoginHelper.JoinCharaterLimit)
  View.Group_NewLoginAndJoin.Group_Change.InputField_CheckPassWord:SetCharacterLimit(EmailLoginHelper.ChangePasswordCharaterLimit)
  View.Group_NewLoginAndJoin.Group_Change.InputField_PassWord:SetCharacterLimit(EmailLoginHelper.ChangePasswordCharaterLimit)
  local useCodeRegister = EmailLoginHelper.IsUseCodeRegister
  View.Group_NewLoginAndJoin.Group_Join.InputField_Code:SetActive(useCodeRegister)
  View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode:SetActive(useCodeRegister)
  local useCodeChange = EmailLoginHelper.IsUseCodeChange
  View.Group_NewLoginAndJoin.Group_Change.InputField_Code:SetActive(useCodeChange)
  View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode:SetActive(useCodeChange)
  View.Group_NewLoginAndJoin.Group_Login.Btn_Forget:SetActive(self.isShowBtnForgetPassword)
  if SdkRegionHelper.IsRegionTW() then
    View.Group_NewLoginAndJoin.Group_Login.Btn_Forget:SetActive(true)
    View.Group_NewLoginAndJoin.Group_Login.Btn_Forget.Txt_:SetText("\232\128\129\231\142\169\229\174\182\231\153\187\229\133\165")
  end
end

function ViewController:UpdateView()
  if self.counterEmailCode >= 0 then
    self.timerEmailCode:Update()
  end
end

function ViewController:CloseView()
  View.self:CloseUI()
end

function ViewController:StartTimerEmailCode()
  self.counterEmailCode = self.COUNT_EMAIL_CODE
  self.timerEmailCode:Start()
  self:SetViewsGetCodeDisable()
end

function ViewController:UpdateTimerEmailCode()
  self.counterEmailCode = self.counterEmailCode - 1
  if self.counterEmailCode < 0 then
    self.timerEmailCode:Pause()
    self:SetViewsGetCodeEnable()
    return
  end
  View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode.Txt_Count:SetText(self.counterEmailCode)
  View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode.Txt_Count:SetText(self.counterEmailCode)
end

function ViewController:SetViewsGetCodeEnable()
  if EmailLoginHelper.IsUseCodeRegister then
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode.Txt_Get:SetActive(true)
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode.Txt_Count:SetActive(false)
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode:SetBtnInteractable(true)
  end
  if EmailLoginHelper.IsUseCodeChange then
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode.Txt_Get:SetActive(true)
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode.Txt_Count:SetActive(false)
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode:SetBtnInteractable(true)
  end
end

function ViewController:SetViewsGetCodeDisable()
  if EmailLoginHelper.IsUseCodeRegister then
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode.Txt_Get:SetActive(false)
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode.Txt_Count:SetActive(true)
    View.Group_NewLoginAndJoin.Group_Join.Btn_GetCode:SetBtnInteractable(false)
  end
  if EmailLoginHelper.IsUseCodeChange then
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode.Txt_Get:SetActive(false)
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode.Txt_Count:SetActive(true)
    View.Group_NewLoginAndJoin.Group_Change.Btn_GetCode:SetBtnInteractable(false)
  end
end

function ViewController:PopTips(tipsId, iscontent)
  View.Btn_Tips3:SetActive(true)
  local content = iscontent and tipsId or GetText(tipsId)
  View.Btn_Tips3.Img_BG.Txt_Warm:SetText(content)
  local width = View.Btn_Tips3.Img_BG.Txt_Warm:GetWidth()
  View.Btn_Tips3.Img_BG.Txt_Warm:SetWidth(width)
end

function ViewController:HideTips()
  View.Btn_Tips3:SetActive(false)
end

function ViewController:SwitchPanelLogin(sEmail, sPassword)
  self:SwitchPanel(1)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG:SetActive(true)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG2:SetActive(false)
  if sEmail ~= nil then
    View.Group_NewLoginAndJoin.Group_Login.InputField_Account:SetText(sEmail)
  end
  if sPassword ~= nil then
    View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:SetText(sPassword)
  end
end

function ViewController:SwitchPanelRegister()
  self:SwitchPanel(2)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG:SetActive(false)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG2:SetActive(true)
end

function ViewController:SwitchPanelChangePassword()
  self:SwitchPanel(3)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG:SetActive(false)
  View.Group_NewLoginAndJoin.Img_BG.Img_BG2:SetActive(true)
end

function ViewController:SwitchPanel(panelType)
  local strEmpty = ""
  View.Group_NewLoginAndJoin.Group_Login:SetActive(panelType == 1)
  View.Group_NewLoginAndJoin.Group_Login.InputField_Account:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Join:SetActive(panelType == 2)
  View.Group_NewLoginAndJoin.Group_Join.InputField_Account:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Join.InputField_PassWord:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Join.InputField_CheckPassWord:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Join.InputField_Code:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Join.Group_Toggle.Btn_toggle.Img_On:SetActive(false)
  self.isToggleUserAgreement = false
  View.Group_NewLoginAndJoin.Group_Change:SetActive(panelType == 3)
  View.Group_NewLoginAndJoin.Group_Change.InputField_Account:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Change.InputField_PassWord:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Change.InputField_CheckPassWord:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Change.InputField_Code:SetText(strEmpty)
  View.Group_NewLoginAndJoin.Group_Switch:SetActive(false)
end

function ViewController:SwitchLoginPasswordShow()
  local isShow = View.Group_NewLoginAndJoin.Group_Login.Btn_ShowandHide.Img_Show.IsActive == false
  View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:ShowPassword(isShow)
  View.Group_NewLoginAndJoin.Group_Login.Btn_ShowandHide.Img_Hide:SetActive(not isShow)
  View.Group_NewLoginAndJoin.Group_Login.Btn_ShowandHide.Img_Show:SetActive(isShow)
end

function ViewController:GetEmailCodeForRegister()
  local address = View.Group_NewLoginAndJoin.Group_Join.InputField_Account:GetText()
  Controller:GetEmailCode(address, function(msg)
    self:OnGetEmailCodeCallback(msg)
  end)
  self:StartTimerEmailCode()
end

function ViewController:OnGetEmailCodeCallback(msg)
  if msg.rc and msg.rc ~= "" then
    self:PopTips(msg.msg, true)
    return
  end
end

function ViewController:GetEmailCodeForChangePassword()
  local address = View.Group_NewLoginAndJoin.Group_Change.InputField_Account:GetText()
  Controller:GetEmailCode(address)
  self:StartTimerEmailCode()
end

function ViewController:Login()
  local email = View.Group_NewLoginAndJoin.Group_Login.InputField_Account:GetText()
  local password = View.Group_NewLoginAndJoin.Group_Login.InputField_PassWord:GetText()
  PlayerData.ShowCMD(email)
  if self:CheckEmailFormat(email) == false then
    return
  end
  if self:CheckPasswordFormat(password) == false then
    return
  end
  Controller:Login(email, password, function(msg)
    self:OnLoginCallback(msg)
  end)
end

function ViewController:GoogleLogin()
  Controller:GoogleLogin(function(msg)
    self:OnLoginCallback(msg)
  end)
end

function ViewController:OnLoginCallback(msg)
  if msg.rc and msg.rc ~= "" then
    self:PopTips(msg.msg, true)
    return
  end
  self:CloseView()
end

function ViewController:Register()
  local email = View.Group_NewLoginAndJoin.Group_Join.InputField_Account:GetText()
  local password = View.Group_NewLoginAndJoin.Group_Join.InputField_PassWord:GetText()
  local passwordCheck = View.Group_NewLoginAndJoin.Group_Join.InputField_CheckPassWord:GetText()
  local code = View.Group_NewLoginAndJoin.Group_Join.InputField_Code:GetText()
  if self:CheckAgreeUserPrivacy() == false then
    return
  end
  if self:CheckEmailFormat(email) == false then
    return
  end
  if self:CheckPasswordFormat(password) == false then
    return
  end
  if self:CheckPasswordTwice(password, passwordCheck) == false then
    return
  end
  if EmailLoginHelper.IsUseCodeRegister and self:CheckCode(code) == false then
    return
  end
  Controller:Register(email, password, code, function(msg)
    self:OnRegisterCallback(msg, email, password)
  end)
end

function ViewController:OnRegisterCallback(msg, email, password)
  if msg.rc and msg.rc ~= "" then
    self:PopTips(msg.msg, true)
    return
  end
  self:PopTips(80607542)
  self:SwitchPanelLogin(email, password)
end

function ViewController:ChangePassword()
  local email = View.Group_NewLoginAndJoin.Group_Change.InputField_Account:GetText()
  local password = View.Group_NewLoginAndJoin.Group_Change.InputField_PassWord:GetText()
  local passwordCheck = View.Group_NewLoginAndJoin.Group_Change.InputField_CheckPassWord:GetText()
  local code = View.Group_NewLoginAndJoin.Group_Change.InputField_Code:GetText()
  if self:CheckEmailFormat(email) == false then
    return
  end
  if self:CheckPasswordFormat(password) == false then
    return
  end
  if self:CheckPasswordTwice(password, passwordCheck) == false then
    return
  end
  if EmailLoginHelper.IsUseCodeChange and self:CheckCode(code) == false then
    return
  end
  Controller:ChangePassword(email, password, code, function(msg)
    self:OnChangePasswordCallback(msg, email, password)
  end)
end

function ViewController:OnChangePasswordCallback(msg, sEmail, sPassword)
  if msg.rc and msg.rc ~= "" then
    self:PopTips(msg.msg, true)
    return
  end
  self:PopTips(80601993)
  self:SwitchPanelLogin(sEmail, sPassword)
end

function ViewController:CheckAgreeUserPrivacy()
  if self.isToggleUserAgreement == false then
    self:PopTips(80608885)
    return false
  end
  return true
end

function ViewController:CheckEmailFormat(sEmail)
  if string.nilorempty(sEmail) then
    self:PopTips(80607541)
    return false
  end
  return true
end

function ViewController:CheckPasswordFormat(sEmail)
  if string.nilorempty(sEmail) then
    self:PopTips(80607545)
    return false
  end
  return true
end

function ViewController:CheckPasswordTwice(p1, p2)
  if p1 ~= p2 then
    self:PopTips(80607544)
    return false
  end
  return true
end

function ViewController:CheckCode(sCode)
  if string.nilorempty(sCode) then
    self:PopTips(80601832)
    return false
  end
  return true
end

function ViewController:TipPasswordChangeSuccess()
  self:PopTips(80601993)
end

function ViewController:TipRegisterSuccess()
  self:PopTips(80607542)
end

function ViewController:OnToggleUserAgreement()
  self.isToggleUserAgreement = not self.isToggleUserAgreement
  View.Group_NewLoginAndJoin.Group_Join.Group_Toggle.Btn_toggle.Img_On:SetActive(self.isToggleUserAgreement)
end

function ViewController:OnBtnUserAgreement()
  CS.UnityEngine.Application.OpenURL(self.urlUserAgreement or "")
end

function ViewController:OnBtnPrivacy()
  CS.UnityEngine.Application.OpenURL(self.urlPrivacy or "")
end

function ViewController:OnGroupLoginBtnForgetClick()
  if SdkRegionHelper.IsRegionTW() then
    ApplicationHelper.OpenUrl(self.urlTwAccountRebinding or "")
    return
  end
  self:SwitchPanelChangePassword()
end

return ViewController
