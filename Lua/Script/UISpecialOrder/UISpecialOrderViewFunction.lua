local View = require("UISpecialOrder/UISpecialOrderView")
local DataModel = require("UISpecialOrder/UISpecialOrderDataModel")
local ViewFunction = {
  SpecialOrder_Group_Formula_Btn_GetFormula_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.ActivityId)
    local requireItemId = cfg.getProductionCost[1].id
    local requireItemNum = cfg.getProductionCost[1].num
    local requireItemHave = PlayerData:GetGoodsById(requireItemId).num
    if requireItemNum > requireItemHave then
      CommonTips.OpenTips(80610926)
      return
    end
    local makeLv = PlayerData:GetHomeInfo().compound_lv
    local requireLevel = cfg.getProductionPremise
    if makeLv < requireLevel then
      CommonTips.OpenTips(string.format(GetText(80610927), requireLevel))
      return
    end
    CommonTips.OnPrompt(GetText(80610942), nil, nil, function()
      Net:SendProto("future.levy_exchange", function(json)
        if json.reward then
          CommonTips.OpenShowItem(json.reward)
        end
        local orderCfg = PlayerData:GetFactoryData(cfg.orderList[1].id)
        local productionCfg = PlayerData:GetFactoryData(orderCfg.requireProduction)
        table.insert(PlayerData.ServerData.formula_items, tostring(productionCfg.unlock))
        DataModel.RefreshPanel()
      end, DataModel.ActivityId)
    end)
  end,
  SpecialOrder_Group_Progress_Btn_Personal_Click = function(btn, str)
    View.Group_BuffInfo:SetActive(true)
    DataModel.SwitchBuffTab(1)
  end,
  SpecialOrder_Group_Progress_Btn_All_Click = function(btn, str)
    View.Group_BuffInfo:SetActive(true)
    DataModel.SwitchBuffTab(2)
  end,
  SpecialOrder_Btn_Help_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.ActivityId)
    CommonTips.OpenHelp(cfg.helpId)
  end,
  SpecialOrder_Btn_Pdd_Click = function(btn, str)
    UIManager:Open("UI/StageQuest/StageQuest", Json.encode({titleIndex = 4, isFromActivity = true}))
  end,
  SpecialOrder_Group_BuffInfo_Btn_BG_Click = function(btn, str)
    View.Group_BuffInfo:SetActive(false)
  end,
  SpecialOrder_Group_BuffInfo_Group_Personal_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    DataModel.SetSelfBuffElement(element, elementIndex)
  end,
  SpecialOrder_Group_BuffInfo_Group_Personal_ScrollGrid_Buff_Group_Item_Group_Common_Btn_Get_Click = function(btn, str)
    DataModel.TryGetReward(tonumber(str))
  end,
  SpecialOrder_Group_BuffInfo_Group_Personal_ScrollGrid_Buff_Group_Item_Group_Current_Btn_Get_Click = function(btn, str)
    DataModel.TryGetReward(tonumber(str))
  end,
  SpecialOrder_Group_BuffInfo_Group_Personal_Btn_Change_Click = function(btn, str)
    DataModel.SwitchBuffTab(2)
  end,
  SpecialOrder_Group_BuffInfo_Group_All_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    DataModel.SetServerBuffElement(element, elementIndex)
  end,
  SpecialOrder_Group_BuffInfo_Group_All_Btn_Change_Click = function(btn, str)
    DataModel.SwitchBuffTab(1)
  end
}
return ViewFunction
