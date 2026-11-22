local GooglePCHelper = {}

function GooglePCHelper.IsUseGooglePCAuth()
  if SdkChannelHelper.IsCurUjoy() and ChannelUJoyHelper.IsChannelGPPC() then
    return true
  end
  return false
end

return GooglePCHelper
