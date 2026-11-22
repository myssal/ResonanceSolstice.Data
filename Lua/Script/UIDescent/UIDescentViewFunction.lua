local View = require("UIDescent/UIDescentView")
local DataModel = require("UIDescent/UIDescentDataModel")
local Controller = require("UIDescent/UIDescentController")
local ViewFunction = {
  Descent_Btn_Back_Click = function(btn, str)
    Controller:SaveUsingBuff(function()
      UIManager:GoBack()
    end)
  end,
  Descent_Group_Info_Btn_Use_Click = function(btn, str)
    Controller:OnclickBtnBuff()
  end,
  Descent_Group_Using_Btn_Clear_Click = function(btn, str)
    Controller:ClearUsingBuff()
  end,
  Descent_Group_Using_Btn_UP_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Descent/DescentImprove", Json.encode({
      cubeId = DataModel.cubeId
    }))
  end,
  Descent_Group_Using_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    Controller:SetUsingBuffListGrid(element, elementIndex)
  end,
  Descent_Group_Using_StaticGrid_BuffList_Group_Buff_Btn_Click_Click = function(btn, str)
    Controller:OnSelectUsingBuff(tonumber(str))
  end,
  Descent_Group_BuffList_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:SetBuffListGrid(element, elementIndex)
  end,
  Descent_Group_BuffList_ScrollGrid_List_Group_Buff_Btn_Click_Click = function(btn, str)
    Controller:OnSelectBuff(tonumber(str))
  end
}
return ViewFunction
