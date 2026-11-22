local View = require("UISkinPreview/UISkinPreviewView")
local DataModel = require("UISkinPreview/UISkinPreviewDataModel")
local ViewFunction = require("UISkinPreview/UISkinPreviewViewFunction")
local Controller = require("UISkinPreview/UISkinPreviewController")

local function InitSkinView()
  local list = {}
  list[1] = {}
  list[1].unitViewId = DataModel.InitSkinId
  list[1].isSpine2 = 0
  list[1].qSpineIndex = 0
  if DataModel.RoleCA.spine2Url ~= nil and DataModel.RoleCA.spine2Url ~= "" then
    list[2] = {}
    list[2].unitViewId = DataModel.InitSkinId
    list[2].isSpine2 = 1
    list[2].qSpineIndex = 0
  end
  DataModel.SkinList = list
  DataModel.ChooseIndex = 1
  local count = 1
  for i = 1, table.count(list) do
    local data = list[i]
    local row = {}
    row.unitViewId = data.unitViewId
    row.isHave = false
    row.ca = PlayerData:GetFactoryData(row.unitViewId)
    row.isSelect = false
    row.isWear = false
    row.isSpine2 = data.isSpine2 or 0
    row.qSpineIndex = 0
    if row.isWear == true then
      row.isSelect = true
      DataModel.ChooseIndex = count
    end
    DataModel.SkinList[count] = row
    count = count + 1
  end
  View.Img_Bg.Group_Right.Img_Showing:SetActive(true)
  View.Img_Bg.Group_Right.Group_HoldingStatus.self:SetActive(false)
end

local function BlockFromRes(viewCA)
  local key = "block" .. GameSetting.fromRes
  return viewCA[key]
end

local function InitSkin()
  local ca_skin = {}
  for i, v in ipairs(DataModel.RoleCA.skinList) do
    local skinCA = PlayerData:GetFactoryData(v.unitViewId)
    local isBlock = BlockFromRes(skinCA)
    local battlePassCA
    if skinCA.skinBattlePass and skinCA.skinBattlePass > 0 then
      battlePassCA = PlayerData:GetFactoryData(skinCA.skinBattlePass, "BattlePassFactory")
    end
    if (not battlePassCA or TimeUtil:GetServerTimeStamp() >= TimeUtil:TimeStamp(battlePassCA.PassStartTime)) and not isBlock then
      table.insert(ca_skin, v)
      if skinCA.isSpine2 == 1 then
        local isHave = false
        local server = PlayerData:GetRoleById(DataModel.RoleId)
        local portrailData = PlayerData:GetFactoryData(v.unitViewId)
        if server.resonance_lv == 5 and portrailData.State2Res ~= nil and portrailData.State2Res ~= "" then
          isHave = true
        end
        table.insert(ca_skin, {
          unitViewId = v.unitViewId,
          isSpine2 = 1,
          isHave = isHave
        })
      end
    end
  end
  DataModel.ChooseIndex = 1
  local count = 1
  for i = 1, table.count(ca_skin) do
    local data = ca_skin[i]
    local row = {}
    row.unitViewId = data.unitViewId
    row.isHave = false
    row.ca = PlayerData:GetFactoryData(row.unitViewId)
    row.isSelect = false
    row.isWear = false
    row.isSpine2 = data.isSpine2 or 0
    row.qSpineIndex = 0
    local skinInfo = DataModel.RoleData.skin_list[tostring(data.unitViewId)]
    if skinInfo and skinInfo.span then
      for i = 1, #row.ca.extraSpineList do
        if tonumber(row.ca.extraSpineList[i].id) == tonumber(skinInfo.span) then
          row.qSpineIndex = i
          break
        end
      end
    end
    if tonumber(data.unitViewId) == tonumber(DataModel.RoleData.current_skin[1]) and row.isSpine2 == DataModel.RoleData.current_skin[2] then
      row.isWear = true
    end
    if row.isWear == true then
      row.isSelect = true
      DataModel.ChooseIndex = count
    end
    for c, d in pairs(DataModel.RoleData.skin_list) do
      if tostring(data.unitViewId) == c then
        row.isHave = true
        if data.isHave ~= nil then
          row.isHave = data.isHave
        end
        break
      end
    end
    DataModel.SkinList[count] = row
    count = count + 1
  end
  if table.count(DataModel.SkinList) > 3 then
    View.Img_Bg.Group_Right.Img_Frame.ScrollGrid_SkinList.grid.self.StartCorner = "Left"
  end
  View.Img_Bg.Group_Right.Img_Showing:SetActive(false)
  View.Img_Bg.Group_Right.Group_HoldingStatus.self:SetActive(true)
end

local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    Controller:DeserializeView(initParams)
    params = initParams
    local params = Json.decode(initParams)
    DataModel.isSkinView = params.isSkinView
    View.Img_Bg.Group_Right.Img_Frame.ScrollGrid_SkinList.grid.self.StartCorner = "Center"
    DataModel.SkinList = {}
    if params.isSkinView == true then
      DataModel.InitSkinId = tonumber(params.id)
      DataModel.RoleId = PlayerData:GetFactoryData(params.id).character
      DataModel.RoleCA = PlayerData:GetFactoryData(params.id)
      InitSkinView()
    else
      DataModel.RoleData = params.RoleData
      DataModel.InitSkinId = tonumber(DataModel.RoleData.current_skin[1])
      DataModel.RoleId = params.RoleId
      DataModel.RoleCA = params.RoleCA
      InitSkin()
    end
    DataModel.Spine2PosX = 0
    DataModel:Reset()
    View.Img_Bg.Group_Right.Img_Frame.ScrollGrid_SkinList.grid.self:SetDataCount(table.count(DataModel.SkinList))
    View.Img_Bg.Group_Right.Img_Frame.ScrollGrid_SkinList.grid.self:RefreshAllElement()
    View.Img_Bg.Group_Right.Img_Frame.ScrollGrid_SkinList.grid.self:MoveToPos(DataModel.ChooseIndex)
    DataModel:ClickLeftSkin(DataModel.ChooseIndex, true)
    local live2D = PlayerData:GetPlayerPrefs("int", DataModel.RoleId .. "live2d")
    DataModel.live2D = live2D == 0
    local Img_Live2dBg = View.Img_Bg.Group_Left.Group_Bottom.Group_Btn.Img_Live2dBg
    if live2D == 0 then
      Img_Live2dBg.Img_On.transform.localPosition = Vector3(24, -11, 0)
      Img_Live2dBg.Img_BG:SetSprite("UI/CharacterInfo/Skin/onbg")
    else
      Img_Live2dBg.Img_On.transform.localPosition = Vector3(-24, -11, 0)
      Img_Live2dBg.Img_BG:SetSprite("UI/CharacterInfo/Skin/offbg")
    end
    DataModel.LoadSpineBg(DataModel.InitSkinId)
    local showHomeBtn = not MapNeedleEventData.scene and not WitchData.inWitchMap
    View.Group_CommonTopLeft.Btn_Home:SetActive(showHomeBtn)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.UpdateScaleSlider()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
