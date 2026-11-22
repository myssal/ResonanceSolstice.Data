local Ctrl = {
  CanRotate = false,
  CanScale = false,
  CanDrag = true,
  RotateLimit = 0.1,
  ScaleLimit = 1,
  MoveParam = 0.01
}
local Input = CS.UnityEngine.Input
local TouchPhase = CS.UnityEngine.TouchPhase
local isScale = false
local isRotate = false
local CurDir, StartDir

function Ctrl.OnUpdate()
  if Input.touchCount == 0 then
    isScale = false
    isRotate = false
    return
  end
  if Input.touchCount == 1 then
    if Ctrl.CanDrag then
      local Touch1 = Input.GetTouch(0)
      if Touch1.phase == TouchPhase.Moved then
        Ctrl.OnOneFingerDrag(Touch1.deltaPosition)
      end
    end
  elseif Input.touchCount >= 2 then
    local t1 = Input.GetTouch(0)
    local t2 = Input.GetTouch(1)
    if t1.phase == TouchPhase.Began or t2.phase == TouchPhase.Began then
      StartDir = t2.position - t1.position
      return
    end
    if t1.phase == TouchPhase.Moved or t2.phase == TouchPhase.Moved then
      CurDir = t2.position - t1.position
      local angleChange = Vector2.Angle(StartDir, CurDir)
      local disChange = StartDir.magnitude - CurDir.magnitude
      if Ctrl.CanRotate and math.abs(angleChange) >= Ctrl.RotateLimit and not isScale then
        isRotate = true
        StartDir = CurDir
        Ctrl.OnTwoFingersRotation(angleChange)
      else
        isRotate = false
      end
      if Ctrl.CanScale and math.abs(disChange) >= Ctrl.ScaleLimit and not isRotate then
        isScale = true
        StartDir = CurDir
        Ctrl.OnTwoFingersScale(disChange)
      else
        isScale = false
      end
    end
  end
end

function Ctrl.OnTwoFingersRotation(change)
  if Ctrl.MonoManager then
    Ctrl.MonoManager.CameraCtrl:AddCustomViewDegree(change)
  end
end

function Ctrl.OnTwoFingersScale(change)
  if Ctrl.MonoManager then
    Ctrl.MonoManager.CameraCtrl:AddCustomViewDistance(change * 0.01)
  end
end

function Ctrl.OnOneFingerDrag(change)
  if Ctrl.MonoManager then
    local temp = Vector3(change.x, change.y, 0)
    local curMouseChange = Quaternion.AngleAxis(-Ctrl.MonoManager.CameraCtrl:GetViewDegree(), Vector3.forward) * temp
    local pos = Ctrl.MonoManager.CameraCtrl.ViewPos or Ctrl.MonoManager.RoleCtrl.GO.transform.position
    pos = pos + Vector3(-curMouseChange.x, 0, -curMouseChange.y) * Ctrl.MoveParam
    Ctrl.MonoManager.CameraCtrl:SetViewPos(pos)
  end
end

return Ctrl
