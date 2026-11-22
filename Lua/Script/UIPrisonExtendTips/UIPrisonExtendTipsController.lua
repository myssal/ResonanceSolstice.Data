local View = require("UIPrisonExtendTips/UIPrisonExtendTipsView")
local DataModel = require("UIPrisonExtendTips/UIPrisonExtendTipsDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  View.Txt_PossessNum:SetText(DataModel.hadNum)
  local color = "#FFFFFF"
  if DataModel.hadNum == 0 then
    color = "#FF0000"
  end
  View.Txt_PossessNum:SetColor(color)
  local itemCA = PlayerData:GetFactoryData(DataModel.itemId)
  View.Txt_Name:SetText(itemCA.name)
  View.Img_Icon:SetSprite(itemCA.tipsPath)
  Controller:RefreshNumInfo()
end

function Controller:Sub()
  if DataModel.curUseNum == 1 then
    return
  end
  DataModel.curUseNum = DataModel.curUseNum - 1
  Controller:RefreshNumInfo()
end

function Controller:Add()
  if DataModel.curUseNum >= DataModel.hadNum then
    return
  end
  DataModel.curUseNum = DataModel.curUseNum + 1
  Controller:RefreshNumInfo()
end

function Controller:RefreshNumInfo()
  View.Txt_UseNum:SetText(DataModel.curUseNum)
  View.Txt_AddNum:SetText(string.format(GetText(80608674), DataModel.curUseNum * DataModel.oneAddNum))
end

function Controller:ClickItem()
  CommonTips.OpenItem({
    itemId = DataModel.itemId
  })
end

function Controller:UseItem()
  if DataModel.hadNum == 0 then
    CommonTips.OpenTips(80608991)
    return
  end
  local wareType = ""
  if DataModel.initParams.type == 1 then
    wareType = "material"
  elseif DataModel.initParams.type == 2 then
    wareType = "product"
  end
  local t = {}
  t[tostring(DataModel.itemId)] = DataModel.curUseNum
  Net:SendProto("prison.items_up_ware", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    if json.item_material_space then
      PlayerData.ServerData.user_prison_info.item_material_space = json.item_material_space
    end
    if json.item_product_space then
      PlayerData.ServerData.user_prison_info.item_product_space = json.item_product_space
    end
    PlayerData:RefreshUseItems(t)
    UIManager:GoBack()
    CommonTips.OpenTips(GetText(80608960))
  end, wareType, Json.encode(t))
end

function Controller:Return()
  UIManager:GoBack()
end

return Controller
