local View = require("UITrailerPrompt/UITrailerPromptView")
local DataModel = require("UITrailerPrompt/UITrailerPromptDataModel")
local ViewFunction = require("UITrailerPrompt/UITrailerPromptViewFunction")
local Luabehaviour = {
  serialize = function()
    return DataModel.distance
  end,
  deserialize = function(initParams)
    DataModel.type = "gold"
    local distance = tonumber(initParams)
    DataModel.distance = distance
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    local trailerList = trailerConfig.trailerList
    local trailer = trailerList[trailerLv + 1]
    local maxNum = trailerConfig.trailerMax + trailer.trailerExtra
    local currNum = PlayerData:GetHomeInfo().req_back_num
    local currRemainNum = maxNum - currNum
    local currTime = TimeUtil:GetServerTimeStamp()
    local maxMonthNum = 0
    local monthSpeed = 0
    if next(PlayerData.ServerData.monthly_card) ~= nil then
      for i, v in pairs(PlayerData.ServerData.monthly_card) do
        local deadline = v.deadline
        if currTime < deadline then
          maxMonthNum = PlayerData:GetFactoryData(99900060, "ConfigFactory").trailerMonthCardMax
          monthSpeed = PlayerData:GetFactoryData(99900060, "ConfigFactory").trailerMonthCardSpeed
        end
      end
    end
    local currMonthNum = PlayerData:GetHomeInfo().monthly_req_back_num
    local activityData = PlayerData:GetActivityData(86000069)
    if activityData and activityData.rec_today and TimeUtil:GetServerTimeStamp() <= activityData.rec_today then
      maxMonthNum = maxMonthNum + PlayerData:GetFactoryData(99900060, "ConfigFactory").trailerMonthCardMax
      monthSpeed = monthSpeed + PlayerData:GetFactoryData(99900060, "ConfigFactory").trailerMonthCardSpeed
      currMonthNum = currMonthNum + (PlayerData:GetHomeInfo().activity_monthly_req_back_num or 0)
    end
    local currMonthRemainNum = maxMonthNum - currMonthNum
    local freeNum = PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.AddTrailerFreeNum)
    local useFreeNum = PlayerData:GetHomeInfo().use_free_num or 0
    local freeRemainNum = freeNum - useFreeNum
    local currAllRemainNum = currRemainNum + currMonthRemainNum + freeRemainNum
    local hasReturnBuff = false
    local returnBuffNum = 0
    if PlayerData.ServerData.return_info and PlayerData.ServerData.return_info.ret_ts ~= 0 and PlayerData.ServerData.return_info.ret_buff and PlayerData.ServerData.return_info.ret_buff.train and PlayerData.ServerData.return_info.ret_buff.train["84100163"] then
      local data = PlayerData.ServerData.return_info.ret_buff.train["84100163"]
      if data.act == 1 and 0 < data.param then
        hasReturnBuff = true
        returnBuffNum = data.param
      end
    end
    if hasReturnBuff then
      currAllRemainNum = currAllRemainNum + returnBuffNum
    end
    local color1 = "#FFB800"
    local color2 = "#969696"
    if 10 <= currAllRemainNum then
      local a = currAllRemainNum % 10
      local b = math.floor(currAllRemainNum / 10)
      View.Group_Times.Txt_Des:SetColor(color1)
      View.Group_Times.Txt_Times:SetColor(color1)
      View.Group_Times.Txt_Des:SetText(b)
      View.Group_Times.Txt_Times:SetText(a)
      View.Btn_Confirm.self:SetActive(true)
      View.Btn_UseItem.self:SetActive(false)
    elseif currAllRemainNum <= 0 then
      View.Group_Times.Txt_Des:SetColor(color2)
      View.Group_Times.Txt_Times:SetColor(color2)
      View.Group_Times.Txt_Des:SetText(0)
      View.Group_Times.Txt_Times:SetText(0)
      View.Btn_Confirm.self:SetActive(false)
      View.Btn_UseItem.self:SetActive(true)
    else
      View.Group_Times.Txt_Des:SetColor(color2)
      View.Group_Times.Txt_Times:SetColor(color1)
      View.Group_Times.Txt_Des:SetText(0)
      View.Group_Times.Txt_Times:SetText(currAllRemainNum)
      View.Btn_Confirm.self:SetActive(true)
      View.Btn_UseItem.self:SetActive(false)
    end
    local unit
    if 0 < currMonthRemainNum then
      local trailerMonthCardCost = trailerConfig.trailerMonthCardCost
      local currIndex = currMonthNum + 1
      if currIndex < 1 or currIndex > #trailerMonthCardCost then
        currIndex = currIndex % #trailerMonthCardCost
        if currIndex == 0 then
          currIndex = #trailerMonthCardCost
        end
      end
      unit = trailerMonthCardCost[currIndex]
    elseif hasReturnBuff then
      local trailerReturnCost = trailerConfig.trailerReturnBuffCost
      unit = trailerReturnCost[returnBuffNum]
    else
      local startTime = trailerConfig.trailerStartTime
      local endTime = trailerConfig.trailerEndTime
      local trailerCost = trailerConfig.trailerCost
      if TimeUtil:TimeIsActive(startTime, endTime) == true then
        trailerCost = trailerConfig.trailerFreeCost
        View.Group_Free.Txt_Title:SetText(string.format(GetText(80606914)))
      end
      local currIndex = currNum + 1
      if currIndex < 1 or currIndex > #trailerCost then
        currIndex = #trailerCost
      end
      if 0 < freeRemainNum then
        currIndex = 1
      end
      unit = trailerCost[currIndex]
    end
    DataModel.unit = unit
    if unit ~= nil then
      local gold = math.floor(distance / unit.dis * unit.price + 0.5)
      View.Group_Check.Btn_Gold.Group_On.Txt_Gold:SetText(gold)
      View.Group_Check.Btn_Gold.Group_Off.Txt_Gold:SetText(gold)
      local mileage = math.floor(distance / unit.dis * unit.mileage + 0.5)
      View.Group_Check.Btn_Mileage.Group_On.Txt_Mileage:SetText(mileage)
      View.Group_Check.Btn_Mileage.Group_Off.Txt_Mileage:SetText(mileage)
      if DataModel.type == "gold" then
        DataModel.mileage = 0
        View.Group_Price.Txt_Price:SetText(unit.price)
        View.Group_Free.self:SetActive(gold == 0)
        View.Group_Check.Btn_Mileage.Group_On.self:SetActive(false)
        View.Group_Check.Btn_Mileage.Group_Off.self:SetActive(true)
        View.Group_Check.Btn_Gold.Group_On.self:SetActive(true)
        View.Group_Check.Btn_Gold.Group_Off.self:SetActive(false)
      else
        DataModel.mileage = mileage
        View.Group_Price.Txt_Price:SetText(unit.mileage)
        View.Group_Free.self:SetActive(mileage == 0)
        View.Group_Check.Btn_Mileage.Group_On.self:SetActive(true)
        View.Group_Check.Btn_Mileage.Group_Off.self:SetActive(false)
        View.Group_Check.Btn_Gold.Group_On.self:SetActive(false)
        View.Group_Check.Btn_Gold.Group_Off.self:SetActive(true)
      end
    else
      CommonTips.OpenTips(80602289)
    end
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    local trailerList = trailerConfig.trailerList
    local trailer = trailerList[trailerLv + 1]
    local finalSpeed = math.floor((trailer.speedMax + monthSpeed) * (1 + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.AddTrailerSpeed)) + 0.5)
    View.Group_speedAdd.Txt_Speed:SetText(tostring(finalSpeed) .. " KM/H")
  end,
  awake = function()
  end,
  start = function()
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
