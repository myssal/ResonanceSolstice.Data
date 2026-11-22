local View = require("UIArrestTips/UIArrestTipsView")
local CommonItem = require("Common/BtnItem")
local DataModel = {}

function DataModel:Init(param)
  self.maxNum = param.maxNum
  self.wave_list = param.wave_list
  self.arrestItem = param.arrestItem
  self.curSelectNum = nil
  self.isSkip = param.isSkip
  self.reward = param.reward
  self:InitUI()
  self:SetSelectNum(1)
end

function DataModel:InitUI()
  CommonItem:SetItem(View.Group_Item, {
    id = self.arrestItem,
    num = PlayerData:GetGoodsById(self.arrestItem).num
  })
  View.Group_Slider.Group_Num.Txt_Possess:SetText(self.maxNum)
end

function DataModel:SetSelectNum(num)
  if num == self.curSelectNum then
    return
  end
  self.curSelectNum = num
  self:RefreshSelectNumView()
  self._isSliderChanging = true
  View.Group_Slider.Slider_Value:SetSliderValue((num - 1) / math.max(1, self.maxNum - 1))
  self._isSliderChanging = false
end

function DataModel:RefreshSelectNumView()
  local num = self.curSelectNum
  View.Group_Slider.Group_Num.Txt_Select:SetText(num)
end

function DataModel:OnSliderValue(percent)
  if self._isSliderChanging == true then
    return
  end
  local newUseNum = math.ceil(math.max(self.maxNum - 1, 1) * percent + 1)
  newUseNum = math.min(self.maxNum, math.max(1, newUseNum))
  self.curSelectNum = newUseNum
  self:RefreshSelectNumView()
end

function DataModel:ShowItemDetails(str)
  CommonTips.OpenPreRewardDetailTips(self.arrestItem, nil, true)
end

function DataModel:DoArrest()
  if self.curSelectNum <= 0 or self.curSelectNum > self.maxNum then
    return
  end
  Net:SendProto("prison.arrest_prisoner", function(json)
    local item = PlayerData:GetGoodsById(tostring(self.arrestItem))
    item.num = json.arrest_item_num
    View.self:Confirm()
    UIManager:GoBack(false, 1)
    if table.count(json.arrest_dict) > 0 then
      UIManager:Open("UI/Prison/ArrestPrisoner/Arrest_Success", Json.encode({
        prisonerDic = json.arrest_dict,
        isSkip = self.isSkip,
        reward = self.reward
      }))
    else
      CommonTips.OpenTips(GetText(80600210))
    end
  end, self.wave_list, self.curSelectNum)
end

return DataModel
