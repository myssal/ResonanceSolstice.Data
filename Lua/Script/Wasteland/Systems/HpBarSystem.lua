local SystemBase = require("Wasteland/Systems/SystemBase")
local Class = require("UIDialog/MetatableClass")
local HpBarSystem = Class.New("HpBarSystem", SystemBase)

function HpBarSystem:Ctor()
  self.systemType = WastelandEnum.SystemType.HpBarSystem
  self.requiredComponents = {
    WastelandEnum.CompType.AttrComponent
  }
end

function HpBarSystem:RegisterEvents()
  WastelandEventManager:AddListener(WastelandEnum.Event.OnEntityCreate, self.OnEntityCreate, self)
end

function HpBarSystem:OnEntityCreate(entity)
  local hpBarTrans = entity.entityProduct:GetHpBar()
  if hpBarTrans then
    local hp = entity:GetAttrComp():GetAttr(WastelandEnum.Attr.Hp)
    if hp ~= 0 then
      self:RefreshHp(entity)
    end
  end
end

function HpBarSystem:Update(deltaTime)
  local entities = self:GetEntities()
  for i, entity in pairs(entities) do
    self:RefreshHp(entity)
  end
end

function HpBarSystem:RefreshHp(entity)
  local hpBarTrans = entity.entityProduct:GetHpBar()
  if not hpBarTrans or not hpBarTrans.gameObject.activeSelf then
    return
  end
  local GroupRoot = hpBarTrans.transform:GetComponent(typeof(CS.Seven.UIGroup))
  local Img_PB = hpBarTrans.transform:Find("Img_PB"):GetComponent(typeof(CS.Seven.UIImg))
  local Txt_Num = hpBarTrans.transform:Find("Txt_Num"):GetComponent(typeof(CS.Seven.UITxt))
  local camera = WasteLandManager.wasteLandCamera.mainCamera
  local worldCanvasTrans = CS.UnityEngine.GameObject.Find("WorldCanvas").transform
  local rectTransform = worldCanvasTrans:GetComponent(typeof(CS.UnityEngine.RectTransform))
  local pos = entity:GetContainerTrans().position - entity:GetViewTrans().localPosition
  local anchoredPosition = WasteLandManager:WorldToUIPointInRect(pos, rectTransform, camera)
  local viewCA = entity:GetViewCA()
  anchoredPosition.x = anchoredPosition.x + viewCA.hpBarOffsetX
  anchoredPosition.y = anchoredPosition.y + viewCA.hpBarOffsetY
  GroupRoot:SetAnchoredPosition(anchoredPosition)
  local hp = entity:GetAttrComp():GetAttr(WastelandEnum.Attr.Hp)
  local hpMax = entity:GetAttrComp():GetAttr(WastelandEnum.Attr.HpMax)
  if hpMax == 0 then
    hpMax = 1
  end
  Txt_Num:SetText(hp .. "/" .. hpMax)
  Img_PB:SetFilledImgAmount(hp / hpMax)
end

return HpBarSystem
