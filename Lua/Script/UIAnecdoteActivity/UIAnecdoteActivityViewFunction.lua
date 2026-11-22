local View = require("UIAnecdoteActivity/UIAnecdoteActivityView")
local DataModel = require("UIAnecdoteActivity/UIAnecdoteActivityDataModel")
local ViewFunction = {
  AnecdoteActivity_Btn_Turn_Click = function(btn, str)
    local anecdoteQuestId = DataModel.anecdoteData.id
    UIManager:Open("UI/Quest/Anecdote/Anecdote", Json.encode({nowAnecdoteQuestId = anecdoteQuestId}))
  end
}
return ViewFunction
