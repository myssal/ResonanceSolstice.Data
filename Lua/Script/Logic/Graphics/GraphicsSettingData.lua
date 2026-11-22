local GraphicsSettingData = {}
GraphicsSettingData.DefaultShadowDistanceTier = 2
GraphicsSettingData.DefaultLodBiasTier = 2
GraphicsSettingData.DefaultVSync = 0

function GraphicsSettingData.GetAntiAliasConfigs()
  local t = {
    [0] = 0,
    [1] = 4,
    [2] = 8,
    [3] = 16
  }
  return t
end

function GraphicsSettingData.GetAntiAliasConfigsCount()
  return table.count(GraphicsSettingData.GetAntiAliasConfigs())
end

function GraphicsSettingData.GetAntiAliasCount(index)
  return GraphicsSettingData.GetAntiAliasConfigs()[index]
end

function GraphicsSettingData.GetConfigsLodBias()
  local tier1 = 1
  local tier2 = 2
  local tier3 = 3
  local csTier1 = GraphicsSettingData.GetCsLodTier1()
  local csTier2 = GraphicsSettingData.GetCsLodTier2()
  local csTier3 = GraphicsSettingData.GetCsLodTier3()
  if 0 < csTier1 then
    tier1 = csTier1
  end
  if 0 < csTier2 then
    tier2 = csTier2
  end
  if 0 < csTier3 then
    tier3 = csTier3
  end
  local t = {
    [0] = tier1,
    [1] = tier2,
    [2] = tier3
  }
  return t
end

function GraphicsSettingData.GetCountLodBias()
  return table.count(GraphicsSettingData.GetConfigsLodBias())
end

function GraphicsSettingData.GetLodBiasByIndex(index)
  return GraphicsSettingData.GetConfigsLodBias()[index] or 1
end

function GraphicsSettingData.GetCsLodTier1()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueLodTier1)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetCsLodTier2()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueLodTier2)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetCsLodTier3()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueLodTier3)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetConfigsShadowResolution()
  local t = {
    [0] = 1,
    [1] = 2,
    [2] = 3
  }
  return t
end

function GraphicsSettingData.GetShadowResolutionByIndex(index)
  return GraphicsSettingData.GetConfigsShadowResolution()[index] or 1
end

function GraphicsSettingData.GetCountShadowResolution()
  return table.count(GraphicsSettingData.GetConfigsShadowResolution())
end

function GraphicsSettingData.GetConfigsShadowDistance()
  local tier1 = 100
  local tier2 = 300
  local tier3 = 800
  local csTier1 = GraphicsSettingData.GetCsShadowDistanceTier1()
  local csTier2 = GraphicsSettingData.GetCsShadowDistanceTier2()
  local csTier3 = GraphicsSettingData.GetCsShadowDistanceTier3()
  if 0 < csTier1 then
    tier1 = csTier1
  end
  if 0 < csTier2 then
    tier2 = csTier2
  end
  if 0 < csTier3 then
    tier3 = csTier3
  end
  local t = {
    [0] = tier1,
    [1] = tier2,
    [2] = tier3
  }
  return t
end

function GraphicsSettingData.GetShadowDistanceByIndex(index)
  return GraphicsSettingData.GetConfigsShadowDistance()[index] or 1
end

function GraphicsSettingData.GetCsShadowDistanceTier1()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueShadowDistanceTier1)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetCsShadowDistanceTier2()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueShadowDistanceTier2)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetCsShadowDistanceTier3()
  local r, s = CommonHelper.SafeCallCsFunc(CS.IngameSettingLuaface.GetGraphicsSetValueShadowDistanceTier3)
  if r == nil or r == false or s == nil or s <= 0 then
    return 0
  end
  return s
end

function GraphicsSettingData.GetConfigsShadowCascades()
  local t = {
    [0] = 2,
    [1] = 2,
    [2] = 4
  }
  return t
end

function GraphicsSettingData.GetShadowCascadesByIndex(index)
  return GraphicsSettingData.GetConfigsShadowCascades()[index] or 1
end

return GraphicsSettingData
