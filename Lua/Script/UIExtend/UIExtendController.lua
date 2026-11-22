local View = require("UIExtend/UIExtendView")
local DataModel = require("UIExtend/UIExtendDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  local coachCA = PlayerData:GetFactoryData(DataModel.initParams.coachId)
  DataModel.buildMaterialList = coachCA.buildMaterialList
  View.StaticGrid_Cost.grid.self:RefreshAllElement()
  View.Txt_LvLimit:SetText(string.format(GetText(80608116), coachCA.playgroundLv))
end

function Controller:RefreshElement(element, elementIndex)
  local info = DataModel.buildMaterialList[elementIndex]
  element:SetActive(info ~= nil)
  if info ~= nil then
    BtnItem:SetItem(element.Group_Item, {
      id = info.id
    })
    local curNum = PlayerData:GetGoodsById(info.id).num
    element.Img_Need.Txt_Need:SetText(PlayerData:TransitionNum(info.num))
    element.Img_Need.Txt_Have:SetText(PlayerData:TransitionNum(curNum))
    local color = "#FFFFFF"
    if curNum < info.num then
      color = "#FF0000"
    end
    element.Img_Need.Txt_Have:SetColor(color)
    element.Group_Item.Btn_Item:SetClickParam(info.id)
  end
end

function Controller:ClickItem(btn, str)
  local itemId = tonumber(str)
  CommonTips.OpenRewardDetail(itemId)
end

function Controller:Close()
  View.self:CloseUI()
end

function Controller:Confirm()
  local playgroundCA = PlayerData:GetFactoryData(DataModel.initParams.playgroundId)
  local coachCA = PlayerData:GetFactoryData(DataModel.initParams.coachId)
  local curPlaygroundLv = CommonCoachData.GetCurPlaygroundServerInfo().lv
  if curPlaygroundLv < coachCA.playgroundLv then
    CommonTips.OpenTips(playgroundCA.lvLimitTips)
    return
  end
  local useItem = {}
  for i, v in ipairs(coachCA.buildMaterialList) do
    if PlayerData:GetGoodsById(v.id).num < v.num then
      CommonTips.OpenTips(80600062)
      return
    end
    useItem[v.id] = v.num
  end
  Net:SendProto("playground.extend", function(json)
    PlayerData:RefreshUseItems(useItem)
    local block = CommonCoachData.GetRoomData()
    for k, v in pairs(json.block) do
      block[k] = v
    end
    CommonCoachData.RefreshData()
    local idx = #CommonCoachData.roomID
    HomeManager:AddRoom(tonumber(CommonCoachData.roomID[idx]), CommonCoachData.roomData[idx])
    HomeManager:OpenHome(idx - 1)
    Controller:Close()
    UIManager:Open("UI/Playground/ExtendSuccess")
  end, DataModel.initParams.playgroundId)
end

return Controller
