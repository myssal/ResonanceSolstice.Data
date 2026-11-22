local StartBattle = require("UISquads/View_StartBattle")
local Order = {}

function Order:OnStart(ca)
  local tempSquad = {}
  if ca.roleList ~= nil then
    for i = 1, #ca.roleList do
      if ca.roleList[i].id > 0 then
        local roleData = PlayerData:GetFactoryData(ca.roleList[i].id, "LevelRoleFactory")
        roleData.isLevelRole = true
        roleData.trustLv = 0
        tempSquad[i] = roleData
      end
    end
  end
  if next(tempSquad) == nil and PlayerData.ServerData.squad ~= nil then
    local currentSquad = PlayerData.ServerData.squad[PlayerData.BattleInfo.squadIndex]
    if currentSquad ~= nil then
      for k, v in pairs(currentSquad.role_list) do
        local roleData = PlayerData:GetFactoryData(tonumber(v), "LevelRoleFactory")
        if roleData == nil then
          error("OrderStartBattleError : id : " .. ca.id .. " mod : " .. ca.mod .. " info : " .. Json.encode(ca))
        end
        roleData.isLevelRole = true
        roleData.trustLv = 0
        tempSquad[v] = roleData
      end
    end
  end
  PlayerData.BattleCallBackPage = ""
  PlayerData.Last_Chapter_Parms = nil
  StartBattle:StartBattle(ca.levelId, 0, tempSquad, -1, nil, false)
end

function Order:IsFinish()
  return true
end

return Order
