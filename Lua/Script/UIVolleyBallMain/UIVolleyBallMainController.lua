local DataModel = require("UIVolleyBallMain/UIVolleyBallMainDataModel")
local View = require("UIVolleyBallMain/UIVolleyBallMainView")
local TimerHelper = require("Common/Timer/TimerHelper")
local module = {}
local qteSound, resultAnim, ballPointEffect, ballPointEffect2

local function InitMVPData(playerWin, isExit)
  if not isExit then
    local hitPlayer = DataModel.VolleyGameManager:GetRole(DataModel.VolleyGameManager.volleyball.lastHitTeamID, DataModel.VolleyGameManager.volleyball.lastHitRoleTeamUnitID)
    if hitPlayer then
      hitPlayer.Score = hitPlayer.Score + 1
    end
  end
  local mvpUnit = DataModel.VolleyGameManager:GetMVP()
  local t = playerWin and "MVP" or "SMVP"
  View.Group_Over.Group_Result.Img_MVPBG.Img_MVP.Txt_:SetText(t)
  local player = DataModel.VolleyGameManager:GetRole(0, 0)
  resultAnim = nil
  if player ~= nil and player.ca ~= nil then
    local unitCA = PlayerData:GetFactoryData(player.ca.id)
    if unitCA then
      local headCA = PlayerData:GetFactoryData(unitCA.profilePhoto)
      View.Group_Over.Group_Result.Group_Players.Img_Photo1.Btn_ProfilePhoto1.Img_Client:SetSprite(headCA.imagePath)
    end
    if mvpUnit == player.ca.id then
      View.Group_Over.Group_Result.Img_MVPBG.Txt_Name:SetText(unitCA.roleName)
      View.Group_Over.Group_Result.Img_MVPBG.Txt_Num:SetText(player.Score)
      View.Group_Over.Group_Result.SpineNode_Role:SetData(unitCA.resPath, "")
      resultAnim = player.ca:GetRandomSHAnim(not playerWin)
    end
  end
  player = DataModel.VolleyGameManager:GetRole(0, 1)
  if player ~= nil and player.ca ~= nil then
    local unitCA = PlayerData:GetFactoryData(player.ca.id)
    if unitCA then
      local headCA = PlayerData:GetFactoryData(unitCA.profilePhoto)
      View.Group_Over.Group_Result.Group_Players.Img_Photo2.Btn_ProfilePhoto2.Img_Client:SetSprite(headCA.imagePath)
    end
    if mvpUnit == player.ca.id then
      View.Group_Over.Group_Result.Img_MVPBG.Txt_Name:SetText(unitCA.roleName)
      View.Group_Over.Group_Result.Img_MVPBG.Txt_Num:SetText(player.Score)
      View.Group_Over.Group_Result.SpineNode_Role:SetData(unitCA.resPath, "")
      resultAnim = player.ca:GetRandomSHAnim(not playerWin)
    end
  end
  if hitPlayer then
    hitPlayer.Score = hitPlayer.Score - 1
  end
end

function module.StartQTE(teamid)
  if DataModel.isStart then
    return
  end
  DataModel.WaitQTE = true
  DataModel.waitResult = false
  DataModel.waitResultTime = 0
  DataModel.EnemyQTE = math.random(0, 90) / 100
  View.Group_Common:SetActive(false)
  View.Group_QTE.Img_LeftQTE:SetFilledImgAmount(0)
  View.Group_QTE.Img_RightQTE:SetFilledImgAmount(0)
  View.Group_QTE.Img_RightQTE.Img.fillOrigin = 1
  DataModel.PlayerQTE = nil
  DataModel.teamID = teamid
  View.Group_Over.self:SetActive(false)
  View.Group_QTE.Group_circle:SetActive(false)
  View.Group_QTE.Img_signBlue:SetActive(false)
  View.Group_QTE.Img_signRed:SetActive(false)
  View.Group_QTE.self:SetActive(true)
  TimerHelper.Start("QTESound", 1, function()
    qteSound = SoundManager:CreateSound(30005393)
    CheckLoopSound(qteSound)
    TimerHelper.Stop("QTESound")
  end)
end

function module.ShowQTE()
  DataModel.WaitQTE = false
  DataModel.isStart = true
  View.Group_QTE.Group_circle:SetActive(true)
  View.Group_QTE.Img_signBlue:SetActive(true)
  View.Group_QTE.Img_signRed:SetActive(true)
end

function module.QTEOver()
  DataModel.isStart = false
  View.self:SelectPlayAnim(View.Group_QTE.self, "VolleyBallMain_QTE_Out", function()
    View.Group_QTE.self:SetActive(false)
    View.Group_QTE.Group_QTEResult.Group_Low:SetActive(false)
    View.Group_QTE.Group_QTEResult.Group_Perfect:SetActive(false)
    View.Group_QTE.Group_QTEResult.Group_Good:SetActive(false)
    View.Group_QTE.Group_QTEResult.Group_Wrong:SetActive(false)
  end)
  View.Group_Common:SetActive(true)
end

function module.DefenceSuc()
  DataModel.VolleyGameManager:StrikeFailBall()
end

function module.DefenceSuc2()
  DataModel.VolleyGameManager:StrikeFailBall2()
end

function module.DefenceFail()
  DataModel.VolleyGameManager:StrikeSucBall()
end

function module.AtkMiss()
  DataModel.VolleyGameManager:StrikMissBall()
end

function module:QTEResult()
  DataModel.isStart = false
  local playerRate = DataModel.PlayerQTE * 100
  local enemyRate = DataModel.EnemyQTE * 100
  local temp = playerRate - enemyRate
  DataModel.PlayerQTE = nil
  DataModel.EnemyQTE = nil
  local mag = DataModel.VolleyGameManager
  local attacker = 0
  local defencer = 0
  if DataModel.teamID == mag.playerTeam then
    attacker = enemyRate
    defencer = playerRate
  else
    attacker = playerRate
    defencer = enemyRate
  end
  if attacker > mag.centerMissSize then
    self.AtkMiss()
  elseif defencer > mag.centerMissSize then
    self.DefenceFail()
  elseif attacker > defencer then
    self.DefenceFail()
  else
    local cha = defencer - attacker
    if cha > mag.checkSize then
      self.DefenceSuc2()
    else
      self.DefenceSuc()
    end
  end
end

function module.NetGameOver(reward)
  Time.fixedDeltaTime = DataModel.fiexdDeltaTime
  DataModel.WaitNetResult = false
  module.RefreshScore()
  if PlayerData.volleyBallData.gameMode == 0 then
    View.Group_Over.Group_Btns.Img_LeftTime:SetActive(true)
    local cfgCA = PlayerData:GetFactoryData(DataModel.VolleyGameManager.ca.id)
    local already = PlayerData:GetHomeInfo().vb_num and cfgCA.rewardNum - PlayerData:GetHomeInfo().vb_num or 0
    View.Group_Over.Group_Btns.Img_LeftTime.Txt_Txt:SetText(already .. "/" .. cfgCA.rewardNum)
  else
    View.Group_Over.Group_Btns.Img_LeftTime:SetActive(false)
  end
  View.Group_Common.self:SetActive(false)
  View.Group_Over.self:SetActive(true)
  local rewardActive = reward ~= nil and reward.item ~= nil
  View.Group_Over.Group_Result.Img_RewordBG:SetActive(rewardActive)
  if rewardActive then
    View.Group_Over.Group_Result.Img_RewordBG.ScrollGrid_.grid.self:SetDataCount(0)
    View.Group_Over.Group_Result.Img_RewordBG.ScrollGrid_.grid.self:RefreshAllElement()
  end
  local players = DataModel.VolleyGameManager.players
  if players then
    for i = 0, players.Length - 1 do
      if players[i].particlePart then
        players[i].particlePart:Clear()
      end
      if players[i].model then
        local childNum = players[i].model.transform.childCount
        for m = childNum - 1, 0, -1 do
          local child = players[i].model.transform:GetChild(m)
          if child then
            local particle = child:GetComponentInChildren(typeof(CS.UnityEngine.ParticleSystem))
            if particle then
              particle:Stop()
            end
            child:SetParent(nil)
          end
        end
      end
    end
  end
  View.self:PlayAnim("VolleyBallMain_Group_Over", function()
    if resultAnim then
      View.Group_Over.Group_Result.SpineNode_Role:SetAction(resultAnim.animName)
      View.Group_Over.Group_Result.SpineNode_Role:SetAction("volleyball_stand_03", true)
    end
    if reward and reward.item then
      View.Group_Over.Group_Result.Img_RewordBG:SetActive(true)
      DataModel.Rewards = {}
      for k, v in pairs(reward.item) do
        table.insert(DataModel.Rewards, {
          id = k,
          num = v.num
        })
      end
      View.Group_Over.Group_Result.Img_RewordBG.ScrollGrid_.grid.self:SetDataCount(#DataModel.Rewards)
      View.Group_Over.Group_Result.Img_RewordBG.ScrollGrid_.grid.self:RefreshAllElement()
    else
    end
  end)
end

function module.ShowWin()
  TimerHelper.Start("WaitEnd", 0.3, function()
    View.Group_Over.Group_Result.Img_BgVague:SetSprite("UI\\VolleyBall\\Over\\BG")
    View.Group_Over.Group_Result.Img_Result:SetSprite("UI\\VolleyBall\\Over\\victory")
    View.Group_Over.Group_Result.Img_RewordBG:SetSprite("UI\\VolleyBall\\Over\\reward_bg")
    View.Group_Over.Group_Result.Group_RoleRound.Img_Lose1:SetActive(false)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Lose2:SetActive(false)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Win1:SetActive(true)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Win2:SetActive(true)
    InitMVPData(true)
    DataModel.WaitNetResult = true
    if PlayerData.volleyBallData.gameMode == 0 then
      Net:SendProto("playground.end_mini_game", function(json)
        PlayerData:GetHomeInfo().vb_num = PlayerData:GetHomeInfo().vb_num + 1
        if json and json.reward then
          local sound = SoundManager:CreateSound(30005410)
          CheckLoopSound(sound)
          module.NetGameOver(json.reward)
        end
      end, PlayerData.volleyBallData.uFid, 1, function()
        PlayerData:GetHomeInfo().vb_num = PlayerData:GetHomeInfo().vb_num + 1
        local sound = SoundManager:CreateSound(30005410)
        CheckLoopSound(sound)
        module.NetGameOver()
      end)
    else
      local sound = SoundManager:CreateSound(30005410)
      CheckLoopSound(sound)
      module.NetGameOver()
    end
    TimerHelper.Stop("WaitEnd")
  end)
end

function module.ShowLose(isExit)
  TimerHelper.Start("WaitEnd", 0.3, function()
    View.Group_Over.Group_Result.Img_BgVague:SetSprite("UI\\VolleyBall\\Over\\BG")
    View.Group_Over.Group_Result.Img_Result:SetSprite("UI\\VolleyBall\\Over\\defeat")
    View.Group_Over.Group_Result.Img_RewordBG:SetSprite("UI\\VolleyBall\\Over\\loseBG")
    View.Group_Over.Group_Result.Group_RoleRound.Img_Lose1:SetActive(true)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Lose2:SetActive(true)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Win1:SetActive(false)
    View.Group_Over.Group_Result.Group_RoleRound.Img_Win2:SetActive(false)
    InitMVPData(false, isExit)
    DataModel.WaitNetResult = true
    if PlayerData.volleyBallData.gameMode == 0 then
      Net:SendProto("playground.end_mini_game", function(json)
        PlayerData:GetHomeInfo().vb_num = PlayerData:GetHomeInfo().vb_num + 1
        if json and json.reward then
          local sound = SoundManager:CreateSound(30005409)
          CheckLoopSound(sound)
          module.NetGameOver(json.reward)
        end
      end, PlayerData.volleyBallData.uFid, 0, function()
        PlayerData:GetHomeInfo().vb_num = PlayerData:GetHomeInfo().vb_num + 1
        local sound = SoundManager:CreateSound(30005409)
        CheckLoopSound(sound)
        module.NetGameOver()
      end)
    else
      local sound = SoundManager:CreateSound(30005409)
      CheckLoopSound(sound)
      module.NetGameOver()
    end
    TimerHelper.Stop("WaitEnd")
  end)
end

function module.ShowQTEResult()
  local sound
  if qteSound then
    qteSound:Stop()
    qteSound = nil
  end
  if DataModel.PlayerQTE * 100 > DataModel.VolleyGameManager.centerMissSize then
    sound = SoundManager:CreateSound(30005396)
    View.Group_QTE.Group_QTEResult.Group_Wrong:SetActive(true)
  else
    local cha = (DataModel.EnemyQTE - DataModel.PlayerQTE) * 100
    if cha < 0 then
      sound = SoundManager:CreateSound(30005394)
      View.Group_QTE.Group_QTEResult.Group_Good:SetActive(true)
    elseif cha < DataModel.VolleyGameManager.checkSize then
      sound = SoundManager:CreateSound(30005395)
      View.Group_QTE.Group_QTEResult.Group_Low:SetActive(true)
    elseif cha >= DataModel.VolleyGameManager.checkSize then
      sound = SoundManager:CreateSound(30005395)
      View.Group_QTE.Group_QTEResult.Group_Low:SetActive(true)
    end
  end
  if sound then
    CheckLoopSound(sound)
  end
end

function module.OnRoleAnim(animName, roleTeam, roleUnitID)
  if animName == "volleyball_serve_1" then
  elseif animName == "volleyball_serve_2" then
    local role = DataModel.VolleyGameManager:GetRole(roleTeam, roleUnitID)
    if role then
      local skeleton = role.particlePart:AddSkeleton("Volleyball\\Spine\\volleyball_effect\\volleyball_effect_SkeletonData")
      if skeleton then
        skeleton.transform.position = role.model.transform.position
        skeleton.skeleton.ScaleX = role.animePart:GetDir()
        skeleton.gameObject:SetActive(true)
        skeleton.state:SetAnimation(0, animName, false)
      end
    end
  elseif animName == "volleyball_serve_3" then
    local role = DataModel.VolleyGameManager:GetRole(roleTeam, roleUnitID)
    if role then
      local skeleton = role.particlePart:AddSkeleton("Volleyball\\Spine\\volleyball_effect\\volleyball_effect_SkeletonData")
      if skeleton then
        skeleton.transform.position = role.model.transform.position
        skeleton.skeleton.ScaleX = role.animePart:GetDir()
        skeleton.gameObject:SetActive(true)
        skeleton.state:SetAnimation(0, animName, false)
      end
    end
  end
end

function module.OnRoleAnimEnd(animName, roleTeam, roleUnitID)
  if animName == "volleyball_serve_1" then
  elseif animName == "volleyball_serve_2" then
    local role = DataModel.VolleyGameManager:GetRole(roleTeam, roleUnitID)
    if role then
      role.particlePart:RemoveSkeleton("Volleyball\\Spine\\volleyball_effect\\volleyball_effect_SkeletonData")
    end
  elseif animName == "volleyball_serve_3" then
    local role = DataModel.VolleyGameManager:GetRole(roleTeam, roleUnitID)
    if role then
      role.particlePart:RemoveSkeleton("Volleyball\\Spine\\volleyball_effect\\volleyball_effect_SkeletonData")
    end
  end
end

function module.onHitBallSetTarget(hitType, gridX, girdY)
  local team = 0
  DataModel.BallHasSetTarget = true
  DataModel.BallTargetX = gridX
  DataModel.BallTargetY = girdY
  if hitType == "strikeToAttacker" then
    team = DataModel.VolleyGameManager.volleyball.teamID
    DataModel.VolleyGameManager.CameraCtrl:Shake(0.15, 1, 1, 1, 30, 0)
  elseif hitType == "strikeToDefencer" then
    team = 1 - DataModel.VolleyGameManager.volleyball.teamID
    DataModel.VolleyGameManager.CameraCtrl:Shake(0.15, 1, 1, 1, 30, 0)
  elseif hitType == "skikeToPos" then
    team = 1 - DataModel.VolleyGameManager.volleyball.teamID
    DataModel.VolleyGameManager.CameraCtrl:Shake(0.15, 1, 1, 1, 30, 0)
  elseif hitType == "serve" then
    team = DataModel.VolleyGameManager.volleyball.teamID
  elseif hitType == "passFriend" then
    team = DataModel.VolleyGameManager.volleyball.teamID
  elseif hitType == "passEnemy" then
    team = 1 - DataModel.VolleyGameManager.volleyball.teamID
  end
  DataModel.BallTargetTeamID = team
  local grid = DataModel.VolleyGameManager:GetGrid(team, gridX, girdY)
  if grid then
    if ballPointEffect == nil then
      ballPointEffect = CS.UnityEngine.GameObject.Find("VolleyBall_dimian")
    end
    if ballPointEffect2 == nil then
      ballPointEffect2 = CS.UnityEngine.GameObject.Find("VolleyBall_dimian02")
    end
    if team == 0 then
      if ballPointEffect then
        ballPointEffect.transform.position = grid.transform.position
      end
      if ballPointEffect2 then
        ballPointEffect2.transform.position = Vector3(10000, 10000, 10000)
      end
    else
      if ballPointEffect2 then
        ballPointEffect2.transform.position = grid.transform.position
      end
      if ballPointEffect then
        ballPointEffect.transform.position = Vector3(10000, 10000, 10000)
      end
    end
  end
end

function module.onHitBall(hitType)
  if hitType == 1 then
    local spikeType = DataModel.VolleyGameManager.atkPlayer.statePart.attackState.strikeType
    if spikeType == CS.BeachVolleyBall.enStrikeType.strikeToPos then
      DataModel.VolleyGameManager.volleyball:SetRollParam(true, 3, 5, 1)
    end
  end
end

function module.RefreshScore()
  local t1 = DataModel.VolleyGameManager.Team1Score
  View.Group_Common.Img_ScoreBG.Txt_Team1Score2:SetText(t1)
  View.Group_Over.Img_ScoreBG.Txt_Team1Score2:SetText(t1)
  local t2 = DataModel.VolleyGameManager.Team2Score
  View.Group_Common.Img_ScoreBG.Txt_Team2Score2:SetText(t2)
  View.Group_Over.Img_ScoreBG.Txt_Team2Score2:SetText(t2)
end

function module.ShowScoreAnim(playerWin, callBack)
  if playerWin then
    View.Group_ChangeRound.Img_RoundResultBG:SetSprite("UI\\VolleyBall\\round\\roundBG")
    View.Group_ChangeRound.Img_RoundResultBG.Img_Img:SetSprite("UI\\VolleyBall\\round\\victory")
  else
    View.Group_ChangeRound.Img_RoundResultBG:SetSprite("UI\\VolleyBall\\round\\resultBG")
    View.Group_ChangeRound.Img_RoundResultBG.Img_Img:SetSprite("UI\\VolleyBall\\round\\defeat")
  end
  View.Group_ChangeRound:SetActive(true)
  View.Group_ChangeRound.Img_RoundResultBG:SetActive(true)
  DataModel.IsPlayAnim = true
  local sound = SoundManager:CreateSound(playerWin and 30005193 or 30005194)
  CheckLoopSound(sound)
  View.self:SelectPlayAnim(View.Group_ChangeRound.Img_RoundResultBG.self, "RoundResult", function()
    View.Group_ChangeRound.Img_RoundResultBG:SetActive(false)
    DataModel.IsPlayAnim = false
    callBack()
  end)
end

function module.ShowNextRoundAnim(callBack)
  DataModel.BallHasSetTarget = false
  View.Group_ChangeRound:SetActive(true)
  View.Group_ChangeRound.Img_RoundBG:SetActive(true)
  local curRound = DataModel.VolleyGameManager.Team1Score + DataModel.VolleyGameManager.Team2Score + 1
  View.Group_ChangeRound.Img_RoundBG.Img_Num:SetSprite("UI\\VolleyBall\\round\\" .. curRound)
  DataModel.IsPlayAnim = true
  View.self:SelectPlayAnim(View.Group_ChangeRound.Img_RoundBG.self, "Round", function()
    DataModel.IsPlayAnim = false
    View.Group_Common.Img_ScoreBG.Img_Round.Txt_Round:SetText("Round " .. curRound)
    View.Group_ChangeRound.Img_RoundBG:SetActive(false)
    DataModel.VolleyGameManager.CameraCtrl.Custom_DisMaxSpeed = nil
    callBack()
  end)
  if ballPointEffect then
    ballPointEffect.transform.position = Vector3(0, 10000, 0)
  end
  if ballPointEffect2 then
    ballPointEffect2.transform.position = Vector3(0, 10000, 0)
  end
end

function module.ShowGameStart()
  View.Group_QTE:SetActive(false)
  View.Group_Common:SetActive(false)
  View.Group_Over:SetActive(false)
  View.Group_ChangeRound:SetActive(true)
  View.Group_ChangeRound.Img_RoundBG:SetActive(false)
  View.Group_ChangeRound.Img_RoundResultBG:SetActive(false)
  View.Group_ChangeRound.Img_First.self:SetSprite(GetResPath(88300116))
  View.Group_ChangeRound.Img_Rearhand.self:SetSprite(GetResPath(88300117))
  View.Group_ChangeRound.Img_First:SetActive(PlayerData.volleyBallData.first == 0)
  View.Group_ChangeRound.Img_Rearhand:SetActive(PlayerData.volleyBallData.first ~= 0)
  local configCa = PlayerData:GetFactoryData(DataModel.VolleyGameManager.ca.id)
  if configCa then
    DataModel.VolleyGameManager.WinScore = configCa.winCondition
  end
  DataModel.fiexdDeltaTime = Time.fixedDeltaTime
  Time.fixedDeltaTime = 0.0167
  local sound1 = SoundManager:CreateSound(30005404)
  CheckLoopSound(sound1)
  View.self:PlayAnim("VolleyBallMain_In", function()
    View.Group_ChangeRound.Img_First:SetActive(false)
    View.Group_ChangeRound.Img_Rearhand:SetActive(false)
    DataModel.VolleyGameManager:ResetSorce()
    module.RefreshScore()
    local sound = SoundManager:CreateSound(30005190)
    CheckLoopSound(sound)
    module.ShowNextRoundAnim(function()
      View.Group_ChangeRound:SetActive(false)
      View.Group_Common:SetActive(true)
      DataModel.VolleyGameManager.CameraCtrl.Custom_FovMaxSpeed = 20
      DataModel.VolleyGameManager:StartGame(0, PlayerData.volleyBallData.first)
    end)
  end)
end

function module.showNextRound(playerWin)
  local nextServeTeam = playerWin and 1 - DataModel.VolleyGameManager.playerTeam or DataModel.VolleyGameManager.playerTeam
  module.RefreshScore()
  DataModel.IsPlayAnim = true
  TimerHelper.Start("WaitBallFallSound", 0.3, function()
    local sound = SoundManager:CreateSound(30005191)
    CheckLoopSound(sound)
    local waitTime = DataModel.VolleyGameManager.atkPlayer and DataModel.VolleyGameManager.atkPlayer.IsAir and 1 or 0.5
    DataModel.VolleyGameManager.nextHitPlayer = -1
    TimerHelper.Start("WaitNextRound", waitTime, function()
      DataModel.IsPlayAnim = false
      DataModel.VolleyGameManager:PlayGameOverAnim(playerWin and 0 or 1)
      module.ShowScoreAnim(playerWin, function()
        module.ShowNextRoundAnim(function()
          View.Group_ChangeRound:SetActive(false)
          local players = DataModel.VolleyGameManager.players
          if players then
            for index = 0, 3 do
              if players[index] then
                players[index].IsServe = false
              end
            end
          end
          DataModel.VolleyGameManager:ReStart(nextServeTeam)
        end)
      end)
      TimerHelper.Stop("WaitNextRound")
    end)
    TimerHelper.Stop("WaitBallFallSound")
  end)
end

function module.OnDisenable()
  if ballPointEffect then
    ballPointEffect.transform.position = Vector3(0, 10000, 0)
    ballPointEffect = nil
  end
  if ballPointEffect2 then
    ballPointEffect2.transform.position = Vector3(0, 10000, 0)
    ballPointEffect2 = nil
  end
  resultAnim = nil
end

return module
