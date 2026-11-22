local View = require("UIPublicizeSendSuccess/UIPublicizeSendSuccessView")
local DataModel = {}
DataModel.playGroundId = nil
DataModel.publicizeType = nil
DataModel.publicizePondId = nil
DataModel.victorList = {}
DataModel.victorNum = 0
DataModel.sameCareerList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.playGroundId = data.playGroundId
  DataModel.publicizeType = data.publicizeType
  DataModel.publicizePondId = data.publicizePondId
  DataModel.victorList = data.victorList
end

function DataModel.InitData()
  local sameCareerList = {}
  DataModel.victorNum = 0
  if DataModel.victorList then
    for _, v in pairs(DataModel.victorList) do
      DataModel.victorNum = DataModel.victorNum + v.num
      local psgCA = PlayerData:GetFactoryData(v.psgId, "PassageFactory")
      local data = sameCareerList[psgCA.career] or {}
      for i = 1, v.num do
        table.insert(data, {
          psgId = v.psgId,
          tagId = v.tagId
        })
      end
      sameCareerList[psgCA.career] = data
    end
  end
  DataModel.sameCareerList = {}
  for i, v in pairs(sameCareerList) do
    table.insert(DataModel.sameCareerList, v)
  end
end

function DataModel.RefreshOnShow()
  local UIPublicizeMainDataModel = require("UIPublicizeMain/UIPublicizeMainDataModel")
  local remainNum = PlayerData:GetLeafLetNum()
  if DataModel.publicizeType == UIPublicizeMainDataModel.EnumPublicizeType.adv then
    remainNum = PlayerData:GetGoodsById(11400072).num
  end
  View.GroupResult.Group_center.Group_upper.Group_num.Txt_:SetText(remainNum)
  View.GroupResult.Group_center.Group_upper.Img_Leaflet:SetActive(DataModel.publicizeType == UIPublicizeMainDataModel.EnumPublicizeType.leaflet)
  View.GroupResult.Group_center.Group_upper.Img_Adv:SetActive(DataModel.publicizeType == UIPublicizeMainDataModel.EnumPublicizeType.adv)
  View.GroupResult.Group_LPng.Group_YouHui:SetActive(DataModel.publicizePondId == 85600116)
  View.GroupResult.Group_LPng.Group_ZhuTi:SetActive(DataModel.publicizePondId == 85600115)
  View.GroupResult.Group_LPng.Group_MingRen:SetActive(DataModel.publicizePondId == 85600117)
  DataModel.RefreshPassengerLike()
  DataModel.RefreshConsume()
  View.GroupResult.Group_bottom.Group_passengerNum.Txt_passengerNum:SetText(DataModel.victorNum)
end

DataModel.likeNumList = {
  comfort = 0,
  plantScores = 0,
  fishScores = 0,
  petScores = 0,
  foodScores = 0,
  playScores = 0,
  medicalScores = 0
}

local function GetCommonSum(psgCfg, tagCfg)
  local psgCANum = 0
  local tagCANum = 0
  for i, v in pairs(psgCfg) do
    psgCANum = psgCANum + v.common
  end
  for i, v in pairs(tagCfg) do
    tagCANum = tagCANum + v.common
  end
  return psgCANum + tagCANum
end

local function SetLevel(ctrl, level)
  for i = 1, 5 do
    local child = ctrl.transform:Find("Img_lv" .. i).gameObject
    child:SetActive(i <= level)
  end
end

function DataModel.RefreshPassengerLike()
  local psgCA, tagCA
  for i, v in pairs(DataModel.victorList) do
    psgCA = PlayerData:GetFactoryData(v.psgId, "PassageFactory")
    tagCA = PlayerData:GetFactoryData(v.tagId, "ListFactory")
    if GetCommonSum(psgCA.comfort, tagCA.comfort) > 0 then
      DataModel.likeNumList.comfort = DataModel.likeNumList.comfort + 1
    end
    if 0 < GetCommonSum(psgCA.plantScores, tagCA.plantScores) then
      DataModel.likeNumList.plantScores = DataModel.likeNumList.plantScores + 1
    end
    if 0 < GetCommonSum(psgCA.fishScores, tagCA.fishScores) then
      DataModel.likeNumList.fishScores = DataModel.likeNumList.fishScores + 1
    end
    if 0 < GetCommonSum(psgCA.petScores, tagCA.petScores) then
      DataModel.likeNumList.petScores = DataModel.likeNumList.petScores + 1
    end
    if 0 < GetCommonSum(psgCA.foodScores, tagCA.foodScores) then
      DataModel.likeNumList.foodScores = DataModel.likeNumList.foodScores + 1
    end
    if 0 < GetCommonSum(psgCA.playScores, tagCA.playScores) then
      DataModel.likeNumList.playScores = DataModel.likeNumList.playScores + 1
    end
    if 0 < GetCommonSum(psgCA.medicalScores, tagCA.medicalScores) then
      DataModel.likeNumList.medicalScores = DataModel.likeNumList.medicalScores + 1
    end
  end
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_medical, math.ceil(DataModel.likeNumList.medicalScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_play, math.ceil(DataModel.likeNumList.playScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_food, math.ceil(DataModel.likeNumList.foodScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_pet, math.ceil(DataModel.likeNumList.petScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_fish, math.ceil(DataModel.likeNumList.fishScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_plant, math.ceil(DataModel.likeNumList.plantScores / DataModel.victorNum * 5))
  SetLevel(View.GroupResult.Group_center.Group_under.Group_like.Group_comfort, math.ceil(DataModel.likeNumList.comfort / DataModel.victorNum * 5))
end

local function GetPaySum(psgCfg, tagCfg)
  local psgCANum = 0
  local tagCANum = 0
  for i, v in pairs(psgCfg) do
    psgCANum = psgCANum + v.pay
  end
  for i, v in pairs(tagCfg) do
    tagCANum = tagCANum + v.pay
  end
  return psgCANum + tagCANum
end

DataModel.psgPayList = {}
DataModel.totalPay = 0

function DataModel.RefreshConsume()
  local psgCA, tagCA, comfort, plant, fish, pet, food, play, medical
  DataModel.psgPayList = {}
  DataModel.totalPay = 0
  for _, v in pairs(DataModel.victorList) do
    psgCA = PlayerData:GetFactoryData(v.psgId, "PassageFactory")
    tagCA = PlayerData:GetFactoryData(v.tagId, "TagFactory")
    comfort = GetPaySum(psgCA.comfort, tagCA.comfort)
    plant = GetPaySum(psgCA.plantScores, tagCA.plantScores)
    fish = GetPaySum(psgCA.fishScores, tagCA.fishScores)
    pet = GetPaySum(psgCA.petScores, tagCA.petScores)
    food = GetPaySum(psgCA.foodScores, tagCA.foodScores)
    play = GetPaySum(psgCA.playScores, tagCA.playScores)
    medical = GetPaySum(psgCA.medicalScores, tagCA.medicalScores)
    local sum = (comfort + plant + fish + pet + food + play + medical) * v.num
    if not DataModel.psgPayList[psgCA.career] then
      DataModel.psgPayList[psgCA.career] = sum
    else
      DataModel.psgPayList[psgCA.career] = DataModel.psgPayList[psgCA.career] + sum
    end
    DataModel.totalPay = DataModel.totalPay + sum
  end
  table.sort(DataModel.sameCareerList, function(a, b)
    local psgCA1 = PlayerData:GetFactoryData(a[1].psgId, "PassageFactory")
    local psgCA2 = PlayerData:GetFactoryData(b[1].psgId, "PassageFactory")
    return DataModel.psgPayList[psgCA1.career] > DataModel.psgPayList[psgCA2.career]
  end)
  View.GroupResult.Group_R.ScrollGrid_list.grid.self:SetDataCount(table.count(DataModel.sameCareerList))
  View.GroupResult.Group_R.ScrollGrid_list.grid.self:RefreshAllElement()
end

return DataModel
