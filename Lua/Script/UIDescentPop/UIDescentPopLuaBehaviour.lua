local View = require("UIDescentPop/UIDescentPopView")
local DataModel = require("UIDescentPop/UIDescentPopDataModel")
local ViewFunction = require("UIDescentPop/UIDescentPopViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local buffList = {}
    local val = 0
    local buffMap = {}
    for k, v in pairs(PlayerData.TempCache.CubeRogueData.debuff) do
      local orderCA = PlayerData:GetFactoryData(k)
      if orderCA and buffMap[orderCA.descent] ~= true then
        buffMap[orderCA.descent] = true
        local buffCA = PlayerData:GetFactoryData(orderCA.descent)
        if buffCA then
          val = val + buffCA.descent
          table.insert(buffList, buffCA)
        end
      end
    end
    View.Img_Main.Txt_Descent:SetText(val)
    DataModel.buffList = buffList
    View.Img_Main.ScrollGrid_List.grid.self:SetDataCount(#buffList)
    View.Img_Main.ScrollGrid_List.grid.self:RefreshAllElement()
    View.Img_Main.ScrollGrid_List.grid.self:MoveToTop()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
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
