local View = require("UIEquipSelected/UIEquipSelectedView")
local DataModel = require("UIEquipSelected/UIEquipSelectedDataModel")
local ViewFunction = require("UIEquipSelected/UIEquipSelectedViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      print_r(data)
      DataModel.Data = data
      DataModel.Type = tonumber(data.Type)
      DataModel.Index = tonumber(data.Index)
      DataModel.RoleId = tonumber(data.RoleId)
      DataModel.ResidueNum = tonumber(data.residueNum)
      DataModel.Effect = data.effect or 1
      DataModel.IsCompare = data.IsCompare == true
      DataModel.Squads = data.Squads
    end
    print_r(DataModel)
    print_r("\232\163\133\229\164\135\233\128\137\230\139\169\231\149\140\233\157\162\231\154\132\230\149\176\230\141\174-----------------------------")
    local t = DataModel:GetEquipmentType(true)
    View.ScrollGrid_Equipment.grid.self:MoveToTop()
    View.ScrollGrid_Equipment.grid.self:SetDataCount(#t)
    View.ScrollGrid_Equipment.grid.self:RefreshAllElement()
    View.self:PlayAnim("EquipSelectedIn", function()
      View.self:SetEnableAnimator(false)
    end)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
