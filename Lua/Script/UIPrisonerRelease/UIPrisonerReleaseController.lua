local DataModel = require("UIPrisonerRelease/UIPrisonerReleaseDataModel")
local View = require("UIPrisonerRelease/UIPrisonerReleaseView")
local Controller = {}

function Controller.InitView(json)
  DataModel.release_prisoner = json.release_prisoner or {}
  if next(DataModel.release_prisoner) then
    local count = table.count(DataModel.release_prisoner)
    View.Txt_Title:SetText(string.format(GetText(80608032), count))
    local prisonFactory = PrisonData.GetPrisonCA() or nil
    local leaveMessage = {}
    local length = 0
    if prisonFactory ~= nil then
      leaveMessage = prisonFactory.leaveMessage or nil
      if leaveMessage ~= nil then
        length = table.count(leaveMessage)
      end
    end
    for index = 1, count do
      local tab = DataModel.release_prisoner[index]
      local client_num = string.format("%06d", tonumber(tab.client_num))
      tab.client_num = string.format(GetText(80607161), client_num)
      tab.prisonerIconPath = ""
      tab.prisonerName = ""
      tab.prisonerRarity = ""
      tab.leaveMessage = ""
      local prisonerFactory = PlayerData:GetFactoryData(tab.prisoner_id, "PrisonerFactory") or nil
      if prisonerFactory ~= nil then
        tab.prisonerIconPath = prisonerFactory.prisonerIconPath or ""
        tab.prisonerName = prisonerFactory.prisonerName or ""
        local tagFactory = PlayerData:GetFactoryData(prisonerFactory.prisonerRarity, "TagFactory") or nil
        if tagFactory ~= nil then
          tab.prisonerRarity = tagFactory.prisonerRarity or ""
        end
        if 0 < length then
          tab.leaveMessage = GetText(leaveMessage[math.random(1, length)].id)
        end
      end
    end
    View.ScrollGrid_List.grid.self:SetDataCount(count)
    View.ScrollGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller.SetElement(element, elementIndex)
  local data = DataModel.release_prisoner[elementIndex]
  element.Img_Prisoner:SetSprite(data.prisonerIconPath)
  element.Txt_ID:SetText(data.client_num)
  element.Txt_Name:SetText(data.prisonerName)
  element.Img_Rarity:SetSprite(data.prisonerRarity)
  element.Txt_Tips:SetText(data.leaveMessage)
end

return Controller
