local View = require("UINotebook/UINotebookView")
local DataModel = require("UINotebook/UINotebookDataModel")
local ViewFunction = require("UINotebook/UINotebookViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Img_BG:SetSprite(GetResPath(88300027))
    View.Img_NoteTrade.Group_Trading.Img_Note1:SetSprite(GetResPath(88300047))
    View.Img_NoteTrade.Group_Trading.Img_Note2:SetSprite(GetResPath(88300048))
    View.Img_NoteTrade.Group_Trading.Img_Note3:SetSprite(GetResPath(88300049))
    View.Img_NoteTrade.Group_Trading.Img_Note4:SetSprite(GetResPath(88300050))
    View.Img_NoteTrade.Group_Trading.Img_Note5:SetSprite(GetResPath(88300051))
    View.Img_NoteTrade.Group_Trading.Img_Note6:SetSprite(GetResPath(88300052))
    View.Img_NoteTrade.Group_Trading.Img_Note7:SetSprite(GetResPath(88300053))
    View.Img_NoteTrade.Group_Trading.Img_Note8:SetSprite(GetResPath(88300054))
    View.Img_NoteTrade.Group_Bargain.Img_Note1:SetSprite(GetResPath(88300055))
    View.Img_NoteTrade.Group_Bargain.Img_Note2:SetSprite(GetResPath(88300056))
    View.Img_NoteTrade.Group_Bargain.Img_Note3:SetSprite(GetResPath(88300057))
    View.Img_NoteTrade.Group_Bargain.Img_Note4:SetSprite(GetResPath(88300058))
    View.Img_NoteTrade.Group_Bargain.Img_Note5:SetSprite(GetResPath(88300059))
    View.Img_NoteTrade.Group_Bargain.Img_Note6:SetSprite(GetResPath(88300060))
    View.Img_NoteTrade.Group_Bargain.Img_Note7:SetSprite(GetResPath(88300061))
    View.Img_NoteTrade.Group_Bargain.Img_Note8:SetSprite(GetResPath(88300062))
    View.Img_NoteTrade.Group_Quotes.Img_Note1:SetSprite(GetResPath(88300063))
    View.Img_NoteTrade.Group_Quotes.Img_Note2:SetSprite(GetResPath(88300064))
    View.Img_NoteTrade.Group_Quotes.Img_Note3:SetSprite(GetResPath(88300065))
    View.Img_NoteTrade.Group_Quotes.Img_Note4:SetSprite(GetResPath(88300066))
    View.Img_NoteTrade.Group_Tips.Img_Note1:SetSprite(GetResPath(88300067))
    View.Img_NoteTrade.Group_Tips.Img_Note2:SetSprite(GetResPath(88300068))
    View.Img_NoteTrade.Group_Tips.Img_Note3:SetSprite(GetResPath(88300069))
    View.Img_NoteTrade.Group_Tips.Img_Note4:SetSprite(GetResPath(88300070))
    View.Img_NoteTrade.Group_Tips.Img_Note5:SetSprite(GetResPath(88300071))
    View.Img_NotePassenger.Group_Solicit.Img_Note1:SetSprite(GetResPath(88300072))
    View.Img_NotePassenger.Group_Solicit.Img_Note2:SetSprite(GetResPath(88300073))
    View.Img_NotePassenger.Group_Solicit.Img_Note3:SetSprite(GetResPath(88300074))
    View.Img_NotePassenger.Group_Solicit.Img_Note4:SetSprite(GetResPath(88300075))
    View.Img_NotePassenger.Group_Solicit.Img_Note5:SetSprite(GetResPath(88300076))
    View.Img_NotePassenger.Group_Solicit.Img_Note6:SetSprite(GetResPath(88300077))
    View.Img_NotePassenger.Group_Passenger.Img_Note1:SetSprite(GetResPath(88300078))
    View.Img_NotePassenger.Group_Passenger.Img_Note2:SetSprite(GetResPath(88300079))
    View.Img_NotePassenger.Group_Passenger.Img_Note3:SetSprite(GetResPath(88300080))
    View.Group_Progress.Img_BG:SetSprite(GetResPath(88300035))
    View.Group_Progress.Btn_:SetSprite(GetResPath(88300035))
    if initParams then
      DataModel.SetJsonData(initParams)
    end
    DataModel.InitData()
    DataModel.RefreshOnSHow()
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
    DOTweenTools.KillAll()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
