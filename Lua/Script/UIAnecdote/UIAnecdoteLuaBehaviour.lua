local View = require("UIAnecdote/UIAnecdoteView")
local DataModel = require("UIAnecdote/UIAnecdoteDataModel")
local ViewFunction = require("UIAnecdote/UIAnecdoteViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local nowAnecdoteQuestId
    if initParams then
      nowAnecdoteQuestId = Json.decode(initParams).nowAnecdoteQuestId
    end
    DataModel.Init(nowAnecdoteQuestId)
    View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:SetDataCount(#DataModel.seriesQuestList)
      View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:RefreshAllElement()
      if nowAnecdoteQuestId then
        View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:MoveToPos(DataModel.selectSeriesIdx)
      end
    end))
    View.Group_Left.Group_Title.Group_OnGoing.Img_Btn:SetSprite(GetResPath(88300022))
    View.Group_Left.Group_Title.Group_Available.Img_Btn:SetSprite(GetResPath(88300018))
    View.Group_Left.Group_Title.Group_UnAvailable.Img_Btn:SetSprite(GetResPath(88300023))
    View.Group_Left.Group_Title.Group_Continue.Img_Btn:SetSprite(GetResPath(88300021))
    View.Group_Left.Group_Title.Group_CannotContine.Img_Btn:SetSprite(GetResPath(88300019))
    View.Group_Left.Group_Title.Group_Locked.Img_Btn:SetSprite(GetResPath(88300023))
    View.Group_Left.Group_Title.Group_Completed.Img_Btn:SetSprite(GetResPath(88300020))
    View.Group_Left.Group_Title.Img_TitleDeco:SetSprite(GetResPath(88300017))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    for i, v in ipairs(DataModel.seriesQuestList) do
      local questId = v[1]
      PlayerData:SetPlayerPrefs("int", questId, 1)
    end
    RedpointTree:ChangeRedpointCnt(RedpointTree.NodeNames.Anecdote, -1)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
