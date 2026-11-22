local View = require("UIDescentImprove/UIDescentImproveView")
local DataModel = require("UIDescentImprove/UIDescentImproveDataModel")
local ViewFunction = {
  DescentImprove_Btn_Close_Click = function(btn, str)
    UIManager:CloseTip()
  end,
  DescentImprove_Group_Main_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local dData = DataModel.descentList[elementIndex]
    local isComplete = dData.need <= DataModel.curNum
    element.Group_Completed:SetActive(isComplete)
    element.Group_Incompleted:SetActive(not isComplete)
    element.Group_Num.Txt_Num:SetText(dData.val)
    element.Txt_Task:SetText(string.format(GetText(80610801), dData.need))
  end
}
return ViewFunction
