local View = require("UIActivityEndlessBattle/UIActivityEndlessBattleView")
local DataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  ActivityEndlessBattle_Group_Main_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
    local rewardList = activityCA.rewardPreviewList
    CommonItem:SetActivityPreviewItem(element.Group_Item, rewardList[elementIndex])
    element.Group_Item.Btn_Item:SetClickParam(rewardList[elementIndex].id)
  end,
  ActivityEndlessBattle_Group_Main_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  ActivityEndlessBattle_Group_Main_Btn_Start_Click = function(btn, str)
    local function cb()
      Net:SendProto("endless.activity_main", function(json)
        UIManager:Open("UI/Activity/ActivityEndlessBattle/EndlessBattle", Json.encode({
          activityId = DataModel.activityId,
          
          user_endless = json.user_endless
        }))
      end, DataModel.activityId)
    end
    
    local activityCA = PlayerData:GetFactoryData(DataModel.activityId)
    if TimeUtil:IsActive(activityCA.startTime, activityCA.endTime) then
      if activityCA.joinPlotId and activityCA.joinPlotId ~= -1 and activityCA.joinPlotId ~= "" and PlayerData.plot_paragraph[tostring(activityCA.joinPlotId)] == nil then
        UIManager:Open("UI/Dialog/Dialog", Json.encode({
          id = activityCA.joinPlotId
        }), cb, cb)
      else
        cb()
      end
    else
      View.Group_Main.Btn_Start:SetActive(false)
      CommonTips.OpenTips(80609542)
    end
  end,
  ActivityEndlessBattle_Group_Main_Btn_Shop_Click = function(btn, str)
    local parms = {}
    parms.activityId = DataModel.activityId
    local activityCA = PlayerData:GetFactoryData(parms.activityId)
    parms.shopId = activityCA.activityStoreList[1].id
    Net:SendProto("shop.info", function(json)
      UIManager:Open("UI/Activity/ActivityEndlessBattle/EndlessBattleStore", Json.encode(parms))
    end)
  end,
  ActivityEndlessBattle_Group_Main_Group_PowerRole_Group_Item_Btn_Role_Click = function(btn, str)
  end,
  ActivityEndlessBattle_Group_Main_Group_PowerRole_StaticGrid_RoleList_SetGrid = function(element, elementIndex)
    local powerRoleList = DataModel.powerRoleList
    local roleData = powerRoleList[elementIndex]
    local roleCA = PlayerData:GetFactoryData(roleData.id)
    local viewCA = PlayerData:GetFactoryData(roleCA.viewId)
    element.Img_Mask.Img_Head:SetSprite(viewCA.face)
    local haveRole = PlayerData.ServerData.roles[tostring(roleData.id)] ~= nil
    element.Img_Un:SetActive(not haveRole)
    element.Btn_Role:SetClickParam(elementIndex)
  end,
  ActivityEndlessBattle_Group_Main_Group_PowerRole_StaticGrid_RoleList_Group_Item_Btn_Role_Click = function(btn, str)
    local index = tonumber(str)
    local powerRoleList = DataModel.powerRoleList
    local roleData = powerRoleList[index]
    local roleId = roleData.id
    local haveRole = PlayerData.ServerData.roles[tostring(roleId)] ~= nil
    if haveRole then
      local data = {
        currentRoleId = roleId,
        fromView = EnumDefine.CommonFilterType.SquadView
      }
      Net:SendProto("hero.info", function(json)
        if json.roles then
          PlayerData.ServerData.roles[roleId] = json.roles[roleId]
          UIManager:Open("UI/CharacterInfo/CharacterInfo", Json.encode(data))
        end
      end, tonumber(roleId))
    else
      CommonTips.OpenUnitDetail({id = roleId})
    end
  end,
  ActivityEndlessBattle_Group_Main_Group_PowerRole_Btn_Help_Click = function(btn, str)
    local isOpen = DataModel.isHelpOpen == true
    View.Group_Main.Group_PowerRole.Group_Help:SetActive(not isOpen)
    DataModel.isHelpOpen = not isOpen
  end,
  ActivityEndlessBattle_Group_Main_Btn_Help_Click = function(btn, str)
    View.Group_Help:SetActive(true)
  end,
  ActivityEndlessBattle_Group_Help_Btn_Close_Click = function(btn, str)
    View.Group_Help:SetActive(false)
  end,
  ActivityEndlessBattle_Group_Help_Group_window_Group_tabList_Group_Tab_000_Btn__Click = function(btn, str)
  end
}
return ViewFunction
