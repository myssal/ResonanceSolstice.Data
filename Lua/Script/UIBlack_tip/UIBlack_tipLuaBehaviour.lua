local View = require("UIBlack_tip/UIBlack_tipView")
local DataModel = require("UIBlack_tip/UIBlack_tipDataModel")
local ViewFunction = require("UIBlack_tip/UIBlack_tipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Txt_Des:SetText(GetText(80605476))
    if initParams then
      local text = Json.decode(initParams).text
      if text and text ~= "" then
        View.Txt_Des:SetText(text)
      end
    end
    DataModel.openTime = 0
    local trainName = PlayerData:GetHomeInfo().home_name
    if trainName == nil or trainName == "" then
      trainName = PlayerData:GetFactoryData(99900014).defaultName
    end
    View.Txt_trainName:SetText(string.format(GetText(80601635), trainName))
    local dt = os.date("*t", TimeUtil:GetServerTimeStamp())
    local hour = dt.hour < 10 and "0" .. dt.hour or dt.hour
    local min = 10 > dt.min and "0" .. dt.min or dt.min
    View.Txt_Time:SetText(TimeUtil:GetSvrTimeFormatStr4())
    local name = PlayerData:GetFactoryData(PlayerData:GetHomeInfo().station_info.sid).name
    View.Txt_city:SetText(name)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if LoadingManager.autoCloseLoading == true and LoadingManager.loadingPercent >= 1 then
      LoadingManager:CloseLoading()
    end
  end,
  ondestroy = function()
    PlayerData.TempCache.IsBlackOver = true
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
