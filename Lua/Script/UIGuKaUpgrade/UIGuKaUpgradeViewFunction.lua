local View = require("UIGuKaUpgrade/UIGuKaUpgradeView")
local DataModel = require("UIGuKaUpgrade/UIGuKaUpgradeDataModel")
local Controller = require("UIGuKaUpgrade/UIGuKaUpgradeController")
local ViewFunction = {
  GuKaUpgrade_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.IsClosing then
      return
    end
    CommonTips.OpenWitchPrompt(80610474, nil, nil, function()
      Net:SendProto("activity.deal_guka_upgrade", function(json)
        WitchData.GetWitchesData().guka_num = 0
        View.self:Confirm()
        View.self:CloseUI()
      end, WitchData.GetActivityId())
    end)
  end,
  GuKaUpgrade_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  GuKaUpgrade_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  GuKaUpgrade_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80306745)
  end,
  GuKaUpgrade_Group_Pack_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetBagElement(element, elementIndex)
  end,
  GuKaUpgrade_Btn_UpGrade_Click = function(btn, str)
    Controller:TryUpgradeGuKa()
  end,
  GuKaUpgrade_Group_CurrencyItem_Btn_Buy_Click = function(btn, str)
  end,
  GuKaUpgrade_StaticGrid_Currency_SetGrid = function(element, elementIndex)
    Controller:SetCurrencyElement(element, elementIndex)
  end,
  GuKaUpgrade_StaticGrid_Currency_Group_CurrencyItem_Btn_Buy_Click = function(btn, str)
  end,
  GuKaUpgrade_Group_Pack_ScrollGrid__Group_Item_Group_GuKa_Btn__Click = function(btn, str)
    Controller:SelectGuKa(tonumber(str))
  end,
  GuKaUpgrade_Group_Effect_Btn_Close_Click = function(btn, str)
    View.Group_Effect:SetActive(false)
  end,
  GuKaUpgrade_Video_Majila_Skip_Click = function(btn, str)
  end
}
return ViewFunction
