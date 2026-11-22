local DataModel = {}

function DataModel:GetAntiAliasConfigs()
  return GraphicsSettingData.GetAntiAliasConfigs()
end

function DataModel:GetAntiAliasConfigsCount()
  return GraphicsSettingData.GetAntiAliasConfigsCount()
end

function DataModel:GetShadowDistanceCount()
  return GraphicsSettingData.GetCountShadowResolution()
end

function DataModel:GetCountLodBias()
  return GraphicsSettingData.GetCountLodBias()
end

function DataModel:GetAntiAliasConfigTitle(index)
  if index == 1 then
    return GetText(80609355)
  elseif index == 2 then
    return GetText(80609356)
  elseif index == 3 then
    return GetText(80609357)
  else
    return GetText(80609358)
  end
end

return DataModel
