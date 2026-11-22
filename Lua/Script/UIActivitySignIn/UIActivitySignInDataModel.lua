local DataModel = {
  activityId = 0,
  activityCA = nil,
  signinId = 0,
  SignInConfig = nil
}

function DataModel:Init(initParams)
  DataModel.initParams = Json.decode(initParams)
  DataModel.activityId = DataModel.initParams.activityId
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  DataModel.signinId = DataModel.activityCA.signinId
  DataModel.SignInConfig = PlayerData:GetFactoryData(DataModel.signinId)
end

return DataModel
