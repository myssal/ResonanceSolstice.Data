local View = require("UIItemSelection/UIItemSelectionView")
local DataModel = require("UIItemSelection/UIItemSelectionDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local OutSideData = require("UICubeSkill/UICubeSkillDataModel")
local ItemAttrManager = require("UICubeRogueMain/CubeRogueItemAttrManager")
local Controller = {}

function Controller.RefreshSelect()
  View.Group_Btn.Btn_Confirm.Group_Num.Group_Num.Txt_Now:SetText(#DataModel.curSelect)
end

function Controller.ShowList(data)
  DataModel.dataList = {}
  for k, v in pairs(data) do
    table.insert(DataModel.dataList, {id = k, data = v})
  end
  Controller.RefreshSelect()
  local num = #DataModel.dataList
  if num <= 3 then
    Controller.curGrid.grid.self:SetStartCorner("Center")
  else
    Controller.curGrid.grid.self:SetStartCorner("Left")
  end
  Controller.curGrid.grid.self:SetDataCount(num)
  Controller.curGrid.grid.self:RefreshAllElement()
  Controller.ShowCoin()
  if Controller.showRefreshBtn then
    Controller.SetRefreshBtn()
  else
    View.Group_Btn.Btn_Refresh:SetActive(false)
  end
end

function Controller.SetRefreshBtn()
  local unlock = OutSideData.IsRefreshBuffSelectUnlock()
  unlock = unlock and DataModel.GetRefreshMaxCount() - DataModel.refreshNum > 0
  if unlock then
    View.Group_Btn.Btn_Refresh:SetActive(true)
    local orderCfg = PlayerData:GetFactoryData(89900026)
    local costData = orderCfg.requiredList[1]
    DataModel.refreshCost = costData.num
    DataModel.refreshCostId = costData.id
    View.Group_Btn.Btn_Refresh.Img_Able.Group_Cost.Txt_Num:SetText(DataModel.refreshCost)
    View.Group_Btn.Btn_Refresh.Img_Unable:SetActive(DataModel.refreshCost > PlayerData:GetGoodsById(costData.id).num)
  else
    View.Group_Btn.Btn_Refresh:SetActive(false)
  end
end

function Controller.ShowCoin()
  local coinCfg = GetCA(11400607, "ItemFactory")
  View.Group_Coin.Img_Icon:SetSprite(coinCfg.iconPath)
  View.Group_Coin.Txt_Num:SetText(PlayerData:GetGoodsById(11400607).num)
end

function Controller.Select(id)
  if table.list_remove(DataModel.curSelect, id) then
  elseif DataModel.maxSelect == 1 then
    DataModel.curSelect[1] = id
  else
    if #DataModel.curSelect >= DataModel.maxSelect then
      return
    end
    table.insert(DataModel.curSelect, id)
  end
  DataModel.onlyRefreshSel = true
  Controller.curGrid.grid.self:RefreshAllElement()
  DataModel.onlyRefreshSel = false
  if DataModel.showType == 1 or DataModel.showType == 3 then
    DataModel.canConfirm = #DataModel.curSelect > 0
  elseif DataModel.showType == 2 or DataModel.showType == 4 then
    DataModel.canConfirm = #DataModel.curSelect == DataModel.maxSelect
  end
  View.Group_Btn.Btn_Confirm.Img_Unable:SetActive(not DataModel.canConfirm)
  Controller.RefreshSelect()
end

function Controller.OnSendNet(json)
  local list = {}
  for k, v in pairs(DataModel.curSelect) do
    local curID = tonumber(v)
    for m, n in pairs(DataModel.dataList) do
      if tonumber(n.id) == curID then
        table.insert(list, n)
        if DataModel.showType ~= 1 then
          goto lbl_27
        end
        do break end
        ::lbl_27::
        if DataModel.showType == 2 then
          RogueController:AddEquip(v, nil)
          break
        end
        if DataModel.showType ~= 3 then
          goto lbl_40
        end
        do break end
        ::lbl_40::
        if DataModel.showType == 4 then
          RogueController:AddInsideBuff(v, nil)
        end
        break
      end
    end
  end
  UIManager:GoBack(false)
  ItemAttrManager.EffectRemoveAttr(Enum_RogueItemOrderType.GetBuffNum)
  if json.package and table.count(json.package) > 0 then
    RogueController.DealDirectReward({
      rg_pack = json.package
    })
  end
  if json.reward then
    RogueController.DealDirectReward(json.reward)
  end
  if DataModel.showType == 2 or DataModel.showType == 4 then
    RogueController.rewardList = RogueController.rewardList or {}
    local it = (DataModel.showType == 1 or DataModel.showType == 2) and "Equip" or "Buff"
    table.insert(RogueController.rewardList, {
      ptype = "lose_equip_buff",
      itemType = it,
      data = list
    })
  end
  RogueController.TryShowReward()
  Controller.Clear()
end

function Controller.ClearSelect()
  DataModel.curSelect = {}
  if DataModel.showType == 1 or DataModel.showType == 3 then
    DataModel.canConfirm = #DataModel.curSelect > 0
  elseif DataModel.showType == 2 or DataModel.showType == 4 then
    DataModel.canConfirm = #DataModel.curSelect == DataModel.maxSelect
  end
  View.Group_Btn.Btn_Confirm.Img_Unable:SetActive(not DataModel.canConfirm)
  Controller.RefreshSelect()
end

function Controller.Clear()
  DataModel.curSelect = {}
  DataModel.dataList = nil
  Controller.curGrid = nil
  DataModel.canConfirm = nil
end

return Controller
