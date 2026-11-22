local View = require("UIHistoryList/UIHistoryListView")
local DataModel = require("UIHistoryList/UIHistoryListDataModel")
local ViewFunction = {
  HistoryList_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  HistoryList_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  HistoryList_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HistoryList_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  HistoryList_Group_Btn_Btn_Friend_Click = function(btn, str)
    DataModel.SelectRecordClick(DataModel.ERecordType.Total)
  end,
  HistoryList_Group_Btn_Btn_Detail_Click = function(btn, str)
    DataModel.SelectRecordClick(DataModel.ERecordType.ToDay)
  end,
  HistoryList_Group_FriendList_ScrollGrid__SetGrid = function(element, elementIndex)
    local data = DataModel.totalRecord[elementIndex]
    local baseData = DataModel.GetFriendBaseData(data.uid)
    local avatar = baseData.avatar
    if avatar and avatar ~= "" then
      local profilePhotoCA = PlayerData:GetFactoryData(avatar, "ProfilePhotoFactory")
      element.Group_Info.Img_Head.Img_Mask.Img_Character:SetSprite(profilePhotoCA.imagePath)
    else
      local gender = data.gender
      local head = PlayerData:GetFactoryData(99900001, "ConfigFactory")
      if head and head.playerHeadList then
        element.Group_Info.Img_Head.Img_Mask.Img_Character:SetSprite(head.playerHeadList[gender + 1].playerHeadPath)
      end
    end
    element.Group_Info.Txt_Name:SetText(baseData.role_name)
    element.Group_Info.Txt_Lv:SetText(baseData.playground.lv)
    element.Group_Good.Txt_Num:SetText(data.like_cnt)
    element.Group_Help.Txt_Num:SetText(data.help_cnt)
    element.Group_Steal.Txt_Num:SetText(data.steal_cnt .. "/" .. data.steal_num)
    local date = os.date("*t", data.look_ts)
    local month = string.format("%02d", date.month)
    local day = string.format("%02d", date.day)
    element.Group_Time.Txt_Num:SetText(string.format(GetText(80610213), month, day))
  end,
  HistoryList_Group_DetailList_ScrollGrid__SetGrid = function(element, elementIndex)
    local data = DataModel.todayRecord[elementIndex]
    local baseData = DataModel.GetFriendBaseData(data.uid)
    local avatar = baseData.avatar
    if avatar and avatar ~= "" then
      local profilePhotoCA = PlayerData:GetFactoryData(avatar, "ProfilePhotoFactory")
      element.Group_Info.Img_Head.Img_Mask.Img_Character:SetSprite(profilePhotoCA.imagePath)
    else
      local gender = data.gender
      local head = PlayerData:GetFactoryData(99900001, "ConfigFactory")
      if head and head.playerHeadList then
        element.Group_Info.Img_Head.Img_Mask.Img_Character:SetSprite(head.playerHeadList[gender + 1].playerHeadPath)
      end
    end
    element.Group_Info.Txt_Name:SetText(baseData.role_name)
    element.Group_Info.Txt_Lv:SetText(baseData.playground.lv)
    element.Group_Good.Txt_Num:SetText(data.like_cnt)
    element.Group_Help.Txt_Num:SetText(data.help_cnt)
    element.Group_Steal.Txt_Num:SetText(data.steal_cnt .. "/" .. data.steal_num)
    local date = os.date("*t", data.look_ts)
    local hour = string.format("%02d", date.hour)
    local minute = string.format("%02d", date.min)
    element.Group_Time.Txt_Num:SetText(hour .. ":" .. minute)
  end
}
return ViewFunction
