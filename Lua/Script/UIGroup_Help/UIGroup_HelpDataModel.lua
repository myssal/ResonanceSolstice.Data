local DataModel = {}

function DataModel.initData(helpId)
  local cfg = PlayerData:GetFactoryData(helpId)
  DataModel.title = GetText(cfg.helpTitle)
  DataModel.helpList = cfg.help
  DataModel.selectIndex = 1
end

function DataModel.SearchHelpIndex(id)
  local index = 1
  if id ~= nil then
    for k, v in pairs(DataModel.helpList) do
      if v.tadId == id then
        return k
      end
    end
  end
  return index
end

return DataModel
