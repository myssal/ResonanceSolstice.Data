local View = require("UISetting/UISettingView")
local DataModel = require("UISetting/PcGraphics/UISetting_PcGraphicsDataModel")
local Controller = {}

function Controller:InitView()
  self.isShowingPCResulotionScroll = false
  self.isInitedPcResolutionGrid = false
  self:InitAntiAliasing()
  self:InitVSync()
  self:ResetPCWindowType()
  self:InitPCResolution()
  self:InitCityFPS()
  self:InitTrainMapFPS()
  self:InitLoadBias()
  self:InitShadowDistance()
end

function Controller:RefreshView()
  self:RefreshAntiAliasing()
  self:ResetPCWindowType()
  self:SetPCResolutionChangeBtnTxt()
  self:RefreshLodBias()
  self:RefreshShadowDistance()
  self:RefreshVSync()
end

function Controller:RestoreToDefault()
  GraphicsSettingPcHelper.RestoreToDefault()
  self:RefreshView()
  self:SetPCWindowTypeShow(GraphicsSettingPcData.PcDefaultWindowTypeIsFull)
end

function Controller:IsEnableShadowDistance()
  return GraphicsSettingHelper.CanUseShadowDistance()
end

function Controller:InitShadowDistance()
  if self:IsEnableShadowDistance() == false then
    return
  end
  local Group_ShadowDistance = self:GetGroupShadowDistance()
  if Group_ShadowDistance == nil then
    return
  end
  Group_ShadowDistance:SetActive(true)
  Group_ShadowDistance.Img_Box.StaticGrid_TextureQuality.grid.self:SetDataCount(DataModel:GetShadowDistanceCount())
  Group_ShadowDistance.Img_Box.StaticGrid_TextureQuality.grid.self:RefreshAllElement()
  self:RefreshShadowDistance()
end

function Controller:RefreshShadowDistance()
  if self:IsEnableShadowDistance() == false then
    return
  end
  self:HideAllItemsShadowDistance()
  local curIndex = GraphicsSettingHelper.GetShadowDistance() + 1
  local element = View.Group_PC.ScrollView_Image.Viewport.Content.Group_ShadowDistance.Img_Box.StaticGrid_TextureQuality.grid[curIndex]
  if element == nil then
    return
  end
  element.Btn_Off:SetActive(false)
  element.Img_On:SetActive(true)
end

function Controller:OnSetGridShadowDistance(element, elementIndex)
  element.Btn_Off:SetClickParam(elementIndex)
  element.Btn_Off:SetActive(true)
  element.Img_On:SetActive(false)
end

function Controller:OnItemBtnClickShowdowDistance(btn, str)
  local index = tonumber(str)
  GraphicsSettingHelper.SetShadowDistance(index - 1)
  self:RefreshShadowDistance()
end

function Controller:GetGroupShadowDistance()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_ShadowDistance
end

function Controller:HideAllItemsShadowDistance()
  local count = DataModel:GetShadowDistanceCount()
  for i = 1, count do
    local lastElement = self:GetGridShadowDistance()[i]
    lastElement.Img_On:SetActive(false)
    lastElement.Btn_Off:SetActive(true)
  end
end

function Controller:GetGridShadowDistance()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_ShadowDistance.Img_Box.StaticGrid_TextureQuality.grid
end

function Controller:IsEnableLodBias()
  return GraphicsSettingHelper.CanUseLodBias()
end

function Controller:InitLoadBias()
  if self:IsEnableLodBias() == false then
    return
  end
  View.Group_PC.ScrollView_Image.Viewport.Content.Group_LOD:SetActive(true)
  View.Group_PC.ScrollView_Image.Viewport.Content.Group_LOD.Img_Box.StaticGrid_LOD.grid.self:SetDataCount(DataModel:GetCountLodBias())
  View.Group_PC.ScrollView_Image.Viewport.Content.Group_LOD.Img_Box.StaticGrid_LOD.grid.self:RefreshAllElement()
  self:RefreshLodBias()
end

function Controller:RefreshLodBias()
  if self:IsEnableLodBias() == false then
    return
  end
  self:HideAllItemsLodBias()
  local curIndex = GraphicsSettingHelper.GetLoadBias() + 1
  local element = View.Group_PC.ScrollView_Image.Viewport.Content.Group_LOD.Img_Box.StaticGrid_LOD.grid[curIndex]
  if element == nil then
    return
  end
  element.Btn_Off:SetActive(false)
  element.Img_On:SetActive(true)
end

function Controller:OnSetGridLodBias(element, elementIndex)
  element.Btn_Off:SetActive(true)
  element.Img_On:SetActive(false)
  element.Btn_Off:SetClickParam(elementIndex)
end

function Controller:OnItemBtnClickLodBias(btn, str)
  local index = tonumber(str)
  GraphicsSettingHelper.SetLodBias(index - 1)
  self:RefreshLodBias()
end

function Controller:HideAllItemsLodBias()
  local count = DataModel:GetCountLodBias()
  for i = 1, count do
    local lastElement = self:GetGridLodBias()[i]
    lastElement.Img_On:SetActive(false)
    lastElement.Btn_Off:SetActive(true)
  end
end

function Controller:GetGridLodBias()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_LOD.Img_Box.StaticGrid_LOD.grid
end

function Controller:InitAntiAliasing()
  self:GetAntiAliasingGrid().self:SetDataCount(DataModel:GetAntiAliasConfigsCount())
  self:GetAntiAliasingGrid().self:RefreshAllElement()
  self:RefreshAntiAliasing()
end

function Controller:RefreshAntiAliasing()
  self:HideAllAntiAliasingGridItem()
  local lastIndex = GraphicsSettingPrefsHelper.GetMSAA() + 1
  local lastElement = self:GetAntiAliasingGrid()[lastIndex]
  lastElement.Img_On:SetActive(true)
  lastElement.Btn_Off:SetActive(false)
end

function Controller:HideAllAntiAliasingGridItem()
  local count = DataModel:GetAntiAliasConfigsCount()
  for i = 1, count do
    local lastElement = self:GetAntiAliasingGrid()[i]
    lastElement.Img_On:SetActive(false)
    lastElement.Btn_Off:SetActive(true)
  end
end

function Controller:GetAntiAliasingGrid()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_MSAA.Img_Box.StaticGrid_MSAA.grid
end

function Controller:OnSetGridAntiAliasing(element, elementIndex)
  element.Btn_Off:SetClickParam(elementIndex)
  element.Img_On:SetActive(false)
  element.Btn_Off:SetActive(true)
  local title = DataModel:GetAntiAliasConfigTitle(elementIndex)
  element.Img_On.Txt_Title:SetText(title)
  element.Btn_Off.Txt_Title:SetText(title)
end

function Controller:OnItemBtnClickAntiAliasing(btn, str)
  local index = tonumber(str)
  self:HideAllAntiAliasingGridItem()
  local element = self:GetAntiAliasingGrid()[index]
  element.Img_On:SetActive(true)
  element.Btn_Off:SetActive(false)
  GraphicsSettingHelper.SetMSAA(index - 1)
end

function Controller:IsEnableVSync()
  return GraphicsSettingHelper.CanUseVSync()
end

function Controller:InitVSync()
  local Group_VSync = self:GetGroupVSync()
  if not self:IsEnableVSync() then
    Group_VSync:SetActive(false)
    return
  end
  Group_VSync:SetActive(true)
  local isOn = GraphicsSettingHelper.GetVSync() == 1
  self:TurnVSync(isOn, false)
end

function Controller:RefreshVSync()
  if self:IsEnableVSync() == false then
    return
  end
  local isOn = GraphicsSettingHelper.IsVSyncOn()
  self:TurnVSync(isOn, false)
end

function Controller:GetGroupVSync()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_VSync
end

function Controller:TurnVSync(isOn, playAnim, funcAnimEnd)
  local Group_VSync = self:GetGroupVSync()
  local switch = Group_VSync.Img_Switch
  local spritePath = "UI/Setting/resource/slide_off"
  local offsetX = -43
  if isOn then
    spritePath = "UI/Setting/resource/slide_on"
    offsetX = 43
  end
  if playAnim then
    DOTweenTools.DOLocalMoveXCallback(switch.Img_On.transform, offsetX, 0.25, function()
      switch:SetSprite(spritePath)
      if funcAnimEnd ~= nil then
        funcAnimEnd()
      end
    end)
  else
    switch:SetSprite(spritePath)
    switch.Img_On:SetLocalPositionX(offsetX)
  end
end

function Controller:OnClickVSync()
  local isOn = GraphicsSettingHelper.IsVSyncOn()
  self:TurnVSync(not isOn, true, function()
    GraphicsSettingHelper.TurnVSync()
  end)
end

function Controller:InitMSAA()
  if not self:IsPC() or GraphicsSettingHelper.CanUseMSAA() == false then
    return
  end
  local isMSAA = 0
  if PlayerPrefs.HasKey("currentMSAA") then
    isMSAA = PlayerPrefs.GetInt("currentMSAA")
  end
  local switch = View.Group_Image.ScrollView_Image.Viewport.Content.Group_MSAA.Img_Switch
  if switch ~= nil then
    local spriteName = "UI/Setting/resource/slide_off"
    local offset = -43
    if isMSAA == 1 then
      spriteName = "UI/Setting/resource/slide_on"
      offset = 43
    end
    switch:SetSprite(spriteName)
    switch.Img_On:SetLocalPositionX(offset)
  end
end

function Controller:InitCityFPS()
  if self:IsPC() then
    local strFps60 = "60FPS"
    local strFps120 = "120FPS"
    local Group_CityFPS = View.Group_Image.ScrollView_Image.Viewport.Content.Group_CityFPS
    if Group_CityFPS == nil then
      return
    end
    Group_CityFPS.Img_Box.Group_30Fps.Btn_Off.Txt_30:SetText(strFps60)
    Group_CityFPS.Img_Box.Group_30Fps.Img_On.Txt_30:SetText(strFps60)
    Group_CityFPS.Img_Box.Group_60Fps.Btn_Off.Txt_60:SetText(strFps120)
    Group_CityFPS.Img_Box.Group_60Fps.Img_On.Txt_60:SetText(strFps120)
  end
end

function Controller:InitTrainMapFPS()
  if self:IsPC() then
    local strFps60 = "60FPS"
    local strFps120 = "120FPS"
    local Group_DriveFPS = View.Group_Image.ScrollView_Image.Viewport.Content.Group_DriveFPS
    if Group_DriveFPS == nil then
      return
    end
    Group_DriveFPS.Img_Box.Group_30Fps.Btn_Off.Txt_30:SetText(strFps60)
    Group_DriveFPS.Img_Box.Group_30Fps.Img_On.Txt_30:SetText(strFps60)
    Group_DriveFPS.Img_Box.Group_60Fps.Btn_Off.Txt_60:SetText(strFps120)
    Group_DriveFPS.Img_Box.Group_60Fps.Img_On.Txt_60:SetText(strFps120)
  end
end

function Controller:IsPCWindowTypeSetEnable()
  if not self:IsPC() then
    return false
  end
  if self:GetPCWindowTypeGroup() == nil then
    return false
  end
  return true
end

function Controller:IsPcResolutionSetEnable()
  if not self:IsPC() then
    return false
  end
  if self:GetPCResolutionGroup() == nil then
    return false
  end
  return true
end

function Controller:ResetPCWindowType()
  if not self:IsPCWindowTypeSetEnable() then
    return
  end
  self:GetPCWindowTypeGroup():SetActive(true)
  local fullScreen = GraphicsHelper.IsFullScreen()
  self:SetPCWindowTypeShow(fullScreen)
end

function Controller:SetPCWindowTypeShow(isFull)
  self:GetPCWindowTypeGroup().Img_Box.Group_All.Img_On:SetActive(isFull)
  self:GetPCWindowTypeGroup().Img_Box.Group_All.Btn_Off:SetActive(not isFull)
  self:GetPCWindowTypeGroup().Img_Box.Group_Window.Img_On:SetActive(not isFull)
  self:GetPCWindowTypeGroup().Img_Box.Group_Window.Btn_Off:SetActive(isFull)
end

function Controller:InitPCResolution()
  if not self:IsPcResolutionSetEnable() then
    return
  end
  self:GetPCResolutionGroup():SetActive(true)
  self:SetPCResolutionChangeBtnTxt()
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetActive(false)
end

function Controller:TryInitPCResolutionGrid()
  if self.isInitedPcResolutionGrid == false then
    local ca = PlayerData:GetFactoryData(99900012)
    local list = ca.PCresolutionList
    self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetDataCount(table.count(list))
    self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:RefreshAllElement()
    self.isInitedPcResolutionGrid = true
  end
end

function Controller:SetPCResolutionChangeBtnTxt()
  local curWidht = GraphicsHelper.GetScreenWidth()
  local curHeight = GraphicsHelper.GetScreenHeight()
  local display = GraphicsSettingPrefsHelper.GetResolutionDisplay()
  local strShow = string.format("%sx%s", 1920, 1080)
  if display ~= nil and display ~= "" then
    strShow = display
  end
  self:GetPCResolutionGroup().Group_Main.Btn_Change.Txt_Resolution:SetText(strShow)
end

function Controller:SetPCResolutionChangeBtnTxtWithText(text)
  self:GetPCResolutionGroup().Group_Main.Btn_Change.Txt_Resolution:SetText(text)
end

function Controller:OnSetGridPcResolution(element, elementIndex)
  element.Img_Activated:SetActive(false)
  local ca = PlayerData:GetFactoryData(99900012)
  local list = ca.PCresolutionList
  local cfg = list[elementIndex]
  if cfg == nil then
    return
  end
  element.Btn_Activate.Txt_Language:SetText(cfg.resolution)
  element.Btn_Activate:SetClickParam(elementIndex)
end

function Controller:OnItemBtnClickPcResolution(btn, str)
  if self:CheckNotArrived() then
    return
  end
  local index = tonumber(str)
  local cfg = self:GetCfgFromPcResolutionList(index)
  if cfg == nil then
    return
  end
  local width = cfg.long
  local height = cfg.width
  if width == nil or height == nil then
    return
  end
  self:OnClickResolutionBtn()
  self:SetPCResolutionChangeBtnTxtWithText(cfg.resolution)
  GraphicsHelper.SetResolutionWithCurrentScreenMode(width, height)
end

function Controller:GetCfgFromPcResolutionList(index)
  local ca = PlayerData:GetFactoryData(99900012)
  local list = ca.PCresolutionList
  if list == nil then
    return nil
  end
  return list[index]
end

function Controller:GetPCWindowTypeGroup()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_PCWindowType
end

function Controller:GetPCResolutionGroup()
  return View.Group_PC.ScrollView_Image.Viewport.Content.Group_PCresolution
end

function Controller:OnClickResolutionBtn()
  if self:CheckNotArrived() then
    return
  end
  self.isShowingPCResulotionScroll = not self.isShowingPCResulotionScroll
  self:GetPCResolutionGroup().Btn_BG:SetActive(self.isShowingPCResulotionScroll)
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetActive(self.isShowingPCResulotionScroll)
  self:TryInitPCResolutionGrid()
end

function Controller:SetFullScreenMode()
  if self:CheckNotArrived() then
    return
  end
  GraphicsHelper.SetFullScreenMode()
  self:SetPCWindowTypeShow(true)
end

function Controller:SetWindowMode()
  if self:CheckNotArrived() then
    return
  end
  GraphicsHelper.SetWindowMode()
  self:SetPCWindowTypeShow(false)
end

function Controller:IsPC()
  return PlatformHelper.IsPC()
end

function Controller:CheckNotArrived()
  if PlayerData:GetHomeInfo().station_info.is_arrived ~= 2 then
    CommonTips.OpenTips(80608658)
    return true
  end
  if MainManager.bgSceneName ~= "Main" then
    CommonTips.OpenTips(80608658)
    return true
  end
  return false
end

return Controller
