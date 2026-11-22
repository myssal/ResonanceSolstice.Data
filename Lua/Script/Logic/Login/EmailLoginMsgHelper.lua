local EmailLoginMsgHelper = {}

function EmailLoginMsgHelper.ReqEmailLogin(sEmail, sPassword, cb)
  local phoneLogin = ProtocolFactory:CreateProtocol(ProtocolType.PhoneLogin)
  phoneLogin.username = sEmail
  phoneLogin.password = sPassword
  phoneLogin:SetCallback(function(res2)
    local msg = Json.decode(res2)
    EmailLoginMsgHelper.OnRecvEmailLogin(msg, sEmail, cb)
  end)
  EmailLoginMsgHelper.AddToServerConnectManager(phoneLogin)
end

function EmailLoginMsgHelper.OnRecvEmailLogin(msg, username, cb)
  if msg.rc and msg.rc ~= "" then
    if cb ~= nil then
      cb(msg)
    end
    return
  end
  PlayerData.access_token = msg.access_token
  PlayerData.pid = msg.openid
  LoginGV.SetUsername(username)
  local args = {
    accessToken = msg.access_token,
    username = username,
    openId = PlayerData.pid
  }
  LoginHelper.ReqInfoAndIndex(args, cb)
end

function EmailLoginMsgHelper.ReqEmailRegister(sEmail, sPassword, sCode, cb)
  local phoneRegister = ProtocolFactory:CreateProtocol(ProtocolType.PhoneRegister)
  phoneRegister.username = sEmail
  phoneRegister.code = sCode
  if EmailLoginHelper.IsUseCodeRegister == false then
    phoneRegister.code = "register"
  end
  phoneRegister.password = sPassword
  phoneRegister:SetCallback(function(res2)
    local msg = Json.decode(res2)
    if cb ~= nil then
      cb(msg)
    end
    EmailLoginMsgHelper.OnRecvEmailRegister(msg)
  end)
  EmailLoginMsgHelper.AddToServerConnectManager(phoneRegister)
end

function EmailLoginMsgHelper.OnRecvEmailRegister(msg)
end

function EmailLoginMsgHelper.ReqEmailChangePassword(sEmail, sPassword, sCode, cb)
  local changePassword = ProtocolFactory:CreateProtocol(ProtocolType.ChangePassword)
  changePassword.username = sEmail
  changePassword.code = sCode
  if EmailLoginHelper.IsUseCodeChange == false then
    changePassword.code = "register"
  end
  changePassword.new_password = sPassword
  changePassword:SetCallback(function(res2)
    local msg = Json.decode(res2)
    if cb ~= nil then
      cb(msg)
    end
    EmailLoginMsgHelper.OnRecvEmailChangePassword(msg)
  end)
  EmailLoginMsgHelper.AddToServerConnectManager(changePassword)
end

function EmailLoginMsgHelper.OnRecvEmailChangePassword(msg)
end

function EmailLoginMsgHelper.ReqGetEmailSecurityCode(emailAddress, cb)
  local protocol = ProtocolFactory:CreateProtocol(ProtocolType.GetEmailSecurityCode)
  protocol.addressee = emailAddress
  protocol:SetCallback(function(res2)
    local msg = Json.decode(res2)
    if cb ~= nil then
      cb(msg)
    end
  end)
  EmailLoginMsgHelper.AddToServerConnectManager(protocol)
end

function EmailLoginMsgHelper.AddToServerConnectManager(protocol)
  ServerConnectManager:Add(protocol)
end

return EmailLoginMsgHelper
