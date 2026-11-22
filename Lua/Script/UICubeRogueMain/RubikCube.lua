local publicMethod = require("UICubeRogueMain/CubeRoguePublicMethod")
local RubikCube = {
  obj = nil,
  rot = nil,
  size = 3
}
RubikCube.__index = RubikCube
local Enum_CubeType = {
  Boss = 12601541,
  Reward = 12601617,
  Recover = 12601615,
  HardBattle = 12601542,
  NormalBattle = 12601540,
  Event = 12601616,
  Shop = 12601614,
  SpecialShop = 12601699
}

function RubikCube.new(centerPosition, cubeSize, gap, size, id)
  local self = setmetatable({}, RubikCube)
  self.centerPosition = centerPosition or Vector3.zero
  self.cubeSize = cubeSize or 1
  self.gap = gap or 0.1
  self.cubeData = {}
  self.size = size or 3
  self.cfg = PlayerData:GetFactoryData(id, "CubeRogueFactory")
  self.allCfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
  return self
end

function RubikCube:Clear()
  CS.UnityEngine.GameObject.Destroy(self.obj)
  self.centerPosition = nil
  self.cubeSize = nil
  self.gap = nil
  self.cubeData = nil
  self.size = nil
  self.cfg = nil
  self.obj = nil
  self.animator = nil
  self.rot = nil
  self.bossCube = nil
end

local CubeDefaultRotation = {}

local function InitSingleCube(cube, cubeDic)
  local posInfo = string.split(string.sub(cube.name, 7, 11), ",")
  local face = tonumber(posInfo[1])
  local x = tonumber(posInfo[2])
  local y = tonumber(posInfo[3])
  local rolePos = cube.transform:Find("Rogue_Cube_MF_02")
  local moveBtn = rolePos:Find("Btn")
  local moveArrow = moveBtn:Find("Arrow")
  cubeDic = cubeDic or {}
  cubeDic[face] = cubeDic[face] or {}
  cubeDic[face][x] = cubeDic[face][x] or {}
  cubeDic[face][x][y] = cubeDic[face][x][y] or {}
  CubeDefaultRotation[face] = CubeDefaultRotation[face] or {}
  CubeDefaultRotation[face][x] = CubeDefaultRotation[face][x] or {}
  CubeDefaultRotation[face][x][y] = cube.transform.localRotation
  local tempData = {
    face = face,
    row = x,
    col = y,
    obj = cube,
    rolePos = rolePos,
    moveBtn = moveBtn,
    moveArrow = moveArrow,
    netData = cubeDic[face][x][y].netData,
    realId = cubeDic[face][x][y].realId,
    item = cubeDic[face][x][y].item
  }
  cubeDic[face][x][y] = tempData
  local ctl = require("UICubeRogueMain/UICubeRoguewMainController")
  local listener = cube:GetComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
  local entryDown = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDown.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerDown
  entryDown.callback:AddListener(function(eventData)
    ctl.OnCubePointerDown(eventData, tempData)
  end)
  listener.triggers:Add(entryDown)
  local entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
  entryDrag.callback:AddListener(function(eventData)
    ctl.OnCubeDrag(eventData)
  end)
  listener.triggers:Add(entryDrag)
  local entryUp = CS.UnityEngine.EventSystems.EventTrigger.Entry()
  entryUp.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerUp
  entryUp.callback:AddListener(function(eventData)
    ctl.OnCubePointerUp(eventData, tempData)
  end)
  listener.triggers:Add(entryUp)
end

function RubikCube:LoadModel()
  local GetRes = publicMethod.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.GameObject))
  local model = CS.UnityEngine.GameObject.Instantiate(GetRes(ResManager, self.cfg.cubeEntiretyModle, "#CubeRogue"))
  self.obj = model
  self.animator = model:GetComponent(typeof(CS.UnityEngine.Animator))
  model.transform.position = Vector3.zero
  model.transform.localEulerAngles = Vector3(51, -133, 12)
  self.rot = model.transform:Find("Rot").gameObject
  local childCount = model.transform.childCount
  for i = 0, childCount - 1 do
    local cube = model.transform:GetChild(i)
    if not string.contains(cube.name, "Rot") and not string.contains(cube.name, "Center") then
      InitSingleCube(cube.gameObject, self.cubeData)
    end
  end
  self:RefreshCubeLabel()
end

function RubikCube:PlayAnim(stateName)
  if self.animator == nil or self.curAnim == stateName then
    logError("\233\173\148\230\150\185\231\154\132\229\138\168\231\148\187\230\142\167\229\136\182\229\153\168\228\184\186\231\169\186")
  end
  if self.animator then
    self.animator.enabled = true
    self.animator:Play(stateName)
  end
  self.curAnim = stateName
end

function RubikCube:StopAnim()
  if self.animator then
    self.animator.enabled = false
  end
end

local faceNormals = {
  Vector3.up,
  Vector3.back,
  Vector3.right,
  Vector3.forward,
  Vector3.left,
  Vector3.down
}

function RubikCube:Generate()
  RubikCube.obj = CS.UnityEngine.GameObject("Rubik")
  RubikCube.obj.transform.position = self.centerPosition
  local collider = RubikCube.obj:AddComponent(typeof(CS.UnityEngine.BoxCollider))
  local colSize = (self.size + 1) * (self.cubeSize + self.gap)
  collider.size = Vector3(colSize, colSize, colSize)
  RubikCube.rot = CS.UnityEngine.GameObject("Rot")
  RubikCube.rot.transform:SetParent(RubikCube.obj.transform)
  RubikCube.rot.transform.localPosition = Vector3.zero
  for i, normal in ipairs(faceNormals) do
    self:GenerateFace(i, normal)
  end
  self:GenerateDetail()
end

function RubikCube:GenerateDetail()
  local genFunc = xlua.get_generic_method(CS.ResManager, "GetRes")
  local realFunc = genFunc(typeof(CS.UnityEngine.GameObject))
  local obj = realFunc(ResManager, self.cfg.cubeModle, "#CubeRogue")
  local cube = CS.UnityEngine.GameObject.Instantiate(obj)
  cube.transform:SetParent(RubikCube.obj.transform)
  cube.transform.localPosition = Vector3.zero
  cube.name = "Cube (Center)"
end

function RubikCube:GenerateFace(face, normal)
  local _normal = normal
  if face == 6 then
    _normal = Vector3.up
  end
  local right = Vector3.Cross(_normal, Vector3.up)
  if right == Vector3.zero then
    right = Vector3.Cross(_normal, Vector3.forward)
  end
  local up = Vector3.Cross(right, _normal)
  local maxIndex = self.size - 1
  local halfSize = maxIndex / 2
  for x = 0, maxIndex do
    local xOff = x - halfSize
    for y = 0, maxIndex do
      local yOff = y - halfSize
      local offset = right * xOff * (self.cubeSize + self.gap) + up * yOff * (self.cubeSize + self.gap)
      local position = normal * (self.cubeSize + self.gap) * (halfSize + 1) + offset
      local type = 2
      if x == 0 and y == maxIndex then
        type = 1
      elseif x == maxIndex and y == 0 then
        type = 1
      elseif x == 0 and y == 0 then
        type = 1
      elseif x == maxIndex and y == maxIndex then
        type = 1
      elseif x == 0 or x == maxIndex or y == 0 or y == maxIndex then
        type = 2
      else
        type = 3
      end
      local cube = self:CreateCube(type, position, normal)
      local xid = x + 1
      local yid = y + 1
      cube.name = "Cube (" .. face .. "," .. xid .. "," .. yid .. ")"
      if not self.cubeData[face] then
        self.cubeData[face] = {}
      end
      if not self.cubeData[face][xid] then
        self.cubeData[face][xid] = {}
      end
      local tempData = {
        face = face,
        row = xid,
        col = yid,
        obj = cube
      }
      self.cubeData[face][xid][yid] = tempData
      local ctl = require("UICubeRogueMain/UICubeRoguewMainController")
      local col = cube:AddComponent(typeof(CS.UnityEngine.BoxCollider))
      col.size = Vector3(self.cubeSize, self.cubeSize, self.cubeSize)
      local listener = cube:AddComponent(typeof(CS.UnityEngine.EventSystems.EventTrigger))
      local entryDown = CS.UnityEngine.EventSystems.EventTrigger.Entry()
      entryDown.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerDown
      entryDown.callback:AddListener(function(eventData)
        ctl.OnCubePointerDown(eventData, tempData)
      end)
      listener.triggers:Add(entryDown)
      local entryDrag = CS.UnityEngine.EventSystems.EventTrigger.Entry()
      entryDrag.eventID = CS.UnityEngine.EventSystems.EventTriggerType.Drag
      entryDrag.callback:AddListener(function(eventData)
        ctl.OnCubeDrag(eventData)
      end)
      listener.triggers:Add(entryDrag)
      local entryUp = CS.UnityEngine.EventSystems.EventTrigger.Entry()
      entryUp.eventID = CS.UnityEngine.EventSystems.EventTriggerType.PointerUp
      entryUp.callback:AddListener(function(eventData)
        ctl.OnCubePointerUp(eventData, tempData)
      end)
      listener.triggers:Add(entryUp)
    end
  end
end

function RubikCube:RefreshCubeLabel(roleCtrl, bossCtrl)
  local newRole, newBoss
  for face = 1, 6 do
    for x = 1, self.size do
      for y = 1, self.size do
        local xid = x
        local yid = y
        if self.cubeData[face] ~= nil and self.cubeData[face][xid] ~= nil and self.cubeData[face][xid][yid].obj ~= nil then
          if newRole == nil and roleCtrl and roleCtrl.face == self.cubeData[face][xid][yid].face and roleCtrl.x == self.cubeData[face][xid][yid].row and roleCtrl.y == self.cubeData[face][xid][yid].col then
            newRole = self.cubeData[face][xid][yid]
          end
          if newBoss == nil and bossCtrl and bossCtrl.face == self.cubeData[face][xid][yid].face and bossCtrl.x == self.cubeData[face][xid][yid].row and bossCtrl.y == self.cubeData[face][xid][yid].col then
            newBoss = self.cubeData[face][xid][yid]
          end
          self.cubeData[face][xid][yid].face = face
          self.cubeData[face][xid][yid].row = xid
          self.cubeData[face][xid][yid].col = yid
          self.cubeData[face][xid][yid].obj.transform.localRotation = CubeDefaultRotation[face][x][y]
        end
      end
    end
  end
  if newRole then
    roleCtrl.face = newRole.face
    roleCtrl.x = newRole.row
    roleCtrl.y = newRole.col
  end
  if newBoss then
    bossCtrl.face = newBoss.face
    bossCtrl.x = newBoss.row
    bossCtrl.y = newBoss.col
  end
end

function RubikCube:CreateCube(type, position, normal)
  local genFunc = xlua.get_generic_method(CS.ResManager, "GetRes")
  local realFunc = genFunc(typeof(CS.UnityEngine.GameObject))
  local obj
  if type == 1 then
    obj = realFunc(ResManager, self.cfg.cubeCornerModle, "#CubeRogue")
  elseif type == 2 then
    obj = realFunc(ResManager, self.cfg.cubeSideModle, "#CubeRogue")
  else
    obj = realFunc(ResManager, self.cfg.cubeCenterModle, "#CubeRogue")
  end
  local cube = CS.UnityEngine.GameObject.Instantiate(obj)
  cube.transform.rotation = CS.UnityEngine.Quaternion.LookRotation(normal)
  cube.transform:SetParent(RubikCube.obj.transform)
  cube.transform.localPosition = position
  return cube
end

function RubikCube:SetData(netData)
  for face = 1, 6 do
    local face_str = tostring(face)
    for x = 1, self.size do
      for y = 1, self.size do
        local xid = x
        local yid = y
        self.cubeData[face] = self.cubeData[face] or {}
        self.cubeData[face][xid] = self.cubeData[face][xid] or {}
        self.cubeData[face][xid][yid] = self.cubeData[face][xid][yid] or {}
        self.cubeData[face][xid][yid].netData = tonumber(netData[face_str][xid][yid].tp_id)
        self.cubeData[face][xid][yid].realId = tonumber(netData[face_str][xid][yid].eid)
        self.cubeData[face][xid][yid].item = netData[face_str][xid][yid].item
      end
    end
  end
end

function RubikCube:ResetNetData()
  local result = {}
  for face, faceData in pairs(self.cubeData) do
    result[tostring(face)] = result[tostring(face)] or {}
    for x, rowData in pairs(faceData) do
      result[tostring(face)][x] = result[tostring(face)][x] or {}
      for y, cubeData in pairs(rowData) do
        local temp = {}
        if cubeData.netData then
          temp.tp_id = tostring(cubeData.netData)
        end
        if cubeData.realId then
          temp.eid = tostring(cubeData.realId)
        end
        temp.item = cubeData.item
        result[tostring(face)][x][y] = temp
      end
    end
  end
  return result
end

local function ShowCubeIcon(cubeData, cfg, self)
  if cubeData == nil then
    return
  end
  local iconPath, gridPath, isBoss
  if cubeData.netData == nil or cubeData.netData == "" then
    iconPath = "UI/CubeRogue/TypeIcon/CubeIcon/icon_empty"
    gridPath = "CubeRoguePath/Model/Prefab/Rogue_Cube_MF_N_Empty"
  else
    local eventCfg = GetCA(tonumber(cubeData.netData), "ActivityListFactory")
    local typeCfg = GetCA(eventCfg.typeId, "TagFactory")
    iconPath = typeCfg.icon
    gridPath = typeCfg.cellModel
    if typeCfg.id == 12601541 then
      self.bossCube = cubeData
      isBoss = true
    end
  end
  if cubeData.gridPath ~= gridPath then
    if cubeData.curGrid then
      CS.UnityEngine.GameObject.Destroy(cubeData.curGrid)
    end
    cubeData.gridPath = gridPath
    cubeData.curGrid = publicMethod.LoadModel(gridPath, "#CubeRogue")
    cubeData.curGrid.transform:SetParent(cubeData.rolePos.transform)
    cubeData.curGrid.transform.localPosition = Vector3.zero
    cubeData.curGrid.transform.localRotation = Quaternion.identity
    cubeData.curGrid.gameObject.name = "grid"
    cubeData.mesh = cubeData.curGrid.transform:Find("Icon"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
  end
  if cubeData.mesh then
    local getIcon = publicMethod.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.Texture2D))
    cubeData.mesh.material:SetTexture("_MainTex", getIcon(ResManager, iconPath, "#CubeRogue"))
  end
  if not isBoss and cubeData.item and table.count(cubeData.item) > 0 and (cubeData.specialItemModel == nil or cubeData.specialItemModel:IsNull()) then
    cubeData.specialItemModel = publicMethod.LoadModel(cfg.specialItemModel, "#CubeRogue")
    cubeData.specialItemModel.transform:SetParent(cubeData.rolePos.transform)
    cubeData.specialItemModel.transform.localPosition = Vector3.forward
    cubeData.specialItemModel.transform.localRotation = Quaternion.identity
  elseif (cubeData.item == nil or isBoss) and cubeData.specialItemModel then
    if not cubeData.specialItemModel:IsNull() then
      CS.UnityEngine.GameObject.Destroy(cubeData.specialItemModel)
    end
    cubeData.specialItemModel = nil
  end
end

function RubikCube:ShowIcon(face, x, y)
  if self.cubeData[face] then
    if x then
      if y then
        local data = self.cubeData[face][x][y]
        ShowCubeIcon(data, self.allCfg, self)
      else
        for _y, data in pairs(self.cubeData[face][x]) do
          ShowCubeIcon(data, self.allCfg, self)
        end
      end
    elseif y then
      for _x, row in pairs(self.cubeData[face]) do
        local data = row[y]
        ShowCubeIcon(data, self.allCfg, self)
      end
    else
      for _x, row in pairs(self.cubeData[face]) do
        for _y, data in pairs(row) do
          ShowCubeIcon(data, self.allCfg, self)
        end
      end
    end
  else
    for _f, _g in pairs(self.cubeData) do
      for _x, row in pairs(_g) do
        for _y, data in pairs(row) do
          ShowCubeIcon(data, self.allCfg, self)
        end
      end
    end
  end
end

function RubikCube:CheckData(Data, face_, x_, y_)
  local netData = Data.faces
  for face = 1, 6 do
    local face_str = tostring(face)
    for x = 1, self.size do
      for y = 1, self.size do
        local xid = x
        local yid = y
        if tostring(netData[face_str][xid][yid].tp_id) ~= tostring(self.cubeData[face][xid][yid].netData) then
          logError("\229\135\186\233\148\153\228\186\134! \229\186\143\229\143\183" .. face .. xid .. yid .. "  : net-" .. tostring(netData[face_str][xid][yid].tp_id) .. "  local-" .. tostring(self.cubeData[face][xid][yid].netData) .. "      ")
        end
      end
    end
  end
  local curPos = string.split(Data.cur_lct, ":")
  if face_ ~= tonumber(curPos[3]) or x_ ~= tonumber(curPos[1]) or y_ ~= tonumber(curPos[2]) then
    logError("\232\167\146\232\137\178\228\189\141\231\189\174\229\135\186\233\148\153\228\186\134! net-" .. Data.cur_lct .. "    local-" .. tonumber(face_) .. ":" .. tonumber(x_) .. ":" .. tonumber(y_))
  end
end

function RubikCube.GetRotateNextFace(face, isHorizon, rot)
  if face == 1 then
    if isHorizon then
      return 0 < rot and 5 or 3
    else
      return 0 < rot and 2 or 4
    end
  elseif face == 2 then
    if isHorizon then
      return 0 < rot and 5 or 3
    else
      return 0 < rot and 6 or 1
    end
  elseif face == 3 then
    if isHorizon then
      return 0 < rot and 2 or 4
    else
      return 0 < rot and 6 or 1
    end
  elseif face == 4 then
    if isHorizon then
      return 0 < rot and 3 or 5
    else
      return 0 < rot and 6 or 1
    end
  elseif face == 5 then
    if isHorizon then
      return 0 < rot and 4 or 2
    else
      return 0 < rot and 6 or 1
    end
  elseif face == 6 then
    if isHorizon then
      return 0 < rot and 2 or 4
    else
      return 0 < rot and 5 or 3
    end
  end
end

function RubikCube:RotHorizontalData(face, x, y, rot, roleCtrl, bossCtrl)
  if 0 < rot then
    self:RotHorizontalUnClockwise(face, x, y)
  else
    self:RotHorizontalClockwise(face, x, y)
  end
  self:RefreshCubeLabel(roleCtrl, bossCtrl)
end

function RubikCube:RotHorizontalUnClockwise(face, x, y)
  for i = 1, 3 do
    self:RotHorizontalClockwise(face, x, y)
  end
end

function RubikCube:RotHorizontalClockwise(face, x, y)
  if face < 6 and 1 < face then
    local temp = {}
    for row = 1, self.size do
      if temp[row] == nil then
        temp[row] = {}
      end
      temp[row][y] = self.cubeData[5][row][y]
    end
    for i = 5, 2, -1 do
      for row = 1, self.size do
        if i == 2 then
          self.cubeData[i][row][y] = temp[row][y]
        else
          self.cubeData[i][row][y] = self.cubeData[i - 1][row][y]
        end
      end
    end
    if y == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[6][yy][self.size - xx + 1]
        end
      end
      self.cubeData[6] = t
    elseif y == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[1][yy][self.size - xx + 1]
        end
      end
      self.cubeData[1] = t
    end
  elseif face == 1 then
    local data = {}
    for xx = 1, self.size do
      local row = self.cubeData[3][y][self.size - xx + 1]
      table.insert(data, row)
      self.cubeData[3][y][self.size - xx + 1] = self.cubeData[1][xx][y]
    end
    for xx = 1, self.size do
      self.cubeData[1][xx][y] = self.cubeData[5][self.size - y + 1][xx]
    end
    for xx = 1, self.size do
      self.cubeData[5][self.size - y + 1][xx] = self.cubeData[6][self.size - xx + 1][y]
    end
    for xx = 1, self.size do
      self.cubeData[6][self.size - xx + 1][y] = data[xx]
    end
    if y == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[2][self.size - yy + 1][xx]
        end
      end
      self.cubeData[2] = t
    elseif y == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[4][yy][self.size - xx + 1]
        end
      end
      self.cubeData[4] = t
    end
  else
    local data = {}
    for xx = 1, self.size do
      local row = self.cubeData[6][x][xx]
      table.insert(data, row)
      self.cubeData[6][x][xx] = self.cubeData[2][x][self.size - xx + 1]
    end
    for xx = 1, self.size do
      self.cubeData[2][x][xx] = self.cubeData[1][x][xx]
    end
    for xx = 1, self.size do
      self.cubeData[1][x][xx] = self.cubeData[4][self.size - x + 1][self.size - xx + 1]
    end
    for xx = 1, self.size do
      self.cubeData[4][self.size - x + 1][xx] = data[xx]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[5][self.size - yy + 1][xx]
        end
      end
      self.cubeData[5] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[3][yy][self.size - xx + 1]
        end
      end
      self.cubeData[3] = t
    end
  end
end

function RubikCube:RotVerticalData(face, x, y, rot, roleCtrl, bossCtrl)
  if rot < 0 then
    self:RotVerticalClockwise(face, x, y)
  else
    self:RotVerticalUnClockwise(face, x, y)
  end
  self:RefreshCubeLabel(roleCtrl, bossCtrl)
end

function RubikCube:RotVerticalClockwise(face, x, y)
  if face == 3 then
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[3][x][self.size - yy + 1])
    end
    for yy = 1, self.size do
      self.cubeData[3][x][self.size - yy + 1] = self.cubeData[6][self.size - yy + 1][x]
    end
    for yy = 1, self.size do
      self.cubeData[6][self.size - yy + 1][x] = self.cubeData[5][self.size - x + 1][yy]
    end
    for yy = 1, self.size do
      self.cubeData[5][self.size - x + 1][yy] = self.cubeData[1][yy][x]
    end
    for yy = 1, self.size do
      self.cubeData[1][yy][x] = data[yy]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[2][yy][self.size - xx + 1]
        end
      end
      self.cubeData[2] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[4][self.size - yy + 1][xx]
        end
      end
      self.cubeData[4] = t
    end
  elseif face == 5 then
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[5][x][yy])
    end
    for yy = 1, self.size do
      self.cubeData[5][x][yy] = self.cubeData[6][self.size - yy + 1][self.size - x + 1]
    end
    for yy = 1, self.size do
      self.cubeData[6][self.size - yy + 1][self.size - x + 1] = self.cubeData[3][self.size - x + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[3][self.size - x + 1][self.size - yy + 1] = self.cubeData[1][yy][self.size - x + 1]
    end
    for yy = 1, self.size do
      self.cubeData[1][yy][self.size - x + 1] = data[yy]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[4][yy][self.size - xx + 1]
        end
      end
      self.cubeData[4] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[2][self.size - yy + 1][xx]
        end
      end
      self.cubeData[2] = t
    end
  elseif face == 4 then
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[4][x][yy])
    end
    for yy = 1, self.size do
      self.cubeData[4][x][yy] = self.cubeData[6][self.size - x + 1][yy]
    end
    for yy = 1, self.size do
      self.cubeData[6][self.size - x + 1][yy] = self.cubeData[2][self.size - x + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[2][self.size - x + 1][self.size - yy + 1] = self.cubeData[1][self.size - x + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[1][self.size - x + 1][self.size - yy + 1] = data[yy]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[3][yy][self.size - xx + 1]
        end
      end
      self.cubeData[3] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[5][self.size - yy + 1][xx]
        end
      end
      self.cubeData[5] = t
    end
  elseif face == 2 then
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[2][x][yy])
    end
    for yy = 1, self.size do
      self.cubeData[2][x][yy] = self.cubeData[6][x][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[6][x][self.size - yy + 1] = self.cubeData[4][self.size - x + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[4][self.size - x + 1][self.size - yy + 1] = self.cubeData[1][x][yy]
    end
    for yy = 1, self.size do
      self.cubeData[1][x][yy] = data[yy]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[5][yy][self.size - xx + 1]
        end
      end
      self.cubeData[5] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[3][self.size - yy + 1][xx]
        end
      end
      self.cubeData[3] = t
    end
  elseif face == 1 then
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[1][x][yy])
    end
    for yy = 1, self.size do
      self.cubeData[1][x][yy] = self.cubeData[2][x][yy]
    end
    for yy = 1, self.size do
      self.cubeData[2][x][yy] = self.cubeData[6][x][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[6][x][self.size - yy + 1] = self.cubeData[4][self.size - x + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[4][self.size - x + 1][self.size - yy + 1] = data[yy]
    end
    if x == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[5][yy][self.size - xx + 1]
        end
      end
      self.cubeData[5] = t
    elseif x == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[3][self.size - yy + 1][xx]
        end
      end
      self.cubeData[3] = t
    end
  else
    local data = {}
    for yy = 1, self.size do
      table.insert(data, self.cubeData[6][yy][y])
    end
    for yy = 1, self.size do
      self.cubeData[6][yy][y] = self.cubeData[5][self.size - y + 1][self.size - yy + 1]
    end
    for yy = 1, self.size do
      self.cubeData[5][self.size - y + 1][self.size - yy + 1] = self.cubeData[1][self.size - yy + 1][y]
    end
    for yy = 1, self.size do
      self.cubeData[1][self.size - yy + 1][y] = self.cubeData[3][y][yy]
    end
    for yy = 1, self.size do
      self.cubeData[3][y][yy] = data[yy]
    end
    if y == 1 then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[2][yy][self.size - xx + 1]
        end
      end
      self.cubeData[2] = t
    elseif y == self.size then
      local t = {}
      for xx = 1, self.size do
        for yy = 1, self.size do
          if t[xx] == nil then
            t[xx] = {}
          end
          t[xx][yy] = self.cubeData[4][self.size - yy + 1][xx]
        end
      end
      self.cubeData[4] = t
    end
  end
end

function RubikCube:RotVerticalUnClockwise(face, x, y)
  for i = 1, 3 do
    self:RotVerticalClockwise(face, x, y)
  end
end

function RubikCube:GetAll()
  local affectedCubes = {}
  for face = 1, 6 do
    for x = 1, self.size do
      for y = 1, self.size do
        table.insert(affectedCubes, self.cubeData[face][x][y])
      end
    end
  end
  return affectedCubes
end

function RubikCube:GetCube(face, x, y)
  if self.cubeData == nil or self.cubeData[face] == nil or self.cubeData[face][x] == nil then
    return nil
  end
  return self.cubeData[face][x][y]
end

function RubikCube:GetRoundCubes(step, face, x, y)
  local result = {}
  for k, v in pairs(self.cubeData[face]) do
    for m, n in pairs(v) do
      local temp = math.abs(k - x) + math.abs(m - y)
      if 0 < temp and step >= temp then
        table.insert(result, n)
      end
    end
  end
  return result
end

function RubikCube:GetCubeTypeNum(cubeType)
  local result = 0
  for i = 1, 6 do
    for x = 1, self.size do
      for y = 1, self.size do
        local cube = self.cubeData[i][x][y]
        if cube.netData then
          local eventCfg = GetCA(tonumber(cube.netData), "ActivityListFactory")
          if eventCfg.typeId == cubeType then
            result = result + 1
          elseif cubeType == Enum_CubeType.Shop and eventCfg.typeId == Enum_CubeType.SpecialShop then
            result = result + 1
          end
        end
      end
    end
  end
  return result
end

function RubikCube:GetHorizontalAffected(face, x, y)
  local affectedCubes = {}
  if face ~= 6 then
    for r = 1, self.size do
      table.insert(affectedCubes, self.cubeData[face][r][y])
    end
  else
    for r = 1, self.size do
      table.insert(affectedCubes, self.cubeData[face][x][r])
    end
  end
  if face < 6 and 1 < face then
    for iface = 2, 5 do
      if iface ~= face then
        for r = 1, self.size do
          table.insert(affectedCubes, self.cubeData[iface][r][y])
        end
      end
    end
    if y == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[1][row][c])
        end
      end
    elseif y == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[6][row][c])
        end
      end
    end
  elseif face == 1 then
    for row = 1, self.size do
      table.insert(affectedCubes, self.cubeData[6][row][y])
      table.insert(affectedCubes, self.cubeData[3][y][row])
      table.insert(affectedCubes, self.cubeData[5][self.size - y + 1][row])
    end
    if y == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[2][row][c])
        end
      end
    elseif y == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[4][row][c])
        end
      end
    end
  else
    for row = 1, self.size do
      table.insert(affectedCubes, self.cubeData[1][x][row])
      table.insert(affectedCubes, self.cubeData[2][x][row])
      table.insert(affectedCubes, self.cubeData[4][self.size - x + 1][row])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[5][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[3][row][c])
        end
      end
    end
  end
  return affectedCubes
end

function RubikCube:GetCurSpecialNum(playerCube)
  if self.cubeData == nil then
    return 0
  end
  local result = 0
  for face, data in pairs(self.cubeData) do
    for x, row in pairs(data) do
      for y, cube in pairs(row) do
        if cube and cube ~= playerCube and cube.item and cube.item[1] and cube.item[1].num then
          result = result + cube.item[1].num
        end
      end
    end
  end
  return result
end

function RubikCube:GetVerticalAffected(face, x, y)
  local affectedCubes = {}
  if face == 3 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[3][x][col])
      table.insert(affectedCubes, self.cubeData[5][self.size - x + 1][col])
    end
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[1][self.size - col + 1][x])
      table.insert(affectedCubes, self.cubeData[6][self.size - col + 1][x])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[2][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[4][row][c])
        end
      end
    end
  elseif face == 5 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[5][x][col])
      table.insert(affectedCubes, self.cubeData[3][self.size - x + 1][col])
    end
    for row = 1, self.size do
      table.insert(affectedCubes, self.cubeData[1][row][self.size - x + 1])
      table.insert(affectedCubes, self.cubeData[6][row][self.size - x + 1])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[4][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[2][row][c])
        end
      end
    end
  elseif face == 1 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[1][x][col])
      table.insert(affectedCubes, self.cubeData[6][x][col])
      table.insert(affectedCubes, self.cubeData[2][x][col])
      table.insert(affectedCubes, self.cubeData[4][self.size - x + 1][col])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[5][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[3][row][c])
        end
      end
    end
  elseif face == 6 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[6][col][y])
      table.insert(affectedCubes, self.cubeData[1][col][y])
      table.insert(affectedCubes, self.cubeData[5][self.size - y + 1][col])
      table.insert(affectedCubes, self.cubeData[3][y][col])
    end
    if y == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[2][row][c])
        end
      end
    elseif y == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[4][row][c])
        end
      end
    end
  elseif face == 2 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[2][x][col])
      table.insert(affectedCubes, self.cubeData[4][self.size - x + 1][col])
      table.insert(affectedCubes, self.cubeData[6][x][col])
      table.insert(affectedCubes, self.cubeData[1][x][col])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[5][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[3][row][c])
        end
      end
    end
  elseif face == 4 then
    for col = 1, self.size do
      table.insert(affectedCubes, self.cubeData[4][x][col])
      table.insert(affectedCubes, self.cubeData[2][self.size - x + 1][col])
      table.insert(affectedCubes, self.cubeData[6][self.size - x + 1][col])
      table.insert(affectedCubes, self.cubeData[1][self.size - x + 1][col])
    end
    if x == 1 then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[3][row][c])
        end
      end
    elseif x == self.size then
      for c = 1, self.size do
        for row = 1, self.size do
          table.insert(affectedCubes, self.cubeData[5][row][c])
        end
      end
    end
  end
  return affectedCubes
end

return RubikCube
