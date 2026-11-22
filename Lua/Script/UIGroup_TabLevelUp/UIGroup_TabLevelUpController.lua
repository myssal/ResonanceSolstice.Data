local View = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpView")
local DataModel = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}
local UITable, tempLvUpLevel

local function UseCost()
  local num = 0
  for i, v in pairs(DataModel.TempLvUpUse) do
    if 0 < v.tempNum then
      num = num + v.cost * v.tempNum
    end
  end
  if num == 0 then
    UITable.Group_TABottom.Group_Cost.self:SetActive(false)
    return
  end
  UITable.Group_TABottom.Group_Cost.self:SetActive(true)
  local have = PlayerData:GetUserInfo().gold
  UITable.Group_TABottom.Group_Cost.Txt_Have:SetText(have)
  UITable.Group_TABottom.Group_Cost.Txt_Need:SetText(num)
  if num > have then
    UITable.Group_TABottom.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
    DataModel.IsNoMoney = true
  else
    UITable.Group_TABottom.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
    DataModel.IsNoMoney = false
  end
end

local function SetExpEveryAll()
  local num = 0
  for k, v in pairs(DataModel.LvUpConfigFactory) do
    num = num + v.levelUpExp
    DataModel.LvUpEveryExp[k] = num
  end
end

local lastRoleId

function Controller:Load()
  DataModel.lock_Add = false
  DataModel.isLevelUp_Long = false
  DataModel.tempLvUpLevel = DataModel.RoleData.lv
  DataModel.tempLvUpExp = DataModel.RoleData.exp
  DataModel.allLvUpExp = DataModel.RoleData.exp
  DataModel.LvUpEveryExp = {}
  DataModel.LvUpConfigFactory = PlayerData:GetFactoryData(99900003, "ConfigFactory").expList
  SetExpEveryAll()
  UITable = View
  tempLvUpLevel = nil
  self:Refresh()
end

function Controller:Refresh(isTemp)
  DataModel.tempLvUpLevel = DataModel.tempLvUpLevel or DataModel.RoleData.lv
  DataModel.tempLvUpExp = DataModel.tempLvUpExp or DataModel.RoleData.exp
  if lastRoleId == DataModel.RoleId and DataModel.InitState == false and not isTemp then
    return
  end
  local portraitId = DataModel.RoleData.current_skin[1]
  if portraitId == nil or portraitId == 0 then
    local viewCa = PlayerData:GetFactoryData(DataModel.RoleCA.viewId, "UnitViewFactory")
    portraitId = DataModel.RoleCA.viewId
  end
  local Group_TATop = UITable.Group_TATop
  local Img_Icon = Group_TATop.Group_Icon.Img_Icon
  Img_Icon:SetSprite(PlayerData:GetFactoryData(PlayerData:GetFactoryData(DataModel.RoleId).viewId).face)
  Group_TATop.Img_LevelBottom.Txt_Name:SetText(DataModel.RoleCA.name)
  local Group_LV = Group_TATop.Img_LevelBottom.Group_LV
  Group_LV.Txt_LVCap.Txt_LVNum:SetText(tostring(DataModel.tempLvUpLevel))
  Group_LV.Txt_LVCap:SetText(DataModel.AwakeMaxLevel)
  if not isTemp then
    local data = PlayerData:GetFactoryData(99900001, "ConfigFactory").expSourceMaterialList
    DataModel.TempLvUpUse = DataModel.TempLvUpUse or {}
    for i, v in ipairs(data) do
      local num = PlayerData:GetMaterialById(v.id).num
      local itemData = PlayerData:GetFactoryData(v.id, "SourceMaterialFactory")
      DataModel.TempLvUpUse[i] = {
        id = v.id,
        maxNum = num,
        exp = itemData.exp,
        tempNum = 0,
        cost = itemData.cost
      }
    end
  end
  self:SetExp()
  local Group_TABottom = UITable.Group_TABottom
  Group_TABottom.StaticGrid_Item.self:RefreshAllElement()
  UseCost()
  if DataModel.curSquad then
    View.Group_TABottom.Btn_UpToMax:SetActive(true)
    if View.Group_TABottom.Btn_UpToMaxFullTeam ~= nil then
      View.Group_TABottom.Btn_UpToMaxFullTeam:SetActive(true)
    end
    if View.Group_TABottom.Btn_UpToMax_Single ~= nil then
      View.Group_TABottom.Btn_UpToMax_Single:SetActive(false)
    end
    if View.Group_TABottom.Btn_LevelCapBreak ~= nil then
      View.Group_TABottom.Btn_LevelCapBreak:SetActive(false)
    end
    if View.Group_TATop.Group_LvWithBreak ~= nil then
      if PlayerData:IsUnitLevelCapBreakUnlock() then
        View.Group_TATop.Group_LvWithBreak:SetActive(true)
        View.Group_TATop:SetLocalPositionX(-183)
      else
        View.Group_TATop.Group_LvWithBreak:SetActive(false)
        View.Group_TATop:SetLocalPositionX(0)
      end
    end
  else
    if PlayerData:IsUnitLevelCapBreakUnlock() then
      View.Group_TABottom.Btn_UpToMax:SetActive(true)
      if View.Group_TABottom.Btn_UpToMaxFullTeam ~= nil then
        View.Group_TABottom.Btn_UpToMaxFullTeam:SetActive(false)
      end
      if View.Group_TABottom.Btn_UpToMax_Single ~= nil then
        View.Group_TABottom.Btn_UpToMax_Single:SetActive(false)
      end
      if View.Group_TABottom.Btn_LevelCapBreak ~= nil then
        View.Group_TABottom.Btn_LevelCapBreak:SetActive(true)
      end
    else
      View.Group_TABottom.Btn_UpToMax:SetActive(false)
      if View.Group_TABottom.Btn_UpToMaxFullTeam ~= nil then
        View.Group_TABottom.Btn_UpToMaxFullTeam:SetActive(false)
      end
      if View.Group_TABottom.Btn_UpToMax_Single ~= nil then
        View.Group_TABottom.Btn_UpToMax_Single:SetActive(true)
      end
      if View.Group_TABottom.Btn_LevelCapBreak ~= nil then
        View.Group_TABottom.Btn_LevelCapBreak:SetActive(false)
      end
    end
    if View.Group_TATop.Group_LvWithBreak ~= nil then
      View.Group_TATop.Group_LvWithBreak:SetActive(false)
      View.Group_TATop:SetLocalPositionX(0)
    end
  end
  View.Group_LvCapBreak:SetActive(false)
end

function Controller:SetExp()
  local Img_LevelBottom = UITable.Group_TATop.Img_LevelBottom
  local Group_EXP = Img_LevelBottom.Group_EXP
  local lv = DataModel.tempLvUpLevel
  local endExp = 0
  local ConfigFactory = PlayerData:GetFactoryData(99900003, "ConfigFactory").expList
  local isMaxLevel = false
  if lv >= DataModel.AwakeMaxLevel then
    isMaxLevel = true
  else
    endExp = ConfigFactory[DataModel.tempLvUpLevel].levelUpExp
  end
  Group_EXP.Txt_EXPNum:SetActive(not isMaxLevel)
  if DataModel.RoleData.lv == DataModel.tempLvUpLevel and DataModel.tempLvUpExp == DataModel.RoleData.exp then
    Img_LevelBottom.Img_EXPPB:SetFilledImgAmount(DataModel.tempLvUpExp / endExp)
    Img_LevelBottom.Img_EXPAdd:SetFilledImgAmount(DataModel.tempLvUpExp / endExp)
  else
    if DataModel.tempLvUpLevel > DataModel.RoleData.lv then
      Img_LevelBottom.Img_EXPPB:SetFilledImgAmount(0)
    elseif DataModel.tempLvUpLevel == DataModel.RoleData.lv then
      Img_LevelBottom.Img_EXPPB:SetFilledImgAmount(DataModel.RoleData.exp / endExp)
    end
    Img_LevelBottom.Img_EXPAdd:SetFilledImgAmount(DataModel.tempLvUpExp / endExp)
  end
  if DataModel.tempLvUpLevel == DataModel.AwakeMaxLevel then
    Img_LevelBottom.Img_EXPPB:SetFilledImgAmount(0)
    Img_LevelBottom.Img_EXPAdd:SetFilledImgAmount(0)
  else
    Group_EXP.Txt_EXPNum:SetText(DataModel.tempLvUpExp .. "/" .. endExp)
  end
end

function Controller:OpenLvCapBreak()
  DataModel.lastNumIndex = nil
  DataModel.curNumIndex = nil
  DataModel.isBreakDraging = false
  View.Group_LvCapBreak:SetActive(true)
  local maxLevel = PlayerData:GetMaxUnitLevelCapBreak()
  DataModel.costMap = {}
  local breakConfig = PlayerData:GetFactoryData(99900235)
  local itemMap = {}
  for i = 1, maxLevel do
    local breakData = breakConfig.costList[i]
    local itemList = PlayerData:GetFactoryData(breakData.id).materialList
    DataModel.costMap[i] = {}
    for j = 1, #itemList do
      local itemId = itemList[j].id
      local num = itemList[j].num
      if itemMap[itemId] == nil then
        itemMap[itemId] = 0
      end
      if i > PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id) then
        itemMap[itemId] = itemMap[itemId] + num
      end
      if itemMap[itemId] == 0 then
        itemMap[itemId] = nil
      end
    end
    for k, v in pairs(itemMap) do
      DataModel.costMap[i][k] = itemMap[k]
    end
  end
  View.Group_LvCapBreak.Page_Grade.grid.self:SetDataCount(maxLevel)
  View.Group_LvCapBreak.Page_Grade.grid.self:RefreshAllElement()
  View.Group_LvCapBreak.Page_GradeHide.grid.self:SetDataCount(maxLevel)
  View.Group_LvCapBreak.Page_GradeHide.grid.self:RefreshAllElement()
  local curLv = PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id)
  if maxLevel <= curLv then
    curLv = maxLevel - 1
  end
  View.Group_LvCapBreak.Page_GradeHide.grid.self:LocatElementImmediate(curLv)
end

function Controller:CloseLvCapBreak()
  View.Group_LvCapBreak:SetActive(false)
end

function Controller:OnSetPageGradeElement(element, elementIndex)
  local config = PlayerData:GetFactoryData(99900001)
  element.Group_Lv_Child.Txt_LvNum:SetText(config.roleLevelMax + elementIndex)
  local isFinish = elementIndex <= PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id)
  element.Group_Lv_Child.Img_Line:SetActive(elementIndex ~= 1)
  if elementIndex - 1 == DataModel.curNumIndex then
    DataModel.isBreakItemEnough = true
    if DataModel.curNumIndex < PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id) then
      DataModel.isBreakItemEnough = false
      View.Group_LvCapBreak.Group_Cost.Group_CostList:SetActive(false)
      View.Group_LvCapBreak.Group_Cost.Txt_Already:SetActive(true)
    else
      View.Group_LvCapBreak.Group_Cost.Group_CostList:SetActive(true)
      View.Group_LvCapBreak.Group_Cost.Txt_Already:SetActive(false)
      local count = 1
      for k, v in pairs(DataModel.costMap[elementIndex]) do
        local itemId = k
        local num = v
        local curItem = View.Group_LvCapBreak.Group_Cost.Group_CostList["Group_Item_00" .. count]
        count = count + 1
        if curItem then
          curItem:SetActive(true)
          BtnItem:SetItem(curItem, {id = itemId})
          curItem.Txt_CostNum:SetText(PlayerData:NumToFormatString(num, 1))
          curItem.Txt_CostNum.Txt_Split.Txt_CurrentNum:SetText(PlayerData:NumToFormatString(PlayerData:GetGoodsById(itemId).num, 1))
          curItem.Btn_Item:SetClickParam(itemId)
          if num > PlayerData:GetGoodsById(itemId).num then
            if DataModel.isBreakItemEnough then
              DataModel.isBreakItemEnough = false
            end
            curItem.Txt_CostNum:SetColor(UIConfig.Color.Red)
            curItem.Txt_CostNum.Txt_Split:SetColor(UIConfig.Color.Red)
            curItem.Txt_CostNum.Txt_Split.Txt_CurrentNum:SetColor(UIConfig.Color.Red)
          else
            curItem.Txt_CostNum:SetColor(UIConfig.Color.White)
            curItem.Txt_CostNum.Txt_Split:SetColor(UIConfig.Color.White)
            curItem.Txt_CostNum.Txt_Split.Txt_CurrentNum:SetColor(UIConfig.Color.White)
          end
        end
      end
      for i = count, 5 do
        local curItem = View.Group_LvCapBreak.Group_Cost.Group_CostList["Group_Item_00" .. i]
        if curItem then
          curItem:SetActive(false)
        end
      end
    end
    element.Group_Lv_Child.Img_Circle_Black:SetActive(false)
    element.Group_Lv_Child.Img_Circle_Yellow:SetActive(true)
    element.Group_Lv_Child.Img_Circle_White:SetActive(false)
    element.Group_Lv_Child.Img_Circle_Grey:SetActive(false)
    if not DataModel.isBreakDraging then
      element.Group_Lv_Child:SelectPlayAnim("")
      element.Group_Lv_Child:SelectPlayAnim("stateBlackToYellow")
    end
    View.Group_LvCapBreak.Btn_Break:SetActive(DataModel.isBreakItemEnough)
  else
    local isBreakItemEnough = true
    for k, v in pairs(DataModel.costMap[elementIndex]) do
      local itemId = k
      local num = v
      if num > PlayerData:GetGoodsById(itemId).num and isBreakItemEnough then
        isBreakItemEnough = false
      end
    end
    element.Group_Lv_Child.Img_Circle_Yellow:SetActive(false)
    element.Group_Lv_Child.Img_Circle_Black:SetActive(isFinish)
    element.Group_Lv_Child.Img_Circle_White:SetActive(not isFinish and isBreakItemEnough)
    element.Group_Lv_Child.Img_Circle_Grey:SetActive(not isFinish and not isBreakItemEnough)
    if isFinish then
      element.Group_Lv_Child:SelectPlayAnim("stateYellowToBlack")
    elseif isBreakItemEnough then
      element.Group_Lv_Child:SelectPlayAnim("stateYellowToWhite")
    else
      element.Group_Lv_Child:SelectPlayAnim("stateYellowToGrey")
    end
  end
  element.Group_Lv_Child.Img_Check:SetActive(isFinish)
end

function Controller:OnClickRewardItem(str)
  local itemId = tonumber(str)
  if not itemId then
    return
  end
  CommonTips.OpenPreRewardDetailTips(itemId)
end

function Controller:ShowBreakSuccess()
  local config = PlayerData:GetFactoryData(99900001)
  View.Group_LvCapBreakSuccess:SetActive(true)
  View.Group_LvCapBreakSuccess.Group_Text.Txt_Num01:SetText(config.roleLevelMax + DataModel.curNumIndex + 1)
  View.Group_LvCapBreakSuccess.Group_Text.Group_Row.Txt_Lv02.Txt_Num02:SetText(config.roleLevelMax + PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id))
  View.Group_LvCapBreakSuccess.Group_Text.Group_Row.Txt_Lv03.Txt_Num03:SetText(config.roleLevelMax + DataModel.curNumIndex + 1)
end

function Controller:HideBreakSuccess()
  View.Group_LvCapBreakSuccess:SetActive(false)
end

function Controller:TryBreakLevel()
  local curBreakLv = PlayerData:GetRoleLevelCapBreak(DataModel.RoleCA.id)
  if curBreakLv > DataModel.curNumIndex then
    return
  end
  if not DataModel.isBreakItemEnough then
    return
  end
  Net:SendProto("hero.lv_break", function(json)
    PlayerData:RefreshUseItems(DataModel.costMap[DataModel.curNumIndex + 1])
    Controller:CloseLvCapBreak()
    local roleData = PlayerData:GetRoleById(DataModel.RoleCA.id)
    Controller:ShowBreakSuccess()
    if roleData then
      roleData.break_lv = (roleData.break_lv or 0) + DataModel.curNumIndex + 1 - curBreakLv
      local Group_LV = View.Group_TATop.Img_LevelBottom.Group_LV
      DataModel.AwakeMaxLevel = PlayerData:GetRoleLvMax(DataModel.RoleId)
      Group_LV.Txt_LVCap:SetText(DataModel.AwakeMaxLevel)
    end
  end, DataModel.RoleCA.id, DataModel.curNumIndex + 1 - curBreakLv)
end

return Controller
