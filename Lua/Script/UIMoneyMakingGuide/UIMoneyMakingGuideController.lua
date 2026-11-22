local View = require("UIMoneyMakingGuide/UIMoneyMakingGuideView")
local DataModel = require("UIMoneyMakingGuide/UIMoneyMakingGuideDataModel")
local MapDataModel = require("UICityMap/UICityMapDataModel")
local MapController = require("UICityMap/UICityMapController")
local Controller = {}

function Controller:Init()
  local homeCommon = require("Common/HomeCommon")
  local station_info = PlayerData:GetHomeInfo().station_info
  DataModel.stationId = nil
  DataModel.bubbleId = nil
  local hasTrade = false
  local inCity = false
  if station_info.status == -1 then
    inCity = true
    local cityMapId = homeCommon.GetCityStateInfo(station_info.sid).cityMapId
    local bubbleList = PlayerData:GetFactoryData(cityMapId).bubbleList
    for i = 1, #bubbleList do
      local bubbleCA = PlayerData:GetFactoryData(bubbleList[i].id)
      if bubbleCA.btnType == "HomeTrade" then
        hasTrade = true
        DataModel.stationId = station_info.sid
        DataModel.bubbleId = bubbleList[i].id
      end
    end
  end
  local hasActivity = false
  local activityTimeList = PlayerData:GetFactoryData(99900059).activityTimeList
  local activityMainList = PlayerData:GetFactoryData(99900059).activityMainList
  local activityPlotList = PlayerData:GetFactoryData(99900059).activityPlotList
  local activityOperateList = PlayerData:GetFactoryData(99900059).activityOperateList
  for k, v in ipairs(activityTimeList) do
    if tonumber(v.id) == 86000044 then
      hasActivity = true
    end
  end
  for k, v in ipairs(activityMainList) do
    if tonumber(v.id) == 86000044 then
      hasActivity = true
    end
  end
  for k, v in ipairs(activityPlotList) do
    if tonumber(v.id) == 86000044 then
      hasActivity = true
    end
  end
  for k, v in ipairs(activityOperateList) do
    if tonumber(v.id) == 86000044 then
      hasActivity = true
    end
  end
  View.Group_Panel.Group_Panel01_Level:SetActive(hasActivity)
  if hasActivity then
    View.Group_Panel.Group_Panel01_Level.Group_MainPic.Img_MainPic:SetSprite(GetResPath(88300306))
  end
  View.Group_Panel.Group_Panel02_Trade:SetActive(hasTrade)
  View.Group_Panel.Group_Panel04_Note:SetActive(not hasTrade)
  View.Group_TopBar.Group_Station:SetActive(inCity)
  View.Group_TopBar.Txt_GuideName:SetActive(not inCity)
  if inCity then
    local stationCa = PlayerData:GetFactoryData(station_info.sid)
    View.Group_TopBar.Group_Station.Txt_StationName:SetText(stationCa.name)
  end
end

function Controller:OpenActivity()
  UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000044}))
end

function Controller:ClickHomeTrade()
  MapDataModel.stationId = DataModel.stationId
  MapController:ClickBtn(nil, {
    bubbleId = DataModel.bubbleId
  })
end

function Controller:OpenShop()
  Net:SendProto("shop.info", function(json)
    json.shopId = 80300323
    UIManager:Open("UI/Store/Store", Json.encode(json))
  end)
end

function Controller:OpenNote()
  CommonTips.OpenNoteBook(1)
end

return Controller
