local View = require("UIItemSelection/UIItemSelectionView")
local DataModel = require("UIItemSelection/UIItemSelectionDataModel")
local ViewFunction = require("UIItemSelection/UIItemSelectionViewFunction")
local Controller = require("UIItemSelection/UIItemSelectionController")
local ItemAttrManager = require("UICubeRogueMain/CubeRogueItemAttrManager")
local enum_Type = {
  getWeapon = 1,
  loseWeapon = 2,
  getBuff = 3,
  loseBuff = 4
}

local function ShowTitle(state)
  View.Img_Title.Txt_Weapon:SetActive(state == enum_Type.getWeapon)
  View.Img_Title.Txt_LoseWeapon:SetActive(state == enum_Type.loseWeapon)
  View.Img_Title.Txt_Buff:SetActive(state == enum_Type.getBuff)
  View.Img_Title.Txt_LoseBuff:SetActive(state == enum_Type.loseBuff)
  DataModel.showType = state
end

local function InitMaxSelect(maxSel)
  DataModel.curSelect = {}
  DataModel.maxSelect = maxSel
  DataModel.canConfirm = false
  View.Group_Btn.Btn_Confirm.Img_Unable:SetActive(true)
  View.Group_Btn.Btn_Confirm.Group_Num.Group_Num.Txt_Max:SetText(string.format("%d", maxSel))
  View.Group_Btn.Btn_Confirm.Group_Num.Group_Num.Txt_Now:SetText(0)
end

local function InitGrid(state)
  if state == enum_Type.getWeapon or state == enum_Type.loseWeapon then
    View.ScrollGrid_Weapon.self:SetActive(true)
    View.ScrollGrid_Buff.self:SetActive(false)
    Controller.curGrid = View.ScrollGrid_Weapon
  elseif state == enum_Type.getBuff or state == enum_Type.loseBuff then
    View.ScrollGrid_Weapon.self:SetActive(false)
    View.ScrollGrid_Buff.self:SetActive(true)
    Controller.curGrid = View.ScrollGrid_Buff
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    if data.ptype == "get_equip_buff_select" then
      DataModel.cfg = GetCA(tonumber(data.id), "ActivityListFactory")
      local etype = DataModel.cfg.packageType == "Buff" and enum_Type.getBuff or enum_Type.getWeapon
      ShowTitle(etype)
      local attr = 0
      if etype == enum_Type.getBuff then
        attr = ItemAttrManager.GetAttr(Enum_RogueItemOrderType.GetBuffNum)
      end
      InitMaxSelect(DataModel.cfg.selectNum + attr)
      InitGrid(etype)
      Controller.showRefreshBtn = DataModel.cfg.packageType == "Buff"
      DataModel.refreshNum = data.refresh or 0
      Controller.ShowList(data.data)
    elseif data.ptype == "lose_equip_buff_select" then
      DataModel.cfg = GetCA(tonumber(data.id), "RogueOrderFactory")
      local etype = DataModel.cfg.orderType == "LoseEquip" and enum_Type.loseWeapon or enum_Type.loseBuff
      ShowTitle(etype)
      InitMaxSelect(DataModel.cfg.param)
      InitGrid(etype)
      Controller.showRefreshBtn = nil
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
