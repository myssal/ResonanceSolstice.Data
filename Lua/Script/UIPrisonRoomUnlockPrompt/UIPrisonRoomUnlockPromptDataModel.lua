local View = require("UIPrisonRoomUnlockPrompt/UIPrisonRoomUnlockPromptView")
local CommonItem = require("Common/BtnItem")
local DataModel = {}
DataModel.roomIndex = 1
DataModel.areaIndex = 1
DataModel.prisonCA = PrisonData.GetPrisonCA()

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.roomIndex = tonumber(data.roomIndex)
  DataModel.areaIndex = tonumber(data.areaIndex)
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  local costInfo = DataModel.prisonCA.buySpacePrice[1]
  local itemCA = PlayerData:GetFactoryData(costInfo.id)
  View.Group_Prompt.TextIcon_Unlock:SetText(string.format(GetText(80608518), itemCA.textIcon, costInfo.num))
  View.Group_Prompt.Group_PowerTotal.Group_Total.Txt_Num:SetText(PrisonData.GetCurPower())
  View.Group_Prompt.Group_PowerTotal.Group_Power.Txt_Num:SetText(string.format(GetText(80608430), PrisonData.GetUsePower(), DataModel.prisonCA.cellSpaceOccupyPower))
  CommonItem.SetItem(self, View.Group_Prompt.Group_Material.Group_Item.Group_Item, costInfo)
  local ownNum = PlayerData:GetGoodsById(costInfo.id).num
  local needNum = costInfo.num
  local ownNumColor = ownNum < needNum and "#FF0000" or "FFFFFF"
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num1:SetText(PlayerData:TransitionNum(needNum))
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num1:SetColor(ownNumColor)
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num2:SetText(PlayerData:TransitionNum(ownNum))
  View.Group_Prompt.Group_Material.Group_Item.Group_Item.Btn_Item:SetClickParam(costInfo.id)
end

return DataModel
