local RedPointNodeStr = {}
local Root = {
  CityMap = {
    [1] = "HomeSafe",
    [2] = "RubbishStation",
    [3] = "RestArea",
    GetSuffix = function()
      local station_info = PlayerData:GetHomeInfo().station_info
      if station_info ~= nil then
        local stop_info = station_info.stop_info
        if stop_info ~= nil and stop_info[2] == -1 then
          local curStayId = tonumber(stop_info[1])
          return curStayId
        end
      end
      return ""
    end
  },
  HomeSafe = {
    [1] = "HomeSafeLevel",
    GetSuffix = function()
      local station_info = PlayerData:GetHomeInfo().station_info
      if station_info ~= nil then
        local stop_info = station_info.stop_info
        if stop_info ~= nil and stop_info[2] == -1 then
          local curStayId = tonumber(stop_info[1])
          local homeCommon = require("Common/HomeCommon")
          local cityStateInfo = homeCommon.GetCityStateInfo(curStayId)
          local listCA = PlayerData:GetFactoryData(cityStateInfo.cityMapId, "CityMapFactory")
          for k, v in ipairs(listCA.bubbleList) do
            local ca = PlayerData:GetFactoryData(v.id)
            if ca.btnType == "HomeSafe" then
              return ca.buildingId
            end
          end
        end
      end
      return ""
    end
  },
  RubbishStation = {
    [1] = "RubbishStationLevel",
    GetSuffix = function()
      local station_info = PlayerData:GetHomeInfo().station_info
      if station_info ~= nil then
        local stop_info = station_info.stop_info
        if stop_info ~= nil and stop_info[2] == -1 then
          local curStayId = tonumber(stop_info[1])
          local homeCommon = require("Common/HomeCommon")
          local cityStateInfo = homeCommon.GetCityStateInfo(curStayId)
          local listCA = PlayerData:GetFactoryData(cityStateInfo.cityMapId, "CityMapFactory")
          for k, v in ipairs(listCA.bubbleList) do
            local ca = PlayerData:GetFactoryData(v.id)
            if ca.btnType == "RubbishStation" then
              return ""
            end
          end
        end
      end
      return "1"
    end
  },
  RestArea = {
    [1] = "BarStoreShopCommodity",
    GetSuffix = function()
      local station_info = PlayerData:GetHomeInfo().station_info
      if station_info ~= nil then
        local stop_info = station_info.stop_info
        if stop_info ~= nil and stop_info[2] == -1 then
          local curStayId = tonumber(stop_info[1])
          local homeCommon = require("Common/HomeCommon")
          local cityStateInfo = homeCommon.GetCityStateInfo(curStayId)
          local listCA = PlayerData:GetFactoryData(cityStateInfo.cityMapId, "CityMapFactory")
          for k, v in ipairs(listCA.bubbleList) do
            local ca = PlayerData:GetFactoryData(v.id)
            if ca.btnType == "RestArea" then
              return ""
            end
          end
        end
      end
      return 1
    end
  }
}
local InnerRedPointNodeStr = {
  HomeSafeLevel = "Root|HomeSafeLevel",
  RubbishStationLevel = "Root|RubbishStationLevel",
  BarStoreShopCommodity = "Root|BarStoreShopCommodity"
}

function RedPointNodeStr.IsHaveRed(nodeName, suffix)
  local t = Root[nodeName]
  if t ~= nil then
    if t.GetSuffix ~= nil then
      suffix = t.GetSuffix() or ""
    end
    if 0 < #t then
      for k, v in ipairs(t) do
        if RedPointNodeStr.IsHaveRed(v, suffix) then
          return true
        end
      end
      return false
    end
  end
  local childNodeStr = InnerRedPointNodeStr[nodeName]
  if childNodeStr then
    if suffix == nil then
      suffix = ""
    elseif type(suffix) == "table" then
      for i, v in ipairs(suffix) do
        if 0 < RedpointTree:GetRedpointCnt(childNodeStr .. v) then
          return true
        end
      end
      return false
    end
    return 0 < RedpointTree:GetRedpointCnt(childNodeStr .. suffix)
  else
    return 0 < RedpointTree:GetRedpointCnt(nodeName)
  end
end

RedPointNodeStr.RedPointNodeStr = InnerRedPointNodeStr
return RedPointNodeStr
