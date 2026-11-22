local View = require("UIWitchesShop/UIWitchesShopView")
local DataModel = {}
DataModel.eventId = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.eventId = data.eventId
  DataModel.selectInfo = data.selectInfo
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  local eventId = DataModel.eventId
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  View.Group_Stamina.Txt_Num:SetText(WitchData.GetStamina() .. "/" .. WitchData.GetStaminaMax())
  View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
  local showNpc = eventCA.eventNPC > 0
  if showNpc then
    local npcCA = PlayerData:GetFactoryData(eventCA.eventNPC, "NPCFactory")
    local showSpine = npcCA.spineUrl ~= ""
    View.Spine_Character:SetActive(showSpine)
    if showSpine then
      local scale = npcCA.spineScale
      View.Spine_Character:SetLocalScale(Vector3(scale, scale, 1))
      View.Spine_Character:SetAnchoredPosition(Vector2(npcCA.spineOffsetX, npcCA.spineOffsetY))
      View.Spine_Character:SetData(npcCA.spineUrl, "idle")
      View.Img_Character:SetActive(false)
    else
      local showImg = npcCA.resUrl ~= ""
      View.Img_Character:SetActive(showImg)
      if showImg then
        View.Img_Character:SetAnchoredPosition(Vector2(npcCA.offsetX, npcCA.offsetY))
        View.Img_Character:SetSprite(npcCA.resUrl)
      end
    end
  else
    View.Spine_Character:SetActive(false)
    View.Img_Character:SetActive(false)
  end
  View.StaticGrid_BuffList.grid.self:SetDataCount(table.count(DataModel.selectInfo))
  View.StaticGrid_BuffList.grid.self:RefreshAllElement()
end

return DataModel
