local Controller = require("UIMiniGameBSRank/UIMiniGameBSRankController")
return {
  MiniGameBSRank_Btn_Backdrop_Click = function()
    Controller.Close()
  end,
  MiniGameBSRank_Group_Panel_Btn_Close_Click = function()
    Controller.Close()
  end,
  MiniGameBSRank_Group_Panel_ScrollGrid_List_SetGrid = function(element, index)
    Controller.SetRow(element, index)
  end
}
