local View = require("UITrainSound/UITrainSoundView")
local DataModel = require("UITrainSound/UITrainSoundDataModel")
local Controller = require("UITrainSound/UITrainSoundController")
local NotUsingColor = {wave = "#000000", playSoundBtn = "#B2B3B2"}
local UsingColor = {wave = "#FFFFFF", playSoundBtn = "#C88B00"}
local ViewFunction = {
  TrainSound_Group_SoundList_ScrollGrid_SoundList_SetGrid = function(element, elementIndex)
    local data = DataModel.AllList[elementIndex]
    if data == nil then
      return
    end
    local CurUsingSound = tonumber(PlayerData:GetHomeInfo().train_sound) or 88100001
    local isUsing = data.Cfg.id == CurUsingSound
    element.Img_Bg:SetActive(not isUsing)
    element.Img_BgUsing:SetActive(isUsing)
    element.Txt_Name:SetText(data.Cfg.soundName)
    element.Btn_Use:SetClickParam(elementIndex)
    element.Btn_Use:SetActive(not isUsing)
    element.Img_Using:SetActive(isUsing)
    element.Group_Progress.Img_Bg:SetActive(isUsing)
    element.Group_Progress.Slider_Wave.Group_Fill:SetActive(isUsing)
    DataModel.Sliders[elementIndex] = element.Group_Progress.Slider_Wave
    element.Group_Progress.Slider_Wave.Img_Bg:SetColor(isUsing and UsingColor.wave or NotUsingColor.wave)
    element.Btn_Play:SetColor(isUsing and UsingColor.playSoundBtn or NotUsingColor.playSoundBtn)
    element.Btn_Play:SetClickParam(elementIndex)
    element.Btn_Play:SetActive(elementIndex ~= DataModel.CurPlaying or DataModel.IsPause)
    element.Btn_Stop:SetColor(isUsing and UsingColor.playSoundBtn or NotUsingColor.playSoundBtn)
    element.Btn_Stop:SetActive(elementIndex == DataModel.CurPlaying and not DataModel.IsPause)
    element.Group_Lock.self:SetActive(data.Unlock == 0)
    element.Group_Lock.Btn_UnLock:SetClickParam(elementIndex)
  end,
  TrainSound_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  TrainSound_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  TrainSound_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  TrainSound_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Group_Lock_Btn_UnLock_Click = function(btn, str)
    local index = tonumber(str)
    if index == nil then
      return
    end
    local data = DataModel.AllList[index]
    if data == nil then
      return
    end
    local cfg = data.Cfg
    View.Group_UnLock.Group_Prompt.TextIcon_Prompt:SetText(string.format(GetText(80608801), cfg.soundName))
    DataModel.UnlockMoenyEnough = nil
    DataModel.UnlockSoundID = nil
    DataModel.UnlockCostID = nil
    DataModel.UnlockCostCount = nil
    if cfg.unLockCost and #cfg.unLockCost > 0 then
      local costData = cfg.unLockCost[1]
      local itemCfg = GetCA(costData.id)
      View.Group_UnLock.Group_Gold.Img_:SetSprite(itemCfg.buyPath)
      View.Group_UnLock.Group_Gold.Txt_Num:SetText(costData.num)
      DataModel.UnlockMoenyEnough = PlayerData:GetGoodsById(costData.id).num >= costData.num
      DataModel.UnlockSoundID = cfg.id
      DataModel.UnlockCostID = costData.id
      DataModel.UnlockCostCount = costData.num
      DataModel.UnlockSoundName = cfg.soundName
    end
    View.Group_UnLock:SetActive(true)
  end,
  TrainSound_Group_UnLock_Btn_BG_Click = function(btn, str)
    DataModel.UnlockMoenyEnough = nil
    DataModel.UnlockSoundID = nil
    DataModel.UnlockCostID = nil
    DataModel.UnlockCostCount = nil
    View.Group_UnLock:SetActive(false)
  end,
  TrainSound_Group_UnLock_Btn_Cancel_Click = function(btn, str)
    DataModel.UnlockMoenyEnough = nil
    DataModel.UnlockSoundID = nil
    DataModel.UnlockCostID = nil
    DataModel.UnlockCostCount = nil
    View.Group_UnLock:SetActive(false)
  end,
  TrainSound_Group_UnLock_Btn_Confirm_Click = function(btn, str)
    if DataModel.UnlockMoenyEnough == nil or DataModel.UnlockSoundID == nil then
      logError("\230\149\176\230\141\174\229\135\186\233\148\153!")
      View.Group_UnLock:SetActive(false)
      return
    end
    if not DataModel.UnlockMoenyEnough then
      CommonTips.OpenTips(80608802)
      View.Group_UnLock:SetActive(false)
      return
    end
    Net:SendProto("home.unlock_sound", function(json)
      DataModel.UnlockTrainSound(DataModel.UnlockSoundID)
      DataModel.SaveToLocal(DataModel.UnlockSoundID)
      Controller.ShowUnlockSuccess(DataModel.UnlockSoundName)
      DataModel.UnlockSoundName = nil
      DataModel.UnlockMoenyEnough = nil
      DataModel.UnlockSoundID = nil
      DataModel.UnlockCostID = nil
      DataModel.UnlockCostCount = nil
      View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
      View.Group_UnLock:SetActive(false)
    end, DataModel.UnlockSoundID)
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Btn_Use_Click = function(btn, str)
    local data = DataModel.AllList[tonumber(str) or 0]
    if data ~= nil then
      local selectId = data.Cfg.id
      Net:SendProto("home.switch_sound", function(json)
        PlayerData:GetHomeInfo().train_sound = tostring(selectId)
        Controller.ShowCurrent()
        View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
      end, data.Cfg.id)
    else
    end
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Group_Progress_Slider_Wave_Slider = function(slider, value)
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Group_Progress_Slider_Wave_SliderDown = function(slider)
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Group_Progress_Slider_Wave_SliderUp = function(slider)
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Btn_Play_Click = function(btn, str)
    local index = tonumber(str)
    if index == nil then
      return
    end
    if DataModel.CurPlaying == nil or DataModel.CurPlaying ~= index then
      if DataModel.CurPlaySound then
        DataModel.CurPlaySound:Stop()
        DataModel.Sliders[DataModel.CurPlaying]:SetSliderValue(0)
      end
      local data = DataModel.AllList[index]
      if data and data.Cfg then
        DataModel.CurPlaySound = SoundManager:CreateSound(data.Cfg.tryListenId)
        if DataModel.CurPlaySound then
          DataModel.CurPlaySound:Play()
        end
      end
    elseif DataModel.CurPlaying == index and DataModel.CurPlaySound then
      DataModel.CurPlaySound:Pause(false)
    end
    DataModel.IsPause = false
    DataModel.CurPlaying = index
    View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
  end,
  TrainSound_Group_SoundList_ScrollGrid_SoundList_Group_Item_Btn_Stop_Click = function(btn, str)
    if DataModel.CurPlaySound then
      DataModel.CurPlaySound:Pause(true)
    end
    DataModel.IsPause = true
    View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
  end
}
return ViewFunction
