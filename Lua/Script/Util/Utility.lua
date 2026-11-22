function StringFormat(msg, ...)
  local pattern = "{%d+}"
  
  local isMatch = string.find(msg, pattern)
  if isMatch == nil then
    return string.format(msg, ...)
  end
  local matchList = string.gmatch(msg, pattern)
  local args = {
    ...
  }
  local tableParams = {}
  local num = 1
  for v in matchList, nil, nil do
    local i_str = string.gsub(v, "[{}]", "")
    local index = tonumber(i_str)
    local count = #args
    if index > count then
      index = count - 1
    end
    local result = args[index]
    tableParams[num] = result
    num = num + 1
  end
  local msgNew = string.gsub(msg, "{%d+}", "")
  local count = #tableParams
  local arg1, arg2, arg3, arg4, arg5
  if 5 <= count then
    arg5 = tableParams[5]
  end
  if 4 <= count then
    arg4 = tableParams[4]
  end
  if 3 <= count then
    arg3 = tableParams[3]
  end
  if 2 <= count then
    arg2 = tableParams[2]
  end
  if 1 <= count then
    arg1 = tableParams[1]
  end
  print_r("msgnew", msgNew)
  print_r("msg", msg)
  print_r("arg1", arg1)
  print_r("arg2", arg2)
  return string.format(msgNew, arg1, arg2, arg3, arg4, arg5)
end

function Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break
    end
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
    nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

function Trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function ToNumber(value)
  return math.modf(value + 0.1)
end

function GetText(id)
  local idText = PlayerData:GetFactoryData(id, "TextFactory")
  if idText ~= nil then
    return idText.text
  else
    return PlayerData:GetFactoryData(80600033, "TextFactory").text
  end
end

function GetTextNPCMod(id, returnTable)
  local idText = PlayerData:GetFactoryData(id, "TextFactory")
  returnTable.soundList = {}
  returnTable.animNameList = {}
  if idText ~= nil then
    if idText.isReplace then
      local text = ""
      local cacheStationId = 0
      local cacheGoodsId = 0
      
      local function replaceFunc1()
        local t = PlayerData.TempCache.NPCTalkData[idText.replaceType]
        if t ~= nil and 0 < #t then
          local idx = 1
          local count = #t
          local curTime = TimeUtil:GetServerTimeStamp()
          while idx <= count do
            local info = t[idx]
            if curTime >= info.end_time then
              table.remove(t, idx)
              count = count - 1
            else
              idx = idx + 1
            end
          end
          if 0 < count then
            local randomIdx = math.random(1, count)
            local detailInfo = t[randomIdx]
            cacheStationId = detailInfo.stationId
            cacheGoodsId = detailInfo.goodsId
            text = string.gsub(idText.text, "{%a+}", function(s)
              if s == idText.stationString then
                return detailInfo.stationName
              elseif s == idText.goodsString then
                return detailInfo.goodsName
              end
              return s
            end)
          end
        end
      end
      
      local function replaceFunc2()
        local t = PlayerData.TempCache.NPCTalkData[idText.replaceType]
        if t ~= nil and 0 < #t then
          local num = math.random(1, #t)
          local data = t[num]
          cacheGoodsId = data.goodsId
          text = string.gsub(idText.text, idText.goodsString, function(s)
            return data.name
          end)
        end
      end
      
      local TypeToFunc = {
        [EnumDefine.NPCTalkDataEnum.BuySuddenRise] = replaceFunc1,
        [EnumDefine.NPCTalkDataEnum.BuySuddenDrop] = replaceFunc1,
        [EnumDefine.NPCTalkDataEnum.SellSuddenRise] = replaceFunc1,
        [EnumDefine.NPCTalkDataEnum.SellSuddenDrop] = replaceFunc1,
        [EnumDefine.NPCTalkDataEnum.Drop] = replaceFunc2,
        [EnumDefine.NPCTalkDataEnum.Rise] = replaceFunc2,
        [EnumDefine.NPCTalkDataEnum.RareGoods] = replaceFunc2
      }
      if idText.replaceType == EnumDefine.NPCTalkDataEnum.PlayerName then
        local userInfo = PlayerData:GetUserInfo()
        local playerName = ""
        if userInfo ~= nil then
          playerName = userInfo.role_name
        end
        text = string.gsub(idText.text, idText.playerNameString, playerName)
      elseif TypeToFunc[idText.replaceType] ~= nil then
        TypeToFunc[idText.replaceType]()
      end
      if text == "" then
        if idText.noDataTextId <= 0 then
          return GetText(80601225)
        end
        local ca = PlayerData:GetFactoryData(idText.noDataTextId, "TextFactory")
        text = ca.text
        if ca.soundList then
          for i, v in ipairs(ca.soundList) do
            table.insert(returnTable.soundList, v.id)
          end
        end
        if ca.preAnimName ~= "" then
          table.insert(returnTable.animNameList, ca.preAnimName)
        end
        if ca.animName ~= "" then
          table.insert(returnTable.animNameList, ca.animName)
        end
        returnTable.isLoop = ca.isLoop
      else
        local npcCA = PlayerData:GetFactoryData(returnTable.npcId, "NPCFactory")
        if idText.soundList then
          for i, v in ipairs(idText.soundList) do
            if v.replaceType == "None" then
              table.insert(returnTable.soundList, v.id)
            elseif v.replaceType == "Station" then
              for i1, v1 in ipairs(npcCA.stationSoundList) do
                if v1.stationId == cacheStationId then
                  table.insert(returnTable.soundList, v1.soundId)
                  break
                end
              end
            elseif v.replaceType == "Goods" then
              for i1, v1 in ipairs(npcCA.goodsSoundList) do
                if v1.goodsId == cacheGoodsId then
                  table.insert(returnTable.soundList, v1.soundId)
                  break
                end
              end
            end
          end
        end
        if idText.preAnimName ~= "" then
          table.insert(returnTable.animNameList, idText.preAnimName)
        end
        if idText.animName ~= "" then
          table.insert(returnTable.animNameList, idText.animName)
        end
        returnTable.isLoop = idText.isLoop
      end
      return text
    else
      if idText.soundList then
        for i, v in ipairs(idText.soundList) do
          table.insert(returnTable.soundList, v.id)
        end
      end
      if idText.preAnimName ~= "" then
        table.insert(returnTable.animNameList, idText.preAnimName)
      end
      if idText.animName ~= "" then
        table.insert(returnTable.animNameList, idText.animName)
      end
      returnTable.isLoop = idText.isLoop
      return idText.text
    end
  else
    return PlayerData:GetFactoryData(80600033, "TextFactory").text
  end
end

function NumThousandsSplit(num, saveDecimalNum)
  local intPart = math.floor(num)
  local decimalPart = num - intPart
  local s = tostring(intPart)
  local pos = string.len(s) % 3
  if pos == 0 then
    pos = 3
  end
  local result = string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos + 1), "(...)", ",%1")
  if saveDecimalNum then
    return result .. string.format(".%." .. saveDecimalNum .. "f", decimalPart)
  end
  return result
end

function ClearFollowZero(num, saveDecimalNum)
  if not saveDecimalNum then
    saveDecimalNum = 1
  elseif 3 < saveDecimalNum then
    saveDecimalNum = 3
  end
  local format = "%." .. saveDecimalNum .. "f"
  local str = string.format(format, num)
  local s = str:gsub("(%.%d*[1-9])0+$", "%1"):gsub("%.0*$", "")
  return tonumber(s)
end

function SafeReleaseVaildScene()
  local curSceneList = {}
  local cnt = CS.UnityEngine.SceneManagement.SceneManager.sceneCount - 1
  for i = 0, cnt do
    local s = CS.UnityEngine.SceneManagement.SceneManager.GetSceneAt(i)
    table.insert(curSceneList, s.name)
  end
  local SliceSceneManager = CBus:GetManager(CS.ManagerName.SliceSceneManager, true)
  if SliceSceneManager ~= nil then
    local i = SliceSceneManager.loadedScene.Count - 1
    if i < 0 then
      return
    end
    while 0 <= i do
      local item = SliceSceneManager.loadedScene[i]
      local v = SliceSceneManager:Sceneid2Pos(item)
      local name = "crunk" .. 100 + v.x .. "_" .. 100 + v.y
      if SliceSceneManager.loadingScene:Contains(item) == false and CheckSceneExist(name, curSceneList) == false then
        SliceSceneManager.loadedScene:RemoveAt(i)
      end
      i = i - 1
    end
  end
end

function SafeReleaseScene(isUnload)
  local instance = CS.LODGroupIJob.JobSystem.LODGroupManager.Instance
  if instance.m_AllLODGroupBuffer ~= nil then
    for i, v in pairs(instance.m_AllLODGroupBuffer) do
      if v ~= nil then
        local rgmlg = v:GetComponent(typeof(CS.RGMLoaderGroup))
        local idx = 0
        for i2, v2 in pairs(rgmlg.stateAry) do
          rgmlg.stateAry[idx] = 5
          idx = idx + 1
        end
      end
    end
  end
  local curSceneList = {}
  if isUnload == nil then
    isUnload = false
  end
  if isUnload == true then
    local cnt = CS.UnityEngine.SceneManagement.SceneManager.sceneCount - 1
    for i = 0, cnt do
      local s = CS.UnityEngine.SceneManagement.SceneManager.GetSceneAt(i)
      table.insert(curSceneList, s.name)
    end
  end
  local SliceSceneManager = CBus:GetManager(CS.ManagerName.SliceSceneManager, true)
  if SliceSceneManager ~= nil then
    local i = SliceSceneManager.loadedScene.Count - 1
    while 0 <= i do
      local item = SliceSceneManager.loadedScene[i]
      local v = SliceSceneManager:Sceneid2Pos(item)
      local name = "crunk" .. 100 + v.x .. "_" .. 100 + v.y
      if isUnload == true and CheckSceneExist(name, curSceneList) then
        SliceSceneManager:UnloadScene(v.x, v.y, true)
      else
        local DisplayManager = CBus:GetManager(CS.ManagerName.DisplayManager, true)
        if DisplayManager ~= nil then
          DisplayManager:RemoveWatcher(name)
        end
        local ResManager = CBus:GetManager(CS.ManagerName.ResManager, true)
        if ResManager ~= nil then
          ResManager.resloader:ReleaseGCKeyBroadCast("#" .. name, true, true)
        end
      end
      i = i - 1
    end
    SliceSceneManager.loadedScene:Clear()
  end
end

function CheckLoopSound(sound)
  if sound then
    if sound.audioSource == nil or sound.audioSource == nil or sound.audioSource.clip == nil then
      sound:Stop()
    else
      sound:Play()
    end
  end
end

function CheckSceneExist(name, list)
  if list == nil then
    return false
  end
  local rel = false
  for i, v in ipairs(list) do
    if v == name then
      rel = true
    end
  end
  return rel
end

function GetResPath(caId)
  local ca = PlayerData:GetFactoryData(caId)
  if ca == nil then
    return ""
  end
  return ca.filePath or ""
end

seven_mt = {
  __index = function(t, key)
    if t.self then
      return t.self[key]
    end
    return t[key]
  end
}

function FixAdBoard()
  local modeNode = CS.UnityEngine.GameObject.Find("AD_Board")
  if modeNode == nil then
    return
  end
  local ads = modeNode:GetComponent(typeof(CS.AdBoardView))
  ads.isRGMLoaded = true
end
