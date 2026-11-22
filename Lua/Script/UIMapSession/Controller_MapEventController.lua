local View = require("UIDialog/UIDialogView")
local DataModel = require("UIMapSession/UIMapSessionDataModel")
local MapEventBase = require("UIMapSession/Model_MapEventBase")
local classModName = {}
local continue = false
local classMod, allMod, isFinish, CA
local isInited = false
local classModAction

local function End()
  if allMod == nil then
    print_r("\230\174\181\232\144\189\233\133\141\231\189\174\233\148\153\232\175\175,\233\156\128\232\166\129\231\173\150\229\136\146\232\167\163\229\134\179!!!\n\230\174\181\232\144\189\229\139\190\233\128\137\228\186\134\228\184\141\232\191\148\229\155\158\228\184\138\228\184\170\231\149\140\233\157\162,\228\188\154\229\141\161\229\156\168\230\156\128\229\144\142\228\184\128\230\174\181\229\137\167\230\131\133\n\n\232\167\163\229\134\179\230\150\185\229\188\143:\n\230\150\185\229\188\1431.\229\139\190\233\128\137\230\174\181\232\144\189-\232\191\148\229\155\158\228\184\138\228\184\170\231\149\140\233\157\162,\230\150\185\229\188\143\n2.\229\188\149\229\175\188\229\183\165\229\142\130+\229\188\149\229\175\188+\229\188\149\229\175\188\229\145\189\228\187\164\229\183\165\229\142\130")
    return
  end
  continue = false
  isFinish = true
  classMod = nil
  allMod = {}
end

local controller = {
  Init = function(ca)
    allMod = {}
    classMod = nil
    continue = false
    isFinish = true
    isInited = true
  end,
  OnEnd = function()
    End()
  end,
  Update = function()
    if classModAction ~= nil then
      classModAction()
      classModAction = nil
      return
    end
    if isFinish == true or classMod == nil then
      return
    end
    classMod:OnUpdate()
  end
}

function controller.InitEvent(obj, id, args)
  if isInited ~= true then
    controller.Init()
  end
  local rt = MapSessionManager:SessionOnInit()
  isFinish = false
  return rt ~= "break"
end

function controller.GetClassMod()
  return classMod
end

function controller.RecycleCurrent()
  if classMod ~= nil then
    classMod:Dtor()
    classMod = nil
    CA = nil
    isFinish = true
    continue = false
  end
end

function controller.IsFinish()
  return isFinish
end

function controller.SetFlag(sid, id)
  Net:SendProto("adventure.set_flag", function(json)
    MapSessionManager:ProtocolCallback(sid, "adventure.set_flag", Json.encode(json.map_event))
  end, id)
end

function controller.GetGroup(sid, groupId)
  Net:SendProto("adventure.get_group", function(json)
    MapSessionManager:ProtocolCallback(sid, "adventure.get_group", Json.encode(json.map_event[groupId]))
  end, groupId)
end

function controller.EventReceiveQuest(questId)
  if questId == nil then
    return
  end
  Net:SendProto("quest.accept", function()
    local quests = PlayerData.ServerData.quests
  end, tostring(questId))
end

function controller.EventChangeScene(sceneName, uiPath, param)
  if not sceneName then
    return
  end
  PlayerData.BattleCallBackPage = ""
  PlayerData.Last_Chapter_Parms = nil
  CoroutineManager:Reg("needleClick", LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
    CommonTips.OpenLoadingCB(function()
      UIManager:Pause(false)
      if sceneName == "Battle" then
        SafeReleaseScene(false)
      end
      CBus:ChangeScene(sceneName, function()
        if uiPath then
          local initParam = {}
          if uiPath == "UI/InsZone/InsZone" then
            MapNeedleEventData.scene = sceneName
            initParam = {chapterId = param}
          end
          UIManager:Open(uiPath, Json.encode(initParam))
        end
      end)
    end)
    CoroutineManager:UnReg("needleClick")
  end))
end

function controller.OpenStore(id)
  local stationPlace = PlayerData:GetFactoryData(id, "HomeStationPlaceFactory")
  if PlayerData:GetUserInfo().lv < stationPlace.levelOpen then
    CommonTips.OpenTips(string.format(GetText(stationPlace.lockedTip), stationPlace.levelOpen))
    return
  end
  local MainController = require("UIMainUI/UIMainUIController")
  MainController.ImmediatelyStop()
  HomeStationStoreManager:Create(stationPlace.resId, stationPlace.id)
  local coachCA = PlayerData:GetFactoryData(stationPlace.resId, "HomeCoachFactory")
  HomeStationStoreManager:Load(coachCA.defaultTemplate)
  for i, v in pairs(stationPlace.npcList) do
    HomeStationStoreManager:CreateCustom(v.id, 0, v.isRandom, v.npcX, v.npcZ, v.tree)
  end
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local conductor = PlayerData:GetUserInfo().gender == 1 and homeConfig.conductorM or homeConfig.conductorW
  HomeStationStoreManager:CreateCustom(conductor, 0, true, 0, 0, "PassengerKCD:move")
  local c = PlayerData:GetFactoryData(stationPlace.serverId, "HomeCharacterFactory")
  HomeStationStoreManager:CreateSpeicalCharacter(stationPlace.serverId, 0, 0, c.interactiveIconPath)
  UIManager:Open("UI/CityStore/CityStore", Json.encode({
    StationId = tostring(0),
    PlaceId = tostring(id)
  }))
  local sound = SoundManager:CreateSound(stationPlace.bgm)
  if sound ~= nil then
    sound:Play()
  end
  TrainCameraManager:OpenCamera(3)
end

return controller
