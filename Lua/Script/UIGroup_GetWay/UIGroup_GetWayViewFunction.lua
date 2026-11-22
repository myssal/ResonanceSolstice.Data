local View = require("UIGroup_GetWay/UIGroup_GetWayView")
local DataModel = require("UIGroup_GetWay/UIGroup_GetWayDataModel")
local funcCommon = require("Common/FuncCommon")
local ViewFunction = {
  Group_GetWay_Btn_Back_Click = function(btn, str)
    View.self:Confirm()
    View.self:CloseUI()
  end,
  Group_GetWay_Img_WayBg_ScrollGrid__SetGrid = function(element, elementIndex)
    local indexId = tonumber(elementIndex)
    local content = DataModel.getwayList[indexId].DisplayName
    local UIpath = DataModel.getwayList[indexId].UIName
    local funcId = DataModel.getwayList[indexId].funcId
    local btnContent = GetText(80602159)
    local isUnlock = true
    if funcId ~= -1 then
      isUnlock = funcCommon.FuncActiveCheck(funcId, false)
      if not isUnlock then
        btnContent = GetText(80602158)
      end
    end
    if UIpath ~= "" and isUnlock == true then
      element.Group_Text:SetActive(false)
      element.Group_Forward:SetActive(true)
      element.Group_Forward.Btn_Forward:SetClickParam(elementIndex)
      element.Group_Forward.Txt_WayEg:SetText(content)
    else
      element.Group_Text:SetActive(true)
      element.Group_Text.Img_None.Txt_Forwad:SetText(btnContent)
      element.Group_Forward:SetActive(false)
      element.Group_Text.Txt_WayEg:SetText(content)
    end
  end,
  Group_GetWay_Img_WayBg_ScrollGrid__Group_Item_Group_Forward_Btn_Forward_Click = function(btn, str)
    local indexId = tonumber(str)
    local UIpath = DataModel.getwayList[indexId].UIName
    local jumpParams = DataModel.getwayList[indexId].Way3
    local index2StoreIdList = {
      [1] = 80300924,
      [2] = 80300003,
      [3] = 80300323,
      [4] = 80301713,
      [5] = 80302554,
      [6] = 80300004,
      [7] = 80305469
    }
    if UIpath == "UI/Store/Store" then
      Net:SendProto("shop.info", function(json)
        json.shopId = index2StoreIdList[2]
        if jumpParams ~= "" then
          json.jumpParams = jumpParams
          local params = string.split(jumpParams, "|")
          json.shopId = index2StoreIdList[tonumber(params[1])]
        end
        if DataModel.isTrainWeapon then
          UIManager:GoBack(false)
        end
        UIManager:Open("UI/Store/Store", Json.encode(json))
      end)
      return
    end
    if UIpath == "UI/Prison/PrisonShop/PrisonShop" then
      local prisonData = PrisonData.GetSeverPrisonData()
      if not prisonData then
        CommonTips.OpenTips(80609539)
        return
      end
      local shopList = {}
      local prisonCfg = PrisonData.GetPrisonCA()
      for i, v in ipairs(prisonCfg.prisonStoreList) do
        table.insert(shopList, v.id)
      end
      local shopIds = table.concat(shopList, ",")
      Net:SendProto("shop.info", function(json)
        PlayerData:RefreshShops(json.shops)
        local params = string.split(jumpParams, "|")
        UIManager:Open("UI/Prison/PrisonShop/PrisonShop", Json.encode({
          openTab = params[1],
          jumpCommodityId = params[2]
        }))
      end, shopIds)
      return
    end
    if UIpath == "UI/Prison/MaterialProduction/MaterialProductionEdit" then
      local params = string.split(jumpParams, "|")
      local roomTypeId = params[1]
      if not PlayerData.ServerData.user_prison_info or next(PlayerData.ServerData.user_prison_info) == nil then
        CommonTips.OpenTips(80609539)
        return
      end
      local roomData = PlayerData.ServerData.user_prison_info.rooms
      if not roomData[roomTypeId] then
        CommonTips.OpenTips(80610012)
        return
      else
        local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
        local remainTime = UIPrisonDataModel.GetRoomBuildRemainTime(roomTypeId)
        if 0 < remainTime and roomData[roomTypeId].lv == 1 then
          CommonTips.OpenTips(80610012)
          return
        end
      end
      UIManager:Open(UIpath, Json.encode({
        roomTypeId = roomTypeId,
        jumpFormulaId = params[2]
      }))
      return
    end
    if UIpath == "UI/BP_Quest/BattlePass_Quest" and PlayerData:GetNowPassData() == false then
      CommonTips.OpenTips(80602313)
      return
    end
    if UIpath == "UI/HomeBattleCenter/ConstructStage/ConstructStage" then
      local StationId
      local Index = 1
      if jumpParams ~= "" then
        local params = string.split(jumpParams, "|")
        StationId = tonumber(params[1])
        Index = tonumber(params[2])
      end
      if StationId == nil then
        error("\231\188\186\229\176\145\232\189\166\231\171\153\233\133\141\231\189\174")
      end
      local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
      if StationId ~= TradeDataModel.EndCity then
        local prisonOpen = PrisonData.curStationPlace and 0 < PrisonData.curStationPlace
        local prisonRoomIndex = PrisonData.roomIndex
        UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
          if prisonOpen then
            PrisonData.jumpReturnRoomIndex = prisonRoomIndex
          end
          UIManager:GoBack()
        end)
        local MapController = require("UIHome/UIHomeMapController")
        MapController:AutoToClickStation(StationId, true)
        return
      end
      local row = {}
      row.stationId = StationId
      row.index = Index
      CommonTips.OpenConstructStage(row)
      return
    end
    if UIpath == "UI/ExchangeStation/ExchangeStation" then
      local BuildId
      local commodityId = -1
      if jumpParams ~= "" then
        local params = string.split(jumpParams, "|")
        BuildId = tonumber(params[1])
        commodityId = tonumber(params[2])
      end
      if BuildId ~= nil then
        local buildCA = PlayerData:GetFactoryData(BuildId)
        local stationId = buildCA.stationId
        local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
        if stationId == TradeDataModel.EndCity and PlayerData.IsInStation() then
          local storeList = buildCA.exchangeStoreList
          local storeId, remainTime, isOpen
          for i = 1, #storeList do
            isOpen, remainTime = PlayerData:IsStoreOpen(storeList[i].id)
            if isOpen then
              storeId = storeList[i].id
              break
            end
          end
          if not isOpen then
            return
          end
          Net:SendProto("shop.info", function(json)
            local stationCA = PlayerData:GetFactoryData(stationId)
            UIManager:Open(UIpath, Json.encode({
              buildingId = buildCA.id,
              IsCityMapIn = false,
              name = stationCA.name,
              initMode = "Exchange",
              initItem = commodityId
            }))
          end, storeId)
        else
          do
            local prisonOpen = PrisonData.curStationPlace and 0 < PrisonData.curStationPlace
            local prisonRoomIndex = PrisonData.roomIndex
            UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
              if prisonOpen then
                PrisonData.jumpReturnRoomIndex = prisonRoomIndex
              end
              UIManager:GoBack()
            end)
            local MapController = require("UIHome/UIHomeMapController")
            MapController:AutoToClickStation(stationId, true)
          end
        end
      else
        error("\231\188\186\229\176\145\229\187\186\231\173\145\233\133\141\231\189\174")
      end
      return
    end
    if UIpath == "UI/HomeBattleCenter/HomeBattleCenter" then
      local stationId
      local commodityId = -1
      local bubbleId = -1
      if jumpParams ~= "" then
        local params = string.split(jumpParams, "|")
        stationId = tonumber(params[1])
        bubbleId = tonumber(params[2])
        commodityId = tonumber(params[3])
      end
      if stationId ~= nil then
        local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
        if stationId == TradeDataModel.EndCity and PlayerData.IsInStation() then
          local bubbleCA = PlayerData:GetFactoryData(bubbleId)
          local t = {}
          t.stationId = stationId
          t.buildingId = bubbleCA.buildingId
          t.npcId = bubbleCA.npcId
          t.bgPath = bubbleCA.bgPath
          t.bgColor = bubbleCA.bgColor
          t.isCityMapIn = false
          t.name = bubbleCA.name
          t.textId = bubbleCA.textId
          t.initGroup = "Group_Exchange"
          t.initItem = commodityId
          UIManager:Open(bubbleCA.uiPath, Json.encode(t))
        else
          local prisonOpen = PrisonData.curStationPlace and 0 < PrisonData.curStationPlace
          local prisonRoomIndex = PrisonData.roomIndex
          UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
            if prisonOpen then
              PrisonData.jumpReturnRoomIndex = prisonRoomIndex
            end
            UIManager:GoBack()
          end)
          local MapController = require("UIHome/UIHomeMapController")
          MapController:AutoToClickStation(stationId, true)
        end
      else
        error("\231\188\186\229\176\145\232\189\166\231\171\153\233\133\141\231\189\174")
      end
      return
    end
    if UIpath == "UI/HomeReputation/HomeReputation" then
      local stop_info = PlayerData:GetHomeInfo().station_info.stop_info
      local targetStationId = -1
      local rep = 0
      if jumpParams ~= "" then
        local params = string.split(jumpParams, "|")
        targetStationId = tonumber(params[1])
        rep = tonumber(params[2])
      end
      if stop_info ~= nil and stop_info[2] == -1 then
        local stationId = tonumber(stop_info[1])
        if 0 < targetStationId then
          local ca = PlayerData:GetFactoryData(targetStationId)
          if stationId == targetStationId or stationId == ca.attachedToCity then
            UIManager:Open(UIpath, Json.encode({stationId = targetStationId, rep = rep}))
            return
          end
        end
      end
      local prisonOpen = PrisonData.curStationPlace and 0 < PrisonData.curStationPlace
      local prisonRoomIndex = PrisonData.roomIndex
      UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
        if prisonOpen then
          PrisonData.jumpReturnRoomIndex = prisonRoomIndex
        end
        UIManager:GoBack()
      end)
      local MapController = require("UIHome/UIHomeMapController")
      if 0 < targetStationId then
        MapController:AutoToClickStation(targetStationId, true)
      end
      return
    end
    if UIpath == "UI/HomeTrade/HomeTrade" then
      local stop_info = PlayerData:GetHomeInfo().station_info.stop_info
      local targetStationId = -1
      local rep = 0
      if jumpParams ~= "" then
        local params = string.split(jumpParams, "|")
        targetStationId = tonumber(params[1])
      end
      if stop_info ~= nil and stop_info[2] == -1 then
        local stationId = tonumber(stop_info[1])
        if 0 < targetStationId and stationId == targetStationId then
          local homeCommon = require("Common/HomeCommon")
          local stateInfo = homeCommon.GetCityStateInfo(targetStationId)
          if stateInfo and 0 < stateInfo.cityMapId then
            local ca = PlayerData:GetFactoryData(stateInfo.cityMapId)
            if ca then
              for _, v in ipairs(ca.bubbleList) do
                local bubbleCA = PlayerData:GetFactoryData(v.id)
                if bubbleCA.btnType == "HomeTrade" then
                  local t = {}
                  t.stationId = targetStationId
                  t.buildingId = bubbleCA.buildingId
                  t.npcId = bubbleCA.npcId
                  t.bgPath = bubbleCA.bgPath
                  t.bgColor = bubbleCA.bgColor
                  t.name = bubbleCA.name
                  t.textId = bubbleCA.textId
                  t.autoOpenTrade = true
                  UIManager:Open(UIpath, Json.encode(t))
                end
              end
            end
            return
          end
        end
      end
      local prisonOpen = PrisonData.curStationPlace and 0 < PrisonData.curStationPlace
      local prisonRoomIndex = PrisonData.roomIndex
      UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
        if prisonOpen then
          PrisonData.jumpReturnRoomIndex = prisonRoomIndex
        end
        UIManager:GoBack()
      end)
      local MapController = require("UIHome/UIHomeMapController")
      if 0 < targetStationId then
        MapController:AutoToClickStation(targetStationId, true)
      end
      return
    end
    if UIpath == "UI/Activity/ActivityMain" and jumpParams ~= "" then
      UIManager:Open(UIpath, Json.encode({
        id = tonumber(jumpParams)
      }))
      return
    end
    if UIpath == "UI/Activity/ActivitySafe/FastBattle" and jumpParams ~= "" then
      local params = string.split(jumpParams, "|")
      local p1 = tonumber(params[1])
      local p2 = tonumber(params[2])
      local p3 = tonumber(params[3])
      local ps = {}
      local Act_DataModel = require("UIActivitySafe/UIActivitySafeDataModel")
      local XS_DataModel = require("UIFastBattle/UIFastBattleXSDataModel")
      ps.getWayUIParamData = {}
      ps.getWayUIParamData.openType = (p1 == 1 or p1 == 3) and 1 or 2
      if p1 == 2 then
        ps.getWayUIParamData.curSafeType = nil
      else
        ps.getWayUIParamData.curSafeType = p1 == 1 and 1 or 2
      end
      if ps.getWayUIParamData.openType == 1 then
        if p1 == 1 then
          local selectIndex = Act_DataModel.SafeBuildId2Index(p2)
          if selectIndex == 0 then
            ps.getWayUIParamData.curSelectIndex = 1
            ps.getWayUIParamData.curLevelSelectIdx = 1
          else
            ps.getWayUIParamData.curSelectIndex = selectIndex
            ps.getWayUIParamData.targetTabId = p3
          end
          UIManager:Open(UIpath, Json.encode(ps))
          if selectIndex == 0 then
            CommonTips.OpenTips(80611127)
          end
        elseif p1 == 3 then
          local selectIndex = Act_DataModel.SafeBuildId2Index(p2)
          Net:SendProto("building.level", function(json)
            local result = 0
            local rewardList = XS_DataModel.GetRewardLevels(json.special_level.reward_level)
            if rewardList[p2] then
              for i, v in ipairs(rewardList[p2]) do
                if tonumber(v.id) == p3 then
                  result = i
                end
              end
            end
            if result == 0 then
              ps.getWayUIParamData.curSelectIndex = selectIndex
              ps.getWayUIParamData.curXsIndex = 1
            else
              ps.getWayUIParamData.curSelectIndex = selectIndex
              ps.getWayUIParamData.curXsIndex = result
            end
            UIManager:Open(UIpath, Json.encode(ps))
            if result == 0 then
              CommonTips.OpenTips(80611126)
            end
          end, nil)
          return
        end
      else
        local selectIndex = Act_DataModel.BattleBuildId2Index(p2)
        if selectIndex == 0 then
          ps.getWayUIParamData.curSelectIndex = 1
          ps.getWayUIParamData.targetTabId = p3
        else
          ps.getWayUIParamData.curSelectIndex = selectIndex
          ps.getWayUIParamData.targetTabId = p3
        end
        UIManager:Open(UIpath, Json.encode(ps))
        if selectIndex == 0 then
          CommonTips.OpenTips(80611127)
          selectIndex = 1
        end
      end
      return
    end
    if DataModel.isTrainWeapon then
      UIManager:GoBack(false)
    end
    if jumpParams ~= "" then
      local data = {jumpParams = jumpParams}
      local id = tonumber(jumpParams)
      local isMake = false
      if id and DataManager:GetFactoryNameById(id) == "ProductionFactory" then
        data = DataModel.GetMakeFurSkipInfo(id)
        if data.notfind then
          UIManager:Open("UI/Home_MachiningMenu/Home_MachiningMenu")
          CommonTips.OpenTips(80609971)
          return
        end
        if data.lock then
          UIManager:Open(UIpath, Json.encode(data))
          CommonTips.OpenTips(80608624)
          return
        end
        isMake = true
      end
      local skipPanel = UIManager:GetPanel(UIpath)
      if isMake and skipPanel and skipPanel.IsActive then
        local path = UIManager:GetCurrentPanelURL()
        if path == UIpath then
          UIManager:CloseTip()
          UIManager:CloseTip()
        else
          UIManager:GoBack(false)
        end
        require("UIHome_MachiningLathe/HomeMakeFurController").OpenChoosePanel(data.productionId)
      else
        UIManager:Open(UIpath, Json.encode(data))
      end
    else
      if UIpath == "UI/Prison/PurchaseOrder/PurchaseOrder" then
        local prisonData = PrisonData.GetSeverPrisonData()
        if not prisonData then
          CommonTips.OpenTips(80609539)
          return
        end
      end
      UIManager:Open(UIpath)
    end
  end
}
return ViewFunction
