local View = require("UIMiniGameBSRank/UIMiniGameBSRankView")
local D = require("UIMiniGameBSRank/UIMiniGameBSRankDataModel")
local C = require("UIMiniGameBS/MiniGameBSSettings")
local Network = require("UIMiniGameBS/MiniGameBSNetwork")
local GameData = require("UIMiniGameBS/UIMiniGameBSDataModel")
local Controller = {generation = 0}

local function integerText(value)
  return string.format("%.0f", tonumber(value) or 0)
end

local function label(key)
  return GetText(C.text[key])
end

local function message(key)
  View.Group_Panel.Txt_Message:SetText(key and label(key) or "")
end

function Controller.Init(params)
  Controller.generation = Controller.generation + 1
  Controller.alive = true
  D.params = type(params) == "table" and params or params and params ~= "" and Json.decode(params) or {}
  D.rows, D.cache, D.loading = {}, {}, false
  D.rankId, D.config = Network.GetRank(D.params.bossId)
  local p = View.Group_Panel
  p.Group_Stats.Group_Total.Txt_Value:SetText("--")
  p.Group_Stats.Group_Personal.Txt_Value:SetText("--")
  p.Txt_Empty:SetActive(false)
  p.ScrollGrid_List.grid.self:SetDataCount(C.rank.minimumRows)
  if D.config then
    Controller.Request(true)
  else
    message("rankUnavailable")
  end
end

function Controller.Request(first)
  if not Controller.alive or D.loading or not D.config then
    return
  end
  if not first and not D.cache.has_more then
    return
  end
  D.loading, D.waitTime = true, 0
  local generation, offset = Controller.generation, first and 0 or tonumber(D.cache.next_index) or #D.rows
  
  local function valid()
    return Controller.alive and Controller.generation == generation
  end
  
  Network.QueryRank(D.config, not first and D.cache or nil, function(json)
    if not valid() then
      return
    end
    D.loading = false
    if tonumber(json.status) == 1 then
      D.cache.has_more = false
      message("rankError")
      return
    end
    if first then
      D.rows = {}
    end
    for i, row in ipairs(json.rank_list or {}) do
      D.rows[offset + i] = row
    end
    D.cache = {
      request_id = json.request_id,
      next_index = json.next_index,
      has_more = json.has_more == true or json.has_more == 1
    }
    if #(json.rank_list or {}) == 0 then
      D.cache.has_more = false
    end
    if D.cache.has_more and (D.cache.request_id == nil or D.cache.next_index == nil) then
      D.cache.has_more = false
    end
    local p = View.Group_Panel
    if json.total_hit_count ~= nil then
      p.Group_Stats.Group_Total.Txt_Value:SetText(integerText(json.total_hit_count))
    end
    if first or json.my_rank then
      p.Group_Stats.Group_Personal.Txt_Value:SetText(integerText(json.my_rank and json.my_rank.val or 0))
    end
    if GameData.state and GameData.rankId == D.rankId then
      GameData.ApplyRank(json)
    end
    p.Txt_Empty:SetActive(false)
    message(nil)
    local count = math.max(C.rank.minimumRows, #D.rows + (D.cache.has_more and 1 or 0))
    p.ScrollGrid_List.grid.self:SetDataCount(count)
    p.ScrollGrid_List.grid.self:RefreshAllElement()
    if first then
      p.ScrollGrid_List.grid.self:MoveToTop()
    end
  end)
end

function Controller.SetRow(element, index)
  local row = D.rows[index]
  element.Img_Oneself:SetActive(row ~= nil and row.uid == PlayerData:GetUserInfo().uid)
  element.Txt_Order:SetText(integerText(row and row.rank or index))
  element.Txt_Name:SetText(row and (row.role_name or "") or "")
  element.Txt_Count:SetText(row and integerText(row.val) or "")
  if not row and D.cache.has_more and index == #D.rows + 1 then
    Controller.Request(false)
  end
end

function Controller.Destroy()
  Controller.alive = false
  Controller.generation = Controller.generation + 1
  require("UIMiniGameBS/UIMiniGameBSController").ResumeRank()
end

function Controller.Close()
  UIManager:GoBack(false)
end

function Controller.Update()
  if not Controller.alive then
    return
  end
  if CS.UnityEngine.Input.GetKeyDown("escape") then
    Controller.Close()
    return
  end
  if D.loading then
    D.waitTime = D.waitTime + CS.UnityEngine.Time.unscaledDeltaTime
    if D.waitTime >= 15 then
      Controller.generation = Controller.generation + 1
      D.loading = false
      D.cache.has_more = false
      message("rankError")
    end
  end
end

return Controller
