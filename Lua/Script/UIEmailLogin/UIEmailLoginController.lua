local Controller = {}

function Controller:Login(sEmail, sPassword, cb)
  EmailLoginMsgHelper.ReqEmailLogin(sEmail, sPassword, function(msg)
    self:OnRecvLogin(msg, "email")
    if cb ~= nil then
      cb(msg)
    end
  end)
end

function Controller:OnRecvLogin(msg, logintype)
  if msg.rc and msg.rc ~= "" then
    return
  end
  local accessToken = PlayerData.access_token
  local openId = PlayerData.pid
  local ts = TimeUtil.GetServerTimeStamp()
  local userName = LoginGV.GetUsername()
  EmailLoginHelper.SaveEmailIdList(userName, accessToken, openId, ts, logintype)
end

function Controller:Register(sEmail, sPassword, sCode, cb)
  EmailLoginMsgHelper.ReqEmailRegister(sEmail, sPassword, sCode, cb)
end

function Controller:ChangePassword(sEmail, sPassword, sCode, cb)
  EmailLoginMsgHelper.ReqEmailChangePassword(sEmail, sPassword, sCode, cb)
end

function Controller:GetEmailCode(sEmailAddress, cb)
  EmailLoginMsgHelper.ReqGetEmailSecurityCode(sEmailAddress, cb)
end

function Controller:GoogleLogin(cb)
  SdkLoginHelper.SelectLogin("google", function(msg)
    self:OnRecvLogin(msg, "google")
    if cb ~= nil then
      cb(msg)
    end
  end)
end

return Controller
