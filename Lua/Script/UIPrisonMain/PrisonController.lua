local Controller = {}
local boxFurId = 81300365
local AnimationOffSetMap = {
  standby = {
    offsetX = 1,
    offsetY = 0,
    offsetZ = 0.5
  },
  work_sewing1 = {
    offsetX = 0.5,
    offsetY = 0.23,
    offsetZ = 0.5
  },
  work_sewing2 = {
    offsetX = 0.5,
    offsetY = 0.23,
    offsetZ = 0.5
  },
  dozing = {
    offsetX = 1,
    offsetY = 0,
    offsetZ = 0.5
  }
}
local BubbleState = {
  None = 1,
  Accident = 2,
  Ill = 3,
  Working = 4,
  WorkStop = 5,
  WorkDone = 6
}

local function PlayAnim(character, animName)
  if character and animName and animName ~= "" then
    local offsetInfo = AnimationOffSetMap[animName] or {
      offsetX = 0,
      offsetY = 0,
      offsetZ = 0
    }
    character.animePart:SetLocalPosition(Vector3(0, 0, 0))
    character.animePart:SetLocalPositionAdd(Vector3(offsetInfo.offsetX, offsetInfo.offsetY, offsetInfo.offsetZ))
    character.tranPart:SetWorldPos(character.curTile.centerPosition)
    character.animePart:Play(animName)
  end
end

function Controller.InitScene()
  PrisonData.curStationPlace = 81500010
  local stationPlace = PlayerData:GetFactoryData(81500010, "HomeStationPlaceFactory")
  HomeStationStoreManager:Create(stationPlace.resId, stationPlace.id)
  local coachCA = PlayerData:GetFactoryData(stationPlace.resId, "HomeCoachFactory")
  HomeStationStoreManager:Load(coachCA.defaultTemplate)
  for i, v in pairs(stationPlace.npcList) do
    HomeStationStoreManager:CreateCustom(v.id, 0, v.isRandom, v.npcX, v.npcZ, v.tree)
  end
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local conductor = PlayerData:GetUserInfo().gender == 1 and homeConfig.conductorM or homeConfig.conductorW
  local offsetX = math.random(2, 10)
  local offsetZ = math.random(7, 10)
  HomeStationStoreManager:CreateCustom(conductor, 0, false, offsetX, offsetZ, "PassengerKCD:move")
  local prisonData = PrisonData.GetSeverPrisonData()
  local npcId = not prisonData and 70000020 or 70000221
  local characterCA = PlayerData:GetFactoryData(npcId, "HomeCharacterFactory")
  local uiPath
  if npcId == 70000020 then
    uiPath = "UI/Prison/Contract/PrisonContract"
  elseif npcId == 70000221 then
    uiPath = "UI/Prison/Contract/PrisonContractManage/PrisonContractManage"
  end
  local character = HomeStationStoreManager:CreateCustom(npcId, 0, false, 3, 3, "Businessman:stand")
  local effectPart = character.effectPart
  effectPart:SetTouchEvent(characterCA.interactiveIconPath, uiPath)
  effectPart:SetLayer(27)
end

local Sound

function Controller.PlayBgmSound()
  local sound = SoundManager:CreateSound(30005063)
  if sound then
    Sound = sound
    sound:Play()
  end
end

function Controller.StopBgmSound()
  if Sound then
    Sound:Stop()
    Sound = nil
  end
end

function Controller.InitDefaultRoom()
  local room = HomeManager:GetCurRoom()
  for areaIndex = 1, 6 do
    for posIndex = 1, 3 do
      local x, y = PrisonData.GetFurPosInfo(areaIndex, posIndex)
      room:FirstInitFurniture(boxFurId, x, y)
    end
  end
  local fur = room:GetReception()
  if fur then
    fur.view:SetActive(false)
  end
end

function Controller.InitRoom(roomIndex, uiRoot)
  local prisonData = PrisonData.GetSeverPrisonData()
  local roomCount = table.count(prisonData.workshops_front)
  if roomIndex < 1 or roomIndex > roomCount then
    return
  end
  HomeManager:CleanRoom(0)
  local stationPlace = PlayerData:GetFactoryData(81500010, "HomeStationPlaceFactory")
  local coachCA = PlayerData:GetFactoryData(stationPlace.resId, "HomeCoachFactory")
  HomeStationStoreManager:Load(coachCA.defaultTemplate)
  local room = HomeManager:GetCurRoom()
  for areaIndex = 1, 6 do
    for posIndex = 1, 3 do
      local cellIndex = PrisonData.GetCellIndex(areaIndex, posIndex)
      if not PrisonData.CheckAreaPosUnLock(roomIndex, cellIndex) then
        local x, y = PrisonData.GetFurPosInfo(areaIndex, posIndex)
        room:FirstInitFurniture(boxFurId, x, y)
      end
    end
  end
  local fur = room:GetReception()
  if fur then
    fur.view:SetActive(false)
  end
  for i, character in pairs(PrisonData.sceneAnimList) do
    HomeStationStoreManager:RecycleCustom(character)
  end
  PrisonData.sceneAnimList = {}
  Controller.InitPlacedFur(roomIndex)
  Controller.InitRoomPrisoner(roomIndex)
  Controller.InitProductBubble(roomIndex, uiRoot)
  PrisonData.SetCurRoomIndex(roomIndex)
end

function Controller.InitPlacedFur(roomIndex)
  local furList = PrisonData.GetPlacedFurList(roomIndex)
  local room = HomeManager:GetCurRoom()
  PrisonData.productEvent = {}
  for cellIndex, u_fid in pairs(furList) do
    if u_fid ~= "" then
      local areaIndex, posIndex = PrisonData.GetAreaIndexAndPosIndex(cellIndex)
      local x, y = PrisonData.GetFurPosInfo(areaIndex, posIndex)
      local furData = PrisonData.GetFurniture(u_fid)
      if furData then
        room:FirstInitFurniture(tonumber(furData.id), x, y, 0, u_fid)
      end
    end
  end
end

function Controller.InitProductEvent(roomIndex, cellIndex)
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
  if product then
    local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
    if 0 < remainTime then
      local invokeTime = PrisonData.GetProductFinishTime(roomIndex, cellIndex)
      local func = PrisonController.ProductDone
      local params = {cellIndex = cellIndex, roomIndex = roomIndex}
      PrisonData.SetTimeEvent(cellIndex, "ProductDone", invokeTime, func, params)
    end
    if product.event_trammels or product.event_halo then
      local eventCfg = PrisonData.GetAccidentCfg(roomIndex, cellIndex)
      local eventsHappen = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
      local params = {
        cellIndex = cellIndex,
        roomIndex = roomIndex,
        eventCfg = eventCfg
      }
      if not eventsHappen then
        if product.event_trammels then
          local invokeTime = product.event_trammels.happen_ts
          local func = PrisonController.ProductTrammelsAccident
          PrisonData.SetTimeEvent(cellIndex, "ProductTrammelsAccident", invokeTime, func, params)
        elseif product.event_halo then
          local invokeTime = product.event_halo.happen_ts
          local func = PrisonController.ProductHaloAccident
          PrisonData.SetTimeEvent(cellIndex, "ProductHaloAccident", invokeTime, func, params)
        end
      elseif product.event_trammels then
        PrisonController.ProductTrammelsAccident(params)
      elseif product.event_halo then
        PrisonController.ProductHaloAccident(params)
      end
    end
  end
  local productRoomList = PrisonData.GetProductRoomList()
  local u_pid = productRoomList[roomIndex][cellIndex]
  if u_pid and u_pid ~= "" then
    local prisonerData = PrisonData.GetPrisoner(u_pid)
    if prisonerData.ill_id and prisonerData.ill_id ~= "" then
      local params = {cellIndex = cellIndex, roomIndex = roomIndex}
      local illHappen = PrisonData.IsIllHappen(u_pid)
      local illHappenInProduct = PrisonData.IsIllHappenInProduct(roomIndex, cellIndex)
      if not illHappen then
        local invokeTime = prisonerData.disease_ts
        if illHappenInProduct then
          local func = PrisonController.ProductIll
          PrisonData.SetTimeEvent(cellIndex, "ProductIll", invokeTime, func, params)
        else
          local func = PrisonController.NatureIll
          PrisonData.SetTimeEvent(cellIndex, "NatureIll", invokeTime, func, params)
        end
      else
        local eventsHappen = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
        if not eventsHappen then
          if illHappenInProduct then
            PrisonController.ProductIll(params)
          else
            PrisonController.NatureIll(params)
          end
        end
      end
    end
  end
end

function Controller.UpdatePrisonerAnimEvent()
  for k, eventList in pairs(PrisonData.productEvent) do
    for eventType, event in pairs(eventList) do
      if TimeUtil:GetServerTimeStamp() >= event.invokeTime then
        event.func(event.params)
        PrisonData.productEvent[k] = nil
      end
    end
  end
end

function Controller.ProductDone(params)
  local roomIndex = tostring(params.roomIndex)
  local cellIndex = tostring(params.cellIndex)
  local eventsHappen = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
  if not eventsHappen then
    local animCA = PlayerData:GetFactoryData(80302146, "ListFactory")
    local animations = animCA.prisonerActionReady
    local animation = table.count(animations) > 1 and animations[math.random(1, table.count(animations))] or animations[1]
    local character = PrisonData.placedPrisonerList[cellIndex]
    PlayAnim(character, animation.actionName)
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
    local UIPrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
    UIPrisonMainData.RefreshFunList()
  end
end

function Controller.ProductTrammelsAccident(params)
  local roomIndex = tostring(params.roomIndex)
  local cellIndex = tostring(params.cellIndex)
  local eventCfg = params.eventCfg
  local productRoomList = PrisonData.GetProductRoomList()
  local u_pid = productRoomList[roomIndex][cellIndex]
  local prisonerData = PrisonData.GetPrisoner(u_pid)
  local isFirst = tonumber(prisonerData.personality_id) == eventCfg.firstPrisonerId
  local combineAnimName = eventCfg.combinationAcotionName
  if combineAnimName ~= "" then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local otherCellIndex = tostring(product.event_trammels.other)
    local key = cellIndex .. otherCellIndex
    if not PrisonData.sceneAnimList[key] then
      key = otherCellIndex .. cellIndex
      if not PrisonData.sceneAnimList[key] then
        local fetterId = eventCfg.fetterId
        local tagCA = PlayerData:GetFactoryData(fetterId, "TagFactory")
        if tagCA.sceneAnim > 0 then
          local areaIndex, posIndex = PrisonData.GetAreaIndexAndPosIndex(cellIndex)
          local x, y = PrisonData.GetFurPosInfo(areaIndex, posIndex)
          local sceneAnim = HomeStationStoreManager:CreateCustom(tagCA.sceneAnim, 0, false, x, y, "Prisoner:Default")
          if sceneAnim then
            sceneAnim.animePart:Play(combineAnimName)
            PrisonData.sceneAnimList[key] = sceneAnim
          end
        end
      end
    end
  end
  local character = PrisonData.placedPrisonerList[cellIndex]
  if character then
    local display = isFirst and eventCfg.firstDisplay or not isFirst and eventCfg.secondDisplay
    if display then
      HomeStationStoreManager:RecycleCustom(character)
      PrisonData.placedPrisonerList[cellIndex] = nil
    else
      PlayAnim(character, eventCfg.firstActionName)
    end
  end
  if eventCfg.stopProduce then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    if 0 < product.sts then
      product.tts = product.tts + PrisonData.GetProductWorkTime(roomIndex, cellIndex)
      product.sts = 0
    end
  end
end

function Controller.ProductHaloAccident(params)
  local roomIndex = tostring(params.roomIndex)
  local cellIndex = tostring(params.cellIndex)
  local character = PrisonData.placedPrisonerList[cellIndex]
  local eventCfg = PrisonData.GetAccidentCfg(roomIndex, cellIndex)
  if eventCfg.display then
    HomeStationStoreManager:RecycleCustom(character)
    PrisonData.placedPrisonerList[cellIndex] = nil
  else
    PlayAnim(character, eventCfg.actionName)
  end
  if eventCfg.stopProduce then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    if product.sts > 0 then
      product.tts = product.tts + PrisonData.GetProductWorkTime(roomIndex, cellIndex)
      product.sts = 0
    end
  end
end

function Controller.SolveProductAccident(roomIndex, cellIndex, product)
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local otherCellIndex
  if product.event_trammels then
    otherCellIndex = tostring(product.event_trammels.other)
    local key = cellIndex .. otherCellIndex
    if not PrisonData.sceneAnimList[key] then
      key = otherCellIndex .. cellIndex
    end
    local sceneAnim = PrisonData.sceneAnimList[key]
    if sceneAnim then
      HomeStationStoreManager:RecycleCustom(sceneAnim)
      PrisonData.sceneAnimList[key] = nil
    end
    local productRoomList = PrisonData.GetProductRoomList()
    local character = PrisonData.placedPrisonerList[cellIndex]
    if character then
      local u_pid = productRoomList[roomIndex][cellIndex]
      if not u_pid or u_pid == "" then
        HomeStationStoreManager:RecycleCustom(character)
        PrisonData.placedPrisonerList[cellIndex] = nil
      else
        PrisonController.InitPrisonerAnim(roomIndex, cellIndex)
      end
    end
    local otherCharacter = PrisonData.placedPrisonerList[otherCellIndex]
    if otherCharacter then
      local u_pid = productRoomList[roomIndex][otherCellIndex]
      if not u_pid or u_pid == "" then
        HomeStationStoreManager:RecycleCustom(otherCharacter)
        PrisonData.placedPrisonerList[otherCellIndex] = nil
      else
        PrisonController.InitPrisonerAnim(roomIndex, otherCellIndex)
      end
    end
  elseif product.event_halo then
    local character = PrisonData.placedPrisonerList[cellIndex]
    if character then
      PrisonController.InitPrisonerAnim(roomIndex, cellIndex)
    end
  end
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
    local UIPrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
    UIPrisonMainData.RefreshFunList()
  end
end

function Controller.ProductIll(params)
  local roomIndex = tostring(params.roomIndex)
  local cellIndex = tostring(params.cellIndex)
  local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
  if product.sts > 0 then
    product.tts = product.tts + PrisonData.GetProductWorkTime(roomIndex, cellIndex)
    product.sts = 0
  end
  local character = PrisonData.placedPrisonerList[cellIndex]
  PlayAnim(character, "standby")
end

function Controller.NatureIll(params)
  local roomIndex = tostring(params.roomIndex)
  local cellIndex = tostring(params.cellIndex)
  local character = PrisonData.placedPrisonerList[cellIndex]
  PlayAnim(character, "standby")
end

function Controller.SolveIll(cellList)
  for i, cellIndex in pairs(cellList) do
    cellIndex = tostring(cellIndex)
    local character = PrisonData.placedPrisonerList[cellIndex]
    if character then
      HomeStationStoreManager:RecycleCustom(character)
    end
    PrisonData.placedPrisonerList[cellIndex] = nil
  end
  CommonTips.OpenTips(string.format(GetText(80607968), #cellList))
end

function Controller.ChangeRoom(roomIndex, uiRoot)
  roomIndex = tonumber(roomIndex)
  if roomIndex == PrisonData.roomIndex then
    return
  end
  local prisonData = PrisonData.GetSeverPrisonData()
  local roomCount = table.count(prisonData.workshops_front)
  if roomIndex < 1 or roomIndex > roomCount then
    return
  end
  MainManager:SetTrainViewFilter(30, false)
  Controller.InitRoom(roomIndex, uiRoot)
end

function Controller.ReceiveProduct(cellIndex)
  local roomIndex = tostring(PrisonData.roomIndex)
  cellIndex = tostring(cellIndex)
  local character = PrisonData.placedPrisonerList[cellIndex]
  PlayAnim(character, "standby")
  if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
    local UIPrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
    UIPrisonMainData.RefreshFunList()
  end
end

function Controller.OpenProductReceiveTips(roomIndex, grad_product)
  roomIndex = tostring(roomIndex)
  local prisonProductRewards = {}
  local allProducts = PrisonData.GetRoomProducts(roomIndex)
  for k, v in pairs(grad_product) do
    if v.normal > 0 or 0 < v.extra or 0 < v.buff then
      local product = allProducts and allProducts[k]
      if product then
        local formulaCA = PlayerData:GetFactoryData(product.formula_group_id, "ProductionFactory")
        local data = prisonProductRewards[tostring(formulaCA.product)]
        data = data or {
          normal = 0,
          extra = 0,
          buff = 0
        }
        if v.normal then
          data.normal = data.normal + v.normal
        end
        if v.extra then
          data.extra = data.extra + v.extra
        end
        if v.buff then
          data.buff = data.buff + v.buff
        end
        prisonProductRewards[tostring(formulaCA.product)] = data
      end
    end
  end
  if 0 < table.count(prisonProductRewards) then
    UIManager:Open("UI/Common/ShowItem", Json.encode({
      prisonProductRewards = prisonProductRewards,
      title = GetText(80608306),
      ignoreCloseTime = true
    }))
  end
end

local FuncDic = {}

function Controller.GetTFunc(classType, methodName, TType)
  if FuncDic[methodName] and FuncDic[methodName][tostring(TType)] then
    return FuncDic[methodName][tostring(TType)]
  end
  local genFunc = xlua.get_generic_method(classType, methodName)
  local realFunc = genFunc(TType)
  FuncDic[methodName] = FuncDic[methodName] or {}
  FuncDic[methodName][tostring(TType)] = realFunc
  return realFunc
end

local CacheLoadBubble = {}

function Controller.InitProductBubble(roomIndex, uiRoot)
  local prisonData = PrisonData.GetSeverPrisonData()
  if not prisonData then
    return
  end
  roomIndex = tostring(roomIndex)
  local furList = PrisonData.GetPlacedFurList(roomIndex)
  local productRoomList = PrisonData.GetProductRoomList() or {}
  local roomData = productRoomList[roomIndex] or {}
  for cellIndex, bubble in pairs(CacheLoadBubble) do
    local go = bubble.gameObject
    if go and not go:IsNull() then
      go:SetActive(roomData[cellIndex])
    end
  end
  for cellIndex, v in pairs(roomData) do
    local bubble = CacheLoadBubble[cellIndex]
    local go = bubble and bubble.gameObject
    if not go or go:IsNull() then
      local GetRes = Controller.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.GameObject))
      go = CS.UnityEngine.GameObject.Instantiate(GetRes(ResManager, "UI/Prison/Main/Group_WorkingStatus", "#PrisonProductBubble"))
      if go and not go:IsNull() then
        bubble = {}
        bubble.gameObject = go
        local canvas = go.transform:GetComponent(typeof(CS.UnityEngine.Canvas))
        canvas.worldCamera = HomeManager.cam.homeCamera
        bubble.Group_Accident = go.transform:Find("Group_Accident"):GetComponent(typeof(CS.Seven.UIGroup))
        bubble.Group_Medical = go.transform:Find("Group_Medical"):GetComponent(typeof(CS.Seven.UIGroup))
        bubble.Group_Working = go.transform:Find("Group_Item/Group_Working"):GetComponent(typeof(CS.Seven.UIGroup))
        bubble.Group_Stop = go.transform:Find("Group_Item/Group_Stop"):GetComponent(typeof(CS.Seven.UIGroup))
        bubble.Group_WorkDone = go.transform:Find("Group_Item/Group_WorkDone"):GetComponent(typeof(CS.Seven.UIGroup))
        bubble.Img_Item = go.transform:Find("Group_Item/Img_Item"):GetComponent(typeof(CS.Seven.UIImg))
        bubble.Txt_Num = go.transform:Find("Group_Item/Txt_Num"):GetComponent(typeof(CS.Seven.UITxt))
        CacheLoadBubble[cellIndex] = bubble
      end
    end
    if go and not go:IsNull() then
      if uiRoot then
        for i, v in pairs(bubble) do
          if i ~= "gameObject" then
            v.root = uiRoot
          end
        end
      end
      local u_fid = furList[cellIndex]
      local fur = HomeManager:GetFurnitureByUfid(u_fid)
      if fur then
        local furPos = fur.view.transform.parent.localPosition
        local x = furPos.x
        local y = furPos.y + 4.2
        local z = furPos.z
        go.transform.localScale = Vector3(0.008, 0.008, 0.008)
        go.transform.localPosition = Vector3(x, y, z)
      end
      Controller.BindClickEvent(go, roomIndex, cellIndex)
      Controller.RefreshProductBubble(cellIndex)
    end
  end
end

function Controller.BindClickEvent(go, roomIndex, cellIndex)
  local Btn_Get = go.transform:Find("Group_Item/Group_WorkDone/Btn_Get"):GetComponent(typeof(CS.Seven.UIBtn))
  
  local function BubbleDoneClick()
    local function yesFun(json)
      local function callBack()
        Controller.ReceiveProduct(cellIndex)
      end
      
      PrisonData.ReceiveProduct(callBack, roomIndex, {cellIndex})
    end
    
    PrisonData.PreReceiveProduct(yesFun, roomIndex, {cellIndex}, 80608307)
  end
  
  Btn_Get:SetClickFunction(BubbleDoneClick)
  local Btn_Accident = go.transform:Find("Group_Accident/Btn_"):GetComponent(typeof(CS.Seven.UIBtn))
  
  local function BubbleAccidentClick()
    UIManager:Open("UI/Prison/Main/PrisonerEvent/PrisonerEvent", Json.encode({cellIndex = cellIndex}))
  end
  
  Btn_Accident:SetClickFunction(BubbleAccidentClick)
  local Btn_Faster = go.transform:Find("Group_Item/Group_Working/Btn_Faster"):GetComponent(typeof(CS.Seven.UIBtn))
  
  local function BubbleFasterClick()
    UIManager:Open("UI/Prison/PrisonBuildingUpgrade/SelectItemAcculate", Json.encode({addSpeedType = 4, cellIndex = cellIndex}))
  end
  
  Btn_Faster:SetClickFunction(BubbleFasterClick)
  local Btn_Ill = go.transform:Find("Group_Medical/Btn_"):GetComponent(typeof(CS.Seven.UIBtn))
  
  local function BubbleIllClick()
    local function yesFun()
      local productRoomList = PrisonData.GetProductRoomList() or {}
      
      local roomData = productRoomList[roomIndex] or {}
      local u_pid = roomData[cellIndex]
      
      local function callBack(json)
        Controller.SolveIll({cellIndex})
      end
      
      PrisonData.SolveIll(callBack, {u_pid})
    end
    
    local cellList = {}
    table.insert(cellList, cellIndex)
    yesFun()
  end
  
  Btn_Ill:SetClickFunction(BubbleIllClick)
end

function Controller.UpdateProductBubble()
  local prisonData = PrisonData.GetSeverPrisonData()
  if not prisonData then
    return
  end
  for cellIndex, bubble in pairs(CacheLoadBubble) do
    local go = bubble and bubble.gameObject
    if go and not go:IsNull() then
      Controller.RefreshProductBubble(cellIndex)
    end
  end
end

function Controller.GetBubbleState(cellIndex)
  local roomIndex = PrisonData.roomIndex
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
  if not product then
    local productRoomList = PrisonData.GetProductRoomList()
    local u_pid = productRoomList[roomIndex][cellIndex]
    local illHappen = PrisonData.IsIllHappen(u_pid)
    if illHappen then
      return BubbleState.Ill
    end
    return BubbleState.None
  else
    local productAccident = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
    if productAccident then
      return BubbleState.Accident
    end
    local productRoomList = PrisonData.GetProductRoomList()
    local u_pid = productRoomList[roomIndex][cellIndex]
    local illHappen = PrisonData.IsIllHappen(u_pid)
    if illHappen then
      return BubbleState.Ill
    end
    local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
    if remainTime <= 0 then
      return BubbleState.WorkDone
    else
      if product.sts == 0 then
        return BubbleState.WorkStop
      end
      return BubbleState.Working
    end
  end
end

function Controller.RefreshProductBubble(cellIndex)
  local roomIndex = PrisonData.roomIndex
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local bubble = CacheLoadBubble[cellIndex]
  local go = bubble and bubble.gameObject
  if not go or go:IsNull() then
    return
  end
  local bubbleState = Controller.GetBubbleState(cellIndex)
  if bubbleState == BubbleState.None then
    go:SetActive(false)
    return
  else
    go:SetActive(true)
  end
  bubble.Group_Working:SetActive(bubbleState == BubbleState.Working)
  if bubble.Group_Working.IsActive then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
    local formulaCA = PlayerData:GetFactoryData(product.formula_group_id, "ProductionFactory")
    local totalCostTime = formulaCA.perTime * product.count * 60
    local timeTbl = TimeUtil:SecondToTableHMS(remainTime)
    local workTxt = bubble.Group_Working.transform:Find("Txt_StatusWorking"):GetComponent(typeof(CS.Seven.UITxt))
    workTxt:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
    local timeImg = bubble.Group_Working.transform:Find("Img_Time"):GetComponent(typeof(CS.Seven.UIImg))
    timeImg:SetFilledImgAmount((totalCostTime - remainTime) / totalCostTime)
  end
  bubble.Group_Stop:SetActive(bubbleState == BubbleState.WorkStop)
  if bubble.Group_Stop.IsActive then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local remainTime = PrisonData.GetProductRemainTime(roomIndex, cellIndex)
    local formulaCA = PlayerData:GetFactoryData(product.formula_group_id, "ProductionFactory")
    local totalCostTime = formulaCA.perTime * product.count * 60
    local timeTbl = TimeUtil:SecondToTableHMS(remainTime)
    local workTxt = bubble.Group_Stop.transform:Find("Txt_StatusWorking"):GetComponent(typeof(CS.Seven.UITxt))
    workTxt:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
    local timeImg = bubble.Group_Stop.transform:Find("Img_Time"):GetComponent(typeof(CS.Seven.UIImg))
    timeImg:SetFilledImgAmount((totalCostTime - remainTime) / totalCostTime)
  end
  bubble.Group_WorkDone:SetActive(bubbleState == BubbleState.WorkDone)
  bubble.Group_Accident:SetActive(bubbleState == BubbleState.Accident)
  bubble.Group_Medical:SetActive(bubbleState == BubbleState.Ill)
  bubble.Img_Item:SetActive(bubbleState == BubbleState.Working or bubbleState == BubbleState.WorkStop or bubbleState == BubbleState.WorkDone)
  bubble.Txt_Num:SetActive(bubbleState == BubbleState.Working or bubbleState == BubbleState.WorkStop or bubbleState == BubbleState.WorkDone)
  if bubble.Txt_Num.IsActive then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local formulaCA = PlayerData:GetFactoryData(product.formula_group_id, "ProductionFactory")
    local workTime = PrisonData.GetProductWorkTime(roomIndex, cellIndex)
    local count = math.floor(workTime / (formulaCA.perTime * 60)) * formulaCA.perNum
    bubble.Txt_Num:SetText(count)
  end
  if bubble.Img_Item.IsActive then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local formulaCA = PlayerData:GetFactoryData(product.formula_group_id, "ProductionFactory")
    local factoryName = DataManager:GetFactoryNameById(tonumber(formulaCA.product))
    local itemCA
    if factoryName == "HomeGoodsFactory" then
      itemCA = PlayerData:GetFactoryData(formulaCA.product, "HomeGoodsFactory")
      bubble.Img_Item:SetSprite(itemCA.imagePath)
    elseif factoryName == "SourceMaterialFactory" then
      itemCA = PlayerData:GetFactoryData(formulaCA.product, "SourceMaterialFactory")
      bubble.Img_Item:SetSprite(itemCA.iconPath)
    end
  end
end

function Controller.InitRoomPrisoner(roomIndex)
  roomIndex = tostring(roomIndex)
  for i, character in pairs(PrisonData.placedPrisonerList) do
    if character then
      HomeStationStoreManager:RecycleCustom(character)
    end
  end
  PrisonData.placedPrisonerList = {}
  local eventHideList = {}
  local allProducts = PrisonData.GetRoomProducts(roomIndex) or {}
  for cellIndex, product in pairs(allProducts) do
    local eventsHappen = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
    if eventsHappen then
      local eventCfg = PrisonData.GetAccidentCfg(roomIndex, cellIndex)
      local fetterId = eventCfg.fetterId
      if fetterId == 12601124 or fetterId == 12601141 or fetterId == 12601143 then
        eventHideList[cellIndex] = 1
        if product.event_trammels and product.event_trammels.other then
          eventHideList[product.event_trammels.other] = 1
        end
      end
    end
  end
  local prisonerList = PrisonData.GetPlacedPrisonerList(roomIndex)
  for cellIndex, u_pid in pairs(prisonerList) do
    if not eventHideList[cellIndex] and not PrisonData.IsPrisonerInMedicalRoom(u_pid) and not PrisonData.IsPrisonerInDetentionRoom(u_pid) then
      PrisonController.InitPrisoner(roomIndex, cellIndex)
    end
  end
  local productRoomList = PrisonData.GetProductRoomList() or {}
  local cellList = productRoomList[roomIndex] or {}
  for cellIndex, u_pid in pairs(cellList) do
    Controller.InitProductEvent(roomIndex, cellIndex)
  end
end

function Controller.InitPrisoner(roomIndex, cellIndex)
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local prisonerList = PrisonData.GetPlacedPrisonerList(roomIndex)
  local u_pid = prisonerList[cellIndex]
  local prisonerData = PrisonData.GetPrisoner(u_pid)
  if prisonerData then
    local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id, "PrisonerFactory")
    local characterId = prisonerCA.PrisonerAnimation
    if 0 < characterId then
      local areaIndex, posIndex = PrisonData.GetAreaIndexAndPosIndex(cellIndex)
      local x, y = PrisonData.GetFurPosInfo(areaIndex, posIndex)
      local character = HomeStationStoreManager:CreateCustom(characterId, 0, false, x, y, "Prisoner:Default")
      PrisonData.placedPrisonerList[cellIndex] = character
      PrisonController.InitPrisonerAnim(roomIndex, cellIndex)
    end
  end
end

function Controller.InitPrisonerAnim(roomIndex, cellIndex)
  roomIndex = tostring(roomIndex)
  cellIndex = tostring(cellIndex)
  local prisonerList = PrisonData.GetPlacedPrisonerList(roomIndex)
  local u_pid = prisonerList[tostring(cellIndex)]
  local character = PrisonData.placedPrisonerList[cellIndex]
  local animCA = PlayerData:GetFactoryData(80302146, "ListFactory")
  if character then
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local eventsHappen = PrisonData.IsAccidentHappen(roomIndex, cellIndex)
    local illHappen = PrisonData.IsIllHappen(u_pid)
    if not eventsHappen and not illHappen then
      local animations
      if product then
        local finish = PrisonData.GetProductRemainTime(roomIndex, cellIndex) <= 0
        if finish then
          animations = animCA.prisonerActionReady
        else
          animations = animCA.prisonerActionWorking
        end
      else
        animations = animCA.prisonerActionReady
      end
      local animation = table.count(animations) > 1 and animations[math.random(1, table.count(animations))] or animations[1]
      PlayAnim(character, animation.actionName)
    end
  end
end

function Controller.CloseRoom()
  if not PrisonData.curStationPlace or PrisonData.curStationPlace ~= 81500010 then
    return
  end
  if HomeStationStoreManager:GetCurStationPlace() <= 0 then
    return
  end
  HomeStationStoreManager:QuitStationStore()
  local MainUIDataModel = require("UIMainUI/UIMainUIDataModel")
  if MainManager.bgSceneName == MainUIDataModel.SceneNameEnum.Home then
    local HomeController = require("UIHome/UIHomeController")
    local HomeCoachDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
    local HomeCoachController = require("UIHomeCoach/UIHomeCoachController")
    HomeController:RefreshTrains()
    HomeCoachController:InitEnvironment()
    HomeCharacterManager:CreateAll(HomeCoachDataModel.characterData, HomeCoachDataModel.petData)
    HomeCharacterManager:ReShowAll()
  end
  PrisonData.CloseRoom()
  for i, bubble in pairs(CacheLoadBubble) do
    local go = bubble.gameObject
    if go and not go:IsNull() then
      Object.Destroy(go)
    end
  end
  CacheLoadBubble = {}
end

function Controller.UpGradeFurniture(ufid, upgradeId)
  local room = HomeManager:GetCurRoom()
  local fur = room:GetFurniture(ufid)
  if fur then
    HomeManager:UpGradeFurniture(0, ufid, upgradeId)
  end
end

function Controller.JumpReturnCallBack(roomIndex, uiRoot)
  if not PrisonData.curStationPlace then
    PrisonController.InitScene()
    PrisonData.SetCurRoomIndex(roomIndex)
    PrisonController.InitRoom(roomIndex, uiRoot)
    PrisonController.PlayBgmSound()
    TrainCameraManager:OpenCamera(3)
  end
  PrisonData.jumpReturnRoomIndex = nil
end

function Controller.OpenPrisonBuildUI()
  if PrisonData.GetSeverPrisonData() then
    local function callBack(json)
      local OrderData = require("UIHYOrderStation/PrisonHyOrderData")
      
      OrderData.SetOrderData(json.prison_orders)
      UIManager:Open("UI/Prison/Overview/Prison")
    end
    
    PrisonData.PrisonRefresh(callBack)
  else
    PrisonController.InitScene()
    UIManager:Open("UI/Prison/Main/PrisonMain")
    PrisonController.InitDefaultRoom()
  end
end

return Controller
