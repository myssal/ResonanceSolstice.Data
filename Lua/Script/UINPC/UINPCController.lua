local View = require("UINPC/UINPCView")
local DataModel = require("UINPC/UINPCDataModel")
local NPCDialog = require("Common/NPCDialog")
local Controller = {}

function Controller:SelfInit()
  DataModel.npcId = DataModel.initParams.npcId
  local npcConfig = PlayerData:GetFactoryData(DataModel.npcId, "NPCFactory")
  DataModel.isSpine = npcConfig.spineUrl ~= ""
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  DataModel.stationId = 0
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info ~= nil then
    local stop_info = station_info.stop_info
    if stop_info ~= nil and stop_info[2] == -1 then
      DataModel.stationId = tonumber(stop_info[1])
    end
  end
  local HomeCommon = require("Common/HomeCommon")
  local repLv = HomeCommon.GetRepLv(DataModel.stationId)
  NPCDialog.HandleNPCTxtTable({repLv = repLv})
  Controller:ShowNPCTalk(DataModel.initParams.npcEnum ~= nil and DataModel.initParams.npcEnum or DataModel.NPCDialogEnum.enterText)
end

function Controller:ParentCallInit(extraData)
  if extraData then
    if extraData.canvasOrder ~= nil then
      View.self:SetCanvasOrder(extraData.canvasOrder)
      View.self.IsDisableUIOrder = true
    else
      DataModel.autoUpdateOrder = true
    end
    if extraData.stationId ~= nil then
      DataModel.stationId = extraData.stationId
    end
    if extraData.npcEnum ~= nil then
      Controller:ShowNPCTalk(extraData.npcEnum)
    end
  end
end

function Controller:ShowNPCTalk(dialogEnum)
  local npcConfig = PlayerData:GetFactoryData(DataModel.npcId, "NPCFactory")
  if npcConfig then
    local textTable = {}
    textTable = npcConfig[dialogEnum]
    if textTable == nil then
      return
    end
    local commonNpc = require("Common/NPCDialog")
    local info = commonNpc.SetNPCText(View.Group_NPC, textTable, dialogEnum)
    Controller:PlayerSounds(info.soundList)
    Controller:PlayAnim(info.animName)
  end
end

function Controller:PlayerSounds(soundTable)
  Controller:ClearAllSound()
  if soundTable ~= nil then
    DataModel.soundList = soundTable
    Controller:PlaySingleSound()
  end
end

local function innerSoundEndCallBack()
  Controller:PlaySingleSound()
end

function Controller:PlaySingleSound()
  if DataModel.curSoundIdx >= #DataModel.soundList then
    Controller:ClearAllSound()
    return
  end
  DataModel.curSoundIdx = DataModel.curSoundIdx + 1
  local soundId = DataModel.soundList[DataModel.curSoundIdx]
  DataModel.curPlaySound = SoundManager:CreateSound(soundId)
  if DataModel.curPlaySound ~= nil then
    DataModel.curPlaySound:SetEndCallBack(innerSoundEndCallBack)
    DataModel.curPlaySound:Play()
  end
end

function Controller:ClearAllSound()
  DataModel.curSoundIdx = 0
  DataModel.soundList = nil
  if DataModel.curPlaySound ~= nil then
    DataModel.curPlaySound:SetEndCallBack()
    DataModel.curPlaySound:Stop()
    DataModel.curPlaySound = nil
  end
end

function Controller:PlayAnim(animName)
  if animName ~= nil and animName ~= "" and DataModel.isSpine then
    View.Group_NPC.SpineAnimation_Character:SetAction(animName, true, true)
  end
end

function Controller:BindParentInfo(parentView, extraData)
  DataModel.parentView = parentView
  parentView:RegChildPanel(View.self.url)
  Controller:ParentCallInit(extraData)
  return Controller
end

function Controller:ViewClosedCall()
  View.self.IsDisableUIOrder = false
  Controller:ClearAllSound()
  DataModel.parentView:UnregChildPanel(View.self.url)
  DataModel.parentView = nil
end

return Controller
