local View = require("UIMiniGameBS/UIMiniGameBSView")
local DataModel = require("UIMiniGameBS/UIMiniGameBSDataModel")
local Controller = require("UIMiniGameBS/UIMiniGameBSController")
local ViewFunction = {
  MiniGameBS_Group_Controls_Btn_Return_Click = function(btn, str)
    Controller.Return()
  end,
  MiniGameBS_Group_Controls_Btn_Rank_Click = function(btn, str)
    Controller.OpenRank()
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Up_Click = function(btn, str)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Up_ClickDown = function(btn, str)
    Controller.SetDirection("up", true)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Up_ClickUp = function(btn, str)
    Controller.SetDirection("up", false)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Left_Click = function(btn, str)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Left_ClickDown = function(btn, str)
    Controller.SetDirection("left", true)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Left_ClickUp = function(btn, str)
    Controller.SetDirection("left", false)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Down_Click = function(btn, str)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Down_ClickDown = function(btn, str)
    Controller.SetDirection("down", true)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Down_ClickUp = function(btn, str)
    Controller.SetDirection("down", false)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Right_Click = function(btn, str)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Right_ClickDown = function(btn, str)
    Controller.SetDirection("right", true)
  end,
  MiniGameBS_Group_Controls_Group_Direction_Btn_Right_ClickUp = function(btn, str)
    Controller.SetDirection("right", false)
  end,
  MiniGameBS_Group_Controls_Btn_Interact_Click = function(btn, str)
    Controller.Interact()
  end,
  MiniGameBS_Group_Choices_Btn_Punch_Click = function(btn, str)
    Controller.Choose("punch")
  end,
  MiniGameBS_Group_Choices_Btn_Kill_Click = function(btn, str)
    Controller.Choose("kill")
  end,
  MiniGameBS_Group_Choices_Btn_Special_Click = function(btn, str)
    Controller.Choose("special")
  end,
  MiniGameBS_Group_Choices_Btn_Leave_Click = function(btn, str)
    Controller.Choose("leave")
  end,
  MiniGameBS_Group_Dialogue_Btn_DialogueArea_Click = function(btn, str)
    Controller.Advance()
  end,
  MiniGameBS_Group_Dialogue_Btn_Advance_Click = function(btn, str)
    Controller.Advance()
  end
}
return ViewFunction
