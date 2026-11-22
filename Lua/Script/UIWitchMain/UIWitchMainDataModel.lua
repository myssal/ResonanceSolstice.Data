local View = require("UIWitchMain/UIWitchMainView")
local DataModel = {
  mainPanel = "UI/Witches/Main/WitchMain",
  isCameraFollowPlayer = true,
  mainCamera = nil,
  defaultCameraDistance = 7,
  defaultCameraHeight = 9.5,
  defualtCameraAngleX = 45,
  defualtAxisY = 0.1,
  gridList = {},
  triggers = {},
  randomAnimFrame = 0,
  randomAnimPlayerCount = 1200,
  isInited = false,
  move_consume = -1,
  float_moveNum = -1,
  fireworkViewList = {},
  fireworkCameraMoveTime = 1,
  sealList = {},
  toWitchHouseCompleted = false,
  sealEffectWeight = {},
  SingleSealEffectList = {},
  CombineSealEffectList = {},
  SealEffectList = {},
  IsCombineEffect = false
}
DataModel.animData = {
  standList = {},
  idle = nil,
  move = nil,
  move_broom = nil,
  idle_broom = nil
}
DataModel.backSceneName = ""
DataModel.backUI = ""
DataModel.backUIParams = {}
DataModel.showTicket = 0
DataModel.bossEventId = nil
DataModel.isFireworkAnimPlaying = false

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.backSceneName = data.backSceneName
  DataModel.backUI = data.backUI
  DataModel.backUIParams = data.backUIParams
  DataModel.showTicket = data.showTicket
end

function DataModel:InitData()
  self.mainPanel = WitchData.GetUIPath("UI/Witches/Main/WitchMain")
  self.mainCamera = CS.UnityEngine.GameObject.Find("Main Camera")
  self.isCameraFollowPlayer = true
  self.randomAnimFrame = 0
  View.Group_Seal:SetActive(true)
  DataModel.InitSealEffectData()
  DataModel.bossEventId = nil
  DataModel.isFireworkAnimPlaying = false
end

function DataModel.InitSealEffectData()
  DataModel.sealEffectWeight = WitchData.GetSealEffectWeight()
  DataModel.SingleSealEffectList = {}
  DataModel.CombineSealEffectList = {}
  local singleSeal = WitchData.GetParkMapCA().singleSealList
  for i, v in ipairs(singleSeal) do
    local cfg = PlayerData:GetFactoryData(v.id)
    DataModel.SingleSealEffectList[tostring(cfg.itemId)] = tostring(v.id)
  end
  local combineSeal = WitchData.GetParkMapCA().combineSealList
  for i, v in ipairs(combineSeal) do
    local weight = 0
    local combineCfg = PlayerData:GetFactoryData(v.id)
    local combineList = combineCfg.combineSeal
    for index, seal in ipairs(combineList) do
      local effectWeight = 0
      if DataModel.sealEffectWeight and DataModel.sealEffectWeight[tostring(seal.id)] then
        effectWeight = DataModel.sealEffectWeight[tostring(seal.id)]
      end
      weight = weight + effectWeight
    end
    DataModel.CombineSealEffectList[tostring(weight)] = tostring(v.id)
  end
end

function DataModel.RefreshOnShow()
  View.Group_Stamina.Txt_Num:SetText(WitchData.GetStamina() .. "/" .. WitchData.GetStaminaMax())
  View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
  local sealData = WitchData.GetWitchesData().user_seal
  DataModel.sealList = Clone(sealData)
  DataModel.RefreshSeal()
  DataModel.RefreshTicket()
  local handbookDataModel = require("UIGuKaHandbook/UIGuKaHandbookDataModel")
  local redPoint = handbookDataModel.CheckRedPoint()
  View.Btn_Handbook.Img_RedPoint:SetActive(redPoint)
  View.Group_Buff.Btn_Tea.Group_TeaBuff:SetActive(false)
  View.Group_Seal.Group_Tips:SetActive(false)
  DataModel.CheckGuKaRedPoint()
end

function DataModel.SetSealEffectElement()
  View.Group_SealShow.Img_bg.Img_Type:SetActive(DataModel.IsCombineEffect)
  DataModel.SealEffectList = DataModel.SealEffectList or {}
  local effectCount = table.count(DataModel.SealEffectList)
  View.Group_SealShow.Img_bg.Txt_Buff1:SetActive(1 <= effectCount)
  View.Group_SealShow.Img_bg.Txt_Buff2:SetActive(2 <= effectCount)
  View.Group_SealShow.Img_bg.Txt_Buff3:SetActive(3 <= effectCount)
  local buffCfg
  if 1 <= effectCount then
    local cfg = PlayerData:GetFactoryData(DataModel.SealEffectList[1])
    buffCfg = DataModel.IsCombineEffect and PlayerData:GetFactoryData(cfg.combineSkillId) or PlayerData:GetFactoryData(cfg.skillId)
    View.Group_SealShow.Img_bg.Txt_Buff1:SetText(buffCfg.description)
    if effectCount == 1 then
      View.Group_SealShow.Img_bg.Img_Type.Txt_Type:SetText(cfg.name)
    end
  end
  if 2 <= effectCount then
    local cfg = PlayerData:GetFactoryData(DataModel.SealEffectList[2])
    buffCfg = PlayerData:GetFactoryData(cfg.skillId)
    View.Group_SealShow.Img_bg.Txt_Buff2:SetText(buffCfg.description)
  end
  if 3 <= effectCount then
    local cfg = PlayerData:GetFactoryData(DataModel.SealEffectList[3])
    buffCfg = PlayerData:GetFactoryData(cfg.skillId)
    View.Group_SealShow.Img_bg.Txt_Buff3:SetText(buffCfg.description)
  end
end

function DataModel.SetSealShowElement(element, elementIndex)
  local sealList = WitchData.GetWitchesData().user_seal or {}
  local id = sealList[elementIndex]
  element.Img_Seal:SetActive(id)
  element.Img_:SetActive(id)
  if id then
    local cfg = PlayerData:GetFactoryData(id)
    element.Img_Seal:SetSprite(cfg.iconPath)
    element.Img_.Txt_:SetText(cfg.name)
  end
end

function DataModel.SetSealElement(element, elementIndex)
  local id = DataModel.sealList[elementIndex]
  element.Img_Empty:SetActive(not id)
  element.Img_Seal:SetActive(id)
  element.transform:Find("UI_WitchMain_Loop").gameObject:SetActive(id)
  if id then
    local cfg = PlayerData:GetFactoryData(id)
    element.Img_Seal:SetSprite(cfg.iconPath)
  end
end

function DataModel.RefreshSeal()
  local maxSealCount = WitchData.GetParkMapCA().sealNumMax
  View.Group_Seal.StaticGrid_Seal.grid.self:SetDataCount(maxSealCount)
  View.Group_Seal.StaticGrid_Seal.grid.self:RefreshAllElement()
end

function DataModel.RefreshTicket(clickOpen, show)
  if clickOpen then
    DataModel.ShowTicket(show)
  else
    local showTicket = PlayerData:GetPlayerPrefs("int", "WitchShowTicket") == 0
    if showTicket then
      PlayerData:SetPlayerPrefs("int", "WitchShowTicket", 1)
    end
    DataModel.ShowTicket(showTicket)
  end
end

function DataModel.ShowTicket(show)
  View.Group_TicketShow:SetActive(show)
  if show then
    local witchesData = WitchData.GetWitchesData()
    local parkMapCA = WitchData.GetParkMapCA()
    for i, v in pairs(parkMapCA.ticketBuffList) do
      if tostring(v.id) == witchesData.ticket_id then
        View.Group_TicketShow.Img_Ticket:SetSprite(v.ticketShowPath)
        local ticketItemCA = PlayerData:GetFactoryData(v.id, "ItemFactory")
        local buffInfo = ticketItemCA.ticketBuff[1]
        if buffInfo then
          local desc = ""
          if buffInfo.buffType == "server" then
            local homeBuffCA = PlayerData:GetFactoryData(buffInfo.id, "HomeBuffFactory")
            desc = homeBuffCA.desc
          elseif buffInfo.buffType == "client" then
            local buffSkillCA = PlayerData:GetFactoryData(buffInfo.id, "SkillFactory")
            desc = buffSkillCA.description
          end
          View.Group_TicketShow.Img_Di.Txt_:SetText(desc)
        end
        break
      end
    end
  end
end

function DataModel.GetSealEffect()
  local effectList = {}
  if table.count(DataModel.sealList) == 4 then
    local weight = 0
    for i, v in ipairs(DataModel.sealList) do
      local effectWeight = 0
      if DataModel.sealEffectWeight and DataModel.sealEffectWeight[tostring(v)] then
        effectWeight = DataModel.sealEffectWeight[tostring(v)]
      end
      weight = weight + effectWeight
    end
    if DataModel.CombineSealEffectList[tostring(weight)] then
      table.insert(effectList, DataModel.CombineSealEffectList[tostring(weight)])
      return effectList, true
    else
      return effectList, false
    end
  else
    for i, v in ipairs(DataModel.sealList) do
      if DataModel.SingleSealEffectList[tostring(v)] then
        table.insert(effectList, DataModel.SingleSealEffectList[tostring(v)])
      end
    end
    return effectList, false
  end
end

function DataModel.ShowSealEffect()
  local sealData = WitchData.GetWitchesData().user_seal
  DataModel.sealList = Clone(sealData)
  local effectList, isCombine = DataModel.GetSealEffect()
  DataModel.SealEffectList = Clone(effectList)
  DataModel.IsCombineEffect = isCombine
  local sealCount = table.count(WitchData.GetWitchesData().user_seal)
  View.Group_SealShow.StaticGrid_Seal.grid.self:SetDataCount(sealCount)
  View.Group_SealShow.StaticGrid_Seal.grid.self:RefreshAllElement()
  DataModel.SetSealEffectElement()
  View.Group_Seal:SetActive(false)
  View.Group_SealShow:SetActive(true)
end

function DataModel.CheckGuKaRedPoint()
  local needShowGuKaRedPoint = false
  local gukaDataModel = require("UIGuKa/UIGuKaDataModel")
  needShowGuKaRedPoint = gukaDataModel.CheckGuKaRedPoint()
  View.Btn_Guka.Img_RedPoint:SetActive(needShowGuKaRedPoint)
end

function DataModel.LookAt(current, target)
  local dir = (target.transform.position - current.transform.position).normalized
  dir.y = 0
  current.transform.forward = dir
end

function DataModel:Clear()
  self.isCameraFollowPlayer = true
  self.mainCamera = nil
  self.gridList = {}
  self.triggers = {}
  self.randomAnimFrame = 0
  self.isInited = false
  self.move_consume = -1
  self.float_moveNum = -1
  self.fireworkViewList = {}
  DataModel.animData.standList = {}
  DataModel.animData.idle = nil
  DataModel.animData.move = nil
  DataModel.animData.move_broom = nil
  DataModel.animData.idle_broom = nil
end

return DataModel
