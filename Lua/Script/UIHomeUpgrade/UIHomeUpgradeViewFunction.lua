local View = require("UIHomeUpgrade/UIHomeUpgradeView")
local DataModel = require("UIHomeUpgrade/UIHomeUpgradeDataModel")
local Controller = require("UIHomeUpgrade/UIHomeUpgradeController")
local ViewFunction = {
  HomeUpgrade_Btn_Close_Click = function(btn, str)
    View.self:PlayAnim("HomeUpgrade_Out", function()
      View:CloseUI()
    end)
  end,
  HomeUpgrade_Img_UpgradeBG_Group_MaterialsItem_ScrollGrid_Materials_SetGrid = function(element, elementIndex)
    local info = DataModel.CostItems[elementIndex]
    local BtnItem = require("Common/BtnItem")
    BtnItem:SetItem(element.Group_Item, {
      id = info.id
    })
    element.Group_Item.Btn_Item:SetClickParam(info.id)
    local haveNum = PlayerData:GetGoodsById(info.id).num
    element.Group_Cost.Txt_Have:SetText(PlayerData:TransitionNum(haveNum))
    element.Group_Cost.Txt_Need:SetText(PlayerData:TransitionNum(info.num))
    if haveNum < info.num then
      element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
    else
      element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
    end
  end,
  HomeUpgrade_Img_UpgradeBG_Group_MaterialsItem_ScrollGrid_Materials_Group_Consume_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId)
  end,
  HomeUpgrade_Img_UpgradeBG_Group_Btn_Btn_Upgrade_Click = function(btn, str)
    View.Img_UpgradeBG.Group_Btn.Btn_Upgrade:SetBtnInteractable(false)
    View.self:PlayAnim("HomeUpgrade_Out", function()
      View.Img_UpgradeBG.Group_Btn.Btn_Upgrade:SetBtnInteractable(true)
      View:CloseUI()
      
      local function callBack()
        if UIManager:IsPanelOpened("UI/Home_MachiningMenu/Home_MachiningMenu") then
          local UIHome_MachiningMenuDataModel = require("UIHome_MachiningMenu/UIHome_MachiningMenuDataModel")
          UIHome_MachiningMenuDataModel.RefreshAfterUpgrade()
        end
        View.self:Confirm()
      end
      
      Controller:DoUpGrade(callBack)
    end)
  end,
  HomeUpgrade_Img_UpgradeBG_Group_Btn_Btn_Cancel_Click = function(btn, str)
    View.self:PlayAnim("HomeUpgrade_Out", function()
      View:CloseUI()
    end)
  end
}
return ViewFunction
