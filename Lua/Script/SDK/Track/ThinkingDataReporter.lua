local ThinkingDataReporter = {}

function ThinkingDataReporter.GetReporter()
  if CS.MSDKExternSetting.IsUseThinkingData() == false then
    return nil
  end
  local reporter = CS.GameSdkMonoMgr.Instance:GetOneDataReporter("thinkingdata")
  return reporter
end

function ThinkingDataReporter.TrackTDOrder(orderId, payAmount, payType)
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  local tDict = {
    order_id = orderId,
    pay_fee = payAmount,
    currency_type = PayHelper.GetCurrencyTypeStr(),
    pay_type = payType
  }
  local dict = SdkHelper.ConvertTableToDictStrObj(tDict)
  ThinkingDataReporter.Track("init_order", dict)
end

function ThinkingDataReporter.TrackTDBuy(payStatus, orderId, payAmount, productId, productName, currencyType, payType, isFirst)
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  local tDict = {
    order_id = orderId,
    pay_fee = payAmount,
    currency_type = PayHelper.GetCurrencyTypeStr(),
    payment_id = productId,
    payment_name = productName,
    currency_type = currencyType,
    pay_type = payType,
    first_recharge = isFirst or 0
  }
  ThinkingDataReporter.AddCommonProp(tDict)
  local dict = SdkHelper.ConvertTableToDictStrObj(tDict)
  local methodName = ""
  if payStatus == 0 then
    methodName = "payment"
  else
    methodName = "payment_fail"
  end
  ThinkingDataReporter.Track(methodName, dict)
  if payStatus == 0 then
    ThinkingDataReporter.SetUserRechargeInfos(payAmount)
  end
end

function ThinkingDataReporter.TrackTDBuySuccess(orderId, payAmount, productId, productName, currencyType, isFirst)
  ThinkingDataReporter.TrackTDBuy(0, orderId, payAmount, productId, productName, currencyType, isFirst)
end

function ThinkingDataReporter.TrackTDBuyFail(orderId, payAmount, productId, productName, currencyType, isFirst)
  ThinkingDataReporter.TrackTDBuy(1, orderId, payAmount, productId, productName, currencyType, isFirst)
end

function ThinkingDataReporter.TrackTDLogout()
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  reporter:TrackLogout()
end

function ThinkingDataReporter.MakeCommonPropDict()
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return nil
  end
  local userInfo = PlayerData:GetUserInfo()
  local homeInfo = PlayerData:GetHomeInfo()
  if homeInfo == nil or userInfo == nil then
    return nil
  end
  local tDict = {
    [SdkTrackConst.EvtProp.account_uid] = userInfo.uid,
    [SdkTrackConst.EvtProp.trade_lv] = homeInfo.trade_lv or 0,
    [SdkTrackConst.EvtProp.compound_lv] = homeInfo.compound_lv or 0,
    [SdkTrackConst.EvtProp.player_level] = PlayerData:GetPlayerLevel(),
    [SdkTrackConst.EvtProp.prison_level] = PrisonData.GetPrisonLv(),
    [SdkTrackConst.EvtProp.login_day] = PlayerData.ServerData.total_login_num or 0
  }
  local dict = SdkHelper.ConvertTableToDictStrObj(tDict)
  if dict == nil then
    return nil
  end
  return dict
end

function ThinkingDataReporter.AddCommonProp(t)
  if t == nil then
    return
  end
  local userInfo = PlayerData:GetUserInfo()
  local homeInfo = PlayerData:GetHomeInfo()
  if homeInfo == nil or userInfo == nil then
    return nil
  end
  t[SdkTrackConst.EvtProp.account_uid] = userInfo.uid
  t[SdkTrackConst.EvtProp.trade_lv] = homeInfo.trade_lv or 0
  t[SdkTrackConst.EvtProp.compound_lv] = homeInfo.compound_lv or 0
  t[SdkTrackConst.EvtProp.player_level] = PlayerData:GetPlayerLevel()
  t[SdkTrackConst.EvtProp.prison_level] = PrisonData.GetPrisonLv()
  t[SdkTrackConst.EvtProp.login_day] = PlayerData.ServerData.total_login_num or 0
end

function ThinkingDataReporter.TrackBackMainUI()
  local dict = ThinkingDataReporter.MakeCommonPropDict()
  if dict == nil then
    return
  end
  ThinkingDataReporter.Track(SdkTrackConst.EvtName.back_mainui, dict)
end

function ThinkingDataReporter.TrackEnterGame(uid)
  local dict = ThinkingDataReporter.MakeCommonPropDict()
  if dict == nil then
    return
  end
  ThinkingDataReporter.Track(SdkTrackConst.EvtName.enter_game, dict)
  ThinkingDataReporter.OnTrackEnterGame()
end

function ThinkingDataReporter.TrackDataLinkLogin()
  local t = {
    [SdkTrackConst.EvtProp.states] = "success"
  }
  ThinkingDataReporter.TrackWithLuaTable(SdkTrackConst.EvtName.datalink_login, t)
end

function ThinkingDataReporter.Track(methodName, dict)
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  CommonHelper.SafeCallCsFunc(CS.ThinkingData.Analytics.TDAnalytics.Track, methodName, dict)
end

function ThinkingDataReporter.TrackWithLuaTable(methodName, luaT)
  if luaT == nil then
    return
  end
  local dict = SdkHelper.ConvertTableToDictStrObj(luaT)
  ThinkingDataReporter.Track(methodName, dict)
end

function ThinkingDataReporter.SetUserWithLuaTable(luaT)
  if luaT == nil then
    return
  end
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  local dict = SdkHelper.ConvertTableToDictStrObj(luaT)
  CS.ThinkingData.Analytics.TDAnalytics.UserSet(dict)
end

function ThinkingDataReporter.SetUserOnceWithLuaTable(luaT)
  if luaT == nil then
    return
  end
  local reporter = ThinkingDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  local dict = SdkHelper.ConvertTableToDictStrObj(luaT)
  CS.ThinkingData.Analytics.TDAnalytics.UserSetOnce(dict)
end

function ThinkingDataReporter.OnSdkHelperTrackCustom(eventName, luaT)
  if eventName == nil or eventName == "" or luaT == nil then
    return
  end
  if eventName == SdkConst.EvtName.level_up then
    ThinkingDataReporter.SetUserPlayerLevel()
  end
end

function ThinkingDataReporter.OnRegister()
  ThinkingDataReporter.SetUserRegisterTime()
end

function ThinkingDataReporter.SetUserRegisterTime()
  local t = {
    [SdkTrackConst.EvtProp.register_time] = ThinkingDataReporter.GetSvrTimeStr()
  }
  ThinkingDataReporter.SetUserOnceWithLuaTable(t)
end

function ThinkingDataReporter.OnTrackEnterGame()
  ThinkingDataReporter.SetUserChannel2()
  ThinkingDataReporter.SetUserOpenId()
  ThinkingDataReporter.SetUserPlayerLevel()
  ThinkingDataReporter.SetUserLastLoginTime()
  ThinkingDataReporter.SetUserDiamondLeft()
  ThinkingDataReporter.SetUserGoldLeft()
end

function ThinkingDataReporter.GetPlayerLevel()
  if PlayerData.ServerData == nil or PlayerData.ServerData.user_info == nil then
    return 1
  end
  return PlayerData.ServerData.user_info.lv or 1
end

function ThinkingDataReporter.SetUserChannel2()
  local channel2Flag = SdkHelper.GetChannel2Flag()
  if channel2Flag == nil or channel2Flag == "" then
    return
  end
  local t = {
    [SdkTrackConst.EvtProp.channel2] = channel2Flag
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserOpenId()
  local openid = LoginGV.GetViewId()
  if openid == nil or openid == "" then
    return
  end
  local t = {
    [SdkTrackConst.EvtProp.openid] = openid
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserPlayerLevel()
  local lv = ThinkingDataReporter.GetPlayerLevel()
  local t = {
    [SdkTrackConst.EvtProp.player_level] = lv
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserLastLoginTime()
  local t = {
    [SdkTrackConst.EvtProp.last_login_time] = ThinkingDataReporter.GetSvrTimeStr()
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserDiamondLeft()
  local num = PlayerData:GetGoodsById(11400005).num
  local t = {
    [SdkTrackConst.EvtProp.diamond_left] = num
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserGoldLeft()
  local num = PlayerData:GetGoodsById(11400001).num
  local t = {
    [SdkTrackConst.EvtProp.gold_left] = num
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserRechargeInfos(fPayAmount)
  ThinkingDataReporter.SetUserRechargeSum(fPayAmount)
  ThinkingDataReporter.SetUserFirstRechargeTime()
  ThinkingDataReporter.SetUserLastRechargeTime()
end

function ThinkingDataReporter.SetUserRechargeSum(fPayAmount)
  local recharge_sum = ThinkingDataReporter.GetUserInfoRechargeSum()
  if recharge_sum == nil or type(recharge_sum) ~= "number" then
    return
  end
  local add = 0
  if fPayAmount ~= nil and type(fPayAmount) == "number" then
    add = fPayAmount
  end
  local t = {
    [SdkTrackConst.EvtProp.recharge_sum] = recharge_sum + add
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserFirstRechargeTime()
  local recharge_sum = ThinkingDataReporter.GetUserInfoRechargeSum()
  if recharge_sum == nil or type(recharge_sum) ~= "number" or 0 < recharge_sum then
    return
  end
  local strTime = ThinkingDataReporter.GetSvrTimeStr()
  local t = {
    [SdkTrackConst.EvtProp.first_recharge_time] = strTime
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.SetUserLastRechargeTime()
  local t = {
    [SdkTrackConst.EvtProp.last_recharge_time] = ThinkingDataReporter.GetSvrTimeStr()
  }
  ThinkingDataReporter.SetUserWithLuaTable(t)
end

function ThinkingDataReporter.GetSvrTimeStr()
  return os.date("%Y-%m-%d %H:%M:%S", PlayerData:GetSeverTime())
end

function ThinkingDataReporter.GetUserInfo()
  if PlayerData.ServerData == nil then
    return nil
  end
  return PlayerData.ServerData.user_info
end

function ThinkingDataReporter.GetUserInfoRechargeSum()
  local user_info = ThinkingDataReporter.GetUserInfo()
  if user_info == nil then
    return nil
  end
  return user_info.recharge_sum
end

return ThinkingDataReporter
