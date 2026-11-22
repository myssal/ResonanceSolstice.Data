local View = require("UIPetInfo/UIPetInfoView")
local DataModel = require("UIPetInfo/UIPetInfoDataModel")
local CommonItem = require("Common/BtnItem")

local function UpdateTieInfo()
  local bufferList = DataModel.GetServerPetData()[DataModel.pet_uid].buff_list
  for i = 1, 3 do
    local contentInfo = ""
    if bufferList[i] then
      local buffCA = PlayerData:GetFactoryData(bufferList[i])
      if buffCA ~= nil then
        local tiesName = buffCA.tiesName
        contentInfo = string.format(GetText(80605796), i, tiesName)
        local addNum = 0
        if 0 < buffCA.atkNum then
          addNum = buffCA.atkNum
        elseif 0 < buffCA.defNum then
          addNum = buffCA.defNum
        elseif 0 < buffCA.hpNum then
          addNum = buffCA.hpNum
        end
        addNum = addNum * (1 + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.AddTieVal))
        addNum = math.floor(addNum + 0.5)
        contentInfo = string.format(contentInfo, addNum)
      end
    else
      contentInfo = string.format(GetText(80602691), i, i + 7)
    end
    View.Group_PetInfo.Group_Feeder["Group_Tie" .. i].Txt_:SetText(contentInfo)
  end
end

local function UpdatePetInfo()
  local pet_uid = DataModel.petList[DataModel.selectIndex]
  local data = DataModel.GetServerPetData()[pet_uid]
  local petCfg = PlayerData:GetFactoryData(data.id)
  local nature = data.personality and PlayerData:GetFactoryData(data.personality).petPersonalityName or ""
  View.Group_PetInfo.Group_Love.Txt_LoveLevel:SetText("LV " .. data.lv)
  local nowLvFavor = data.favor
  View.Group_PetInfo.Group_Love.Txt_Love:SetText(string.format("%d/%d", nowLvFavor, DataModel.lvFavorMax))
  View.Group_PetInfo.Group_Love.Img_LoveBar:SetFilledImgAmount(nowLvFavor / DataModel.lvFavorMax)
  View.Group_PetInfo.Group_CommonInfo.Group_PetFoodInt.Txt_:SetText(string.format(GetText(80601033), petCfg.petFoodInt))
  View.Group_PetInfo.Group_CommonInfo.Group_PetGarbage.Txt_:SetText(string.format(GetText(80601006), petCfg.wasteoutput))
  View.Group_PetInfo.Group_CommonInfo.Group_Personality.Txt_:SetText(nature)
  View.Group_PetState.Txt_State:SetText(DataModel.GetPetState(data.status_level))
  View.Group_PetInfo.Group_Feeder.Group_Feeder.Btn_feeder:SetActive(not PlayerData.visitMode)
  View.Group_PetInfo.Btn_Feed:SetActive(not PlayerData.visitMode)
  View.Group_Name.Btn_:SetActive(not PlayerData.visitMode)
  View.Group_PetInfo.Btn_PetGive:SetActive(not PlayerData.visitMode)
  View.Group_PetInfo.Btn_Fondle:SetActive(PlayerData.visitMode)
  if PlayerData.visitMode then
    local maxNum = PlayerData:GetFactoryData(99900192).fondleNum
    local remainNum = maxNum - PlayerData.visitInfo.interact
    View.Group_PetInfo.Btn_Fondle.Txt_:SetText(remainNum .. "/" .. maxNum)
  end
  local feedId = data.role_id
  if feedId ~= "" and feedId then
    local viewId = PlayerData:GetFactoryData(feedId).viewId
    local feedIcon = PlayerData:GetFactoryData(viewId).face
    View.Group_PetInfo.Group_Feeder.Group_Feeder.Btn_feeder.Img_icon:SetSprite(feedIcon)
    View.Group_PetInfo.Group_Feeder.Group_Feeder.Btn_feeder.Img_icon:SetActive(true)
    View.Group_PetInfo.Group_Feeder.Txt_Name:SetText(PlayerData:GetFactoryData(feedId).name)
    View.Group_PetInfo.Group_Feeder.Group_Feeder.Btn_feeder:SetActive(true)
  else
    View.Group_PetInfo.Group_Feeder.Group_Feeder.Btn_feeder.Img_icon:SetActive(false)
    View.Group_PetInfo.Group_Feeder.Txt_Name:SetText()
  end
  local normalAniName = DataModel.GetPetAniName(1)
  View.Group_PetView.Group_Pet:SetActive(false)
  View.Group_PetView.Group_Pet.SpineAnimation_:SetData(DataModel.petSpinePath, normalAniName)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
    View.Group_PetView.Group_Pet.SpineAnimation_:SetLocalScale(Vector3(-1, 1, 1) * DataModel.petInfoRatio)
    View.Group_PetView.Group_Pet:SetActive(true)
  end))
  View.Group_PetScore.Txt_:SetText(DataModel.petScore)
  local kind = PlayerData:GetFactoryData(petCfg.petVarity).petVarity
  View.Group_PetInfo.Group_CommonInfo.Group_PetSpecies.Txt_:SetText(kind)
  local furId = data.u_fid
  local furniture = CommonCoachData.GetFurData()[furId]
  local houseName = ""
  if furniture then
    local fCfg = PlayerData:GetFactoryData(furniture.id)
    houseName = furniture.name == "" and fCfg.name or furniture.name
    View.Group_PetInfo.Group_House.Txt_HouseNameNo:SetActive(false)
    View.Group_PetInfo.Group_House.Txt_PlaceNo:SetActive(false)
    View.Group_PetInfo.Group_House.Txt_HouseName:SetActive(true)
    View.Group_PetInfo.Group_House.Txt_Place:SetActive(true)
    View.Group_PetInfo.Group_House.Txt_HouseName:SetText(houseName)
    View.Group_PetInfo.Group_House.Txt_Place:SetText(string.format(GetText(80601087), DataModel.petFurList[furId].roomId + 1))
  else
    View.Group_PetInfo.Group_House.Txt_HouseNameNo:SetActive(true)
    View.Group_PetInfo.Group_House.Txt_PlaceNo:SetActive(true)
    View.Group_PetInfo.Group_House.Txt_HouseName:SetActive(false)
    View.Group_PetInfo.Group_House.Txt_Place:SetActive(false)
  end
  local name = data.name ~= "" and data.name or petCfg.petName
  View.Group_Name.Txt_:SetText(name)
  View.Group_PetInfo.Group_CommonInfo.Group_FeedDays.Txt_:SetText(string.format(GetText(80601048), data.live_cnt or 0))
  View.Group_PetInfo.Btn_Feed.Txt_:SetText(string.format(GetText(80601071), DataModel.feedMax - data.feed, DataModel.feedMax))
  UpdateTieInfo()
end

local function OpenSnack()
  if View.Group_Snack.IsActive then
    View.Group_Snack:SetActive(false)
  else
    DataModel.GetFoodList()
    local hasFood = false
    for k, v in pairs(DataModel.foodList) do
      if v.num > 0 then
        hasFood = true
        break
      end
    end
    View.Group_Snack:SetActive(true)
    View.Group_Snack.ScrollGrid_Snack.self:SetActive(hasFood)
    View.Group_Snack.Group_NoSnack:SetActive(not hasFood)
    if hasFood then
      View.Group_Snack.ScrollGrid_Snack.grid.self:SetDataCount(#DataModel.foodList)
      View.Group_Snack.ScrollGrid_Snack.grid.self:RefreshAllElement()
    end
  end
end

local ViewFunction = {
  PetInfo_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PetInfo_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
    if HomeManager.cam.isLock then
      local mainUIView = require("UIMainUI/UIMainUIView")
      mainUIView.self:SetRaycastBlock(false)
      HomeManager:CamFocusEnd(function()
        mainUIView.self:SetRaycastBlock(true)
      end)
    end
  end,
  PetInfo_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80300364}
    UIManager:Open("UI/Common/Group_Help", Json.encode(data))
  end,
  PetInfo_Group_PetInfo_Btn_PetGive_Click = function(btn, str)
    CommonTips.OpenTips(GetText(80607634))
  end,
  PetInfo_Group_ChangePet_Btn_Left_Click = function(btn, str)
    DataModel.ChangePet(false)
    UpdatePetInfo()
    if View.Group_Snack.IsActive then
      DataModel.GetFoodList()
      View.Group_Snack.ScrollGrid_Snack.grid.self:SetDataCount(#DataModel.foodList)
      View.Group_Snack.ScrollGrid_Snack.grid.self:RefreshAllElement()
      View.Group_Snack.ScrollGrid_Snack.grid.self:MoveToTop()
    end
  end,
  PetInfo_Group_ChangePet_Btn_Right_Click = function(btn, str)
    DataModel.ChangePet(true)
    UpdatePetInfo()
    if View.Group_Snack.IsActive then
      DataModel.GetFoodList()
      View.Group_Snack.ScrollGrid_Snack.grid.self:SetDataCount(#DataModel.foodList)
      View.Group_Snack.ScrollGrid_Snack.grid.self:RefreshAllElement()
      View.Group_Snack.ScrollGrid_Snack.grid.self:MoveToTop()
    end
  end,
  PetInfo_Group_Name_Btn__Click = function(btn, str)
    View.Group_ChangeName:SetActive(true)
  end,
  PetInfo_Group_PetInfo_Group_Feeder_Group_Feeder_Btn_feeder_Click = function(btn, str)
    if PlayerData.visitMode then
      return
    end
    UIManager:Open("UI/HomePet/PetFeederList", Json.encode({
      u_pet = DataModel.pet_uid
    }))
  end,
  PetInfo_Group_PetInfo_Btn_Feed_Click = function(btn, str)
    OpenSnack()
  end,
  PetInfo_Group_ChangeName_Btn_Close_Click = function(btn, str)
  end,
  PetInfo_Group_ChangeName_Btn_Confirm_Click = function(btn, str)
    local name = View.Group_ChangeName.InputField_ChangeName:GetText()
    Net:SendProto("pet.rename", function()
      DataModel.GetServerPetData()[DataModel.pet_uid].name = name
      View.Group_Name.Txt_:SetText(name)
      View.Group_ChangeName:SetActive(false)
    end, DataModel.pet_uid, name)
  end,
  PetInfo_Group_ChangeName_Btn_Cancel_Click = function(btn, str)
    View.Group_ChangeName:SetActive(false)
  end,
  PetInfo_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PetInfo_Group_Snack_ScrollGrid_Snack_SetGrid = function(element, elementIndex)
    local foodData = DataModel.foodList[elementIndex]
    CommonItem:SetItem(element.Group_Item, foodData, EnumDefine.ItemType.Item)
    element.Group_Item.Btn_Item:SetClickParam(elementIndex)
    if PlayerData.visitMode then
      element.Txt_:SetActive(true)
      element.Img_:SetActive(false)
      local cfg = PlayerData:GetFactoryData(foodData.id)
      local reduceTiredNum = cfg.reduceTiredNum or 0
      element.Txt_:SetText(string.format(GetText(80609142), reduceTiredNum))
      return
    end
    local data = PlayerData:GetFactoryData(foodData.id)
    local addLove = data.addLove * (1 + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RisePetLoveGains))
    if foodData.extraAdd == 1 then
      addLove = addLove * DataModel.extraAdd
    end
    addLove = math.floor(addLove + 1.0E-4)
    element.Txt_:SetText(string.format(GetText(80601054), addLove))
    element.Img_:SetActive(foodData.extraAdd == 1)
  end,
  PetInfo_Group_Snack_ScrollGrid_Snack_Group_FoodItem_Group_Item_Btn_Item_Click = function(btn, str)
    if PlayerData.visitMode then
      local maxNum = PlayerData:GetFactoryData(99900192).fondleNum
      if maxNum <= PlayerData.visitInfo.interact then
        CommonTips.OpenTips(GetText(80608852))
        return
      end
      if PlayerData:GetUserInfo().move_energy <= 0 then
        CommonTips.OpenTips(GetText(80600522))
        return
      end
      local petId = DataModel.pet_uid
      local uid = PlayerData.visitInfo.uid
      local index = tonumber(str)
      local foodData = DataModel.foodList[index]
      local id = foodData.id
      local num = 1
      local material = id .. ":" .. num
      local move_energy = PlayerData:GetUserInfo().move_energy
      Net:SendProto("friend.interact_pet", function()
        PlayerData.visitInfo.interact = PlayerData.visitInfo.interact + 1
        local remainNum = maxNum - PlayerData.visitInfo.interact
        View.Group_PetInfo.Btn_Fondle.Txt_:SetText(remainNum .. "/" .. maxNum)
        local ani_name = DataModel.GetPetAniName(2)
        View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(ani_name, false, true, function()
          View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(DataModel.GetPetAniName(1), true)
        end)
        foodData.num = foodData.num - 1
        PlayerData:GetGoodsById(foodData.id).num = foodData.num
        local txtNum = btn.transform.parent:Find("Txt_Num"):GetComponent(typeof(CS.Seven.UITxt))
        txtNum:SetText(foodData.num)
        local subCnt = move_energy - PlayerData:GetUserInfo().move_energy
        local cfg = PlayerData:GetFactoryData(id)
        local reduceTiredNum = cfg.reduceTiredNum or 0
        subCnt = subCnt > reduceTiredNum and reduceTiredNum or subCnt
        CommonTips.OpenTips(string.format(GetText(80601513), subCnt))
      end, petId, uid, material)
      return
    end
    if DataModel.GetServerPetData()[DataModel.pet_uid].u_fid == "" then
      CommonTips.OpenTips(GetText(80601173))
      return
    end
    if DataModel.GetServerPetData()[DataModel.pet_uid].lv >= DataModel.maxLevel then
      CommonTips.OpenTips(80606884)
      return
    end
    View.Group_PetInfo.Group_Effect1:SetActive(false)
    View.Group_PetInfo.Group_Effect2:SetActive(false)
    local index = tonumber(str)
    local foodData = DataModel.foodList[index]
    local id = foodData.id
    local num = 1
    local param = id .. ":" .. num
    local petInfo = DataModel.GetServerPetData()[DataModel.petList[DataModel.selectIndex]]
    local addLove = PlayerData:GetFactoryData(id).addLove * (1 + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RisePetLoveGains))
    if foodData.extraAdd == 1 then
      addLove = addLove * DataModel.extraAdd
    end
    addLove = math.floor(addLove + 1.0E-4)
    if petInfo.lv == 7 and petInfo.role_id == "" and petInfo.favor + addLove >= DataModel.lvFavorMax then
      CommonTips.OpenTips(GetText(80606031))
      return
    end
    if petInfo.feed < DataModel.feedMax then
      Net:SendProto("pet.feed", function(json)
        petInfo.feed = petInfo.feed + 1
        petInfo.favor = petInfo.favor + addLove
        if petInfo.favor >= DataModel.lvFavorMax then
          View.Group_PetInfo.Group_Effect1:SetActive(true)
          local start_value = (petInfo.favor - addLove) / DataModel.lvFavorMax
          local end_value = 1
          DataModel.tween = DOTweenTools.DoImgProgressbar(View.Group_PetInfo.Group_Love.Img_LoveBar, start_value, end_value, 0.5, function()
            local start_value = 0
            local end_value = petInfo.favor / DataModel.lvFavorMax
            View.Group_PetInfo.Group_Effect2:SetActive(true)
            DataModel.tween = DOTweenTools.DoImgProgressbar(View.Group_PetInfo.Group_Love.Img_LoveBar, start_value, end_value, 0.5, function()
              DataModel.tween = nil
            end)
          end)
          petInfo.favor = petInfo.favor - DataModel.lvFavorMax
          petInfo.lv = petInfo.lv + 1
          DataModel.lvFavorMax = DataModel.GetNextLevelFavor(petInfo.lv)
          if petInfo.lv == DataModel.maxLevel then
            petInfo.favor = DataModel.lvFavorMax
          end
          DataModel.GetServerPetData()[DataModel.pet_uid].lv = petInfo.lv
          while petInfo.favor >= DataModel.lvFavorMax and petInfo.lv < DataModel.maxLevel do
            petInfo.favor = petInfo.favor - DataModel.lvFavorMax
            petInfo.lv = petInfo.lv + 1
            DataModel.lvFavorMax = DataModel.GetNextLevelFavor(petInfo.lv)
            if petInfo.lv == DataModel.maxLevel then
              petInfo.favor = DataModel.lvFavorMax
            end
            DataModel.GetServerPetData()[DataModel.pet_uid].lv = petInfo.lv
          end
          View.Group_PetScore.Txt_:SetText(DataModel.CalPetScores(petInfo))
        else
          View.Group_PetInfo.Group_Effect1:SetActive(true)
          local start_value = (petInfo.favor - addLove) / DataModel.lvFavorMax
          local end_value = petInfo.favor / DataModel.lvFavorMax
          DataModel.tween = DOTweenTools.DoImgProgressbar(View.Group_PetInfo.Group_Love.Img_LoveBar, start_value, end_value, 0.5, function()
            DataModel.tween = nil
          end)
        end
        DataModel.GetServerPetData()[DataModel.pet_uid].feed = petInfo.feed
        DataModel.GetServerPetData()[DataModel.pet_uid].favor = petInfo.favor
        foodData.num = foodData.num - 1
        PlayerData:GetGoodsById(foodData.id).num = foodData.num
        local txtNum = btn.transform.parent:Find("Txt_Num"):GetComponent(typeof(CS.Seven.UITxt))
        txtNum:SetText(foodData.num)
        View.Group_PetInfo.Btn_Feed.Txt_:SetText(string.format(GetText(80601071), DataModel.feedMax - petInfo.feed, DataModel.feedMax))
        local data = DataModel.GetServerPetData()[DataModel.pet_uid]
        View.Group_PetInfo.Group_Love.Txt_LoveLevel:SetText("LV " .. data.lv)
        local nowLvFavor = data.favor
        View.Group_PetInfo.Group_Love.Txt_Love:SetText(string.format("%d/%d", nowLvFavor, DataModel.lvFavorMax))
        View.Group_PetInfo.Group_Love.Img_LoveBar:SetFilledImgAmount(nowLvFavor / DataModel.lvFavorMax)
        local ani_name = DataModel.GetPetAniName(2)
        View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(ani_name, false, true, function()
          View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(DataModel.GetPetAniName(1), true)
        end)
        local nowPetInfo = json.pet[DataModel.pet_uid]
        local count = 0
        for k, v in pairs(nowPetInfo.buff_list) do
          if petInfo.buff_list[k] == nil then
            count = count + 1
          end
        end
        if 0 < count then
          petInfo.buff_list = nowPetInfo.buff_list
          UpdateTieInfo()
        end
      end, DataModel.pet_uid, param)
    else
      CommonTips.OpenTips(80601050)
    end
  end,
  PetInfo_Group_PetView_Group_Pet_Group_State_Group_Good_Btn__Click = function(btn, str)
  end,
  PetInfo_Group_PetView_Group_Pet_Btn_ClickPet_Click = function(btn, str)
    if not DataModel.is_random then
      local ani_name = DataModel.GetPetAniName(3)
      if ani_name then
        View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(ani_name, false, true, function()
          View.Group_PetView.Group_Pet.SpineAnimation_:SetAction(DataModel.GetPetAniName(1), true)
        end)
      end
    end
  end,
  PetInfo_Group_PetInfo_Btn_Fondle_Click = function(btn, str)
    OpenSnack()
  end,
  UpdateTieInfo = UpdateTieInfo,
  UpdatePetInfo = UpdatePetInfo
}
return ViewFunction
