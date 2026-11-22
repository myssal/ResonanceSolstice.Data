local View = require("UIOverview/UIOverviewView")
local DataModel = require("UIOverview/UIOverviewDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  Controller:SelectPanel(DataModel.panelType.Expel, true)
end

function Controller:SelectPanel(type, force)
  if type == DataModel.curSelectType and not force then
    return
  end
  DataModel.curSelectType = type
  local isExpel = type == DataModel.panelType.Expel
  View.Group_Btn.Group_Expel.Group_Off.self:SetActive(not isExpel)
  View.Group_Btn.Group_Expel.Group_On.self:SetActive(isExpel)
  View.Group_Btn.Group_Battle.Group_Off.self:SetActive(isExpel)
  View.Group_Btn.Group_Battle.Group_On.self:SetActive(not isExpel)
  Controller:ShowExpel(isExpel)
  Controller:ShowBattle(not isExpel)
end

function Controller:ShowExpel(isShow)
  View.Group_Expel.self:SetActive(isShow)
  if isShow then
    DataModel.InitBuildingInfo()
    View.Group_Expel.Txt_Num:SetText(string.format(GetText(80607967), DataModel.totalExpelPercent))
    View.Group_Expel.ScrollGrid_List.grid.self:SetDataCount(#DataModel.showExpelInfo)
    View.Group_Expel.ScrollGrid_List.grid.self:MoveToTop()
    View.Group_Expel.ScrollGrid_List.grid.self:RefreshAllElement()
  else
    for i, v in ipairs(View.Group_Expel.ScrollGrid_List.grid) do
      if v.Group_List then
        v.Group_List.self:SetAlpha(0)
      end
    end
  end
end

function Controller:ShowBattle(isShow)
  View.Group_Battle.self:SetActive(isShow)
  if isShow then
    DataModel.InitBattleCenterInfo()
    View.Group_Battle.Txt_Num:SetText(string.format(GetText(80608933), DataModel.totalBattlePercent))
    View.Group_Battle.ScrollGrid_List.grid.self:SetDataCount(#DataModel.showBattleInfo)
    View.Group_Battle.ScrollGrid_List.grid.self:MoveToTop()
    View.Group_Battle.ScrollGrid_List.grid.self:RefreshAllElement()
  else
    for i, v in ipairs(View.Group_Battle.ScrollGrid_List.grid) do
      if v.Group_List then
        v.Group_List.self:SetAlpha(0)
      end
    end
  end
end

function Controller:RefreshExpelElement(element, elementIndex)
  local info = DataModel.showExpelInfo[elementIndex]
  element.Group_List.Img_Icon:SetSprite(info.cityMapIconPath)
  element.Group_List.Txt_Name:SetText(info.name)
  element.Group_List.Txt_Schedule:SetText(string.format(GetText(80602089), math.floor(info.curExpel / info.maxExpel * 100 + 0.5)))
  element.Group_List.Group_Schedule.Img_Schedule:SetFilledImgAmount(info.curExpel / info.maxExpel)
  element.Group_List.Txt_Tips:SetActive(info.isEntrustQueue)
  element.Group_List.StaticGrid_List.grid.self:SetParentParam(elementIndex)
  element.Group_List.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller:RefreshPondElement(element, elementIndex)
  local info = DataModel.showExpelInfo[tonumber(element.ParentParam)]
  local pondInfo = info.ponds[elementIndex]
  element:SetActive(pondInfo ~= nil)
  if pondInfo then
    element.Txt_Name:SetText(pondInfo.seriesName)
    element.Txt_Schedule:SetText(string.format(GetText(80607972), math.floor(pondInfo.curExpel / pondInfo.maxExpel * 100 + 0.5)))
    element.Group_Schedule.Img_Schedule:SetFilledImgAmount(pondInfo.curExpel / pondInfo.maxExpel)
  end
end

function Controller:RefreshBattleCenterElement(element, elementIndex)
  local info = DataModel.showBattleInfo[elementIndex]
  element.Group_List.Img_Icon:SetSprite(info.cityMapIconPath)
  element.Group_List.Txt_Name:SetText(info.name)
  element.Group_List.Txt_BattleName:SetText(info.battleLevelName)
  element.Group_List.Txt_Schedule:SetText(string.format(GetText(80600778), info.curPcnt, info.maxPcnt))
  element.Group_List.Group_Schedule.Img_Schedule:SetFilledImgAmount(info.curPcnt / info.maxPcnt)
end

function Controller:Close()
  UIManager:GoBack(false)
end

return Controller
