local LogoutHelper = {}

function LogoutHelper.LogoutFromGaming()
  HasAddGloableTrainUpdate = nil
  local TimerHelper = require("Common/Timer/TimerHelper")
  TimerHelper.Stop("TrainGloableUpdate")
  TimerHelper.Stop("TrainWheelUpdate")
  SdkHelper.TryLogout()
  PlayerData:Logout()
end

function LogoutHelper.LogoutFromSdk()
  HasAddGloableTrainUpdate = nil
  local TimerHelper = require("Common/Timer/TimerHelper")
  TimerHelper.Stop("TrainGloableUpdate")
  TimerHelper.Stop("TrainWheelUpdate")
  LoginGV.SetIsLogin(false)
  LoginGV.SetIsEnterGame(false)
  PlayerData:Logout()
end

function LogoutHelper.LogoutFromLogin()
end

function LogoutHelper.LogoutBySever()
  if SdkHelper.IsChannelUjoy() then
    LogoutHelper.LogoutFromGaming()
    return
  end
  CBus:NewLogout()
end

return LogoutHelper
