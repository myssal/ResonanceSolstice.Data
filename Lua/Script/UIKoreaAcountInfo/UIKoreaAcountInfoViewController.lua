local View = require("UIKoreaAcountInfo/UIKoreaAcountInfoView")
local ViewController = {}

function ViewController:InitView()
  View.Group_NewLoginAndJoin.Img_BG.Img_BG.Img_Logo:SetSprite(GetResPath(88300030))
  View.Group_NewLoginAndJoin.Group_Main.Group_Toggle.Btn_toggle:SetActive(false)
  local isShowBtnBind = self:IsShowBtnBind()
  View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd:SetActive(isShowBtnBind)
  View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd.Img_Tip:SetActive(isShowBtnBind)
  
  local function cbBindSuccess()
    View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd:SetActive(false)
    View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd.Img_Tip:SetActive(false)
    EscUserCenterHelper.OnBindAccountSuccess()
  end
  
  CS.GameSdkMonoMgr.Instance._lfBindSuccess = cbBindSuccess
  local isUS = SdkRegionHelper.IsRegionUS()
  if isUS then
    View.Group_NewLoginAndJoin.Group_Main.Group_Toggle:SetActive(false)
  end
end

function ViewController:DestroyView()
  CS.GameSdkMonoMgr.Instance._lfBindSuccess = nil
  SdkHelper.ClearLogoutCallback()
end

function ViewController:IsShowBtnBind()
  local isVisitor = ChannelUJoyHelper.IsLoginTypeVisitor()
  if isVisitor then
    return true
  end
  return false
end

function ViewController:OnBtnUserCenter()
  local function onLogout()
    if PlatformHelper.IsPC() then
      LogoutHelper.LogoutFromSdk()
      
      return
    end
    LogoutHelper.LogoutFromGaming()
  end
  
  SdkHelper.SetLogoutCallback(onLogout)
  SdkHelper.UserCenter("", "")
end

function ViewController:OnBtnBindAccount()
  local function cbBindSuccess()
    View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd:SetActive(false)
    
    View.Group_NewLoginAndJoin.Group_Main.Group_Btn.Btn_bd.Img_Tip:SetActive(false)
    EscUserCenterHelper.OnBindAccountSuccess()
  end
  
  SdkHelper.BindAccount(cbBindSuccess)
end

function ViewController:OnBtnLogout()
  CommonTips.OnPrompt(80600797, nil, nil, function()
    HasAddGloableTrainUpdate = nil
    local TimerHelper = require("Common/Timer/TimerHelper")
    TimerHelper.Stop("TrainGloableUpdate")
    TimerHelper.Stop("TrainWheelUpdate")
    SdkHelper.TryLogout()
    PlayerData:Logout()
  end)
end

function ViewController:OnBtnUserAgreement()
  local url = "https://useragreement-kr.ujoygames.co.kr/"
  ApplicationHelper.OpenUrl(url)
end

function ViewController:OnBtnPrivacy()
  local url = "https://privacypolicy-kr.ujoygames.co.kr/"
  ApplicationHelper.OpenUrl(url)
end

function ViewController:OnBtnClose()
  View.self:CloseUI()
end

return ViewController
