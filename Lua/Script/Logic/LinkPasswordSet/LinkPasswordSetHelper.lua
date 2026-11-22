local LinkPasswordSetHelper = {}
LinkPasswordSetHelper.RedDotKey = "RedDot_LinkPasswordSet"

function LinkPasswordSetHelper.IsCanUse()
  local val = GameSetting.SWLinkPasswordSet
  if val ~= nil and type(val) == "number" and val ~= 0 then
    return val == 1
  end
  if SdkRegionHelper.IsRegionCN() and SdkHelper.IsChannelBilibili() == false then
    return false
  end
  return true
end

function LinkPasswordSetHelper.GetRedDot()
  local val = PlayerData:GetPlayerPrefs("int", LinkPasswordSetHelper.RedDotKey) or 0
  return val
end

function LinkPasswordSetHelper.SetRedDot(val)
  PlayerData:SetPlayerPrefs("int", LinkPasswordSetHelper.RedDotKey, val)
end

return LinkPasswordSetHelper
