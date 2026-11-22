local View = require("UISetting/UISettingView")
local DataModel = require("UISetting/UISettingDataModel")
local CtrlCdk = require("UISetting/Cdk/UISettingCdkController")
local LanguageCtrl = require("UISetting/UISettingLanguageController")
local CtrlGraphics = require("UISetting/Graphics/UISetting_GraphicsController")
local CtrlPcGraphics = require("UISetting/PcGraphics/UISetting_PcGraphicsController")
local SwitchText = require("UISetting/SwitchText/UISettingSwitchTextController")

local function SwitchSoundLanguage(selectLanguage)
  local nowLanguage = 1
  local currentSVLanguage = GameSetting.currentSVLanguage
  if currentSVLanguage == "zh" then
    nowLanguage = 1
  else
    nowLanguage = 2
  end
  if nowLanguage ~= selectLanguage then
    nowLanguage = selectLanguage
    local language = "zh"
    if nowLanguage == 1 then
      language = "zh"
    else
      language = "jp"
    end
    PlayerPrefs.SetString("LanguageSVType", language)
    GameSetting.currentSVLanguage = language
    TranslateManager:SetSVLanguage(language)
    View.Group_Sound.Group_DubbingOptions.Img_Box.Group_Chinese.Group_Language.Img_On:SetActive(nowLanguage == 1)
    View.Group_Sound.Group_DubbingOptions.Img_Box.Group_Japanese.Group_Language.Img_On:SetActive(nowLanguage == 2)
  end
end

local ViewFunction = {
  Setting_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
    PlayerPrefs.SetInt("bg", DataModel.Now_Bg)
    PlayerPrefs.SetInt("music", DataModel.Now_Music)
    PlayerPrefs.SetInt("roleCV", DataModel.Now_RoleCV)
  end,
  Setting_Group_Slider1_Slider_Value1_Slider = function(slider, value)
    local s_value = math.floor(value)
    DataModel:SetSliderBG(s_value)
  end,
  Setting_Group_Slider1_Slider_Value1_SliderDown = function(slider)
  end,
  Setting_Group_Slider1_Slider_Value1_SliderUp = function(slider)
    DataModel:UpdateSound(1)
  end,
  Setting_Group_Slider2_Slider_Value2_Slider = function(slider, value)
    local s_value = math.floor(value)
    DataModel:SetSliderMusic(s_value)
  end,
  Setting_Group_Slider2_Slider_Value2_SliderDown = function(slider)
  end,
  Setting_Group_Slider2_Slider_Value2_SliderUp = function(slider)
    DataModel:UpdateSound(2)
  end,
  Setting_Group_ImageQuality_Btn_VeryLow_Click = function(btn, str)
    GameSetting:SetVisualQuality(0)
    DataModel:SetImageQuality(0)
  end,
  Setting_Group_ImageQuality_Btn_Low_Click = function(btn, str)
    GameSetting:SetVisualQuality(1)
    DataModel:SetImageQuality(1)
  end,
  Setting_Group_ImageQuality_Btn_Medium_Click = function(btn, str)
    GameSetting:SetVisualQuality(2)
    DataModel:SetImageQuality(2)
  end,
  Setting_Group_ImageQuality_Btn_High_Click = function(btn, str)
    GameSetting:SetVisualQuality(3)
    DataModel:SetImageQuality(3)
  end,
  Setting_Group_ImageQuality_Btn_VeryHigh_Click = function(btn, str)
    GameSetting:SetVisualQuality(4)
    DataModel:SetImageQuality(4)
  end,
  Setting_Group_FPS_Btn_30_Click = function(btn, str)
    GraphicsSettingHelper.SetVisualFPS(0)
    DataModel:SetFPS(0)
  end,
  Setting_Group_FPS_Btn_60_Click = function(btn, str)
    GraphicsSettingHelper.SetVisualFPS(1)
    DataModel:SetFPS(1)
  end,
  Setting_Group_Shadow_Btn_On_Click = function(btn, str)
    GraphicsSettingHelper.SetShadowQuality(1)
    DataModel:SetShadow(1)
  end,
  Setting_Group_Shadow_Btn_Off_Click = function(btn, str)
    GraphicsSettingHelper.SetShadowQuality(0)
    DataModel:SetShadow(0)
  end,
  Setting_Group_TextureQuality_Btn_Low_Click = function(btn, str)
    GameSetting:SetTextureLimit(0)
    DataModel:SetTextureLimit(0)
  end,
  Setting_Group_TextureQuality_Btn_Medium_Click = function(btn, str)
    GameSetting:SetTextureLimit(1)
    DataModel:SetTextureLimit(1)
  end,
  Setting_Group_TextureQuality_Btn_High_Click = function(btn, str)
    GameSetting:SetTextureLimit(2)
    DataModel:SetTextureLimit(2)
  end,
  Setting_Group_Horizon_Btn_Far_Click = function(btn, str)
    GraphicsSettingHelper.SetViewFarValue(3)
    DataModel:SetFar(3)
  end,
  Setting_Group_Horizon_Btn_Medium_Click = function(btn, str)
    GraphicsSettingHelper.SetViewFarValue(2)
    DataModel:SetFar(2)
  end,
  Setting_Group_Horizon_Btn_Close_Click = function(btn, str)
    GraphicsSettingHelper.SetViewFarValue(1)
    DataModel:SetFar(1)
  end,
  Setting_Group_Horizon_Btn_VeryClose_Click = function(btn, str)
    GraphicsSettingHelper.SetViewFarValue(0)
    DataModel:SetFar(0)
  end,
  Setting_Group_Bloom_Btn_On_Click = function(btn, str)
    GraphicsSettingHelper.SetVisualBloom(1)
    DataModel:SetBloom(1)
  end,
  Setting_Group_Bloom_Btn_Off_Click = function(btn, str)
    GraphicsSettingHelper.SetVisualBloom(0)
    DataModel:SetBloom(0)
  end,
  Setting_Group_Tabs_StaticGrid_Tabs_SetGrid = function(element, elementIndex)
    element.Img_On:SetActive(false)
    element.Btn_Off:SetActive(true)
    local row = DataModel:GetTopRightConfigs()[tonumber(elementIndex)]
    element.Img_On.Img_Black:SetSprite(row.on_img)
    element.Img_On.Txt_Title:SetText(row.txt)
    element.Btn_Off.Img_White:SetSprite(row.off_img)
    element.Btn_Off.Txt_Title:SetText(row.txt)
    element.Btn_Off:SetClickParam(elementIndex)
  end,
  Setting_Group_Tabs_StaticGrid_Tabs_Group_Tabs_Btn_Off_Click = function(btn, str)
    DataModel:SelectRightTop(tonumber(str))
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Btn_RestoreImage_Click = function(btn, str)
    DataModel:ResetImgValue()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PictureQuality_StaticGrid_Quality_SetGrid = function(element, elementIndex)
    element.Btn_Off:SetClickParam(elementIndex)
    element.Img_Selection:SetActive(false)
    element.Btn_Off:SetActive(true)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PictureQuality_StaticGrid_Quality_Group_Quality_Btn_Off_Click = function(btn, str)
    DataModel:SetNewImageQuality(tonumber(str))
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_CityFPS_Img_Box_Group_30Fps_Btn_Off_Click = function(btn, str)
    DataModel:SetCityFPS(0)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_CityFPS_Img_Box_Group_60Fps_Btn_Off_Click = function(btn, str)
    DataModel:SetCityFPS(1)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DriveFPS_Img_Box_Group_30Fps_Btn_Off_Click = function(btn, str)
    DataModel:SetTrainMapFPS(0)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DriveFPS_Img_Box_Group_60Fps_Btn_Off_Click = function(btn, str)
    DataModel:SetTrainMapFPS(1)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DriveHorizon_Img_Box_StaticGrid_DriveHorizon_SetGrid = function(element, elementIndex)
    element.Btn_Off:SetClickParam(elementIndex)
    element.Img_On:SetActive(false)
    element.Btn_Off:SetActive(true)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DriveHorizon_Img_Box_StaticGrid_DriveHorizon_Group_SettingSelection_Btn_Off_Click = function(btn, str)
    DataModel:SetNewFar(tonumber(str))
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DriveShadow_Img_Switch_Btn_Click_Click = function(btn, str)
    local index = 0
    if GameSetting.currentVisualShadow == 0 then
      index = 1
    end
    if GameSetting.currentVisualShadow == 1 then
      index = 0
    end
    DataModel:SetShadow(index)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_Bloom_Img_Switch_Btn_Click_Click = function(btn, str)
    local index = 0
    if GameSetting.currentVisualBloom == 0 then
      index = 1
    end
    if GameSetting.currentVisualBloom == 1 then
      index = 0
    end
    DataModel:SetBloom(index)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_TextureQuality_Img_Box_StaticGrid_TextureQuality_SetGrid = function(element, elementIndex)
    element.Btn_Off:SetClickParam(elementIndex)
    element.Img_On:SetActive(false)
    element.Btn_Off:SetActive(true)
    local row = DataModel.CA.textureQualityList[tonumber(elementIndex)]
    element.Img_On.Txt_Title:SetText(row.optionName)
    element.Btn_Off.Txt_Title:SetText(row.optionName)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_TextureQuality_Img_Box_StaticGrid_TextureQuality_Group_SettingSelection_Btn_Off_Click = function(btn, str)
    DataModel:SetNewTextureLimit(tonumber(str))
  end,
  Setting_Group_Sound_Group_MusicVolume_Img_Box_Slider_MusicVolume_Slider = function(slider, value)
    local s_value = math.floor(value)
    DataModel:SetSliderBG(s_value)
  end,
  Setting_Group_Sound_Group_MusicVolume_Img_Box_Slider_MusicVolume_SliderDown = function(slider)
  end,
  Setting_Group_Sound_Group_MusicVolume_Img_Box_Slider_MusicVolume_SliderUp = function(slider)
    DataModel:UpdateSound(1)
  end,
  Setting_Group_Sound_Btn_RestoreImage_Click = function(btn, str)
    DataModel:ResetMusicValue()
    local nowLanguage = 2
    if GameSetting.defaultSVLanguage then
      if GameSetting.defaultSVLanguage == "zh" then
        nowLanguage = 1
      else
        nowLanguage = 2
      end
    else
      nowLanguage = GameSetting.defaultSoundLanguage
    end
    SwitchSoundLanguage(nowLanguage)
  end,
  Setting_Group_Sound_Group_EffectVolume_Img_Box_Slider_MusicVolume_Slider = function(slider, value)
    local s_value = math.floor(value)
    DataModel:SetSliderMusic(s_value)
  end,
  Setting_Group_Sound_Group_EffectVolume_Img_Box_Slider_MusicVolume_SliderDown = function(slider)
  end,
  Setting_Group_Sound_Group_EffectVolume_Img_Box_Slider_MusicVolume_SliderUp = function(slider)
    DataModel:UpdateSound(2)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_Anti_Aliasing_Img_Switch_Btn_Click_Click = function(btn, str)
  end,
  Setting_Group_Sound_Group_DubbingOptions_Img_Box_Group_Chinese_Group_Language_Btn_Off_Click = function(btn, str)
    SwitchSoundLanguage(1)
  end,
  Setting_Group_Sound_Group_DubbingOptions_Img_Box_Group_Japanese_Group_Language_Btn_Off_Click = function(btn, str)
    if CommonTips.GuideAsset() then
      return
    end
    SwitchSoundLanguage(2)
  end,
  Setting_Group_Cdk_Btn_RestoreImage_Click = function(btn, str)
  end,
  Setting_Group_Cdk_Img_Input_Btn_Clean_Click = function(btn, str)
    CtrlCdk:CleanInput()
  end,
  Setting_Group_Cdk_Btn_Convert_Click = function(btn, str)
    CtrlCdk:Convert()
  end,
  Setting_Group_Sound_Group_CvVolume_Img_Box_Slider_MusicVolume_Slider = function(slider, value)
    local s_value = math.floor(value)
    DataModel:SetSliderRoleCV(s_value)
  end,
  Setting_Group_Sound_Group_CvVolume_Img_Box_Slider_MusicVolume_SliderDown = function(slider)
  end,
  Setting_Group_Sound_Group_CvVolume_Img_Box_Slider_MusicVolume_SliderUp = function(slider)
    DataModel:UpdateSound(3)
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Txt_Group_Main_Btn_Change_Click = function(btn, str)
    LanguageCtrl:ShowTextList()
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Txt_ScrollGrid_LanguageList_SetGrid = function(element, elementIndex)
    LanguageCtrl:SetTextList(element, elementIndex)
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Txt_ScrollGrid_LanguageList_Group_Item_Btn_Activate_Click = function(btn, str)
    LanguageCtrl:ChangeText(str)
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Txt_Btn_BG_Click = function(btn, str)
    LanguageCtrl:HideTextList()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_DamageFigure_Img_Switch_Btn_Click_Click = function(btn, str)
    DataModel:SetDamageFigure(DataModel.Now_DamageFigure)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_MSAA_Img_Switch_Btn_Click_Click = function(btn, str)
    local index = 0
    local isMSAA = PlayerPrefs.GetInt("currentMSAA")
    if isMSAA == 0 then
      index = 1
    end
    if isMSAA == 1 then
      index = 0
    end
    DataModel:SetMSAA(index)
    PlayerPrefs.SetInt("currentMSAA", index)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCWindowType_Img_Box_Group_Window_Btn_Off_Click = function(btn, str)
    CtrlGraphics:SetWindowMode()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCWindowType_Img_Box_Group_All_Btn_Off_Click = function(btn, str)
    CtrlGraphics:SetFullScreenMode()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCresolution_Group_Main_Btn_Change_Click = function(btn, str)
    CtrlGraphics:OnClickResolutionBtn()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCresolution_Btn_BG_Click = function(btn, str)
    CtrlGraphics:OnClickResolutionBtn()
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCresolution_ScrollGrid_ResolutionList_SetGrid = function(element, elementIndex)
    CtrlGraphics:OnSetGridPcResolution(element, elementIndex)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_PCresolution_ScrollGrid_ResolutionList_Group_Item_Btn_Activate_Click = function(btn, str)
    CtrlGraphics:OnItemBtnClickPcResolution(btn, str)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Btn_RestoreImage_Click = function(btn, str)
    CtrlPcGraphics:RestoreToDefault()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_VSync_Img_Switch_Btn_Click_Click = function(btn, str)
    CtrlPcGraphics:OnClickVSync()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_MSAA_Img_Box_StaticGrid_MSAA_SetGrid = function(element, elementIndex)
    CtrlPcGraphics:OnSetGridAntiAliasing(element, elementIndex)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_MSAA_Img_Box_StaticGrid_MSAA_Group_SettingSelection_Btn_Off_Click = function(btn, str)
    CtrlPcGraphics:OnItemBtnClickAntiAliasing(btn, str)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCresolution_Group_Main_Btn_Change_Click = function(btn, str)
    CtrlPcGraphics:OnClickResolutionBtn()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCresolution_Btn_BG_Click = function(btn, str)
    CtrlPcGraphics:OnClickResolutionBtn()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCresolution_ScrollGrid_ResolutionList_SetGrid = function(element, elementIndex)
    CtrlPcGraphics:OnSetGridPcResolution(element, elementIndex)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCresolution_ScrollGrid_ResolutionList_Group_Item_Btn_Activate_Click = function(btn, str)
    CtrlPcGraphics:OnItemBtnClickPcResolution(btn, str)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_FieldofView_Img_Box_StaticGrid_TextureQuality_SetGrid = function(element, elementIndex)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_FieldofView_Img_Box_StaticGrid_TextureQuality_Group_SettingSelection_Btn_Off_Click = function(btn, str)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCWindowType_Img_Box_Group_All_Btn_Off_Click = function(btn, str)
    CtrlPcGraphics:SetFullScreenMode()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_PCWindowType_Img_Box_Group_Window_Btn_Off_Click = function(btn, str)
    CtrlPcGraphics:SetWindowMode()
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_LOD_Img_Box_StaticGrid_LOD_SetGrid = function(element, elementIndex)
    CtrlPcGraphics:OnSetGridLodBias(element, elementIndex)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_LOD_Img_Box_StaticGrid_LOD_Group_SettingSelection_Btn_Off_Click = function(btn, str)
    CtrlPcGraphics:OnItemBtnClickLodBias(btn, str)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_ShadowDistance_Img_Box_StaticGrid_TextureQuality_SetGrid = function(element, elementIndex)
    CtrlPcGraphics:OnSetGridShadowDistance(element, elementIndex)
  end,
  Setting_Group_PC_ScrollView_Image_Viewport_Content_Group_ShadowDistance_Img_Box_StaticGrid_TextureQuality_Group_SettingSelection_Btn_Off_Click = function(btn, str)
    CtrlPcGraphics:OnItemBtnClickShowdowDistance(btn, str)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_ShakeFigure_Img_Switch_Btn_Click_Click = function(btn, str)
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_BoxConfigUpload_Img_Switch_Btn_Click_Click = function(btn, str)
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Main_Img_Bg_StaticGrid_LanguageList_SetGrid = function(element, elementIndex)
    SwitchText:SetElement(element, elementIndex)
  end,
  Setting_Group_Language_ScrollView_Image_Viewport_Content_Group_Main_Img_Bg_StaticGrid_LanguageList_Group_LanguageSell_Btn_LanguageSell_Click = function(btn, str)
    SwitchText:ShowTips(tonumber(str))
  end,
  Setting_Group_Image_ScrollView_Image_Viewport_Content_Group_BattleVideo_Img_Switch_Btn_Click_Click = function(btn, str)
    DataModel:SetBattleVideo(DataModel.Now_BattleVideo)
  end
}
return ViewFunction
