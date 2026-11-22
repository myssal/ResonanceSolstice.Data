local View = require("UIServerConstruction/UIServerConstructionView")
local DataModel = require("UIServerConstruction/UIServerConstructionDataModel")
local Controller = {}

function Controller:Init()
  if DataModel.isAll then
    View.self:PlayAnim("All")
  else
    View.self:PlayAnim("One")
  end
  DataModel.InitData()
  Controller:RefreshGrid()
  Controller:TopRightClick()
  Controller:RefreshLeft()
  Controller:RefreshTopRed()
end

function Controller:LeftOne()
  local Group_One = View.Group_Left.Group_One
  Group_One.self:SetActive(true)
  Group_One.Txt_Num:SetText(NumThousandsSplit(PlayerData:GetActivityPersonalConstructionCstNum(DataModel.activityCA.id)))
end

function Controller:LeftAll()
  local Group_All = View.Group_Left.Group_All
  Group_All.self:SetActive(true)
  Group_All.Txt_Num:SetText(NumThousandsSplit(PlayerData:GetActivityServerConstructionCstNum(DataModel.activityCA.id)))
end

function Controller:RefreshLeft()
  View.Group_Left.Group_All.self:SetActive(false)
  View.Group_Left.Group_One.self:SetActive(false)
  if DataModel.isAll then
    Controller:LeftAll()
  else
    Controller:LeftOne()
  end
end

function Controller:RefreshTopRed()
  local Group_TopLeft = View.Group_TopLeft
  Group_TopLeft.Group_All.Img_RedPoint:SetActive(DataModel.serverRed)
  Group_TopLeft.Group_One.Img_RedPoint:SetActive(DataModel.personalRed)
end

function Controller:TopRightClick()
  local Group_TopLeft = View.Group_TopLeft
  if DataModel.isAll then
    Group_TopLeft.Group_All.Group_On.self:SetActive(true)
    Group_TopLeft.Group_One.Group_On.self:SetActive(false)
    View.Group_TopTip.self:SetActive(true)
  else
    Group_TopLeft.Group_All.Group_On.self:SetActive(false)
    Group_TopLeft.Group_One.Group_On.self:SetActive(true)
    View.Group_TopTip.self:SetActive(false)
  end
end

function Controller:RefreshGrid()
  View.Group_Right.self:SetActive(true)
  View.Group_Right.ScrollGrid_ProgressList.grid.self:SetDataCount(#DataModel.allStage)
  View.Group_Right.ScrollGrid_ProgressList.grid.self:RefreshAllElement()
  View.Group_Right.ScrollGrid_ProgressList.grid.self:MoveToTop()
end

function Controller:SetGridElement(element, elementIndex)
  local row = DataModel.allStage[elementIndex]
  element.Group_Complete.self:SetActive(false)
  element.Group_Already.self:SetActive(false)
  element.Group_Wei.self:SetActive(false)
  element.Img_Icon:SetSprite(DataModel.gridIcon)
  if row.state == DataModel.listState.notFinish then
    element.Group_Wei.self:SetActive(true)
    element.Group_Wei.Txt_Defult:SetText(GetText(DataModel.gridTextId))
  end
  if row.state == DataModel.listState.finish then
    element.Group_Already.self:SetActive(true)
    element.Group_Already.Txt_Defult:SetText(GetText(DataModel.gridTextId))
  end
  if row.state == DataModel.listState.recv then
    element.Group_Complete.self:SetActive(true)
    element.Group_Complete.self:SetActive(true)
    element.Group_Complete.Txt_Defult:SetText(GetText(DataModel.gridTextId))
  end
  element.Group_Stage.Txt_Num:SetText(row.index)
  element.Group_Goal.Txt_Num:SetText(NumThousandsSplit(row.max_num))
  element.Group_Goal.Txt_Tips:SetActive(DataModel.isAll)
  if DataModel.isAll then
    element.Group_Goal.Txt_Tips:SetText(string.format(GetText(80609069), row.limit))
  end
  element.Btn_:SetClickParam(elementIndex)
  element.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
  element.ScrollGrid_Reward.grid.self:SetDataCount(table.count(row.rewardList))
  element.ScrollGrid_Reward.grid.self:RefreshAllElement()
end

function Controller:ClickReward(info)
  if info.state ~= DataModel.listState.finish then
    return
  end
  local addFridgeSpace = 0
  for i, v in pairs(info.rewardList) do
    if DataManager:GetFactoryNameById(v.id) == "FridgeItemFactory" then
      local itemCA = PlayerData:GetFactoryData(v.id, "FridgeItemFactory")
      if itemCA then
        addFridgeSpace = addFridgeSpace + itemCA.space * v.num
      end
    end
  end
  if 0 < addFridgeSpace and PlayerData:GetUserInfo().space_info.now_food_material_num + addFridgeSpace > PlayerData:GetUserInfo().space_info.max_food_material_num then
    CommonTips.OpenTips(80601477)
    return
  end
  local index = info.index
  
  local function callBack()
    Net:SendProto("main.get_activity_stage", function(json)
      if DataModel.isAll then
        table.insert(PlayerData:GetActivityData(DataModel.activityCA.id).ser_reward, index - 1)
      else
        table.insert(PlayerData:GetActivityData(DataModel.activityCA.id).per_reward, index - 1)
      end
      Controller:Init()
      CommonTips.OpenShowItem(json.reward)
    end, DataModel.activityCA.id, DataModel:GetStageType(), index - 1)
  end
  
  if 0 < info.tipsId then
    CommonTips.OnPrompt(info.tipsId, nil, nil, callBack)
    return
  end
  callBack()
end

return Controller
