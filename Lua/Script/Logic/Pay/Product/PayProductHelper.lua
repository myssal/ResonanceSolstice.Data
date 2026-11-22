local PayProductHelper = {}

function PayProductHelper.GetProductDisplayPrice(strProductId, preciseDecimalFloor)
  local displayPrice = ""
  if SdkHelper.IsChannelHaoPlay() then
    displayPrice = CS.PayLuaface.GetProductDisplayPrice(strProductId)
    if displayPrice ~= "" then
      return displayPrice
    end
  end
  local formatText = GetText(80601069)
  if SdkHelper.IsChannelDmm() then
    formatText = "pt %d"
  end
  if SdkRegionHelper.IsRegionUS() then
    formatText = "$%s"
  end
  if PlatformHelper.IsEditor() then
    formatText = "$%s"
  end
  local factoryData = PlayerData:GetFactoryData(strProductId)
  if factoryData ~= nil then
    if preciseDecimalFloor then
      return string.format(formatText, PlayerData:GetPreciseDecimalFloor(factoryData.value, 2))
    else
      return string.format(formatText, factoryData.value)
    end
  end
  return ""
end

function PayProductHelper.GetProductConfigPriceAmount(strProductId)
  local factoryData = PayProductHelper.GetProductConfig(strProductId)
  if factoryData ~= nil then
    return factoryData.value
  end
  return 0
end

function PayProductHelper.GetProductConfigName(strProductId)
  local factoryData = PayProductHelper.GetProductConfig(strProductId)
  if factoryData ~= nil then
    return factoryData.name
  end
  return "none"
end

function PayProductHelper.GetProductConfigShopId(strProductId)
  local factoryData = PayProductHelper.GetProductConfig(strProductId)
  if factoryData ~= nil then
    return factoryData.correspondStore
  end
  return 0
end

function PayProductHelper.GetProductConfig(strProductId)
  local factoryData = PlayerData:GetFactoryData(strProductId)
  return factoryData
end

function PayProductHelper.IsProductBuyTypeItem(strProductId)
  local factoryData = PayProductHelper.GetProductConfig(strProductId)
  if factoryData ~= nil then
    return factoryData.buyType == "Item"
  end
  return false
end

return PayProductHelper
