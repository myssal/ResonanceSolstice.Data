local DataModel = {}
DataModel.isSetPainting = false
DataModel.SortType = {
  pluckList = {},
  isIncr = false
}
DataModel.Roles = {}
DataModel.RefreshBreakIndex = 0
DataModel.SpecialList = {}
DataModel.CurrentSpecialList = {}
DataModel.SpecialFilterCA = {}

function DataModel.InitData(openData)
  DataModel.Cfg = GetCA(openData.eventId, "CubeEventFactory")
  DataModel.SelectList = {}
  DataModel.SetRoleData()
  DataModel.SpecialList = {}
  DataModel.CurrentSpecialList = {}
  DataModel.SpecialFilterCA = PlayerData:GetFactoryData(80304554)
  DataModel.SpecialList.Btn_Occupation = {}
  DataModel.SpecialList.Btn_Hit = {}
  DataModel.SpecialList.Btn_Technology = {}
  DataModel.SpecialList.Btn_All = {}
  for k, v in pairs(DataModel.SpecialFilterCA.occList) do
    local row = {}
    row.id = v.tagOcc
    local ca = PlayerData:GetFactoryData(row.id)
    row.name = ca.tagName
    row.icon = ca.icon
    table.insert(DataModel.SpecialList.Btn_All, row)
    table.insert(DataModel.SpecialList.Btn_Occupation, row)
  end
  for k, v in pairs(DataModel.SpecialFilterCA.hitList) do
    local row = {}
    row.id = v.tagHit
    local ca = PlayerData:GetFactoryData(row.id)
    row.name = ca.tagName
    row.icon = ca.icon
    table.insert(DataModel.SpecialList.Btn_All, row)
    table.insert(DataModel.SpecialList.Btn_Hit, row)
  end
  for k, v in pairs(DataModel.SpecialFilterCA.tecList) do
    local row = {}
    row.id = v.tagTec
    local ca = PlayerData:GetFactoryData(row.id)
    row.name = ca.tagName
    row.icon = ca.icon
    table.insert(DataModel.SpecialList.Btn_All, row)
    table.insert(DataModel.SpecialList.Btn_Technology, row)
  end
end

function DataModel.SetRoleData()
  DataModel.Roles = {}
  local roleList = PlayerData.TempCache.CubeRogueData.roles
  for k in pairs(PlayerData.ServerData.roles) do
    if roleList[tostring(k)] == nil then
      table.insert(DataModel.Roles, k)
    end
  end
end

function DataModel.OnHireSuccess()
  for k, v in pairs(DataModel.SelectList) do
    local idstr = tostring(v)
    table.list_remove(DataModel.Roles, idstr)
    PlayerData.TempCache.CubeRogueData.roles[idstr] = {}
  end
  DataModel.SelectList = {}
end

return DataModel
