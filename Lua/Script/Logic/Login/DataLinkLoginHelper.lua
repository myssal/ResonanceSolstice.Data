local DataLinkLoginHelper = {}
DataLinkLoginHelper.IsShowDataLink = true

function DataLinkLoginHelper.IsUseDataLinkLogin()
  local isJp = SdkRegionHelper.IsRegionJP()
  local isCn = SdkRegionHelper.IsRegionCN()
  local isRegionOK = isCn or isJp
  if not isRegionOK then
    return false
  end
  if SdkHelper.IsChannelDmm() then
    return false
  end
  local ret = LoginHelper.LoginCacheIdListFirstLoginTypeIsDataLink()
  return ret
end

function DataLinkLoginHelper.TryAutoDataLinkLoginNormal()
  local cache = LoginHelper.GetLoginCacheIdListFirst()
  DataLinkLoginHelper.ReqInfoAndIndex(cache.access_token or " ", cache.openid or " ", cache.username)
end

function DataLinkLoginHelper.TryAutoDataLinkLoginInDMM()
  if DataLinkLoginHelper.CanAutoLoginInDMM() == false then
    return
  end
  local viewid = LoginGV.GetViewId()
  local data = DataLinkLoginHelper.GetOneDataLinkCacheWithViewerId(viewid)
  DataLinkLoginHelper.ReqInfoAndIndex(data.accessToken or " ", data.pid or " ", data.linkCode)
end

function DataLinkLoginHelper.CanAutoLoginInDMM()
  if SdkHelper.IsChannelDmm() == false then
    return false
  end
  local viewid = LoginGV.GetViewId()
  local data = DataLinkLoginHelper.GetOneDataLinkCacheWithViewerId(viewid)
  if data == nil then
    return false
  end
  return true
end

function DataLinkLoginHelper.ReqInfoAndIndex(accessToken, cacheOpenid, username)
  LoginGV.SetIsLogin(false)
  PlayerData.access_token = accessToken
  PlayerData.pid = cacheOpenid
  local args = {
    accessToken = PlayerData.access_token,
    openId = PlayerData.pid,
    username = username,
    platform = "oc"
  }
  
  local function callback(json)
    if json.rc and json.rc ~= "" then
      LoginHelper.DeleteLoginCacheIdList()
      return
    end
    LoginGV.SetIsLogin(true)
    DataLinkLoginHelper.OnRecvInfoAndIndex()
  end
  
  LoginHelper.ReqInfoAndIndex(args, callback)
end

function DataLinkLoginHelper.TryDataLinkLogin(username, password, cb)
  if username == nil or password == nil then
    return
  end
  local username1 = username
  local password1 = password
  local login = ProtocolFactory:CreateProtocol(ProtocolType.Login)
  login.username = username1
  login.password = password1
  if SdkHelper.IsChannelDmm() then
    login.username = LoginGV.GetViewId() .. "=;" .. username
  end
  login:SetCallback(function(res2)
    local json2 = Json.decode(res2)
    if json2.rc and json2.rc ~= "" then
      CommonTips.OpenTips(json2.msg)
      return
    end
    PlayerData.access_token = json2.access_token
    PlayerData.pid = json2.openid
    local args = {
      accessToken = PlayerData.access_token,
      openId = PlayerData.pid,
      username = username1,
      platform = "oc"
    }
    
    local function callback(json)
      if cb ~= nil then
        cb(json)
      end
      if json.rc and json.rc ~= "" then
        return
      end
      local accessToken = PlayerData.access_token
      local openId = PlayerData.pid
      local ts = TimeUtil.GetServerTimeStamp()
      local userName = username1
      local viewid = LoginGV.GetViewId()
      DataLinkLoginHelper.SaveDataLinkCache(username1, viewid, accessToken, openId)
      LoginHelper.SaveLoginCacheIdList(userName, accessToken, openId, ts, "datalink", viewid)
      DataLinkLoginHelper.OnRecvInfoAndIndex()
    end
    
    LoginHelper.ReqInfoAndIndex(args, callback)
  end)
  ServerConnectManager:Add(login)
end

function DataLinkLoginHelper.OnRecvInfoAndIndex()
  ThinkingDataReporter.TrackDataLinkLogin()
end

function DataLinkLoginHelper.DataLinkLogout()
  LoginHelper.DeleteLoginCacheIdList()
end

function DataLinkLoginHelper.SaveDataLinkCache(strLinkCode, strViewerId, accessToken, pid)
  if SdkHelper.IsChannelDmm() == false then
    return
  end
  local row = {
    linkCode = strLinkCode,
    viewerId = strViewerId or "0",
    accessToken = accessToken or "0",
    pid = pid or "0"
  }
  local datas = DataLinkLoginHelper.GetDataLinkCache()
  if datas == nil then
    datas = {}
    datas[1] = row
  else
    local num = #datas
    for i = 1, #datas do
      local data = datas[i]
      if data ~= nil and data.linkCode == strLinkCode then
        table.remove(datas, i)
      end
    end
    local index = table.count(datas)
    datas[index + 1] = row
  end
  PlayerPrefs.SetString("DataLinkCache", Json.encode(datas))
end

function DataLinkLoginHelper.DeleteDataLinkCache()
  if PlayerPrefs.HasKey("DataLinkCache") == true then
    PlayerPrefs.DeleteKey("DataLinkCache")
  end
end

function DataLinkLoginHelper.GetDataLinkCache()
  local saveStr = PlayerPrefs.GetString("DataLinkCache")
  if saveStr == nil or saveStr == "" then
    return nil
  end
  return Json.decode(saveStr)
end

function DataLinkLoginHelper.GetFirstCache()
  local saveList = DataLinkLoginHelper.GetDataLinkCache()
  if saveList == nil then
    return nil
  end
  local firstCache = saveList[1]
  return firstCache
end

function DataLinkLoginHelper.GetOneDataLinkCacheWithViewerId(strViewerId)
  local datas = DataLinkLoginHelper.GetDataLinkCache()
  if datas == nil then
    return nil
  end
  for i = 1, #datas do
    local data = datas[i]
    if data ~= nil and data.viewerId == strViewerId then
      return data
    end
  end
  return nil
end

return DataLinkLoginHelper
