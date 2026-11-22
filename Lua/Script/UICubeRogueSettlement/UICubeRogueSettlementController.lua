local View = require("UICubeRogueSettlement/UICubeRogueSettlementView")
local DataModel = require("UICubeRogueSettlement/UICubeRogueSettlementDataModel")
local Controller = {
  Enum_RoleQuality = {
    [1] = "N",
    [2] = "N",
    [3] = "R",
    [4] = "SR",
    [5] = "SSR"
  }
}

function Controller.ShowPanel(data)
  DataModel.data = data
  View.Group_Bg:SetActive(true)
  View.Group_Process_1:SetActive(true)
  View.Group_Process_2:SetActive(false)
  local titlePath = data.isWin and 88300284 or 88300283
  View.Group_Bg.Img_Title:SetSprite(GetResPath(titlePath))
  View.Group_Bg.Img_Bg:SetActive(data.isWin)
  View.Group_Bg.Img_BgNot:SetActive(not data.isWin)
  local netData = PlayerData.TempCache.CubeRogueData
  local difficult = netData.difficulty
  local allConfig = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
  local difficultInfo = allConfig.rogueDifficultList[difficult + 1]
  View.Group_Process_1.Group_Info.Group_Depth.Img_Num:SetSprite(difficultInfo.insideIcon)
  View.Group_Process_1.Group_Info.Group_Grade.Txt_GradeNum:SetText(data.endLv)
  View.Group_Process_1.Group_Info.Group_Grade.Img_GradeUp:SetActive(data.endLv > data.startLv)
  View.Group_Process_1.Group_Info.Group_Stress.Txt_Num:SetText(data.press)
  View.Group_Process_1.Group_Info.Group_Stress.Txt_Num:SetActive(data.press and data.press > 0)
  View.Group_Process_1.Group_Info.Group_Stress.Group_NotOpen:SetActive(data.press == nil or data.press <= 0)
  View.Group_Process_1.Group_Grade.Txt_Num:SetText(data.addExp)
  View.Group_Process_1.Group_WeeklyExperience.Txt_Num:SetText(data.addWeeklyPoint)
  View.Group_Process_1.Group_Speciall.Txt_Num:SetText(data.specialItemNum)
  View.Group_Process_1.Group_Skill.Txt_Num:SetText(data.addSkillPoint)
  local loseSpecial = data.specialItemNum - data.addSkillPoint
  View.Group_Process_1.Group_Lose:SetActive(0 < loseSpecial)
  View.Group_Process_1.Group_Lose.Txt_Num:SetText(loseSpecial)
  View.Group_Process_1.Img_Score.Txt_1.Txt_Final:SetText(data.score)
  View.Group_Process_1.Img_Score.Txt_Coefficient:SetText(string.format("%d", math.floor(difficultInfo.settlementCoefficient * 100)) .. "%")
  View.Group_Process_1.Img_Score.Txt_Num:SetText(string.format("%.0f", data.score / difficultInfo.settlementCoefficient))
end

function Controller.ShowPanel2()
  View.Group_Process_1:SetActive(false)
  View.Group_Process_2:SetActive(true)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_CharacterTitle.Img_Icon:SetActive(DataModel.data.isWin)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_CharacterTitle.Img_IconNot:SetActive(not DataModel.data.isWin)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_Equipment.Img_Icon:SetActive(DataModel.data.isWin)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_Equipment.Img_IconNot:SetActive(not DataModel.data.isWin)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_BuffTitle.Img_Icon:SetActive(DataModel.data.isWin)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Img_BuffTitle.Img_IconNot:SetActive(not DataModel.data.isWin)
  View.Group_Process_2.Group_Btn.Btn_Confirm:SetActive(DataModel.data.isWin)
  View.Group_Process_2.Group_Btn.Btn_ConfirmNot:SetActive(not DataModel.data.isWin)
  local gameData = PlayerData.TempCache.CubeRogueData
  DataModel.allRole = {}
  for k, v in pairs(gameData.roles) do
    if k and k ~= "" then
      local roleLv = PlayerData.ServerData.roles[k].lv
      local roleCfg = PlayerData:GetFactoryData(k, "UnitFactory")
      local roleQualityInt = roleCfg.qualityInt
      local roleFacePath = PlayerData:GetFactoryData(roleCfg.viewId, "UnitViewFactory").face
      table.insert(DataModel.allRole, {
        id = k,
        lv = roleLv,
        qualityInt = roleQualityInt,
        facePath = roleFacePath
      })
    end
  end
  table.sort(DataModel.allRole, function(a, b)
    if a.qualityInt == b.qualityInt then
      return a.lv > b.lv
    else
      return a.qualityInt > b.qualityInt
    end
  end)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Character.ScrollGrid_Character.grid.self:SetDataCount(#DataModel.allRole)
  View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Character.ScrollGrid_Character.grid.self:RefreshAllElement()
  if table.count(gameData.inside_buffs) == 0 then
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Buff:SetActive(false)
  else
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Buff:SetActive(true)
    DataModel.allTeam = {}
    local allTeamDic = {}
    for k, v in pairs(gameData.inside_buffs) do
      local buffCfg = PlayerData:GetFactoryData(k, "RogueBuffFactory")
      local buffTeamCfg = PlayerData:GetFactoryData(buffCfg.correspondingTeam, "RogueTeamFactory")
      local isOpen = TimeUtil:TimeIsActive(buffTeamCfg.startTime)
      if isOpen then
        if allTeamDic[buffTeamCfg.id] == nil then
          local tempData = {
            id = buffTeamCfg.id,
            num = 0
          }
          allTeamDic[buffTeamCfg.id] = tempData
          table.insert(DataModel.allTeam, tempData)
        end
        allTeamDic[buffTeamCfg.id].num = allTeamDic[buffTeamCfg.id].num + 1
      end
    end
    table.sort(DataModel.allTeam, function(a, b)
      return a.num > b.num
    end)
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Buff.ScrollGrid_TacticBuff.grid.self:SetDataCount(#DataModel.allTeam)
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Buff.ScrollGrid_TacticBuff.grid.self:RefreshAllElement()
  end
  if table.count(gameData.equips) == 0 then
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Equipment:SetActive(false)
  else
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Equipment:SetActive(true)
    DataModel.allEquip = {}
    for k, v in pairs(gameData.equips) do
      local equipCfg = PlayerData:GetFactoryData(k, "RogueEquipmentFactory")
      table.insert(DataModel.allEquip, {
        id = k,
        quality = equipCfg.qualityInt
      })
    end
    table.sort(DataModel.allEquip, function(a, b)
      return a.quality > b.quality
    end)
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Equipment.ScrollGrid_Equipment.grid.self:SetDataCount(#DataModel.allEquip)
    View.Group_Process_2.ScrollView_Process_2.Viewport.Content.Group_Equipment.ScrollGrid_Equipment.grid.self:RefreshAllElement()
  end
end

local function OnExpAnimEnd()
  if DataModel.data.startLv < DataModel.data.endLv then
    DataModel.data.startLv = DataModel.data.startLv + 1
    View.Group_Process_1.Group_Info.Group_Grade.Txt_GradeNum:SetText(DataModel.data.startLv)
    DataModel.curExpAnimIndex = DataModel.curExpAnimIndex + 1
    Controller.DoExpAnim()
  else
    DataModel.curExpAnimIndex = nil
  end
end

function Controller.DoExpAnim()
  if DataModel.curExpAnimIndex > #DataModel.data.expStartRate then
    DataModel.curExpAnimIndex = nil
    return
  end
  local startRate = DataModel.data.expStartRate[DataModel.curExpAnimIndex]
  local endRate = DataModel.data.expEndRate[DataModel.curExpAnimIndex]
  View.Group_Process_1.Group_Info.Group_Grade.Img_ExpNew:SetFilledImgAmount(startRate)
  View.Group_Process_1.Group_Info.Group_Grade.Img_ExpOld:SetFilledImgAmount(startRate)
  DOTweenTools.DoImgProgressbar(View.Group_Process_1.Group_Info.Group_Grade.Img_ExpNew, startRate, endRate, 0.5, function()
    OnExpAnimEnd()
  end, function(leftTime)
  end, function()
  end)
end

function Controller.OnConfirmClick()
  local allCfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
  local keys = {
    "coinId",
    "specialItemId"
  }
  for k, v in pairs(keys) do
    local id = allCfg[v]
    local itemNum = PlayerData:GetGoodsById(id).num
    PlayerData:RefreshUseItems({
      [id] = itemNum
    })
  end
  
  local function OpenCubeRogueOverView()
    Net:SendProto("cube.info", function(json)
      PlayerData.TempCache.CubeRogueData = json.cube
      UIManager:Open("UI/CubeRogue/OverView/CubeRogueOverView", Json.encode({activityId = 86000026, isBattleReturn = true}))
    end)
  end
  
  if DataModel.data.reward and DataModel.data.reward.item and table.count(DataModel.data.reward.item) > 0 then
    local reward = DataModel.data.reward
    DataModel.data.reward = nil
    CommonTips.OpenShowItem(reward, function()
      if DataModel.data.isMainScene then
        OpenCubeRogueOverView()
      else
        local bgPath
        local cfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
        if cfg.loadingList and #cfg.loadingList > 0 then
          bgPath = cfg.loadingList[math.random(1, #cfg.loadingList)].imagePath
        end
        if bgPath == "" then
          bgPath = nil
        end
        CommonTips.OpenLoading(nil, nil, bgPath, function()
          CBus:ChangeScene("Main", function()
            OpenCubeRogueOverView()
          end)
        end)
      end
    end)
  elseif DataModel.data.isMainScene then
    OpenCubeRogueOverView()
  else
    local bgPath
    local cfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    if cfg.loadingList and #cfg.loadingList > 0 then
      bgPath = cfg.loadingList[math.random(1, #cfg.loadingList)].imagePath
    end
    if bgPath == "" then
      bgPath = nil
    end
    CommonTips.OpenLoading(nil, nil, bgPath, function()
      CBus:ChangeScene("Main", function()
        OpenCubeRogueOverView()
      end)
    end)
  end
end

function Controller.ClearData()
  DataModel.data = nil
  DataModel.cfg = nil
  DataModel.curExpAnimIndex = nil
  DataModel.allRole = nil
  DataModel.allTeam = nil
  DataModel.allEquip = nil
  if PlayerData.TempCache and PlayerData.TempCache.CubeRogueData then
    PlayerData.TempCache.CubeRogueData.cube_id = ""
  end
end

return Controller
