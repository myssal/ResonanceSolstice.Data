local View = require("UIOverview/UIOverviewView")
local DataModel = require("UIOverview/UIOverviewDataModel")
local Controller = require("UIOverview/UIOverviewController")
local ViewFunction = {
  Overview_Btn__Click = function(btn, str)
    Controller:Close()
  end,
  Overview_ScrollGrid_List_SetGrid = function(element, elementIndex)
  end,
  Overview_ScrollGrid_List_Group_Item_Group_List_StaticGrid_List_SetGrid = function(element, elementIndex)
  end,
  Overview_Group_Expel_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshExpelElement(element, elementIndex)
  end,
  Overview_Group_Expel_ScrollGrid_List_Group_Item_Group_List_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshPondElement(element, elementIndex)
  end,
  Overview_Group_Battle_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshBattleCenterElement(element, elementIndex)
  end,
  Overview_Group_Btn_Group_Expel_Btn__Click = function(btn, str)
    Controller:SelectPanel(DataModel.panelType.Expel)
  end,
  Overview_Group_Btn_Group_Battle_Btn__Click = function(btn, str)
    Controller:SelectPanel(DataModel.panelType.Battle)
  end
}
return ViewFunction
