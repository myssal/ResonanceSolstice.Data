local View = require("UIGroup_EventWeek/UIGroup_EventWeekView")
local DataModel = require("UIGroup_EventWeek/UIGroup_EventWeekDataModel")
local ViewFunction = require("UIGroup_EventWeek/UIGroup_EventWeekViewFunction")

local function Callback()
  DataModel.Init()
  View.Group_Info.Group_Tv.Group_Information.Group_Interview:SetActive(true)
  View.Group_Info.Group_Tv.Group_Information.Group_Guest:SetActive(false)
  View.Group_Info.Group_Tv.Group_Information.Group_Manufacture:SetActive(false)
  View.Group_Info.Group_Tv.Group_Information.Group_Trade:SetActive(false)
  View.Group_Info.Group_Tv.Group_Back.Group_Time.Txt_StartTime:SetText(DataModel.startTime)
  View.Group_Info.Group_Tv.Group_Back.Group_Time.Txt_EndTime:SetText(DataModel.endTime)
  View.Group_Info.Group_Tv.Group_NPC:SetActive(true)
  local bgPath = DataModel.nowInterviewBg
  View.Group_Info.Group_Tv.Group_Information.Group_Interview.Img_BG:SetSprite(bgPath)
  View.Group_Info.Group_Tv.Group_Back.Img_Bg:SetSprite(DataModel.tvBgPng)
  local interviewNpcCfg = PlayerData:GetFactoryData(DataModel.nowInterviewNpcId)
  View.Group_Info.Group_Tv.Group_NPC.InterviewSpine:SetData(interviewNpcCfg.spineUrl)
  View.Group_Info.Group_Tv.Group_NPC.InterviewSpine:SetAnchoredPositionX(interviewNpcCfg.spineOffsetX)
  View.Group_Info.Group_Tv.Group_NPC.InterviewSpine:SetAnchoredPositionY(interviewNpcCfg.spineOffsetY)
  View.Group_Info.Group_Tv.Group_NPC.InterviewSpine:SetLocalScale(Vector3(1, 1, 1) * interviewNpcCfg.spineScale)
  View.Group_Info.Group_Tv.Group_Content.Txt_Content:SetText(GetText(DataModel.nowTitle))
  View.Group_Info.Group_Tv.Group_Back.Img_Title.Txt_Title:SetText(GetText(DataModel.eventText))
  local contentId = DataModel.nowcircleText
  local content = GetText(contentId)
  View.Group_Bottom.Img_Mask.Txt_Circle:SetText(content)
  local startposx = View.Group_Bottom.Rect.rect.width
  local txtWidth = View.Group_Bottom.Img_Mask.Txt_Circle:GetWidth()
  View.Group_Bottom.Img_Mask.Txt_Circle:SetAnchoredPositionX((startposx - txtWidth) / 2)
  if startposx < txtWidth then
    local scrollSpeed = 0.2
    scrollSpeed = scrollSpeed * string.getLength(content)
    View.Group_Bottom.Img_Mask.Txt_Circle:SetLocalPositionX(0)
    View.Group_Bottom.Img_Mask.Txt_Circle:SetText(content .. "    " .. content)
    local spaceWidth = math.floor(View.Group_Bottom.Img_Mask.Txt_Circle.Txt.fontSize / 5) + 1
    local spaceNum = 4
    local txtWidth = View.Group_Bottom.Img_Mask.Txt_Circle:GetWidth()
    local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
    DOTweenTools.DOLocalMoveX(View.Group_Bottom.Img_Mask.Txt_Circle.transform, -endposx, scrollSpeed):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
  end
  View.Group_Info.Group_Tv.Group_Tab.Btn_Guest:SetActive(next(DataModel.GetQueatData()))
  View.Group_Info.Group_Tv.Group_Tab.Btn_Manufacture:SetActive(next(DataModel.GetManufactureData()))
  View.Group_Info.Group_Tv.Group_Tab.Btn_Trade:SetActive(next(DataModel.GetTradData()))
  View.Group_Info.Group_Tv.Group_Tab.Btn_Order:SetActive(next(DataModel.GetOrderData()))
  local redStatus = DataModel.GetRedDotStatus()
  View.self:PlayAnimOnce("GoldenWeek_InTwo")
  if redStatus then
    PlayerData:SetPlayerPrefs("int", "RefreshTime", PlayerData.ServerData.server_resident["86000010"].ti)
    require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end
  ViewFunction.Group_EventWeek_Group_Info_Group_Tv_Group_Tab_Btn_Trade_Click()
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Info.Group_Tv.Group_Back.Img_Title:SetSprite(GetResPath(88300046))
    View.Group_Info.Group_Tv.Group_Content.Img_BG:SetSprite(GetResPath(88300044))
    View.Group_Info.Group_Tv.Group_NPC:SetActive(false)
    View.Group_Info.Group_Tv.Group_Information.Group_Interview.Group_NPC:SetActive(false)
    if PlayerData.ServerData.server_resident then
      if TimeUtil:GetServerTimeStamp() >= PlayerData.ServerData.server_resident["86000010"].ti then
        Net:SendProto("quest.list", function(json)
          PlayerData.ServerData.server_resident = json.server_resident
          Callback()
        end, 6)
      else
        Callback()
      end
    else
      Callback()
    end
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
    DOTweenTools.Kill(View.Group_Bottom.Img_Mask.Txt_Circle.transform)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
