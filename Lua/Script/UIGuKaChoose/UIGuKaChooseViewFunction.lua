local View = require("UIGuKaChoose/UIGuKaChooseView")
local DataModel = require("UIGuKaChoose/UIGuKaChooseDataModel")
local Controller = require("UIGuKaChoose/UIGuKaChooseController")
local ViewFunction = {
  GuKaChoose_Group_Choose_Group_1_Btn_SelectGuKa_Click = function(btn, str)
    if DataModel.IsSelect then
      return
    end
    Controller:TrySelectGuKa(1)
  end,
  GuKaChoose_Group_Choose_Group_2_Btn_SelectGuKa_Click = function(btn, str)
    if DataModel.IsSelect then
      return
    end
    Controller:TrySelectGuKa(2)
  end,
  GuKaChoose_Group_Choose_Group_3_Btn_SelectGuKa_Click = function(btn, str)
    if DataModel.IsSelect then
      return
    end
    Controller:TrySelectGuKa(3)
  end,
  GuKaChoose_Group_Sure_Btn__Click = function(btn, str)
    local gukaId = DataModel.GuKaList[DataModel.CurSelectIdx]
    local isHave = WitchData.GetWitchesData().guka[tostring(gukaId)] and WitchData.GetWitchesData().guka[tostring(gukaId)].had == 1
    
    local function cb(json)
      local element
      if not DataModel.IsOptional then
        element = View.Group_Choose["Group_" .. DataModel.CurSelectIdx]
        element.transform:Find("UI_fire_003").gameObject:SetActive(true)
      else
        element = View.Group_Optional.ScrollGrid_.grid.self:GetElementByIndex(DataModel.CurSelectIdx - 1)
        if element ~= nil then
          element.Group_1.transform:Find("UI_fire_003").gameObject:SetActive(true)
        end
      end
      View.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        if isHave then
          CommonTips.OpenShowItem(json.reward, function()
            View.self:CloseUI()
          end)
        else
          local MainDataModel = require("UIWitchMain/UIWitchMainDataModel")
          MainDataModel.CheckGuKaRedPoint()
          UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/Group_ShowGuka"), Json.encode({id = gukaId}), function()
            View.self:CloseUI()
          end)
        end
      end))
    end
    
    if DataModel.CurSelectIdx == 0 then
      return
    end
    if DataModel.IsSelect then
      return
    end
    DataModel.IsSelect = true
    if DataModel.rewardType == "guka" then
      WitchData.ReqSelectGuKa(DataModel.CurSelectIdx, cb)
    elseif DataModel.rewardType == "item_guka" then
      WitchData.ReqSelectItemGuKa(DataModel.CurSelectIdx, cb)
    end
  end,
  GuKaChoose_Group_Optional_ScrollGrid__SetGrid = function(element, elementIndex)
    Controller:SetGuKaOptionalElement(element, elementIndex)
  end,
  GuKaChoose_Group_Optional_ScrollGrid__Group_Item_Group_1_Btn_SelectGuKa_Click = function(btn, str)
    if DataModel.IsSelect then
      return
    end
    Controller:TrySelectGuKa(tonumber(str))
  end,
  GuKaChoose_Group_Choose_Group_Refresh_Btn_Refresh_Click = function(btn, str)
    Controller:ClickRefresh()
  end
}
return ViewFunction
