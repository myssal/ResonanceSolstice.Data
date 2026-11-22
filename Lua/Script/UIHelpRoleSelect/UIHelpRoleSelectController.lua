local View = require("UIHelpRoleSelect/UIHelpRoleSelectView")
local DataModel = require("UIHelpRoleSelect/UIHelpRoleSelectDataModel")
local Controller = {}

function Controller:Init()
  DataModel:RefreshRoleList()
  DataModel:SortAllRoles("Level")
  DataModel.sortType.Level = true
  DataModel.sortType.Rarity = true
  DataModel.sortType.Time = true
  View.Common_Filter.Group_TabBtn.Btn_Level.Img_bg.Img_Arrow:SetRotate(180)
  View.Common_Filter.Group_TabBtn.Btn_Rarity.Img_bg.Img_Arrow:SetRotate(180)
  View.Common_Filter.Group_TabBtn.Btn_Time.Img_bg.Img_Arrow:SetRotate(180)
  View.Common_Filter.Group_TabBtn.Btn_Level.Img_bg:SetSprite("UI/Common/left_on")
  View.Common_Filter.Group_TabBtn.Btn_Rarity.Img_bg:SetSprite("UI/Common/left_off")
  View.Common_Filter.Group_TabBtn.Btn_Time.Img_bg:SetSprite("UI/Common/left_off")
  View.ScrollGrid_CharacterList.grid.self:SetDataCount(#DataModel.SortRoles)
  View.ScrollGrid_CharacterList.grid.self:MoveToTop()
  View.ScrollGrid_CharacterList.grid.self:RefreshAllElement()
  if #DataModel.SortRoles > 0 then
  end
  View.Group_Detail:SetActive(false)
end

function Controller:SetRoleElement(element, index)
  local data = DataModel.SortRoles[index]
  data.element = element
  DataModel.Break_Role = data
  local id = data.id
  DataModel.SortRoles[index].mask = element.Group_InTeam
  DataModel.SortRoles[index].selected = element.Img_Selected
  element.Btn_Item:SetClickParam(index)
  local ca = PlayerData:GetFactoryData(id)
  element.Img_Bottom:SetSprite(UIConfig.CharacterBottom[ca.qualityInt])
  local server = PlayerData:GetRoleById(id)
  if server ~= nil and server.current_skin ~= nil then
    local portraitId = server.current_skin[1]
    local portrailData = PlayerData:GetFactoryData(portraitId, "UnitViewFactory")
    element.Img_Mask.Img_Character:SetSprite(portrailData.roleListResUrl)
    if server.current_skin[2] == 1 and ca.isSpine2 == 1 then
      element.Img_Mask.Img_Character:SetSprite(portrailData.State2RoleListRes)
    end
  else
    local portraitId = ca.viewId
    local portrailData = PlayerData:GetFactoryData(portraitId, "UnitViewFactory")
    element.Img_Mask.Img_Character:SetSprite(portrailData.roleListResUrl)
  end
  element.Img_Decorate:SetSprite(UIConfig.CharacterDecorate[ca.qualityInt])
  element.Txt_Name:SetText(data.name)
  element.Txt_LVNum:SetText(data.lv)
  if element.Img_Rarity then
    element.Img_Rarity:SetSprite(UIConfig.TipConfig[ca.qualityInt + 1])
  end
  element.Group_InTeam:SetActive(DataModel.SortRoles[index].squads_index > 0)
  local index_img = "Img_Index"
  for i = 1, 5 do
    element.Group_InTeam[index_img .. i]:SetActive(false)
  end
  if element.Group_InTeam[index_img .. data.squads_index] then
    element.Group_InTeam[index_img .. data.squads_index]:SetActive(true)
  end
  local awakeLv = data.awake_lv
  for i = 1, 5 do
    element.Group_Break.StaticGrid_BK.grid[i].Img_On:SetActive(i <= awakeLv)
    element.Group_Break.StaticGrid_BK.grid[i].Img_Off:SetActive(i > awakeLv)
  end
  element.Group_Awake.Img_Awake:SetSprite(UIConfig.AwakeCommon[data.resonance_lv + 1])
  local isFinalSkillUnlock = PlayerData:IsRoleFinalSkillUnlock(data.id)
  if isFinalSkillUnlock then
    element.Group_Awake.Img_Awake:SetColor("#FFE266")
  else
    element.Group_Awake.Img_Awake:SetColor("#FFFFFF")
  end
  local ca = PlayerData:GetFactoryData(data.id, "UnitFactory")
  local Group_SkillColor = element.Group_SkillColor
  local cardList = PlayerData:GetRoleCardList(ca.id)
  for i = 1, table.count(cardList) do
    local obj = "Group_SkillColor" .. i
    local cardCA = PlayerData:GetFactoryData(cardList[table.count(cardList) - i + 1].id)
    local color = cardCA.color
    Group_SkillColor[obj].Img_Color:SetSprite(UIConfig.CharacterSkillColor[color])
  end
  local Group_Locate = Group_SkillColor.Group_Locate
  Group_Locate.Img_Line:SetSprite(UIConfig.CharacterLine[ca.line])
  local buff = PlayerData:GetCurStationStoreBuff(tostring(id), EnumDefine.HomeSkillEnum.AddTrust)
  local groupTrust = element.Group_Trust
  groupTrust:SetActive(buff ~= nil)
  if buff ~= nil then
    groupTrust.Txt_TrustNum:SetText(string.format(GetText(80601584), math.floor(buff.param * 100)))
    local curTime = TimeUtil:GetServerTimeStamp()
    local remainTime = math.max(buff.endTime - curTime, 0)
    local buffCA = PlayerData:GetFactoryData(buff.id, "HomeBuffFactory")
    groupTrust.Group_Icon.Img_TrustTime:SetFilledImgAmount(remainTime / buffCA.continueTime)
  end
  element.Img_Selected:SetActive(DataModel.curSelectedIndex == index)
end

function Controller:OnClickRole(index)
  local data = DataModel.SortRoles[index]
  local lastIndex = DataModel.curSelectedIndex
  if lastIndex ~= nil and 0 < lastIndex and DataModel.SortRoles[lastIndex].selected ~= nil then
    DataModel.SortRoles[lastIndex].selected:SetActive(false)
  end
  DataModel.curSelectedIndex = index
  data.selected:SetActive(true)
  Controller:RefreshGroupDetail(data)
  local curRoleIndex = data.squads_index
  if 0 < curRoleIndex then
    data.squads_index = 0
    data.mask:SetActive(false)
    DataModel.curSelectedRoles[curRoleIndex] = ""
  else
    local flag = true
    for i = 1, DataModel.maxNum do
      if DataModel.curSelectedRoles[i] == nil or DataModel.curSelectedRoles[i] == "" then
        DataModel.curSelectedRoles[i] = data.id
        data.squads_index = i
        data.mask:SetActive(true)
        local index_img = "Img_Index"
        for i = 1, 5 do
          data.mask[index_img .. i]:SetActive(false)
        end
        if data.mask[index_img .. data.squads_index] then
          data.mask[index_img .. data.squads_index]:SetActive(true)
        end
        flag = false
        break
      end
    end
    if flag then
    end
  end
end

function Controller:RefreshGroupDetail(data)
  DataModel.RoleCA = PlayerData:GetFactoryData(data.id)
  View.Group_Detail:SetActive(true)
  View.Group_Detail.Group_Card.StaticGrid_Card.grid.self:RefreshAllElement()
end

function Controller:OnsetRoleCardGrid(element, elementIndex)
  element.Btn_Skill:SetClickParam(tostring(elementIndex))
  local skillId = DataModel.RoleCA.skillList[tonumber(elementIndex)].skillId
  local data = PlayerData:GetFactoryData(skillId, "SkillFactory")
  element.Txt_Name:SetText(data.name)
  element.Img_Icon:SetSprite(data.iconPath)
  local cardCA = PlayerData:GetFactoryData(data.cardID)
  element.Img_Icon:SetColor(Color.white)
  if cardCA.color == "Red" then
    element.Img_Icon:SetColor(GameSetting.redCardColor)
  end
  element.Group_Cost.Txt_Num:SetText(math.ceil(cardCA.cost_SN))
end

function Controller:OnClickBtnRole()
  local data = {
    currentRoleId = DataModel.RoleCA.id,
    fromView = EnumDefine.CommonFilterType.SquadView,
    current = "MainUI",
    IsSquad = true,
    SquadsRoleList = {}
  }
  UIManager:Open("UI/CharacterInfo/CharacterInfo", Json.encode(data))
end

function Controller:OnClickSort(sortType)
  local preType = DataModel.curSortType
  if preType == sortType then
    DataModel.sortType[sortType] = not DataModel.sortType[sortType]
    View.Common_Filter.Group_TabBtn["Btn_" .. sortType].Img_bg.Img_Arrow:SetRotate(DataModel.sortType[sortType] and 180 or 0)
  else
    View.Common_Filter.Group_TabBtn["Btn_" .. preType].Img_bg:SetSprite("UI/Common/left_off")
    View.Common_Filter.Group_TabBtn["Btn_" .. sortType].Img_bg:SetSprite("UI/Common/left_on")
  end
  DataModel:SortAllRoles(sortType)
  View.ScrollGrid_CharacterList.grid.self:RefreshAllElement()
end

function Controller:TryAddHelpRoles()
  local roleStr = table.concat(DataModel.curSelectedRoles, ",")
  Net:SendProto("battle.add_help", function(json)
    UIManager:GoBack()
  end, roleStr)
end

return Controller
