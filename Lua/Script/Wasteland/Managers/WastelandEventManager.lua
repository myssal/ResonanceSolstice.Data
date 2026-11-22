local EventManager = {}
local Listeners = {}

function EventManager:Init()
  Listeners = {}
end

function EventManager:AddListener(eventType, func, caller)
  if not Listeners[eventType] then
    Listeners[eventType] = {}
  end
  caller.eventListenEnable = true
  table.insert(Listeners[eventType], {func = func, caller = caller})
end

function EventManager:RemoveListener(caller)
  for eventType, events in pairs(Listeners) do
    for i = #events, 1, -1 do
      if events[i].caller == caller then
        table.remove(events, i)
      end
    end
  end
end

function EventManager:Trigger(eventType, ...)
  local list = Listeners[eventType]
  if not list then
    return
  end
  for _, item in ipairs(list) do
    if item.caller and item.caller.eventListenEnable then
      item.func(item.caller, ...)
    end
  end
end

function EventManager:SetCallerEnable(caller, active)
  for eventType, events in pairs(Listeners) do
    for i = #events, 1, -1 do
      if events[i].caller == caller then
        events[i].caller.eventListenEnable = active
        break
      end
    end
  end
end

function EventManager:Destroy()
  Listeners = {}
end

return EventManager
