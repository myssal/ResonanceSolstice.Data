local View = require("UIDescentImprove/UIDescentImproveView")
local DataModel = require("UIDescentImprove/UIDescentImproveDataModel")
local ViewFunction = require("UIDescentImprove/UIDescentImproveViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local data = Json.decode(initParams)
      DataModel.cubeId = data.cubeId
      local cubeCA = PlayerData:GetFactoryData(DataModel.cubeId)
      DataModel.cubeCA = cubeCA
      local dLevelList = {}
      for i = 2, #DataModel.cubeCA.descentMaxLevelList do
        table.insert(dLevelList, {
          need = DataModel.cubeCA.descentMaxLevelList[i].maxNum,
          val = DataModel.cubeCA.descentMaxLevelList[i].maxLv - DataModel.cubeCA.descentMaxLevelList[i - 1].maxLv
        })
      end
      local curDescentLv = PlayerData.TempCache.CubeRogueData.des_lv or 0
      local dFvo = DataModel.cubeCA.descentMaxLevelList[math.max(1, curDescentLv + 1)]
      View.Group_Main.Group_Num.Txt_Num:SetText(dFvo.maxLv)
      DataModel.curNum = dFvo.maxNum
      table.sort(dLevelList, function(e1, e2)
        if e1.need <= dFvo.maxNum and e2.need > dFvo.maxNum then
          return false
        end
        if e1.need > dFvo.maxNum and e2.need <= dFvo.maxNum then
          return true
        end
        return e1.need < e2.need
      end)
      DataModel.descentList = dLevelList
      View.Group_Main.ScrollGrid_List.grid.self:SetDataCount(#dLevelList)
      View.Group_Main.ScrollGrid_List.grid.self:RefreshAllElement()
      View.Group_Main.ScrollGrid_List.grid.self:MoveToTop()
    end
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
