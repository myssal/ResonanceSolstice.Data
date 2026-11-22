local DataModel = {
  eventId = nil,
  sealEventType = nil,
  sealList = {},
  selectIndex = 1,
  isSubmitting = false
}

function DataModel.SetJsonData(json)
  local data = Json.decode(json)
  DataModel.eventId = data.eventId
  DataModel.sealEventType = data.sealEventType
  DataModel.sealList = WitchData.GetWitchesData().user_seal or {}
  DataModel.selectIndex = #DataModel.sealList > 0 and 1 or 0
  DataModel.isSubmitting = false
end

return DataModel
