local DataModel = {}

function DataModel:Init(params)
  self.resultList = params.resultList
  self.newIndex = params.newIndex
  self.levelId = params.levelId
end

return DataModel
