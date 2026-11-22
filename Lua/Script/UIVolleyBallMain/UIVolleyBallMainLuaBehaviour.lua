local View = require("UIVolleyBallMain/UIVolleyBallMainView")
local DataModel = require("UIVolleyBallMain/UIVolleyBallMainDataModel")
local ViewFunction = require("UIVolleyBallMain/UIVolleyBallMainViewFunction")
local Ctrl = require("UIVolleyBallMain/UIVolleyBallMainController")

local function OnBallSetTarget()
  if not DataModel.BallHasSetTarget or DataModel.BallTargetX == nil or DataModel.BallTargetY == nil then
    return
  end
  if DataModel.VolleyGameManager == nil or DataModel.VolleyGameManager.isGameStart == false then
    return
  end
  if DataModel.VolleyGameManager.volleyball == nil or DataModel.VolleyGameManager.volleyball.landItem == nil then
    return
  end
  local newTarget = DataModel.VolleyGameManager.volleyball.landItem
  if newTarget.gridX ~= DataModel.BallTargetX or newTarget.gridY ~= DataModel.BallTargetY or newTarget.teamid ~= DataModel.BallTargetTeamID then
    local hitType = newTarget.teamid == DataModel.BallTargetTeamID and "passFriend" or "passEnemy"
    Ctrl.onHitBallSetTarget(hitType, newTarget.gridX, newTarget.gridY)
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.VolleyGameManager = CBus:GetManager(CS.ManagerName.VolleyGameManager, true)
    if initParams and initParams.reInit then
      local data = Json.decode(initParams)
      if data and data.reInit then
        DataModel.VolleyGameManager:InitData()
        DataModel.VolleyGameManager:InitGrid()
      end
    end
    DataModel.VolleyGameManager.volleyball.shakeDur = 0.1
    DataModel.VolleyGameManager.volleyball.strengthX = 1
    DataModel.VolleyGameManager.volleyball.strengthY = 1
    DataModel.VolleyGameManager.volleyball.strengthZ = 1
    DataModel.VolleyGameManager.volleyball.vibrato = 30
    DataModel.VolleyGameManager.volleyball.randomness = 0
    DataModel.VolleyGameManager.volleyball.hitGroundSoundID = 30005392
    DataModel.VolleyGameManager.volleyball.hitRoleSoundID = 30005192
    DataModel.VolleyGameManager.curRoleUI.transform:SetParent(nil)
    local players = DataModel.VolleyGameManager.players
    if players then
      for i = 0, players.Length - 1 do
        players[i]:Recycle()
      end
    end
    DataModel.VolleyGameManager:InitModel(PlayerData.volleyBallData.team0, PlayerData.volleyBallData.team1)
    DataModel.VolleyGameManager.CameraCtrl:SetViewPos(Vector3(0.11, 1.921, 0))
    DataModel.VolleyGameManager.CameraCtrl.ViewDistance = 30
    DataModel.VolleyGameManager.CameraCtrl.SmoothTime = 0.001
    DataModel.VolleyGameManager.CameraCtrl.Custom_FovMaxSpeed = nil
    local alert = DataModel.VolleyGameManager.go_game.transform:Find("alert")
    local time = 0
    while alert do
      CS.UnityEngine.GameObject.DestroyImmediate(alert.gameObject)
      alert = DataModel.VolleyGameManager.go_game.transform:Find("alert")
      time = time + 1
      if 100 <= time then
        break
      end
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    OnBallSetTarget()
    if DataModel.WaitQTE and DataModel.VolleyGameManager.isBulletTime then
      Ctrl.ShowQTE()
    end
    if DataModel.isStart == false then
      return
    end
    local player = DataModel.VolleyGameManager.playerTeam == 0 and View.Group_QTE.Img_LeftQTE or View.Group_QTE.Img_RightQTE
    local enemy = DataModel.VolleyGameManager.playerTeam == 1 and View.Group_QTE.Img_LeftQTE or View.Group_QTE.Img_RightQTE
    local temp = DataModel.VolleyGameManager.scaleSpeed / 100 * Time.deltaTime
    local playerqte = player.Img.fillAmount + temp
    playerqte = math.min(1, playerqte)
    if DataModel.PlayerQTE and playerqte > DataModel.PlayerQTE then
      playerqte = DataModel.PlayerQTE
    end
    player:SetFilledImgAmount(playerqte)
    local pWidth = View.Group_QTE.Img_LeftQTE:GetSize().x * (1 - playerqte)
    View.Group_QTE.Img_signBlue:SetAnchoredPositionX(-pWidth)
    local enemyDone = false
    local enemyQTE = enemy.Img.fillAmount + temp
    if enemyQTE >= DataModel.EnemyQTE then
      enemyDone = true
      enemyQTE = DataModel.EnemyQTE
    end
    enemy:SetFilledImgAmount(enemyQTE)
    pWidth = View.Group_QTE.Img_RightQTE:GetSize().x * (1 - enemyQTE)
    View.Group_QTE.Img_signRed:SetAnchoredPositionX(pWidth)
    if 1 <= player.Img.fillAmount then
      DataModel.PlayerQTE = 1
    end
    if DataModel.PlayerQTE and enemyDone and not DataModel.waitResult then
      DataModel.waitResult = true
      DataModel.waitResultTime = 0
      Ctrl.ShowQTEResult()
    end
    if DataModel.waitResult then
      DataModel.waitResultTime = DataModel.waitResultTime + Time.deltaTime
    end
    if DataModel.waitResultTime >= 1.5 then
      DataModel.waitResult = false
      DataModel.waitResultTime = 0
      Ctrl:QTEResult()
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    Ctrl.OnDisenable()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
