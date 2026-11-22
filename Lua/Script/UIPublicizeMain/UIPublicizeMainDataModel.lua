local View = require("UIPublicizeMain/UIPublicizeMainView")
local DataModel = {}
DataModel.playgroundId = nil
DataModel.publicizeList = {}
DataModel.stationId = nil
DataModel.publicizeIndex = 1
DataModel.publicizeNum = 0
DataModel.publicizeType = nil
DataModel.publicizePondId = nil
DataModel.curHaveNum = 0
DataModel.basicNum = 1
DataModel.EnumPublicizeType = {leaflet = "leaflet", adv = "adv"}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.playgroundId = data.playgroundId or 87300002
end

function DataModel.InitData()
  if PlayerData:GetHomeInfo().station_info.status == -1 then
    DataModel.stationId = PlayerData:GetHomeInfo().station_info.sid
  end
  DataModel.publicizeList = {}
  local playgroundId = DataModel.playgroundId
  if playgroundId then
    local playGroundCA = PlayerData:GetFactoryData(playgroundId, "PlaygroundFactory")
    for i, v in ipairs(playGroundCA.PublicizeList) do
      table.insert(DataModel.publicizeList, {
        id = v.id
      })
    end
  end
  DataModel.publicizeIndex = 1
  DataModel.publicizeNum = 0
  DataModel.publicizeType = nil
  DataModel.EnumPublicizeWay = nil
  DataModel.curHaveNum = 0
  DataModel.basicNum = 1
end

function DataModel.RefreshOnShow()
  if not DataModel.playgroundId then
    return
  end
  local leafletNum = PlayerData.GetLeafLetNum()
  View.Group_TopRight.Group_Cerent.Txt_:SetText(leafletNum)
  local advNum = PlayerData:GetGoodsById(11400072).num
  View.Group_TopRight.Group_Adv.Txt_:SetText(advNum)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    local dataCount = #DataModel.publicizeList
    View.Group_Bg.NewScrollGrid_.grid.self:SetDataCount(dataCount)
    View.Group_Bg.NewScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Bg.NewScrollGrid_.grid.self:MoveToTop()
  end))
  View.Group_SendNum:SetActive(false)
  local homeCommon = require("Common/HomeCommon")
  homeCommon.SetPublicizePsgElement(View.Group_TopRight.Group_PassengerCapacity, DataModel.playgroundId)
end

function DataModel.Publicize(publicizeIndex)
  DataModel.publicizeIndex = publicizeIndex
  local info = DataModel.publicizeList[publicizeIndex]
  local pondCA = PlayerData:GetFactoryData(info.id, "PondFactory")
  DataModel.publicizePondId = info.id
  View.Group_SendNum:SetActive(true)
  View.Group_SendNum.Group_Tad.Group_Text:SetActive(pondCA.publicizeType ~= "leafletAndAdv")
  View.Group_SendNum.Group_Tad.Group_Adv:SetActive(pondCA.publicizeType == "leafletAndAdv")
  View.Group_SendNum.Group_Tad.Group_Leaflet:SetActive(pondCA.publicizeType == "leafletAndAdv")
  local remainCopyFlierNum = PlayerData.GetRemainCopyLeafLetNum()
  local format = 0 < remainCopyFlierNum and "<color=#FFFFFF>%d</color>" or "<color=#FF0000>%d</color>"
  View.Group_SendNum.Group_Item.Img_Leaflet.Img_jiayin.Txt_:SetText(string.format(GetText(80602527) .. format, remainCopyFlierNum))
  if pondCA.publicizeType ~= "leafletAndAdv" then
    local txt = ""
    if pondCA.publicizeType == "onlyLeaflet" then
      txt = GetText(80607841)
      DataModel.PublicizeSelectLeafLet()
    elseif pondCA.publicizeType == "onlyAdv" then
      txt = GetText(80607842)
      DataModel.PublicizeSelectAdv()
    end
    View.Group_SendNum.Group_Tad.Group_Text.Txt_:SetText(txt)
  else
    DataModel.PublicizeSelectLeafLet()
  end
end

function DataModel.PublicizeSelectLeafLet()
  View.Group_SendNum.Group_Tad.Group_Leaflet.Btn_On:SetActive(true)
  View.Group_SendNum.Group_Tad.Group_Leaflet.Btn_Off:SetActive(false)
  View.Group_SendNum.Group_Tad.Group_Adv.Btn_On:SetActive(false)
  View.Group_SendNum.Group_Tad.Group_Adv.Btn_Off:SetActive(true)
  View.Group_SendNum.Group_Item.Img_Leaflet:SetActive(true)
  View.Group_SendNum.Group_Item.Img_Adv:SetActive(false)
  View.Group_SendNum.Group_Item.Btn_Item:SetClickParam(11400070)
  local leafletNum = PlayerData.GetLeafLetNum()
  local playGroundCA = PlayerData:GetFactoryData(87300002, "PlaygroundFactory")
  local minValue = 0
  local maxValue = 0
  local selectNum = 0
  local basic = playGroundCA.parkLeafletNum
  if leafletNum >= basic then
    minValue = 1
    maxValue = math.floor(leafletNum / basic)
    selectNum = basic
  end
  View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetMinAndMaxValue(minValue, maxValue)
  View.Group_SendNum.Group_chooseNum.Btn_Add:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Add.Txt_:SetText("+" .. basic)
  View.Group_SendNum.Group_chooseNum.Btn_Reduce:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Reduce.Txt_:SetText("-" .. basic)
  View.Group_SendNum.Group_chooseNum.Btn_Min:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Max:SetClickParam(leafletNum)
  DataModel.publicizeType = DataModel.EnumPublicizeType.leaflet
  DataModel.curHaveNum = leafletNum
  DataModel.SelectPublicizeNum(selectNum)
  DataModel.basicNum = basic
  View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(selectNum / DataModel.basicNum))
end

function DataModel.PublicizeSelectAdv()
  View.Group_SendNum.Group_Tad.Group_Leaflet.Btn_On:SetActive(false)
  View.Group_SendNum.Group_Tad.Group_Leaflet.Btn_Off:SetActive(true)
  View.Group_SendNum.Group_Tad.Group_Adv.Btn_On:SetActive(true)
  View.Group_SendNum.Group_Tad.Group_Adv.Btn_Off:SetActive(false)
  View.Group_SendNum.Group_Item.Img_Leaflet:SetActive(false)
  View.Group_SendNum.Group_Item.Img_Adv:SetActive(true)
  View.Group_SendNum.Group_Item.Btn_Item:SetClickParam(11400072)
  local advNum = PlayerData:GetGoodsById(11400072).num
  local minValue = 0
  local maxValue = 0
  local selectNum = 0
  local basic = 1
  if advNum >= basic then
    minValue = 1
    maxValue = advNum
    selectNum = basic
  end
  View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetMinAndMaxValue(minValue, maxValue)
  View.Group_SendNum.Group_chooseNum.Btn_Add:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Add.Txt_:SetText("+" .. basic)
  View.Group_SendNum.Group_chooseNum.Btn_Reduce:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Reduce.Txt_:SetText("-" .. basic)
  View.Group_SendNum.Group_chooseNum.Btn_Min:SetClickParam(basic)
  View.Group_SendNum.Group_chooseNum.Btn_Max:SetClickParam(advNum)
  DataModel.publicizeType = DataModel.EnumPublicizeType.adv
  DataModel.curHaveNum = advNum
  DataModel.SelectPublicizeNum(selectNum)
  DataModel.basicNum = 1
  View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(selectNum / DataModel.basicNum))
end

function DataModel.SelectPublicizeNum(selectNum)
  local selectNumTxt = ""
  if selectNum == 0 then
    selectNumTxt = "<color=#FF0000>0</color>"
  else
    selectNumTxt = string.format("<color=#FFFFFF>%d</color>", selectNum)
  end
  DataModel.publicizeNum = selectNum
  View.Group_SendNum.Group_chooseNum.Group_Slider.Txt_Select:SetText(selectNumTxt .. "/" .. DataModel.curHaveNum)
end

return DataModel
