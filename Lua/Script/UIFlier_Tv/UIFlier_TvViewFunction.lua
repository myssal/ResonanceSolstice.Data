local View = require("UIFlier_Tv/UIFlier_TvView")
local DataModel = require("UIFlier_Tv/UIFlier_TvDataModel")
local ViewFunction = {
  Flier_Tv_Group_TopRight_Group_PassengerCapacity_Btn_Add_Click = function(btn, str)
  end,
  Flier_Tv_Group_TopRight_Group_PassengerCapacity_Btn_Icon_Click = function(btn, str)
  end,
  Flier_Tv_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if View.Group_Send.IsActive then
      DataModel.RefreshStation()
    else
      UIManager:GoBack()
    end
  end,
  Flier_Tv_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Flier_Tv_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Flier_Tv_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Flier_Tv_Group_Send_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local id = PlayerData.SolicitData.tvPool[elementIndex]
    local cfg = PlayerData:GetFactoryData(id, "PondFactory")
    element.Group_Content.Txt_Title:SetText(cfg.adName)
    element.Img_Icon:SetSprite(cfg.adIcon)
    if cfg.adDesc > 0 then
      local desc = PlayerData:GetFactoryData(cfg.adDesc, "TextFactory")
      element.Group_Content.Txt_Dec:SetText(desc.text)
    end
    if cfg.adItem[1] then
      local itemCfg = PlayerData:GetFactoryData(cfg.adItem[1].id, "ItemFactory")
      element.Group_Item.Group_Dec.Img_Item:SetSprite(itemCfg.iconPath)
      element.Group_Item.Group_Dec.Txt_Num:SetText("X" .. cfg.adItem[1].num)
    end
    element.Btn_Put:SetClickParam(id)
  end,
  Flier_Tv_Group_Send_ScrollGrid_List_Group_Magazine_Btn_Put_Click = function(btn, str)
    if PlayerData.SolicitData.tvSendNum <= 0 then
      CommonTips.OpenTips(80602323)
      return
    end
    local pondCfg = PlayerData:GetFactoryData(str, "PondFactory")
    for i, v in pairs(pondCfg.adItem) do
      if PlayerData:GetGoodsById(v.id).num < v.num then
        CommonTips.OpenTips(80600488)
        return
      else
        PlayerData.ServerData.items[tostring(v.id)].num = PlayerData.ServerData.items[tostring(v.id)].num - v.num
      end
    end
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    if PosClickHandler.GetCoachDirtyPercent() < homeConfig.cleantwo then
      CommonTips.OpenFlierConditionTips({
        showType = EnumDefine.FlierConditionShowType.showNeedClean,
        stationId = DataModel.stationId
      })
      return
    end
    Net:SendProto("station.attract_psg", function(json)
      PlayerData.SolicitData.tvSendNum = PlayerData.SolicitData.tvSendNum - 1
      CommonTips.OpenFlierSendSuccess(json.passenger, json.furniture, 2)
    end, "tv", DataModel.selectSendStationId, nil, nil, str)
  end,
  Flier_Tv_Group_Station_ScrollGrid_List_SetGrid = function(element, elementIndex)
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
  Flier_Tv_Group_Station_ScrollGrid_List_Group_SendStation_Btn_Station_Click = function(btn, str)
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
  Flier_Tv_Group_Station_Group_btn_Btn_Send_Click = function(btn, str)
    local advNum = PlayerData.ServerData.items["11400072"] and PlayerData.ServerData.items["11400072"].num or 0
    if 0 >= PlayerData.SolicitData.tvSendNum then
      CommonTips.OpenTips(80602323)
      return
    end
    if advNum <= 0 then
      CommonTips.OpenTips(80602324)
      return
    end
    if PlayerData:GetCurPassengerNum() >= PlayerData:GetMaxPassengerNum() then
      CommonTips.OpenTips(80602325)
      return
    end
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    if PosClickHandler.GetCoachDirtyPercent() < homeConfig.cleantwo then
      CommonTips.OpenFlierConditionTips({
        showType = EnumDefine.FlierConditionShowType.showNeedClean,
        stationId = DataModel.stationId
      })
      return
    end
    DataModel.RefreshSend()
  end
}
return ViewFunction
