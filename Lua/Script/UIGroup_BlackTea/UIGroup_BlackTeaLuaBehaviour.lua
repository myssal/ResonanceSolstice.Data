local View = require("UIGroup_BlackTea/UIGroup_BlackTeaView")
local DataModel = require("UIGroup_BlackTea/UIGroup_BlackTeaDataModel")
local ViewFunction = require("UIGroup_BlackTea/UIGroup_BlackTeaViewFunction")
local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.initParams = params
    local id = params.activityId
    local activityCA = PlayerData:GetFactoryData(id)
    DataModel.activityCA = activityCA
    local Group_Residue = View.Group_Residue
    local remainingTime = 0
    local timeList = ActivityMainDataModel.IsActiveNewTimeOpen(id)
    remainingTime = timeList.startTime - TimeUtil:GetServerTimeStamp()
    local lastTime = TimeUtil:SecondToTable(remainingTime)
    if 0 < lastTime.day then
      Group_Residue.Group_Time.Txt_Time:SetText(string.format(GetText(80609204), lastTime.day))
    elseif 0 < lastTime.hour then
      Group_Residue.Group_Time.Txt_Time:SetText(string.format(GetText(80609205), lastTime.hour))
    else
      Group_Residue.Group_Time.Txt_Time:SetText(string.format(GetText(80609205), 1))
    end
    DataModel.NotJoinReward = {}
    for k, v in pairs(activityCA.rewardPreviewList) do
      table.insert(DataModel.NotJoinReward, v)
    end
    Group_Residue.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.NotJoinReward))
    Group_Residue.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
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
