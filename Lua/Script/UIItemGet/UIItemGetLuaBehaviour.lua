local View = require("UIItemGet/UIItemGetView")
local DataModel = require("UIItemGet/UIItemGetDataModel")
local ViewFunction = require("UIItemGet/UIItemGetViewFunction")
local Controller = require("UIItemGet/UIItemGetController")

local function ShowTitle(state, isSpecial)
  local isget = state == Controller.enum_Type.getWeapon or state == Controller.enum_Type.getBuff
  isget = isget and not isSpecial
  local islose = state == Controller.enum_Type.loseWeapon or state == Controller.enum_Type.loseBuff
  local isGetItem = state == Controller.enum_Type.getItem
  local isIntensify = state == Controller.enum_Type.intensify
  View.Img_Title.Txt_Get:SetActive(isget)
  View.Img_Title.Txt_Lose:SetActive(islose)
  View.Img_Title.Txt_Intensify:SetActive(isIntensify)
  View.Img_Title.Txt_GetItem:SetActive(isGetItem)
  View.Img_Title.Txt_Special:SetActive(isSpecial)
  View.Img_BG:SetActive(not islose)
  View.Img_LoseBG:SetActive(islose)
  View.Group_Get:SetActive(not islose)
  View.Group_Lose:SetActive(islose)
end

local function InitGrid(state, dataCount)
  if state == Controller.enum_Type.getWeapon or state == Controller.enum_Type.loseWeapon then
    View.ScrollGrid_Weapon.self:SetActive(3 < dataCount)
    View.StaticGrid_Weapon.self:SetActive(dataCount <= 3)
    View.ScrollGrid_Buff.self:SetActive(false)
    View.StaticGrid_Buff.self:SetActive(false)
    Controller.curGrid = 3 < dataCount and View.ScrollGrid_Weapon or View.StaticGrid_Weapon
  elseif state == Controller.enum_Type.getBuff or state == Controller.enum_Type.loseBuff or state == Controller.enum_Type.intensify or state == Controller.enum_Type.getItem then
    View.ScrollGrid_Weapon.self:SetActive(false)
    View.StaticGrid_Weapon.self:SetActive(false)
    View.ScrollGrid_Buff.self:SetActive(3 < dataCount)
    View.StaticGrid_Buff.self:SetActive(dataCount <= 3)
    Controller.curGrid = 3 < dataCount and View.ScrollGrid_Buff or View.StaticGrid_Buff
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.itemType = data.itemType
    if data.ptype == "get_equip_buff" then
      local etype, isSpecial
      if data.itemType == "Equip" then
        etype = Controller.enum_Type.getWeapon
      elseif data.itemType == "Item" then
        etype = Controller.enum_Type.getItem
      elseif data.itemType == "Buff" then
        etype = Controller.enum_Type.getBuff
        isSpecial = data.isSpecial
      end
      ShowTitle(etype, isSpecial)
      InitGrid(etype, #data.data)
      Controller.ShowList(data.data)
    elseif data.ptype == "lose_equip_buff" then
      local etype = data.itemType == "Buff" and Controller.enum_Type.loseBuff or Controller.enum_Type.loseWeapon
      ShowTitle(etype)
      InitGrid(etype, #data.data)
      Controller.ShowList(data.data)
    elseif data.ptype == "intensify" then
      local etype = Controller.enum_Type.intensify
      ShowTitle(etype)
      InitGrid(etype, #data.data)
      Controller.ShowList(data.data)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
