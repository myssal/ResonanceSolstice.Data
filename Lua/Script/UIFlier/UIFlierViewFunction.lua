local DataModel = require("UIFlier/UIFlierDataModel")
local View = require("UIFlier/UIFlierView")
local Controller = require("UIFlier/UIFlierController")
local ViewFunction = {
  Flier_GroupTopPanel_Group_TopLeft_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Flier_GroupTopPanel_Group_TopLeft_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Flier_GroupTopPanel_Group_TopRight_Group_Note_Btn_Tips_Click = function(btn, str)
  end,
  Flier_GroupTopPanel_Group_TopLeft_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Flier_GroupTopPanel_Group_TopLeft_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Flier_GroupTopPanel_Group_TopRight_Group_PassengerCapacity_Btn_Add_Click = function(btn, str)
  end,
  Flier_GroupTopPanel_Group_TopRight_Group_PassengerCapacity_Btn_Icon_Click = function(btn, str)
  end,
  Flier_GroupTopPanel_Group_TopRight_Group_Note_Btn__Click = function(btn, str)
  end,
  Flier_GroupSendStationPanel_Group_btn_Btn_Send_Click = function(btn, str)
    if PlayerData.GetLeafLetNum() == 0 then
      CommonTips.OpenTips(80601862)
      return
    end
    if PlayerData:GetCurPassengerNum() == PlayerData:GetMaxPassengerNum() then
      CommonTips.OpenTips(80602325)
      return
    end
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    if PosClickHandler.GetCoachDirtyPercent() < homeConfig.cleantwo then
      CommonTips.OpenFlierConditionTips({
        showType = EnumDefine.FlierConditionShowType.showNeedClean,
        stationId = DataModel.stationId
      })
    else
      Controller.RefreshSendPosPanel(true)
    end
  end,
  Flier_GroupSendPosPanel_StaticGrid_SetGrid = function(element, elementIndex)
    local info = DataModel.sendPosList[elementIndex]
    if info then
      local placeCfg = PlayerData:GetFactoryData(info.id, "ListFactory")
      DataModel.sendPosElementList[info.id] = element
      element.GroupInfo.Img_PlaceIcon:SetSprite(placeCfg.namePlaceIcon)
      element.GroupInfo.Group_.Txt_Name:SetText(placeCfg.namePlace)
      element.GroupInfo.Txt_Desc:SetText(GetText(placeCfg.PlaceDesc))
      if PlayerData.SolicitData.stationSendPosList[tostring(info.id)] then
        element.GroupLock:SetActive(false)
      else
        element.GroupLock:SetActive(true)
        element.GroupLock.Txt_Lock:SetText(string.format(GetText(80607608), placeCfg.unlockPlace))
      end
      element.GroupInfo.Btn_choose.Img_SelectImg:SetActive(false)
      element.GroupInfo.Btn_choose:SetClickParam(info.id)
    end
  end,
  Flier_GroupSendPosPanel_Btn_Confirm_Click = function(btn, str)
    Controller.RefreshSendNumPanel(true)
  end,
  Flier_GroupSendPosPanel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.RefreshSendPosPanel(false)
    Controller.RefreshSendStationPanel(true)
    Controller.RefreshCopyPanel(true)
    Controller.RefreshTopPanel(true)
  end,
  Flier_GroupSendPosPanel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Flier_GroupSendPosPanel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Flier_GroupSendPosPanel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Flier_GroupCopyNumPanel_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Flier_GroupCopyNumPanel_Btn_Min_Click = function(btn, str)
    View.GroupCopyNumPanel.Group_Slider.Slider_Value:SetSliderValue(1)
  end,
  Flier_GroupCopyNumPanel_Btn_Reduce_Click = function(btn, str)
    if DataModel.curSelectCopyFlierNum - 1 <= 0 then
      return
    end
    DataModel.curSelectCopyFlierNum = DataModel.curSelectCopyFlierNum - 1
    View.GroupCopyNumPanel.Group_Slider.Slider_Value:SetSliderValue(DataModel.curSelectCopyFlierNum)
  end,
  Flier_GroupCopyNumPanel_Group_Slider_Slider_Value_Slider = function(slider, value)
    local maxValue = DataModel.GetMaxCopyNum()
    DataModel.curSelectCopyFlierNum = math.floor(value)
    View.GroupCopyNumPanel.Group_Slider.Group_Num.Txt_Select:SetText(string.format("%d/%d", DataModel.curSelectCopyFlierNum, maxValue))
    local costCfg = PlayerData:GetFactoryData(99900061).leafletAddPay
    local count = View.GroupCopyNumPanel.CopyCostGroup.transform.childCount
    for i = 1, count do
      local costItem = View.GroupCopyNumPanel.CopyCostGroup["Cost" .. i]
      if costCfg[i] then
        local costNum = costCfg[i].num * DataModel.curSelectCopyFlierNum
        local format = costNum > PlayerData:GetUserInfo().gold and "<color=#FF0000>%d</color>" or "<color=#FFFFFF>%d</color>"
        costItem.Txt_Num:SetText(string.format(format, costNum))
        costItem.Img_Cost:SetSprite(PlayerData:GetFactoryData(costCfg[i].id, "ItemFactory").iconPath)
      end
    end
  end,
  Flier_GroupCopyNumPanel_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  Flier_GroupCopyNumPanel_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  Flier_GroupCopyNumPanel_Btn_Add_Click = function(btn, str)
    local remainCopyFlierNum = PlayerData.GetRemainCopyLeafLetNum()
    if remainCopyFlierNum < DataModel.curSelectCopyFlierNum + 1 then
      return
    end
    DataModel.curSelectCopyFlierNum = DataModel.curSelectCopyFlierNum + 1
    View.GroupCopyNumPanel.Group_Slider.Slider_Value:SetSliderValue(DataModel.curSelectCopyFlierNum)
  end,
  Flier_GroupCopyNumPanel_Btn_Max_Click = function(btn, str)
    View.GroupCopyNumPanel.Group_Slider.Slider_Value:SetSliderValue(View.GroupCopyNumPanel.Group_Slider.Slider_Value.slider.maxValue)
  end,
  Flier_GroupCopyNumPanel_Btn_Cancel_Click = function(btn, str)
    Controller.RefreshCopyNunPanel(false)
  end,
  Flier_GroupCopyNumPanel_Btn_Confirm_Click = function(btn, str)
    Controller.RefreshCopyNunPanel(false)
    Net:SendProto("station.overprint_leaflet", function(json)
      local copyNum = PlayerData.SolicitData.copyLeafletNum
      copyNum = copyNum + DataModel.curSelectCopyFlierNum
      PlayerData.SolicitData.copyLeafletNum = copyNum
      CommonTips.OpenShowItem(json.reward)
      if View.GroupSendStationPanel.self.IsActive then
        Controller.RefreshSendStationPanel(true)
      end
      if View.GroupTopPanel.self.IsActive then
        Controller.RefreshTopPanel(true)
      end
      if View.GroupCopyPanel.self.IsActive then
        Controller.RefreshCopyPanel(true)
      end
    end, DataModel.curSelectCopyFlierNum)
  end,
  Flier_Group_SendNum_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Flier_Group_SendNum_Group_chooseNum_Btn_Min_Click = function(btn, str)
    local leafletNum = PlayerData.GetLeafLetNum()
    local sendBasic = DataModel.sendBasic
    if leafletNum < sendBasic then
      CommonTips.OpenTips(80602322)
      return
    end
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value.self:SetSliderValue(1)
  end,
  Flier_Group_SendNum_Group_chooseNum_Btn_Reduce_Click = function(btn, str)
    local leafletNum = PlayerData.GetLeafLetNum()
    local sendBasic = DataModel.sendBasic
    if leafletNum < sendBasic then
      CommonTips.OpenTips(80602322)
      return
    end
    local num = DataModel.curSelectSendFlierNum - sendBasic
    if num <= 0 then
      return
    end
    DataModel.curSelectSendFlierNum = num
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value.self:SetSliderValue(math.floor(num / sendBasic))
  end,
  Flier_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_Slider = function(slider, value)
    local leafletNum = PlayerData.GetLeafLetNum()
    DataModel.curSelectSendFlierNum = math.floor(value) * DataModel.sendBasic
    View.Group_SendNum.Group_chooseNum.Group_Slider.Txt_Select:SetText(string.format("%d/%d", DataModel.curSelectSendFlierNum, leafletNum))
  end,
  Flier_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  Flier_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  Flier_Group_SendNum_Group_chooseNum_Btn_Add_Click = function(btn, str)
    local leafletNum = PlayerData.GetLeafLetNum()
    local sendBasic = DataModel.sendBasic
    if leafletNum < sendBasic then
      CommonTips.OpenTips(80602322)
      return
    end
    local num = DataModel.curSelectSendFlierNum + sendBasic
    if num > PlayerData.GetLeafLetNum() then
      return
    end
    DataModel.curSelectSendFlierNum = num
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value.self:SetSliderValue(math.floor(num / sendBasic))
  end,
  Flier_Group_SendNum_Group_chooseNum_Btn_Max_Click = function(btn, str)
    local leafletNum = PlayerData.GetLeafLetNum()
    local sendBasic = DataModel.sendBasic
    if leafletNum < sendBasic then
      CommonTips.OpenTips(80602322)
      return
    end
    local num = leafletNum - leafletNum % sendBasic
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value.self:SetSliderValue(math.floor(num / sendBasic))
  end,
  Flier_Group_SendNum_Btn_Cancel_Click = function(btn, str)
    Controller.RefreshSendNumPanel(false)
  end,
  Flier_Group_SendNum_Btn_Confirm_Click = function(btn, str)
    if DataModel.curSelectSendFlierNum < DataModel.sendBasic then
      CommonTips.OpenTips(80602322)
      return
    end
    Net:SendProto("station.attract_psg", function(json)
      local returnNum = json.return_leaflet and json.return_leaflet or 0
      PlayerData.SolicitData.leafletNum = PlayerData.SolicitData.leafletNum - DataModel.curSelectSendFlierNum + returnNum
      CommonTips.OpenFlierSendSuccess(json.passenger, json.furniture, 0)
    end, "leaflet", DataModel.selectSendStationId, DataModel.curSelectSendFlierNum, DataModel.curFlierSendStartPosId)
  end,
  Flier_GroupSendStationPanel_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local stationId = DataModel.sendStationList[elementIndex]
    local select = stationId == DataModel.selectSendStationId
    element.Group_choose:SetActive(select)
    if select then
      DataModel.selectSendStationElement = element
    end
    local stationCA = PlayerData:GetFactoryData(stationId, "HomeStationFactory")
    local serverStation = PlayerData:GetHomeInfo().stations[stationId]
    local curLv = serverStation.rep_lv or 0
    local lock = curLv < stationCA.leafletUnlock
    element.Group_lock:SetActive(lock)
    if lock then
      element.Group_lock.Txt_dec:SetText(string.format(GetText(80608574), stationCA.leafletUnlock))
    end
    element.Img_StationBg:SetSprite(stationCA.leafletMap)
    element.Img_cityPath:SetSprite(stationCA.cityMapIconPath)
    element.Group_placeTxt.Txt_:SetText(stationCA.name)
    element.Btn_Station:SetClickParam(stationId)
    DataModel.sendStationElementList[stationId] = element
    element.Group_GoldenWeek:SetActive(DataModel.activityStart and DataModel.StartCityList[stationId])
    element.Group_GoldenWeek.Img_Tag.Txt_En:SetActive(not CommonTips.IsResEN())
    element.Group_GoldenWeek.Img_Tag:SetSprite(DataModel.nowActivity.passengerIcon)
  end,
  Flier_GroupSendStationPanel_ScrollGrid_List_Group_SendStation_Btn_Station_Click = function(btn, str)
    local stationCA = PlayerData:GetFactoryData(str, "HomeStationFactory")
    local serverStation = PlayerData:GetHomeInfo().stations[str]
    local curLv = serverStation.rep_lv or 0
    local lock = curLv < stationCA.leafletUnlock
    if lock then
      CommonTips.OpenTips(80601860)
      return
    end
    if DataModel.selectSendStationId == str then
      return
    end
    if DataModel.selectSendStationElement then
      DataModel.selectSendStationElement.Group_choose:SetActive(false)
    end
    DataModel.selectSendStationElement = DataModel.sendStationElementList[str]
    DataModel.selectSendStationElement.Group_choose:SetActive(true)
    DataModel.selectSendStationId = str
  end,
  Flier_GroupCopyPanel_GroupBottom_Btn_Copy_Click = function(btn, str)
    if PlayerData.GetLeafLetNum() >= DataModel.maxHaveFlierNum then
      CommonTips.OpenTips(80607398)
      return
    elseif PlayerData.GetRemainCopyLeafLetNum() <= 0 then
      CommonTips.OpenTips(80607461)
      return
    end
    Controller.RefreshCopyNunPanel(true)
  end,
  Flier_Group_SendNum_GroupBottom_Btn_Copy_Click = function(btn, str)
    if PlayerData.GetLeafLetNum() >= DataModel.maxHaveFlierNum then
      CommonTips.OpenTips(80607398)
      return
    elseif PlayerData.GetRemainCopyLeafLetNum() <= 0 then
      CommonTips.OpenTips(80607461)
      return
    end
    Controller.RefreshCopyNunPanel(true)
    Controller.RefreshSendNumPanel(false)
  end,
  Flier_GroupSendPosPanel_StaticGrid_Group_SendPlace_GroupInfo_Btn_choose_Click = function(btn, str)
    View.GroupSendPosPanel.Img_CantConfirm:SetActive(false)
    if DataModel.selectSendPosElement then
      DataModel.selectSendPosElement.GroupInfo.Btn_choose.Img_SelectImg:SetActive(false)
    end
    DataModel.selectSendPosElement = DataModel.sendPosElementList[tonumber(str)]
    DataModel.selectSendPosElement.GroupInfo.Btn_choose.Img_SelectImg:SetActive(true)
    DataModel.curFlierSendStartPosId = str
  end
}
return ViewFunction
