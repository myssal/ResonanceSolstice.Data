local View = require("UICubeWarehouse/UICubeWarehouseView")
local DataModel = require("UICubeWarehouse/UICubeWarehouseDataModel")
local Controller = {}

function Controller:Init()
  local cubeData = PlayerData.TempCache.CubeRogueData
  local cubeId = PlayerData.TempCache.RogueCache.cubeId
  DataModel.cubeCA = PlayerData:GetFactoryData(cubeId)
  DataModel.cubeData = cubeData
  DataModel.buffFilterMode = nil
  DataModel.weaponFilterMode = nil
  DataModel.tabIndex = nil
  local coinCA = PlayerData:GetFactoryData(DataModel.cubeCA.coinId)
  View.Group_Coin.Img_Icon:SetSprite(coinCA.iconPath)
  View.Group_Coin.Txt_Num:SetText(PlayerData:GetGoodsById(coinCA.id).num)
  self:InitInsideBuff()
  self:InitWeapon()
  self:InitExtraBuff()
  self:OnClickTopTab(DataModel.InitIndex)
end

function Controller:RefreshTopTab()
  local tabIndex = DataModel.tabIndex
  View.Group_Top.Group_Buff.Group_On:SetActive(tabIndex == 1)
  View.Group_Top.Group_Buff.Group_Off:SetActive(tabIndex ~= 1)
  View.Group_Top.Group_Weapon.Group_On:SetActive(tabIndex == 2)
  View.Group_Top.Group_Weapon.Group_Off:SetActive(tabIndex ~= 2)
  View.Group_Top.Group_Team.Group_On:SetActive(tabIndex == 3)
  View.Group_Top.Group_Team.Group_Off:SetActive(tabIndex ~= 3)
  View.Group_Buff:SetActive(tabIndex == 1)
  View.Group_Weapon:SetActive(tabIndex == 2)
  View.Group_Team:SetActive(tabIndex == 3)
  if tabIndex == 1 then
    self:RefreshGroupBuff()
  elseif tabIndex == 2 then
    self:RefreshWeapon()
  elseif tabIndex == 3 then
    self:RefreshGroupTeam()
  end
end

function Controller:InitInsideBuff()
  local cubeCA = DataModel.cubeCA
  local teamList = {}
  for i = 1, #cubeCA.rogueTeamList do
    local teamCA = PlayerData:GetFactoryData(cubeCA.rogueTeamList[i].id)
    if TimeUtil:IsActive(teamCA.startTime, "") then
      table.insert(teamList, teamCA)
    end
  end
  DataModel.teamCaList = teamList
  local buffDic = DataModel.cubeData.inside_buffs
  local buffList = {
    all = {}
  }
  for i = 1, #DataModel.teamCaList do
    local curTeamKay = tostring(DataModel.teamCaList[i].id)
    buffList[curTeamKay] = {}
  end
  for k, v in pairs(buffDic) do
    local buffCa = PlayerData:GetFactoryData(k)
    local teamId = buffCa.correspondingTeam
    local buffData = {id = k}
    for m, n in pairs(v) do
      buffData[m] = n
    end
    buffList.all[#buffList.all + 1] = buffData
    if buffList[tostring(teamId)] == nil then
      buffList[tostring(teamId)] = {}
    end
    if buffCa.isSpecial ~= true then
      buffList[tostring(teamId)][#buffList[tostring(teamId)] + 1] = buffData
    end
  end
  DataModel.buffList = buffList
  DataModel.SortedMap = {}
end

function Controller:RefreshGroupBuff()
  View.Group_Buff.StaticGrid_List.grid.self:SetDataCount(#DataModel.teamCaList + 1)
  DataModel.weaponFilterMode = nil
  self:SetBuffFilter(1)
end

function Controller:OnSetBuffTypeGrid(element, elementIndex)
  local isSelected = elementIndex == DataModel.buffFilterMode
  element.Group_On:SetActive(isSelected)
  element.Group_Off:SetActive(not isSelected)
  local iconPath = "UI/CubeRogue/CubeWarehouse/Rarity/All"
  if 1 < elementIndex then
    iconPath = DataModel.teamCaList[elementIndex - 1].tabIconPath
  end
  local teamKey = Controller:GetCurTeamKey(elementIndex)
  if isSelected then
    element.Group_On.Img_Icon:SetSprite(iconPath)
    element.Group_On.Txt_Num:SetText(#DataModel.buffList[teamKey])
  else
    element.Group_Off.Img_Icon:SetSprite(iconPath)
    element.Group_Off.Txt_Num:SetText(#DataModel.buffList[teamKey])
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:GetCurTeamKey(filterMode)
  local curTeamKay = "all"
  if filterMode == nil then
    filterMode = DataModel.buffFilterMode
  end
  if 1 < filterMode then
    curTeamKay = tostring(DataModel.teamCaList[filterMode - 1].id)
  end
  return curTeamKay
end

function Controller:SetBuffFilter(mode)
  if DataModel.buffFilterMode == mode then
    return
  end
  DataModel.buffFilterMode = mode
  View.Group_Buff.StaticGrid_List.grid.self:RefreshAllElement()
  local teamKey = self:GetCurTeamKey()
  if DataModel.SortedMap[mode] ~= true then
    DataModel.SortedMap[mode] = true
    table.sort(DataModel.buffList[teamKey], function(a, b)
      local w1 = Controller:GetBuffWeight(a.id)
      local w2 = Controller:GetBuffWeight(b.id)
      if w1 ~= w2 then
        return w1 > w2
      else
        return tonumber(a.id) > tonumber(b.id)
      end
    end)
  end
  View.Group_Buff.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.buffList[teamKey])
  View.Group_Buff.ScrollGrid_Buff.grid.self:RefreshAllElement()
  View.Group_Buff.ScrollGrid_Buff.grid.self:MoveToTop()
end

function Controller:OnSetBuffGrid(element, elementIndex)
  local teamKey = self:GetCurTeamKey()
  local buffList = DataModel.buffList[teamKey]
  local buffData = buffList[elementIndex]
  local buffCA = PlayerData:GetFactoryData(buffData.id)
  element.Img_Icon:SetSprite(buffCA.iconPath)
  element.Txt_Name:SetText(buffCA.name)
  element.Img_Bg:SetSprite(DataModel.BuffBgQualityPath[buffCA.qualityInt + 1])
  local isInstensify = buffData.intensify ~= nil and buffData.intensify > 0
  element.Img_Level:SetActive(not isInstensify)
  element.Img_Level2:SetActive(isInstensify)
  local teamCA = PlayerData:GetFactoryData(buffCA.correspondingTeam)
  element.Img_Type:SetSprite(teamCA.tabIconPath)
  element.Img_TypeIcon:SetSprite(teamCA.shadePath)
  element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(teamCA.name)
  if isInstensify then
    element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(true)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetText(buffCA.intensifyDes)
  else
    element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(false)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(true)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(buffCA.des)
  end
end

function Controller:GetBuffWeight(id)
  local buffCA = PlayerData:GetFactoryData(id)
  return buffCA.qualityInt
end

function Controller:InitWeapon()
  local weaponDic = DataModel.cubeData.equips
  local weaponList = {
    all = {},
    Blue = {},
    Purple = {},
    Golden = {},
    Orange = {},
    negative = {}
  }
  for k, v in pairs(weaponDic) do
    local ca = PlayerData:GetFactoryData(k)
    local data = {id = k}
    for m, n in pairs(v) do
      data[m] = n
    end
    weaponList.all[#weaponList.all + 1] = data
    local weaponKey = ca.quality
    if ca.isNegative then
      weaponKey = "negative"
    end
    if weaponList[weaponKey] == nil then
      weaponList[weaponKey] = {}
    end
    weaponList[weaponKey][#weaponList[weaponKey] + 1] = data
  end
  DataModel.weaponList = weaponList
  DataModel.SortedWeaponMap = {}
end

function Controller:RefreshWeapon()
  DataModel.buffFilterMode = nil
  self:SetWeaponFilterMode("all")
end

function Controller:SetWeaponFilterMode(mode)
  if DataModel.weaponFilterMode == mode then
    return
  end
  if DataModel.SortedWeaponMap[mode] ~= true then
    DataModel.SortedWeaponMap[mode] = true
    table.sort(DataModel.weaponList[mode], function(a, b)
      local w1 = Controller:GetWeaponWeight(a.id)
      local w2 = Controller:GetWeaponWeight(b.id)
      if w1 ~= w2 then
        return w1 > w2
      else
        return tonumber(a.id) > tonumber(b.id)
      end
    end)
  end
  DataModel.weaponFilterMode = mode
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_All, "all")
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_Blue, "Blue")
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_Purple, "Purple")
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_Golden, "Golden")
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_Orange, "Orange")
  self:OnSetWeaponTypeGrid(View.Group_Weapon.Group_Quality.Group_Negative, "negative")
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:SetDataCount(#DataModel.weaponList[mode])
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:RefreshAllElement()
  View.Group_Weapon.ScrollGrid_Weapon.grid.self:MoveToTop()
end

function Controller:OnSetWeaponTypeGrid(element, elementKey)
  local isSelected = elementKey == DataModel.weaponFilterMode
  element.Group_On:SetActive(isSelected)
  element.Group_Off:SetActive(not isSelected)
  if isSelected then
    element.Group_On.Txt_Num:SetText(#DataModel.weaponList[elementKey])
  else
    element.Group_Off.Txt_Num:SetText(#DataModel.weaponList[elementKey])
  end
  element.Btn_:SetClickParam(elementKey)
end

function Controller:RefreshWeapomInfo()
  local weaponMod = DataModel.weaponFilterMode
  local weaponList = DataModel.weaponList[weaponMod]
  local weaponData = weaponList[DataModel.curWeaponIndex]
  View.Group_Weapon.Group_Centre:SetActive(weaponData ~= nil)
  View.Group_Weapon.Group_Empty:SetActive(#weaponList <= 0)
  if weaponData == nil then
    return
  end
  local weaponCA = PlayerData:GetFactoryData(weaponData.id)
  View.Group_Weapon.Group_Centre.Img_Icon:SetSprite(weaponCA.iconPath)
  View.Group_Weapon.Group_Centre.Txt_Name:SetText(weaponCA.name)
  View.Group_Weapon.Group_Centre.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(weaponCA.des)
  local bgPath = DataModel.BuffDecoBgQualityPath[weaponCA.qualityInt + 1]
  if weaponCA.isNegative then
    bgPath = DataModel.BuffDecoBgQualityPath[#DataModel.WeaponBgQualityPath]
  end
  View.Group_Weapon.Group_Centre.Img_Quality:SetSprite(bgPath)
  local efficacyNum = weaponCA.efficacyNum
  if 0 < weaponCA.efficacyNum then
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(weaponCA.id)]
    local use = equipData.use or 0
    if efficacyNum > use then
      View.Group_Weapon.Group_Remaining:SetActive(true)
      View.Group_Weapon.Group_Destroy:SetActive(false)
      View.Group_Weapon.Group_Remaining.Txt_Num:SetText(efficacyNum - use)
    else
      View.Group_Weapon.Group_Remaining:SetActive(false)
      View.Group_Weapon.Group_Destroy:SetActive(true)
    end
  else
    View.Group_Weapon.Group_Remaining:SetActive(false)
    View.Group_Weapon.Group_Destroy:SetActive(false)
  end
end

function Controller:OnSetWeaponGrid(element, elementIndex)
  local weaponMod = DataModel.weaponFilterMode
  local weaponList = DataModel.weaponList[weaponMod]
  local weaponData = weaponList[elementIndex]
  local weaponCA = PlayerData:GetFactoryData(weaponData.id)
  element.Img_Icon:SetSprite(weaponCA.iconPath)
  element.Txt_Name:SetText(weaponCA.name)
  local bgPath = DataModel.WeaponBgQualityPath[weaponCA.qualityInt + 1]
  if weaponCA.isNegative then
    bgPath = DataModel.WeaponBgQualityPath[#DataModel.WeaponBgQualityPath]
  end
  element.Img_Bg:SetSprite(bgPath)
  element.ScrollView_Des.Viewport.Content.Txt_Des:SetText(weaponCA.des)
  local efficacyNum = weaponCA.efficacyNum
  if weaponCA.efficacyNum > 0 then
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(weaponCA.id)]
    local use = equipData.use or 0
    if efficacyNum > use then
      element.Group_Remaining:SetActive(true)
      element.Group_Destroy:SetActive(false)
      element.Group_Remaining.Txt_Num:SetText(efficacyNum - use)
    else
      element.Group_Remaining:SetActive(false)
      element.Group_Destroy:SetActive(true)
    end
  else
    element.Group_Remaining:SetActive(false)
    element.Group_Destroy:SetActive(false)
  end
end

function Controller:GetWeaponWeight(id)
  local weaponCA = PlayerData:GetFactoryData(id)
  if weaponCA.isNegative then
    return -1
  end
  return weaponCA.qualityInt
end

function Controller:InitExtraBuff()
  local teamId = DataModel.cubeData.team
  local teamCA = PlayerData:GetFactoryData(teamId)
  DataModel.exBuffList = teamCA.extraBuffList
end

function Controller:RefreshGroupTeam()
  DataModel.weaponFilterMode = nil
  DataModel.buffFilterMode = nil
  View.Group_Team.ScrollView_List.Viewport.Content.Group_Bottom.Img_Schedule:SetFilledImgAmount(0)
  View.Group_Team.ScrollView_List.Viewport.Content.StaticGrid_List.grid.self:SetDataCount(#DataModel.exBuffList)
  View.Group_Team.ScrollView_List.Viewport.Content.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller:OnSetTeamBuffGrid(element, elementIndex)
  local buffData = DataModel.exBuffList[elementIndex]
  local isUnlock, isNumUnlock, isPrepositionUnlock = self:IsExBuffUnlock(buffData)
  if isUnlock then
    View.Group_Team.ScrollView_List.Viewport.Content.Group_Bottom.Img_Schedule:SetFilledImgAmount(elementIndex / #DataModel.exBuffList)
    View.Group_Team.ScrollView_List.Viewport.Content.Group_Bottom["Img_" .. elementIndex]:SetActive(true)
  end
  element.Group_Not.self:SetActive(not isUnlock)
  element.Group_Complete.self:SetActive(isUnlock)
  local buffCA = PlayerData:GetFactoryData(buffData.id)
  element.Group_Complete.Txt_Name:SetText(buffCA.name)
  element.Group_Complete.Img_Icon:SetSprite(buffCA.iconPath)
  local teamId = buffCA.correspondingTeam
  local hasNum = DataModel.cubeData.buff_cnt or 0
  local needNum = buffData.num
  element.Group_Num.Txt_Present:SetText(hasNum)
  element.Group_Num.Txt_Total:SetText(needNum)
  local desStr = ""
  local teamCA = PlayerData:GetFactoryData(teamId)
  if not isPrepositionUnlock then
    local prepositionId = buffData.prepositionId
    local prepositionCA = PlayerData:GetFactoryData(prepositionId)
    desStr = string.format(GetText(80610302), prepositionCA.name)
  elseif not isNumUnlock then
    desStr = string.format(GetText(80610303), teamCA.name, needNum)
  else
    desStr = buffCA.des
  end
  element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(desStr)
  for i = 1, #DataModel.exBuffList do
    element.Group_Schedule["Group_S" .. i]:SetActive(elementIndex == i)
  end
  element.Group_Schedule["Group_S" .. elementIndex].Img_Schedule:SetFilledImgAmount(hasNum / needNum)
  element.Img_Type:SetActive(teamCA.tabIconPath)
  element.Txt_Type:SetText(teamCA.name)
end

function Controller:IsExBuffUnlock(buffData)
  local prepositionId = buffData.prepositionId
  local isPrepositionUnlock = false
  if prepositionId == nil or prepositionId <= 0 then
    isPrepositionUnlock = true
  else
    for k, v in pairs(DataModel.cubeData.outside_buffs) do
      if tostring(k) == tostring(prepositionId) then
        isPrepositionUnlock = true
      end
    end
  end
  local buffCA = PlayerData:GetFactoryData(buffData.id)
  local teamId = buffCA.correspondingTeam
  local isNumUnlock = buffData.num <= (DataModel.cubeData.buff_cnt or 0)
  return isNumUnlock and isPrepositionUnlock, isNumUnlock, isPrepositionUnlock
end

function Controller:OnClickTopTab(index)
  if DataModel.tabIndex == index then
    return
  end
  DataModel.tabIndex = index
  Controller:RefreshTopTab()
end

return Controller
