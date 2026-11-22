local Timer = require("Common/Timer")
local View = require("UIStore/UIStoreView")
local DataModel = require("UIStore/UIStoreDataModel")
local Controller = require("UIStore/UIStoreDataController")
local ViewFunction = require("UIStore/UIStoreViewFunction")
local SignGiftController = require("UIStore/UIStoreController_SignGift")
local Luabehaviour = {
  serialize = function()
    local param = {}
    param.index = DataModel.TopIndex
    param.RefreshState = 1
    return Json.encode(param)
  end,
  deserialize = function(initParams)
    SdkReporter.TrackOpenUIStore()
    DataModel.Init()
    DataModel.SetRefreshTime()
    if initParams then
      local json = Json.decode(initParams)
      DataModel.TopIndex = DataModel.TopIndex or 1
      for k, v in pairs(DataModel.TagPanel) do
        View[v]:SetActive(false)
      end
      View.Btn_BlackMoon.Img_Red:SetActive(DataModel.GetStoreRedState(40300012))
      local shopIndex = 1
      local jumpParams = json.jumpParams
      if json.shopId then
        shopIndex = DataModel.GetStoreIndexByShopId(json.shopId)
      elseif jumpParams then
        local params = string.split(jumpParams, "|")
        shopIndex = 0 < #params and tonumber(params[1])
      end
      local shopId = DataModel.GetStoreIdByIndex(shopIndex)
      if DataModel.TopIndex ~= shopIndex and shopIndex then
        View[DataModel.TagPanel[DataModel.TopIndex]]:SetActive(false)
        View[DataModel.TagPanel[shopIndex]]:SetActive(true)
      end
      DataModel.RefreshState = json.RefreshState or 1
      DataModel.TopIndex = shopIndex or 1
      DataModel.GetStoreIndex(json.switchParameter)
      Controller.InitTopList()
      if json.subIndex ~= nil then
        local itemIndex
        if json.shopId == 80300323 or json.shopId == 80302554 then
          for i = 1, #DataModel.GiftStoreList do
            if tonumber(DataModel.GiftStoreList[i].id) == tonumber(json.subIndex) then
              itemIndex = i
              break
            end
          end
          if itemIndex ~= nil then
            Controller:ClickGiftStoreGroupGiftElement(nil, tostring(itemIndex))
          end
        elseif json.shopId == 80301713 then
          for i = 1, #DataModel.SkinPreStore do
            if tonumber(DataModel.SkinPreStore[i].id) == tonumber(json.subIndex) then
              itemIndex = i
              break
            end
          end
          if itemIndex ~= nil then
            Controller:ClickSkinPreStoreGroupNewGiftElement(nil, tostring(itemIndex))
          end
        end
      end
      DataModel.isMoveEnergyOpen = json.isMoveEnergyOpen
      if GameSetting.AdministrationsAddictionFeature then
        local grow = PlayerData:IsCheckYearOld(PlayerData:GetUserInfo().real_info.id_card)
        if grow < 18 then
          CommonTips.OpenAntiAddiction({index = 2})
        end
      end
      local jumpParams = json.jumpParams
      local giftId
      if jumpParams then
        local params = string.split(jumpParams, "|")
        giftId = 1 < #params and tonumber(params[2])
      end
      if DataModel.isMoveEnergyOpen or giftId then
        View.self:StartC(LuaUtil.cs_generator(function()
          coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
          local idx = -1
          local sold = false
          local data, labelIndex = DataModel:JunmpStorePageData(shopId, giftId)
          for i, v in ipairs(data) do
            if v.id == giftId then
              idx = i
              sold = v.isMax
              break
            end
            if giftId == nil then
              if v.id == 82100015 and v.isMax == false then
                idx = i
                break
              end
              if v.id == 82100021 and v.isMax == false then
                idx = i
              end
            end
          end
          if idx == -1 then
            UIManager:GoBack()
            return
          end
          if shopId == 80300323 or shopId == 80302554 then
            View.Group_GiftStore.NewScrollGrid_List.grid.self:MoveToPos(idx)
            if labelIndex then
              Controller:ClickGroupGiftGroupLabelElement(labelIndex, true)
            end
            if sold == false then
              Controller:ClickGiftStoreGroupGiftElement(nil, idx)
            end
          end
          if shopId == 80301713 then
            View.Group_SkinPreStore.NewScrollGrid_List.grid.self:MoveToPos(idx)
            if labelIndex then
              Controller:ClickGroupSkinLabelElement(labelIndex, true)
            end
            if sold == false then
              Controller:ClickSkinPreStoreGroupNewGiftElement(nil, idx)
            end
          end
          if shopId == 80305469 then
            local giftIndex
            for i, v in ipairs(DataModel.ExchangeStoreList) do
              if giftId == v.id then
                giftIndex = i
                break
              end
            end
            View.Group_Exchange.Group_Middle.ScrollGrid_List.grid.self:MoveToPos(giftIndex)
            Controller.JumpOpenExchangeTip(giftId)
          end
        end))
      end
    end
    View.timer = Timer.New(1, function()
      if DataModel.NextRefreshTime > 0 then
        DataModel.NextRefreshTime = DataModel.NextRefreshTime - 1
      elseif DataModel.IsNextRefresh then
        DataModel.IsNextRefresh = false
        Net:SendProto("shop.info", function(json)
          Controller.OpenStorePage()
          DataModel.SetRefreshTime()
        end)
      end
      if table.count(DataModel.TriggerTimeList) == 0 then
        return
      end
      for k, v in pairs(DataModel.TriggerTimeList) do
        if 0 < v.time then
          v.time = v.time - 1
          if 0 >= v.time then
            Controller.OpenStorePage()
          end
        end
      end
    end)
    View.timer:Start()
    Controller:Recharge()
    local showHomeBtn = not WitchData.inWitchMap
    View.Group_CommonTopLeft.Btn_Home:SetActive(showHomeBtn)
    if DataModel.TopIndex then
      View.ScrollGrid_TopButton.grid.self:MoveToPos(DataModel.TopIndex)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.timer then
      View.timer:Update()
    end
  end,
  ondestroy = function()
    DataModel:Clear()
    SignGiftController.Release()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
