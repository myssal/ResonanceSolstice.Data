local View = require("UIItemFloatInquirySettlement/UIItemFloatInquirySettlementView")
local DataModel = require("UIItemFloatInquirySettlement/UIItemFloatInquirySettlementDataModel")
local ViewFunction = require("UIItemFloatInquirySettlement/UIItemFloatInquirySettlementViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    local itemCA = PlayerData:GetFactoryData(params.id)
    local parkBuildingGrid = params.parkBuildingGrid
    local name
    local des = ""
    if params.type == "floatInquiry" then
      name = string.format(GetText(80610458), itemCA.name)
      if itemCA.carTips and itemCA.carTips > 0 then
        des = string.format(GetText(itemCA.carTips), itemCA.parkRounds)
      end
      View.Img_Item:SetSprite(itemCA.tipsPath)
    elseif params.type == "SealInquiry" then
      name = GetText(80610461)
      local parkCA = PlayerData:GetFactoryData(itemCA.parkBuildingGrid)
      local parkBuildingName = parkCA.name
      local sealCA
      if WitchData.GetWitchesData().map[tostring(parkBuildingGrid)] then
        local seal = WitchData.GetWitchesData().map[tostring(parkBuildingGrid)].seal
        if seal then
          sealCA = PlayerData:GetFactoryData(seal)
        end
      end
      des = string.format(GetText(80610462), parkBuildingName, sealCA.name)
      View.Img_Building:SetSprite(parkCA.pic)
    end
    View.Img_Building:SetActive(params.type == "SealInquiry")
    View.Img_Item:SetActive(params.type == "floatInquiry")
    View.Img_BGText.Txt_1:SetText(name)
    View.Img_BGText.Group_1.Txt_Dec:SetText(des)
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
