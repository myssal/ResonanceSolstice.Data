local UJoyReporter = {}

function UJoyReporter.TrackEnterGame()
  UJoyReporter.TrackEvent("enterinstance", "")
end

function UJoyReporter.TrackCreateRole()
  local t = {
    role_id = PlayerData:GetUserInfo().uid
  }
  UJoyReporter.TrackEvent("create_character", Json.encode(t))
end

function UJoyReporter.TrackTaskComplete(taskId)
  if SdkChannelHelper.IsCurNotUjoy() then
    return
  end
  if taskId == nil or type(taskId) ~= "number" then
    return
  end
  local token = ""
  if taskId == 81000025 then
    token = "Chapter_2"
  elseif taskId == 81000037 then
    token = "Chapter_3"
  elseif taskId == 81001199 then
    token = "Chapter_4"
  end
  UJoyReporter.TrackEvent(token, "")
end

function UJoyReporter.TrackBuySuccess(strProductId, isFirst, sdkPrice, sdkOrderId)
  if SdkChannelHelper.IsCurNotUjoy() then
    return
  end
  if strProductId == nil or type(strProductId) ~= "string" then
    return
  end
  local token = ""
  local productPrice = 0
  if strProductId == "82100003" then
    token = "card_huashi_6"
    productPrice = 1.13
  elseif strProductId == "82100004" then
    token = "card_huashi_30"
    productPrice = 5.63
  elseif strProductId == "82100005" then
    token = "card_huashi_98"
    productPrice = 17.25
  elseif strProductId == "82100006" then
    token = "card_huashi_198"
    productPrice = 33.75
  elseif strProductId == "82100007" then
    token = "card_huashi_328"
    productPrice = 56.25
  elseif strProductId == "82100013" then
    token = "card_huashi_488"
    productPrice = 82.5
  elseif strProductId == "82100008" then
    token = "card_huashi_648"
    productPrice = 111.75
  elseif strProductId == "82100089" then
    token = "card_qicheng_6"
    productPrice = 1.13
  elseif strProductId == "82100014" then
    token = "card_zhaomu_6"
    productPrice = 1.13
  elseif strProductId == "82100017" then
    token = "card_zhaomu_168"
    productPrice = 29.25
  elseif strProductId == "82100025" then
    token = "card_zhaomu_328"
    productPrice = 56.25
  end
  local t = {price = productPrice}
  UJoyReporter.TrackEvent(token, Json.encode(t))
  UJoyReporter.TrackFirstBuy(isFirst, sdkPrice)
  UJoyReporter.TrackPcAfPurchase(sdkPrice, sdkOrderId)
end

function UJoyReporter.TrackFirstBuy(isFirst, sdkPrice)
  if sdkPrice == nil then
    return
  end
  if SdkHelper.IsChannelUjoy() == false or isFirst == nil or type(isFirst) ~= "string" or isFirst ~= "1" then
    return
  end
  local t2 = {
    price = sdkPrice or 0
  }
  UJoyReporter.TrackEvent("first_charge", Json.encode(t2))
end

function UJoyReporter.TrackPcAfPurchase(sdkPrice, sdkOrderId)
  if sdkOrderId == nil or sdkPrice == nil then
    return
  end
  if SdkHelper.IsChannelUjoy() == false then
    return
  end
  if PlatformHelper.IsPC() == false then
    return
  end
  local t2 = {
    af_order_id = sdkOrderId,
    af_price = sdkPrice / 100,
    af_currency = "USD",
    af_revenue = sdkPrice / 100
  }
  UJoyReporter.TrackEvent("af_purchase", Json.encode(t2))
end

function UJoyReporter.TrackLevelUp(levelNow)
  if levelNow == nil then
    return
  end
  if type(levelNow) ~= "number" then
    return
  end
  local token = ""
  if 50 <= levelNow then
    token = "level_50"
  elseif 45 <= levelNow then
    token = "level_45"
  elseif 40 <= levelNow then
    token = "level_40"
  elseif 35 <= levelNow then
    token = "level_35"
  elseif 30 <= levelNow then
    token = "level_30"
  elseif 25 <= levelNow then
    token = "level_25"
  elseif 20 <= levelNow then
    token = "level_20"
  elseif 15 <= levelNow then
    token = "level_15"
  elseif 10 <= levelNow then
    token = "level_10"
  elseif 5 <= levelNow then
    token = "level_5"
  elseif 4 <= levelNow then
    token = "level_4"
  elseif 3 <= levelNow then
    token = "level_3"
  elseif 2 <= levelNow then
    token = "level_2"
  elseif 1 <= levelNow then
    token = "level_1"
  end
  UJoyReporter.TrackEvent(token, "")
end

function UJoyReporter.TrackEvent(strKey, strValue)
  if SdkChannelHelper.IsCurUjoy() then
    CS.ChannelUjoyMgr.Instance:LogEvent(strKey, strValue, false)
  end
end

return UJoyReporter
