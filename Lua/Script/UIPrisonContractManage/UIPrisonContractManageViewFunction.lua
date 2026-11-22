local View = require("UIPrisonContractManage/UIPrisonContractManageView")
local DataModel = require("UIPrisonContractManage/UIPrisonContractManageDataModel")
local ViewFunction = {
  PrisonContractManage_Btn_BG_Click = function(btn, str)
    if DataModel.autoOpen and PrisonData.GetMargin() <= 0 then
      CommonTips.OpenTips(80608794)
      return
    end
    View.self:CloseUI()
  end,
  PrisonContractManage_Btn_ContractLook_Click = function(btn, str)
    UIManager:Open("UI/Prison/Contract/PrisonContract")
  end,
  PrisonContractManage_Group_Bond_Btn_Auto_Click = function(btn, str)
    local function callBack()
      View.Group_Bond.Btn_AutoSelect:SetActive(true)
      
      View.Group_Bond.Btn_Auto:SetActive(false)
    end
    
    PrisonData.SetMarginSwitch(callBack, 1)
  end,
  PrisonContractManage_Group_Bond_Btn_AutoSelect_Click = function(btn, str)
    local function callBack()
      View.Group_Bond.Btn_AutoSelect:SetActive(false)
      
      View.Group_Bond.Btn_Auto:SetActive(true)
    end
    
    PrisonData.SetMarginSwitch(callBack, 0)
  end,
  PrisonContractManage_Group_Bond_Btn_Bond_Click = function(btn, str)
    local margin = PrisonData.GetMargin()
    local marginMax = DataModel.GetMarginMax()
    if margin == marginMax then
      CommonTips.OpenTips(80607300)
    else
      local addNum = marginMax - margin
      if addNum > PlayerData:GetGoodsById(11400001).num then
        CommonTips.OpenTips(80600260)
        return
      end
      
      local function yesFun()
        local function callBack()
          local prisonCA = PrisonData.GetPrisonCA()
          
          margin = PrisonData.GetMargin()
          local moneyMarginMax = DataModel.GetMarginMax()
          View.Group_Bond.Img_Decoration.Txt_Num:SetText(margin .. "/" .. moneyMarginMax)
          local rate = moneyMarginMax ~= 0 and margin / moneyMarginMax or 0
          View.Group_Bond.Img_Bar:SetFilledImgAmount(rate)
          View.Group_Bond.Img_BarPoint:SetAnchoredPosition(Vector2(-350 + 700 * rate, View.Group_Bond.Img_BarPoint:GetAnchoredPositionY()))
          View.Group_Bond.Img_BarPoint.Img_Normal:SetActive(rate >= prisonCA.shortageBondNum)
          View.Group_Bond.Img_BarPoint.Img_Shortage:SetActive(rate < prisonCA.shortageBondNum)
        end
        
        PrisonData.SetMargin(callBack, addNum)
      end
      
      local moneyName = PlayerData:GetFactoryData(11400001, "ItemFactory").name
      CommonTips.OnPrompt(string.format(GetText(80607299), addNum, moneyName), nil, nil, yesFun)
    end
  end,
  PrisonContractManage_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.autoOpen then
      View.self:CloseUI()
      UIManager:GoBack()
    end
  end,
  PrisonContractManage_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    if DataModel.autoOpen then
      UIManager:GoHome()
    end
  end,
  PrisonContractManage_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonContractManage_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
