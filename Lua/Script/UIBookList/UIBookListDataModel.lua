local BuffDataModel = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local EventDataModel = require("UIEvent/UIEventDataModel")
local EquipDataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local ItemDataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local DataModel = {
  cubeId = 0,
  BookIds = {
    team = 80900017,
    buff = 80900015,
    equip = 80900016,
    event = 80900020,
    item = 80900022
  }
}

function DataModel.GetCubeRogueConfig()
  return PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
end

function DataModel.GetCubeBookTypeConfig(index)
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if not cubeConfig then
    return nil
  end
  if not cubeConfig.bookTypeList then
    return nil
  end
  return cubeConfig.bookTypeList[index]
end

function DataModel.UpdateBookServerInfo(cubeBooks)
  cubeBooks = cubeBooks or {}
  PlayerData.ServerData.books = PlayerData.ServerData.books or {}
  PlayerData.ServerData.books.buff = cubeBooks.buff or {}
  PlayerData.ServerData.books.buff_reward = cubeBooks.buff_reward or {}
  PlayerData.ServerData.books.ce_reward = cubeBooks.ce_reward or {}
  PlayerData.ServerData.books.cube_equip = cubeBooks.cube_equip or {}
  PlayerData.ServerData.books.event = cubeBooks.event or {}
  PlayerData.ServerData.books.event_reward = cubeBooks.event_reward or {}
  PlayerData.ServerData.books.inside_item = cubeBooks.inside_item or {}
  PlayerData.ServerData.books.item_reward = cubeBooks.item_reward or {}
end

function DataModel.GetRedDotStatus()
  if BuffDataModel.GetProgressRewardRedState() then
    return true
  end
  if EquipDataModel.GetProgressRewardRedState() then
    return true
  end
  if EventDataModel.GetProgressRewardRedState() then
    return true
  end
  if ItemDataModel.GetProgressRewardRedState() then
    return true
  end
  return false
end

return DataModel
