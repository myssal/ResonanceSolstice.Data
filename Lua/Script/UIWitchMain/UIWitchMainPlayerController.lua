local DataModel = require("UIWitchMain/UIWitchMainDataModel")
local FloatController = require("UIWitchMain/UIWitchMainFloatController")
local WitchesMapDataModel = require("UIWitchesMap/UIWitchesMapDataModel")
local PlayerController = {
  view = nil,
  view_broom = nil,
  animator = nil,
  inStateBroom = false
}

local function getViewBroom(go)
  local broom = go.transform:GetChild(0):GetChild(0):GetChild(3):GetChild(1)
  return broom.gameObject
end

function PlayerController:PlayAnim(animName)
  self.animator:Play(animName)
  local effect_idle = self.view.transform:Find("Effect_Idle").gameObject
  local effect_broom = self.view.transform:Find("Effect_Broom").gameObject
  local useBroom = animName == DataModel.animData.idle_broom or animName == DataModel.animData.move_broom
  effect_idle:SetActive(useBroom ~= true)
  effect_broom:SetActive(useBroom)
  if useBroom == true then
    if animName == "stand_broom" or animName == "walk_broom" then
      self.view_broom:SetActive(true)
    else
      self.view_broom:SetActive(false)
    end
  else
    self.view_broom:SetActive(false)
  end
  self.inStateBroom = useBroom
  DataModel.randomAnimFrame = 0
end

function PlayerController:ReqMove(grid, broomUsed, compeletedFunc)
  local curGridData = WitchData.GetGridData(WitchData.GetGridId())
  local com = curGridData and curGridData.com
  if com and tonumber(com) == 0 then
    return
  end
  if WitchData.GetStamina() < DataModel.move_consume then
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/MainFinish"), Json.encode({showTempLeft = 0, showRevive = 1}))
    return
  end
  
  local function cbSuccess(json)
    WitchData.SetGridId(grid.id)
    WitchData.SetStamina(WitchData.GetStamina() - DataModel.move_consume)
    WitchData.MoveEndRefreshData()
    WitchesMapDataModel:RefreshFloatInquiryRounds()
    if broomUsed == true then
      self:PlayAnim(DataModel.animData.move_broom)
    else
      self:PlayAnim(DataModel.animData.move)
    end
    DataModel.LookAt(self.view, grid.gridView)
    DOTweenTools.DOLocalMoveCallback(self.view.transform, grid.posX, DataModel.defualtAxisY, grid.posY, 1, function()
      if grid.eventView ~= nil then
        grid.eventView:SetActive(false)
      end
      self.view_broom:SetActive(false)
      self:PlayAnim(DataModel.animData.idle)
      DOTweenTools.DOLocalRotate(self.view.transform, 0, 0, 0, 0.25)
      DataModel.randomAnimFrame = 0
      if compeletedFunc then
        compeletedFunc(json)
      end
    end)
    FloatController:DoMove()
  end
  
  Net:SendProto("activity.move_position", cbSuccess, grid.id, WitchData.GetActivityId())
end

function PlayerController.MoveEndDealEvent(eventId)
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  if mod == "\233\173\148\229\165\179\229\175\185\232\175\157" then
    local gridCA = PlayerData:GetFactoryData(WitchData.GetGridId(), "ParkGridFactory")
    if gridCA.FerrisWheel and gridCA.FerrisWheel > 0 and PlayerData:GetPlayerPrefs("int", "WitchWheelDialog") == 1 then
      local activityId = PlayerData:GetFactoryData(gridCA.FerrisWheel).ferrisWheelEntrance
      UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleLevelWensheng", Json.encode({eventId = eventId, activityId = activityId}))
      return
    end
  end
  PlayerController.DealEvent(eventId)
end

function PlayerController.DealEvent(eventId)
  local witchesData = WitchData.GetWitchesData()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  if mod == "\233\173\148\229\165\179\229\175\185\232\175\157" then
    local needDeal = WitchData.IsEventNeedDeal(eventId)
    if #eventCA.dialogList == 0 then
      if needDeal then
        local function cb(json)
          if json.reward then
            WitchData.OpenShowItem(json.reward)
          end
          if WitchData.IsInEndOverList(WitchData.GetGridId(), eventId) then
            WitchData.ReqEndOverEvent(eventId)
          end
        end
        
        WitchData.ReqDealEvent(eventId, cb)
      elseif WitchData.IsInEndOverList(WitchData.GetGridId(), eventId) then
        WitchData.ReqEndOverEvent(eventId)
      end
    elseif #eventCA.dialogList > 0 then
      if needDeal then
        local function cb(json)
          UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesEvent"), Json.encode({eventId = eventId}))
          
          if json.reward then
            WitchData.OpenShowItem(json.reward)
          end
        end
        
        WitchData.ReqDealEvent(eventId, cb)
      else
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesEvent"), Json.encode({eventId = eventId}))
      end
    end
  elseif mod == "\233\173\148\229\165\179\233\129\147\229\133\183\229\149\134\229\186\151" then
    local selectInfo = witchesData.temp_select and witchesData.temp_select.shop
    if selectInfo and 0 < #selectInfo then
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesShop"), Json.encode({eventId = eventId, selectInfo = selectInfo}))
    else
      local function cb(json)
        if json.temp_select then
          UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesShop"), Json.encode({
            eventId = eventId,
            
            selectInfo = json.temp_select.shop
          }))
        end
      end
      
      WitchData.ReqDealEvent(eventId, cb)
    end
  elseif mod == "\233\173\148\229\165\179\232\140\182\230\173\135\228\186\139\228\187\182" then
    local selectInfo = witchesData.temp_select and witchesData.temp_select.rest
    if selectInfo and 0 < #selectInfo then
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesTeaBuff"), Json.encode({eventId = eventId, selectInfo = selectInfo}))
    else
      local function cb(json)
        if json.temp_select then
          UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesTeaBuff"), Json.encode({
            eventId = eventId,
            
            selectInfo = json.temp_select.rest
          }))
        end
      end
      
      WitchData.ReqDealEvent(eventId, cb)
    end
  elseif mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
    if eventCA.battleType == "Boss" and 0 < WitchData.GetSealCount() then
      DataModel.bossEventId = eventId
      DataModel.ShowSealEffect()
      return
    end
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesEnemy"), Json.encode({eventId = eventId}))
  elseif mod == "\229\146\149\229\141\161\229\175\185\232\175\157" then
    local selectInfo = witchesData.temp_select and witchesData.temp_select.guka
    if selectInfo and 0 < #selectInfo then
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaChoose"), Json.encode({rewardType = "guka"}))
    else
      local function cb(json)
        if json.temp_select then
          UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaChoose"), Json.encode({rewardType = "guka"}))
        end
      end
      
      WitchData.ReqDealEvent(eventId, cb)
    end
  elseif mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesEnemy"), Json.encode({eventId = eventId}))
  end
end

function PlayerController:InitPlayer()
  self.view = CS.UnityEngine.GameObject.Find("Player")
  self.animator = self.view.transform:GetChild(0):GetChild(0):GetComponent(typeof(CS.UnityEngine.Animator))
  self.view_broom = getViewBroom(self.view)
  self.view_broom:SetActive(false)
  local gridId = WitchData.GetGridId()
  local startPoint = DataModel.gridList[tonumber(gridId)]
  if startPoint == nil then
    startPoint = {}
    local startGridData = PlayerData:GetFactoryData(gridId, "ParkGridFactory")
    startPoint.posX = startGridData.x
    startPoint.posY = startGridData.y
  end
  self.view.transform.localPosition = Vector3(startPoint.posX, DataModel.defualtAxisY, startPoint.posY)
  if startPoint.eventView ~= nil then
    startPoint.eventView:SetActive(false)
  end
end

function PlayerController:OnUpdate()
  if self.inStateBroom ~= true then
    if DataModel.randomAnimFrame > DataModel.randomAnimPlayerCount then
      DataModel.randomAnimFrame = 0
      local count = table.count(DataModel.animData.standList)
      local index = math.random(1, count)
      local animName = DataModel.animData.standList[index]
      self:PlayAnim(animName)
    end
    DataModel.randomAnimFrame = DataModel.randomAnimFrame + 1
  end
end

function PlayerController:Clear()
  self.view = nil
  self.view_broom = nil
  self.animator = nil
end

return PlayerController
