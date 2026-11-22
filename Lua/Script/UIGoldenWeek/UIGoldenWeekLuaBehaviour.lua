local View = require("UIGoldenWeek/UIGoldenWeekView")
local DataModel = require("UIGoldenWeek/UIGoldenWeekDataModel")
local ViewFunction = require("UIGoldenWeek/UIGoldenWeekViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    View.Group_Info.Group_Tv.Group_Back.Img_Title:SetSprite(GetResPath(88300045))
    View.Group_Info.Group_Tv.Group_Content.Img_BG:SetSprite(GetResPath(88300044))
    params = initParams
    local data = Json.decode(initParams)
    DataModel.Init(data.activityId)
    View.Group_Info.Group_Tv.Group_Information.Group_Interview:SetActive(true)
    View.Group_Info.Group_Tv.Group_Information.Group_Guest:SetActive(false)
    View.Group_Info.Group_Tv.Group_Information.Group_Manufacture:SetActive(false)
    View.Group_Info.Group_Tv.Group_Information.Group_Trade:SetActive(false)
    View.Group_Info.Group_Tv.Group_Back.Group_Time.Txt_StartTime:SetText(DataModel.startTime)
    View.Group_Info.Group_Tv.Group_Back.Group_Time.Txt_EndTime:SetText(DataModel.endTime)
    local npcCfg = PlayerData:GetFactoryData(DataModel.npcId)
    View.Group_Info.Group_Tv.Group_NPC.Spine_:SetData(npcCfg.spineUrl)
    View.Group_Info.Group_Tv.Group_NPC.Spine_:SetAnchoredPositionX(npcCfg.spineOffsetX)
    View.Group_Info.Group_Tv.Group_NPC.Spine_:SetAnchoredPositionY(npcCfg.spineOffsetY)
    View.Group_Info.Group_Tv.Group_NPC.Spine_:SetLocalScale(Vector3(1, 1, 1) * npcCfg.spineScale)
    if next(DataModel.nowInterviewNpcInfo) then
      local bgPath = DataModel.nowInterviewNpcInfo[1].bgPng
      View.Group_Info.Group_Tv.Group_Information.Group_Interview.Img_BG:SetSprite(bgPath)
      local interviewNpcCfg = PlayerData:GetFactoryData(DataModel.nowInterviewNpcInfo[1].id)
      local nowSpine = View.Group_Info.Group_Tv.Group_Information.Group_Interview.Group_NPC.Spine_
      nowSpine:SetData(interviewNpcCfg.spineUrl)
      nowSpine:SetAnchoredPositionX(interviewNpcCfg.spineOffsetX)
      nowSpine:SetAnchoredPositionY(interviewNpcCfg.spineOffsetY)
      nowSpine:SetLocalScale(Vector3(1, 1, 1) * interviewNpcCfg.spineScale)
    end
    if next(DataModel.nowTitleInfo) then
      View.Group_Info.Group_Tv.Group_Content.Txt_Content:SetText(GetText(DataModel.nowTitleInfo[1].id))
    end
    if next(DataModel.nowcircleTextInfo) then
      local contentId = DataModel.nowcircleTextInfo[1].id
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
    end
    ViewFunction.ShowPanel(1)
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
