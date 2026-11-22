local View = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeView")
local DataModel = require("UIPrisonBuildingUpgrade/UIPrisonBuildingUpgradeDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  PrisonBuildingUpgrade_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:Confirm()
    local isPowerRoom = DataModel.IsPowerRoom(DataModel.buildType)
    if isPowerRoom then
      View.self:PlayAnimOnce("Main_Power_Out", function()
        View.self:CloseUI()
      end)
    else
      View.self:PlayAnimOnce("Main_Out", function()
        View.self:CloseUI()
      end)
    end
  end,
  PrisonBuildingUpgrade_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonBuildingUpgrade_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Left_Group_Room_Group_Big_Btn_RoomB_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Left_Group_Room_Group_Small_Btn_RoomA_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Btn_Group_RoomUp_Btn__Click = function(btn, str)
    View.Group_Right.Group_Upgrade:SetActive(true)
    View.Group_Right.Group_CC:SetActive(false)
    View.Group_Right.Group_Btn.Group_RoomUp.Group_:SetActive(true)
    View.Group_Right.Group_Btn.Group_Machine.Group_:SetActive(false)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Btn_Group_Machine_Btn__Click = function(btn, str)
    View.Group_Right.Group_Upgrade:SetActive(false)
    View.Group_Right.Group_CC:SetActive(true)
    View.Group_Right.Group_Btn.Group_RoomUp.Group_:SetActive(false)
    View.Group_Right.Group_Btn.Group_Machine.Group_:SetActive(true)
    DataModel.RefreshPowerRoomPowerSocket()
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    local lvCfg = DataModel.roomLvData[elementIndex]
    if not lvCfg.config then
      element.Group_Builded:SetActive(false)
      element.Group_Current:SetActive(false)
      element.Group_LockCanBuild:SetActive(false)
      element.Group_Lock:SetActive(false)
      element.Btn_:SetActive(false)
      element.Img_Line:SetActive(false)
      return
    end
    local roomCA = PlayerData:GetFactoryData(lvCfg.config, "PrisonRoomFactory")
    if roomCA == nil then
      return
    end
    local roomLevel = roomCA.roomLevel
    local serverLv = DataModel.serverRoomData and DataModel.serverRoomData.lv or 0
    local state = DataModel.GetUpgradeState(elementIndex)
    element.Group_Builded:SetActive(state == DataModel.UpgradeState.Upgraded and roomLevel ~= serverLv)
    element.Group_Builded.Txt_LV:SetText(roomLevel)
    element.Group_Builded.Group_Choose:SetActive(DataModel.selectRoomId == lvCfg.config)
    element.Group_Current:SetActive(roomLevel == serverLv)
    element.Group_Current.Txt_LV:SetText(roomLevel)
    element.Group_Current.Group_Choose:SetActive(DataModel.selectRoomId == lvCfg.config)
    element.Group_LockCanBuild:SetActive(state == DataModel.UpgradeState.CanUpgrade)
    element.Group_LockCanBuild.Txt_LV:SetText(roomLevel)
    element.Group_LockCanBuild.Group_Choose:SetActive(DataModel.selectRoomId == lvCfg.config)
    element.Group_Lock:SetActive(state == DataModel.UpgradeState.CantUpgrade)
    element.Group_Lock.Txt_LV:SetText(roomLevel)
    element.Group_Lock.Group_Choose:SetActive(DataModel.selectRoomId == lvCfg.config)
    element.Btn_:SetActive(true)
    element.Btn_:SetClickParam(elementIndex)
    element.Img_Line:SetActive(elementIndex < #DataModel.roomLvData - 2)
    DataModel.levelElementList[lvCfg.config] = element
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_ScrollGrid_Level_Group_Item_Btn__Click = function(btn, str)
    DataModel.ClickLevel(tonumber(str))
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_Material_Group_Required_ScrollGrid_Required_SetGrid = function(element, elementIndex)
    local roomCA = PlayerData:GetFactoryData(DataModel.selectRoomId, "PrisonRoomFactory")
    local itemInfo = roomCA.lvUpCost[elementIndex]
    if itemInfo then
      CommonItem.SetItem(self, element.Group_Item, itemInfo)
      local haveNum = PlayerData:GetGoodsById(itemInfo.id).num
      element.Group_Item.Group_Num.Txt_Have:SetText(PlayerData:NumToFormatString(math.floor(haveNum), 1))
      element.Group_Item.Group_Num.Txt_Need:SetActive(haveNum >= itemInfo.num)
      element.Group_Item.Group_Num.Txt_Need:SetText(PlayerData:NumToFormatString(itemInfo.num, 1))
      element.Group_Item.Group_Num.Txt_NeedRed:SetActive(haveNum < itemInfo.num)
      element.Group_Item.Group_Num.Txt_NeedRed:SetText(PlayerData:NumToFormatString(itemInfo.num, 1))
      element.Group_Item.Btn_Item:SetClickParam(itemInfo.id)
    end
    element.Group_Item:SetActive(itemInfo)
    element.Img_None:SetActive(not itemInfo)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_Material_Group_Required_ScrollGrid_Required_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_CanBuild_Btn_Complete_Click = function(btn, str)
    local costInfo
    local typeId = DataModel.buildType
    local lvCfg = DataModel.roomLvData[tonumber(str)]
    local roomCA = PlayerData:GetFactoryData(lvCfg.config, "PrisonRoomFactory")
    local prisonCA = PrisonData.GetPrisonCA()
    for i, v in ipairs(prisonCA.diamondFaster) do
      if v.timeFaster >= roomCA.upgradeTime then
        costInfo = v
        break
      end
    end
    if costInfo then
      local function yesFun()
        local function callBack()
          View.self:CloseUI()
          
          if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
            local UIPrisonData = require("UIPrison/UIPrisonDataModel")
            UIPrisonData.UpgradeBuildImmediately(DataModel.buildType)
          end
        end
        
        PrisonData.UpgradeRoomImmediately(callBack, typeId, lvCfg.config, costInfo)
      end
      
      local itemCA = PlayerData:GetFactoryData(costInfo.diamond)
      CommonTips.OnPrompt(string.format(GetText(80607671), costInfo.diamondNum, itemCA.name), nil, nil, yesFun)
    end
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_CanBuild_Btn_Build_Click = function(btn, str)
    local lvCfg = DataModel.roomLvData[tonumber(str)]
    
    local function callBack()
      local function animCallBack()
        View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Build:SetBtnInteractable(true)
        
        View.self:CloseUI()
        if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
          local UIPrisonData = require("UIPrison/UIPrisonDataModel")
          UIPrisonData.UpgradeBuild(DataModel.buildType)
        end
      end
      
      local isPowerRoom = DataModel.IsPowerRoom(DataModel.buildType)
      if isPowerRoom then
        View.self:PlayAnimOnce("Main_Power_Out", animCallBack)
      else
        View.self:PlayAnimOnce("Main_Out", animCallBack)
      end
    end
    
    View.Group_Right.Group_Upgrade.Group_CanBuild.Btn_Build:SetBtnInteractable(false)
    PrisonData.UpgradeRoom(callBack, DataModel.buildType, lvCfg.config)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_CC_StaticGrid_MK_SetGrid = function(element, elementIndex)
    local powerRoomTypeCA = PlayerData:GetFactoryData(87500012, "PrisonRoomTypeFactory")
    local maxCount = 0
    if 0 < #powerRoomTypeCA.roomList then
      local maxLvRoomId = powerRoomTypeCA.roomList[#powerRoomTypeCA.roomList].config
      maxCount = PlayerData:GetFactoryData(maxLvRoomId, "PrisonRoomFactory").slotNum
    end
    if elementIndex > maxCount then
      element:SetActive(false)
      return
    end
    element:SetActive(true)
    local prisonData = PrisonData.GetSeverPrisonData()
    local installed = elementIndex <= prisonData.power_socket_num
    local curRoomCA = PlayerData:GetFactoryData(DataModel.curRoomId, "PrisonRoomFactory")
    element.Img_Empty:SetActive(not installed and elementIndex <= curRoomCA.slotNum)
    element.Img_NotUnlock:SetActive(not installed and elementIndex > curRoomCA.slotNum)
    if not installed and elementIndex > curRoomCA.slotNum then
      local unLockLv = 0
      for i, v in ipairs(powerRoomTypeCA.roomList) do
        local roomCA = PlayerData:GetFactoryData(v.config, "PrisonRoomFactory")
        if elementIndex <= roomCA.slotNum then
          unLockLv = roomCA.roomLevel
          break
        end
      end
      element.Img_NotUnlock.Txt_Tips:SetText(string.format(GetText(80608551), unLockLv))
    end
    element.Img_Installed:SetActive(installed)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_CC_Btn_Install_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonBuildingUpgrade/PrisonPowerRoomPrompt", nil, function()
      DataModel.RefreshPowerRoomPower()
      DataModel.RefreshPowerRoomPowerSocket()
    end)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_CC_Btn_NotInstall_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_CC_Btn_Not_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_CannotBuild_Btn_CreateRoom_Click = function(btn, str)
  end,
  PrisonBuildingUpgrade_Group_Right_Group_Upgrade_Group_CannotBuild_Btn_Power_Click = function(btn, str)
  end
}
return ViewFunction
