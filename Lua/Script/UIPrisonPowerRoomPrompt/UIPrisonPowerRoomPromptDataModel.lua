local View = require("UIPrisonPowerRoomPrompt/UIPrisonPowerRoomPromptView")
local CommonItem = require("Common/BtnItem")
local DataModel = {}
DataModel.costList = {}

function DataModel.SetJsoData(json)
  if not json then
    return
  end
end

function DataModel.InitData()
  local installedNum = PrisonData.GetSeverPrisonData().power_socket_num
  local prisonCA = PrisonData.GetPrisonCA()
  for i, v in ipairs(prisonCA.prisonBuyElectricList) do
    if i > installedNum then
      local costListCA = PlayerData:GetFactoryData(v.consumeMaterial, "ListFactory")
      DataModel.costList = costListCA.electricMaterialList
      break
    end
  end
end

function DataModel.RefreshOnShow()
  local curPower = PrisonData.GetCurPower()
  local prisonData = PrisonData.GetSeverPrisonData()
  local installed = prisonData.power_socket_num
  local prisonCA = PlayerData:GetFactoryData(86800014, "PrisonFactory")
  local nextAddInfo = prisonCA.prisonBuyElectricList[installed + 1]
  local addPower = nextAddInfo and nextAddInfo.extraPower or 0
  View.Group_Prompt.Group_PowerTotal.Group_Total.Txt_Num:SetText(string.format(GetText(80608651), curPower, addPower))
  local costInfo = DataModel.costList[1]
  CommonItem:SetItem(View.Group_Prompt.Group_Material.Group_Item.Group_Item, costInfo)
  local ownNum = PlayerData:GetGoodsById(costInfo.id).num
  local needNum = costInfo.num
  local ownNumColor = ownNum < needNum and "#FF0000" or "FFFFFF"
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num1:SetText(needNum)
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num1:SetColor(ownNumColor)
  View.Group_Prompt.Group_Material.Group_Item.Group_Num.Txt_Num2:SetText(PlayerData:TransitionNum(ownNum))
  View.Group_Prompt.Group_Material.Group_Item.Group_Item.Btn_Item:SetClickParam(costInfo.id)
  costInfo = DataModel.costList[2]
  CommonItem:SetItem(View.Group_Prompt.Group_Material.Group_Item1.Group_Item, costInfo)
  ownNum = PlayerData:GetGoodsById(costInfo.id).num
  needNum = costInfo.num
  ownNumColor = ownNum < needNum and "#FF0000" or "FFFFFF"
  View.Group_Prompt.Group_Material.Group_Item1.Group_Num.Txt_Num1:SetText(needNum)
  View.Group_Prompt.Group_Material.Group_Item1.Group_Num.Txt_Num1:SetColor(ownNumColor)
  View.Group_Prompt.Group_Material.Group_Item1.Group_Num.Txt_Num2:SetText(PlayerData:TransitionNum(ownNum))
  View.Group_Prompt.Group_Material.Group_Item1.Group_Item.Btn_Item:SetClickParam(costInfo.id)
end

return DataModel
