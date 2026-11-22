local HarmonyChannelLoginMgr = {}

function HarmonyChannelLoginMgr:SetThirdOpenId(v)
  self.thirdOpenId = v
end

function HarmonyChannelLoginMgr:GetThirdOpenId()
  return self.thirdOpenId or ""
end

function HarmonyChannelLoginMgr:SetTeamPlayerId(v)
  self.teamPlayerId = v
end

function HarmonyChannelLoginMgr:GetTeamPlayerId()
  return self.teamPlayerId or ""
end

function HarmonyChannelLoginMgr:SetLoginType(v)
  self.loginType = v
end

function HarmonyChannelLoginMgr:GetLoginType()
  return self.loginType or ""
end

function HarmonyChannelLoginMgr:IsUseChannelLogin()
  if self:GetLoginType() == "official" then
    return false
  end
  return true
end

function HarmonyChannelLoginMgr:TryHandlerResult(data)
  Debug.Log(string.format("[Login]Login originSdkMsg = %s", data.originSdkMsg))
  local useOfficialLogin = false
  local isExcuteNextLogic = false
  self:SetLoginType("")
  self:SetTeamPlayerId("")
  local msg = Json.decode(data.originSdkMsg)
  local msg1 = msg.unionLoginResult
  local msg2 = msg.authResult
  if data.status == 0 then
    if msg.accountName ~= nil and msg.accountName ~= "" and msg.accountNamee ~= "hw_account" then
      useOfficialLogin = true
      self:SetLoginType("official")
    else
      data.accessToken = msg2.authorizationCode
      local gamePlayerId = msg1.localPlayer.gamePlayerId
      data.uid = gamePlayerId
      data.userName = gamePlayerId
      self:SetTeamPlayerId(gamePlayerId)
    end
  else
    Debug.Log(string.format("[Login]Login originSdkMsg code= %s", msg.code))
    if msg.code ~= nil and msg.code == 1001502012 then
      Debug.Log(string.format("[Login]Login originSdkMsg code= %s equal", msg.code))
      useOfficialLogin = true
    end
  end
  LoginHelper.SetAdministrationsAddictionFeature(useOfficialLogin)
  if useOfficialLogin then
    LoginHelper.SetChannelLoginEnable(false)
    LoginHelper.StartOfficialLogin()
    return true
  end
  if isExcuteNextLogic then
    return false
  end
  return isExcuteNextLogic
end

function HarmonyChannelLoginMgr:BindPlayer()
  local thridOpenId = self:GetThirdOpenId()
  local teamPlayerId = self:GetTeamPlayerId()
  CS.ChannelHarmonyMgr.Instance:BindPlayer(thridOpenId, teamPlayerId)
end

function HarmonyChannelLoginMgr:VerifyCheck()
  CS.ChannelHarmonyMgr.Instance:VerifyCheck(self:GetThirdOpenId())
end

function HarmonyChannelLoginMgr:SavePlayerInfo()
  local info = {
    roleId = PlayerData:GetUserInfo().uid,
    roleName = PlayerData:GetUserInfo().uid,
    serverId = "1",
    serverName = "cn_release",
    teamPlayerId = self:GetTeamPlayerId()
  }
  local jsonStr = Json.encode(info)
  Debug.Log(string.format("[HMS]SavePlayerInfo info=%s", jsonStr))
  CS.ChannelHarmonyMgr.Instance:SavePlayerInfo(jsonStr)
end

function HarmonyChannelLoginMgr:BeforeLogoutInLogin()
  LoginHelper.SetChannelLoginEnable(true)
  PlayerPrefs.SetInt("IsAgree", 0)
end

function HarmonyChannelLoginMgr:BeforeLoginInit()
  local showLoginDialog = self:GetPlayerPrefs("show_login_dialog")
  if showLoginDialog == "false" then
    local loginType = self:GetPlayerPrefs("login_type")
    self:SetLoginType(loginType)
    if loginType == "official" then
      LoginHelper.SetChannelLoginEnable(false)
    end
  end
end

function HarmonyChannelLoginMgr:BeforeSendIndex(send, context)
  if context == "oc" then
    send.teamPlayerId = self:GetTeamPlayerId()
    send.platform = "oc"
  else
    send.openId = self:GetTeamPlayerId()
  end
end

function HarmonyChannelLoginMgr:AfterRecvIndex(msg, context)
  if msg == nil then
    return
  end
  if self:GetLoginType() == "official" then
    LoginHelper.SetChannelLoginEnable(false)
    self:SetPlayerPrefs("show_login_dialog", "false")
    self:SetPlayerPrefs("login_type", "official")
  elseif context == "channel" then
    self:SetThirdOpenId(msg.third_openid)
    if msg.third_openid == "1" then
      PlayerPrefs.SetString("PhoneIDList", "")
      LoginHelper.SetChannelLoginEnable(false)
      LoginHelper.StartOfficialLogin()
    else
      self:SetPlayerPrefs("show_login_dialog", "false")
      self:BindPlayer()
    end
  else
    self:SetThirdOpenId(msg.pid)
    self:SetPlayerPrefs("show_login_dialog", "false")
    LoginHelper.SetSelectPrivacy(true)
    self:BindPlayer()
  end
end

function HarmonyChannelLoginMgr:TryLogoutInLoginScene()
end

function HarmonyChannelLoginMgr:TryLogoutInGameScene()
end

function HarmonyChannelLoginMgr:AfterLogoutInLoginScene()
  self:SetLoginType("")
  self:SetPlayerPrefs("show_login_dialog", "")
  self:SetPlayerPrefs("login_type", "")
  LoginHelper.ClickLoginBtnEnter()
end

function HarmonyChannelLoginMgr:AfterLogoutInGameScene()
end

function HarmonyChannelLoginMgr:OnRecvMainIndex()
  self:VerifyCheck()
  self:SavePlayerInfo()
end

function HarmonyChannelLoginMgr:SetPlayerPrefs(key, value)
  PlayerPrefs.SetString("hmos_" .. key, value)
end

function HarmonyChannelLoginMgr:GetPlayerPrefs(key)
  return PlayerPrefs.GetString("hmos_" .. key) or ""
end

return HarmonyChannelLoginMgr
