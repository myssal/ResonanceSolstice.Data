local View = require("UIMonopoly/UIMonopolyView")
local Manager = require("UIMonopoly/LuaMonopolyManager")
local DataModel = require("UIMonopoly/UIMonopolyDataModel")

local function RefreshMainUIBuffElement(element, elementIndex)
  if element == nil then
    return
  end
  local list = DataModel.GetBuffList()
  if not list then
    return
  end
  local info = list[elementIndex]
  if not info then
    return
  end
  element.Btn_Buff.Img_Time:SetActive(false)
  element.Btn_Buff.Img_Num.Txt_Num:SetText(tostring(info.time))
  local ca = PlayerData:GetFactoryData(info.itemId, "ItemFactory")
  if ca then
    element.Btn_Buff.Img_Icon:SetSprite(ca.iconPath)
  end
  element.Btn_Buff:SetClickFunction(function()
    Manager.RefreshBuffListShow()
  end)
end

local function RefreshBuffElement(element, elementIndex)
  if element == nil then
    return
  end
  local list = DataModel.GetBuffList()
  if not list then
    return
  end
  local info = list[elementIndex]
  if not info then
    return
  end
  element.Img_TimeTip:SetActive(false)
  element.Img_CountTip.Txt_Count:SetText(tostring(info.time))
  local ca = PlayerData:GetFactoryData(info.itemId, "ItemFactory")
  if ca then
    element.Group_Des.Txt_Des:SetText(ca.buffDes)
    element.Img_Icon:SetSprite(ca.iconPath)
    element.Txt_Name:SetText(ca.name)
  end
end

local function RefreshTestBackpackElement(element, elementIndex)
  if element == nil then
    return
  end
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  local info = list[elementIndex]
  if not info then
    return
  end
  element.Group_Item.Btn_Item.Img_Num.Txt_Num:SetText("x" .. tostring(info.num))
  local ca = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not ca then
    return
  end
  element.Group_Item.Btn_Item.Txt_Name:SetText(ca.name)
  element.Group_Item.Btn_Item.Img_Icon:SetSprite(ca.iconPath)
  element.Group_Item.Btn_Item:SetClickParam(elementIndex)
end

local function RefreshPlayerElement(element, elementIndex)
  if element == nil then
    return
  end
  element.Img_Selected:SetActive(false)
  local list = DataModel.GetPlayerList()
  if not list then
    return
  end
  local info = list[elementIndex]
  if not info then
    return
  end
  element.Img_Info.Txt_Name:SetText(tostring(info.role_name))
  element.Img_Info.Txt_LV:SetText(info.lv)
  local headPath
  if info.avatar then
    local photoCA = PlayerData:GetFactoryData(info.avatar, "ProfilePhotoFactory")
    headPath = photoCA.imagePath
  else
    local configCA = PlayerData:GetFactoryData(99900001, "ConfigFactory")
    headPath = configCA.playerHeadList[info.gender + 1].playerHeadPath
  end
  if headPath then
    element.Img_HeadBG.Img_HeadMask.Img_Head:SetSprite(headPath)
  end
  element.Btn_Select:SetClickFunction(function()
    if Manager.curSelectPlayerObj then
      Manager.curSelectPlayerObj:SetActive(false)
    end
    element.Img_Selected:SetActive(true)
    Manager.curSelectPlayerObj = element.Img_Selected
    DataModel.curSelectUid = info.uid
  end)
end

local function RefreshBackpackElement(element, elementIndex)
  if element == nil then
    return
  end
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  local info = list[elementIndex]
  if not info then
    return
  end
  element.Img_Selected:SetActive(false)
  element.Img_CountTip.Txt_Count:SetText(tostring(info.num))
  local ca = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not ca then
    return
  end
  element.Txt_Name:SetText(ca.name)
  element.Group_Des.Txt_Des:SetText(ca.des)
  element.Img_Icon:SetSprite(info.iconPath)
  element.Btn_Select:SetClickFunction(function()
    if Manager.curSelectItemObj then
      Manager.curSelectItemObj:SetActive(false)
    end
    element.Img_Selected:SetActive(true)
    Manager.curSelectItemObj = element.Img_Selected
    DataModel.curSelectItemIndex = elementIndex
  end)
end

local function ReqTelecontrolDice(index)
  Manager.RefreshCDingState()
  Net:SendProto("monopoly.use_dice", function(json)
    if json then
      Manager.MinusBuffTimeByTime(DataModel.buffType.diceChange)
      Manager.MinusBuffTimeByTime(DataModel.buffType.diceFixPlus)
      Manager.MinusBuffTimeByTime(DataModel.buffType.rpg)
      if json.point ~= json.step then
        CommonTips.OpenTips(string.format(GetText(80609575), json.step))
      end
      DataModel.userMonopolyData.telecontrol = DataModel.userMonopolyData.telecontrol - 1
      Manager.RefreshTelecontrolDiceNum()
      DataModel.userMonopolyData.step = json.step
      if not string.nilorempty(json.curLoc) then
        CommonTips.OpenTips(80609984)
        Manager.MoveToGrid(json.curLoc)
      end
      if json.step > 0 then
        Manager.OnDiceOver()
      end
      View.Group_DiceItem:SetActive(false)
    end
  end, "telecontrol", index, function(json)
    Manager.CheckTimeIsOverAndBack()
  end)
end

local ViewFunction = {
  Monopoly_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    CommonTips.OpenLoading(nil, "", nil, function()
      CBus:ChangeScene("Main", function()
        UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000020}))
      end)
    end)
  end,
  Monopoly_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    CommonTips.OpenLoading(function()
      CBus:ChangeScene("Main")
    end)
  end,
  Monopoly_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Monopoly_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Monopoly_Group_Dice_Btn_Dice_Click = function(btn, str)
    if not DataModel.userMonopolyData then
      return
    end
    if DataModel.userMonopolyData.step > 0 then
      return
    end
    if not DataModel.userMonopolyData or 0 >= DataModel.GetUserDiceNum() then
      CommonTips.OpenTips(80600010)
      return
    end
    if not Manager.diceAni then
      return
    end
    Manager.RefreshCDingState()
    Net:SendProto("monopoly.use_dice", function(json)
      if json then
        Manager.MinusBuffTimeByTime(DataModel.buffType.diceChange)
        Manager.MinusBuffTimeByTime(DataModel.buffType.diceFix)
        Manager.MinusBuffTimeByTime(DataModel.buffType.rpg)
        Manager.AddUserDiceNum(-1)
        Manager.RefreshDiceNum()
        if json.point > 0 then
          DataModel.userMonopolyData.step = json.step
          View.Group_Model:SetActive(true)
          Manager.diceAni:Play("roll")
          DataModel.PlaySound(DataModel.soundIds.useDice)
          View.self:StartC(LuaUtil.cs_generator(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
            Manager.diceAni:Play(json.point .. "")
            coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
            if json.point ~= json.step then
              CommonTips.OpenTips(string.format(GetText(80609575), json.step))
            end
            View.Group_Model:SetActive(false)
            if not string.nilorempty(json.curLoc) then
              CommonTips.OpenTips(80609984)
              Manager.MoveToGrid(json.curLoc)
            end
            if json.step > 0 then
              Manager.RollDiceEnd(json.step)
            end
          end))
        end
      end
    end, "normal", 0, function(json)
      Manager.CheckTimeIsOverAndBack()
    end)
  end,
  Monopoly_Group_Dice_Btn_Control_Click = function(btn, str)
    if not DataModel.userMonopolyData then
      return
    end
    if DataModel.userMonopolyData.step > 0 then
      return
    end
    if not DataModel.userMonopolyData or 0 >= DataModel.userMonopolyData.telecontrol then
      CommonTips.OpenTips(80600010)
      return
    end
    View.Group_DiceItem:SetActive(true)
    View.Group_DiceItem.Img_BG.Img_Title:SetSprite((GetResPath(88300168)))
    View.self:PlayAnimOnce("Group_DiceItem")
    DataModel.PlaySound(DataModel.soundIds.uiOpen)
  end,
  Monopoly_Group_Money_Img_Detail_StaticGrid_City_SetGrid = function(element, elementIndex)
  end,
  Monopoly_Group_Money_Img_Detail_Btn_Clsoe_Click = function(btn, str)
  end,
  Monopoly_Group_Money_Btn_CityMoney_Click = function(btn, str)
  end,
  Monopoly_Group_DiceItem_Btn_Quit_Click = function(btn, str)
    View.Group_DiceItem:SetActive(false)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_1_Click = function(btn, str)
    ReqTelecontrolDice(1)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_2_Click = function(btn, str)
    ReqTelecontrolDice(2)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_3_Click = function(btn, str)
    ReqTelecontrolDice(3)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_4_Click = function(btn, str)
    ReqTelecontrolDice(4)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_5_Click = function(btn, str)
    ReqTelecontrolDice(5)
  end,
  Monopoly_Group_DiceItem_Img_BG_Btn_6_Click = function(btn, str)
    ReqTelecontrolDice(6)
  end,
  Monopoly_Group_Buff_NewScrollGrid_BuffList_SetGrid = function(element, elementIndex)
    RefreshBuffElement(element, elementIndex)
  end,
  Monopoly_Group_Buff_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    RefreshBuffElement(element, elementIndex)
  end,
  Monopoly_Group_Buff_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.Group_Buff:SetActive(false)
  end,
  Monopoly_Group_Buff_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Monopoly_Group_Buff_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Monopoly_Group_Buff_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_NewScrollGrid_BuffList_SetGrid = function(element, elementIndex)
    RefreshBackpackElement(element, elementIndex)
  end,
  Monopoly_Group_ItemBackpack_NewScrollGrid_BuffList_Group_Item_Btn_Select_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_StaticGrid_BuffList_SetGrid = function(element, elementIndex)
    RefreshBackpackElement(element, elementIndex)
  end,
  Monopoly_Group_ItemBackpack_StaticGrid_BuffList_Group_Item_Btn_Select_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_Btn_Use_Click = function(btn, str)
    Manager.OnBackpackUseBtnClick()
  end,
  Monopoly_Group_ItemBackpack_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.Group_ItemBackpack:SetActive(false)
  end,
  Monopoly_Group_ItemBackpack_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Monopoly_Group_ItemBackpack_Group_ChooseCharacter_Btn_Close_Click = function(btn, str)
    View.Group_ItemBackpack.Group_ChooseCharacter:SetActive(false)
  end,
  Monopoly_Group_ItemBackpack_Group_ChooseCharacter_Btn_Cancel_Click = function(btn, str)
    View.Group_ItemBackpack.Group_ChooseCharacter:SetActive(false)
  end,
  Monopoly_Group_ItemBackpack_Group_ChooseCharacter_Btn_Confirm_Click = function(btn, str)
    Manager.OnPlayerUseBtnClick(DataModel.curSelectUid)
  end,
  Monopoly_Group_ItemBackpack_Group_ChooseCharacter_StaticGrid_Character_SetGrid = function(element, elementIndex)
    RefreshPlayerElement(element, elementIndex)
  end,
  Monopoly_Group_ItemBackpack_Group_ChooseCharacter_StaticGrid_Character_Group_Character_Btn_Select_Click = function(btn, str)
  end,
  Monopoly_Group_ItemTest_Btn_TestClose_Click = function(btn, str)
    View.self:PlayAnimOnce("ItemOut", function()
      View.Group_ItemTest:SetActive(false)
      View.Group_ItemHide:SetActive(true)
      View.Group_Money:SetActive(true)
      View.Group_Dice:SetActive(true)
      View.Group_CommonTopLeft:SetActive(true)
    end)
  end,
  Monopoly_Group_ItemTest_Group_SliderBar_Slider_Scale_Slider = function(slider, value)
  end,
  Monopoly_Group_ItemTest_Group_SliderBar_Slider_Scale_SliderDown = function(slider)
  end,
  Monopoly_Group_ItemTest_Group_SliderBar_Slider_Scale_SliderUp = function(slider)
  end,
  Monopoly_Group_ItemHide_Btn_GridMenu_Click = function(btn, str)
    Manager.OnGridMenuBtnClick()
  end,
  Monopoly_Group_ItemHide_Btn_DiceDay_Click = function(btn, str)
    DataModel.OpenDiceDayPanel()
  end,
  Monopoly_Group_ItemHide_Btn_UseItem_Click = function(btn, str)
    Manager.OnItemBackpackBtnClick()
  end,
  Monopoly_Group_ItemHide_Btn_Refresh_Click = function(btn, str)
    Manager.OnRefreshBtnClick()
  end,
  Monopoly_Group_ItemHide_StaticGrid_BuffBar_SetGrid = function(element, elementIndex)
    RefreshMainUIBuffElement(element, elementIndex)
  end,
  Monopoly_Group_ItemHide_StaticGrid_BuffBar_Group_Buff_Btn_Buff_Click = function(btn, str)
  end,
  Monopoly_Group_Arrow_Btn_UP_Click = function(btn, str)
    Manager.CtlSelectDir(1)
  end,
  Monopoly_Group_Arrow_Btn_Down_Click = function(btn, str)
    Manager.CtlSelectDir(3)
  end,
  Monopoly_Group_Arrow_Btn_Left_Click = function(btn, str)
    Manager.CtlSelectDir(4)
  end,
  Monopoly_Group_Arrow_Btn_Right_Click = function(btn, str)
    Manager.CtlSelectDir(2)
  end,
  Monopoly_Group_BuffGodTips_Btn_Close_Click = function(btn, str)
    View.Group_BuffGodTips:SetActive(false)
    if DataModel.reqOutputFunc then
      DataModel.reqOutputFunc()
    end
  end,
  Monopoly_Group_BuffGodTipsBad_Btn_Close_Click = function(btn, str)
    View.Group_BuffGodTipsBad:SetActive(false)
    if DataModel.reqOutputFunc then
      DataModel.reqOutputFunc()
    end
  end,
  Monopoly_Group_ItemTest_NewScrollGrid_BuffList_SetGrid = function(element, elementIndex)
    RefreshTestBackpackElement(element, elementIndex)
  end,
  Monopoly_Group_ItemTest_NewScrollGrid_BuffList_Group_ItemOut_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  Monopoly_Group_ItemTest_NewScrollGrid_BuffList_Group_ItemOut_Group_Item_Btn_Item_LongPress = function(btn, str)
    Manager.OnItemLongPressed(tonumber(str))
  end,
  Monopoly_Group_ItemHide_Group_LV_Btn_LV_Click = function(btn, str)
    local isSignMpy = PlayerData.ServerData.user_monopoly.sign_mpy == 1
    local isEndMpy = PlayerData.GetMonopolyIsEnd()
    if not isSignMpy and not isEndMpy then
      CommonTips.OpenTips(80609949)
      return
    end
    local mapId = PlayerData.GetUserMonopolyId() or 0
    if mapId ~= 0 then
      UIManager:Open("UI/Monopoly/UI/Grade/MonopolyGrade", Json.encode({isOpenByMap = true}))
    end
  end,
  Monopoly_Group_ItemHide_Group_Target_Btn_Health_Click = function(btn, str)
    if not DataModel.userMonopolyData or not DataModel.userMonopolyData.monopoly_id then
      return
    end
    UIManager:Open("UI/Monopoly/UI/Boss/BossMenu", Json.encode({
      bossLevel = Manager.bossLevel,
      monopolyId = DataModel.userMonopolyData.monopoly_id,
      isHelpBoss = false
    }))
  end
}
return ViewFunction
