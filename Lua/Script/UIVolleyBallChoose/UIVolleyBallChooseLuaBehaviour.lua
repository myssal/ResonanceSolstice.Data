local View = require("UIVolleyBallChoose/UIVolleyBallChooseView")
local DataModel = require("UIVolleyBallChoose/UIVolleyBallChooseDataModel")
local ViewFunction = require("UIVolleyBallChoose/UIVolleyBallChooseViewFunction")
local Timer = require("Common/Timer")
local timerPath = {
  "UI/VolleyBall/Volleyball_Countdown/0",
  "UI/VolleyBall/Volleyball_Countdown/1",
  "UI/VolleyBall/Volleyball_Countdown/2",
  "UI/VolleyBall/Volleyball_Countdown/3",
  "UI/VolleyBall/Volleyball_Countdown/4",
  "UI/VolleyBall/Volleyball_Countdown/5",
  "UI/VolleyBall/Volleyball_Countdown/6",
  "UI/VolleyBall/Volleyball_Countdown/7",
  "UI/VolleyBall/Volleyball_Countdown/8",
  "UI/VolleyBall/Volleyball_Countdown/9"
}

local function ChangeScene()
  LoadingManager:OpenLoading("UI/VolleyBall/VolleyBallMain_loading", nil, function()
    if MainManager.bgSceneName == "VolleyBallScene" then
      LoadingManager.loadingPercent = 1
      UIManager:Open("UI/VolleyBall/VolleyBallMain", Json.encode({reInit = true}))
      return
    else
      CBus:ChangeScene("VolleyBallScene")
    end
  end)
end

local function SetTimeSprite(path)
  View.Group_Choose.Group_Tips.Img_Countdown:SetSprite(path)
  View.Group_Choose.Group_Tips.Img_Countdown:SetLocalScale(0.3, 0.3, 0.3)
  View.Group_Choose.Group_Tips.Img_Countdown:SetLocalScale(0.9, 0.9, 0.9, 0.3, function()
  end)
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    DataModel.init(data)
    View.timer:Pause()
    View.Group_Choose.Group_Tips:SetActive(false)
    View.Group_Loading:SetActive(true)
    View.Group_Loading.Img_Logo.Img_txt:SetSprite(GetResPath(88300118))
    View.Group_Choose.ScrollGrid_.grid.self:SetDataCount(#DataModel.roleList)
    View.Group_Choose.ScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Choose.StaticGrid_.grid.self:RefreshAllElement()
    DataModel.PlaySound(30005405)
    View.self:PlayAnim("VolleyBallChoose_In", function()
      View.Group_Loading:SetActive(false)
      View.timer:Start()
      View.Group_Choose.Group_Tips:SetActive(true)
      View.Group_Choose.Group_Tips.Txt_PStage:SetActive(true)
      View.Group_Choose.Group_Tips.Img_Countdown:SetActive(true)
      View.Group_Choose.Group_Tips.Img_Countdown:SetSprite(timerPath[DataModel.remainTime])
      SetTimeSprite(timerPath[DataModel.remainTime])
      DataModel.PlaySound(30005401)
      View.Group_Choose.Group_Tips.Txt_AIstage:SetActive(false)
      View.Group_Choose.Group_Tips.Txt_Play:SetActive(false)
    end)
  end,
  awake = function()
    local aiReactionTs = math.random(2, 4)
    View.timer = Timer.New(1, function()
      if DataModel.status == 0 then
        DataModel.PlaySound(30005401)
        DataModel.remainTime = DataModel.remainTime - 1
        if 0 >= DataModel.remainTime then
          local id = DataModel.roleList[DataModel.nowSelectIdx].id
          local selected = DataModel.RoleIsSelect(id)
          if not selected then
            DataModel.UpdateSelectRoleInfo(id)
            DataModel.FindNextSelectId()
          end
          View.Group_Choose.Group_Tips.Img_Countdown:SetSprite(timerPath[DataModel.remainTime])
          SetTimeSprite(timerPath[DataModel.remainTime])
          View.Group_Choose.ScrollGrid_.grid.self:RefreshAllElement()
          View.Group_Choose.StaticGrid_.grid.self:RefreshAllElement()
          if DataModel.status == 1 then
            View.Group_Choose.Group_Tips.Txt_PStage:SetActive(false)
            View.Group_Choose.Group_Tips.Txt_AIstage:SetActive(true)
          end
        else
          SetTimeSprite(timerPath[DataModel.remainTime])
        end
        return
      end
      if DataModel.status == 1 then
        DataModel.PlaySound(30005401)
        DataModel.remainTime = DataModel.remainTime - 1
        if DataModel.aiTs - DataModel.remainTime >= aiReactionTs then
          DataModel.UpdateSelectRoleInfo(DataModel.roleList[DataModel.nowSelectIdx].id)
          if DataModel.status == 1 then
            DataModel.FindNextSelectId(true)
            aiReactionTs = math.random(2, 4)
          else
            View.Group_Choose.Group_Tips.Txt_Play:SetActive(true)
            View.Group_Choose.Group_Tips.Txt_AIstage:SetActive(false)
            View.Group_Choose.Group_Tips.Img_Countdown:SetActive(false)
          end
          View.Group_Choose.Group_Tips.Img_Countdown:SetSprite(timerPath[DataModel.remainTime])
          SetTimeSprite(timerPath[DataModel.remainTime])
          View.Group_Choose.ScrollGrid_.grid.self:MoveToPos(DataModel.nowSelectIdx)
          View.Group_Choose.ScrollGrid_.grid.self:RefreshAllElement()
          View.Group_Choose.StaticGrid_.grid.self:RefreshAllElement()
        else
          SetTimeSprite(timerPath[DataModel.remainTime])
        end
        return
      end
      if DataModel.status == 2 then
        DataModel.remainTime = DataModel.remainTime - 1
        if 0 >= DataModel.remainTime then
          View.Group_Choose.Group_Tips.Img_Countdown:SetActive(false)
          local gameType = "volleyball"
          local roles = DataModel.selectRoleList[1]
          local count = #DataModel.selectRoleList
          for i = 2, count do
            roles = roles .. ";" .. DataModel.selectRoleList[i]
          end
          if PlayerData.volleyBallData.gameMode == 0 then
            Net:SendProto("playground.start_mini_game", function(json)
              PlayerData.volleyBallData.uFid = json.gameUid
              ChangeScene()
            end, gameType, roles)
          else
            ChangeScene()
          end
          DataModel.status = -1
        else
        end
        return
      end
    end)
  end,
  start = function()
  end,
  update = function()
    View.timer:Update()
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
