local View = require("UITenPulls/UITenPullsView")
local DataModel = require("UITenPulls/UITenPullsDataModel")
local ViewController = require("UITenPulls/UITenPullsViewController")
local sound
local ViewFunction = {
  TenPulls_Btn_BG_Click = function(btn, str)
    if DataModel.isShow == false then
      return
    end
    DataModel.isShow = false
    UIManager:GoBack(true, 1)
    if DataModel.Reward then
      CommonTips.OpenShowItem(DataModel.Reward)
    end
    RateHelper.TryOpenRatePop()
  end,
  TenPulls_StaticGrid_Role_SetGrid = function(element, elementIndex)
    local data = DataModel.Roles[elementIndex]
    local ca = data.ca
    element.Img_New:SetActive(data.isNew)
    element.Img_Rairty:SetSprite(UIConfig.RoleQuality[ca.qualityInt])
    element.Img_Bottom:SetSprite("UI\\Gacha\\gacha_bottom_rarity0" .. ca.qualityInt)
    element.Img_Character:SetSprite(PlayerData:GetFactoryData(ca.viewId, "UnitViewFactory").gacha)
    local tagCA = PlayerData:GetFactoryData(ca.sideId)
    if ca.qualityInt < 3 then
      element.Img_Camp:SetActive(true)
      element.Img_Camp2:SetActive(false)
      element.Img_Camp:SetSprite(tagCA.icon)
      element.Group_SR:SetActive(false)
      element.Group_SSR:SetActive(false)
    else
      element.Img_Camp:SetActive(false)
      element.Img_Camp2:SetActive(true)
      if ca.qualityInt == 3 then
        element.Img_Camp2:SetSprite(tagCA.gachaSRPath)
        element.Group_SR:SetActive(true)
        element.Group_SSR:SetActive(false)
      end
      if ca.qualityInt == 4 then
        element.Img_Camp2:SetSprite(tagCA.gachaSSRPath)
        element.Group_SR:SetActive(false)
        element.Group_SSR:SetActive(true)
      end
    end
  end,
  PlaySound = function(qualityInt)
    local tSoundId
    local tBGMConfig = PlayerData:GetFactoryData(99900002, "ConfigFactory")
    if tBGMConfig ~= nil then
      if qualityInt < 2 then
        tSoundId = tBGMConfig.jiesuanN
      elseif qualityInt < 3 then
        tSoundId = tBGMConfig.jiesuanR
      elseif qualityInt < 4 then
        tSoundId = tBGMConfig.jiesuanSR
      else
        tSoundId = tBGMConfig.jiesuanSSR
      end
      if tSoundId ~= nil then
        sound = SoundManager:CreateSound(tSoundId)
        if sound ~= nil then
          sound:Play()
        end
      end
    end
  end,
  TenPulls_Btn_Share_Click = function(btn, str)
    ViewController:OnBtnShare()
  end
}
return ViewFunction
