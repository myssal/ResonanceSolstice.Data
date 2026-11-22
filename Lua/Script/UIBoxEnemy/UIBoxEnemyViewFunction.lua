local View = require("UIBoxEnemy/UIBoxEnemyView")
local DataModel = require("UIBoxEnemy/UIBoxEnemyDataModel")
local Controller = require("UIBoxEnemy/UIBoxEnemyController")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")

local function stopAllEffectCts()
  if DataModel.effectCoroutines then
    for i = 1, #DataModel.effectCoroutines do
      View.self:StopC(DataModel.effectCoroutines[i])
    end
  end
  DataModel.effectCoroutines = {}
end

local ViewFunction = {
  BoxEnemy_Img_LeftBG_Btn_Provoke_Click = function(btn, str)
    local lv, isMax = DataModel.GetBossLevel()
    if isMax then
      CommonTips.OpenTips(80609499)
      return
    end
    View.Group_Provoke:SetActive(true)
    View.self:PlayAnim("Group_Provoke")
  end,
  BoxEnemy_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller.RefreshFightRewardElement(element, elementIndex)
  end,
  BoxEnemy_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  BoxEnemy_Img_RightBG_Btn_Fight_Click = function(btn, str)
    if DataModel.isFightCDIng then
      CommonTips.OpenTips(80609531)
      return
    end
    local eventInfo = PlayerData:GetFactoryData(tonumber(DataModel.eventId), "MonopolyEventFactory")
    if not eventInfo then
      return
    end
    if not MonopolyManager.GetFightNumIsEnough() then
      CommonTips.OpenTips(80609500)
      return
    end
    
    local function cbSuccess(json)
      if string.nilorempty(json.rc) then
        if json.box_info and json.box_info.attach_ti then
          local curTime = TimeUtil:GetServerTimeStamp() or 0
          local offsetTime = curTime - json.box_info.attach_ti
          if offsetTime <= eventInfo.levelTime then
            CommonTips.OpenTips(80609531)
            local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
            if monopolyInfo then
              DataModel.isFightCDIng = true
              View.self:StartC(LuaUtil.cs_generator(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(monopolyInfo.clickLimit))
                DataModel.isFightCDIng = false
              end))
            end
            return
          end
        end
        local status = {
          levelId = eventInfo.boxLevel,
          gridId = DataModel.gridId,
          Current = "Monopoly",
          extraUIParamData = {scene = "Monopoly"}
        }
        PlayerData.BattleCallBackPage = "UI/Monopoly/Monopoly"
        UIManager:Open("UI/Squads/Squads", Json.encode(status))
      end
    end
    
    local function cbFail(json)
      if json and not string.nilorempty(json) then
        Controller.CheckMPYIsOver()
      end
      UIManager:ClosePanel()
      MonopolyManager.SetFightNumIsMax()
      if DataModel.isInit then
        MonopolyManager.InitEventDialog()
      elseif DataModel.dialogEvent then
        MonopolyManager.DoDialogEvent(DataModel.gridId, DataModel.dialogEvent)
      end
    end
    
    Net:SendProto("monopoly.deal_box", cbSuccess, 0, cbFail)
  end,
  BoxEnemy_Img_RightBG_Btn_GiveUp_Click = function(btn, str)
    View.Group_GivUp:SetActive(true)
    View.self:PlayAnim("Group_GivUp")
  end,
  BoxEnemy_Group_Provoke_Group_Num_Btn_Min_Click = function(btn, str)
    DataModel.addLevel = 0
    Controller.RefreshCostTxtShow()
    Controller.RefreshSliderValue()
  end,
  BoxEnemy_Group_Provoke_Group_Num_Btn_Dec_Click = function(btn, str)
    DataModel.addLevel = DataModel.addLevel - 1
    DataModel.addLevel = DataModel.addLevel < 0 and 0 or DataModel.addLevel
    Controller.RefreshCostTxtShow()
    Controller.RefreshSliderValue()
  end,
  BoxEnemy_Group_Provoke_Group_Num_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel.addLevel = math.floor(value)
    Controller.RefreshCostTxtShow()
  end,
  BoxEnemy_Group_Provoke_Group_Num_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  BoxEnemy_Group_Provoke_Group_Num_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  BoxEnemy_Group_Provoke_Group_Num_Btn_Add_Click = function(btn, str)
    DataModel.addLevel = DataModel.addLevel + 1
    DataModel.maxShowLevel = DataModel.maxShowLevel or 0
    DataModel.addLevel = DataModel.addLevel > DataModel.maxShowLevel and DataModel.maxShowLevel or DataModel.addLevel
    Controller.RefreshCostTxtShow()
    Controller.RefreshSliderValue()
  end,
  BoxEnemy_Group_Provoke_Group_Num_Btn_Max_Click = function(btn, str)
    DataModel.maxShowLevel = DataModel.maxShowLevel or 0
    DataModel.addLevel = DataModel.maxShowLevel
    Controller.RefreshCostTxtShow()
    Controller.RefreshSliderValue()
  end,
  BoxEnemy_Group_Provoke_Btn_Cancel_Click = function(btn, str)
    View.Group_Provoke:SetActive(false)
  end,
  BoxEnemy_Group_Provoke_Btn_Use_Click = function(btn, str)
    local lv, isMax = DataModel.GetBossLevel()
    if isMax then
      CommonTips.OpenTips(80609499)
    else
      if DataModel.addLevel == 0 then
        CommonTips.OpenTips(80609532)
        return
      end
      local hasCount = PlayerData:GetGoodsById(DataModel.costItemId).num or 0
      local costNum = DataModel.levelOnceAddCostNum * DataModel.addLevel
      if hasCount < costNum then
        CommonTips.OpenTips(80600010)
      else
        Net:SendProto("monopoly.add_degree", function(json)
          if string.nilorempty(json.rc) then
            View.Group_Provoke:SetActive(false)
            PlayerData:RefreshUseItems({
              [DataModel.costItemId] = costNum
            })
            local eventInfo = PlayerData:GetFactoryData(DataModel.eventId, "MonopolyEventFactory")
            if eventInfo then
              View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetAction(eventInfo.boxAnger, true, true)
              Controller.PlayAngrySound()
              if eventInfo.angerEffects then
                stopAllEffectCts()
                Controller.HideAllAngerEffects()
                for i = 1, #eventInfo.angerEffects do
                  local info = eventInfo.angerEffects[i]
                  if info then
                    do
                      local effect = View.self.transform:Find(info.object)
                      if effect then
                        if info.time > 0 then
                          local effectCt = View.self:StartC(LuaUtil.cs_generator(function()
                            coroutine.yield(CS.UnityEngine.WaitForSeconds(info.time))
                            effect.gameObject:SetActive(false)
                            effect.gameObject:SetActive(true)
                          end))
                          DataModel.AddCoroutine(effectCt)
                        else
                          effect.gameObject:SetActive(false)
                          effect.gameObject:SetActive(true)
                        end
                      end
                    end
                  end
                end
              end
              local hideCt = View.self:StartC(LuaUtil.cs_generator(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(eventInfo.effectsEndTime))
                View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetAction(eventInfo.boxStand, true, true)
                if eventInfo.angerEffects then
                  Controller.HideAllAngerEffects()
                end
                stopAllEffectCts()
              end))
              DataModel.AddCoroutine(hideCt)
            end
            DataModel.difficulty = DataModel.difficulty + DataModel.addLevel
            DataModel.addLevel = 0
            Controller.RefreshContentShow()
          end
        end, DataModel.addLevel, function(json)
          if json and not string.nilorempty(json) then
            Controller.CheckMPYIsOver()
          end
        end)
      end
    end
  end,
  BoxEnemy_Group_GivUp_Btn_Cancel_Click = function(btn, str)
    View.Group_GivUp:SetActive(false)
  end,
  BoxEnemy_Group_GivUp_Btn_Confirm_Click = function(btn, str)
    Net:SendProto("monopoly.deal_box", function(json)
      if string.nilorempty(json.rc) then
        View.Group_GivUp:SetActive(false)
        UIManager:ClosePanel()
        MonopolyManager.SetFightNumIsMax()
        if DataModel.isInit then
          MonopolyManager.InitEventDialog()
        elseif DataModel.dialogEvent then
          MonopolyManager.DoDialogEvent(DataModel.gridId, DataModel.dialogEvent)
        end
      end
    end, 1, function(json)
      if json and not string.nilorempty(json) then
        Controller.CheckMPYIsOver()
      end
    end)
  end,
  BoxEnemy_Group_Provoke_Img_BG_Img_SourceItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end
}
return ViewFunction
