local SkinPoseHelper = {}
local PlayerPrefsKey = "SkinPoseIndex"

local function GetExtraSpineList(viewId)
  local viewCA = PlayerData:GetFactoryData(viewId, "UnitViewFactory")
  return viewCA and viewCA.extraSpineList or {}
end

function SkinPoseHelper.GetPoseIndex(viewId)
  local extraSpineList = GetExtraSpineList(viewId)
  local poseIndex = tonumber(PlayerData:GetPlayerPrefs("int", PlayerPrefsKey .. viewId)) or 0
  if poseIndex < 0 or poseIndex > #extraSpineList then
    return 0
  end
  return poseIndex
end

function SkinPoseHelper.SetPoseIndex(viewId, poseIndex)
  local extraSpineList = GetExtraSpineList(viewId)
  poseIndex = tonumber(poseIndex) or 0
  if poseIndex < 0 or poseIndex > #extraSpineList then
    poseIndex = 0
  end
  PlayerData:SetPlayerPrefs("int", PlayerPrefsKey .. viewId, poseIndex)
  return poseIndex
end

function SkinPoseHelper.NextPoseIndex(viewId)
  local extraSpineList = GetExtraSpineList(viewId)
  local poseIndex = SkinPoseHelper.GetPoseIndex(viewId) + 1
  if poseIndex > #extraSpineList then
    poseIndex = 0
  end
  return SkinPoseHelper.SetPoseIndex(viewId, poseIndex)
end

function SkinPoseHelper.GetViewId(viewId, isSpine2)
  if isSpine2 == true or tonumber(isSpine2) == 1 then
    return viewId
  end
  local poseIndex = SkinPoseHelper.GetPoseIndex(viewId)
  if 0 < poseIndex then
    return GetExtraSpineList(viewId)[poseIndex].id
  end
  return viewId
end

function SkinPoseHelper.GetDefaultIdleName(viewCA)
  local idleName = "idle"
  local idleListId = viewCA and viewCA.SpineIdleListId
  if idleListId and 0 < idleListId then
    local idleListCA = PlayerData:GetFactoryData(idleListId, "ListFactory")
    local idleInfo = idleListCA and idleListCA.posterGirlIdleList and idleListCA.posterGirlIdleList[1]
    if idleInfo and idleInfo.idleName and idleInfo.idleName ~= "" then
      idleName = idleInfo.idleName
    end
  end
  return idleName
end

return SkinPoseHelper
