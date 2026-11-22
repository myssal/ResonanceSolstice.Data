local GraphicsSettingPcHelper = {}

function GraphicsSettingPcHelper.RestoreToDefault()
  GraphicsSettingPcHelper.SetDefaultResolution()
  GraphicsSettingPcHelper.SetDefaultAntiAlias()
  GraphicsSettingPcHelper.SetDefaultLodBias()
  GraphicsSettingPcHelper.SetDefaultShadowDistance()
  GraphicsSettingPcHelper.SetDefaultShadowDistance()
  GraphicsSettingPcHelper.SetDefaultVSync()
end

function GraphicsSettingPcHelper.SetDefaultResolution()
  local width = GraphicsSettingPcData.PcDefaultResolutionWidth
  local height = GraphicsSettingPcData.PcDefaultResolutionHeight
  local isFull = GraphicsSettingPcData.PcDefaultWindowType == 0
  GraphicsHelper.SetScreenResolution(width, height, isFull, true)
end

function GraphicsSettingPcHelper.SetDefaultAntiAlias()
  local quality = GraphicsSettingPcData.PcDefaultAntiAnliasingQuality
  GraphicsSettingHelper.SetMSAA(quality)
end

function GraphicsSettingPcHelper.SetDefaultLodBias()
  local quality = GraphicsSettingData.DefaultLodBiasTier
  GraphicsSettingHelper.SetLodBias(quality)
end

function GraphicsSettingPcHelper.SetDefaultShadowDistance()
  local quality = GraphicsSettingData.DefaultShadowDistanceTier
  GraphicsSettingHelper.SetShadowDistance(quality)
end

function GraphicsSettingPcHelper.SetDefaultVSync()
  local quality = GraphicsSettingData.DefaultVSync
  GraphicsSettingHelper.SetVSync(quality)
end

return GraphicsSettingPcHelper
