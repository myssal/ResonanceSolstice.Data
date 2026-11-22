local View = require("UIPrisonManage/UIPrisonManageView")
local DataModel = require("UIPrisonManage/UIPrisonManageDataModel")
local ViewFunction = require("UIPrisonManage/UIPrisonManageViewFunction")
local ManagerController = require("UIPrisonManage/UIPrisonManagerController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local roomIndex = PrisonData.roomIndex
    if initParams then
      local params = Json.decode(initParams)
      roomIndex = params.roomIndex or 1
    end
    DataModel.curRoomIndex = roomIndex
    ManagerController:InitView()
    View.PrisonerListManage:SetActive(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local down = false
    if Input.GetMouseButton(0) then
      down = true
    end
    DataModel.curFrameMouseDown = false
    DataModel.curFrameMouseUp = false
    if DataModel.preMouseDown ~= down then
      if DataModel.preMouseDown == false then
        DataModel.curFrameMouseDown = true
      else
        DataModel.curFrameMouseUp = true
      end
    end
    DataModel.preMouseDown = down
    if not DataModel.RoomIsWorking(DataModel.curRoomIndex) then
      if DataModel.curFrameMouseUp then
        DataModel.isDrag = false
      end
      if DataModel.isDrag then
        local pos = Input.mousePosition
        View.Group_Temp.self:SetAnchoredPosition(Vector2(pos.x, pos.y))
        ManagerController:Dragging()
      end
      if not DataModel.isDrag and View.Group_Temp.self.IsActive then
        ManagerController:DragEnd()
      end
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
