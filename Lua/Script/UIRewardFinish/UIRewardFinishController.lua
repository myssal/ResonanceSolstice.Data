local View = require("UIRewardFinish/UIRewardFinishView")
local DataModel = require("UIRewardFinish/UIRewardFinishDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init(data)
  local passCount = data.passCount
  local isWin = data.isWin
  View.Group_Reward.Group_Win.self:SetActive(isWin)
  View.Group_Reward.Group_Lose.self:SetActive(not isWin)
  DataModel.randBattleCA = PlayerData:GetFactoryData(data.rb_id or 89000001)
  DataModel.rewardList = {}
  for k, v in pairs(data.reward) do
    for t, rewardData in pairs(v) do
      DataModel.rewardList[tonumber(k) + 1] = {
        id = next(rewardData),
        num = rewardData[next(rewardData)].num
      }
      break
    end
  end
  local rewardCount = DataModel.randBattleCA.rewardFinish[passCount + 1].num
  DataModel.rewardCount = rewardCount
  View.Group_Reward.Txt_Level:SetText(passCount)
  View.Group_Reward.StaticGrid_Reward.grid.self:SetDataCount(rewardCount)
  View.Group_Reward.StaticGrid_Reward.grid.self:RefreshAllElement()
  View.Group_CommonTopLeft:SetActive(false)
end

function Controller:OnSetRewardGrid(element, elementIndex)
  local data = DataModel.rewardList[elementIndex]
  element.Btn_Reward:SetActive(data == nil)
  element.Group_Item.self:SetActive(data ~= nil)
  if data ~= nil then
    BtnItem:SetItem(element.Group_Item, {
      id = data.id,
      num = data.num
    })
    element.Group_Item.Btn_Item:SetClickParam(data.id)
  else
    element.Btn_Reward:SetClickParam(elementIndex - 1)
  end
end

function Controller:OnGetReward(str)
  local index = tonumber(str)
  Net:SendProto("battle.box_reward", function(json)
    local reward = json.reward
    for itemType, dic in pairs(reward) do
      for k, v in pairs(dic) do
        DataModel.rewardList[index + 1] = {
          id = k,
          num = v.num
        }
      end
    end
    if table.count(DataModel.rewardList) >= DataModel.rewardCount then
      View.Group_CommonTopLeft:SetActive(true)
    end
    View.Group_Reward.StaticGrid_Reward.grid.self:RefreshAllElement()
  end, index)
end

function Controller:OnBtnBack()
  PlayerData.ServerData.rb_id = ""
  UIManager:ClosePanel(false, "UI/Activity/ActivityRandomBattle/RandomLevel")
  UIManager:GoBack()
end

return Controller
