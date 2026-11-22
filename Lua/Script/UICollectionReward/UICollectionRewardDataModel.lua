local Buff_DataModel = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local Equip_DataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local Event_DataModel = require("UIEvent/UIEventDataModel")
local ItemDataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local DataModel = {
  bookId = 0,
  bookIdTypes = {
    buff = 80900015,
    equip = 80900016,
    event = 80900020,
    item = 80900022
  },
  stateType = {
    canNotGet = 1,
    canGet = 2,
    hasGet = 3
  }
}

function DataModel.GetFinishCount()
  if DataModel.bookId == DataModel.bookIdTypes.buff then
    return Buff_DataModel.GetFinishedProgressNum()
  elseif DataModel.bookId == DataModel.bookIdTypes.equip then
    return Equip_DataModel.GetFinishedProgressNum()
  elseif DataModel.bookId == DataModel.bookIdTypes.event then
    return Event_DataModel.GetFinishedProgressNum()
  elseif DataModel.bookId == DataModel.bookIdTypes.item then
    return ItemDataModel.GetFinishedProgressNum()
  end
end

function DataModel.GetAllUnlockNum()
  local unlockNum = 0
  local allNum = 0
  if DataModel.bookId == DataModel.bookIdTypes.buff then
    unlockNum = Buff_DataModel.GetAllUnlockCount()
    allNum = #Buff_DataModel.GetAllBuffList()
  elseif DataModel.bookId == DataModel.bookIdTypes.equip then
    unlockNum = Equip_DataModel.GetAllUnlockCount()
    allNum = #Equip_DataModel.GetAllEquipList()
  elseif DataModel.bookId == DataModel.bookIdTypes.event then
    unlockNum = Event_DataModel.GetAllUnlockCount()
    allNum = #Event_DataModel.GetAllEventList()
  elseif DataModel.bookId == DataModel.bookIdTypes.item then
    unlockNum = ItemDataModel.GetAllUnlockCount()
    allNum = #ItemDataModel.GetAllItemList()
  end
  return unlockNum, allNum
end

function DataModel.GetBookInfo()
  return PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
end

function DataModel.GetStageGetStateByIndex(index)
  if not index then
    return DataModel.stateType.canNotGet
  end
  local isUnlockNumEnough = false
  local isHasGet = false
  if DataModel.bookId == DataModel.bookIdTypes.buff then
    isUnlockNumEnough = Buff_DataModel.GetUnlockNumEnoughToGet(index)
    isHasGet = Buff_DataModel.GetRewardIsGetByIndex(index - 1)
  elseif DataModel.bookId == DataModel.bookIdTypes.equip then
    isUnlockNumEnough = Equip_DataModel.GetUnlockNumEnoughToGet(index)
    isHasGet = Equip_DataModel.GetRewardIsGetByIndex(index - 1)
  elseif DataModel.bookId == DataModel.bookIdTypes.event then
    isUnlockNumEnough = Event_DataModel.GetUnlockNumEnoughToGet(index)
    isHasGet = Event_DataModel.GetRewardIsGetByIndex(index - 1)
  elseif DataModel.bookId == DataModel.bookIdTypes.item then
    isUnlockNumEnough = ItemDataModel.GetUnlockNumEnoughToGet(index)
    isHasGet = ItemDataModel.GetRewardIsGetByIndex(index - 1)
  end
  if not isUnlockNumEnough then
    return DataModel.stateType.canNotGet
  end
  if isHasGet then
    return DataModel.stateType.hasGet
  end
  return DataModel.stateType.canGet
end

function DataModel.GetProtoName()
  if DataModel.bookId == DataModel.bookIdTypes.buff then
    return "book.buff_reward"
  elseif DataModel.bookId == DataModel.bookIdTypes.equip then
    return "book.equip_reward"
  elseif DataModel.bookId == DataModel.bookIdTypes.event then
    return "book.event_reward"
  elseif DataModel.bookId == DataModel.bookIdTypes.item then
    return "book.item_reward"
  end
end

function DataModel.SetRewardHasGet(index)
  if DataModel.bookId == DataModel.bookIdTypes.buff then
    Buff_DataModel.SetRewardHasGet(index)
  elseif DataModel.bookId == DataModel.bookIdTypes.equip then
    Equip_DataModel.SetRewardHasGet(index)
  elseif DataModel.bookId == DataModel.bookIdTypes.event then
    Event_DataModel.SetRewardHasGet(index)
  elseif DataModel.bookId == DataModel.bookIdTypes.item then
    ItemDataModel.SetRewardHasGet(index)
  end
end

return DataModel
