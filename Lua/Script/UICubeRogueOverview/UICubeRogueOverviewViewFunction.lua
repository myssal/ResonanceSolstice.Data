local View = require("UICubeRogueOverview/UICubeRogueOverviewView")
local RogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
local AttrManager = require("UICubeRogueMain/CubeRogueEquipAttrManager")
local ItemAttrManager = require("UICubeRogueMain/CubeRogueItemAttrManager")
local DataModel = require("UICubeRogueOverview/UICubeRogueOverviewDataModel")
local Controller = require("UICubeRogueOverview/UICubeRogueOverviewController")
local ViewFunction = {
  CubeRogueOverview_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.isBattleReturn then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = DataModel.activityId,
        backToHome = true
      }))
    else
      UIManager:GoBack()
    end
  end,
  CubeRogueOverview_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  CubeRogueOverview_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CubeRogueOverview_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(86000026)
  end,
  CubeRogueOverview_Group_Card_Btn__Click = function(btn, str)
    local cardPackId = DataModel.activityCA.activityCardPack
    local activityName = DataModel.activityCA.name
    
    local function callBack()
      Controller:RefreshCard()
    end
    
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({cardPackId = cardPackId, activityName = activityName}), callBack)
  end,
  CubeRogueOverview_Group_Enter_Group_Start_Btn__Click = function(btn, str)
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      PlayerData.TempCache.CubeRogueData.reward = json.reward
      AttrManager:InitData()
      ItemAttrManager.InitData()
      CommonTips.OpenCubeRogue()
    end)
  end,
  CubeRogueOverview_Btn_Help_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Help/Roguehelp")
  end,
  CubeRogueOverview_Group_Book_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Book/BookList/BookList", Json.encode({cubeId = 89400002}), function()
      Controller:RefreshAllRed()
    end)
  end,
  CubeRogueOverview_Group_WeeklyRewards_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/WeeklyRewards/WeeklyRewards", nil, function()
      Controller:RefreshAllRed()
    end)
  end,
  CubeRogueOverview_Group_CommonLevel_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CommonRewards/CommonRewards", nil, function()
      Controller:RefreshAllRed()
    end)
  end,
  CubeRogueOverview_Group_Skill_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Skill/CubeSkill", nil, function()
      Controller:RefreshAllRed()
    end)
  end,
  CubeRogueOverview_Group_Quest_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Mission/CubeRogueMission", nil, function()
      Controller:RefreshAllRed()
    end)
  end,
  CubeRogueOverview_Group_Store_Btn__Click = function(btn, str)
    if DataModel.configCubeCA == nil or DataModel.configCubeCA.storeId == "" then
      CommonTips.OpenTips("\231\188\186\229\176\145\229\149\134\229\186\151id")
      return
    end
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/CubeRogue/OutsideStore/OutsideStore", Json.encode({
        storeId = DataModel.configCubeCA.storeId
      }))
    end, DataModel.configCubeCA.storeId)
  end,
  CubeRogueOverview_Group_Enter_Group_Continue_Btn__Click = function(btn, str)
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      PlayerData.TempCache.CubeRogueData.reward = json.reward
      AttrManager:InitData()
      ItemAttrManager.InitData()
      CommonTips.OpenCubeRogue()
    end)
  end,
  CubeRogueOverview_Group_Enter_Group_Stop_Btn__Click = function(btn, str)
    CommonTips.OpenRogueStopTips({}, function()
      RogueMain.EndCube(false, nil, true)
    end)
  end,
  CubeRogueOverview_Group_Enter_Toggle_Delete_Toggle = function(toggle, value)
  end
}
return ViewFunction
