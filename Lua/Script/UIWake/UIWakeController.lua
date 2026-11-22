local View = require("UIWake/UIWakeView")
local DataModel = require("UIWake/UIWakeDataModel")
local TeamDataModel = require("UITeam_Battle/UITeam_BattleDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local Controller = {}

function Controller:Init()
  DataModel.eventCA = PlayerData:GetFactoryData(DataModel.eventId)
  View.Img_Title:SetSprite(GetResPath(88300235))
  local roleList = {}
  local roleDeck = PlayerData.TempCache.CubeRogueData.roles
  for k, v in pairs(roleDeck) do
    local roleCA = PlayerData:GetFactoryData(k)
    if roleCA ~= nil then
      roleList[#roleList + 1] = {id = k}
    end
  end
  table.sort(roleList, function(e1, e2)
    local w1 = Controller:GetRoleWeightById(e1.id)
    local w2 = Controller:GetRoleWeightById(e2.id)
    return w1 > w2
  end)
  local costId = DataModel.eventCA.breakPriceNList[1].id
  DataModel.priceList = {
    [0] = DataModel.eventCA.breakPriceNList,
    [1] = DataModel.eventCA.breakPriceNList,
    [2] = DataModel.eventCA.breakPriceRList,
    [3] = DataModel.eventCA.breakPriceSRList,
    [4] = DataModel.eventCA.breakPriceSSRList
  }
  DataModel.costId = costId
  DataModel.costNum = 0
  DataModel.roleList = roleList
  DataModel.selectedIndex = nil
  View.ScrollGrid_RoleList.grid.self:SetDataCount(#DataModel.roleList)
  Controller:OnSelectRole(1)
end

function Controller:GetRoleWeightById(id)
  local weight = 0
  local roleData = PlayerData:GetRoleById(id)
  local awakeLv = (roleData.awake_lv or 0) + (PlayerData.TempCache.CubeRogueData.roles[tostring(id)].awake_lv or 0)
  weight = weight + awakeLv
  local roleCA = PlayerData:GetFactoryData(id)
  weight = weight + (roleCA.qualityInt + 1) * 10
  if awakeLv == #roleCA.breakthroughList - 1 then
    weight = weight - 1000
  end
  local roleList = PlayerData.TempCache.CubeRogueData.deck
  for k in pairs(roleList) do
    if k == id then
      weight = weight + 100
      break
    end
  end
  return weight
end

function Controller:OnSelectRole(index)
  if DataModel.selectedIndex == index then
    return
  end
  DataModel.selectedIndex = index
  View.ScrollGrid_RoleList.grid.self:RefreshAllElement()
  Controller:RefreshAwakeInfo()
  Controller:RefreshCostInfo()
end

function Controller:OnSetRoleGrid(element, elementIndex)
  local roleId = DataModel.roleList[elementIndex].id
  element.Btn_Click:SetClickParam(elementIndex)
  local roleData = PlayerData.ServerData.roles[roleId]
  local currentSkin = roleData.current_skin[1]
  local viewCA = PlayerData:GetFactoryData(currentSkin, "UnitViewFactory")
  element.Img_Mask.Img_Character:SetSprite(viewCA.roleListResUrl)
  element.Group_LV.Txt_Num:SetText(math.max(roleData.lv, 60))
  local roleCA = PlayerData:GetFactoryData(roleId)
  element.Txt_Name:SetText(roleCA.name)
  local awakeLv = (roleData.awake_lv or 0) + (PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv or 0)
  element.Group_Break.StaticGrid_BK.grid.self:SetDataCount(5)
  for i = 0, 4 do
    element.Group_Break.StaticGrid_BK.grid[i + 1].Img_On:SetActive(awakeLv >= i + 1)
  end
  local qualityInt = roleCA.qualityInt
  local bgPath = TeamDataModel.RoleQualityBigPath[qualityInt]
  local maskPath = TeamDataModel.RoleQualityBigMaskPath[qualityInt]
  element.Img_Quality:SetSprite(bgPath)
  element.Img_Mask:SetSprite(maskPath)
  element.Img_Selected:SetActive(elementIndex == DataModel.selectedIndex)
  element.Img_Max:SetActive(awakeLv == 5 and elementIndex ~= DataModel.selectedIndex)
end

function Controller:RefreshAwakeInfo(awakeIndex)
  local roleId = DataModel.roleList[DataModel.selectedIndex].id
  local roleData = PlayerData:GetRoleById(roleId)
  local awakeLv = (roleData.awake_lv or 0) + (PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv or 0)
  local roleCA = PlayerData:GetFactoryData(roleId)
  if awakeLv == #roleCA.breakthroughList - 1 then
    View.Group_Max:SetActive(true)
    View.Group_BK:SetActive(false)
  else
    View.Group_Max:SetActive(false)
    View.Group_BK:SetActive(true)
    View.Group_BK.Group_Current.Txt_BK:SetText(string.format(GetText(80600418), awakeLv))
    View.Group_BK.Group_Next.Txt_BK:SetText(string.format(GetText(80600418), awakeLv + 1))
    View.Group_BK.Group_Current.StaticGrid_BK.grid.self:SetDataCount(5)
    for i = 0, 4 do
      View.Group_BK.Group_Current.StaticGrid_BK.grid[i + 1].Img_On:SetActive(awakeLv >= i + 1)
    end
    View.Group_BK.Group_Next.StaticGrid_BK.grid.self:SetDataCount(5)
    for i = 0, 4 do
      View.Group_BK.Group_Next.StaticGrid_BK.grid[i + 1].Img_On:SetActive(awakeLv + 1 >= i + 1)
    end
  end
  DataModel.awakeIndex = nil
  for i = 1, 5 do
    local isOn = awakeLv >= i
    if View.Group_Icon1["Group_Line" .. i - 1] ~= nil then
      View.Group_Icon1["Group_Line" .. i - 1]:SetActive(isOn)
    end
    View.Group_Icon1["Group_SkillIcon" .. i].Img_lightselect:SetActive(false)
    Controller:SetGroupSlillIcon(View.Group_Icon1["Group_SkillIcon" .. i], roleCA.breakthroughList[i + 1], isOn, i)
  end
  if awakeIndex == nil then
    awakeIndex = 1
  end
  Controller:SelectAwake(awakeIndex)
end

function Controller:SelectAwake(index)
  if DataModel.awakeIndex == index then
    return
  end
  if DataModel.awakeIndex ~= nil then
    View.Group_Icon1["Group_SkillIcon" .. DataModel.awakeIndex].Img_lightselect:SetActive(false)
  end
  View.Group_Icon1["Group_SkillIcon" .. index].Img_lightselect:SetActive(true)
  DataModel.awakeIndex = index
  local roleId = DataModel.roleList[DataModel.selectedIndex].id
  local roleCA = PlayerData:GetFactoryData(roleId)
  local bkData = roleCA.breakthroughList[DataModel.awakeIndex + 1]
  local bkCA = PlayerData:GetFactoryData(bkData.breakthroughId)
  View.Group_AwakeCheck.Img_AwakeIconBase.Img_AwakeIcon:SetSprite(bkCA.path)
  View.Group_AwakeCheck.Txt_Name:SetText(bkCA.name)
  View.Group_AwakeCheck.ScrollView_Des.Viewport.Content.Txt_Des:SetText(bkCA.desc)
end

function Controller:SetGroupSlillIcon(group, bkData, isOn, index)
  local bkCA = PlayerData:GetFactoryData(bkData.breakthroughId)
  if isOn then
    group.Group_On:SetActive(true)
    group.Group_Off:SetActive(false)
    group.Group_On.Img_Icon:SetSprite(bkCA.path)
  else
    group.Group_On:SetActive(false)
    group.Group_Off:SetActive(true)
    group.Group_Off.Img_Icon:SetSprite(bkCA.path)
    group.Group_Off.Img_Lock.Txt_Lock:SetText(string.format(GetText(80600417), index))
  end
end

function Controller:RefreshCostInfo()
  local canAwake = true
  local roleId = DataModel.roleList[DataModel.selectedIndex].id
  local roleData = PlayerData:GetRoleById(roleId)
  local awakeLv = (roleData.awake_lv or 0) + (PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv or 0)
  local roleCA = PlayerData:GetFactoryData(roleId)
  if awakeLv == #roleCA.breakthroughList - 1 then
    canAwake = false
  end
  DataModel.costNum = DataModel.priceList[roleCA.qualityInt][1].num
  local costCA = PlayerData:GetFactoryData(DataModel.costId)
  View.Group_Cost.Group_Icon.Img_Coin:SetSprite(costCA.buyPath)
  View.Group_Cost.Txt_Cost:SetText(DataModel.costNum)
  local hasNum = PlayerData:GetGoodsById(costCA.id).num
  View.Group_Cost.Txt_Own:SetText(hasNum)
  if hasNum < DataModel.costNum then
    canAwake = false
    View.Group_Cost.Txt_Cost:SetColor("#CD5454")
    View.Group_Cost.Txt_0:SetColor("#CD5454")
    View.Group_Cost.Txt_Own:SetColor("#CD5454")
  else
    View.Group_Cost.Txt_Cost:SetColor("#FFFFFF")
    View.Group_Cost.Txt_0:SetColor("#FFFFFF")
    View.Group_Cost.Txt_Own:SetColor("#FFFFFF")
  end
  View.Btn_Confirm.Img_Unable:SetActive(not canAwake)
  View.Btn_Confirm.Img_Able:SetActive(canAwake)
end

function Controller:OnBtnAwake()
  local roleId = DataModel.roleList[DataModel.selectedIndex].id
  local roleData = PlayerData:GetRoleById(roleId)
  local awakeLv = (roleData.awake_lv or 0) + (PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv or 0)
  local roleCA = PlayerData:GetFactoryData(roleId)
  if awakeLv == #roleCA.breakthroughList - 1 then
    return
  end
  local costCA = PlayerData:GetFactoryData(DataModel.costId)
  local hasNum = PlayerData:GetGoodsById(costCA.id).num
  if hasNum < DataModel.costNum then
    return
  end
  Net:SendProto("cube.awake", function(json)
    PlayerData:RefreshUseItems({
      [DataModel.costId] = DataModel.costNum
    })
    RogueController.ShowCoin()
    local lv = PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv or 0
    PlayerData.TempCache.CubeRogueData.roles[tostring(roleId)].awake_lv = lv + 1
    View.self:PlayAnimOnce(DataModel.AwakeAnimName[awakeLv + 1], function()
      View.ScrollGrid_RoleList.grid.self:RefreshAllElement()
      Controller:RefreshAwakeInfo(DataModel.awakeIndex)
      Controller:RefreshCostInfo()
    end)
  end, tostring(roleId))
end

return Controller
