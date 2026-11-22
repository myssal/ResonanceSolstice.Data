local DataModel = require("UIItemGet/UIItemGetDataModel")
local Controller = {
  enum_Type = {
    getWeapon = 1,
    loseWeapon = 2,
    getBuff = 3,
    loseBuff = 4,
    intensify = 5,
    getItem = 6
  }
}

function Controller.ShowList(dataList)
  DataModel.dataList = dataList
  Controller.curGrid.grid.self:SetDataCount(#DataModel.dataList)
  Controller.curGrid.grid.self:RefreshAllElement()
end

function Controller.Clear()
  Controller.curGrid = nil
  DataModel.dataList = nil
end

return Controller
