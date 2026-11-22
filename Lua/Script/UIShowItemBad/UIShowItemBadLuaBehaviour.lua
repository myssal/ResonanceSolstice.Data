local View = require("UIShowItemBad/UIShowItemBadView")
local DataModel = require("UIShowItemBad/UIShowItemBadDataModel")
local ViewFunction = require("UIShowItemBad/UIShowItemBadViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local status = {}
    if initParams ~= nil and initParams ~= "" then
      status = Json.decode(initParams)
    end
    DataModel.Data = {}
    DataModel.Data = PlayerData:SortShowItem(status.rewards)
    if table.count(DataModel.Data) <= 15 then
      View.ScrollGrid_Items.self:SetEnable(false)
      View.ScrollGrid_Items.grid.self:SetStartCorner("Center")
    else
      View.ScrollGrid_Items.self:SetEnable(true)
      View.ScrollGrid_Items.grid.self:SetStartCorner("Left")
    end
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
      View.ScrollGrid_Items.grid.self:SetDataCount(table.count(DataModel.Data))
      View.ScrollGrid_Items.grid.self:RefreshAllElement()
      local row = View.ScrollGrid_Items.grid.self:GetRow()
      View.Group_300:SetActive(false)
      View.Group_580:SetActive(false)
      View.Group_800:SetActive(false)
      View.Group_890:SetActive(false)
      if row == 1 then
        View.Group_300:SetActive(true)
      elseif row == 2 then
        View.Group_580:SetActive(true)
      elseif row == 3 then
        View.Group_800:SetActive(true)
      else
        View.Group_890:SetActive(true)
      end
    end))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
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
