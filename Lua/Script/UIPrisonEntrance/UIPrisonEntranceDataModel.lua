local View = require("UIPrisonEntrance/UIPrisonEntranceView")
local DataModel = {}

function DataModel.RefreshOnShow()
  View.Group_EntranceWindows.Group_Title.Txt_LV:SetText(PrisonData.GetPrisonLv())
end

return DataModel
