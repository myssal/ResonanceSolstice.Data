local View = require("UIPrison/UIPrisonView")
local DataModel = require("UIPrison/UIPrisonDataModel")
local ViewFunction = {
  Prison_Group_Btn_Btn_Function_Click = function(btn, str)
    DataModel.OpenRoomUI(str)
  end,
  Prison_Group_Btn_Btn_Upgrade_Click = function(btn, str)
    local function callBack()
      if not DataModel.powerRoomPosChange and tonumber(str) == 87500012 then
        local anchoredPosY = View.Group_Bg.ScrollView_:GetAnchoredPositionY()
        
        View.Group_Bg.ScrollView_:SetAnchoredPositionY(anchoredPosY + 70)
        View.Group_Btn:SetAnchoredPositionY(150)
        DataModel.powerRoomPosChange = true
      end
      View.Group_Btn:SetActive(false)
      UIManager:Open("UI/Prison/PrisonBuildingUpgrade/PrisonBuildingUpgrade", Json.encode({buildType = str}), function()
        View.Group_Btn:SetActive(true)
      end)
    end
    
    PrisonData.PrisonRefresh(callBack)
  end,
  Prison_Group_Btn_Btn_Acceleration_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonBuildingUpgrade/SelectItemAcculate", Json.encode({
      addSpeedType = 1,
      typeId = DataModel.selectTypeId
    }))
  end,
  Prison_Group_Btn_Btn_Faster_Click = function(btn, str)
    local typeId = tonumber(DataModel.selectTypeId)
    local costInfo
    local roomLvCfg = DataModel.GetRoomLvCfg(typeId)
    local remainTime = DataModel.GetRoomBuildRemainTime(typeId)
    local prisonCA = PrisonData.GetPrisonCA()
    for i, v in ipairs(prisonCA.diamondFaster) do
      if remainTime <= v.timeFaster then
        costInfo = v
        break
      end
    end
    if costInfo then
      local function yesFun()
        local function callBack()
          DataModel.UpgradeBuildImmediately(typeId)
        end
        
        PrisonData.UpgradeRoomImmediately(callBack, typeId, roomLvCfg.config, costInfo)
      end
      
      local itemCA = PlayerData:GetFactoryData(costInfo.diamond)
      CommonTips.OnPrompt(string.format(GetText(80607671), costInfo.diamondNum, itemCA.name), nil, nil, yesFun)
    end
  end,
  Prison_Btn_FocusClose_Click = function(btn, str)
    if DataModel.focus then
      local typeId = tonumber(DataModel.selectTypeId)
      DOTweenTools.DOLocalMove(View.Group_Bg.ScrollView_.transform, DataModel.focusBeforePos.x, DataModel.focusBeforePos.y, 0, 0.5)
      DOTweenTools.DOScaleCallback(View.Group_Bg.transform, 1, 0.5, function()
        View.Btn_FocusClose:SetActive(false)
        View.Img_BGTop:SetActive(true)
        View.Group_CommonTopLeft:SetActive(true)
        DataModel.selectTypeId = nil
      end)
      local ctr = DataModel.buildCtrList[typeId]
      if ctr.Group_Picked then
        ctr.Group_Picked:SetActive(false)
      end
      View.Group_Btn:SetActive(false)
      DataModel.focus = false
      DataModel.powerRoomPosChange = false
    end
  end,
  Prison_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    PrisonController.StopBgmSound()
    UIManager:GoBack()
  end,
  Prison_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Prison_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Prison_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304346}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation1_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(1, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation2_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(2, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation3_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(3, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation4_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(4, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation5_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(5, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Accomodation6_Click = function(btn, str)
    DataModel.OpenPrisonerRoom(6, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop1_Click = function(btn, str)
    DataModel.OpenProductRoom(1, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop2_Click = function(btn, str)
    DataModel.OpenProductRoom(2, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop3_Click = function(btn, str)
    DataModel.OpenProductRoom(3, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop4_Click = function(btn, str)
    DataModel.OpenProductRoom(4, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop5_Click = function(btn, str)
    DataModel.OpenProductRoom(5, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Workshop6_Click = function(btn, str)
    DataModel.OpenProductRoom(6, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopDW_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopRZ_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Energy_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_TransitCenter_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopZW_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopFR_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Shop_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Bond_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Canteen_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Medical_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Release_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_PrisonerList_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Exercise_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Punishment_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Visit_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Security_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_HYOrderStation_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_Purchase_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_WarehouseCP_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_WarehouseYL_Click = function(btn, str)
    DataModel.ClickRoom(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Group_Building_Btn_Stability_Click = function(btn, str)
    View.Btn_CloseTip:SetActive(true)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo:SetActive(true)
    local effectCfg = DataModel.prisonCA.roomStabilityEffect[1]
    if effectCfg then
      local prisonData = PrisonData.GetSeverPrisonData()
      local stability = prisonData.stability
      local normalNum = 0
      normalNum = stability - effectCfg.effectOneThreshold
      normalNum = 0 < normalNum and normalNum or 0
      normalNum = ClearFollowZero(normalNum * effectCfg.effectOneAdd * 100)
      local extraNum = 0
      extraNum = stability - effectCfg.effectTwoThreshold
      extraNum = 0 < extraNum and extraNum or 0
      extraNum = ClearFollowZero(extraNum * effectCfg.effectTwoAdd * 100)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo.Img_BG.Txt_:SetText(stability)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo.Img_BG.Group_Content.Txt_1:SetText(string.format(GetText(effectCfg.effectOneTextId), normalNum))
      View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo.Img_BG.Group_Content.Txt_2:SetText(string.format(GetText(effectCfg.effectTwoTextId), extraNum))
    end
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Group_Building_Btn_Obedience_Click = function(btn, str)
    View.Btn_CloseTip:SetActive(true)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo:SetActive(true)
    local effectCfg = DataModel.prisonCA.roomObedienceEffect[1]
    if effectCfg then
      local prisonData = PrisonData.GetSeverPrisonData()
      local obedience = prisonData.obedience
      local normalNum = 0
      normalNum = obedience - effectCfg.effectOneThreshold
      normalNum = 0 < normalNum and normalNum or 0
      normalNum = ClearFollowZero(normalNum * effectCfg.effectOneAdd * 100)
      local extraNum = 0
      extraNum = obedience - effectCfg.effectTwoThreshold
      extraNum = 0 < extraNum and extraNum or 0
      extraNum = ClearFollowZero(extraNum * effectCfg.effectTwoAdd * 100)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo.Img_BG.Txt_:SetText(obedience)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo.Img_BG.Group_Content.Txt_1:SetText(string.format(GetText(effectCfg.effectOneTextId), normalNum))
      View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo.Img_BG.Group_Content.Txt_2:SetText(string.format(GetText(effectCfg.effectTwoTextId), extraNum))
    end
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Group_Building_Btn_Safety_Click = function(btn, str)
    View.Btn_CloseTip:SetActive(true)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo:SetActive(true)
    local effectCfg = DataModel.prisonCA.roomSafetyEffect[1]
    if effectCfg then
      local prisonData = PrisonData.GetSeverPrisonData()
      local safety = prisonData.safety
      local normalNum = 0
      normalNum = safety - effectCfg.effectOneThreshold
      normalNum = 0 < normalNum and normalNum or 0
      normalNum = ClearFollowZero(normalNum * effectCfg.effectOneAdd * 100)
      local extraNum = 0
      extraNum = safety - effectCfg.effectTwoThreshold
      extraNum = 0 < extraNum and extraNum or 0
      extraNum = ClearFollowZero(extraNum * effectCfg.effectTwoAdd * 100)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo.Img_BG.Txt_:SetText(safety)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo.Img_BG.Group_Content.Txt_1:SetText(string.format(GetText(effectCfg.effectOneTextId), normalNum))
      View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo.Img_BG.Group_Content.Txt_2:SetText(string.format(GetText(effectCfg.effectTwoTextId), extraNum))
    end
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Group_Building_Btn_Hygiene_Click = function(btn, str)
    View.Btn_CloseTip:SetActive(true)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo:SetActive(true)
    local effectCfg = DataModel.prisonCA.roomHygieneEffect[1]
    if effectCfg then
      local prisonData = PrisonData.GetSeverPrisonData()
      local hygiene = prisonData.hygiene
      local normalNum = 0
      normalNum = hygiene - effectCfg.effectOneThreshold
      normalNum = 0 < normalNum and normalNum or 0
      normalNum = ClearFollowZero(normalNum * effectCfg.effectOneAdd * 100)
      local extraNum = 0
      extraNum = hygiene - effectCfg.effectTwoThreshold
      extraNum = 0 < extraNum and extraNum or 0
      extraNum = ClearFollowZero(extraNum * effectCfg.effectTwoAdd * 100)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo.Img_BG.Txt_:SetText(hygiene)
      View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo.Img_BG.Group_Content.Txt_1:SetText(string.format(GetText(effectCfg.effectOneTextId), normalNum))
      View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo.Img_BG.Group_Content.Txt_2:SetText(string.format(GetText(effectCfg.effectTwoTextId), extraNum))
    end
  end,
  Prison_Img_BGTop_Group_Level_Btn__Click = function(btn, str)
    UIManager:Open("UI/Prison/Overview/PrisonLevel/PrisonLevel")
  end,
  Prison_Img_BGTop_Group_Power_Btn__Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonBuildingUpgrade/PrisonBuildingUpgrade", Json.encode({buildType = 87500012}))
  end,
  Prison_Img_BGTop_Group_Prisoner_Btn__Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonerList/PrisonerList", Json.encode({Mode = "Prison"}))
  end,
  Prison_Btn_CloseTip_Click = function(btn, str)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_StabilityInfo:SetActive(false)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_ObedienceInfo:SetActive(false)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_SafetyInfo:SetActive(false)
    View.Group_Bg.ScrollView_.Viewport.Content.Group_HygieneInfo:SetActive(false)
    View.Btn_CloseTip:SetActive(false)
  end,
  Prison_Group_Navigation_Btn_Quest_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  Prison_Group_Navigation_Btn_Navigation_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonTask/PrisonTask", Json.encode({stationId = 83000017}))
  end,
  Prison_Group_NewBtn_Btn_LifeSkill_Click = function(btn, str)
    UIManager:Open("UI/LifeSkill/LifeSkill", Json.encode({type = 2}))
  end,
  Prison_Group_NewBtn_Btn_Warehouse_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse", Json.encode({openStationTab = 1}))
  end,
  Prison_Group_NewBtn_Btn_Purchase_Click = function(btn, str)
    local function callBack()
      UIManager:Open("UI/Prison/PurchaseOrder/PurchaseOrder")
    end
    
    PrisonData.PrisonRefresh(callBack)
  end,
  Prison_Group_NewBtn_Btn_Order_Click = function(btn, str)
    UIManager:Open("UI/Prison/HYOrderStation/HYOrderStation")
  end,
  Prison_Group_NewBtn_Btn_Shop_Click = function(btn, str)
    local shopList = {}
    for i, v in ipairs(DataModel.prisonCA.prisonStoreList) do
      table.insert(shopList, v.id)
    end
    local shopIds = table.concat(shopList, ",")
    Net:SendProto("shop.info", function(json)
      PlayerData:RefreshShops(json.shops)
      UIManager:Open("UI/Prison/PrisonShop/PrisonShop")
    end, shopIds)
  end,
  Prison_Group_NewBtn_Btn_Law_Click = function(btn, str)
  end,
  Prison_Group_Btn_Btn_Production_Click = function(btn, str)
    DataModel.OpenRoomUI(str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopDW_Group_Status_Btn_Get_Click = function(btn, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopRZ_Group_Status_Btn_Get_Click = function(btn, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopZW_Group_Status_Btn_Get_Click = function(btn, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopFR_Group_Status_Btn_Get_Click = function(btn, str)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopFR_Group_Status_Group_Item_Btn__Click = function(btn, str)
    DataModel.OpenRoomUI(87500019)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopZW_Group_Status_Group_Item_Btn__Click = function(btn, str)
    DataModel.OpenRoomUI(87500017)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopRZ_Group_Status_Group_Item_Btn__Click = function(btn, str)
    DataModel.OpenRoomUI(87500020)
  end,
  Prison_Group_Bg_ScrollView__Viewport_Content_Btn_MaterialWorkshopDW_Group_Status_Group_Item_Btn__Click = function(btn, str)
    DataModel.OpenRoomUI(87500018)
  end,
  Prison_Group_NewBtn_Btn_Pdd_Click = function(btn, str)
    UIManager:Open("UI/StageQuest/StageQuest", Json.encode({titleIndex = 4}))
  end
}
return ViewFunction
