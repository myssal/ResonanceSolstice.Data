local View = require("UIBuffInfo/UIBuffInfoView")
local DataModel = require("UIBuffInfo/UIBuffInfoDataModel")
local ViewFunction = require("UIBuffInfo/UIBuffInfoViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      View.Group_Buff:SetActive(not data.isEquip)
      View.Group_Weapon:SetActive(data.isEquip)
      if data.isEquip then
        local cfg = PlayerData:GetFactoryData(data.id, "RogueEquipmentFactory")
        View.Group_Weapon.Txt_Name:SetText(cfg.name)
        View.Group_Weapon.Img_Icon:SetSprite(cfg.iconPath)
        if cfg.isNegative then
          View.Group_Weapon.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/Red")
        else
          View.Group_Weapon.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/" .. cfg.quality)
        end
        View.Group_Weapon.ScrollView_Des.Viewport.Content.Txt_Des:SetText(cfg.des)
        local netData = PlayerData.TempCache.CubeRogueData.equips[data.id]
        netData.use = netData.use or 0
        netData.isDead = netData.orders == nil or table.count(netData.orders) == 0
        View.Group_Weapon.Group_Destroy:SetActive(netData.isDead)
        View.Group_Weapon.Group_Remaining:SetActive(0 < cfg.efficacyNum)
        if 0 < cfg.efficacyNum then
          View.Group_Weapon.Group_Remaining.Txt_Num:SetText(cfg.efficacyNum - netData.use)
        end
      else
        local buffCA = PlayerData:GetFactoryData(data.id)
        View.Group_Buff.Img_Icon:SetSprite(buffCA.iconPath)
        View.Group_Buff.Txt_Name:SetText(buffCA.name)
        View.Group_Buff.Img_Bg:SetSprite(DataModel.BuffBgQualityPath[buffCA.qualityInt + 1])
        View.Group_Buff.Img_Level:SetActive(true)
        View.Group_Buff.Img_Level2:SetActive(false)
        local teamCA = PlayerData:GetFactoryData(buffCA.correspondingTeam)
        View.Group_Buff.Img_Type:SetSprite(teamCA.tabIconPath)
        View.Group_Buff.Img_TypeIcon:SetSprite(teamCA.shadePath)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(teamCA.name)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(false)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(true)
        View.Group_Buff.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(buffCA.des)
      end
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
