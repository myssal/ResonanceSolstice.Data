local Timer = require("Common/Timer")
local View = require("UIShowCharacter/UIShowCharacterView")
local DataModel = require("UIShowCharacter/UIShowCharacterDataModel")
local ViewFunction = require("UIShowCharacter/UIShowCharacterViewFunction")
local Controller = require("UIShowCharacter/UIShowCharacterController")

local function PlaySound()
  if DataModel.unitView.gachaVoice > 0 then
    DataModel.Sound = SoundManager:CreateSound(DataModel.unitView.gachaVoice)
    if DataModel.Sound ~= nil then
      DataModel.Sound:Play()
    end
  end
end

local function ShowExtraReward()
  if DataModel.poolId ~= nil then
    local rewardList = {}
    if #DataModel.detail.breakthroughList - 1 <= 2 + PlayerData:GetGoodsById(DataModel.detail.rewardList[1].id).num then
      rewardList[#rewardList + 1] = {
        id = DataModel.detail.decomposeRewardList[1].id,
        num = DataModel.detail.decomposeRewardList[1].num,
        way = 1
      }
    elseif not DataModel.CurrCard.isNew then
      rewardList[#rewardList + 1] = {
        id = DataModel.detail.rewardList[1].id,
        num = DataModel.detail.rewardList[1].num,
        way = 1
      }
    end
    local poolCA = PlayerData:GetFactoryData(DataModel.poolId)
    if poolCA ~= nil and #poolCA.extraRewardsList > 0 then
      rewardList[#rewardList + 1] = {
        id = poolCA.extraRewardsList[1].id,
        num = poolCA.extraRewardsList[1].num,
        way = 2
      }
    end
    DataModel.extraList = rewardList
    if 0 < #rewardList then
      View.Group_Reward.StaticGrid_List.self:SetActive(true)
      View.Group_Reward.StaticGrid_List.grid.self:SetDataCount(#rewardList)
      View.Group_Reward.StaticGrid_List.grid.self:RefreshAllElement()
    end
  end
end

local function SetSkipReady()
  View.Btn_BG:SetActive(true)
end

local function Show2nd(anim)
  View.self:PlayAnimCallBack(anim, function()
    SetSkipReady()
  end)
end

local function HasGachaVideo(unitView)
  return unitView ~= nil and unitView.gachaVideoUzl ~= nil and unitView.gachaVideoUzl ~= ""
end

local function EnsureVideoSkipButton()
  local video = View.Group_Spine2.Video_Gacha.self
  local button = video.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Button))
  if button == nil then
    button = video.gameObject:AddComponent(typeof(CS.UnityEngine.UI.Button))
  end
  local bindingFlags = debug.getmetatable(CS.System.Reflection.BindingFlags.Instance).__bor(CS.System.Reflection.BindingFlags.Instance, CS.System.Reflection.BindingFlags.NonPublic)
  local skipButtonField = typeof(CS.Seven.UIVideo):GetField("_skipBtn", bindingFlags)
  if skipButtonField ~= nil then
    skipButtonField:SetValue(video, button)
  end
  video.isSkip = true
  button.enabled = false
end

local function PlayGroupSpine2Video(unitView, callback)
  EnsureVideoSkipButton()
  View.Group_Spine2.SpineSecondMode_Character:SetActive(false)
  View.Group_Spine2.Video_Gacha.self:SetActive(true)
  View.Group_Spine2.Video_Gacha.self:Play(unitView.gachaVideoUzl, false, false, true, function()
    if callback ~= nil then
      callback()
    end
  end)
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Group_Spine.SpineAnimation_Character:ReleaseRes()
    View.Group_Spine.SpineAnimation_Character:SetActive(false)
    View.Group_Spine2.Video_Gacha.self:SetActive(false)
    View.Group_Spine2:SetActive(false)
    View.Group_Effect:SetActive(false)
    View.self:SetRaycastBlock(true)
    View.self:PlayAnim("end")
    DataModel.isReady = false
    Controller:InitView(initParams)
    View.self:StartC(LuaUtil.cs_generator(function()
      View.Group_Info.Img_Camp:SetActive(false)
      View.Group_Quality.Img_Camp:SetActive(false)
      View.Img_Black:SetActive(true)
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
      View.Group_Chuxian.Group_R.Group_R:SetActive(true)
      View.Group_Chuxian.Group_SR.Group_SR:SetActive(true)
      View.Group_Chuxian.Group_SSR.Group_SSR:SetActive(true)
      View.Group_Guang.Group_R.Group_R:SetActive(true)
      View.Group_Guang.Group_SR.Group_SR:SetActive(true)
      View.Group_Guang.Group_SSR.Group_SSR:SetActive(true)
      View.Group_Quality.Img_Camp:SetActive(true)
      View.Group_Info.Img_Camp:SetActive(true)
      View.Group_Effect:SetActive(true)
      DataModel.AnimIndex = DataModel.AnimIndex + 1
      local data = Json.decode(initParams)
      local aniPlus = ""
      DataModel.Type = data.type
      DataModel.Index = data.index
      DataModel.Cards = data.cards
      DataModel.GoBackState = data.goBackState == nil and true or false
      DataModel.poolId = data.poolId
      if data.material then
        DataModel.Reward = data.material
        DataModel.ShowItem = 1
      else
        DataModel.ShowItem = 0
        DataModel.Reward = nil
      end
      DataModel.CurrCard = DataModel.Cards[DataModel.Index]
      View.Group_Info.Img_New:SetActive(DataModel.CurrCard.isNew)
      if DataModel.Type == EnumDefine.DrawCard.One and DataModel.isSkip == true and DataModel.CurrCard.isNew == false then
        aniPlus = "2"
      end
      if DataModel.Type == EnumDefine.DrawCard.One or #DataModel.Cards == DataModel.Index then
        View.Btn_Skip.self:SetActive(false)
      else
        View.Btn_Skip.self:SetActive(true)
      end
      local detail = PlayerData:GetFactoryData(DataModel.CurrCard.id, "UnitFactory")
      DataModel.detail = detail
      View.Img_Bottom:SetSprite("UI\\ShowCharacter\\showcharacter_bg_rarity0" .. detail.qualityInt)
      View.Group_Info.Txt_Name:SetText(detail.name)
      local fileCA = PlayerData:GetFactoryData(detail.fileList[1].file)
      local nowLanguage = GameSetting.currentSVLanguage == "zh" and 1 or 2
      View.Group_Info.Txt_Name.Txt_CV.Txt_:SetText(fileCA["CvName" .. nowLanguage])
      View.Txt_Lines:SetText(detail.getCharacter)
      local tagCA = PlayerData:GetFactoryData(detail.sideId)
      View.Group_Info.Img_Camp:SetSprite(tagCA.icon)
      View.Group_Quality.Img_Camp:SetSprite(tagCA.icon)
      if detail.qualityInt < 4 then
        View.Group_Quality.Img_Camp_SSR:SetSprite(tagCA.gachaSRPath)
      else
        View.Group_Quality.Img_Camp_SSR:SetSprite(tagCA.gachaSSRPath)
      end
      View.Group_Info.Img_Rairty:SetSprite(UIConfig.RoleQuality[detail.qualityInt])
      View.Group_Spine2.SpineSecondMode_Character:SetLocalScale(Vector3(1, 1, 1))
      local unitView = PlayerData:GetFactoryData(detail.viewId, "UnitViewFactory")
      DataModel.unitView = unitView
      local spineUrl = Controller:GetSpineUrl(unitView)
      if unitView.spineUrl ~= "" then
        View.Group_Character.Img_Character:SetActive(false)
        View.Group_Character.Spine_Character:SetActive(true)
        View.Group_Character.Spine_Character:SetData(unitView.spineUrl)
        View.Group_Character.Img_Character.Img_Character:SetSprite(unitView.resUrl)
      else
        View.Group_Character.Img_Character:SetActive(true)
        View.Group_Character.Img_Character.Img_Character:SetSprite(unitView.resUrl)
        View.Group_Character.Spine_Character:SetActive(false)
        if DataModel.InitPos.isRecord then
          DataModel.InitPos.isRecord = false
          local transform = View.Group_Character.Img_Character.Img_Character.transform
          DataModel.InitPos.x = transform.localPosition.x
          DataModel.InitPos.y = transform.localPosition.y
          DataModel.InitPos.scale = transform.localScale.x
        end
        local pos = DataModel.InitPos
        local posX = pos.x + unitView.offsetX * pos.scale
        local posY = pos.y + unitView.offsetY * pos.scale
      end
      local bgOffsetX = unitView.gachaX or 0
      local bgOffsetY = unitView.gachaY or 0
      View.Group_Reward.StaticGrid_List.self:SetActive(false)
      ShowExtraReward()
      if View.timer_2 == nil then
        View.timer_2 = Timer.New(1, function()
          PlaySound()
          View.timer_2:Pause()
        end, nil, nil, true)
      end
      if detail.qualityInt < 3 then
        View.Group_Spine.SpineAnimation_Character:SetActive(false)
        View.Img_BG:SetActive(true)
        View.self:PlayAnimCallBack("R" .. aniPlus, function()
          SetSkipReady()
        end)
        View.timer_2.delay = DataModel.AnimatorDelayList["R" .. aniPlus] or 1
        View.timer_2:Start()
      elseif detail.qualityInt < 4 then
        if unitView.gachaSpine2Url ~= "" then
          View.Group_Spine.SpineAnimation_Character:SetData(unitView.gachaSpine2Url)
          View.Group_Spine.SpineAnimation_Character:SetGray()
          View.Group_Spine.SpineAnimation_Character.transform.localPosition = Vector3(bgOffsetX, bgOffsetY, 0)
          View.Group_Spine.SpineAnimation_Character:SetActive(true)
          View.Img_BG:SetActive(false)
          if spineUrl ~= "" then
            if HasGachaVideo(unitView) then
              View.Group_Spine2.self:SetActive(true)
              PlayGroupSpine2Video(unitView)
              View.self:PlayAnimCallBack("NewSR_J2" .. aniPlus, function()
                SetSkipReady()
              end)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSR_J2" .. aniPlus] or 1
              View.timer_2:Start()
            else
              View.Group_Spine2.Video_Gacha.self:SetActive(false)
              View.Group_Spine2.SpineSecondMode_Character:SetActive(true)
              View.Group_Spine2.SpineSecondMode_Character:SetPrefab(spineUrl)
              View.Group_Spine2.SpineSecondMode_Character:SetAction("perform", false, true)
              View.Group_Spine2.SpineSecondMode_Character:SetActiveAllEffects()
              View.Group_Spine2.self:SetActive(true)
              if unitView.state2Overturn == true then
                View.Group_Spine2.SpineSecondMode_Character:SetLocalScale(Vector3(-1, 1, 1))
              end
              View.self:PlayAnimCallBack("NewSR_J2" .. aniPlus, function()
                SetSkipReady()
              end)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSR_J2" .. aniPlus] or 1
              View.timer_2:Start()
            end
          else
            View.Group_Spine2.self:SetActive(false)
            View.self:PlayAnimCallBack("SR_J2" .. aniPlus, function()
              SetSkipReady()
            end)
            View.timer_2.delay = DataModel.AnimatorDelayList["SR_J2" .. aniPlus] or 1
            View.timer_2:Start()
          end
        else
          View.Group_Spine.SpineAnimation_Character:SetActive(false)
          View.Img_BG:SetActive(true)
          View.self:PlayAnimCallBack("SR" .. aniPlus, function()
            SetSkipReady()
          end)
          View.timer_2.delay = DataModel.AnimatorDelayList["SR" .. aniPlus] or 1
          View.timer_2:Start()
        end
      elseif unitView.gachaSpine2Url ~= "" then
        View.Group_Spine.SpineAnimation_Character:SetData(unitView.gachaSpine2Url)
        View.Group_Spine.SpineAnimation_Character:SetGray()
        View.Group_Spine.SpineAnimation_Character.transform.localPosition = Vector3(bgOffsetX, bgOffsetY, 0)
        View.Group_Spine.SpineAnimation_Character:SetActive(true)
        View.Img_BG:SetActive(false)
        if spineUrl ~= "" then
          View.Group_Spine2.self:SetActive(true)
          if HasGachaVideo(unitView) then
            if aniPlus == "" then
              View.self:PlayAnim("NewSSR_J2")
              PlayGroupSpine2Video(unitView, function()
                Show2nd("NewSSR_J2_2nd")
              end)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSSR_J2_2nd" .. aniPlus] or 1
            else
              View.self:PlayAnimCallBack("NewSSR_J2" .. aniPlus, function()
                SetSkipReady()
              end)
              PlayGroupSpine2Video(unitView)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSSR_J2" .. aniPlus] or 1
            end
          else
            View.Group_Spine2.Video_Gacha.self:SetActive(false)
            View.Group_Spine2.SpineSecondMode_Character:SetActive(true)
            View.Group_Spine2.SpineSecondMode_Character:SetPrefab(spineUrl)
            if aniPlus == "" then
              View.self:PlayAnim("NewSSR_J2")
              View.Group_Spine2.SpineSecondMode_Character:SetAction("perform", false, true, function()
                Show2nd("NewSSR_J2_2nd")
              end)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSSR_J2_2nd" .. aniPlus] or 1
            else
              View.self:PlayAnimCallBack("NewSSR_J2" .. aniPlus, function()
                SetSkipReady()
              end)
              View.Group_Spine2.SpineSecondMode_Character:SetAction("perform", false, true)
              View.timer_2.delay = DataModel.AnimatorDelayList["NewSSR_J2" .. aniPlus] or 1
            end
            View.Group_Spine2.SpineSecondMode_Character:SetActiveAllEffects()
            View.Group_Spine2.self:SetActive(true)
            if unitView.state2Overturn == true then
              View.Group_Spine2.SpineSecondMode_Character:SetLocalScale(Vector3(-1, 1, 1))
            end
          end
          View.timer_2:Start()
        else
          View.Group_Spine2.self:SetActive(false)
          View.self:PlayAnimCallBack("SSR_J2" .. aniPlus, function()
            SetSkipReady()
          end)
          View.timer_2.delay = DataModel.AnimatorDelayList["SSR_J2" .. aniPlus] or 1
          View.timer_2:Start()
        end
      else
        View.Group_Spine.SpineAnimation_Character:SetActive(false)
        View.Img_BG:SetActive(true)
        View.self:PlayAnimCallBack("SSR" .. aniPlus, function()
          SetSkipReady()
        end)
        View.timer_2.delay = DataModel.AnimatorDelayList["SSR" .. aniPlus] or 1
        View.timer_2:Start()
      end
      if DataModel.Type == EnumDefine.DrawCard.One and DataModel.isSkip == true and DataModel.CurrCard.isNew == false then
      else
        ViewFunction.PlaySound(detail.qualityInt)
      end
      DataModel.isReady = true
      View.Btn_BG:SetActive(true)
      if DataModel.CurrCard.isNew == true then
        View.Btn_BG:SetActive(false)
      end
    end))
  end,
  awake = function()
    View.timer_2 = Timer.New(1, function()
      PlaySound()
      View.timer_2:Pause()
    end, nil, nil, true)
  end,
  start = function()
  end,
  update = function()
    if View.timer_2 then
      View.timer_2:Update()
    end
  end,
  ondestroy = function()
    if View.timer_2 then
      View.timer_2:Stop()
      View.timer_2 = nil
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
