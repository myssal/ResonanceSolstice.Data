local View = require("UICharacterInfo/UICharacterInfoView")
local lastRoleId
local DataModel = {
  RoleId = -1,
  RoleData = nil,
  RoleCA = nil,
  DragOver = false,
  DragOverPosX = nil,
  Roles = {},
  RoleAttributeCurrent = {},
  RoleAttributeNext = {},
  QueueData = {CurrentIndex = -1, Count = -1},
  InitState = false,
  IsNoMoney = false,
  InfoInitPos = {
    isRecord = true,
    x = 0,
    y = 0,
    scale = 1,
    offsetX = 0,
    offsetY = 1
  },
  LevelUpInitPos = {
    isRecord = true,
    x = 0,
    y = 0,
    scale = 1
  },
  Job = {
    [1] = "\229\188\186\232\162\173",
    [2] = "\233\152\178\230\154\180",
    [3] = "\229\176\132\230\137\139",
    [4] = "\231\129\181\229\173\144",
    [5] = "\230\143\180\230\138\164",
    [6] = "\231\137\185\232\129\140"
  },
  TableIndex = nil,
  ClassifyList = {},
  InitClassifyList = false,
  offsetX = 0,
  offsetY = 0,
  IsSquad = true,
  SquadsRoleList = {}
}
DataModel.lock_Add = false
DataModel.lock_LevelUp = false
DataModel.isLevelUp_Long = false
DataModel.MaterialList = {}

function DataModel.UpdateMaterialList(data)
  DataModel.MaterialList = {}
  for k, v in pairs(data) do
    local Factory = PlayerData:GetFactoryData(tonumber(v.id))
    local ItemViewFactory = PlayerData:GetFactoryData(tonumber(Factory.viewId))
    table.insert(DataModel.MaterialList, {
      id = v.id,
      Factory = Factory,
      num = v.num,
      ItemViewFactory = ItemViewFactory
    })
  end
end

function DataModel.StaticGrid_Item_SetGrid(index)
  return DataModel.MaterialList[index]
end

DataModel.AttributeConfig = {
  {
    type = "tAtk",
    txt = GetText(80607458),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_attack"
  },
  {
    type = "tHp",
    txt = GetText(80607459),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_health"
  },
  {
    type = "tDef",
    txt = GetText(80607460),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_defense"
  },
  {
    type = "tCri",
    txt = "\230\154\180\229\135\187\231\142\135",
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_cri"
  },
  {
    type = "tCriDamage",
    txt = "\230\154\180\229\135\187\228\188\164\229\174\179",
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_cri_damage"
  },
  {
    type = "tSpeed",
    txt = "\230\148\187\230\146\131\233\128\159\229\186\166",
    sprite = "UI\\Common\\Characterinfo_icon_att_attackSpd"
  },
  {
    type = "tSpeedRange",
    txt = "\230\148\187\230\146\131\231\175\132\229\155\178",
    sprite = "UI\\Common\\Characterinfo_icon_att_attackRange"
  },
  {
    type = "tSpName",
    txt = "\231\137\185\230\174\138\230\138\128\232\131\189\229\144\141\231\167\176",
    sprite = "UI\\Common\\Characterinfo_icon_att_sp"
  }
}
DataModel.AttributeBreakConfig = {
  {
    type = "tAtk",
    txt = GetText(80607458),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_attack"
  },
  {
    type = "tHp",
    txt = GetText(80607459),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_health"
  },
  {
    type = "tDef",
    txt = GetText(80607460),
    sprite = "UI\\CharacterInfo\\Characterinfo_icon_att_defense"
  }
}

function DataModel.GetShowType()
  local portraitId = DataModel.RoleData.current_skin[1]
  if portraitId == nil or portraitId == 0 then
    local viewCa = PlayerData:GetFactoryData(DataModel.RoleCA.viewId, "UnitViewFactory")
    portraitId = DataModel.RoleCA.viewId
  end
  local portrailData = PlayerData:GetFactoryData(portraitId, "UnitViewFactory")
  if DataModel.RoleData.resonance_lv == 5 and portrailData.spine2Url ~= nil and portrailData.spine2Url ~= "" then
    if DataModel.RoleData.current_skin[2] == 1 then
      return "Spine2"
    else
      return "Spine"
    end
  end
  if portrailData.spineUrl ~= nil and portrailData.spineUrl ~= "" then
    return "Spine"
  else
    return "Img"
  end
end

function DataModel.RefreshPage()
  for i = 1, #DataModel.TabEnum do
    if DataModel.TabEnum[i].btn.Img_RedPoint then
      DataModel.TabEnum[i].btn.Img_RedPoint:SetActive(PlayerData:GetAllRoleAwakeRedID(tostring(DataModel.RoleId)))
    end
  end
end

local function SwitchSpeed(tSpeed)
  if tSpeed <= 80 then
    return 80600232
  elseif tSpeed <= 120 then
    return 80600233
  elseif tSpeed <= 200 then
    return 80600234
  elseif tSpeed <= 275 then
    return 80600235
  else
    return 80600236
  end
end

local function SwitchSpeedRange(line)
  local line_config = {
    [0] = 80600228,
    [1] = 80600229,
    [2] = 80600230,
    [3] = 80600231
  }
  return line_config[line] or line
end

function DataModel:SetRoleAttributeCurrent()
  local RoleData = DataModel.RoleData
  DataModel.RoleAttributeCurrent = {}
  local temp_data = {}
  temp_data.tHp, temp_data.tDef, temp_data.tAtk, temp_data.tCri, temp_data.tCriDamage, temp_data.tSpeed, temp_data.tBlock, temp_data.tBlockRate, temp_data.tPDamageUp, temp_data.tMDamageUp, temp_data.tFReduce, temp_data.tGetPDamageDown, temp_data.tGetMDamageDown, temp_data.tGetFDamageDown, temp_data.tGetHealUp, temp_data.tGetShieldUp, temp_data.tSummonAtkUp, temp_data.tSummonFinalDamageUp = PlayerData:CountRoleAttributeById(DataModel.RoleId, RoleData.skills[1] and RoleData.skills[1].lv or 1, RoleData.skills[2] and RoleData.skills[2].lv or 1, RoleData.skills[2] and RoleData.skills[2].lv or 1, RoleData.lv, RoleData.awake_lv, RoleData.resonance_lv, RoleData.trust_lv or 1)
  for k, v in pairs(PlayerData.AttributeConfig) do
    local row = {}
    DataModel.RoleAttributeCurrent[k] = row
    row.name = v.txt
    if temp_data[v.type] then
      row.num = temp_data[v.type] + 1.0E-7 or 0
      row.num = PlayerData:GetPreciseDecimalFloor(row.num, 2)
      if v.type == "tSpeed" then
        row.num = GetText(SwitchSpeed(temp_data[v.type]))
      end
    else
      if v.type == "tSpeedRange" then
        row.num = GetText(SwitchSpeedRange(DataModel.RoleCA.line))
      end
      if v.type == "tSpName" then
        row.num = DataModel.RoleCA.specialGiftDes
      end
    end
    row.sprite = v.sprite
  end
end

function DataModel.LoadSpineBg(viewId)
  local live2D = PlayerData:GetPlayerPrefs("int", DataModel.RoleId .. "live2d")
  if live2D == 1 or DataModel.GetShowType() == "Spine2" then
    View.Group_Middle.Img_SpineBG:SetActive(false)
    return
  end
  local viewCfg = PlayerData:GetFactoryData(viewId or DataModel.RoleData.portrait_id, "UnitViewFactory")
  if viewCfg.SpineBackground and viewCfg.SpineBackground ~= "" then
    View.Group_Middle.Img_SpineBG:SetSprite(viewCfg.SpineBackground)
    DataModel.offsetX = viewCfg.SpineBGX and viewCfg.SpineBGX or 0
    DataModel.offsetY = viewCfg.SpineBGY and viewCfg.SpineBGY or 0
    local x
    if DataModel.DragOverPosX and DataModel.DragOverPosX ~= 0 then
      x = 0 < DataModel.DragOverPosX and -Screen.width or Screen.width
    else
      x = View.Group_Middle.SpineAnimation_Character.transform.localPosition.x - DataModel.offsetX
    end
    local y = viewCfg.SpineBGY and viewCfg.SpineBGY or 0
    View.Group_Middle.Img_SpineBG.transform.localPosition = Vector3(x, y, 0)
    local scale = viewCfg.SpineBGScale or 1
    View.Group_Middle.Img_SpineBG.transform.localScale = Vector3(scale, scale, 0)
  end
  View.Group_Middle.Img_SpineBG:SetActive(viewCfg.SpineBackground and viewCfg.SpineBackground ~= "")
end

function DataModel.SpineBgFollow()
  if View.Group_Middle.Img_SpineBG.IsActive then
    local x = View.Group_Middle.SpineAnimation_Character.transform.localPosition.x - DataModel.offsetX
    local pos = Vector3(x, DataModel.offsetY, 0)
    View.Group_Middle.Img_SpineBG.transform.localPosition = pos
    local alpha = View.Group_Middle.SpineAnimation_Character.color.a
    View.Group_Middle.Img_SpineBG:SetAlpha(alpha)
  end
end

return DataModel
