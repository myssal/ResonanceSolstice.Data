local View = require("UIHomeEmergency/UIHomeEmergencyView")
local DataModel = {}
DataModel.allCanLiveInCharacter = {}
DataModel.ufid = nil
DataModel.otherFurRoles = {}
DataModel.curFurRoles = nil
local this = DataModel

function DataModel.InitData()
  DataModel.otherFurRoles = {}
  for ufid, v in pairs(PlayerData:GetHomeInfo().furniture) do
    if ufid ~= DataModel.ufid then
      local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
      if furCA.functionType == 12600296 and v.roles then
        for i, roleId in pairs(v.roles) do
          if roleId ~= "" then
            DataModel.otherFurRoles[tostring(roleId)] = ufid
          end
        end
      end
    end
  end
  DataModel.curFurRoles = {}
  local furData = PlayerData:GetFurniture()[DataModel.ufid]
  if furData.roles then
    for i, roleId in pairs(furData.roles) do
      if roleId ~= "" then
        DataModel.curFurRoles[tostring(roleId)] = DataModel.ufid
      end
    end
  end
  this.RefreshAllCanLiveInCharacter()
end

function DataModel.RefreshAllCanLiveInCharacter()
  this.allCanLiveInCharacter = {}
  for roleId, v in pairs(PlayerData.ServerData.roles) do
    local unitCA = PlayerData:GetFactoryData(roleId, "UnitFactory")
    if unitCA.homeCharacter > 0 and unitCA.isDoctor then
      local t = {}
      t.id = roleId
      t.name = unitCA.name
      t.jobInt = unitCA.jobInt
      t.qualityInt = unitCA.qualityInt
      local viewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
      t.resUrl = viewCA.resUrl
      t.roleListResUrl = viewCA.roleListResUrl
      t.lv = v.lv
      t.obtain_time = v.obtain_time
      t.resonance_lv = v.resonance_lv or 0
      t.awake_lv = v.awake_lv or 0
      table.insert(this.allCanLiveInCharacter, t)
    end
  end
end

DataModel.ESortType = {
  level = 1,
  quality = 2,
  time = 3
}

function DataModel.SortByLevel()
  table.sort(this.allCanLiveInCharacter, function(a, b)
    local isTemp1 = this.IsRoleInCurEmergency(a.id)
    local isTemp2 = this.IsRoleInCurEmergency(b.id)
    if isTemp1 and isTemp2 then
      return false
    elseif isTemp1 then
      return true
    elseif isTemp2 then
      return false
    else
      local isLive1 = this.IsRoleLiveIn(a.id)
      local isLive2 = this.IsRoleLiveIn(b.id)
      if isLive1 and not isLive2 then
        return false
      elseif not isLive1 and isLive2 then
        return true
      elseif a.lv == b.lv then
        if a.qualityInt == b.qualityInt then
          return tonumber(a.id) > tonumber(b.id)
        else
          return tonumber(a.qualityInt) > tonumber(b.qualityInt)
        end
      else
        return a.lv > b.lv
      end
    end
  end)
end

function DataModel.SortByQuality()
  table.sort(this.allCanLiveInCharacter, function(a, b)
    local isTemp1 = this.IsRoleInCurEmergency(a.id)
    local isTemp2 = this.IsRoleInCurEmergency(b.id)
    if isTemp1 and isTemp2 then
      return false
    elseif isTemp1 then
      return true
    elseif isTemp2 then
      return false
    else
      local isLive1 = this.IsRoleLiveIn(a.id)
      local isLive2 = this.IsRoleLiveIn(b.id)
      if isLive1 and not isLive2 then
        return false
      elseif not isLive1 and isLive2 then
        return true
      elseif a.qualityInt == b.qualityInt then
        if a.lv == b.lv then
          return tonumber(a.id) > tonumber(b.id)
        else
          return tonumber(a.lv) > tonumber(b.lv)
        end
      else
        return a.qualityInt > b.qualityInt
      end
    end
  end)
end

function DataModel.SortByTime()
  table.sort(this.allCanLiveInCharacter, function(a, b)
    local isTemp1 = this.IsRoleInCurEmergency(a.id)
    local isTemp2 = this.IsRoleInCurEmergency(b.id)
    if isTemp1 and isTemp2 then
      return false
    elseif isTemp1 then
      return true
    elseif isTemp2 then
      return false
    else
      local isLive1 = this.IsRoleLiveIn(a.id)
      local isLive2 = this.IsRoleLiveIn(b.id)
      if isLive1 and not isLive2 then
        return false
      elseif not isLive1 and isLive2 then
        return true
      elseif a.obtain_time == b.obtain_time then
        return tonumber(a.id) > tonumber(b.id)
      else
        return a.obtain_time > b.obtain_time
      end
    end
  end)
end

function DataModel.RefreshOnShow()
  DataModel.RefreshRoleListPanel(DataModel.ESortType.level)
end

function DataModel.RefreshRoleListPanel(sortType)
  if sortType == DataModel.ESortType.level then
    DataModel.SortByLevel()
  elseif sortType == DataModel.ESortType.quality then
    DataModel.SortByQuality()
  elseif sortType == DataModel.ESortType.time then
    DataModel.SortByTime()
  end
  View.characterList:SetActive(true)
  View.characterList.Group_TopRight.Btn_Level.Img_Select:SetActive(sortType == DataModel.ESortType.level)
  View.characterList.Group_TopRight.Btn_Rarity.Img_Select:SetActive(sortType == DataModel.ESortType.quality)
  View.characterList.Group_TopRight.Btn_Time.Img_Select:SetActive(sortType == DataModel.ESortType.time)
  View.characterList.ScrollGrid_.grid.self:SetDataCount(table.count(DataModel.allCanLiveInCharacter))
  View.characterList.ScrollGrid_.grid.self:RefreshAllElement()
end

function DataModel.RefreshFurRoleData(roleId)
  roleId = tostring(roleId)
  local selectRoleInEmergency = DataModel.IsRoleLiveIn(roleId)
  local selectRoleEmergencyUfid
  if selectRoleInEmergency then
    selectRoleEmergencyUfid = DataModel.GetRoleEmergencyUfid(roleId)
  end
  local curFurData = PlayerData:GetFurniture()[DataModel.ufid]
  curFurData.roles = curFurData.roles or {}
  local curRoleId = curFurData.roles[1] and tostring(curFurData.roles[1]) or ""
  if roleId == curRoleId then
    curFurData.roles[1] = nil
    DataModel.curFurRoles[roleId] = nil
    CharacterUtil.StopOp(curRoleId)
  elseif selectRoleInEmergency then
    curFurData.roles[1] = roleId
    local selectRoleEmergencyFurData = PlayerData:GetFurniture()[selectRoleEmergencyUfid]
    selectRoleEmergencyFurData.roles[1] = curRoleId
    if curRoleId ~= "" then
      DataModel.otherFurRoles[curRoleId] = selectRoleEmergencyUfid
    end
    DataModel.curFurRoles[roleId] = DataModel.ufid
    CharacterUtil.InitOp(roleId, DataModel.ufid, 0, -1)
    if curRoleId ~= "" then
      CharacterUtil.InitOp(curRoleId, selectRoleEmergencyUfid, 0, -1)
    end
  else
    curFurData.roles[1] = roleId
    DataModel.curFurRoles[roleId] = DataModel.ufid
    if curRoleId ~= "" then
      CharacterUtil.StopOp(curRoleId)
    end
    CharacterUtil.InitOp(roleId, DataModel.ufid, 0, -1)
  end
  Net:SendProto("hero.check_in", function(json)
  end, DataModel.ufid, roleId)
  if selectRoleEmergencyUfid then
    Net:SendProto("hero.check_in", function(json)
    end, selectRoleEmergencyUfid, curRoleId)
  end
  PlayerData:RemoveRoleSleepTime(roleId)
end

function DataModel.InitEmergency()
  for ufid, v in pairs(PlayerData:GetHomeInfo().furniture) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    if furCA.functionType == 12600296 and v.roles then
      for index, roleId in pairs(v.roles) do
        if roleId ~= "" then
          CharacterUtil.InitOp(roleId, ufid, index - 1, -1)
        end
      end
    end
  end
end

function DataModel.GetRoleEmergencyUfid(roleId)
  roleId = tostring(roleId)
  return DataModel.otherFurRoles[roleId] or DataModel.curFurRoles[roleId]
end

function DataModel.IsRoleLiveIn(roleId)
  return DataModel.GetRoleEmergencyUfid(roleId) ~= nil
end

function DataModel.IsRoleInCurEmergency(roleId)
  local ufid = DataModel.GetRoleEmergencyUfid(roleId)
  return ufid == DataModel.ufid
end

return DataModel
