local View = require("UIPlayground/UIPlaygroundView")
local DataModel = require("UIPlayground/UIPlaygroundDataModel")
local Controller = require("UIPlayground/UIPlaygroundController")
local ViewFunction = {
  Playground_Btn_Decorate_Click = function(btn, str)
    Controller:DoDecorate()
  end,
  Playground_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller:Return()
  end,
  Playground_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    Controller:Home()
  end,
  Playground_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Playground_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    Controller:OpenHelp()
  end,
  Playground_Group_Navigation_Btn_Quest_Click = function(btn, str)
    Controller:ClickQuest()
  end,
  Playground_Group_Navigation_Btn_Navigation_Click = function(btn, str)
    Controller:ClickQuest()
  end,
  Playground_Btn_Advocacy_Click = function(btn, str)
    Net:SendProto("playground.playground_info", function(json)
      if json then
        PlayerData.SolicitData.leafletNum = json.own_leaflet
        PlayerData.SolicitData.copyLeafletNum = json.add_leaflet
        PlayerData:GetHomeInfo().visitors = json.visitors
      end
      UIManager:Open("UI/ParkPublicity/PublicizeMain", Json.encode({
        playgroundId = CommonCoachData.GetPlaygroundId()
      }))
    end, 87300002)
  end,
  Playground_Btn_Extend_Click = function(btn, str)
    Controller:Extend()
  end,
  Playground_Btn_NAV_Click = function(btn, str)
    Controller:ClickQuickJumpShow(true)
  end,
  Playground_Btn_Visit_Click = function(btn, str)
  end,
  Playground_Group_QuickJump_Btn_Close_Click = function(btn, str)
    Controller:ClickQuickJumpShow(false)
  end,
  Playground_Group_QuickJump_Group_Windows_Img_Base_StaticGrid_Train_SetGrid = function(element, elementIndex)
    Controller:RefreshQuickJumpElement(element, elementIndex)
  end,
  Playground_Group_QuickJump_Group_Windows_Img_Base_StaticGrid_Train_Group_train_Btn_train_Click = function(btn, str)
    Controller:ClickQuickJump(btn, str)
  end,
  Playground_Btn_Moster_Click = function(btn, str)
    Controller:ClickMonsterBtn()
  end,
  Playground_Btn_Moster_Btn_Debuff_Click = function(btn, str)
    Controller:ShowDebuffTips(true)
  end,
  Playground_Group_DebuffTips_Btn_Close_Click = function(btn, str)
    Controller:ShowDebuffTips(false)
  end,
  Playground_Img_LV_Btn_BB_Click = function(btn, str)
    Net:SendProto("playground.park_reward", function(json)
      local IncomeDataModel = require("UIGroup_Income/UIGroup_IncomeDataModel")
      if json and json.interface then
        IncomeDataModel.curIncome = json.interface.gold
        local playGroundData = PlayerData.GetPlaygroundData(87300002)
        playGroundData.casual = json.interface.casual
        playGroundData.psg = json.interface.psg
        playGroundData.pub = json.interface.pub
        playGroundData.pond = json.interface.pond
        playGroundData.invest_num = json.interface.invest_num
      end
      UIManager:Open("UI/ParkRevenue/Group_Income")
    end, 0, 87300002)
  end,
  Playground_Btn_Patrol_Click = function(btn, str)
    Controller:OpenIslandBattle()
  end,
  Playground_Img_LV_Btn_ProfilePhoto_Click = function(btn, str)
  end,
  Playground_Btn_Tourist_Click = function(btn, str)
  end,
  Playground_Img_Cleanliness_Btn_Rubbish_Click = function(btn, str)
    Controller:OpenRubbish()
  end,
  Playground_Group_Store_Btn__Click = function(btn, str)
    Controller:OpenBuildingShop()
  end,
  Playground_Group_Exchange_Btn__Click = function(btn, str)
    Controller:OpenExchangeStation()
  end,
  Playground_Btn_Report_Click = function(btn, str)
    Controller:OpenLMUI()
  end,
  Playground_Btn_FriendOpen_Click = function(btn, str)
    Net:SendProto("playground.fg_get_friend_list", function(json)
      if json.friends then
        UIManager:Open("UI/Playground/FriendIslandUpdate/FriendList/FriendList", Json.encode({
          friends = json.friends
        }))
      end
    end, 87300002)
  end
}
return ViewFunction
