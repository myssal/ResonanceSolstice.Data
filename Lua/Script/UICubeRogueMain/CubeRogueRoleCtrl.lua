local Ctrl = {
  modelPath = nil,
  model = nil,
  animator = nil,
  IsMoving = nil
}
Ctrl.__index = Ctrl
local jumpAnimName = "Migong_QIZI_jump"
local jumpStartMoveTime = 0.333333
local jumpMoveDuration = 0.416467
local jumpEndTime = 0.2502
local endWaitTime = 0.3

function Ctrl.new(modelPath)
  modelPath = modelPath or "CubeRoguePath/Role/Role"
  local self = setmetatable({}, Ctrl)
  self.modelPath = modelPath
  return self
end

function Ctrl:Generate(cube, rotClick)
  local genFunc = xlua.get_generic_method(CS.ResManager, "GetRes")
  local realFunc = genFunc(typeof(CS.UnityEngine.GameObject))
  local obj = realFunc(ResManager, self.modelPath, "#CubeRogue")
  self.model = CS.UnityEngine.GameObject.Instantiate(obj)
  self:SetPosition(cube)
  self.animator = self.model:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
  local btns = self.model.transform:Find("RotBtn")
  if btns == nil then
    return
  end
  local btnCount = btns.childCount - 1
  for i = 0, btnCount do
    local rotBtnSprite = btns:GetChild(i):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    if rotBtnSprite then
      local PublicTool = require("UICubeRogueMain/CubeRoguePublicMethod")
      rotBtnSprite.sprite = PublicTool.LoadSprite(88300211, "CubeRogue")
    end
  end
  self.rotBtns = btns.gameObject
  self:ActiveRotBtns(false)
  
  local function initRotClick(parent, transName, click)
    local listener = parent:Find(transName):GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
    local entryDown = CS.UnityEngine.EventSystems.EventTrigger.Entry()
    entryDown.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerClick
    entryDown.callback:AddListener(click)
    listener.triggers:Add(entryDown)
  end
  
  initRotClick(self.rotBtns.transform, "forward", function(eventData)
    rotClick(1, -1)
  end)
  initRotClick(self.rotBtns.transform, "back", function(eventData)
    rotClick(1, 1)
  end)
  initRotClick(self.rotBtns.transform, "left", function(eventData)
    rotClick(-1, -1)
  end)
  initRotClick(self.rotBtns.transform, "right", function(eventData)
    rotClick(-1, 1)
  end)
end

function Ctrl:ActiveRotBtns(value)
  if self.rotBtns and not self.rotBtns:IsNull() and self.rotBtns.activeSelf ~= value then
    self.rotBtns:SetActive(value)
  end
end

function Ctrl:SetPosition(cube, posOff, rot, sca)
  if cube == nil or cube.rolePos == nil then
    return
  end
  self.model.transform:SetParent(cube.rolePos.transform)
  self.face = cube.face
  self.x = cube.row
  self.y = cube.col
  self:SetOffset(posOff, rot, sca)
  local tempRot = 0
  if cube.face == 1 then
    tempRot = 0
  elseif cube.face == 6 then
    tempRot = 90
  else
    tempRot = 180
  end
  self.model.transform.localRotation = CS.UnityEngine.Quaternion.Euler(0, 0, tempRot)
end

function Ctrl:SetOffset(posOff, rot, sca)
  self.model.transform.localPosition = posOff or self.posOff or Vector3.zero
  self.posOff = self.model.transform.localPosition
  self.model.transform.localScale = sca or self.scaOff or Vector3.one
  self.scaOff = self.model.transform.localScale
end

function Ctrl:MoveTo(cube, cb)
  self.IsMoving = true
  self.animator:Play(jumpAnimName)
  TimerHelper.StartOnce("stopPlayerMoving", jumpStartMoveTime + jumpMoveDuration + jumpEndTime + endWaitTime + 0.1, function()
    if self.IsMoving then
      self:SetPosition(cube)
      self.IsMoving = false
      cb()
      logError("\232\175\183\230\179\168\230\132\143\230\173\164\229\164\132\230\156\137bug\232\167\166\229\143\145\228\186\134\232\161\165\230\149\145\230\142\170\230\150\189 MoveTo(): \230\156\170\231\159\165\229\142\159\229\155\160\229\175\188\232\135\180\228\186\186\231\137\169\231\167\187\229\138\168\231\154\132dotween\230\156\170\229\174\140\230\136\144!")
    end
  end)
  DOTweenTools.Delay(jumpStartMoveTime, function()
    local tween = self.model.transform:DOMove(cube.rolePos.transform.position + cube.rolePos.transform.forward, jumpMoveDuration):SetEase(CS.DG.Tweening.Ease.Linear)
    DOTweenTools.DoComplete(tween, function()
      DOTweenTools.Delay(jumpEndTime + endWaitTime, function()
        cb()
        self:SetPosition(cube)
        self.IsMoving = false
      end)
    end)
  end)
end

local flashJumpUpTime = 0.5
local flashJumpDownTime = 0.5
local jumpDownAnimName = "Migong_QIZI_jump03"

function Ctrl:MoveToFlash(cube, onJumpUp, jumpUpWaitTime, onWaitEnd, onJumpDown)
  self.IsMoving = true
  self.animator:Play(jumpAnimName)
  local hasDone = false
  TimerHelper.StartOnce("stopPlayerFlash1", flashJumpUpTime + jumpUpWaitTime + 0.1, function()
    if not hasDone then
      self:SetPosition(cube)
      self.animator:Play(jumpDownAnimName)
      if onJumpDown then
        onJumpDown()
      end
      logError("\232\175\183\230\179\168\230\132\143\230\173\164\229\164\132\230\156\137bug\232\167\166\229\143\145\228\186\134\232\161\165\230\149\145\230\142\170\230\150\189 MoveToFlash() \233\152\182\230\174\1811: \230\156\170\231\159\165\229\142\159\229\155\160\229\175\188\232\135\180\228\186\186\231\137\169\231\167\187\229\138\168\231\154\132dotween\230\156\170\229\174\140\230\136\144!")
    end
  end)
  TimerHelper.StartOnce("stopPlayerFlash2", flashJumpUpTime + jumpUpWaitTime + flashJumpDownTime + 0.2, function()
    if self.IsMoving then
      self.IsMoving = false
      if onJumpDown then
        onJumpDown()
      end
      logError("\232\175\183\230\179\168\230\132\143\230\173\164\229\164\132\230\156\137bug\232\167\166\229\143\145\228\186\134\232\161\165\230\149\145\230\142\170\230\150\189 MoveToFlash() \233\152\182\230\174\1812: \230\156\170\231\159\165\229\142\159\229\155\160\229\175\188\232\135\180\228\186\186\231\137\169\231\167\187\229\138\168\231\154\132dotween\230\156\170\229\174\140\230\136\144!")
    end
  end)
  DOTweenTools.Delay(flashJumpUpTime, function()
    if onJumpUp then
      onJumpUp()
    end
    DOTweenTools.Delay(jumpUpWaitTime, function()
      hasDone = true
      self:SetPosition(cube)
      self.animator:Play(jumpDownAnimName)
      if onWaitEnd then
        onWaitEnd()
      end
      DOTweenTools.Delay(flashJumpDownTime, function()
        self.IsMoving = false
        if onJumpDown then
          onJumpDown()
        end
      end)
    end)
  end)
end

function Ctrl:MoveToLiner(cube, cb)
  self.IsMoving = true
  TimerHelper.StartOnce("stopBossMove", jumpMoveDuration + 0.1, function()
    if self.IsMoving then
      self.IsMoving = false
      self:SetPosition(cube)
      cb()
      logError("\232\175\183\230\179\168\230\132\143\230\173\164\229\164\132\230\156\137bug\232\167\166\229\143\145\228\186\134\232\161\165\230\149\145\230\142\170\230\150\189 MoveToLiner(): \230\156\170\231\159\165\229\142\159\229\155\160\229\175\188\232\135\180Boss\231\167\187\229\138\168\231\154\132dotween\230\156\170\229\174\140\230\136\144!")
    end
  end)
  local tween = self.model.transform:DOMove(cube.rolePos.transform.position + cube.rolePos.transform.forward, jumpMoveDuration):SetEase(CS.DG.Tweening.Ease.Linear)
  DOTweenTools.DoComplete(tween, function()
    cb()
    self:SetPosition(cube)
    self.IsMoving = false
  end)
end

function Ctrl.OnUpdate()
end

function Ctrl:Clear()
  DOTweenTools.KillAll()
  CS.UnityEngine.GameObject.Destroy(self.model)
  self.model = nil
  self.animator = nil
  self.IsMoving = nil
  self.modelPath = nil
end

return Ctrl
