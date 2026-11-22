local View = require("UIGroup_LikesTips/UIGroup_LikesTipsView")
local DataModel = {}

function DataModel.RefreshOnShow()
  local num, maxNum = PlayerData.GetGiveLikeNum()
  View.Img_NumBG.Txt_:SetText(string.format(GetText(80609549), num, maxNum))
end

return DataModel
