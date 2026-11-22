local View = require("UIGachaNew/UIGachaNewView")
local DataModel = require("UIGachaNew/UIGachaNewDataModel")
local ViewFunction = require("UIGachaNew/UIGachaNewViewFunction")
local Controller = require("UIGachaNew/UIGachaNewController")
local Luabehaviour = {
  serialize = function()
    local t = {}
    t.index = DataModel.Index
    t.tabIndex = DataModel.TabIndex
    return Json.encode(t)
  end,
  deserialize = function(initParams)
    View.Img_Mask:SetActive(false)
    View.self:PlayAnim("In")
    DataModel.ItemLimitTime = -1
    Controller:Init()
    if initParams == nil or type(Json.decode(initParams)) ~= "table" and tonumber(Json.decode(initParams)) == nil then
      local tabIndex, index
      if PlayerData.Last_GachaId then
        tabIndex, index = Controller:GetIndex(PlayerData.Last_GachaId)
        PlayerData.Last_GachaId = nil
      end
      Controller:ClickTabBtn(tabIndex, index, true)
    else
      local param = Json.decode(initParams)
      local index
      local tabIndex = 1
      if type(param) ~= "table" then
        index = tonumber(param)
      else
        local poolId = param.poolId
        if poolId == nil then
          index = param.index
          tabIndex = param.tabIndex
        else
          tabIndex, index = Controller:GetIndex(poolId)
        end
      end
      if index == nil then
        index = 1
      end
      Controller:ClickTabBtn(tabIndex, index, true)
    end
    for k, v in pairs(DataModel.TabType) do
      local dataList = DataModel.CardPool[v]
      if dataList == nil or #dataList == 0 then
        if v == DataModel.TabType.Activaty then
          View.ScrollView_Tab.Viewport.Content.Btn_Activity.self:SetActive(false)
        elseif v == DataModel.TabType.Plot then
          View.ScrollView_Tab.Viewport.Content.Btn_Plot.self:SetActive(false)
        elseif v == DataModel.TabType.Permanent then
          View.ScrollView_Tab.Viewport.Content.Btn_Permanent.self:SetActive(false)
        end
      else
        local isShowRed = false
        for i1, v1 in pairs(dataList) do
          isShowRed = isShowRed or v1.red
          if isShowRed then
            break
          end
        end
        if v == DataModel.TabType.Activaty then
          View.ScrollView_Tab.Viewport.Content.Btn_Activity.self:SetActive(true)
          View.ScrollView_Tab.Viewport.Content.Btn_Activity.Img_Remind:SetActive(isShowRed)
        elseif v == DataModel.TabType.Plot then
          View.ScrollView_Tab.Viewport.Content.Btn_Plot.self:SetActive(true)
          View.ScrollView_Tab.Viewport.Content.Btn_Plot.Img_Remind:SetActive(isShowRed)
        elseif v == DataModel.TabType.Permanent then
          View.ScrollView_Tab.Viewport.Content.Btn_Permanent.self:SetActive(true)
          View.ScrollView_Tab.Viewport.Content.Btn_Permanent.Img_Remind:SetActive(isShowRed)
        end
      end
    end
    View.Group_BuyItem.self:SetActive(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    for i, v in pairs(DataModel.CardPool) do
      for i1, v1 in pairs(v) do
        if v1.detail.timeFunc ~= nil then
          EventManager:RemoveOnSecondEvent(v1.detail.timeFunc)
          v1.detail.timeFunc = nil
        end
        if v1.detail.timeFunc1 ~= nil then
          EventManager:RemoveOnSecondEvent(v1.detail.timeFunc1)
          v1.detail.timeFunc1 = nil
        end
      end
    end
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
