local Tool = {}
local FuncDic = {}

function Tool.GetTFunc(classType, methodName, TType)
  if FuncDic[methodName] and FuncDic[methodName][tostring(TType)] then
    return FuncDic[methodName][tostring(TType)]
  end
  local genFunc = xlua.get_generic_method(classType, methodName)
  local realFunc = genFunc(TType)
  FuncDic[methodName] = FuncDic[methodName] or {}
  FuncDic[methodName][tostring(TType)] = realFunc
  return realFunc
end

function Tool.GetTKFunc(classType, methodName, TType, KType)
  if FuncDic[methodName] and FuncDic[methodName][tostring(TType)] then
    return FuncDic[methodName][tostring(TType)]
  end
  local genFunc = xlua.get_generic_method(classType, methodName)
  local realFunc = genFunc(TType, KType)
  FuncDic[methodName] = FuncDic[methodName] or {}
  FuncDic[methodName][tostring(TType)] = realFunc
  return realFunc
end

function Tool.PassPointerDownEvent(go, eventData)
  if go == nil then
    return
  end
  local func = Tool.GetTFunc(CS.UnityEngine.EventSystems.ExecuteEvents, "Execute", typeof(CS.UnityEngine.EventSystems.IPointerDownHandler))
  if func then
    func(go, eventData, CS.UnityEngine.EventSystems.ExecuteEvents.pointerDownHandler)
  end
end

function Tool.PassPointerUpEvent(go, eventData)
  if go == nil then
    return
  end
  local func = Tool.GetTFunc(CS.UnityEngine.EventSystems.ExecuteEvents, "Execute", typeof(CS.UnityEngine.EventSystems.IPointerUpHandler))
  if func then
    func(go, eventData, CS.UnityEngine.EventSystems.ExecuteEvents.pointerUpHandler)
  end
end

function Tool.PassDragEvent(go, eventData)
  if go == nil then
    return
  end
  local func = Tool.GetTFunc(CS.UnityEngine.EventSystems.ExecuteEvents, "Execute", typeof(CS.UnityEngine.EventSystems.IDragHandler))
  if func then
    func(go, eventData, CS.UnityEngine.EventSystems.ExecuteEvents.dragHandler)
  end
end

function Tool.PassBeginDragEvent(go, eventData)
  if go == nil then
    return
  end
  local func = Tool.GetTFunc(CS.UnityEngine.EventSystems.ExecuteEvents, "Execute", typeof(CS.UnityEngine.EventSystems.IBeginDragHandler))
  if func then
    func(go, eventData, CS.UnityEngine.EventSystems.ExecuteEvents.beginDragHandler)
  end
end

function Tool.PassEndDragEvent(go, eventData)
  if go == nil then
    return
  end
  local func = Tool.GetTFunc(CS.UnityEngine.EventSystems.ExecuteEvents, "Execute", typeof(CS.UnityEngine.EventSystems.IEndDragHandler))
  if func then
    func(go, eventData, CS.UnityEngine.EventSystems.ExecuteEvents.endDragHandler)
  end
end

function Tool.LoadModel(resPath, gcKey)
  local loadModel = Tool.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.GameObject))
  local tempModel = loadModel(ResManager, resPath, gcKey)
  return CS.UnityEngine.GameObject.Instantiate(tempModel)
end

function Tool.LoadSprite(id, gcKey)
  local loadModel = Tool.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.Sprite))
  return loadModel(ResManager, GetResPath(id), gcKey)
end

function Tool.Clear()
  FuncDic = {}
end

return Tool
