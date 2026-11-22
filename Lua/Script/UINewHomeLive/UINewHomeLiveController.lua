local View = require("UINewHomeLive/UINewHomeLiveView")
local DataModel = require("UINewHomeLive/UINewHomeLiveDataModel")
local Controller = {}
local this = Controller

function Controller.RefreshOnShow()
  local cfg = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
  View.Group_Details.Txt_Name:SetText(cfg.name .. " LV" .. cfg.Level)
  this.RefreshWaste()
  this.RefreshLivePanel()
  this.RefreshLightInfo()
  View.Group_CharacterList:SetActive(false)
end

function Controller.RefreshWaste()
  local cfg = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
  local totalWaste = 0
  local roles = PlayerData:GetHomeInfo().furniture[DataModel.curFurUfid].roles or {}
  for i, v in pairs(roles) do
    if v ~= "" then
      local unitCA = PlayerData:GetFactoryData(v, "UnitFactory")
      totalWaste = totalWaste + unitCA.WasteCoefficient * cfg.wasteoutput
    end
  end
  View.Group_Details.Group_LJ.Group_sum.Txt_Num:SetText(math.floor(totalWaste))
end

local function RefreshBed(ctr, liveRoleId, bedIndex)
  local canLiveInNum = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory").characterNum
  local show = bedIndex <= canLiveInNum
  ctr:SetActive(show)
  if show then
    ctr.Group_Change:SetActive(liveRoleId)
    ctr.Group_Checkin:SetActive(not liveRoleId)
    if liveRoleId then
      local unitCA = PlayerData:GetFactoryData(liveRoleId, "UnitFactory")
      local unitViewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
      local profilePhotoCA = PlayerData:GetFactoryData(unitViewCA.profilePhotoID, "ProfilePhotoFactory")
      ctr.Group_Change.Txt_Name:SetText(unitCA.name)
      ctr.Group_Change.Group_lv.Txt_LV:SetText(PlayerData.ServerData.roles[liveRoleId].lv)
      ctr.Group_Change.Group_Member.Btn_Change.Img_member:SetSprite(profilePhotoCA.imagePath)
      local remainTime = PlayerData:GetRoleRemainSleepTime(liveRoleId)
      if 0 < remainTime then
        ctr.Group_Change.Group_sleep.Group_sleeping.Txt_time:SetText(GetText(80603061) .. os.date("!%H:%M:%S", remainTime))
      end
    end
  end
end

function Controller.RefreshLivePanel()
  local canLiveInNum = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory").characterNum
  local liveRoles = PlayerData:GetHomeInfo().furniture[DataModel.curFurUfid].roles or {}
  local role1
  if liveRoles[1] and liveRoles[1] ~= "" then
    role1 = liveRoles[1]
  end
  RefreshBed(View.Group_Details.Group_Bed.Group_Bed1, role1, 1)
  local role2
  if liveRoles[2] and liveRoles[2] ~= "" then
    role2 = liveRoles[2]
  end
  RefreshBed(View.Group_Details.Group_Bed.Group_Bed2, role2, 2)
  local height = 1030 - (2 - canLiveInNum) * 200
  View.Group_Details:SetHeight(height)
end

function Controller.RefreshFrame(roleId, liveIndex, furUfid)
  local state = roleId and roleId ~= ""
  local iconPath = ""
  if state then
    local unitCA = PlayerData:GetFactoryData(roleId, "UnitFactory")
    local unitViewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
    local profilePhotoCA = PlayerData:GetFactoryData(unitViewCA.profilePhotoID, "ProfilePhotoFactory")
    iconPath = profilePhotoCA.imagePath
  end
  HomeManager:RefreshFurPhotoFrame(furUfid, liveIndex, state, iconPath)
end

function Controller.RefreshLightInfo()
  local cfg = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
  if cfg.upgrade > 0 then
    local maxInfo = DataModel.GetMaxLvFurnitureInfo(DataModel.curFurId)
    if maxInfo then
      View.Group_Details.Group_Light.Group_Lock:SetActive(true)
      View.Group_Details.Group_Light.Group_Lock.Group_tips.Group_text.Txt_LockLv:SetText("LV" .. maxInfo.Level)
    else
      View.Group_Details.Group_Light.Group_Lock:SetActive(false)
    end
  else
    View.Group_Details.Group_Light.Group_Lock:SetActive(false)
  end
  local colorType = PlayerData:GetPlayerPrefs("string", "FurLightColor" .. DataModel.curFurUfid)
  colorType = colorType ~= "" and colorType or DataModel.defaultLightColorType
  this.SetRotateZAndColor(colorType, false)
end

function Controller.SetRotateZAndColor(colorType, setColor)
  View.Group_Details.Group_Light.Img_colordisc.Btn_red.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Red)
  View.Group_Details.Group_Light.Img_colordisc.Btn_yellow.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Yellow)
  View.Group_Details.Group_Light.Img_colordisc.Btn_green.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Green)
  View.Group_Details.Group_Light.Img_colordisc.Btn_cyan.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Cyan)
  View.Group_Details.Group_Light.Img_colordisc.Btn_blue.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Blue)
  View.Group_Details.Group_Light.Img_colordisc.Btn_purple.Img_on:SetActive(colorType == EnumDefine.EFurLightColorType.Purple)
  View.Group_Details.Group_Light.Img_knob.transform.localRotation = Quaternion.Euler(0, 0, EnumDefine.EFurLightColorRotate[colorType])
  if setColor then
    local furCA = PlayerData:GetFactoryData(DataModel.curFurId)
    if furCA.characterNum ~= 1 then
      HomeManager:ChangeFurLight(DataModel.curFurUfid, EnumDefine.EFurLightColor[colorType])
    else
      HomeManager:ChangeFurMaterial(DataModel.curFurUfid, EnumDefine.EFurLightMaterialPath[colorType])
    end
    PlayerData:SetPlayerPrefs("string", "FurLightColor" .. DataModel.curFurUfid, colorType)
  end
end

function Controller.RefreshSelectLiveIn(sortType)
  if sortType == DataModel.ESortType.level then
    DataModel.SortByLevel()
  elseif sortType == DataModel.ESortType.quality then
    DataModel.SortByQuality()
  elseif sortType == DataModel.ESortType.time then
    DataModel.SortByTime()
  end
  UIManager:LoadSplitPrefab(View, "UI/Home/NewHomeLive", "Group_CharacterList")
  View.Group_CharacterList:SetActive(true)
  View.Group_CharacterList.Group_TopRight.Btn_Level.Img_Select:SetActive(sortType == DataModel.ESortType.level)
  View.Group_CharacterList.Group_TopRight.Btn_Rarity.Img_Select:SetActive(sortType == DataModel.ESortType.quality)
  View.Group_CharacterList.Group_TopRight.Btn_Time.Img_Select:SetActive(sortType == DataModel.ESortType.time)
  View.Group_CharacterList.ScrollGrid_.grid.self:SetDataCount(table.count(DataModel.allCanLiveInCharacter))
  View.Group_CharacterList.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller.CharacterLiveIn(roleId)
  roleId = tostring(roleId)
  local selectRoleData = PlayerData:GetRoleById(roleId)
  local selectRoleLiveIn = DataModel.IsRoleLiveIn(roleId)
  local selectRoleLiveInCurFur = DataModel.IsRoleLiveInCurFur(roleId)
  local selectRoleLiveFurUfid, selectRoleLiveFurData, selectRoleLiveIndex
  if selectRoleLiveIn then
    selectRoleLiveFurUfid = selectRoleData.u_fid
    selectRoleLiveFurData = PlayerData:GetFurniture()[selectRoleData.u_fid]
    selectRoleLiveFurData.roles = selectRoleLiveFurData.roles or {}
    selectRoleLiveIndex = DataModel.GetRoleLiveIndex(roleId)
    if selectRoleLiveIndex == -1 then
      return
    end
  end
  local selectRoleInEmergency = DataModel.IsInEmergency(roleId)
  local curFurData = PlayerData:GetFurniture()[DataModel.curFurUfid]
  curFurData.roles = curFurData.roles or {}
  local curRoleData, curRoleInEmergency, curHomeCharacter
  local curRoleId = curFurData.roles[DataModel.curLiveInPos] and tostring(curFurData.roles[DataModel.curLiveInPos]) or ""
  if curRoleId ~= "" then
    curRoleData = PlayerData:GetRoleById(curRoleId)
    curHomeCharacter = CharacterUtil.GetOpHomeCharacter(curRoleId)
    curRoleInEmergency = DataModel.IsInEmergency(curRoleId)
  end
  if curRoleId == roleId then
    curFurData.roles[DataModel.curLiveInPos] = nil
    curRoleData.u_fid = nil
    PlayerData:RemoveRoleSleepTime(roleId)
  else
    curFurData.roles[DataModel.curLiveInPos] = roleId
    selectRoleData.u_fid = DataModel.curFurUfid
    if selectRoleLiveFurData then
      selectRoleLiveFurData.roles[selectRoleLiveIndex] = curRoleId
      if curRoleData then
        curRoleData.u_fid = selectRoleLiveFurUfid
      end
    elseif curRoleData then
      PlayerData:RemoveRoleSleepTime(curRoleId)
      curRoleData.u_fid = nil
    end
  end
  if curRoleId == roleId or not selectRoleLiveIn then
    if curRoleData and not curRoleInEmergency then
      CharacterUtil.StopOp(curRoleId)
    end
  else
    if not selectRoleInEmergency then
      local sleepTime = PlayerData:GetRoleRemainSleepTime(roleId)
      if 0 < sleepTime then
        CharacterUtil.InitOp(roleId, DataModel.curFurUfid, DataModel.curLiveInPos - 1, sleepTime)
      end
    end
    if curRoleId ~= "" and not curRoleInEmergency then
      local sleepTime = PlayerData:GetRoleRemainSleepTime(curRoleId)
      if 0 < sleepTime then
        CharacterUtil.InitOp(curRoleId, selectRoleLiveFurUfid, selectRoleLiveIndex - 1, sleepTime)
      end
    end
    if not selectRoleLiveInCurFur then
      curHomeCharacter = CharacterUtil.GetOpHomeCharacter(curRoleId)
      if curHomeCharacter and not curHomeCharacter.movePart.IsMoving then
        curHomeCharacter.view:SetActive(false)
      end
    end
  end
  local curFurLiveNum = PlayerData:GetFactoryData(curFurData.id, "HomeFurnitureFactory").characterNum
  for i = 1, curFurLiveNum do
    this.RefreshFrame(curFurData.roles[i], i, DataModel.curFurUfid)
  end
  if selectRoleLiveIn and not selectRoleLiveInCurFur then
    local livenNum = PlayerData:GetFactoryData(selectRoleLiveFurData.id, "HomeFurnitureFactory").characterNum
    for i = 1, livenNum do
      this.RefreshFrame(selectRoleLiveFurData.roles[i], i, selectRoleLiveFurData.u_fid)
    end
  end
  View.Group_CharacterList:SetActive(false)
  this.RefreshWaste()
  this.RefreshLivePanel()
  local liveRoleData = {}
  for i = 1, curFurLiveNum do
    liveRoleData[i] = curFurData.roles[i] or ""
  end
  local str = table.concat(liveRoleData, ",")
  Net:SendProto("hero.check_in", function(json)
  end, DataModel.curFurUfid, str)
  if selectRoleLiveFurData and not selectRoleLiveInCurFur then
    local livenNum = PlayerData:GetFactoryData(selectRoleLiveFurData.id, "HomeFurnitureFactory").characterNum
    local liveRoleData = {}
    for i = 1, livenNum do
      liveRoleData[i] = curFurData.roles[i] or ""
    end
    local str = table.concat(liveRoleData, ",")
    Net:SendProto("hero.check_in", function(json)
    end, selectRoleLiveFurUfid, str)
  end
end

function Controller.RefreshAllAutoSleep()
  for roleId, roleData in pairs(PlayerData.ServerData.roles) do
    if roleData.u_fid and roleData.u_fid ~= "" and not DataModel.IsInEmergency(roleId) then
      local remainTime = PlayerData:GetRoleRemainSleepTime(roleId)
      local autoSleepTime = DataModel.GetLiveSleepTime(roleId)
      if 0 < remainTime and remainTime < autoSleepTime then
        PlayerData:SetRoleSleepTime(roleId, autoSleepTime)
        local character = CharacterUtil.GetOpHomeCharacter(roleId)
        if character then
          HomeCharacterManager:ChangeOpTime(character, autoSleepTime)
        end
      elseif remainTime == 0 and 0 < autoSleepTime then
        local liveIndex = DataModel.GetRoleLiveIndex(roleId)
        CharacterUtil.StartOp(roleId, roleData.u_fid, liveIndex - 1, autoSleepTime)
        PlayerData:SetRoleSleepTime(roleId, autoSleepTime)
      end
    end
  end
end

function Controller.RefreshCurFurAutoSleep()
  if not UIManager:IsPanelOpened("UI/MainUI/MainUI") then
    local roles = PlayerData:GetFurniture()[DataModel.curFurUfid].roles
    if roles then
      for i, roleId in pairs(roles) do
        if roleId ~= "" then
          local remainTime = PlayerData:GetRoleRemainSleepTime(roleId)
          local autoSleepTime = DataModel.GetLiveSleepTime(roleId)
          if 0 < remainTime and remainTime < autoSleepTime then
            PlayerData:SetRoleSleepTime(roleId, autoSleepTime)
            local character = CharacterUtil.GetOpHomeCharacter(roleId)
            if character then
              HomeCharacterManager:ChangeOpTime(character, autoSleepTime)
            end
          elseif remainTime == 0 and 0 < autoSleepTime and not DataModel.IsInEmergency(roleId) then
            local liveIndex = DataModel.GetRoleLiveIndex(roleId)
            local roleData = PlayerData:GetRoleById(roleId)
            CharacterUtil.StartOp(roleId, roleData.u_fid, liveIndex - 1, autoSleepTime)
            PlayerData:SetRoleSleepTime(roleId, autoSleepTime)
          end
          local ctr = View.Group_Details.Group_Bed["Group_Bed" .. i]
          if ctr then
            local character = CharacterUtil.GetOpHomeCharacter(roleId)
            local isSleeping = 0 < remainTime and character and character:CheckSleepRemainTimeShow() and not DataModel.IsInEmergency(roleId)
            ctr.Group_Change.Group_sleep.Group_sleeping:SetActive(isSleeping)
            ctr.Group_Change.Group_sleep.Btn_gotoSleep:SetActive(not isSleeping)
            local timeTxt = GetText(80603061) .. os.date("!%H:%M:%S", remainTime)
            if CommonTips.IsResEN() then
              timeTxt = os.date("!%H:%M:%S", remainTime)
            end
            ctr.Group_Change.Group_sleep.Group_sleeping.Txt_time:SetText(timeTxt)
          end
        end
      end
    end
  end
end

function Controller.RoleSleepTimeUpdate()
  for roleId, v in pairs(PlayerData.RoleSleepTime) do
    local remainTime = v.sleepStart + v.sleepTime - os.time()
    if remainTime <= 0 then
      CharacterUtil.StopOp(roleId, false)
      PlayerData:RemoveRoleSleepTime(roleId)
    end
  end
end

function Controller.InitSleep()
  for roleId, roleData in pairs(PlayerData.ServerData.roles) do
    if roleData.u_fid and roleData.u_fid ~= "" then
      local remainTime = PlayerData:GetRoleRemainSleepTime(roleId)
      local autoSleepTime = DataModel.GetLiveSleepTime(roleId)
      if remainTime < autoSleepTime then
        PlayerData:SetRoleSleepTime(roleId, autoSleepTime)
        remainTime = autoSleepTime
      end
      if 0 < remainTime then
        local liveIndex = DataModel.GetRoleLiveIndex(roleId)
        if liveIndex ~= -1 then
          CharacterUtil.InitOp(roleId, roleData.u_fid, liveIndex - 1, remainTime)
        end
      end
    end
  end
end

return Controller
