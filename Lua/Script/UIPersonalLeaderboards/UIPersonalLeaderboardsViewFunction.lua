local View = require("UIPersonalLeaderboards/UIPersonalLeaderboardsView")
local DataModel = require("UIPersonalLeaderboards/UIPersonalLeaderboardsDataModel")
local ViewFunction = {
  PersonalLeaderboards_Btn_Quit_Click = function(btn, str)
    UIManager:GoBack(false, 1)
  end,
  PersonalLeaderboards_ScrollGrid_RecordList_SetGrid = function(element, elementIndex)
    local data = DataModel.resultList[elementIndex]
    local duration = data.duration
    local minutes = math.floor(duration / 60)
    local remainingSeconds = math.floor(duration % 60)
    element.Txt_Duration:SetText(string.format("%02d:%02d", minutes, remainingSeconds))
    element.Txt_Harm:SetText(PlayerData:NumToFormatString(data.damageTotal, 2))
    local groupRoles = element.Group_CharacterFaceList
    for i = 1, #data.roles do
      local skinId = data.roles[i].face
      groupRoles["Group_Face00" .. i - 1].Img_Mask.Img_Face:SetSprite(PlayerData:GetFactoryData(skinId).face)
    end
    element.Btn_Details:SetClickParam(elementIndex)
    local isNew = elementIndex == DataModel.newIndex
    element.Img_New:SetActive(isNew)
    element.Txt_Time:SetText(os.date("%Y/%m/%d", data.create_ts))
  end,
  PersonalLeaderboards_ScrollGrid_RecordList_Leaderboard_Btn_Details_Click = function(btn, str)
    local data = DataModel.resultList[tonumber(str)]
    data.levelId = DataModel.levelId
    UIManager:Open("UI/Battle/TestLevelDetail", Json.encode(data))
  end
}

function ViewFunction:Init(params)
  if params.tipText then
    View.Img_Title.Txt_Tip:SetText(GetText(params.tipText))
  else
    View.Img_Title.Txt_Tip:SetText(GetText(80607302))
  end
  View.Img_Title.Txt_UID:SetText(string.format(GetText(80607301), PlayerData:GetUserInfo().uid))
  DataModel:Init(params)
  View.ScrollGrid_RecordList.grid.self:SetDataCount(#DataModel.resultList)
  View.ScrollGrid_RecordList.grid.self:RefreshAllElement()
  View.ScrollGrid_RecordList.grid.self:MoveToTop()
end

return ViewFunction
