local View = require("UISetting/UISettingView")
local Controller = {}

function Controller:InitView()
  self.isShowingPCResulotionScroll = false
  self:InitCityFPS()
  self:InitTrainMapFPS()
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
  local ca = PlayerData:GetFactoryData(99900012)
  local list = ca.PCresolutionList
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetDataCount(table.count(list))
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:RefreshAllElement()
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetActive(false)
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
  return View.Group_Image.ScrollView_Image.Viewport.Content.Group_PCWindowType
end

function Controller:GetPCResolutionGroup()
  return View.Group_Image.ScrollView_Image.Viewport.Content.Group_PCresolution
end

function Controller:OnClickResolutionBtn()
  if self:CheckNotArrived() then
    return
  end
  self.isShowingPCResulotionScroll = not self.isShowingPCResulotionScroll
  self:GetPCResolutionGroup().Btn_BG:SetActive(self.isShowingPCResulotionScroll)
  self:GetPCResolutionGroup().ScrollGrid_ResolutionList.grid.self:SetActive(self.isShowingPCResulotionScroll)
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
  return false
end

return Controller
