local View = require("UIHomeBubble/UIHomeBubbleView")
local DataModel = require("UIHomeBubble/UIHomeBubbleDataModel")
local Controller = require("UIHomeBubble/UIHomeBubbleController")
local ViewFunction = {
  HomeBubble_Btn_Close_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Group_Title_Btn_Info_Click = function(btn, str)
    Controller:SwitchShow()
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Btn_Upgrade_Click = function(btn, str)
    View.self:CloseUI()
    local t = {}
    t.furUfid = DataModel.curFurUfid
    t.furId = DataModel.curFurId
    UIManager:Open("UI/HomeUpgrade/HomeUpgrade", Json.encode(t))
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Btn_Interactive_Click = function(btn, str)
    Controller:TempFishErrorSolved()
    local furCA = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
    if (furCA.interfaceUrl == "UI/ChangeSkin/ChangeSkin" or furCA.interfaceUrl == "UI/Database/database" or furCA.functionType == 12600143) and CommonTips.GuideAsset() then
      return
    end
    if furCA.interfaceUrl == "UI/Home/HomeEmergency/HomeEmergency" then
      Controller:RefreshEmergency(true)
      View.Group_Panel.Img_Glass.Img_BubbleBG.Btn_Interactive:SetActive(false)
      return
    end
    if furCA.interfaceUrl == "UI/VolleyBall/VolleyBall_open" then
      local lv = CommonCoachData.GetCurPlaygroundServerInfo().lv
      local openCondition = furCA.openCondition
      if lv < openCondition[1].num then
        local name = PlayerData:GetFactoryData(openCondition[1].id).name
        CommonTips.OpenTips(string.format(GetText(80608279), name, openCondition[1].num))
        return
      end
    end
    local camFocus = false
    if furCA.interfaceUrl ~= nil and furCA.interfaceUrl ~= "" then
      UIManager:GoBack(false)
      if furCA.functionType == 12600143 or furCA.functionType == 12600187 or furCA.functionType == 12600144 then
        local mainUIView = require("UIMainUI/UIMainUIView")
        local mainUIController = require("UIMainUI/UIMainUIController")
        local data = {}
        data.onlyShow = true
        data.ufid = DataModel.curFurUfid
        if UIManager:IsPanelOpened("UI/MainUI/MainUI") then
          mainUIController:ExitTo(furCA.interfaceUrl, Json.encode(data))
        else
          UIManager:Open(furCA.interfaceUrl, Json.encode(data))
        end
        local v3 = Vector3(furCA.checkCameraX, furCA.checkCameraY, furCA.checkCameraZ)
        HomeManager:CamFocusToFurniture(DataModel.curFurUfid, v3, furCA.checkCameraTime, false, furCA.focusCamMove, function()
        end)
        camFocus = true
      elseif furCA.interfaceUrl == "UI/ChangeSkin/ChangeSkin" then
        UIManager:Open("UI/ChangeSkin/ChangeSkin")
      elseif furCA.functionType == 12600294 then
        UIManager:Open(furCA.interfaceUrl, Json.encode(EnumDefine.Depot.FridgeItem))
      elseif furCA.interfaceUrl == "UI/Home/NewHomeLive" then
        local v3 = Vector3(furCA.checkCameraX, furCA.checkCameraY, furCA.checkCameraZ)
        HomeManager:CamFocusToFurniture(DataModel.curFurUfid, v3, furCA.checkCameraTime, false, furCA.focusCamMove, function()
        end)
        camFocus = true
        UIManager:Open(furCA.interfaceUrl, Json.encode({
          ufid = DataModel.curFurUfid
        }))
      elseif furCA.interfaceUrl == "UI/Island_Battle/Island_Battle" then
        local activityCA = PlayerData:GetFactoryData(86000016)
        if activityCA.levelEndTime ~= "" and TimeUtil:GetServerTimeStamp() > TimeUtil:TimeStamp(activityCA.levelEndTime) then
          CommonTips.OpenTips(80607798)
          return
        end
        local isLandDataModel = require("UIIslandActivity/UIIslandActivityDataModel")
        if activityCA.levelQuestLimit ~= -1 and isLandDataModel:QuestIsFinish(activityCA.levelQuestLimit) == false then
          local questCA = PlayerData:GetFactoryData(activityCA.levelQuestLimit)
          local text = string.format(GetText(80607796), questCA.name)
          CommonTips.OpenTips(text, true)
          return
        end
        UIManager:Open("UI/Island_Battle/Island_Battle", Json.encode({activityId = 86000016, isPlayGround = true}))
      else
        local buildingId
        if furCA.buildingId and furCA.buildingId > 0 then
          buildingId = furCA.buildingId
        end
        UIManager:Open(furCA.interfaceUrl, Json.encode({
          ufid = DataModel.curFurUfid,
          furId = DataModel.curFurId,
          buildingId = buildingId
        }))
      end
    else
      if DataModel.CurHomeFurniture == nil then
        DataModel.CurHomeFurniture = HomeManager:GetFurniture(DataModel.curFurUfid)
      end
      DataModel.CurHomeFurniture:PlayAnimationByState(DataModel.ToAnimationState)
      PlayerData:SetPlayerPrefs("int", "FurnitureAnimationState" .. DataModel.curFurUfid, DataModel.ToAnimationState)
      UIManager:GoBack(false)
    end
    if camFocus then
      CharacterUtil.FocusResetMovePart()
      local furData = CommonCoachData.GetFurData()[tostring(DataModel.curFurUfid)]
      local roles = furData.roles
      if roles then
        for opIndex, uid in pairs(roles) do
          local opTime = -1
          if furCA.interfaceUrl == "UI/Home/NewHomeLive" then
            opTime = PlayerData:GetRoleRemainSleepTime(uid)
          end
          if opTime ~= 0 then
            CharacterUtil.InitOp(uid, DataModel.curFurUfid, opIndex - 1, opTime)
          end
        end
      end
    end
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Btn_CharacterInteractive_Click = function(btn, str)
    if DataModel.curFurId == "81300016" then
      local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
      if TradeDataModel.GetIsTravel() then
        CommonTips.OpenTips(80608659)
      end
    end
    local gender = PlayerData:GetUserInfo().gender or 1
    local conductor = gender == 1 and 10000137 or 10000173
    local stop = tonumber(str) == 0
    if stop then
      CharacterUtil.StopOp(conductor, true)
    else
      CharacterUtil.StartOp(conductor, DataModel.curFurUfid, 0, 15, true)
    end
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.self:CloseUI()
    end))
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Group_Working_Group_add_Btn__Click = function(btn, str)
    local furCA = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
    UIManager:Open(furCA.interfaceUrl, Json.encode({
      ufid = DataModel.curFurUfid,
      furId = DataModel.curFurId
    }))
  end,
  HomeBubble_Group_Panel_Img_Glass_Img_BubbleBG_Group_Working_Group_change_Group_Member_Btn_Change_Click = function(btn, str)
    local furCA = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
    UIManager:Open(furCA.interfaceUrl, Json.encode({
      ufid = DataModel.curFurUfid,
      furId = DataModel.curFurId
    }))
  end
}
return ViewFunction
