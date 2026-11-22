local View = require("UIHomeCapsule/UIHomeCapsuleView")
local DataModel = require("UIHomeCapsule/UIHomeCapsuleDataModel")
local Controller = require("UIHomeCapsule/UIHomeCapsuleController")
local HomeStoreDataModel = require("UIHomeCapsule/UIHomeStoreDataModel")
local HomeStoreController = require("UIHomeCapsule/UIHomeStoreController")
local ViewFunction = require("UIHomeCapsule/UIHomeCapsuleViewFunction")
local tempParams
local Luabehaviour = {
  serialize = function()
    return Json.encode(tempParams)
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local t = Json.decode(initParams)
      tempParams = t
      Controller:ClearView()
      Controller:ChangeToView(1, t, true)
    elseif View.Group_HomeStore.self.IsActive then
      View.Group_HomeStore.Group_FurnitureStore.ScrollGrid_List.grid.self:RefreshAllElement()
      View.Group_HomeStore.Group_Right.StaticGrid_BQ.grid.self:RefreshAllElement()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.ReleaseDrag then
      local curPos = View.Group_ND.Drag_Center:GetAnchoredPositionX()
      if DataModel.dragStopTarPos < 0 and curPos < DataModel.dragStopTarPos or DataModel.dragStopTarPos == 0 and curPos > DataModel.dragStopTarPos then
        curPos = DataModel.dragStopTarPos
        View.Group_ND.Drag_Center:SetAnchoredPositionX(curPos)
        DataModel.ReleaseDrag = false
        DataModel.dragStopTarPos = nil
      else
        local dir = DataModel.dragStopTarPos - curPos
        local speed = dir * 0.2
        if 0 < speed and speed < 5 then
          speed = 5
        elseif speed < 0 and -5 < speed then
          speed = -5
        end
        curPos = curPos + speed
        View.Group_ND.Drag_Center:SetAnchoredPositionX(curPos)
      end
    end
    if DataModel.pickStatus == "get" and 0 >= DataModel.NDAnimeTime then
      Controller:PickAnime()
    elseif DataModel.pickStatus == "eggwait" and 0 >= DataModel.NDAnimeTime then
      DataModel.pickStatus = "waiteggopen"
      Controller:PickResult()
    elseif DataModel.pickStatus == "waiteggopen" and 0 >= DataModel.NDAnimeTime then
      DataModel.pickStatus = "rewardopen"
      Controller:ShowOpenEffect()
    elseif DataModel.pickStatus == "rewardopen" and 0 >= DataModel.NDAnimeTime then
      DataModel.pickStatus = "none"
      Controller:RewardTip()
    elseif DataModel.pickStatus == "none" then
    else
      DataModel.NDAnimeTime = DataModel.NDAnimeTime - Time.deltaTime
    end
  end,
  ondestroy = function()
    HomeStoreDataModel.List = {}
    DataModel.ConfirmType = nil
    DataModel.NeedNum = nil
    DataModel.StoreID = nil
    DataModel.CommodityId = nil
    DataModel.PickType = nil
    DataModel.NeedBuyMoney = nil
    DataModel.HDItemID = nil
    DataModel.NDItemID = nil
    DataModel.CostMoneyNum = nil
    DataModel.viewType = nil
    if DataModel.NDModel then
      CS.UnityEngine.GameObject.Destroy(DataModel.NDModel)
    end
    DataModel.NDModel = nil
    Controller.ClearShopBuyTempData()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
