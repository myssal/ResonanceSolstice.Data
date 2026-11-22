local LoginViewHelper = {}

function LoginViewHelper.IsShowChannelLoginLanguageOptions()
  if LoginHelper.IsUseChannelLogin() == false then
    return false
  end
  if SdkRegionHelper.IsRegionCN() == false then
    return false
  end
  if SdkChannelHelper.IsCurSteam() then
    return false
  end
  return true
end

return LoginViewHelper
