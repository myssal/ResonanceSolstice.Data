local View = require("UIParoleRoom/UIParoleRoomView")
local DataModel = require("UIParoleRoom/UIParoleRoomDataModel")
local Controller = {}

function Controller:ScoreSortDown(List)
  table.sort(List, function(a, b)
    return a.score > b.score
  end)
end

function Controller:ScoreSortUp(List)
  table.sort(List, function(a, b)
    return a.score < b.score
  end)
end

function Controller:TimeSortDown(List)
  table.sort(List, function(a, b)
    return a.remainTime > b.remainTime
  end)
end

function Controller:TimeSortUp(List)
  table.sort(List, function(a, b)
    return a.remainTime < b.remainTime
  end)
end

function Controller:Init()
  DataModel.InitData()
  View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Group_Choose:SetActive(false)
  DataModel.SortState.index = 1
  DataModel.SortState.currentDown = false
  View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Txt_:SetText(GetText(80608524))
  View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Img_PaixuSheng:SetActive(not DataModel.SortState.currentDown)
  View.Group_ParoleRoomList.Group_Prisoner.Group_Paixu.Img_PaixuJiang:SetActive(DataModel.SortState.currentDown)
  View.ParoleRoomPrompt:SetActive(false)
  Controller:RefreshData()
  Controller:RefreshCoin()
  View.Group_ParoleRoomList.Group_Prisoner.Group_Prisoner.Group_Title.Txt_Num:SetText(table.count(DataModel.SortCanParolePrisonerData) + table.count(DataModel.SortCantParolePrisonerData))
  local refreshCost = PrisonData.GetPrisonCA().refreshItemList
  View.Group_LawyerList.Group_Refresh.Txt_Num:SetText(refreshCost[1].num)
end

function Controller:SetCanParolePrisonerElement(element, elementIndex)
  local row = DataModel.SortCanParolePrisonerData[elementIndex]
  local cfg = PlayerData:GetFactoryData(row.id)
  element.Group_Prisoner.Txt_Name:SetText(cfg.prisonerName)
  element.Group_Prisoner.Txt_Time:SetText(row.time)
  element.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
  element.Group_Prisoner.Txt_Score:SetText(row.score)
  element.Group_Prisoner.Group_Money.Txt_Money:SetText(DataModel.CalParoleMoney(row.score, row.payParam))
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:SetCantParolePrisonerElement(element, elementIndex)
  local row = DataModel.SortCantParolePrisonerData[elementIndex]
  local cfg = PlayerData:GetFactoryData(row.id)
  element.Group_Prisoner.Txt_Name:SetText(cfg.prisonerName)
  element.Group_Prisoner.Txt_Time:SetText(row.time)
  element.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
  element.Group_Prisoner.Txt_Score:SetText(row.score)
end

function Controller:SetPrisonerElement(element, elementIndex)
  element.Group_NoInfo:SetActive(false)
  local needUp = DataModel.CanParoleCount == 0
  if elementIndex == 1 then
    element.Group_NoInfo:SetActive(DataModel.CanParoleCount == 0)
    element.Group_TitleCanParole:SetActive(true)
    element.Group_TitleCantParole:SetActive(false)
    element.Group_CanRelease:SetActive(false)
    element.Group_CantRelease:SetActive(false)
  elseif elementIndex == table.count(DataModel.SortCanParolePrisonerData) + 2 then
    element.Group_TitleCantParole.self:SetAnchoredPositionY(needUp and 40 or 140)
    element.Group_NoInfo:SetActive(#DataModel.SortCantParolePrisonerData == 0)
    element.Group_TitleCanParole:SetActive(false)
    element.Group_TitleCantParole:SetActive(true)
    element.Group_CanRelease:SetActive(false)
    element.Group_CantRelease:SetActive(false)
  elseif 1 < elementIndex and elementIndex <= table.count(DataModel.SortCanParolePrisonerData) + 1 then
    element.Group_TitleCanParole:SetActive(false)
    element.Group_TitleCantParole:SetActive(false)
    element.Group_CanRelease:SetActive(true)
    element.Group_CantRelease:SetActive(false)
    element.Group_CanRelease.self:SetAnchoredPositionY(145)
    local rowElement = elementIndex - 1
    local row = DataModel.SortCanParolePrisonerData[rowElement]
    if row then
      local cfg = PlayerData:GetFactoryData(row.id)
      local remainDay = row.remainTime // 86400
      local ctr = element.Group_CanRelease
      ctr.Group_Prisoner.Group_Num.Txt_:SetText("No." .. string.format("%06d", row.clint_num))
      ctr.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
      ctr.Group_Prisoner.Txt_Name:SetText(cfg.prisonerName)
      ctr.Group_Prisoner.Txt_Score:SetText(string.format(GetText(80608486), row.score))
      ctr.Group_Prisoner.Txt_Time:SetText(string.format(GetText(80608485), remainDay))
      ctr.Group_Prisoner.Group_Money.Group_Money.Txt_Num:SetText(DataModel.CalParoleMoney(row.score, row.payParam))
      if DataModel.HasLawyer() then
        ctr.Group_Prisoner.Group_Money.Txt_Commission:SetActive(true)
        ctr.Group_Prisoner.Group_Money.Txt_Commission:SetText(string.format(GetText(80608530), math.floor(DataModel.GetLawyerCost() * 100)))
      else
        ctr.Group_Prisoner.Group_Money.Txt_Commission:SetActive(false)
      end
      ctr.Btn_:SetClickParam(rowElement)
    end
  elseif elementIndex > table.count(DataModel.SortCanParolePrisonerData) + 2 then
    element.Group_TitleCanParole:SetActive(false)
    element.Group_TitleCantParole:SetActive(false)
    element.Group_CanRelease:SetActive(false)
    element.Group_CantRelease:SetActive(true)
    element.Group_CantRelease.self:SetAnchoredPositionY(needUp and 185 or 285)
    local rowElement = elementIndex - 2 - DataModel.CanParoleCount
    local row = DataModel.SortCantParolePrisonerData[rowElement]
    if row then
      local cfg = PlayerData:GetFactoryData(row.id)
      local remainDay = row.remainTime // 86400
      local ctr = element.Group_CantRelease
      ctr.Group_Prisoner.Txt_Name:SetText(cfg.prisonerName)
      ctr.Group_Prisoner.Group_Num.Txt_:SetText("No." .. string.format("%06d", row.clint_num))
      ctr.Group_Prisoner.Img_Prisoner:SetSprite(cfg.prisonerIconPath)
      ctr.Group_Prisoner.Txt_Score:SetText(string.format(GetText(80608489), row.score))
      ctr.Group_Prisoner.Txt_Time:SetText(string.format(GetText(80608485), remainDay))
    end
  end
end

function Controller:RefreshPrisonerList()
  Controller:SortCanParoleData()
  Controller:SortCantParoleData()
  View.Group_ParoleRoomList.Group_NoPrison:SetActive(table.count(DataModel.SortCanParolePrisonerData) + table.count(DataModel.SortCantParolePrisonerData) == 0)
  View.Group_ParoleRoomList.Group_Prisoner.Group_Prisoner.Group_PrisonerList.ScrollView_.Viewport.Content.ScrollGrid_.grid.self:SetDataCount(table.count(DataModel.SortCanParolePrisonerData) + table.count(DataModel.SortCantParolePrisonerData) + 2)
  View.Group_ParoleRoomList.Group_Prisoner.Group_Prisoner.Group_PrisonerList.ScrollView_.Viewport.Content.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller:RefreshLawyer()
  local hasLawyer = DataModel.HasLawyer()
  View.Group_ParoleRoomList.Group_Lawyer:SetActive(hasLawyer)
  View.Group_ParoleRoomList.Group_NoLawyer:SetActive(not hasLawyer)
  if hasLawyer then
    local row = DataModel.CurLawyerData
    local ctr = View.Group_ParoleRoomList.Group_Lawyer
    ctr.Btn_Stop:SetActive(true)
    ctr.Btn_Employ:SetActive(false)
    local remainTime = DataModel.GetCurLawyerRemainTime()
    ctr.Group_Ability.Group_Time.Txt_Num:SetText(string.format(GetText(80608512), remainTime // 86400))
    ctr.Txt_Name:SetText(row.cfg.lawyerName)
    ctr.Group_Level.Txt_:SetText(row.cfg.starLevel)
    ctr.Img_Pic:SetSprite(row.cfg.lawyerPicturePath)
    ctr.Group_Ability.Group_MoneyAdd.Txt_Des:SetText(string.format(GetText(80608490), row.cfg.moneyAdd))
    ctr.Group_Ability.Group_Money.Group_Cost.Txt_Num:SetText(row.cfg.moneyCost)
    ctr.Group_Ability.Group_Money.Group_CostPer.Txt_People:SetText(string.format(GetText(80608510), math.floor(row.cfg.moneyCostPer * 100)))
  end
end

function Controller:SetLawyerListElement(element, elementIndex)
  local row = DataModel.LawyerList[elementIndex]
  if row then
    local isCur = DataModel.IsCurLawyer(row.id)
    if isCur then
      local remainDay = DataModel.GetCurLawyerRemainTime() // 86400
      element.Group_Ability.Group_Time.Txt_Num:SetText(string.format(GetText(80608512), remainDay))
    else
      element.Group_Ability.Group_Time.Txt_Num:SetText(string.format(GetText(80608512), row.day))
    end
    element.Btn_Stop:SetActive(isCur)
    element.Btn_Employ:SetActive(not isCur)
    element.Txt_Name:SetText(row.cfg.lawyerName)
    element.Img_Pic:SetSprite(row.cfg.lawyerPicturePath)
    element.Group_Level.Txt_:SetText(row.cfg.starLevel)
    element.Group_Ability.Group_MoneyAdd.Txt_Des:SetText(string.format(GetText(80608490), row.cfg.moneyAdd))
    element.Group_Ability.Group_Money.Group_Cost.Txt_Num:SetText(row.cfg.moneyCost)
    element.Group_Ability.Group_Money.Group_CostPer.Txt_People:SetText(string.format(GetText(80608510), math.floor(row.cfg.moneyCostPer * 100)))
    element.Btn_Stop:SetClickParam(elementIndex)
    element.Btn_Employ:SetClickParam(elementIndex)
  end
end

function Controller:RefreshLawyerList()
  View.Group_LawyerList.StaticGrid_.grid.self:SetDataCount(table.count(DataModel.LawyerList))
  View.Group_LawyerList.StaticGrid_.grid.self:RefreshAllElement()
end

function Controller:RefreshCoin()
  View.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetGoodsById(11400001).num)
end

function Controller:RefreshTitle()
  View.Group_ParoleRoomList.Group_Title.Txt_Level:SetText("Lv." .. DataModel.RoomLevel)
  local roomLevelId = PlayerData:GetFactoryData(87500016).roomList[DataModel.RoomLevel].config
  local cfg = PlayerData:GetFactoryData(roomLevelId)
  View.Group_ParoleRoomList.Group_Title.Txt_LevelName:SetText(cfg.roomDesc)
  View.Group_ParoleRoomList.Group_Title.Group_LowestScore.Txt_LowestScore:SetText(string.format(GetText(80608481), cfg.lowestScore))
end

function Controller:RefreshData()
  Controller:RefreshTitle()
  Controller:RefreshPrisonerList()
  Controller:RefreshLawyer()
  View.Group_LawyerList:SetActive(false)
end

function Controller:OpenPrompt(data)
  if not data then
    CommonTips.OpenTips(GetText(80608045))
    return
  end
  local cfg = PlayerData:GetFactoryData(data.id)
  View.ParoleRoomPrompt.Group_Item.Img_Pic:SetSprite(cfg.prisonerIconPath)
  View.ParoleRoomPrompt.Group_Item.Group_ID.Txt_ID:SetText(string.format(GetText(80607161), string.format("%06d", data.clint_num)))
  View.ParoleRoomPrompt.Group_Item.Group_ID.Img_Rarity:SetSprite(PlayerData:GetFactoryData(cfg.prisonerRarity).prisonerRarity)
  local coinCount = DataModel.CalParoleMoney(data.score, data.payParam)
  View.ParoleRoomPrompt.Txt_Money:SetText(string.format(GetText(80607998), "Gold", coinCount))
  View.ParoleRoomPrompt:SetActive(true)
  View.self:PlayAnimOnce("ParoleRoomPrompt_In")
end

function Controller:OpenPromptOneBtnParole()
  CommonTips.OnPrompt(GetText(80609144), nil, nil, function()
    Controller:OneBtnParole()
  end, nil)
end

function Controller:OneBtnParole()
  if DataModel.CanParoleCount <= 0 then
    return
  end
  for i, v in pairs(DataModel.SortCanParolePrisonerData) do
    if v.days * 86400 + v.enterTime < TimeUtil:GetServerTimeStamp() then
      CommonTips.OpenTips(GetText(80608045))
      return
    end
  end
  local prisonerList = {}
  for i, v in pairs(DataModel.SortCanParolePrisonerData) do
    table.insert(prisonerList, v.u_pid)
  end
  Net:SendProto("prison.parole", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    if json.prison_backpack then
      PlayerData.ServerData.user_prison_info.prison_backpack = json.prison_backpack
    end
    if json.raw_material_workshops then
      PlayerData.ServerData.user_prison_info.raw_material_workshops = json.raw_material_workshops
    end
    if json.workshops_front then
      PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
    end
    if json.workshops_master then
      PlayerData.ServerData.user_prison_info.workshops_master = json.workshops_master
    end
    DataModel.ChoosePrisonerList = {}
    DataModel.CollectPrisonerList()
    Controller:RefreshPrisonerList()
    Controller:RefreshCoin()
    View.Group_ParoleRoomList.Group_Prisoner.Group_Prisoner.Group_Title.Txt_Num:SetText(table.count(DataModel.SortCanParolePrisonerData) + table.count(DataModel.SortCantParolePrisonerData))
  end, Json.encode(prisonerList))
end

function Controller:TryParole()
  if table.count(DataModel.ChoosePrisonerList) == 0 or table.count(DataModel.ChoosePrisonerList) > 1 then
    return
  end
  for i, v in pairs(DataModel.ChoosePrisonerList) do
    if v.days * 86400 + v.enterTime < TimeUtil:GetServerTimeStamp() then
      CommonTips.OpenTips(GetText(80608045))
      return
    end
  end
  local prisonerList = {}
  for i, v in pairs(DataModel.ChoosePrisonerList) do
    table.insert(prisonerList, v.u_pid)
  end
  Net:SendProto("prison.parole", function(json)
    View.self:PlayAnimOnce("ParoleRoomPrompt_Out", function()
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      View.ParoleRoomPrompt:SetActive(false)
    end)
    if json.prison_backpack then
      PlayerData.ServerData.user_prison_info.prison_backpack = json.prison_backpack
    end
    if json.raw_material_workshops then
      PlayerData.ServerData.user_prison_info.raw_material_workshops = json.raw_material_workshops
    end
    if json.workshops_front then
      PlayerData.ServerData.user_prison_info.workshops_front = json.workshops_front
    end
    if json.workshops_master then
      PlayerData.ServerData.user_prison_info.workshops_master = json.workshops_master
    end
    DataModel.ChoosePrisonerList = {}
    DataModel.CollectPrisonerList()
    Controller:RefreshPrisonerList()
    Controller:RefreshCoin()
    View.Group_ParoleRoomList.Group_Prisoner.Group_Prisoner.Group_Title.Txt_Num:SetText(table.count(DataModel.SortCanParolePrisonerData) + table.count(DataModel.SortCantParolePrisonerData))
  end, Json.encode(prisonerList))
end

function Controller:TryRefreshLawyer()
  local refreshCost = PrisonData.GetPrisonCA().refreshItemList
  CommonTips.OnPrompt(string.format(GetText(80610305), "Diamond", refreshCost[1].num), nil, nil, function()
    if PlayerData:GetGoodsById(refreshCost[1].id).num < refreshCost[1].num then
      CommonTips.OpenTips(80600062)
      return
    end
    Net:SendProto("prison.refresh_lawyer_list", function(json)
      PlayerData.ServerData.user_prison_info.lawyers = json.lawyers
      DataModel.InitLawyerList()
      Controller:RefreshLawyerList()
    end)
  end)
end

function Controller:TryDoEmploy(idx, isEmploy)
  local row
  if idx == -1 then
    row = DataModel.CurLawyerData
  else
    row = DataModel.LawyerList[idx]
  end
  if row then
    if isEmploy then
      local t = {}
      t.itemId = 11400001
      t.useNum = row.cfg.moneyCost * row.day
      local itemCfg = PlayerData:GetFactoryData(t.itemId)
      CommonTips.OnPrompt(string.format(GetText(80607600), "Gold", row.cfg.moneyCost * row.day, itemCfg.name, row.cfg.lawyerName), nil, nil, function()
        if PlayerData:GetGoodsById(t.itemId).num < t.useNum then
          CommonTips.OpenTips(80600062)
          return
        end
        Net:SendProto("prison.employ_relieve_lawyer", function(json)
          PlayerData.ServerData.user_prison_info.cur_lawyer = json.cur_lawyer
          View.Group_ParoleRoomList.Group_Prisoner:SetActive(true)
          DataModel.InitCurLawyerData()
          Controller:RefreshLawyerList()
          Controller:RefreshLawyer()
          Controller:RefreshPrisonerList()
          Controller:RefreshCoin()
          View.self:PlayAnimOnce("LawyerList_Back", function()
            View.Group_LawyerList:SetActive(false)
          end)
        end, "employ", tostring(row.id))
      end)
    else
      CommonTips.OnPrompt(string.format(GetText(80607590), row.cfg.lawyerName), nil, nil, function()
        if DataModel.HasLawyer() then
          Net:SendProto("prison.employ_relieve_lawyer", function(json)
            PlayerData.ServerData.user_prison_info.cur_lawyer = json.cur_lawyer
            DataModel.InitCurLawyerData()
            Controller:RefreshLawyerList()
            Controller:RefreshLawyer()
            Controller:RefreshPrisonerList()
            Controller:RefreshCoin()
          end, "relieve")
        end
      end)
    end
  end
end

function Controller:SortCanParoleData()
  local index = DataModel.SortState.index
  if index == 2 then
    DataModel.SortCanParolePrisonerData = Clone(DataModel.CanParolePrisonerData)
    if DataModel.SortState.currentDown then
      Controller:ScoreSortDown(DataModel.SortCanParolePrisonerData)
    else
      Controller:ScoreSortUp(DataModel.SortCanParolePrisonerData)
    end
    return
  end
  if index == 1 then
    DataModel.SortCanParolePrisonerData = Clone(DataModel.CanParolePrisonerData)
    if DataModel.SortState.currentDown then
      Controller:TimeSortDown(DataModel.SortCanParolePrisonerData)
    else
      Controller:TimeSortUp(DataModel.SortCanParolePrisonerData)
    end
    return
  end
end

function Controller:SortCantParoleData()
  local index = DataModel.SortState.index
  if index == 2 then
    DataModel.SortCantParolePrisonerData = Clone(DataModel.CantParolePrisonerData)
    if DataModel.SortState.currentDown then
      Controller:ScoreSortDown(DataModel.SortCantParolePrisonerData)
    else
      Controller:ScoreSortUp(DataModel.SortCantParolePrisonerData)
    end
    return
  end
  if index == 1 then
    DataModel.SortCantParolePrisonerData = Clone(DataModel.CantParolePrisonerData)
    if DataModel.SortState.currentDown then
      Controller:TimeSortDown(DataModel.SortCantParolePrisonerData)
    else
      Controller:TimeSortUp(DataModel.SortCantParolePrisonerData)
    end
    return
  end
end

function Controller:Click(btn)
  if DataModel.SortState.currentBtn == btn then
    Controller:Revert(btn)
    Controller:RefreshData()
    return
  end
  Controller:Deactivate(DataModel.SortState.currentBtn)
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
  Controller:RefreshData()
end

function Controller:ResetActive(btn)
  for key, value in pairs(btn) do
    if key == "self" then
    elseif key == "Img_DeN" then
      btn[key]:SetActive(true)
    elseif key == "Img_DeP" then
      btn[key]:SetActive(true)
    else
      btn[key]:SetActive(false)
    end
  end
end

function Controller:Deactivate(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(true)
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(true)
  end
end

function Controller:Active(btn)
  if btn.Img_AN.gameObject.activeInHierarchy then
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_DeN.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Revert(btn)
  if btn.Img_DeP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(false)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(true)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = false
  elseif btn.Img_AP.gameObject.activeInHierarchy then
    btn.Img_DeP:SetActive(true)
    btn.Img_DeN:SetActive(false)
    btn.Img_AP:SetActive(false)
    btn.Img_AN:SetActive(false)
    DataModel.SortState.currentDown = true
  end
end

function Controller:Reset(btn)
  for key, value in pairs(View.Group_ParoleRoomList.Group_TopRightPrison) do
    if key ~= "self" then
      Controller:ResetActive(value)
      Controller:Deactivate(value)
    end
  end
  DataModel.SortState.currentBtn = btn
  Controller:Active(DataModel.SortState.currentBtn)
end

return Controller
