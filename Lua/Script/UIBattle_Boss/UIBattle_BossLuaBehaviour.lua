local View = require("UIBattle_Boss/UIBattle_BossView")
local DataModel = require("UIBattle_Boss/UIBattle_BossDataModel")
local Controller = require("UIBattle_Boss/UIBattle_BossController")
local ViewFunction = require("UIBattle_Boss/UIBattle_BossViewFunction")
local Luabehaviour = {
  serialize = function()
    local parms = {}
    parms.turntableId = DataModel.TurntableCA.id
    parms.stationId = DataModel.StationId
    parms.index = DataModel.SelectIndex
    parms.isCityMapIn = DataModel.IsCityMapIn
    return Json.encode(parms)
  end,
  deserialize = function(initParams)
    local parms = Json.decode(initParams)
    DataModel:Init(parms)
    Controller:RefreshAbyssTime()
    View.Group_Right.self:SetActive(false)
    local count = #DataModel.TurntableCA.levelBossList
    local lastNode = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.grid.self:GetChildByIndex(count - 1)
    local width = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level.self.Rect.rect.width / 2 + lastNode.transform.localPosition.x + 1500
    View.ScrollView_Select.Viewport.Content:SetWidth(width)
    
    local function callBack()
      Net:SendProto("station.turntable_battle", function(json)
        DataModel.BatterInfo = json.ttb_level[tostring(DataModel.StationId)]
        local progressAll = 0
        local progressAllMax = 0
        for i, v in ipairs(DataModel.TurntableCA.levelBossList) do
          local data = DataModel.TurntableCA.levelBossList[i]
          local levelList = PlayerData:GetFactoryData(data.id).levelList
          local levelCountMax = #levelList
          local progress = DataModel:GetCurrentLevelData(i - 1, levelCountMax)
          progressAll = progressAll + progress
          progressAllMax = progressAllMax + levelCountMax
        end
        local progress = PlayerData:GetPreciseDecimalFloor(progressAll / progressAllMax * 100, 0)
        View.Group_CommomBottomLeft.Group_Progress.Txt_Num:SetText(progressAll .. "/" .. progressAllMax .. "(" .. progress .. "%)")
        View.Group_CommomBottomLeft:SetActive(true)
        View.Group_CommomBottomLeft.Group_Items.Txt_Num:SetText(json.score or 0)
        Controller:Init(DataModel.SelectIndex)
      end, DataModel.StationId)
    end
    
    if DataModel.TurntableCA.FirstParagraphid > -1 and PlayerData.plot_paragraph[tostring(DataModel.TurntableCA.FirstParagraphid)] == nil then
      UIManager:Open("UI/Dialog/Dialog", Json.encode({
        id = DataModel.TurntableCA.FirstParagraphid
      }))
    else
      callBack()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.remainTime = DataModel.remainTime - 0.02
    if DataModel.remainTime <= 0 then
      DataModel.remainTime = DataModel.constTime
      Controller:RefreshAbyssTime()
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
