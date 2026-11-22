local DataModel = require("UIMainUI/UIMainUIDataModel")
local Controller = {}

function Controller.RefreshTrains()
  HomeManager:RefreshData(CommonCoachData.roomID, CommonCoachData.roomData)
  local homeCommon = require("Common/HomeCommon")
  homeCommon.TempRefreshRoomPileUpData()
  Controller.UpdateFoodBoxNum()
  Controller.InitAllFurnitureExtraData()
end

function Controller.InitAllFurnitureExtraData()
  for k, v in pairs(CommonCoachData.GetFurData()) do
    Controller.InitFurnitureExtraData(v, k)
  end
end

function Controller.InitRoomFurnitureExtraData(roomIdx)
  local serverRoomData = CommonCoachData.GetRoomData(nil, true)
  local u_cid = serverRoomData[roomIdx] and serverRoomData[roomIdx].uid or nil
  if u_cid == nil and roomIdx <= #PlayerData:GetHomeInfo().coach_template then
    u_cid = PlayerData:GetHomeInfo().coach_template[roomIdx]
  end
  if u_cid ~= nil and u_cid ~= "" then
    for k, v in pairs(CommonCoachData.GetFurData()) do
      if v.u_cid == u_cid then
        Controller.InitFurnitureExtraData(v, k)
      end
    end
  end
end

function Controller.InitFurnitureExtraData(furnitureData, u_fid)
  if furnitureData.u_cid ~= nil and furnitureData.u_cid ~= "" then
    if furnitureData.space ~= nil and furnitureData.space.creatures ~= nil then
      HomeCreatureManager:AddFurCreatures(u_fid, furnitureData.space.creatures)
    end
    if furnitureData.plants ~= nil then
      for k, v in pairs(furnitureData.plants) do
        if v ~= nil and v ~= "" then
          HomeCreatureManager:AddFurIndexCreature(u_fid, v, k - 1)
        end
      end
    end
    if furnitureData.water ~= nil and furnitureData.water.fishes ~= nil then
      for k, v in pairs(furnitureData.water.fishes) do
        HomeCreatureManager:AddFurCreatureNum(u_fid, k, v)
      end
    end
  end
end

function Controller.CameraTween()
  if DataModel.cameraTween then
    local complete = MainManager:PlayCameraAnimation("In", function()
      DataModel.cameraTween = false
      Controller.GetOnHockReward(false)
    end)
    if not complete then
      DataModel.cameraTween = false
    end
  end
end

function Controller.UpdateFoodBoxNum()
  local boxMeal = PlayerData.ServerData.user_home_info.meal_info.box_meal
  local workMeal = PlayerData.ServerData.user_home_info.meal_info.work_meal
  local arrivedWorkMealCount = 0
  local curTime = PlayerData:GetSeverTime()
  if curTime < TimeUtil:GetFutureTime(0, 5) then
    arrivedWorkMealCount = 3
  else
    local orderTimeList = PlayerData:GetFactoryData(99900014, "ConfigFactory").orderTimeList
    for i = 1, #orderTimeList do
      local timeStr = orderTimeList[i].time
      local h = tonumber(string.sub(timeStr, 1, 2))
      local m = tonumber(string.sub(timeStr, 4, 5))
      local s = tonumber(string.sub(timeStr, 7, 8))
      if TimeUtil:GetNextSpecialTimeStamp(h, m, s, TimeUtil:GetFutureTime(0, 0)) <= TimeUtil:GetServerTimeStamp() then
        arrivedWorkMealCount = arrivedWorkMealCount + 1
      end
    end
  end
  local workMealCount = arrivedWorkMealCount - table.count(workMeal)
  local boxMealCount = 0
  for k, v in pairs(boxMeal) do
    if 0 < v.due_time - TimeUtil:GetServerTimeStamp() then
      boxMealCount = boxMealCount + 1
    end
  end
  HomeManager:SetSubViewNum(81300121, boxMealCount + workMealCount)
end

return Controller
