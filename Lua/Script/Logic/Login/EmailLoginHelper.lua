local EmailLoginHelper = {}
EmailLoginHelper.IsUseCodeRegister = false
EmailLoginHelper.IsUseCodeChange = true
EmailLoginHelper.JoinCharaterLimit = 64
EmailLoginHelper.LoginCharaterLimit = 64
EmailLoginHelper.ChangePasswordCharaterLimit = 64

function EmailLoginHelper.IsUseEmailLogin()
  if SdkHelper.IsChannelDmm() then
    return false
  end
  local sw = GameSetting.SWEmailLogin
  if sw ~= nil and sw ~= 0 then
    return sw == 1
  end
  if SdkChannelHelper.IsCurJapanOfficial() or SdkChannelHelper.IsCurJPOfficialWeb() then
    return true
  end
  if SdkChannelHelper.IsCurTwOfficial() or SdkChannelHelper.IsCurTwOfficialWeb() then
    return true
  end
  return false
end

function EmailLoginHelper.TryEmailLogin()
  local saveList = EmailLoginHelper.GetEmailIdList()
  if saveList == nil then
    EmailLoginHelper.OpenEmailLoginView()
    return
  end
  local account = saveList[1]
  local loginType = account.logintype
  if loginType == "google" then
    SdkLoginHelper.GoogleLogin(function(msg)
      if msg.rc and msg.rc ~= "" then
        EmailLoginHelper.OpenEmailLoginView()
        CommonTips.OpenTips(msg.msg)
        return
      end
    end)
    return
  end
  PlayerData.access_token = account.access_token or " "
  PlayerData.pid = account.openid or " "
  
  local function cb(msg)
    if msg.rc and msg.rc ~= "" then
      EmailLoginHelper.OpenEmailLoginView()
      CommonTips.OpenTips(msg.msg)
      return
    end
  end
  
  local args = {
    accessToken = PlayerData.access_token,
    username = account.username,
    openId = PlayerData.pid
  }
  LoginHelper.ReqInfoAndIndex(args, cb)
end

function EmailLoginHelper.GetEmailIdList()
  return LoginHelper.GetLoginCacheIdList()
end

function EmailLoginHelper.SaveEmailIdList(username, access_token, openid, lastLoginTs, logintype)
  LoginHelper.SaveLoginCacheIdList(username, access_token, openid, lastLoginTs, logintype)
end

function EmailLoginHelper.Logout()
  LoginHelper.Logout()
  if EmailLoginHelper.IsUseEmailLogin() == false then
    return
  end
  EmailLoginHelper.OpenEmailLoginView()
end

function EmailLoginHelper.OpenEmailLoginView()
  UIManager:Open("UI/Login/EmailLogin")
end

return EmailLoginHelper
