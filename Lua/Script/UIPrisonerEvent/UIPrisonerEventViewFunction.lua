local View = require("UIPrisonerEvent/UIPrisonerEventView")
local DataModel = require("UIPrisonerEvent/UIPrisonerEventDataModel")
local ViewFunction = {
  PrisonerEvent_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonerEvent_Btn_Dispose_Click = function(btn, str)
    local roomIndex = DataModel.roomIndex
    local cellIndex = DataModel.cellIndex
    local product = PrisonData.GetCellProduct(roomIndex, cellIndex)
    local cellList = {}
    table.insert(cellList, cellIndex)
    if product.event_trammels then
      table.insert(cellList, product.event_trammels.other)
    end
    
    local function yesFun()
      local function callBack(json)
        local fetterId = DataModel.eventCfg.fetterId
        
        local tagCA = PlayerData:GetFactoryData(fetterId, "TagFactory")
        local buffCA = PlayerData:GetFactoryData(tagCA.buffId, "HomeBuffFactory")
        local desc = string.format(tagCA.prisonerBuffDesc, buffCA.desc)
        if buffCA.buffType == "TimeAdd" then
          View.Group_Detail.Txt_Des:SetText(string.format(desc, tagCA.timeAdd))
        else
          for i, v in ipairs(tagCA.paramList) do
            if v.programme == product.count then
              View.Group_Detail.Txt_Des:SetText(string.format(desc, v.probabilityParam))
              break
            end
          end
        end
        View.Btn_Dispose:SetActive(false)
        View.Btn_NoDispose:SetActive(false)
        PrisonController.SolveProductAccident(roomIndex, cellIndex, product)
        if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
          local UIPrisonMainData = require("UIPrisonMain/UIPrisonMainDataModel")
          UIPrisonMainData.RefreshOneButton()
        end
      end
      
      PrisonData.SolveProductAccident(callBack, DataModel.roomIndex, DataModel.cellIndex)
    end
    
    yesFun()
  end,
  PrisonerEvent_Btn_NoDispose_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
