local SdkLoginHelper = {}

function SdkLoginHelper.SelectLogin(sLoginType, fCallback)
  CS.GameSdkLuaface.SelectLogin(sLoginType, function(jsonStr)
    Debug.Log("[GoogleLogin]SdkLoginHelper.SelectLogin jsonStr=" .. jsonStr)
    SdkLoginHelper.OnSelectLogin(jsonStr, fCallback)
  end)
end

function SdkLoginHelper.OnSelectLogin(jsonStr, fCallback)
  Debug.Log("[Login]SdkLoginHelper.OnSelectLogin jsonStr=" .. jsonStr)
  local data = Json.decode(jsonStr)
  if data == nil or data.Status ~= 0 then
    return
  end
  LoginGV.SetAccessToken(data.AccessToken)
  LoginGV.SetUsername(data.UserName)
  LoginGV.SetIsLogin(true)
  local args = {
    accessToken = data.AccessToken,
    username = data.UserName,
    platform = "gp"
  }
  LoginHelper.ReqInfoAndIndex(args, function(json)
    Debug.Log("[Login]SdkLoginHelper.OnReqInfoAndIndex jsonStr=" .. jsonStr)
    if fCallback ~= nil then
      fCallback(json)
    end
  end)
end

function SdkLoginHelper.SelectLogout(sLoginType)
  CS.GameSdkLuaface.SelectLogout(sLoginType)
end

function SdkLoginHelper.GoogleLogin(cb)
  SdkLoginHelper.SelectLogin("google", function(msg)
    if cb ~= nil then
      cb(msg)
    end
  end)
end

return SdkLoginHelper
