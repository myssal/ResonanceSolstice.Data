local C = require("UIMiniGameBS/MiniGameBSSettings")
local E = {
  choiceHold = 0.5,
  choiceBlinkDuration = 0.4,
  choiceBlinkInterval = 0.08
}

local function copy(v)
  if type(v) ~= "table" then
    return v
  end
  local t = {}
  for k, a in pairs(v) do
    t[k] = copy(a)
  end
  return t
end

function E.SetMode(s, mode, dialogue)
  s.mode, s.elapsed, s.dialogue, s.page = mode, 0, dialogue, 1
  s.moving = false
  s.pendingChoice = nil
  if mode == "choice" then
    s.selected = 0
  end
  s.revision = (s.revision or 0) + 1
end

function E.New(snapshot)
  if snapshot and snapshot.version == 1 then
    return copy(snapshot)
  end
  return {
    version = 1,
    mode = "explore",
    elapsed = 0,
    clock = 0,
    revision = 1,
    x = 0,
    y = 445,
    facing = "up",
    walkTime = 0,
    moving = false,
    maryX = 0,
    maryY = 55,
    maryAlpha = 1,
    hurt = false,
    hitAt = 0,
    gateOpen = false,
    gateProgress = 0,
    blood = false,
    flash = 0,
    selected = 0,
    page = 1,
    punches = 0,
    impact = false
  }
end

function E.Snapshot(s)
  return copy(s)
end

function E.Reset(s)
  local punches, revision = s.punches, s.revision
  local fresh = E.New()
  for k in pairs(s) do
    s[k] = nil
  end
  for k, v in pairs(fresh) do
    s[k] = v
  end
  s.punches, s.revision = punches, revision + 1
end

local function near(s, point, radius)
  return (s.x - point[1]) ^ 2 + (s.y + C.footOffset - point[2]) ^ 2 <= radius ^ 2
end

function E.NearGate(s)
  return not s.gateOpen and near(s, C.gatePoint, C.gateRadius)
end

function E.NearNPC(s)
  return s.maryAlpha > 0 and near(s, C.npcPoint, C.npcRadius)
end

function E.CanStand(s, x, y)
  local fy, r, b = y + C.footOffset, C.radius, C.bounds
  if x < b[1] or x > b[2] or fy < b[3] or fy > b[4] then
    return false
  end
  
  local function overlaps(a)
    return x + r > a[1] and x - r < a[3] and fy + r > a[2] and fy - r < a[4]
  end
  
  for _, a in ipairs(C.obstacles) do
    if overlaps(a) then
      return false
    end
  end
  return s.gateOpen or not overlaps(C.gateRect)
end

function E.Interact(s)
  if s.mode ~= "explore" then
    return
  end
  s.facing = "up"
  if E.NearGate(s) then
    E.SetMode(s, "gateDialogue", "gate")
  elseif E.NearNPC(s) then
    E.SetMode(s, "choice", "opening")
  end
end

local function executeChoice(s, action)
  if action == "punch" then
    s.fromX, s.fromY, s.impact = s.x, s.y, false
    s.facing = "up"
    E.SetMode(s, "punch")
  elseif action == "kill" then
    E.SetMode(s, "kill", "kill")
  elseif action == "special" then
    E.SetMode(s, "blocked", "blocked")
  elseif action == "leave" then
    E.SetMode(s, "explore")
  end
end

function E.Choose(s, action)
  if s.mode ~= "choice" then
    return
  end
  local index = ({
    punch = 1,
    kill = 2,
    special = 3,
    leave = 4
  })[action]
  if not index then
    return
  end
  s.selected = index
  if action == "leave" then
    executeChoice(s, action)
    return
  end
  s.mode, s.elapsed, s.pendingChoice = "choiceConfirm", 0, action
  s.moving = false
end

function E.Advance(s)
  if s.mode == "choice" or s.mode == "choiceConfirm" or not s.dialogue then
    return
  end
  if s.page < #C.dialogue[s.dialogue].ids then
    s.page = s.page + 1
    s.revision = s.revision + 1
    return
  end
  if s.mode == "gateDialogue" then
    s.fromX, s.fromY = s.x, s.y
    E.SetMode(s, "gateOpening")
  elseif s.mode == "kill" then
    s.hurt, s.hitAt = true, s.clock
    E.SetMode(s, "killEffect")
  elseif s.mode == "reaction" then
    E.SetMode(s, "vanish")
  elseif s.mode == "blocked" then
    E.SetMode(s, "choice", "opening")
  elseif s.mode == "complete" then
    E.Reset(s)
  end
end

function E.Cancel(s)
  if s.mode == "choice" or s.mode == "choiceConfirm" or s.mode == "blocked" or s.mode == "gateDialogue" or s.mode == "kill" then
    E.SetMode(s, "explore")
    return true
  end
  return false
end

function E.Step(s, dt, input)
  dt = math.max(0, math.min(dt or 0, 0.05))
  input = input or {}
  local events = {}
  local oldWalk = s.walkTime
  local oldX, oldY = s.x, s.y
  local previousElapsed = s.elapsed
  s.elapsed, s.clock = s.elapsed + dt, s.clock + dt
  local t = s.elapsed
  s.flash = 0
  s.moving = false
  if s.mode == "choiceConfirm" then
    if t >= E.choiceHold + E.choiceBlinkDuration then
      executeChoice(s, s.pendingChoice)
    end
  elseif s.mode == "explore" then
    local dx = (input.right and 1 or 0) - (input.left and 1 or 0)
    local dy = (input.down and 1 or 0) - (input.up and 1 or 0)
    if dx ~= 0 or dy ~= 0 then
      s.facing = dx ~= 0 and (0 < dx and "right" or "left") or 0 < dy and "down" or "up"
      local length = math.sqrt(dx * dx + dy * dy)
      dx, dy = dx / length * C.speed * dt, dy / length * C.speed * dt
      if E.CanStand(s, s.x + dx, s.y) then
        s.x = s.x + dx
      end
      if E.CanStand(s, s.x, s.y + dy) then
        s.y = s.y + dy
      end
      s.moving = math.abs(s.x - oldX) + math.abs(s.y - oldY) > 0.001
    end
    s.walkTime = s.moving and s.walkTime + dt or 0
  elseif s.mode == "gateOpening" then
    if previousElapsed < 0.3 and 0.3 <= t then
      events[#events + 1] = "gate-latch"
    end
    local p = math.min(1, t / 0.3)
    local ease = 1 - (1 - p) ^ 3
    s.x = s.fromX + (1 - s.fromX) * ease
    s.y = s.fromY + (445 - s.fromY) * ease
    s.moving = p < 1
    s.walkTime = s.walkTime + dt
    s.gateProgress = math.max(0, math.min(1, (t - 0.3) / 0.24))
    if 0.72 <= t then
      s.gateOpen = true
      s.gateProgress = 1
      E.SetMode(s, "explore")
    end
  elseif s.mode == "punch" then
    if t < 0.36 then
      local p = 1 - (1 - t / 0.36) ^ 3
      s.x = s.fromX * (1 - p)
      s.y = s.fromY + (125 - s.fromY) * p
      s.moving = true
      s.walkTime = s.walkTime + dt
    elseif t < 0.54 then
      s.x = 0
      s.y = 125 + math.floor((t - 0.36) / 0.18 * 2.5 + 0.5)
    elseif t < 0.63 then
      s.y = 121.25
    else
      s.y = 121.25 + math.floor(math.min(1, (t - 0.63) / 0.21) * 3.75 + 0.5)
    end
    if 0.54 <= t and not s.impact then
      s.impact, s.hurt, s.hitAt = true, true, s.clock
      s.punches = s.punches + 1
      events[#events + 1] = "punch"
    end
    if 0.54 <= t and t < 0.78 then
      s.flash = (1 - (t - 0.54) / 0.24) * 0.62
    end
    if 0.86 <= t then
      s.x, s.y, s.maryX, s.maryY, s.flash = 0, 125, 0, 55, 0
      E.SetMode(s, "reaction", "reaction")
    end
  elseif s.mode == "killEffect" then
    s.flash = t < 0.16 and (1 - t / 0.16) * 0.52 or 0
    if 0.16 <= t then
      s.maryAlpha, s.blood = 0, true
    end
    if 1.2 <= t then
      E.SetMode(s, "complete", "ending")
    end
  elseif s.mode == "vanish" then
    s.maryAlpha = math.max(0, 1 - t / 0.65)
    s.maryY = 55 - math.floor(t / 0.17) * 1.25
    s.y = 125 + math.floor(math.min(1, t / 0.35) * 7.5 + 0.5)
    if 0.65 <= t then
      s.maryAlpha = 0
      E.SetMode(s, "victory")
      events[#events + 1] = "victory"
    end
  elseif s.mode == "victory" and 2.2 <= t then
    E.SetMode(s, "complete", "ending")
  end
  if s.moving and math.abs(s.x - oldX) + math.abs(s.y - oldY) > 0.01 then
    local n = math.floor((s.walkTime + 0.16) / 0.32)
    if n > math.floor((oldWalk + 0.16) / 0.32) then
      events[#events + 1] = n % 2 == 1 and "step-a" or "step-b"
    end
  end
  return events
end

return E
