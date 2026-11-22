local View = require("UIDictionary/UIDictionaryView")
local DataModel = require("UIDictionary/UIDictionaryDataModel")

local function ShowCostImg(costNum, Img_Cost1, Img_Cost2)
  local tWidth = 0
  local cost = costNum
  if 99 < cost then
    cost = 99
  end
  if cost < 0 then
    cost = 0
  end
  local cost1 = math.floor(cost / 10)
  local cost2 = math.floor(cost % 10)
  local numTextCA = DataModel:GetcostImgConfig(cost2)
  tWidth = numTextCA.width
  Img_Cost2:SetSprite(numTextCA.resStr)
  if cost1 < 1 then
    Img_Cost2:SetLocalPositionX(0)
    Img_Cost1:SetActive(false)
  else
    Img_Cost1:SetActive(true)
    numTextCA = DataModel:GetcostImgConfig(cost1)
    tWidth = tWidth + numTextCA.width + DataModel.numCA.interval
    Img_Cost1:SetSprite(numTextCA.resStr)
    Img_Cost1:SetLocalPositionX(numTextCA.width / 2 - tWidth / 2)
    Img_Cost2:SetLocalPositionX(tWidth / 2 - numTextCA.width / 2)
  end
end

local function ReshCardItem(item, id)
  local skillId = DataModel.skillList[id].Skill
  local skillConfig = PlayerData:GetFactoryData(skillId)
  local iconPath = skillConfig.iconPath
  local cardConfig = PlayerData:GetFactoryData(skillConfig.cardID)
  local costNum = math.floor(cardConfig.cost_SN)
  local skillImg = item.Btn_Card.Group_SkillIcon.Img_MaskSkill.Img_Skill
  skillImg:SetSprite(iconPath)
  item.Btn_Card.Img_BG02.Group_Cost.CardCost:SetNum(costNum)
end

local lastItem, nowItem

local function ReshCardInfo(id)
  local skillConfig = PlayerData:GetFactoryData(DataModel.skillList[id].Skill)
  local skillName = skillConfig.name
  local skillDes = skillConfig.description
  local cardConfig = PlayerData:GetFactoryData(skillConfig.cardID)
  local costNum = math.floor(cardConfig.cost_SN)
  local iconPath = skillConfig.iconPath
  View.Group_Card.Group_Selected.Img_Icon:SetSprite(iconPath)
  View.Group_Card.Group_Selected.Img_CardNameBg.Txt_CardName:SetText(skillName)
  View.Group_Card.Group_Selected.Txt_CardCost:SetText(string.format("COST  <size=40>%d</size>", costNum))
  View.Group_Card.Group_Selected.Group_Item:SetActive(true)
  DataModel:GetSkillTagList(skillConfig.cardID)
  local txt = View.Group_Card.Group_Selected.Group_Item.Txt_CardDesc
  txt:SetText(skillDes)
  local desHeight = txt:GetHeight()
  txt = View.Group_Card.Group_Selected.Group_Item.Group_Tag.Txt_TagDesc
  DataModel.desAndTaglist = {
    [1] = {
      id = 1,
      info = skillDes,
      pos = 0
    }
  }
  DataModel.GetDesAndSkillTagList(desHeight, txt)
  View.Group_Card.Group_Selected.Group_Item:SetActive(false)
  View.Group_Card.Group_Selected.CustomScrollGrid_Desc.self:UpdateGridWidthOrHeight(DataModel.height)
  View.myCustomSV:RefreshData(DataModel.desAndTaglist, View.Group_Card.Group_Selected.CustomScrollGrid_Desc.self.viewportCount)
  View.Group_Card.Group_Selected.CustomScrollGrid_Desc.self.scrollRect.verticalNormalizedPosition = 1
  View.myCustomSV:RefreshAllElement()
  DataModel.selectId = id
end

local function SwitchTopTab(tabType)
  if tabType ~= DataModel.lastTopTab then
    DataModel.tabList[DataModel.lastTopTab].panel:SetActive(false)
    DataModel.tabList[DataModel.lastTopTab].selectImg:SetActive(false)
    DataModel.tabList[tabType].panel:SetActive(true)
    DataModel.tabList[tabType].selectImg:SetActive(true)
    DataModel.lastTopTab = tabType
  end
  if tabType == 2 then
    View.Group_Tab.Btn_Card:SetLocalPositionY(-80, 0)
  else
    View.Group_Tab.Btn_Card:SetLocalPositionY(140, 0)
  end
end

local function SwitchAffixTab(tabType)
  if tabType and tabType ~= DataModel.lastAffixTab then
    DataModel.affixTabList[tabType].Img_On:SetActive(true)
    DataModel.affixTabList[DataModel.lastAffixTab].Img_On:SetActive(false)
    DataModel.lastAffixTab = tabType
    View.Group_Tag.ScrollGrid_.grid.self:SetDataCount(#DataModel.affixList[tabType])
    View.Group_Tag.ScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Tag.ScrollGrid_.grid.self.ScrollRect.verticalNormalizedPosition = 1
  elseif tabType == nil then
    DataModel.lastAffixTab = 1
    View.Group_Tag.ScrollGrid_.grid.self:SetDataCount(#DataModel.affixList[1])
    View.Group_Tag.ScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Tag.ScrollGrid_.grid.self.ScrollRect.verticalNormalizedPosition = 1
    DataModel.affixTabList[1].Img_On:SetActive(true)
    DataModel.affixTabList[2].Img_On:SetActive(false)
    DataModel.affixTabList[3].Img_On:SetActive(false)
  end
end

local function RefreshPanel()
  if nowItem and DataModel.selectId ~= 1 then
    nowItem.gameObject:SetActive(false)
  end
  ReshCardInfo(1)
  DataModel.tabList[1].panel:SetActive(true)
  DataModel.tabList[1].selectImg:SetActive(true)
  if DataModel.lastTopTab ~= 1 then
    DataModel.tabList[DataModel.lastTopTab].panel:SetActive(false)
    DataModel.tabList[DataModel.lastTopTab].selectImg:SetActive(false)
  end
  DataModel.lastTopTab = 1
  View.Group_Card.ScrollGrid_CardSelection.grid.self.ScrollRect.verticalNormalizedPosition = 1
end

local ViewFunction = {
  Dictionary_Group_Mechanism_ScrollGrid__SetGrid = function(element, elementIndex)
  end,
  Dictionary_Group_Card_ScrollGrid_CardSelection_SetGrid = function(element, elementIndex)
    element.Btn_Card:SetClickParam(elementIndex)
    ReshCardItem(element, elementIndex)
    if elementIndex == DataModel.selectId then
      element.Btn_Card.Img_HighLight:SetActive(true)
      lastItem = element.Btn_Card.Img_HighLight.transform
    else
      element.Btn_Card.Img_HighLight:SetActive(false)
    end
  end,
  Dictionary_Group_Tab_Btn_Card_Click = function(btn, str)
    if DataModel.lastTopTab ~= 1 then
      SwitchTopTab(1)
      DataModel.lastAffixTab = nil
      RefreshPanel()
      View.Group_Card.ScrollGrid_CardSelection.grid.self:SetDataCount(#DataModel.skillList)
      View.Group_Card.ScrollGrid_CardSelection.grid.self:RefreshAllElement()
    end
  end,
  Dictionary_Group_Tab_Btn_Tag_Click = function(btn, str)
    if DataModel.lastTopTab ~= 2 then
      SwitchTopTab(2)
      SwitchAffixTab(DataModel.lastAffixTab)
    end
  end,
  Dictionary_Group_Tab_Btn_Mechanism_Click = function(btn, str)
    if DataModel.lastTopTab ~= 3 then
      SwitchTopTab(3)
      DataModel.lastAffixTab = nil
      View.Group_Mechanism.ScrollView_:SetVerticalNormalizedPosition(1)
    end
  end,
  Dictionary_Group_Card_ScrollGrid_CardSelection_Group_Item_Btn_Card_Click = function(btn, str)
    local id = tonumber(str)
    if lastItem and id ~= DataModel.selectId then
      nowItem = btn.transform:Find("Img_HighLight")
      nowItem.gameObject:SetActive(true)
      lastItem.gameObject:SetActive(false)
      ReshCardInfo(id)
      lastItem = nowItem
    end
  end,
  Dictionary_Group_Tag_Btn_Tech_Click = function(btn, str)
    SwitchAffixTab(1)
  end,
  Dictionary_Group_Tag_Btn_Control_Click = function(btn, str)
    SwitchAffixTab(2)
  end,
  Dictionary_Group_Tag_Btn_Defence_Click = function(btn, str)
    SwitchAffixTab(3)
  end,
  Dictionary_Group_Tag_ScrollGrid__SetGrid = function(element, elementIndex)
    local id = DataModel.affixList[DataModel.lastAffixTab][elementIndex].id
    local tagConfig = PlayerData:GetFactoryData(id)
    element.Img_:SetSprite(tagConfig.icon)
    element.Txt_TagName:SetText(tagConfig.tagName)
    element.Txt_TagDesc:SetText(tagConfig.detail)
  end,
  Dictionary_Img_BG_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    DataModel.lastAffixTab = nil
    nowItem = nil
    UIManager:GoBack(false)
  end,
  Dictionary_Img_BG_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    DataModel.lastAffixTab = nil
    nowItem = nil
    UIManager:GoHome()
  end,
  Dictionary_Img_BG_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Dictionary_Group_Card_Group_Selected_CustomScrollGrid_Desc_SetGrid = function(element, elementIndex)
    View.myCustomSV:SetItemShowAndHide(View.Group_Card.Group_Selected.CustomScrollGrid_Desc.self.currentPosXOrY)
  end,
  SwitchTopTab = SwitchTopTab
}
return ViewFunction
