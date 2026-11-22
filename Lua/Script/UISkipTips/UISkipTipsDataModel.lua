local View = require("UISkipTips/UISkipTipsView")
local BtnItem = require("Common/BtnItem")
local DataModel = {}
DataModel.orderUid = nil
DataModel.orderId = nil
DataModel.remainTime = 0
local costItemId = 11400005

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.orderUid = data.orderUid
end

function DataModel.InitData()
  local orderData = PrisonData.GetPurchaseOrder(DataModel.orderUid)
  local orderId = orderData.prison_oid
  local orderCA = PlayerData:GetFactoryData(orderId, "PrisonProcurementFactory")
  local remainTime = orderData.purchase_ts + orderCA.costTime - TimeUtil.GetServerTimeStamp()
  DataModel.remainTime = remainTime
end

function DataModel.RefreshOnShow()
  DataModel.RefreshTime()
  BtnItem:SetItem(View.Group_Page2.Group_Des.Group_ItemEnergy, {id = costItemId})
  local itemCA = PlayerData:GetFactoryData(costItemId, "ItemFactory")
  local useNum = 0
  local prisonCA = PrisonData.GetPrisonCA()
  local time = DataModel.remainTime
  for i, v in ipairs(prisonCA.accelerationCostList) do
    if time >= v.stage then
      useNum = useNum + v.cost * math.ceil(v.stage / v.time)
      time = time - v.stage
    else
      useNum = useNum + v.cost * math.ceil(time / v.time)
      break
    end
  end
  local haveNum = PlayerData:GetGoodsById(costItemId).num
  View.Group_Page2.Group_Des.Txt_Des:SetText(string.format(GetText(80607867), itemCA.textIcon, useNum))
  View.Group_Page2.Img_Num.Txt_Num:SetText(string.format(GetText(80607871), haveNum))
end

function DataModel.RefreshTime()
  local time = DataModel.remainTime
  local timeTable = TimeUtil:SecondToTableHMS(time)
  View.Group_Page2.Group_Change.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTable.hour, timeTable.minute, timeTable.second))
  local useNum = 0
  local prisonCA = PrisonData.GetPrisonCA()
  for i, v in ipairs(prisonCA.accelerationCostList) do
    if time >= v.stage then
      useNum = useNum + v.cost * math.ceil(v.stage / v.time)
      time = time - v.stage
    else
      useNum = useNum + v.cost * math.ceil(time / v.time)
      break
    end
  end
  local itemCA = PlayerData:GetFactoryData(costItemId, "ItemFactory")
  View.Group_Page2.Group_Des.Txt_Des:SetText(string.format(GetText(80607867), itemCA.textIcon, useNum))
end

return DataModel
