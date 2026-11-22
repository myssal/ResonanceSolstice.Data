local AdjustDataReporter = {}
AdjustDataReporter.TokenPay = "ecad35"
AdjustDataReporter.TokenBattleWin = "jn8tmo"
AdjustDataReporter.TokenBattleWin = "jn8tmo"

function AdjustDataReporter.GetReporter()
  if CS.MSDKExternSetting.IsUseAdjust() == false then
    return nil
  end
  local reporter = CS.GameSdkMonoMgr.Instance:GetOneDataReporter("adjust")
  return reporter
end

function AdjustDataReporter.TrackBuy(amount, currency)
  local reporter = AdjustDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  reporter:TrackRevenueEvent(AdjustDataReporter.TokenPay, amount, currency)
end

function AdjustDataReporter.TryTrackCustomEvent(eventName, propertiesTable)
  local t = {
    [SdkTrackConst.EvtName.battle_win] = "jn8tmo",
    [SdkTrackConst.EvtName.car] = "ykry0o",
    [SdkConst.EvtName.create_role] = "l27yl5",
    [SdkConst.EvtName.draw_card] = "coiykf",
    [SdkConst.EvtName.guide_complete] = "simrjp",
    [SdkConst.EvtName.level_up] = "tpj3in",
    [SdkTrackConst.EvtName.shop_buy] = "v7bpf3",
    [SdkTrackConst.EvtName.task_complete] = "9v3p5j"
  }
  local key = t[eventName]
  if key ~= nil and key ~= "" then
    AdjustDataReporter.TrackEvent(key)
  end
  if eventName == SdkConst.EvtName.level_up and propertiesTable ~= nil then
    AdjustDataReporter.TrackLevelUp(propertiesTable[SdkConst.EvtProp.level])
  end
end

function AdjustDataReporter.TrackLevelUp(levelNow)
  if levelNow == nil then
    return
  end
  if type(levelNow) ~= "number" then
    return
  end
  local token = ""
  if 32 <= levelNow then
    token = "enmg6f"
  elseif 29 <= levelNow then
    token = "hnrv0z"
  elseif 20 <= levelNow then
    token = "s8pieu"
  elseif 15 <= levelNow then
    token = "a3ahht"
  elseif 11 <= levelNow then
    token = "q2ksvv"
  elseif 6 <= levelNow then
    token = "nyuxi4"
  elseif 4 <= levelNow then
    token = "92n9b1"
  end
  AdjustDataReporter.TrackEvent(token)
end

function AdjustDataReporter.TrackEvent(token)
  local reporter = AdjustDataReporter.GetReporter()
  if reporter == nil then
    return
  end
  reporter:TrackSimpleEvent(token)
end

return AdjustDataReporter
