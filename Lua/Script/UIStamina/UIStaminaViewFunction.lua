local View = require("UIStamina/UIStaminaView")
local DataModel = require("UIStamina/UIStaminaDataModel")
local ViewFunction = {
  Stamina_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Stamina_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Stamina_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Stamina_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Stamina_Btn_Energy_Click = function(btn, str)
  end,
  Stamina_Btn_Energy_Btn_Add_Click = function(btn, str)
    local function cb()
      View.Btn_Energy.Txt_Num:SetText(PlayerData:GetUserInfo().energy .. "/" .. PlayerData:GetUserInfo().max_energy)
    end
    
    CommonTips.OpenEnergy(cb)
  end,
  Stamina_Group_Stamina_Btn_Choose_Click = function(btn, str)
  end,
  Stamina_StaticGrid_Option_SetGrid = function(element, elementIndex)
    local parkMapCA = DataModel.ParkMapCA
    local data = parkMapCA.initialEnergyList[elementIndex]
    element.Img_.Txt_Name:SetText(data.name)
    element.Img_.Img_Icon:SetSprite(data.path)
    element.Img_.Txt_Des:SetText(string.format(GetText(80610445), data.num))
    local costNum = data.extraCost
    local enough = costNum <= PlayerData:GetGoodsById(parkMapCA.extraEnergyCostList[1].id).num
    element.Img_.Group_Extra:SetActive(0 < costNum)
    if 0 < costNum then
      local costStr = tostring(data.extraCost)
      if not enough then
        costStr = " <color='#E336360'>+ " .. data.extraCost .. "</color>"
      end
      element.Img_.Group_Extra.Txt_:SetText(string.format(GetText(80610446), costStr))
    end
    element.Img_.Txt_DesText:SetText(data.des)
    element.Img_:SetSprite(data.bgPath)
    element.Img_.Img_Pick:SetSprite(data.pickBgPath)
    element.Img_.Img_Pick:SetActive(false)
    element.Btn_Choose:SetClickParam(elementIndex)
    element.Img_NoChosse:SetActive(not enough)
    DataModel.selectElementList[elementIndex] = element
  end,
  Stamina_StaticGrid_Option_Group_Stamina_Btn_Choose_Click = function(btn, str)
    local index = tonumber(str)
    local parkMapCA = DataModel.ParkMapCA
    local data = parkMapCA.initialEnergyList[index]
    if DataModel.curSelectIndex and DataModel.curSelectIndex == index then
      local function cb(json)
        View.self:Confirm()
      end
      
      WitchData.ReqSelectActionType(index, cb)
    else
      if DataModel.curSelectIndex then
        local element = DataModel.selectElementList[DataModel.curSelectIndex]
        if element then
          element.Img_.Img_Pick:SetActive(false)
        end
      end
      DataModel.curSelectIndex = index
      local element = DataModel.selectElementList[index]
      if element then
        element.Img_.Img_Pick:SetActive(true)
      end
    end
  end,
  Stamina_Btn_Medal_Click = function(btn, str)
  end,
  Stamina_Btn_Medal_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end
}
return ViewFunction
