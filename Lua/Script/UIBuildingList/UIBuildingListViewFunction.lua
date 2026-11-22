local View = require("UIBuildingList/UIBuildingListView")
local DataModel = require("UIBuildingList/UIBuildingListDataModel")
local NPCDialog = require("Common/NPCDialog")

local function PlayNPCTalk(talk_type)
  local npcConfig = PlayerData:GetFactoryData(DataModel.NpcId, "NPCFactory")
  local textTable = npcConfig[talk_type]
  if textTable then
    NPCDialog.SetNPCText(View.Group_NPC, textTable, talk_type)
  end
end

local function RefreshPanel()
  View.Group_Main.self:SetActive(true)
  View.Group_CommonTopLeft:SetActive(true)
  View.Group_NPC.self:SetActive(true)
  View.Img_BG:SetSprite(DataModel.BgPath)
  View.Img_BG:SetColor("#" .. DataModel.BgColor)
  NPCDialog.SetNPC(View.Group_NPC, DataModel.NpcId)
  PlayNPCTalk("enterText")
  local stationConfig = PlayerData:GetFactoryData(DataModel.StationId, "HomeStationFactory")
  View.Group_Main.Group_NpcInfo.Group_Station.Txt_Station:SetText(stationConfig.name)
  View.Group_Main.Group_NpcInfo.Img_Icon:SetSprite(DataModel.buildingIconPath)
  View.Group_Main.Group_NpcInfo.Txt_Title:SetText(DataModel.name)
end

local ViewFunction = {
  BuildingList_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  BuildingList_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    CommonCoachData.GoHome()
  end,
  BuildingList_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BuildingList_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BuildingList_Group_Main_ScrollGrid__SetGrid = function(element, elementIndex)
    local data = DataModel.openList[elementIndex]
    element.Btn_List.Img_:SetSprite(data.icon)
    element.Btn_List.Txt_:SetText(data.name)
    element.Btn_List:SetClickParam(elementIndex)
  end,
  BuildingList_Group_Main_ScrollGrid__Group_Item_Btn_List_Click = function(btn, str)
    local data = DataModel.openList[tonumber(str)]
    if data.isTalk then
      PlayNPCTalk("talkText")
      return
    end
    if data.showUI == "UI/ParkRevenue/Group_Income" then
      Net:SendProto("playground.park_reward", function(json)
        local IncomeDataModel = require("UIGroup_Income/UIGroup_IncomeDataModel")
        if json and json.interface then
          IncomeDataModel.curIncome = json.interface.gold
          local playGroundData = PlayerData.GetPlaygroundData(87300002)
          playGroundData.casual = json.interface.casual
          playGroundData.psg = json.interface.psg
          playGroundData.pub = json.interface.pub
          playGroundData.pond = json.interface.pond
          playGroundData.invest_num = json.interface.invest_num
        end
        UIManager:Open("UI/ParkRevenue/Group_Income")
      end, 0, 87300002)
      return
    end
    if 0 < data.bubId then
      require("UICityMap/UICityMapController"):ClickBtn(nil, {
        bubbleId = data.bubId,
        idx = data.listIndex
      })
      return
    end
    if data.buildId == 84400087 then
      Net:SendProto("shop.info", function(json)
        UIManager:Open("UI/Building/BuildingShop", Json.encode({
          stationId = DataModel.StationId,
          buildId = data.buildId
        }))
      end)
      return
    end
  end,
  BuildingList_Group_Reputation_Btn_Reputation_Click = function(btn, str)
  end,
  RefreshPanel = RefreshPanel
}
return ViewFunction
