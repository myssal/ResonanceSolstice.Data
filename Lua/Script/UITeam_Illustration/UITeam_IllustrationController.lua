local DataModel = require("UITeam_Illustration/UITeam_IllustrationDataModel")
local View = require("UITeam_Illustration/UITeam_IllustrationView")
local Controller = {curSelectTabIndex = nil, curSelectBuffIndex = nil}

function Controller.Init()
  Controller.OnTabClick(1)
  Controller.RefreshTabListShow()
end

function Controller.RefreshTabListShow()
  local entryList = DataModel.GetEntryList()
  if not entryList or #entryList == 0 then
    return
  end
  View.ScrollGrid_Tab.grid.self:SetDataCount(#entryList)
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshTabElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local rogueTeamConfig = DataModel.GetEntryInfoByIndex(elementIndex)
  if not rogueTeamConfig then
    return
  end
  element.Img_TeamIcon:SetSprite(rogueTeamConfig.iconPath)
  element.Txt_TeamName:SetText(rogueTeamConfig.name)
  element.Btn_:SetClickFunction(function()
    Controller.OnTabClick(elementIndex)
  end)
  if Controller.curSelectTabIndex == elementIndex then
    element.Img_TeamIcon:SetLocalScale(Vector3(0.72, 0.72, 0.72))
    element.Group_Active:SetActive(true)
    element.Group_Negative:SetActive(false)
    element.Txt_TeamName:SetColor("#FFFFFF")
    element.Img_TeamIcon:SetColor("#B10707")
  else
    element.Img_TeamIcon:SetLocalScale(Vector3(0.64, 0.64, 0.64))
    element.Group_Active:SetActive(false)
    element.Group_Negative:SetActive(true)
    element.Txt_TeamName:SetColor("#BDBDBD")
    element.Img_TeamIcon:SetColor("#8C8B8B")
  end
end

function Controller.OnTabClick(elementIndex)
  Controller.curSelectTabIndex = elementIndex
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
  Controller.RefreshContentInfo()
end

function Controller.RefreshContentInfo()
  local rogueTeamConfig = DataModel.GetEntryInfoByIndex(Controller.curSelectTabIndex)
  if not rogueTeamConfig then
    return
  end
  View.ScrollView_Info.Viewport.Content.self:SetLocalPositionY(0)
  View.Group_Icon.Img_Icon:SetSprite(rogueTeamConfig.cardBigIcon)
  View.Group_Title.Txt_Name:SetText(DataModel.GetBookName())
  View.ScrollView_Info.Viewport.Content.Group_Title.Txt_TeamName:SetText(rogueTeamConfig.name)
  View.ScrollView_Info.Viewport.Content.Group_Title.Img_TeamIcon:SetSprite(rogueTeamConfig.iconPath)
  View.ScrollView_Info.Viewport.Content.Txt_Des:SetText(rogueTeamConfig.des)
  local extraBuffList = rogueTeamConfig.extraBuffList
  if extraBuffList and 0 < #extraBuffList then
    View.ScrollView_Info.Viewport.Content.StaticGrid_ExtraBuff.grid.self:SetActive(true)
    View.ScrollView_Info.Viewport.Content.StaticGrid_ExtraBuff.grid.self:SetDataCount(5 < #extraBuffList and 5 or #extraBuffList)
    View.ScrollView_Info.Viewport.Content.StaticGrid_ExtraBuff.grid.self:RefreshAllElement()
  else
    View.ScrollView_Info.Viewport.Content.StaticGrid_ExtraBuff.grid.self:SetActive(true)
  end
end

function Controller.RefreshExtraBuffElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local rogueTeamConfig = DataModel.GetEntryInfoByIndex(Controller.curSelectTabIndex)
  if not rogueTeamConfig then
    return
  end
  local extraBuffList = rogueTeamConfig.extraBuffList or {}
  local extraInfo = extraBuffList[elementIndex]
  if not extraInfo then
    return
  end
  local buffConfig = PlayerData:GetFactoryData(extraInfo.id, "RogueBuffFactory")
  if not buffConfig then
    return
  end
  element.Group_Buff.Img_Mask.Img_SkillIcon:SetSprite(buffConfig.iconPath)
  element.Txt_Num:SetText("x" .. tostring(extraInfo.num))
  element.Txt_Des:SetText(tostring(buffConfig.des))
end

function Controller.OnExtraBuffClick(elementIndex)
  Controller.curSelectBuffIndex = elementIndex
  View.Group_Info.Group_Extra.StaticGrid_Icon.grid.self:RefreshAllElement()
  Controller.RefreshBuffSelectContent()
end

function Controller.RefreshBuffSelectContent()
  local rogueTeamConfig = DataModel.GetEntryInfoByIndex(Controller.curSelectTabIndex)
  if not rogueTeamConfig then
    return
  end
  local extraBuffList = rogueTeamConfig.extraBuffList or {}
  local extraInfo = extraBuffList[Controller.curSelectBuffIndex]
  if not extraInfo then
    return
  end
  local buffConfig = PlayerData:GetFactoryData(extraInfo.id, "RogueBuffFactory")
  if not buffConfig then
    return
  end
  View.Group_Info.Group_Extra.Txt_SelectedBuffName:SetText(buffConfig.name)
  View.Group_Info.Group_Extra.Txt_Des:SetText(buffConfig.des)
end

return Controller
