local View = require("UIWitchMain/UIWitchMainView")
local DataModel = require("UIWitchMain/UIWitchMainDataModel")
local ViewFunction = {
  WitchMain_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/MainFinish"), Json.encode({showTempLeft = 1, showRevive = 0}))
  end,
  WitchMain_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WitchMain_Group_Coin_Btn__Click = function(btn, str)
  end,
  WitchMain_Group_Stamina_Btn__Click = function(btn, str)
  end,
  WitchMain_Group_Buff_Btn_Ticket_Click = function(btn, str)
    DataModel.RefreshTicket(true, true)
  end,
  WitchMain_Group_Buff_Btn_Guka_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/Group_GukaAllAttr"))
  end,
  WitchMain_Group_Buff_Btn_Tea_Click = function(btn, str)
    local restBuff = WitchData.GetRestBuffData()
    if string.nilorempty(restBuff) then
      local mapCa = WitchData.GetParkMapCA()
      if mapCa and mapCa.teaTip then
        CommonTips.OpenWitchTip(mapCa.teaTip)
      end
      return
    end
    local show = not View.Group_Buff.Btn_Tea.Group_TeaBuff.IsActive
    if show then
      local skillCA = PlayerData:GetFactoryData(restBuff, "SkillFactory")
      View.Group_Buff.Btn_Tea.Group_TeaBuff.Img_bg.Txt_:SetText(skillCA.description)
    end
    View.Group_Buff.Btn_Tea.Group_TeaBuff:SetActive(show)
  end,
  WitchMain_Group_Seal_Group_Title_Btn_Tips_Click = function(btn, str)
    View.Group_Seal.Group_Tips:SetActive(not View.Group_Seal.Group_Tips.IsActive)
  end,
  WitchMain_Group_Seal_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    DataModel.SetSealElement(element, elementIndex)
  end,
  WitchMain_Btn_Guka_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKa"))
  end,
  WitchMain_Group_SealShow_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    DataModel.SetSealShowElement(element, elementIndex)
  end,
  WitchMain_Btn_Bag_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/WitchBag"))
  end,
  WitchMain_Btn_Handbook_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaHandbook"))
  end,
  WitchMain_Group_SealShow_Img__Btn__Click = function(btn, str)
    for i = 1, 4 do
      local element = View.Group_Seal.StaticGrid_Seal.grid[i]
      element.transform:Find("UI_WitchMain_posui").gameObject:SetActive(false)
      element.transform:Find("UI_WitchMain_posui").gameObject:SetActive(true)
    end
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
      View.Group_Seal:SetActive(false)
      View.Group_SealShow:SetActive(false)
      local UIWitchMainDataController = require("UIWitchMain/UIWitchMainDataController")
      UIWitchMainDataController.CameraMoveInForFirework()
    end))
  end,
  WitchMain_Group_TicketShow_Img__Btn__Click = function(btn, str)
    View.Group_TicketShow:SetActive(false)
  end,
  WitchMain_Group_LittelMap_Btn_Enlarge_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Map/WitchesMap"))
  end
}
return ViewFunction
