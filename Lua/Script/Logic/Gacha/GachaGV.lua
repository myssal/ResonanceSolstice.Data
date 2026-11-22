local GachaGV = {}

function GachaGV:SetLastTenPullPollId(poolId)
  if type(poolId) ~= "number" then
    self.lastTenPullPoolId = tonumber(poolId)
  else
    self.lastTenPullPoolId = poolId
  end
end

function GachaGV:GetLastTenPullPollId()
  return self.lastTenPullPoolId or 0
end

function GachaGV:LastTenPullPollIsNewbie()
  local newbiewPoolId = GachaHelper.GetNewbiePoolId()
  local lastPullPoolId = self:GetLastTenPullPollId()
  if lastPullPoolId == newbiewPoolId then
    return true
  end
  return false
end

function GachaGV:SetLastDrawInfos(list)
  self.lastDrawInfoList = list
end

function GachaGV:GetLastDrawInfos()
  return self.lastDrawInfoList
end

function GachaGV:GetLastDrawNum()
  if self.lastDrawInfoList == nil then
    return 0
  end
  return self.lastDrawInfoList.drawNum
end

return GachaGV
