local View = require("UISettleAccount/UISettleAccountView")
local DataModel = {}
DataModel.win = 0
DataModel.damageTotal = 0
DataModel.reward = {}
DataModel.gukaList = {}
local PosYList = {
  0,
  -259,
  -548,
  -906,
  -1265,
  -1537,
  -1908
}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.win = data.win
  if data.win == 1 then
    DataModel.damageTotal = data.damageTotal or 0
  end
end

function DataModel.InitData()
  local parkMapCA = WitchData.GetParkMapCA()
  if DataModel.win == 1 then
    local reward = {}
    local param = 0
    local damageTotal = DataModel.damageTotal
    for i, v in ipairs(parkMapCA.finialParam) do
      if damageTotal < v.num then
        break
      end
      param = v.param
    end
    if 0 < param then
      for i, v in ipairs(parkMapCA.finialWinAward) do
        table.insert(reward, {
          itemId = v.id,
          num = v.num * param
        })
      end
    end
    DataModel.reward = reward
    local gukaList = {}
    local witchesData = WitchData.GetWitchesData()
    if witchesData.guka then
      for i, v in pairs(witchesData.guka) do
        if v.had == 1 then
          local data = Clone(v)
          data.id = i
          table.insert(gukaList, data)
        end
      end
    end
    table.sort(gukaList, function(a, b)
      return tonumber(a.id) > tonumber(b.id)
    end)
    DataModel.gukaList = gukaList
  else
    local reward = {}
    for i, v in ipairs(parkMapCA.finialLossAward) do
      table.insert(reward, {
        itemId = v.id,
        num = v.num
      })
    end
    DataModel.reward = reward
  end
end

function DataModel.RefreshOnShow()
  local win = DataModel.win == 1
  View.Group_Win:SetActive(win)
  View.Group_Lose:SetActive(not win)
  if win then
    local showCtrList = {}
    local witchesData = WitchData.GetWitchesData()
    local damageTotal = DataModel.damageTotal
    local damageTotalStr = require("UIWitchesRanking/UIWitchesRankingDataModel").SimpleDamageValue(damageTotal)
    View.Group_Win.ScrollView_.Viewport.Content.Group_Damage.Txt_:SetText(damageTotalStr)
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Damage)
    View.Group_Win.ScrollView_.Viewport.Content.Group_Reward.ScrollGrid_Rewards.grid.self:SetActive(#DataModel.reward > 0)
    if #DataModel.reward > 0 then
      View.Group_Win.ScrollView_.Viewport.Content.Group_Reward.ScrollGrid_Rewards.grid.self:SetDataCount(#DataModel.reward)
      View.Group_Win.ScrollView_.Viewport.Content.Group_Reward.ScrollGrid_Rewards.grid.self:RefreshAllElement()
    end
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Reward)
    local seals = witchesData.user_seal
    View.Group_Win.ScrollView_.Viewport.Content.Group_Seal.StaticGrid_Seal.grid.self:SetActive(0 < #seals)
    if 0 < #seals then
      View.Group_Win.ScrollView_.Viewport.Content.Group_Seal.StaticGrid_Seal.grid.self:SetDataCount(#seals)
      View.Group_Win.ScrollView_.Viewport.Content.Group_Seal.StaticGrid_Seal.grid.self:RefreshAllElement()
    end
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Seal)
    View.Group_Win.ScrollView_.Viewport.Content.Group_Guka.ScrollGrid_Guka.grid.self:SetActive(0 < #DataModel.gukaList)
    if 0 < #DataModel.gukaList then
      View.Group_Win.ScrollView_.Viewport.Content.Group_Guka.ScrollGrid_Guka.grid.self.ScrollRect.enabled = #DataModel.gukaList > 7
      View.Group_Win.ScrollView_.Viewport.Content.Group_Guka.ScrollGrid_Guka.grid.self:SetDataCount(#DataModel.gukaList)
      View.Group_Win.ScrollView_.Viewport.Content.Group_Guka.ScrollGrid_Guka.grid.self:RefreshAllElement()
    end
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Guka)
    local restBuff = WitchData.GetRestBuffData()
    View.Group_Win.ScrollView_.Viewport.Content.Group_Tea.Img_Tea:SetActive(not string.nilorempty(restBuff))
    if not string.nilorempty(restBuff) then
      local eventCA = PlayerData:GetFactoryData(88800120, "MonopolyEventFactory")
      for i, v in ipairs(eventCA.buffList) do
        if v.id == tonumber(restBuff) then
          View.Group_Win.ScrollView_.Viewport.Content.Group_Tea.Img_Tea:SetSprite(WitchData.GetUIPath(v.teaBuffIcon))
          break
        end
      end
    end
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Tea)
    local parkMapCA = WitchData.GetParkMapCA()
    for i, v in pairs(parkMapCA.ticketBuffList) do
      if tostring(v.id) == witchesData.ticket_id then
        View.Group_Win.ScrollView_.Viewport.Content.Group_Ticket.Img_Ticket:SetSprite(v.ticketShowPath)
        break
      end
    end
    table.insert(showCtrList, View.Group_Win.ScrollView_.Viewport.Content.Group_Ticket)
    for i, v in ipairs(showCtrList) do
      v:SetAnchoredPositionY(PosYList[i])
    end
  else
    View.Group_Lose.Group_.Group_Reward.ScrollGrid_Rewards.grid.self:SetDataCount(#DataModel.reward)
    View.Group_Lose.Group_.Group_Reward.ScrollGrid_Rewards.grid.self:RefreshAllElement()
  end
end

return DataModel
