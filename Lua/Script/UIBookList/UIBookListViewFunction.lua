local View = require("UIBookList/UIBookListView")
local DataModel = require("UIBookList/UIBookListDataModel")
local Controller = require("UIBookList/UIBookListController")
local ViewFunction = {
  BookList_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
    View.self:Confirm()
  end,
  BookList_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  BookList_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BookList_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BookList_Group_Item_Btn__Click = function(btn, str)
  end,
  BookList_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller.RefreshContentElement(element, elementIndex)
  end,
  BookList_StaticGrid_List_Group_Item_Btn__Click = function(btn, str)
    if not string.nilorempty(str) then
      Controller.OnItemClick(tonumber(str))
    end
  end
}
return ViewFunction
