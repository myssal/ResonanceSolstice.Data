local Order = {}
local isWait = false

function Order:OnStart(ca)
  isWait = ca.isWait or false
  for k, v in pairs(ca.paramList) do
    Net.SetGuideNoUpdateLimit(v.paramEnum, v.paramVal)
  end
end

function Order:IsFinish()
  if isWait then
    return Net.updateGuideNoLimit == nil
  else
    return true
  end
end

return Order
