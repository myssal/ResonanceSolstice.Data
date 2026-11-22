local View = require("UICubeRogueShowItem/UICubeRogueShowItemView")
local DataModel = require("UICubeRogueShowItem/UICubeRogueShowItemDataModel")
local Controller = {}

function Controller.ShowPanel()
  local num = #DataModel.Data
  View.ScrollGrid_Items.self:SetEnable(6 < num)
  if 6 < num then
    View.ScrollGrid_Items.grid.self:SetStartCorner("Left")
  else
    View.ScrollGrid_Items.grid.self:SetStartCorner("Center")
  end
  View.ScrollGrid_Items.grid.self:SetDataCount(num)
  View.ScrollGrid_Items.grid.self:RefreshAllElement()
  View.Img_Title:SetSprite(GetResPath(88300184))
  View.Img_LoseTitle:SetSprite(GetResPath(88300249))
end

return Controller
