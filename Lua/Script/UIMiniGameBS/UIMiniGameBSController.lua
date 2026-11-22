local View = require("UIMiniGameBS/UIMiniGameBSView")
local D = require("UIMiniGameBS/UIMiniGameBSDataModel")
local C = require("UIMiniGameBS/MiniGameBSSettings")
local E = require("UIMiniGameBS/MiniGameBSEngine")
local Network = require("UIMiniGameBS/MiniGameBSNetwork")
local Generic = require("UICubeRogueMain/CubeRoguePublicMethod")
local Controller = {}

local function node(v)
  return type(v) == "table" and v.self or v
end

local function active(v, on)
  node(v):SetActive(on)
end

local function text(v, t)
  node(v):SetText(t)
end

local function label(key)
  return GetText(C.text[key])
end

local function pos(v, x, y)
  node(v):SetAnchoredPosition(Vector2(x, y))
end

local function rgba(v, r, g, b, a)
  node(v):SetColor(Color(r, g, b, a))
end

local choices = {
  "Punch",
  "Kill",
  "Special",
  "Leave"
}
local actions = {
  "punch",
  "kill",
  "special",
  "leave"
}
local keyMap = {
  up = {"up", "w"},
  down = {"down", "s"},
  left = {"left", "a"},
  right = {"right", "d"}
}
local directionButtons = {
  up = "Btn_Up",
  down = "Btn_Down",
  left = "Btn_Left",
  right = "Btn_Right"
}
local directionTouches = {}

function Controller.ClearInput()
  D.held = {}
  directionTouches = {}
end

local function touchDirections(input)
  local held, nextTouches = {}, {}
  local group = View.Group_Controls.Group_Direction
  if D.state.mode ~= "explore" or not node(group).gameObject.activeInHierarchy then
    directionTouches = {}
    return held
  end
  local canvas = View.self:GetComponent(typeof(CS.UnityEngine.Canvas))
  local camera = canvas and canvas.renderMode ~= CS.UnityEngine.RenderMode.ScreenSpaceOverlay and canvas.worldCamera or nil
  local phase = CS.UnityEngine.TouchPhase
  for i = 0, input.touchCount - 1 do
    local touch = input.GetTouch(i)
    if touch.phase ~= phase.Ended and touch.phase ~= phase.Canceled then
      local direction
      for name, buttonName in pairs(directionButtons) do
        local button = node(group[buttonName])
        if button.gameObject.activeInHierarchy and button.Btn.interactable and CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(button.Rect, touch.position, camera) then
          direction = name
          break
        end
      end
      if directionTouches[touch.fingerId] or touch.phase == phase.Began and direction then
        nextTouches[touch.fingerId] = true
        if direction then
          held[direction] = true
        end
      end
    end
  end
  directionTouches = nextTouches
  return held
end

function Controller.StopVoice()
  Controller.voiceGeneration = (Controller.voiceGeneration or 0) + 1
  local sound = Controller.voice
  Controller.voice = nil
  if not sound then
    return
  end
  sound:SetEndCallBack()
  if not sound.IsStop then
    sound.delayDuration = 0
    sound:Stop()
  end
end

local function routeAudio(sound, groupName)
  if not sound.audioSource then
    return
  end
  Controller.audioGroups = Controller.audioGroups or {}
  local group = Controller.audioGroups[groupName]
  if not group then
    local mixer = SoundManager:GetAudioMixer("AudioMixer/MixOut")
    if not mixer then
      return
    end
    local groups = mixer:FindMatchingGroups(groupName)
    if groups.Length == 0 then
      return
    end
    group = groups[0]
    Controller.audioGroups[groupName] = group
  end
  sound.audioSource.outputAudioMixerGroup = group
end

function Controller.StartMusic()
  if Controller.music then
    Controller.music:Pause(false)
    return
  end
  if not SoundManager then
    return
  end
  local cfg = PlayerData:GetFactoryData(30008206, "SoundFactory")
  if not (cfg and cfg.resUrl) or cfg.resUrl == "" then
    return
  end
  local music = SoundManager:CreateSound(CS.SoundFactory.originPackSoundId, cfg.resUrl)
  if not music then
    return
  end
  routeAudio(music, "BGM_Menu")
  music:SetIsLoop(true)
  music:SetVolume(0.11)
  local previous = SoundManager:GetBgmSource()
  Controller.previousMusic = previous
  Controller.previousMusicClip = previous and previous.clip or nil
  Controller.resumePreviousMusic = previous and previous.isPlaying or false
  if Controller.resumePreviousMusic then
    SoundManager:PauseBGM(true)
  end
  Controller.music = music
  music:Play()
end

function Controller.StopMusic()
  local music = Controller.music
  Controller.music = nil
  if music and not music.IsStop then
    music:SetIsLoop(false)
    music:SetEndCallBack()
    music.delayDuration = 0
    music:Stop()
  end
  if SoundManager and Controller.resumePreviousMusic then
    local current = SoundManager:GetBgmSource()
    if current == Controller.previousMusic and current and current.clip == Controller.previousMusicClip then
      SoundManager:PauseBGM(false)
    end
  end
  Controller.previousMusic = nil
  Controller.previousMusicClip = nil
  Controller.resumePreviousMusic = nil
end

function Controller.PlayVoice(soundIds)
  Controller.StopVoice()
  if not SoundManager then
    return
  end
  local ids = type(soundIds) == "table" and soundIds or {soundIds}
  local generation, index = Controller.voiceGeneration, 0
  local playNext
  
  function playNext()
    if generation ~= Controller.voiceGeneration then
      return
    end
    index = index + 1
    local id = tonumber(ids[index]) or 0
    if id <= 0 then
      return
    end
    local sound = SoundManager:CreateSound(id)
    if not sound then
      playNext()
      return
    end
    routeAudio(sound, "Voice_Other")
    Controller.voice = sound
    sound:SetIsLoop(false)
    sound:SetEndCallBack(function()
      if generation ~= Controller.voiceGeneration or Controller.voice ~= sound then
        return
      end
      Controller.voice = nil
      playNext()
    end)
    sound:Play()
  end
  
  playNext()
end

function Controller.StopAudio()
  Controller.StopVoice()
  local sounds = Controller.sounds or {}
  Controller.sounds = {}
  for sound in pairs(sounds) do
    sound:SetEndCallBack()
    if not sound.IsStop then
      sound:Stop()
    end
  end
end

function Controller.PlaySound(name)
  if not SoundManager then
    return
  end
  local sound = SoundManager:CreateSound(CS.SoundFactory.originPackSoundId, C.path .. "Audio/" .. name)
  if not sound then
    return
  end
  routeAudio(sound, "Ui_Common")
  sound:SetIsLoop(false)
  local owner = Controller.sounds
  owner[sound] = true
  sound:SetEndCallBack(function()
    owner[sound] = nil
  end)
  sound:Play()
end

local function releaseFrames()
  if Controller.gcKey then
    for path in pairs(Controller.frames or {}) do
      ResManager:UnloadRes(path, false, Controller.gcKey)
    end
  end
  Controller.frames, Controller.gcKey = nil, nil
end

local function preloadFrames()
  if Controller.frames then
    return
  end
  Controller.gcKey = "#MiniGameBS:" .. tostring(View.self:GetInstanceID())
  Controller.frames = {}
  local getSprite = Generic.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.Sprite))
  for _, art in ipairs({
    "grimmFront",
    "grimmBack",
    "grimmSide",
    "maryIdle",
    "maryHit"
  }) do
    for i = 0, 7 do
      local path = C.path .. "Images/Characters/Frames/" .. art .. "_" .. string.format("%02d", i)
      Controller.frames[path] = getSprite(ResManager, path, Controller.gcKey)
    end
  end
end

local function frame(img, art, index)
  local path = C.path .. "Images/Characters/Frames/" .. art .. "_" .. string.format("%02d", index)
  local sprite = Controller.frames[path]
  if sprite and img.Img.sprite ~= sprite then
    img.Img.sprite = sprite
  end
end

local function charEnds(value)
  local ends = {}
  for p, ch in string.gmatch(value, "()([%z\001-\127\194-\244][\128-\191]*)") do
    ends[#ends + 1] = p + #ch - 1
  end
  return ends
end

local function paginate(value, voices)
  local component = node(View.Group_Dialogue.Txt_Content).transform:GetComponent(typeof(CS.UnityEngine.UI.Text))
  local width = math.max(1, component.rectTransform.rect.width - 4)
  local settings = component:GetGenerationSettings(Vector2(0, 0))
  settings.horizontalOverflow = CS.UnityEngine.HorizontalWrapMode.Overflow
  local generator = component.cachedTextGeneratorForLayout
  local pages, lines, clips = {}, {}, {}
  
  local function flush()
    if 0 < #lines then
      pages[#pages + 1] = {
        line = table.concat(lines, "\n"),
        voices = clips
      }
      lines = {}
      clips = {}
    end
  end
  
  local ids = type(voices) == "table" and voices or {voices}
  local sentenceIndex = 0
  for sentence in (value .. "\n"):gmatch("(.-)\n") do
    sentenceIndex = sentenceIndex + 1
    local wrapped, line = {}, ""
    for char in sentence:gmatch("[%z\001-\127\194-\244][\128-\191]*") do
      if line ~= "" and width < generator:GetPreferredWidth(line .. char, settings) / component.pixelsPerUnit then
        wrapped[#wrapped + 1] = line
        line = char
      else
        line = line .. char
      end
    end
    wrapped[#wrapped + 1] = line
    if 0 < #lines and 3 < #lines + #wrapped then
      flush()
    end
    for i, part in ipairs(wrapped) do
      if #lines == 3 then
        flush()
      end
      lines[#lines + 1] = part
      if i == 1 and 0 < (tonumber(ids[sentenceIndex]) or 0) then
        clips[#clips + 1] = ids[sentenceIndex]
      end
    end
  end
  flush()
  return pages
end

local function showPage()
  local page = Controller.dialoguePages[Controller.dialoguePage]
  Controller.line = page.line
  Controller.ends = charEnds(page.line)
  D.state.typeTime = 0
  if D.state.dialogue ~= "reaction" then
    Controller.PlayVoice(page.voices)
  end
end

local function loadLine()
  local s = D.state
  if not s.dialogue then
    return
  end
  if Controller.lineRevision ~= s.revision then
    local def = C.dialogue[s.dialogue]
    local dialog = View.Group_Dialogue
    text(dialog.Txt_Speaker, def.speaker and label(def.speaker) or "")
    active(dialog.Img_Portrait, def.speaker == "mary" or def.speaker == "grimm")
    if def.speaker == "mary" then
      dialog.Img_Portrait:SetSprite(C.path .. "Images/Portraits/" .. (s.hurt and "maryHit" or "maryIdle"))
    elseif def.speaker == "grimm" then
      dialog.Img_Portrait:SetSprite(C.path .. "Images/Portraits/grimmFront")
    end
    local value = (GetText(def.ids[s.page]) or ""):gsub("\\+n", "\n")
    Controller.dialoguePages = paginate(value, def.soundIds and def.soundIds[s.page])
    Controller.dialoguePage = 1
    Controller.lineRevision = s.revision
    showPage()
  end
end

local function morePages()
  return D.state.dialogue and Controller.dialoguePage < #Controller.dialoguePages
end

local function isTyping()
  if not D.state.dialogue then
    return false
  end
  loadLine()
  return (D.state.typeTime or 0) < #Controller.ends * C.typingInterval
end

function Controller.Render()
  local s = D.state
  if not s then
    return
  end
  if not s.dialogue and s.mode ~= "punch" then
    Controller.StopVoice()
  end
  local scene, ctrl = View.Group_Scene, View.Group_Controls
  local depth = scene.Group_Depth
  pos(depth.Group_Grimm, s.x, -s.y - C.footOffset)
  pos(depth.Group_Mary, s.maryX, -s.maryY - C.footOffset)
  local art = s.facing == "up" and "grimmBack" or s.facing == "down" and "grimmFront" or "grimmSide"
  frame(depth.Group_Grimm.Img_Actor, art, s.moving and math.floor(s.walkTime / C.walkFrame) % 8 or 0)
  depth.Group_Grimm.Img_Actor:SetLocalScale(s.facing == "right" and -1 or 1, 1, 1)
  frame(depth.Group_Mary.Img_Actor, s.hurt and "maryHit" or "maryIdle", math.floor((s.clock - (s.hurt and s.hitAt or 0)) / C.maryFrame) % 8)
  rgba(depth.Group_Mary.Img_Actor, 1, 1, 1, s.maryAlpha)
  active(depth.Group_Mary, 0 < s.maryAlpha)
  active(depth.Group_Gate, not s.gateOpen)
  local widths = {
    59,
    59,
    43,
    24,
    8,
    0
  }
  depth.Group_Gate.Img_Gate:SetWidthHeight(widths[math.min(6, math.floor(s.gateProgress * 6) + 1)], 91)
  active(scene.Img_Blood, s.blood)
  local rows = {
    {
      depth.Group_Mary,
      s.maryY + C.footOffset
    },
    {
      depth.Group_Grimm,
      s.y + C.footOffset
    },
    {
      depth.Img_Plant1,
      160
    },
    {
      depth.Img_Plant2,
      162
    },
    {
      depth.Img_Plant3,
      253
    },
    {
      depth.Img_Plant4,
      253
    },
    {
      depth.Img_Plant5,
      344
    },
    {
      depth.Img_Plant6,
      348
    },
    {
      depth.Img_FenceLeft,
      453
    },
    {
      depth.Img_FenceRight,
      453
    },
    {
      depth.Group_Gate,
      453
    }
  }
  for i, row in ipairs(rows) do
    row[3] = i
  end
  table.sort(rows, function(a, b)
    if a[2] == b[2] then
      return a[3] < b[3]
    end
    return a[2] < b[2]
  end)
  for i, row in ipairs(rows) do
    node(row[1]).transform:SetSiblingIndex(i - 1)
  end
  local spark = s.mode == "punch" and s.elapsed >= 0.54 and s.elapsed < 0.69
  active(scene.Group_HitEffect, spark)
  if spark then
    rgba(scene.Group_HitEffect.Img_Spark_Placeholder, 0.96, 0.9, 0.69, 1 - (s.elapsed - 0.54) / 0.15)
  end
  local scale = View.self.transform.rect.height / 600
  node(scene).transform.localScale = Vector3.one * scale
  local shake = s.mode == "punch" and s.elapsed > 0.54 and s.elapsed < 0.72 and math.sin(s.elapsed * 190) * 2 or 0
  pos(scene, shake * scale, -34 * scale)
  rgba(View.Img_Flash, 0.8, 0.19, 0.016, s.flash)
  active(ctrl.Group_Direction, s.mode == "explore")
  active(ctrl.Btn_Interact, s.mode == "explore")
  node(ctrl.Btn_Interact).Btn.interactable = E.NearGate(s) or E.NearNPC(s)
  local hint = E.NearGate(s) and "gateInteract" or E.NearNPC(s) and "interact" or not s.gateOpen and "gateApproach" or s.maryAlpha == 0 and "emptyGarden" or "approach"
  text(ctrl.Btn_Interact.Txt_Label, label(hint))
  if s.dialogue then
    loadLine()
  end
  local canChoose = s.mode == "choice" and not morePages()
  active(View.Group_Choices, canChoose or s.mode == "choiceConfirm")
  local blinkOn = s.mode ~= "choiceConfirm" or s.elapsed < E.choiceHold or math.floor((s.elapsed - E.choiceHold) / E.choiceBlinkInterval) % 2 == 1
  for i, name in ipairs(choices) do
    local button = View.Group_Choices["Btn_" .. name]
    active(button, i ~= s.selected or blinkOn)
    active(button.Img_Selected, i == s.selected)
    node(button).Btn.interactable = canChoose
  end
  active(View.Group_Dialogue, s.dialogue ~= nil)
  active(View.Group_Victory, s.mode == "victory")
  if s.dialogue then
    loadLine()
    local count = math.min(#Controller.ends, math.floor((s.typeTime or 0) / C.typingInterval))
    text(View.Group_Dialogue.Txt_Content, Controller.line:sub(1, Controller.ends[count] or 0))
    active(View.Group_Dialogue.Btn_DialogueArea, s.mode ~= "choiceConfirm" and (s.mode ~= "choice" or morePages()))
    active(View.Group_Dialogue.Btn_Advance, s.mode ~= "choiceConfirm" and (s.mode ~= "choice" or morePages()))
    active(View.Group_Dialogue.Btn_Advance.Img_Icon, s.mode ~= "complete")
    if View.Group_Dialogue.Btn_Advance.Txt_Label then
      active(View.Group_Dialogue.Btn_Advance.Txt_Label, s.mode == "complete")
    end
    node(View.Group_Dialogue.Btn_Advance):SetWidthHeight(s.mode == "complete" and 180 or 76, 48)
  end
end

function Controller.Init(initParams)
  local params = type(initParams) == "table" and initParams or initParams and initParams ~= "" and Json.decode(initParams) or {}
  Controller.StopAudio()
  D.Init(params)
  Controller.ClearInput()
  Controller.alive, Controller.enabled = true, true
  Controller.lineRevision = nil
  preloadFrames()
  Controller.Render()
  Controller.StartMusic()
  D.rankId, D.rankConfig = Network.GetRank(D.params.bossId)
end

function Controller.ReportHit()
  if not D.rankId then
    return
  end
  local state = D.state
  Net:SendProto("mini_game.add_hit", function(json)
    if Controller.alive and D.state == state then
      D.myHitCount = math.max(D.myHitCount or 0, tonumber(json.hit_count) or 0)
    end
  end, D.rankId, function()
    if Controller.alive and D.state == state then
      CommonTips.OpenTips(C.text.rankError)
    end
  end)
end

function Controller.SetDirection(direction, down)
  if not Controller.alive then
    return
  end
  D.held[direction] = down and D.state.mode == "explore" and not D.rankOpen or nil
end

function Controller.Interact()
  if not Controller.alive or D.rankOpen then
    return
  end
  local old = D.state.revision
  E.Interact(D.state)
  if old ~= D.state.revision then
    Controller.ClearInput()
    Controller.PlaySound("confirm")
  end
  Controller.Render()
end

function Controller.Choose(action)
  if not Controller.alive or D.rankOpen or D.state.mode ~= "choice" or morePages() then
    return
  end
  if action == "punch" and not D.rankId then
    CommonTips.OpenTips(C.text.rankUnavailable)
    return
  end
  Controller.StopAudio()
  Controller.PlaySound("confirm")
  Controller.ClearInput()
  E.Choose(D.state, action)
  Controller.Render()
end

function Controller.Advance()
  if not (Controller.alive and not D.rankOpen and D.state.dialogue) or D.state.mode == "choiceConfirm" or D.state.mode == "choice" and not morePages() then
    return
  end
  if isTyping() then
    D.state.typeTime = #Controller.ends * C.typingInterval
  elseif morePages() then
    Controller.dialoguePage = Controller.dialoguePage + 1
    showPage()
    Controller.PlaySound("confirm")
  else
    local old = D.state.mode
    E.Advance(D.state)
    if old == "kill" and D.state.mode == "killEffect" then
      Controller.StopAudio()
      Controller.PlaySound("kill")
    else
      Controller.PlaySound("confirm")
    end
  end
  Controller.ClearInput()
  Controller.Render()
end

function Controller.Select(index)
  if D.state.mode ~= "choice" or D.rankOpen then
    return
  end
  D.state.selected = (index - 1) % 4 + 1
  Controller.PlaySound("cursor")
  Controller.Render()
end

function Controller.OpenRank()
  if not Controller.alive or D.rankOpen then
    return
  end
  D.rankOpen = true
  Controller.ClearInput()
  Controller.StopAudio()
  UIManager:Open(C.path .. "MiniGameBSRank", Json.encode(D.params))
end

function Controller.ResumeRank()
  if Controller.alive then
    D.rankOpen = false
    Controller.ClearInput()
    Controller.skipFrame = true
  end
end

function Controller.Return()
  if not Controller.alive or D.rankOpen then
    return
  end
  Controller.ClearInput()
  Controller.StopAudio()
  UIManager:GoBack()
end

function Controller.Update()
  if not (Controller.alive and Controller.enabled) or D.rankOpen then
    return
  end
  if Controller.skipFrame then
    Controller.skipFrame = false
    return
  end
  if not CS.UnityEngine.Application.isFocused then
    Controller.ClearInput()
    Controller.StopAudio()
    return
  end
  local input = CS.UnityEngine.Input
  local pointerHeld
  if input.touchCount > 0 then
    D.held = {}
    pointerHeld = touchDirections(input)
  else
    directionTouches = {}
    pointerHeld = D.held
  end
  local held = {}
  for direction, keys in pairs(keyMap) do
    held[direction] = pointerHeld[direction] or input.GetKey(keys[1]) or input.GetKey(keys[2])
  end
  local s = D.state
  if input.GetKeyDown("escape") then
    if E.Cancel(s) then
      Controller.ClearInput()
      Controller.Render()
    else
      Controller.Return()
    end
    return
  end
  if s.mode == "choice" and not morePages() then
    if input.GetKeyDown("up") then
      Controller.Select(s.selected == 0 and 4 or s.selected - 1)
    elseif input.GetKeyDown("down") then
      Controller.Select(s.selected + 1)
    end
    for i, action in ipairs(actions) do
      if input.GetKeyDown(tostring(i)) then
        Controller.Choose(action)
        return
      end
    end
    if input.GetKeyDown("return") or input.GetKeyDown("space") then
      Controller.Choose(actions[s.selected])
      return
    end
  elseif input.GetKeyDown("return") or input.GetKeyDown("space") or s.mode == "explore" and input.GetKeyDown("e") then
    if s.mode == "explore" then
      Controller.Interact()
    else
      Controller.Advance()
    end
    return
  end
  local dt = math.min(CS.UnityEngine.Time.unscaledDeltaTime, 0.05)
  Controller.Step(dt, held)
end

function Controller.Step(dt, held)
  if not (Controller.alive and Controller.enabled) or D.rankOpen then
    return
  end
  local s = D.state
  local revision = s.revision
  for _, sound in ipairs(E.Step(s, dt, held)) do
    if sound == "punch" then
      Controller.ReportHit()
      Controller.PlayVoice(C.impactSoundIds[math.random(#C.impactSoundIds)])
    end
    Controller.PlaySound(sound)
  end
  if revision ~= s.revision then
    Controller.ClearInput()
  end
  if s.dialogue then
    loadLine()
    s.typeTime = math.min((s.typeTime or 0) + dt, #Controller.ends * C.typingInterval)
  end
  Controller.Render()
end

function Controller.Enable()
  Controller.enabled = true
  if Controller.music then
    Controller.music:Pause(false)
  end
end

function Controller.Disable()
  Controller.enabled = false
  Controller.ClearInput()
  Controller.StopAudio()
  if Controller.music and not D.rankOpen then
    Controller.music:Pause(true)
  end
end

function Controller.Destroy()
  Controller.alive = false
  Controller.Disable()
  Controller.StopMusic()
  releaseFrames()
  Controller.audioGroups = nil
  D.state = nil
  Controller.lineRevision = nil
end

return Controller
