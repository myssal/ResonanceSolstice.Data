local View = require("UIIslandActivity/UIIslandActivityView")
local Controller = require("UIIslandActivity/IslandActivityController")
local DataModel = require("UIIslandActivity/UIIslandActivityDataModel")
local ViewFunction = {
  IslandActivity_Group_NotJoin_Group_Add_Btn__Click = function(btn, str)
    Controller:AddActivity()
  end,
  IslandActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:RewardSetElemnt(element, elementIndex)
  end,
  IslandActivity_Group_NotJoin_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:RewardClickElemnt(str)
  end,
  IslandActivity_Group_Join_Group_Card_Btn__Click = function(btn, str)
    Controller:OpenCardPage()
  end,
  IslandActivity_Group_Join_Group_Store_Btn__Click = function(btn, str)
    local data = {}
    local correspondingBuild = DataModel.ActivityCA.correspondingBuild[1]
    data.bubId = correspondingBuild.id
    local bubCA = PlayerData:GetFactoryData(data.bubId)
    
    local function callBack()
      DataModel.VolleyballFurniture = nil
      Controller:RefreshConstructionJoinPage()
    end
    
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Building/BuildingShop", Json.encode({
        stationId = bubCA.stationId,
        buildId = data.bubId
      }), callBack)
    end)
  end,
  IslandActivity_Group_Join_Group_Exchange_Btn__Click = function(btn, str)
    local data = {}
    local correspondingBuild = DataModel.ActivityCA.correspondingBuild[2]
    data.bubId = correspondingBuild.id
    data.listIndex = correspondingBuild.sequence
    require("UICityMap/UICityMapController"):ClickBtn(nil, {
      bubbleId = data.bubId,
      idx = data.listIndex
    })
  end,
  IslandActivity_Group_Join_Group_Quest_Btn__Click = function(btn, str)
    Controller:OpenQuest()
  end,
  IslandActivity_Group_Join_Group_Publicity_Btn__Click = function(btn, str)
    Controller:OpenPublicity()
  end,
  IslandActivity_Group_Join_Group_Volleyball_Btn__Click = function(btn, str)
    Controller:OpenVolleyball()
  end,
  IslandActivity_Group_Join_Group_Level_Btn__Click = function(btn, str)
    Controller:OpenLevel()
  end,
  IslandActivity_Group_Join_Group_Skip_Btn__Click = function(btn, str)
    Controller:OpenPlayground()
  end,
  IslandActivity_Btn_Help_Click = function(btn, str)
    if DataModel.ActivityCA.helpId > -1 then
      CommonTips.OpenHelp(DataModel.ActivityCA.helpId)
    end
  end
}
return ViewFunction
