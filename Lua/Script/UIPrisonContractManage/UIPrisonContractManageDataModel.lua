local View = require("UIPrisonContractManage/UIPrisonContractManageView")
local DataModel = {}
DataModel.autoOpen = false

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.autoOpen = data.autoOpen
end

function DataModel.RefreshOnShow()
  local prisonCA = PrisonData.GetPrisonCA()
  local lv = PrisonData.GetPrisonLv()
  View.Group_PrisonLv.Txt_PrisonLv:SetText(string.format(GetText(80609538), lv))
  local cost = {}
  local prisonerList = PrisonData.GetPrisonPrisoners()
  for _, prisonerData in pairs(prisonerList) do
    local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id, "PrisonerFactory")
    for _, v in pairs(prisonerCA.prisonerCost) do
      if not cost[v.id] then
        cost[v.id] = v.num
      else
        cost[v.id] = cost[v.id] + v.num
      end
    end
  end
  local moneyCost = cost[11400001] or 0
  View.Group_Bond.Group_Cost.Txt_Num:SetText(moneyCost)
  local margin = PrisonData.GetMargin()
  local moneyMarginMax = DataModel.GetMarginMax()
  View.Group_Bond.Img_Decoration.Txt_Num:SetText(margin .. "/" .. moneyMarginMax)
  local rate = moneyMarginMax ~= 0 and margin / moneyMarginMax or 0
  View.Group_Bond.Img_Bar:SetFilledImgAmount(rate)
  View.Group_Bond.Img_BarPoint:SetAnchoredPosition(Vector2(-350 + 700 * rate, View.Group_Bond.Img_BarPoint:GetAnchoredPositionY()))
  View.Group_Bond.Img_BarPoint.Img_Normal:SetActive(rate >= prisonCA.shortageBondNum)
  View.Group_Bond.Img_BarPoint.Img_Shortage:SetActive(rate < prisonCA.shortageBondNum)
  local marginSwitchOn = PrisonData.GetMarginSwitch() == 1
  View.Group_Bond.Btn_AutoSelect:SetActive(marginSwitchOn)
  View.Group_Bond.Btn_Auto:SetActive(not marginSwitchOn)
  View.Group_CommonTopLeft:SetActive(DataModel.autoOpen)
end

function DataModel.GetMarginMax()
  local prisonCA = PrisonData.GetPrisonCA()
  for _, v in pairs(prisonCA.prisonCostPrice) do
    if v.id == 11400001 then
      return v.num
    end
  end
  return 0
end

return DataModel
