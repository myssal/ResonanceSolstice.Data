local View = require("UIActivitySignIn/UIActivitySignInView")
local DataModel = require("UIActivitySignIn/UIActivitySignInDataModel")
local MainController = require("UIActivityMain/UIActivityMainController")
local Controller = {}

function Controller:Init()
  local sign = PlayerData:GetSignInfo()[tostring(DataModel.SignInConfig.id)]
  if sign == nil then
    return
  end
  View.Group_EventSignIn.Img_Day:SetSprite(GetResPath(DataModel.activityCA.signTitlePathId))
  View.Group_EventSignIn.Img_Reward:SetSprite(GetResPath(DataModel.activityCA.signDesPathId))
  local signCount = table.count(DataModel.SignInConfig.SigninRewardList)
  View.Group_EventSignIn.ScrollGrid_Board.grid.self:SetDataCount(signCount)
  View.Group_EventSignIn.ScrollGrid_Board.grid.self:RefreshAllElement()
  local isOffest = false
  if sign.count >= signCount - 2 then
    View.Group_EventSignIn.ScrollGrid_Board.grid.self:MoveToPos(signCount - 2)
  else
    View.Group_EventSignIn.ScrollGrid_Board.grid.self:MoveToPos(sign.count + 1)
    isOffest = true
  end
  if isOffest then
    local anchoredPositionX = View.Group_EventSignIn.ScrollGrid_Board.grid.self.RectTransform.anchoredPosition.x
    local anchoredPositionY = View.Group_EventSignIn.ScrollGrid_Board.grid.self.RectTransform.anchoredPosition.y
    local result = (sign.count - 1) / 5
    local diffPoint = 0.9 - 0.016 * (sign.count - 1)
    diffPoint = diffPoint < 0 and 0.85 or diffPoint
    local offset = 10 + math.ceil(result) * diffPoint
    anchoredPositionX = anchoredPositionX + offset * (sign.count - 1)
    View.Group_EventSignIn.ScrollGrid_Board.grid.self.RectTransform.anchoredPosition = Vector2(anchoredPositionX, anchoredPositionY)
    View.Group_EventSignIn.ScrollGrid_Board.grid.self:HandleScrollEvent(Vector2(0, 0))
  end
  View.Img_BG:SetSprite(DataModel.activityCA.bgPath)
  View.Group_EventSignIn.Group_Decorate.Group_Time.self:SetActive(false)
  if DataModel.activityCA.isTime == true then
    View.Group_EventSignIn.Group_Decorate.Group_Time.self:SetActive(true)
    local timeStart = TimeUtil:GetTimeTable(DataModel.SignInConfig.startTime)
    local timeEnd = TimeUtil:GetTimeTable(DataModel.SignInConfig.endTime)
    local a_1 = timeStart.year .. "/" .. timeStart.month .. "/" .. timeStart.day
    local b_1 = timeStart.hour .. ":" .. timeStart.minute
    local a_2 = timeEnd.year .. "/" .. timeEnd.month .. "/" .. timeEnd.day
    local b_2 = timeEnd.hour .. ":" .. timeEnd.minute
    local str = string.format(GetText(80602405), a_1, b_1, a_2, b_2)
    View.Group_EventSignIn.Group_Decorate.Group_Time.Txt_EndTime:SetText(str)
  end
end

function Controller:SignInSetElement(element, elementIndex)
  local Group_Item = element.Group_Item
  Group_Item.Img_Mark:SetActive(false)
  Group_Item.BtnPolygon_BG:SetClickParam(elementIndex)
  Group_Item.Img_Oh:SetActive(false)
  local sign = PlayerData:GetSignInfo()[tostring(DataModel.SignInConfig.id)]
  if tonumber(elementIndex) <= sign.count then
    Group_Item.Img_Mark:SetActive(true)
  else
    Group_Item.Img_Mark:SetActive(false)
  end
  if tonumber(elementIndex) == sign.count + 1 and sign.status == 0 then
    Group_Item.Img_Oh:SetActive(true)
  end
  local reward_t = DataModel.SignInConfig.SigninRewardList[tonumber(elementIndex)]
  local pngQuality = reward_t.pngQuality
  local nameQuality = reward_t.nameQuality
  local name = reward_t.name
  local color = reward_t.color
  local rewardId = reward_t.id
  local awardList = PlayerData:GetFactoryData(rewardId).awardList
  Group_Item.Txt_Num:SetText("")
  Group_Item.Group_Name.Img_Name.Txt_Name:SetText("")
  if -1 < name then
    Group_Item.Group_Name.Img_Name.Txt_Name:SetText(GetText(name))
  end
  if awardList and awardList[1] then
    local itemId = awardList[1].id
    local reward = PlayerData:GetFactoryData(itemId)
    local num = awardList[1].num
    Group_Item.Txt_Num:SetText(num)
    if name == -1 then
      Group_Item.Group_Name.Img_Name.Txt_Name:SetText(reward.name)
    end
  end
  Group_Item.Img_Frame:SetActive(pngQuality ~= "")
  if pngQuality ~= "" then
    Group_Item.Img_Frame.Txt_Des:SetText(GetText(nameQuality))
    Group_Item.Img_Frame.Txt_Des:SetColor("#" .. color)
    Group_Item.Img_Frame:SetSprite(pngQuality)
  end
  if PlayerData:GetUserInfo().gender == 1 then
    Group_Item.Img_Icon:SetSprite(reward_t.pngMan)
  else
    Group_Item.Img_Icon:SetSprite(reward_t.pngWoman)
  end
end

function Controller:SignInClickElement(str)
  local index = str
  local sign = PlayerData:GetSignInfo()[tostring(DataModel.SignInConfig.id)]
  local id = DataModel.SignInConfig.id
  if sign then
    if sign.status == 1 then
      if index <= sign.count then
        CommonTips.OpenTips(80600191)
        return
      else
        CommonTips.OpenTips(80600194)
        return
      end
    elseif index == sign.count + 1 then
      if sign.status == 1 then
        CommonTips.OpenTips(80600191)
        return
      end
      Net:SendProto("main.sign_in", function(json)
        SdkReporter.TrackSignReward({
          id = id,
          day = sign.count + 1
        })
        if json.reward.role then
          for k, v in pairs(json.reward.role) do
            local ca = PlayerData:GetFactoryData(k)
            local hero_list = {}
            hero_list.hero_id = ca.id
            hero_list.hero_name = ca.name
            hero_list.event_seq = "main.sign_in"
            hero_list.get_times = PlayerData:GetSeverTime()
            ReportTrackEvent.hero_get(hero_list)
          end
        end
        View.Group_EventSignIn.ScrollGrid_Board.grid.self:RefreshAllElement()
        CommonTips.OpenShowItem(json.reward)
        PlayerData.ServerData.sign_info = json.user_info.sign_info
        MainController:RefreshLeftRedState()
      end, DataModel.activityCA.id)
    elseif index < sign.count + 1 then
      CommonTips.OpenTips(80600191)
      return
    else
      CommonTips.OpenTips(80600194)
      return
    end
  end
end

return Controller
