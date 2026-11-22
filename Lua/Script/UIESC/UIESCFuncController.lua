local Controller = {}

function Controller:OnFuncAccountInfo()
  if SdkChannelHelper.IsCurUjoy() then
    UIManager:Open("UI/Login/KoreaAcountInfo")
    return
  elseif SdkHelper.IsUseSdkUserCenter() then
    local uid = PlayerData:GetUserInfo().uid
    local extra = {
      roleid = uid,
      level = PlayerData:GetPlayerLevel()
    }
    local jsonStr = Json.encode(extra)
    SdkHelper.UserCenter(tostring(uid), jsonStr)
    return
  end
  UIManager:Open("UI/Login/AcountInfo")
end

function Controller:OnFuncServices()
  if SdkHelper.TrySdkServices() then
    return
  end
  Debug.Log("[ESCFunc]OnFuncServices")
end

function Controller:OnFuncCommunity()
  if SdkChannelHelper.IsCurUjoy() then
    SdkHelper.Community()
  end
end

function Controller:OnFuncDataLink()
  UIManager:Open("UI/Login/Link_Login/LinkPasswordSet")
end

return Controller
