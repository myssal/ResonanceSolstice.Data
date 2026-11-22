local View = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessView")
local DataModel = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessDataModel")
local ViewFunction = {
  PublicizeSendSuccess_Btn_Shade_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PublicizeSendSuccess_Btn_OK_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PublicizeSendSuccess_GroupResult_Group_R_ScrollGrid_list_SetGrid = function(element, elementIndex)
    local careers = DataModel.sameCareerList[elementIndex]
    local info = careers[1]
    element.Group_sort.Group_sequence:SetActive(elementIndex <= 3)
    element.Group_sort.Group_sequence.Img_first:SetActive(elementIndex == 1)
    element.Group_sort.Group_sequence.Img_second:SetActive(elementIndex == 2)
    element.Group_sort.Group_sequence.Img_third:SetActive(elementIndex == 3)
    element.Group_bg.Img_bg1:SetActive(elementIndex == 1)
    element.Group_bg.Img_bg2:SetActive(elementIndex == 2)
    element.Group_bg.Img_bg3:SetActive(elementIndex == 3)
    element.Group_bg.Img_bg4:SetActive(3 < elementIndex)
    local psgCA = PlayerData:GetFactoryData(info.psgId, "PassageFactory")
    local career = PlayerData:GetFactoryData(psgCA.career).leafletPlace
    element.Group_sort.Txt_1:SetText(career)
    element.Group_sort.Txt_2:SetText(#careers)
    local payRatio = DataModel.psgPayList[psgCA.career] / DataModel.totalPay
    local format = payRatio == 0 and "%d%%" or "%0.2f%%"
    element.Group_sort.Group_3.Txt_:SetText(string.format(format, payRatio * 100))
  end,
  PublicizeSendSuccess_GroupResult_Btn_passenger_Click = function(btn, str)
    Net:SendProto("playground.park_reward", function(json)
      local IncomeDataModel = require("UIGroup_Income/UIGroup_IncomeDataModel")
      if json and json.interface then
        IncomeDataModel.curIncome = json.interface.gold
        local playGroundData = PlayerData.GetPlaygroundData(87300002)
        playGroundData.casual = json.interface.casual
        playGroundData.psg = json.interface.psg
        playGroundData.pub = json.interface.pub
      end
      View.self:CloseUI()
      local UIPublicizeMainView = require("UIPublicizeMain/UIPublicizeMainView")
      UIPublicizeMainView.self:CloseUI()
      UIManager:Open("UI/Building/BuildingList")
      local UIBuildingListView = require("UIBuildingList/UIBuildingListView")
      UIBuildingListView.Group_Main:SetActive(false)
      UIBuildingListView.Group_CommonTopLeft:SetActive(false)
      UIManager:Open("UI/ParkRevenue/Group_Income")
    end, 0, 87300002)
  end
}
return ViewFunction
