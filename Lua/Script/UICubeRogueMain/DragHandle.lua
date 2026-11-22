local DragRotate = {}
DragRotate.__index = DragRotate

function DragRotate.new(gameObject, spinX, spinY, cfg)
  local self = setmetatable({}, DragRotate)
  self.gameObject = gameObject
  self.transform = gameObject.transform
  self.isDragging = false
  self.lastMousePosition = nil
  self.rotSpeedX = spinX
  self.rotSpeedY = spinY
  self.sound = nil
  self.cfg = cfg
  return self
end

function DragRotate:OnMouseDown()
  self.isDragging = true
  self.lastMousePosition = Input.mousePosition
  if self.cfg and self.cfg.slideSoundList and #self.cfg.slideSoundList > 0 then
    local soundInfo
    soundInfo = self.cfg.slideSoundList[math.random(1, #self.cfg.slideSoundList)].id
    self.sound = SoundManager:CreateSound(soundInfo)
  end
end

function DragRotate:OnMouseDrag()
  if not self.isDragging then
    return
  end
  local currentMousePosition = Input.mousePosition
  local delta = currentMousePosition - self.lastMousePosition
  local rotationX = delta.y * self.rotSpeedX * Time.deltaTime
  local rotationY = delta.x * self.rotSpeedY * Time.deltaTime
  local rot = Vector3.up * rotationY + (self.rightDir or Vector3.right) * -rotationX
  self.transform:Rotate(rot, CS.UnityEngine.Space.World)
  self.lastMousePosition = currentMousePosition
  if self.sound and self.sound.audioSource and not self.sound.audioSource.isPlaying then
    self.sound:Play()
  end
end

function DragRotate:OnMouseUp()
  self.isDragging = false
  if self.sound then
    self.sound:Stop()
  end
  self.sound = nil
end

function DragRotate:BindEvents()
  local listener = self.gameObject:AddComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  local entryDown = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDown.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerDown
  entryDown.callback:AddListener(function()
    self:OnMouseDown()
  end)
  listener.triggers:Add(entryDown)
  local entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
  entryDrag.callback:AddListener(function()
    self:OnMouseDrag()
  end)
  listener.triggers:Add(entryDrag)
  local entryUp = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryUp.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerUp
  entryUp.callback:AddListener(function()
    self:OnMouseUp()
  end)
  listener.triggers:Add(entryUp)
end

return DragRotate
