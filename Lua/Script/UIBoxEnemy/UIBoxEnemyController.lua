local DataModel = require("UIBoxEnemy/UIBoxEnemyDataModel")
local View = require("UIBoxEnemy/UIBoxEnemyView")
local BtnItem = require("Common/BtnItem")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local Controller = {}

function Controller.Init()
  View.Img_RightBG.Img_FightRewards:SetSprite(GetResPath(88300169))
  DataModel.addLevel = 0
  Controller.HideAllAngerEffects()
  Controller.RefreshContentShow()
  Controller.PlayBossInSound()
end

function Controller.Release()
end

function Controller.PlayBossInSound()
  local sound = SoundManager:CreateSound(30006353)
  if sound then
    sound:Play()
  end
end

function Controller.PlayAngrySound()
  local sound = SoundManager:CreateSound(30006362)
  if sound then
    sound:Play()
  end
end

function Controller.HideAllAngerEffects()
  local eventInfo = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  if not eventInfo.angerEffects or #eventInfo.angerEffects == 0 then
    return
  end
  for i = 1, #eventInfo.angerEffects do
    local info = eventInfo.angerEffects[i]
    if info then
      local effect = View.self.transform:Find(info.object)
      if effect then
        effect.gameObject:SetActive(false)
      end
    end
  end
end

function Controller.RefreshContentShow()
  local eventInfo = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  View.Img_RightBG.Img_Info.Txt_Name:SetText(eventInfo.boxName)
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetData(eventInfo.boxSpine, "")
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetAction(eventInfo.boxStand, true)
  local addLv = eventInfo.addLv or 1
  local maxLv = eventInfo.boxLvLitmit or 0
  local bossLv, isMax = DataModel.GetBossLevel()
  if isMax then
    View.Img_LeftBG.Btn_Provoke.Img_Mask:SetActive(true)
    View.Img_LeftBG.Btn_Provoke.Txt_:SetActive(false)
  else
    View.Img_LeftBG.Btn_Provoke.Img_Mask:SetActive(false)
    View.Img_LeftBG.Btn_Provoke.Txt_:SetActive(true)
  end
  View.Img_LeftBG.Img_Pedestal.Group_Live.Img_.Txt_:SetText(string.format(GetText(80609804), addLv))
  View.Img_RightBG.Img_Info.Img_Lv.Txt_LV:SetText(string.format(GetText(80609744), bossLv))
  local lvItem = eventInfo.addLvItem
  lvItem = lvItem or {}
  if lvItem[1] then
    DataModel.costItemId = lvItem[1].id
    DataModel.levelOnceAddCostNum = lvItem[1].num
    local itemData = PlayerData:GetFactoryData(DataModel.costItemId, "SourceMaterialFactory")
    if itemData then
      View.Img_LeftBG.Btn_Provoke.Img_:SetSprite(itemData.iconPath)
      DataModel.maxShowLevel = math.ceil((maxLv - bossLv) / addLv) or 0
      Controller.RefreshCostTxtShow()
      View.Group_Provoke.Group_Num.Group_Slider.Slider_Value:SetMinAndMaxValue(0, DataModel.maxShowLevel)
      Controller.RefreshSliderValue()
    end
  end
  local idList = {}
  local levelInfo = PlayerData:GetFactoryData(eventInfo.boxLevel, "LevelFactory")
  if levelInfo then
    View.Img_RightBG.Img_TxtBG.Txt_Des:SetText(levelInfo.description)
    if levelInfo.dropTableList then
      for i = 1, #levelInfo.dropTableList do
        table.insert(idList, levelInfo.dropTableList[i].listId)
      end
    end
  end
  local lvReward = eventInfo.lvRewards or {}
  for i = #lvReward, 1, -1 do
    if bossLv >= lvReward[i].lv then
      table.insert(idList, lvReward[i].reward)
      break
    end
  end
  local rewardList = {}
  for i = 1, #idList do
    local cfg = PlayerData:GetFactoryData(idList[i], "ListFactory")
    if cfg then
      if cfg.rewardList then
        for j = 1, #cfg.rewardList do
          table.insert(rewardList, cfg.rewardList[j])
        end
      end
      if cfg.leveldropList then
        for j = 1, #cfg.leveldropList do
          table.insert(rewardList, cfg.leveldropList[j])
        end
      end
    end
  end
  DataModel.rewardList = rewardList
  if 0 < #rewardList then
    View.Img_RightBG.Img_FightRewards:SetActive(true)
    View.Img_RightBG.Img_FightRewards.ScrollGrid_Reward.grid.self:SetDataCount(#rewardList)
    View.Img_RightBG.Img_FightRewards.ScrollGrid_Reward.grid.self:RefreshAllElement()
  else
    View.Img_RightBG.Img_FightRewards:SetActive(false)
  end
end

function Controller.RefreshFightRewardElement(element, elementIndex)
  local rewList = DataModel.rewardList or {}
  if rewList[elementIndex] then
    BtnItem:SetItem(element.Group_Item, {
      id = rewList[elementIndex].id
    })
    element.Group_Item.Btn_Item:SetClickParam(rewList[elementIndex].id)
  end
end

function Controller.RefreshCostTxtShow()
  View.Group_Provoke.Group_Num.Group_Slider.Group_Num.Txt_Select:SetText(tostring(DataModel.addLevel))
  View.Group_Provoke.Group_Num.Group_Slider.Group_Num.Txt_Possess:SetText(tostring(DataModel.maxShowLevel))
  View.Group_Provoke.Img_BG.Img_SourceItem.Btn_Item:SetClickParam(DataModel.costItemId)
  View.Group_Provoke.Img_BG.Img_SourceItem.Txt_Num:SetText(tostring(DataModel.addLevel * DataModel.levelOnceAddCostNum) .. "/" .. tostring(PlayerData:GetGoodsById(DataModel.costItemId).num or 0))
end

function Controller.RefreshSliderValue()
  View.Group_Provoke.Group_Num.Group_Slider.Slider_Value:SetSliderValue(DataModel.addLevel)
end

function Controller.CheckMPYIsOver(json)
  MonopolyManager.CheckTimeIsOverAndBack()
end

return Controller
