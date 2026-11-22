local View = require("UIBossMenu/UIBossMenuView")
local DataModel = require("UIBossMenu/UIBossMenuDataModel")
local Controller = require("UIBossMenu/UIBossMenuController")
local ViewFunction = {
  BossMenu_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.RefreshFightRewardElement(element, elementIndex)
  end,
  BossMenu_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  BossMenu_Img_RightBG_Img_KillRewards_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.RefreshBossKillRewardElement(element, elementIndex)
  end,
  BossMenu_Img_RightBG_Img_KillRewards_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  BossMenu_Img_RightBG_Btn_AskHelp_Click = function(btn, str)
    Controller.RefreshAskHelpShow()
  end,
  BossMenu_Img_RightBG_Btn_FriednHelp_Click = function(btn, str)
    Controller.RefreshFriendHelpShow()
  end,
  BossMenu_Img_RightBG_Btn_Fight_Click = function(btn, str)
    Controller.OnMyBossFightAndGetBtnClick()
  end,
  BossMenu_Group_Help_Img_BG_Btn_HelpFriends_Click = function(btn, str)
    Controller.RefreshFriendHelpShow()
  end,
  BossMenu_Group_Help_Img_BG_Btn_AskHelp_Click = function(btn, str)
    Controller.RefreshAskHelpShow()
  end,
  BossMenu_Group_Help_Img_BG_Group_HelpFriends_ScrollGrid_User_SetGrid = function(element, elementIndex)
    Controller.RefreshFriendHelpElement(element, elementIndex)
  end,
  BossMenu_Group_Help_Img_BG_Group_HelpFriends_ScrollGrid_User_Group_User_Btn_Help_Click = function(btn, str)
    local elementIndex = tonumber(str) or 0
    local friendList = DataModel.GetHelpFriendList() or {}
    local info = friendList[elementIndex]
    if not info then
      return
    end
    local helpTime = DataModel.GetHelpBossTime() or 0
    if helpTime <= 0 then
      CommonTips.OpenTips(80609360)
      return
    end
    if 0 >= info.bossHp then
      CommonTips.OpenTips(80609362)
      return
    end
    local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
    if ca then
      local nowTime = TimeUtil:GetServerTimeStamp() or 0
      local mpyEndTime = TimeUtil:TimeStamp(ca.endTime) or 0
      local signEndTime = TimeUtil:TimeStamp(PlayerData.GetMonopolySignEnd()) or 0
      if nowTime >= mpyEndTime then
        CommonTips.OpenLoading(function()
          CBus:ChangeScene("Main")
        end)
        return
      elseif nowTime >= signEndTime then
        CommonTips.OpenLoading(function()
          CBus:ChangeScene("Main")
        end)
        return
      end
    end
    Controller.SetBoxBossFightState(true, true)
    DataModel.SetHelpBossTime(helpTime - 1)
    UIManager:ClosePanel()
    local status = {
      levelId = tonumber(DataModel.GetBossLevelId()) or 0,
      Current = "Monopoly",
      friendId = info.uid,
      extraUIParamData = {scene = "Monopoly"}
    }
    PlayerData.BattleCallBackPage = "UI/Monopoly/Monopoly"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  end,
  BossMenu_Group_Help_Img_BG_Group_AskHelp_ScrollGrid_User_SetGrid = function(element, elementIndex)
    Controller.RefreshAskHelpElement(element, elementIndex)
  end,
  BossMenu_Group_Help_Img_BG_Group_AskHelp_ScrollGrid_User_Group_User_Btn_AskHelp_Click = function(btn, str)
    local elementIndex = tonumber(str) or 0
    local friendList = DataModel.GetAskFriendList() or {}
    local friendInfo = friendList[elementIndex]
    if not friendInfo then
      return
    end
    local askTime = DataModel.GetAskBossTime() or 0
    if askTime <= 0 then
      CommonTips.OpenTips(80609365)
      return
    end
    if friendInfo.is_sign == 0 then
      CommonTips.OpenTips(80609383)
      return
    end
    local isAsked = DataModel.GetIsHadAsked(friendInfo.uid)
    if isAsked then
      CommonTips.OpenTips(80609364)
      return
    end
    Net:SendProto("monopoly.ask_boss_help", function(json)
      if string.nilorempty(json.rc) then
        DataModel.SetAskBossTime(askTime - 1)
        Controller.RefreshAskHelpTimeShow()
        DataModel.SetHadAskedByUid(friendInfo.uid)
        View.Group_Help.Img_BG.Group_AskHelp.ScrollGrid_User.grid.self:RefreshAllElement()
      end
    end, friendInfo.uid, DataModel.GetBossLevelId(), function(json)
      if json and not string.nilorempty(json) then
        Controller.CheckMPYIsOver()
      end
    end)
  end,
  BossMenu_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.OnQuitBtnClick()
  end,
  BossMenu_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  BossMenu_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BossMenu_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
