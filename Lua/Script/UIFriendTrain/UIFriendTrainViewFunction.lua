local View = require("UIFriendTrain/UIFriendTrainView")
local DataModel = require("UIFriendTrain/UIFriendTrainDataModel")
local ViewFunction = {
  FriendTrain_Group_TopLeft_Btn_Return_Click = function(btn, str)
    CommonTips.OpenLoadingCB(function()
      UIManager:Pause(false)
      PlayerData.visitMode = false
      UIManager.HomePage = "UI/MainUI/MainUI"
      if DataModel.backScene == "Home" then
        View.self:StartC(LuaUtil.cs_generator(function()
          LoadingManager:SetLoadingPercent(0.3)
          HomeCharacterManager:RecycleAll()
          coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
          DataModel.InitTrainData()
          UIManager:Open("UI/MainUI/MainUI")
          LoadingManager:SetLoadingPercent(0.8)
          coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
          if DataModel.backUI and DataModel.backUI == "FriendsList" then
            local UIFriendsListController = require("UIFriendsList/UIFriendsListController")
            UIFriendsListController.OpenFriendsList()
          else
            UIManager:Open("UI/Friends/Friends")
          end
          coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
          LoadingManager:SetLoadingPercent(1)
        end))
      else
        CBus:ChangeScene(DataModel.backScene, function()
          if DataModel.backUI and DataModel.backUI == "FriendsList" then
            local UIFriendsListController = require("UIFriendsList/UIFriendsListController")
            UIFriendsListController.OpenFriendsList()
          else
            UIManager:Open("UI/Friends/Friends")
          end
        end)
      end
    end)
  end,
  FriendTrain_Group_TopLeft_Btn_Home_Click = function(btn, str)
    CommonTips.OpenLoadingCB(function()
      UIManager:Pause(false)
      PlayerData.visitMode = false
      UIManager.HomePage = "UI/MainUI/MainUI"
      if DataModel.backScene == "Home" then
        View.self:StartC(LuaUtil.cs_generator(function()
          LoadingManager:SetLoadingPercent(0.3)
          HomeCharacterManager:RecycleAll()
          coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
          DataModel.InitTrainData()
          UIManager:Open("UI/MainUI/MainUI")
          LoadingManager:SetLoadingPercent(0.8)
          coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
          LoadingManager:SetLoadingPercent(1)
        end))
      else
        CBus:ChangeScene(DataModel.backScene)
      end
    end)
  end,
  FriendTrain_Group_TopLeft_Btn_Menu_Click = function(btn, str)
  end,
  FriendTrain_Group_TopLeft_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80307366)
  end,
  FriendTrain_Group_MainUI_Img_Head_Img_RubbishInfo_Btn_Take_Click = function(btn, str)
    if DataModel.canStoleRubbishNum <= 0 then
      CommonTips.OpenTips(GetText(80610170))
      return
    end
    local myBlock = PlayerData.visitInfo.my_rubbish_area.waste_block or 0
    local rubbushCapacity = PlayerData.visitInfo.my_rubbish_area.max_space or 0
    if myBlock >= rubbushCapacity then
      CommonTips.OpenTips(GetText(80610171))
      return
    end
    if 0 >= DataModel.RemainStoleCount then
      CommonTips.OpenTips(GetText(80610168))
      return
    end
    if DataModel.NextCanStoleTime >= TimeUtil:GetServerTimeStamp() then
      CommonTips.OpenTips(GetText(80610169))
      return
    end
    Net:SendProto("friend.steal_blocks", function(json)
      local friendLostBlock = json.block
      local myBlock = PlayerData.visitInfo.my_rubbish_area.waste_block or 0
      local rubbushCapacity = PlayerData.visitInfo.my_rubbish_area.max_space or 0
      local friendBlock = PlayerData.visitInfo.rubbish_area.waste_block
      PlayerData.visitInfo.my_rubbish_area.waste_block = myBlock + friendLostBlock
      PlayerData.visitInfo.rubbish_area.waste_block = friendBlock - friendLostBlock
      PlayerData.visitInfo.rubbish_area.stolen_cnt = PlayerData.visitInfo.rubbish_area.stolen_cnt + 1
      local cfg = PlayerData:GetFactoryData(99900192)
      if json.block ~= 0 then
        PlayerData.visitInfo.rubbish_area.success_cnt = PlayerData.visitInfo.rubbish_area.success_cnt + 1
      end
      local cfg = PlayerData:GetFactoryData(99900192)
      local baseRate = 1 - PlayerData.visitInfo.rubbish_area.success_cnt * cfg.doReduceRate
      PlayerData.visitInfo.rubbish_area.steal_rate = baseRate * PlayerData.visitInfo.rubbish_area.pet_ex_rate
      DataModel.RemainStoleCount = DataModel.RemainStoleCount - 1
      PlayerData.visitInfo.rubbish_area.stolen_ts = TimeUtil:GetServerTimeStamp()
      local config = PlayerData:GetFactoryData(99900192)
      local stoleCD = config.stealCD
      local lastStoleTime = PlayerData.visitInfo.rubbish_area.stolen_ts or 0
      DataModel.NextCanStoleTime = lastStoleTime + stoleCD
      friendBlock = PlayerData.visitInfo.rubbish_area.waste_block or 0
      myBlock = PlayerData.visitInfo.my_rubbish_area.waste_block or 0
      View.Group_MainUI.Img_Head.Img_RubbishInfo.Group_RubbushNum.Txt_Num:SetText(friendBlock)
      View.Group_MainUI.Img_Head.Img_RubbishInfo.Group_MyRubbush.Txt_Num:SetText(myBlock .. "/" .. rubbushCapacity)
      DataModel.UpdateStoleInfo()
      UIManager:Open("UI/Friends/StealResultIn", Json.encode({
        stealNum = math.abs(json.block)
      }))
    end, PlayerData.visitInfo.uid)
  end,
  FriendTrain_Group_MainUI_Btn_Pet_Click = function(btn, str)
    UIManager:Open("UI/HomePet/PetManage")
  end,
  FriendTrain_Group_MainUI_Img_Head_Btn_FreindsList_Click = function(btn, str)
    local UIFriendsListController = require("UIFriendsList/UIFriendsListController")
    UIFriendsListController.OpenFriendsList()
  end,
  FriendTrain_Group_Info_Btn_RateDesc_Click = function(btn, str)
    View.Group_RateTips:SetActive(true)
  end,
  FriendTrain_Group_RateTips_Btn_Close_Click = function(btn, str)
    View.Group_RateTips:SetActive(false)
  end
}
return ViewFunction
