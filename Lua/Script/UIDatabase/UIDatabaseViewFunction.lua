local View = require("UIDatabase/UIDatabaseView")
local DataModel = require("UIDatabase/UIDatabaseDataModel")

local function OpenDatabaseInfo(database_type)
  View.Group_Inside:SetActive(true)
  DataModel.GetDatabaseInfolist(0, database_type)
  View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:SetDataCount(#DataModel.databae_info_list)
  View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
  View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:MoveToTop()
  View.Group_Inside.Group_Right.Group_Top.Group_Num.Txt_GotNum:SetText(DataModel.unlockcnt)
  View.Group_Inside.Group_Right.Group_Top.Group_Num.Txt_TotalNum:SetText(DataModel.allcnt)
  View.Group_Inside.Group_Right.Group_Top.Group_Bar.Img_Top:SetFilledImgAmount(DataModel.unlockcnt / DataModel.allcnt)
  View.Group_Inside.Group_Right.Group_Bot.Group_Owned.Txt_Num:SetText(DataModel.unlockcnt)
  View.Group_Inside.Group_Right.Group_Bot.Group_UnOwned.Txt_Num:SetText(DataModel.allcnt - DataModel.unlockcnt)
  DataModel.HideLeftInfo()
  local name = DataModel.database_list[database_type].name
  local cfg_id = DataModel.database_list[database_type].id
  local icon = PlayerData:GetFactoryData(cfg_id).icon
  View.Group_Inside.Group_Right.Group_Top.Img_TitleIcon:SetSprite(icon)
  View.Group_Inside.Group_Right.Group_Top.Txt_Title:SetText(name)
  local value = 0
  if 0 < DataModel.allcnt then
    value = DataModel.FormatNum(DataModel.unlockcnt / DataModel.allcnt * 100)
  end
  View.Group_Inside.Group_Right.Group_Top.Txt_Percentage:SetText(value .. "%")
  View.Group_Inside.Group_Left.Img_LeftBg.Img_Categories.Txt_Content:SetText(name)
  View.self:PlayAnim("in_list")
  View.ScrollGrid_Outside.grid.self:SetActive(false)
end

local ViewFunction = {
  Database_Group_Inside_Group_Right_Group_Mid_ScrollGrid_FirstTabs_SetGrid = function(element, elementIndex)
    local data = DataModel.databae_info_list[elementIndex]
    element.Group_FirstTabs:SetActive(data.level == 2)
    element.Group_SecondTabs:SetActive(data.level == 3)
    element.Group_ThirdTabs:SetActive(data.level == 4)
    if data.level == 2 then
      element.Group_FirstTabs.Btn_FirstTab.Txt_Title:SetText(data.name)
      element.Group_FirstTabs.Btn_FirstTab:SetClickParam(elementIndex)
      element.Group_FirstTabs.Btn_FirstTab.Img_Folding:SetActive(not data.expand)
      element.Group_FirstTabs.Btn_FirstTab.Img_Unfold:SetActive(data.expand)
      element.Group_FirstTabs.Btn_FirstTab.Img_FirstSelection:SetActive(DataModel.select1_indx == data.id)
      element.Group_FirstTabs.Btn_FirstTab.Img_New:SetActive(DataModel.GetNewCount(data.id) > 0)
    elseif data.level == 3 then
      element.Group_SecondTabs.Btn_SecondTab.Txt_Title:SetText(data.name)
      element.Group_SecondTabs.Btn_SecondTab:SetClickParam(elementIndex)
      local hasExpand = DataModel.IsMenuHasExpand(data.id)
      element.Group_SecondTabs.Btn_SecondTab.Group_Fold:SetActive(hasExpand)
      if hasExpand then
        element.Group_SecondTabs.Btn_SecondTab.Group_Fold.Img_Folding:SetActive(not data.expand)
        element.Group_SecondTabs.Btn_SecondTab.Group_Fold.Img_Unfold:SetActive(data.expand)
        element.Group_SecondTabs.Btn_SecondTab.Img_New:SetActive(DataModel.GetNewCount(data.id) > 0)
        element.Group_SecondTabs.Btn_SecondTab.Img_Locked:SetActive(false)
        element.Group_SecondTabs.Btn_SecondTab.Img_SecondSelection:SetActive(DataModel.select2_indx == data.id)
      else
        local unLock = DataModel.IsWordUnLock(data.id)
        element.Group_SecondTabs.Btn_SecondTab.Img_New:SetActive(unLock and PlayerData:GetPlayerPrefs("int", data.id) == 0)
        element.Group_SecondTabs.Btn_SecondTab.Img_SecondSelection:SetActive(unLock and DataModel.select2_indx == data.id)
        element.Group_SecondTabs.Btn_SecondTab.Img_Locked:SetActive(not unLock)
        element.Group_SecondTabs.Btn_SecondTab.Img_Locked.Img_Frame:SetActive(not unLock and DataModel.select2_indx == data.id)
      end
      element.Group_SecondTabs.Btn_SecondTab.Img_SecondSelection.Txt_TitleBlack:SetText(data.name)
      element.Group_SecondTabs.Btn_SecondTab.Txt_Title:SetText(data.name)
    elseif data.level == 4 then
      element.Group_ThirdTabs.Btn_ThirdTab.Txt_Title:SetText(data.name)
      element.Group_ThirdTabs.Btn_ThirdTab:SetClickParam(elementIndex)
      local unLock = DataModel.IsWordUnLock(data.id)
      element.Group_ThirdTabs.Btn_ThirdTab.Img_ThirdSelection.Txt_TitleBlack:SetText(data.name)
      element.Group_ThirdTabs.Btn_ThirdTab.Img_ThirdSelection:SetActive(unLock and DataModel.select3_indx == data.id)
      element.Group_ThirdTabs.Btn_ThirdTab.Img_New:SetActive(unLock and PlayerData:GetPlayerPrefs("int", data.id) == 0)
      element.Group_ThirdTabs.Btn_ThirdTab.Img_Locked:SetActive(not unLock)
      element.Group_ThirdTabs.Btn_ThirdTab.Img_Locked.Img_Frame:SetActive(not unLock and DataModel.select3_indx == data.id)
    end
  end,
  Database_Group_Inside_Group_Right_Group_Mid_ScrollGrid_FirstTabs_Group_Item_Group_FirstTabs_Btn_FirstTab_Click = function(btn, str)
    local indx = tonumber(str)
    local data = DataModel.databae_info_list[indx]
    local operate_type = data.expand and -1 or 1
    if operate_type == 1 then
      DataModel.select1_indx = data.id
      DataModel.select2_indx = nil
      DataModel.select3_indx = nil
      DataModel.AddExpandData(indx)
      DataModel.RefreshLeftInfo(indx)
    else
      if DataModel.select1_indx == data.id then
        DataModel.select1_indx = nil
        DataModel.HideLeftInfo()
      end
      DataModel.RemoveExpandData(indx)
    end
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:SetDataCount(#DataModel.databae_info_list)
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
  end,
  Database_Group_Inside_Group_Right_Group_Mid_ScrollGrid_FirstTabs_Group_Item_Group_SecondTabs_Btn_SecondTab_Click = function(btn, str)
    local indx = tonumber(str)
    local data = DataModel.databae_info_list[indx]
    local hasExpand = DataModel.IsMenuHasExpand(data.id)
    if hasExpand then
      local operate_type = data.expand and -1 or 1
      if operate_type == 1 then
        DataModel.select1_indx = data.front
        DataModel.select2_indx = data.id
        DataModel.select3_indx = nil
        DataModel.AddExpandData(indx)
        DataModel.RefreshLeftInfo(indx)
      else
        if DataModel.select2_indx == data.id then
          DataModel.select2_indx = nil
          DataModel.HideLeftInfo()
        end
        DataModel.RemoveExpandData(indx)
      end
      View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:SetDataCount(#DataModel.databae_info_list)
      View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
    else
      DataModel.select3_indx = nil
      DataModel.select2_indx = data.id
      DataModel.select1_indx = data.front
      if DataModel.IsWordUnLock(data.id) then
        PlayerData:SetPlayerPrefs("int", data.id, 1)
      end
      View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
      DataModel.RefreshLeftInfo(indx)
    end
  end,
  Database_Group_Inside_Group_Right_Group_Mid_Group_SiftList_Img_SiftMaterial_Btn_Refresh_Click = function(btn, str)
  end,
  Database_Group_Inside_Group_Right_Group_Mid_Group_SiftList_ScrollGrid_SiftList_SetGrid = function(element, elementIndex)
  end,
  Database_Group_Inside_Group_Right_Group_Mid_Group_SiftList_ScrollGrid_SiftList_Group_Item_Btn_On_Click = function(btn, str)
  end,
  Database_Group_Inside_Group_Right_Group_Mid_Group_SiftList_Btn_Confirm_Click = function(btn, str)
  end,
  Database_Group_Inside_Group_Right_Group_Mid_Group_SiftList_Btn_Cancel_Click = function(btn, str)
  end,
  Database_Group_Inside_Group_Right_Group_Bot_Group_Owned_Btn_Off_Click = function(btn, str)
    local select_type
    if DataModel.select_type ~= 1 then
      select_type = 1
      View.Group_Inside.Group_Right.Group_Bot.Group_Owned.Btn_Off.Img_On:SetActive(true)
      View.Group_Inside.Group_Right.Group_Bot.Group_UnOwned.Btn_Off.Img_On:SetActive(false)
    else
      select_type = 0
      View.Group_Inside.Group_Right.Group_Bot.Group_Owned.Btn_Off.Img_On:SetActive(false)
    end
    View.Group_Inside.Group_Right.Group_Bot.Group_Owned.Txt_Num:SetText(DataModel.unlockcnt)
    DataModel.GetDatabaseInfolist(select_type, DataModel.data_type)
    View.Group_Inside.Group_Left.Group_Owned:SetActive(false)
    View.Group_Inside.Group_Left.Group_UnOwned:SetActive(true)
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:SetDataCount(#DataModel.databae_info_list)
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:MoveToTop()
  end,
  Database_Group_Inside_Group_Right_Group_Bot_Group_UnOwned_Btn_Off_Click = function(btn, str)
    local select_type
    if DataModel.select_type ~= 2 then
      select_type = 2
      View.Group_Inside.Group_Right.Group_Bot.Group_Owned.Btn_Off.Img_On:SetActive(false)
      View.Group_Inside.Group_Right.Group_Bot.Group_UnOwned.Btn_Off.Img_On:SetActive(true)
    else
      select_type = 0
      View.Group_Inside.Group_Right.Group_Bot.Group_UnOwned.Btn_Off.Img_On:SetActive(false)
    end
    DataModel.GetDatabaseInfolist(select_type, DataModel.data_type)
    View.Group_Inside.Group_Left.Group_Owned:SetActive(false)
    View.Group_Inside.Group_Left.Group_UnOwned:SetActive(true)
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:SetDataCount(#DataModel.databae_info_list)
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:MoveToTop()
  end,
  Database_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if View.ScrollGrid_Outside.grid.self.IsActive then
      UIManager:GoBack()
    else
      View.Group_Inside:SetActive(false)
      View.ScrollGrid_Outside.grid.self:SetActive(true)
      View.ScrollGrid_Outside.grid.self:SetDataCount(table.count(DataModel.database_list))
      View.ScrollGrid_Outside.grid.self:RefreshAllElement()
      View.self:PlayAnim("in")
    end
  end,
  Database_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Database_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Database_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Database_ScrollGrid_Outside_SetGrid = function(element, elementIndex)
    local row = DataModel.database_list[tonumber(elementIndex)]
    local Btn_Guide = element.Btn_Guide
    Btn_Guide:SetSprite(row.coverPage)
    Btn_Guide.Group_Top.Img_TitleIcon:SetSprite(row.icon)
    Btn_Guide.Group_Top.Txt_Title:SetText(row.name)
    element.Btn_Guide:SetClickParam(elementIndex)
    local unlockcnt = row.unlockcnt
    local allcnt = row.allcnt
    Btn_Guide.Group_Top.Group_Num.Txt_GotNum:SetText(unlockcnt)
    Btn_Guide.Group_Top.Group_Num.Txt_TotalNum:SetText(allcnt)
    local fill = 1 < unlockcnt / allcnt and 1 or unlockcnt / allcnt
    Btn_Guide.Group_Top.Group_Bar.Img_Top:SetFilledImgAmount(fill)
    local value = 0
    if 0 < allcnt then
      value = DataModel.FormatNum(fill * 100)
    end
    Btn_Guide.Group_Top.Txt_Percentage:SetText(value .. "%")
    local new_cnt = row.new_cnt
    Btn_Guide.Img_New:SetActive(0 < new_cnt)
  end,
  Database_ScrollGrid_Outside_Group_Item_Btn_Guide_Click = function(btn, str)
    local index = tonumber(str)
    local row = DataModel.database_list[index]
    if row.id == 80300339 then
      local cfg = PlayerData:GetFactoryData(row.id, "ListFactory")
      UIManager:Open("UI/Notebook/NotebookEnter", Json.encode({
        dataTab = cfg.dataTab
      }))
      return
    end
    if row.interfaceUrl ~= "" then
      UIManager:Open(row.interfaceUrl)
      return
    end
    OpenDatabaseInfo(index)
  end,
  Database_Group_Inside_Group_Right_Group_Mid_ScrollGrid_FirstTabs_Group_Item_Group_ThirdTabs_Btn_ThirdTab_Click = function(btn, str)
    local indx = tonumber(str)
    local data = DataModel.databae_info_list[indx]
    DataModel.select3_indx = data.id
    local frontIndex = DataModel.GetMenuIndex(data.front)
    DataModel.select2_indx = data.front
    local secondData = DataModel.databae_info_list[frontIndex]
    DataModel.select1_indx = secondData.front
    DataModel.RefreshLeftInfo(indx)
    if DataModel.IsWordUnLock(data.id) then
      PlayerData:SetPlayerPrefs("int", data.id, 1)
    end
    View.Group_Inside.Group_Right.Group_Mid.ScrollGrid_FirstTabs.grid.self:RefreshAllElement()
  end
}
return ViewFunction
