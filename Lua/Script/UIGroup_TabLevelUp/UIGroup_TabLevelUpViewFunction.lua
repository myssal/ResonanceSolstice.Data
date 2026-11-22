local View = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpView")
local DataModel = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpController")
local InfoLoader = require("UICharacterInfo/ViewInfo")
local SkillLoader = require("UICharacterInfo/ViewSkill")
local AwakeLoader = require("UICharacterInfo/ViewAwake")
local ResonanceLoader = require("UICharacterInfo/ViewResonance")

local function LevelUpSend()
  DataModel.lock_LevelUp = true
  local items = {}
  for i, v in ipairs(DataModel.TempLvUpUse) do
    if v.tempNum > 0 then
      items[v.id] = v.tempNum
    end
  end
  if DataModel.IsNoMoney then
    CommonTips.OpenTips(80600129)
    return
  end
  if DataModel.tempLvUpExp ~= DataModel.RoleData.exp or DataModel.tempLvUpLevel ~= DataModel.RoleData.lv then
    if table.count(items) == 0 then
      return CommonTips.OpenTips(80600134)
    end
    if DataModel.tempLvUpLevel == DataModel.RoleData.lv and DataModel.tempLvUpExp == DataModel.RoleData.exp then
      return
    end
    Net:SendProto("hero.add_exp_by_material", function(json)
      local originalLv = DataModel.RoleData.lv
      local ogrinalExp = DataModel.RoleData.exp
      DataModel.lock_LevelUp = false
      DataModel.isLevelUp_Long = false
      PlayerData:RefreshUseItems(items)
      DataModel.RoleData = PlayerData:GetRoleById(DataModel.RoleId)
      DataModel.InitState = true
      Controller:Load()
      if UseGSDK then
        local info = PlayerData:GetGameUploadInfo()
        GSDKManager:RoleLevelUpload(info.RoleName, info.RoleLevel, info.Balance, info.Chapter)
      end
    end, tostring(DataModel.RoleId), items)
  else
    CommonTips.OpenTips(80600130)
    DataModel.lock_LevelUp = false
    return
  end
end

local function OnClickUpToMax()
  if DataModel.lock_Add == false and DataModel.isLevelUp_Long == false then
    DataModel.lock_Add = true
    DataModel.click_time = 0
    local ConfigFactory = DataModel.LvUpConfigFactory
    local maxLevel = DataModel.AwakeMaxLevel
    if maxLevel <= DataModel.tempLvUpLevel then
      CommonTips.OpenTips(80600130)
      return
    end
    local tempLvUpLevel = DataModel.tempLvUpLevel
    local exp = DataModel.tempLvUpExp
    local maxExp = -exp
    local levelExpMap = {}
    for i = tempLvUpLevel, maxLevel - 1 do
      maxExp = maxExp + (ConfigFactory[i] and ConfigFactory[i].levelUpExp or 0)
      levelExpMap[i] = maxExp
    end
    local totalExp = 0
    local remainExp = maxExp
    for i = #DataModel.TempLvUpUse, 1, -1 do
      local itemData = DataModel.TempLvUpUse[i]
      local needNum = math.min(math.tointeger(math.floor(remainExp / itemData.exp)), itemData.maxNum)
      itemData.tempNum = math.min(needNum, itemData.maxNum)
      totalExp = totalExp + itemData.exp * needNum
      remainExp = remainExp - itemData.exp * needNum
    end
    if totalExp == 0 then
      CommonTips.OpenTips(80600062)
      return
    end
    if 0 < remainExp then
      for i = 1, #DataModel.TempLvUpUse do
        local itemData = DataModel.TempLvUpUse[i]
        if itemData.maxNum > itemData.tempNum then
          itemData.tempNum = math.min(itemData.tempNum + 1, itemData.maxNum)
          totalExp = totalExp + itemData.exp
          break
        end
      end
    end
    local tempExp = exp + totalExp
    DataModel.allLvUpExp = DataModel.allLvUpExp + totalExp
    for i = maxLevel - 1, tempLvUpLevel, -1 do
      if totalExp >= levelExpMap[i] then
        DataModel.tempLvUpLevel = math.min(i + 1, maxLevel)
        if i == maxLevel - 1 then
          tempExp = 0
          break
        end
        tempExp = tempExp - levelExpMap[i]
        break
      end
    end
    View.self:PlayAnim("TapLevelUpStart")
    DataModel.tempLvUpExp = math.min(tempExp, maxExp)
    LevelUpSend()
  end
end

local function LevelUpSendSingle(roleMap)
  DataModel.lock_LevelUp = true
  local items = {}
  local roleJson = {}
  for i, v in pairs(roleMap) do
    roleJson[i] = {}
    for itemId, num in pairs(v) do
      if items[itemId] == nil then
        items[itemId] = 0
      end
      if 0 < num then
        items[itemId] = items[itemId] + num
      end
      roleJson[i][#roleJson[i] + 1] = itemId .. ":" .. num
    end
    roleJson[i] = table.concat(roleJson[i], ",")
  end
  if table.count(items) == 0 then
    return CommonTips.OpenTips(80600134)
  end
  if DataModel.IsNoMoney then
    CommonTips.OpenTips(80600129)
    return
  end
  Net:SendProto("hero.add_exp_multi", function(json)
    DataModel.lock_LevelUp = false
    PlayerData:RefreshUseItems(items)
    DataModel.RoleData = PlayerData:GetRoleById(DataModel.RoleId)
    DataModel.InitState = true
    Controller:Load()
    Controller:Refresh()
  end, Json.encode(roleJson))
end

local function OnClickUpToMaxFullTeam()
  if DataModel.curSquad ~= nil and DataModel.lock_Add == false and DataModel.isLevelUp_Long == false then
    DataModel.lock_Add = true
    DataModel.click_time = 0
    local ConfigFactory = DataModel.LvUpConfigFactory
    local maxLevel = DataModel.AwakeMaxLevel
    local canLevelUp = false
    local isExpEnough = false
    local roleMap = {}
    for i = 1, #DataModel.curSquad do
      local curRole = PlayerData:GetRoleById(DataModel.curSquad[i])
      local tempLvUpLevel = curRole.lv
      if maxLevel <= tempLvUpLevel then
        break
      end
      canLevelUp = true
      local exp = curRole.exp
      local maxExp = -exp
      local levelExpMap = {}
      for i = tempLvUpLevel, maxLevel - 1 do
        maxExp = maxExp + (ConfigFactory[i] and ConfigFactory[i].levelUpExp or 0)
        levelExpMap[i] = maxExp
      end
      local totalExp = 0
      local remainExp = maxExp
      for i = #DataModel.TempLvUpUse, 1, -1 do
        local itemData = DataModel.TempLvUpUse[i]
        local needNum = math.min(math.tointeger(math.floor(remainExp / itemData.exp)), itemData.maxNum)
        itemData.tempNum = math.min(needNum, itemData.maxNum)
        totalExp = totalExp + itemData.exp * needNum
        remainExp = remainExp - itemData.exp * needNum
      end
      if totalExp == 0 then
        break
      end
      isExpEnough = true
      if 0 < remainExp then
        for i = 1, #DataModel.TempLvUpUse do
          local itemData = DataModel.TempLvUpUse[i]
          if itemData.maxNum > itemData.tempNum then
            itemData.tempNum = math.min(itemData.tempNum + 1, itemData.maxNum)
            totalExp = totalExp + itemData.exp
            break
          end
        end
      end
      roleMap[tostring(curRole.id)] = {}
      local num = 0
      for i, v in pairs(DataModel.TempLvUpUse) do
        if 0 < v.tempNum then
          roleMap[tostring(curRole.id)][tostring(v.id)] = v.tempNum
          v.maxNum = v.maxNum - v.tempNum
          num = num + v.cost * v.tempNum
        end
      end
      local have = PlayerData:GetUserInfo().gold
      DataModel.IsNoMoney = num > have
      if curRole.id == DataModel.RoleId then
        local tempExp = exp + totalExp
        DataModel.allLvUpExp = DataModel.allLvUpExp + totalExp
        for i = maxLevel - 1, tempLvUpLevel, -1 do
          if totalExp >= levelExpMap[i] then
            DataModel.tempLvUpLevel = math.min(i + 1, maxLevel)
            if i == maxLevel - 1 then
              tempExp = 0
              break
            end
            tempExp = tempExp - levelExpMap[i]
            break
          end
        end
        DataModel.tempLvUpExp = math.min(tempExp, maxExp)
      end
    end
    if canLevelUp and isExpEnough then
      LevelUpSendSingle(roleMap)
      View.self:PlayAnim("TapLevelUpStart")
    elseif not canLevelUp then
      CommonTips.OpenTips(80600130)
    else
      CommonTips.OpenTips(80600062)
    end
  end
end

local ViewFunction = {
  Group_TabLevelUp_Btn_BG_Click = function(btn, str)
    if DataModel.ShowUI and DataModel.ShowUI == "characterinfo" then
      View.self:CloseUI()
      if DataModel.Index == 1 then
        InfoLoader:Load(DataModel.RoleData, true)
        InfoLoader:_set_exp()
      end
      if DataModel.Index == 2 then
        SkillLoader:Load()
      end
      if DataModel.Index == 3 then
        ResonanceLoader:Load(DataModel.RoleData)
      end
      if DataModel.Index == 4 then
        AwakeLoader:Load(DataModel.RoleData)
      end
    else
      UIManager:GoBack()
    end
  end,
  Group_TabLevelUp_Group_TABottom_StaticGrid_Item_SetGrid = function(element, elementIndex)
    local data = PlayerData:GetFactoryData(99900001, "ConfigFactory").expSourceMaterialList[elementIndex]
    local num = PlayerData:GetGoodsById(data.id).num
    local temp = DataModel.TempLvUpUse[elementIndex]
    temp.Now_num = num
    local itemData = PlayerData:GetFactoryData(data.id, "SourceMaterialFactory")
    CommonItem:SetItem(element.Group_Item, itemData)
    element.Btn_Add:SetClickParam(tostring(elementIndex))
    element.Txt_Use:SetText(num - temp.tempNum)
  end,
  Group_TabLevelUp_Group_TABottom_StaticGrid_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Group_TabLevelUp_Group_TABottom_StaticGrid_Item_Group_Item_Btn_Add_Click = function(btn, str)
    if DataModel.lock_Add == false and DataModel.isLevelUp_Long == false then
      local index = tonumber(str)
      local data = DataModel.TempLvUpUse[index]
      if data.Now_num == 0 then
        CommonTips.OpenTips(80600062)
        return
      end
      DataModel.lock_Add = true
      DataModel.click_time = 0
      local ConfigFactory = DataModel.LvUpConfigFactory
      local maxLevel = DataModel.AwakeMaxLevel
      local tempLvUpLevel = DataModel.tempLvUpLevel == maxLevel and DataModel.tempLvUpLevel - 1 or DataModel.tempLvUpLevel
      local maxExp = ConfigFactory[tempLvUpLevel] and ConfigFactory[tempLvUpLevel].levelUpExp or 0
      if data.tempNum == data.maxNum then
        CommonTips.OpenTips(80600062)
        return
      end
      if maxLevel <= DataModel.tempLvUpLevel then
        CommonTips.OpenTips(80600130)
        return
      end
      data.tempNum = math.min(data.tempNum + 1, data.maxNum)
      local totalExp = data.exp
      local exp = DataModel.tempLvUpExp
      local tempExp = exp + totalExp
      DataModel.allLvUpExp = DataModel.allLvUpExp + totalExp
      while maxExp <= tempExp do
        if DataModel.tempLvUpLevel == maxLevel - 1 then
          tempExp = 0
          DataModel.tempLvUpLevel = DataModel.tempLvUpLevel + 1
          break
        end
        tempExp = tempExp - maxExp
        if maxLevel == DataModel.tempLvUpLevel then
          DataModel.tempLvUpLevel = 1
        else
          DataModel.tempLvUpLevel = DataModel.tempLvUpLevel + 1
        end
        maxExp = ConfigFactory[DataModel.tempLvUpLevel].levelUpExp
      end
      View.self:PlayAnim("TapLevelUpStart")
      DataModel.tempLvUpExp = tempExp
      LevelUpSend()
    end
  end,
  Group_TabLevelUp_Group_TABottom_StaticGrid_Item_Group_Item_Btn_Add_LongPress = function(btn, str)
    local index = tonumber(str)
    local data = DataModel.TempLvUpUse[index]
    if data.Now_num == 0 then
      CommonTips.OpenTips(80600062)
      return
    end
    View.self:StartC(LuaUtil.cs_generator(function()
      while btn.Btn.isHandled do
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.05))
        DataModel.isLevelUp_Long = true
        if data.tempNum == data.maxNum then
          CommonTips.OpenTips(80600062)
          LevelUpSend()
          return
        end
        local maxLevel = DataModel.AwakeMaxLevel
        local tempLvUpLevel = DataModel.tempLvUpLevel == maxLevel and DataModel.tempLvUpLevel - 1 or DataModel.tempLvUpLevel
        local ConfigFactory = DataModel.LvUpConfigFactory
        local maxExp = ConfigFactory[tempLvUpLevel] and ConfigFactory[tempLvUpLevel].levelUpExp or 0
        if maxLevel <= DataModel.tempLvUpLevel then
          CommonTips.OpenTips(80600130)
          LevelUpSend()
          return
        end
        data.tempNum = math.min(data.tempNum + 1, data.maxNum)
        local totalExp = data.exp
        local exp = DataModel.tempLvUpExp
        local tempExp = exp + totalExp
        while maxExp <= tempExp do
          if DataModel.tempLvUpLevel == maxLevel - 1 then
            tempExp = 0
            DataModel.tempLvUpLevel = DataModel.tempLvUpLevel + 1
            break
          end
          tempExp = tempExp - maxExp
          if maxLevel == DataModel.tempLvUpLevel then
            DataModel.tempLvUpLevel = 1
          else
            DataModel.tempLvUpLevel = DataModel.tempLvUpLevel + 1
          end
          maxExp = ConfigFactory[DataModel.tempLvUpLevel].levelUpExp
        end
        DataModel.tempLvUpExp = tempExp
        Controller:Refresh(true)
      end
      View.self:PlayAnim("TapLevelUpStart")
      LevelUpSend()
    end))
  end,
  Group_TabLevelUp_Group_TABottom_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Group_TabLevelUp_Group_TABottom_Group_Item_Btn_Add_Click = function(btn, str)
  end,
  Group_TabLevelUp_Group_TABottom_Group_Item_Btn_Add_LongPress = function(btn, str)
  end,
  Group_TabLevelUp_Group_TABottom_Btn_UpToMax_Click = function(btn, str)
    OnClickUpToMax()
  end,
  Group_TabLevelUp_Group_TABottom_Btn_UpToMax_LongPress = function(btn, str)
  end,
  Group_TabLevelUp_Group_TABottom_Btn_UpToMaxFullTeam_Click = function(btn, str)
    OnClickUpToMaxFullTeam()
  end,
  Group_TabLevelUp_Group_TABottom_Btn_UpToMax_Single_Click = function(btn, str)
    OnClickUpToMax()
  end,
  Group_TabLevelUp_Group_TATop_Group_LvWithBreak_Btn_Break_Click = function(btn, str)
    Controller:OpenLvCapBreak()
  end,
  Group_TabLevelUp_Group_TABottom_Btn_LevelCapBreak_Click = function(btn, str)
    Controller:OpenLvCapBreak()
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_Grade_SetPage = function(element, elementIndex)
    Controller:OnSetPageGradeElement(element, elementIndex)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_Grade_PageDrag = function(dragOffsetPos)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_Grade_PageDragComplete = function(index)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_Grade_PageDragBegin = function(dragOffsetPos)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_Grade_Group_Lv_Item_Group_Lv_Child_Btn_Lv_Click = function(btn, str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Group_Cost_Group_CostList_Group_Item_001_Btn_Item_Click = function(btn, str)
    Controller:OnClickRewardItem(str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Group_Cost_Group_CostList_Group_Item_002_Btn_Item_Click = function(btn, str)
    Controller:OnClickRewardItem(str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Group_Cost_Group_CostList_Group_Item_003_Btn_Item_Click = function(btn, str)
    Controller:OnClickRewardItem(str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Group_Cost_Group_CostList_Group_Item_004_Btn_Item_Click = function(btn, str)
    Controller:OnClickRewardItem(str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Group_Cost_Group_CostList_Group_Item_005_Btn_Item_Click = function(btn, str)
    Controller:OnClickRewardItem(str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Btn_Break_Click = function(btn, str)
    Controller:TryBreakLevel()
  end,
  Group_TabLevelUp_Group_LvCapBreakSuccess_Btn_BG_Click = function(btn, str)
    Controller:HideBreakSuccess()
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_GradeHide_SetPage = function(element, elementIndex)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_GradeHide_PageDrag = function(dragOffsetPos)
    local grid = View.Group_LvCapBreak.Page_Grade.grid.self
    local pos = View.Group_LvCapBreak.Page_GradeHide.grid.self.ScrollRect.content.anchoredPosition
    grid.ScrollRect.content.anchoredPosition = Vector2(pos.x + 610, 0)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_GradeHide_PageDragComplete = function(index)
    local grid = View.Group_LvCapBreak.Page_Grade.grid.self
    grid.ScrollRect.content.anchoredPosition = Vector2(-305 * index + 610, 0)
    DataModel.lastNumIndex = DataModel.curNumIndex
    DataModel.curNumIndex = index
    DataModel.isBreakDraging = false
    grid:RefreshAllElement()
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_GradeHide_PageDragBegin = function(dragOffsetPos)
    DataModel.isBreakDraging = true
  end,
  Group_TabLevelUp_Group_LvCapBreak_Page_GradeHide_Group_Lv_Item_Group_Lv_Child_Btn_Lv_Click = function(btn, str)
  end,
  Group_TabLevelUp_Group_LvCapBreak_Btn_BG_Click = function(btn, str)
    Controller:CloseLvCapBreak()
  end
}
return ViewFunction
