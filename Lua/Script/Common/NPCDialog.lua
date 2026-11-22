local npcId = 0
local npcElement
local defaultHeight = 102
local NPCDiagGroupEnum = {Mutex = "Mutex", Order = "Order"}
local dialogGroup = {
  belongName = "",
  listId = 0,
  curIdx = 0
}
local cacheTalkReturn = {}
local isSpine = false
local curSoundIdx = 0
local soundList, curPlaySound
local isStopSound = false

local function setNpcText(element, txt)
  element.Img_Dialog.self:SetActive(true)
  element.Img_Dialog.Txt_Talk:SetText(txt)
  local height = element.Img_Dialog.Txt_Talk:GetHeight()
  element.Img_Dialog.Txt_Talk:SetHeight(height)
  element.Img_Dialog.self:SetHeight(defaultHeight + height)
  element.Img_Dialog.Txt_Talk:SetTweenContent(txt)
end

local function getDetailText(info, returnTable)
  local text = info.detailTxt
  if text == nil then
    text = GetTextNPCMod(info.id, returnTable)
  end
  return text
end

local function checkTimeLimit(info)
  local startTime = info.startTime or ""
  local endTime = info.endTime or ""
  if info.activityId and info.activityId > 0 then
    local activityCA = PlayerData:GetFactoryData(info.activityId)
    startTime = activityCA.startTime or ""
    endTime = activityCA.endTime or ""
  end
  local curTime = TimeUtil:GetServerTimeStamp()
  if startTime ~= "" then
    local timeStamp = TimeUtil:TimeStamp(startTime)
    if curTime < timeStamp then
      return false
    end
  end
  if endTime ~= "" then
    local timeStamp = TimeUtil:TimeStamp(endTime)
    if curTime > timeStamp then
      return false
    end
  end
  return true
end

local module = {npcId = 1}

function module.Play(element, info)
  if info.soundList then
    module.PlayerSounds(info.soundList)
  end
  if info.animNameList then
    module.PlayAnim(element, info.animNameList, info.isLoop)
  end
end

function module.SetNPCAsChildUI(parentView, id, enum, extraData)
  UIManager:Open("UI/Common/NPC", Json.encode({npcId = id, npcEnum = enum}))
  local npcController = require("UINPC/UINPCController")
  npcController:BindParentInfo(parentView, extraData)
  return npcController
end

function module.SetNPC(element, id, enum, specifiedUrl)
  module.npcId = id
  npcId = id
  npcElement = element
  isSpine = false
  local npcConfig = PlayerData:GetFactoryData(id, "NPCFactory")
  element.self:SetActive(true)
  if specifiedUrl ~= nil then
    element.SpineAnimation_Character:SetActive(false)
    element.Img_Role:SetActive(true)
    element.Img_Role:SetSprite(npcConfig[specifiedUrl])
  elseif npcConfig.spineUrl ~= "" then
    isSpine = true
    element.SpineAnimation_Character:SetActive(true)
    element.Img_Role:SetActive(false)
    element.SpineAnimation_Character:SetData(npcConfig.spineUrl)
    local offset = Vector2(npcConfig.spineOffsetX, npcConfig.spineOffsetY)
    element.SpineAnimation_Character:SetAnchoredPosition(offset)
    if npcConfig.spineScale ~= nil then
      element.SpineAnimation_Character:SetLocalScale(Vector3(npcConfig.spineScale * 100, npcConfig.spineScale * 100, npcConfig.spineScale))
    end
  else
    element.SpineAnimation_Character:SetActive(false)
    element.Img_Role:SetActive(true)
    element.Img_Role:SetSprite(npcConfig.resUrl)
    local offset = Vector2(npcConfig.offsetX, npcConfig.offsetY)
    element.Img_Role:SetAnchoredPosition(offset)
  end
  element.Img_Name.Txt_Name:SetText(npcConfig.name)
  dialogGroup.belongName = ""
  dialogGroup.listId = 0
  dialogGroup.curIdx = 0
  if enum ~= nil then
    module.SetNPCTextByEnum(element, enum)
  end
end

function module.HandleNPCTxtTable(extraValue)
  local npcConfig = PlayerData:GetFactoryData(npcId, "NPCFactory")
  local curReputationLv = 0
  if extraValue ~= nil then
    curReputationLv = extraValue.repLv or 0
  end
  for k, v in pairs(npcConfig) do
    if type(v) == "table" then
      for k1, v1 in pairs(v) do
        if v1.id ~= nil then
          local factoryName = DataManager:GetFactoryNameById(v1.id)
          if factoryName == "ListFactory" then
            local listCA = PlayerData:GetFactoryData(v1.id, factoryName)
            if listCA.listType == NPCDiagGroupEnum.Mutex then
              local dialogList = listCA.dialogList
              for i = 1, #dialogList - 1 do
                local cur = dialogList[i]
                local next = dialogList[i + 1]
                cur.detailTxt = nil
                cur.isHide = true
                if curReputationLv <= next.reputation then
                  cur.isHide = false
                else
                  next.isHide = false
                end
              end
            end
          else
            v1.detailTxt = nil
            v1.isHide = nil
          end
        end
      end
    end
  end
end

function module.HandleNPCTxtSpecialTable(enum, extraValue)
  local npcConfig = PlayerData:GetFactoryData(npcId, "NPCFactory")
  if npcConfig[enum] ~= nil then
    local t = npcConfig[enum]
    if enum == "ItemText" then
      local value = extraValue[1]
      for k, v in pairs(t) do
        v.detailTxt = string.format(GetText(v.id), value)
      end
    end
  end
end

function module.SetNPCText(element, txtTable, tableName)
  if txtTable == nil or #txtTable <= 0 then
    return
  end
  cacheTalkReturn = {}
  cacheTalkReturn.npcId = npcId
  if dialogGroup.belongName == tableName and dialogGroup.listId ~= 0 then
    local listCA = PlayerData:GetFactoryData(dialogGroup.listId, "ListFactory")
    local dialogList = listCA.dialogList
    if #dialogList > dialogGroup.curIdx then
      dialogGroup.curIdx = dialogGroup.curIdx + 1
      local info = dialogList[dialogGroup.curIdx]
      local text = getDetailText(info, cacheTalkReturn)
      setNpcText(element, text)
      module.Play(element, cacheTalkReturn)
      return
    end
  end
  dialogGroup.belongName = tableName
  dialogGroup.listId = 0
  dialogGroup.curIdx = 0
  local totalWeight = 0
  local tempTxtTable = txtTable
  txtTable = {}
  for i, info in ipairs(tempTxtTable) do
    if checkTimeLimit(info) then
      table.insert(txtTable, info)
    end
  end
  for k, v in pairs(txtTable) do
    if not v.isHide then
      totalWeight = totalWeight + v.weight
    end
  end
  local randomWeight = math.random(1, totalWeight)
  local detailTxt = ""
  for k, v in pairs(txtTable) do
    if not v.isHide then
      randomWeight = randomWeight - v.weight
      if randomWeight <= 0 then
        local factoryName = DataManager:GetFactoryNameById(v.id)
        if factoryName == "ListFactory" then
          do
            local listCA = PlayerData:GetFactoryData(v.id, factoryName)
            local dialogList = listCA.dialogList
            if listCA.listType == NPCDiagGroupEnum.Mutex then
              for k1, v1 in pairs(dialogList) do
                if not v1.isHide then
                  detailTxt = getDetailText(v1, cacheTalkReturn)
                  break
                end
              end
              break
            end
            if listCA.listType == NPCDiagGroupEnum.Order then
              dialogGroup.listId = v.id
              dialogGroup.curIdx = 1
              local info = dialogList[dialogGroup.curIdx]
              detailTxt = getDetailText(info, cacheTalkReturn)
            end
          end
          break
        end
        detailTxt = getDetailText(v, cacheTalkReturn)
        break
      end
    end
  end
  if detailTxt == "" then
    element.Img_Dialog.self:SetActive(false)
    return
  end
  setNpcText(element, detailTxt)
  module.Play(element, cacheTalkReturn)
end

function module.SetNPCTextByEnum(element, enum)
  local npcConfig = PlayerData:GetFactoryData(npcId, "NPCFactory")
  local textTable = npcConfig[enum]
  if textTable == nil then
    return
  end
  module.SetNPCText(element, textTable, enum)
end

function module.PlayerSounds(soundTable)
  if isStopSound then
    return
  end
  module.ClearAllSound()
  if soundTable ~= nil then
    soundList = soundTable
    module.PlaySingleSound()
  end
end

local function innerSoundEndCallBack()
  module.PlaySingleSound()
end

function module.PlaySingleSound()
  if soundList == nil then
    return
  end
  if curSoundIdx >= #soundList then
    module.ClearAllSound()
    return
  end
  curSoundIdx = curSoundIdx + 1
  local soundId = soundList[curSoundIdx]
  curPlaySound = SoundManager:CreateSound(soundId)
  if curPlaySound ~= nil then
    curPlaySound:SetEndCallBack(innerSoundEndCallBack)
    curPlaySound:Play()
  end
end

function module.ClearAllSound()
  curSoundIdx = 0
  soundList = nil
  if curPlaySound ~= nil then
    curPlaySound:SetEndCallBack()
    curPlaySound:Stop()
    curPlaySound = nil
  end
end

function module.PlayAnim(element, animNameList, isLoop)
  if isLoop == nil then
    isLoop = true
  end
  if animNameList ~= nil and 0 < #animNameList and isSpine then
    local cb
    if 1 < #animNameList then
      function cb()
        local animName = animNameList[2]
        
        element.SpineAnimation_Character:SetAction(animName, isLoop, true)
      end
    end
    local loop = false
    if #animNameList == 1 then
      loop = true
    end
    element.SpineAnimation_Character:SetAction(animNameList[1], loop, true, cb)
  end
end

function module.ClearAll()
  npcId = 0
  npcElement = nil
  isSpine = false
  module.ClearAllSound()
end

function module.StopSound(isStop)
  isStopSound = isStop
  if isStop then
    module.ClearAllSound()
  end
end

return module
