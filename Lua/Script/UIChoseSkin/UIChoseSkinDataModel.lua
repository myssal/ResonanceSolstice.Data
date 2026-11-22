local DataModel = {}
DataModel.ChooseIndex = nil
DataModel.ItemId = nil
DataModel.ItemData = {}
DataModel.SkinList = {}
DataModel.showSelectDetail = 0
DataModel.EnumSkinType = {
  RoleSkin = "\231\154\174\232\130\164",
  CarSkin = "\229\136\151\232\189\166\229\164\150\232\167\130"
}

function DataModel:InitSkinList()
  local SkinChooseList = DataModel.ItemData.SkinChooseList
  local SkinType = DataModel.ItemData.chosekind
  DataModel.SkinList = {}
  for k, v in pairs(SkinChooseList) do
    local row = {}
    if SkinType == DataModel.EnumSkinType.RoleSkin then
      local character = PlayerData:GetFactoryData(v.skin).character
      local server_SkinList = {}
      if PlayerData:GetRoleById(character).skin_list then
        server_SkinList = PlayerData:GetRoleById(character).skin_list
      end
      row.isHave = server_SkinList[tostring(v.skin)] ~= nil
    elseif SkinType == DataModel.EnumSkinType.CarSkin then
      row.isHave = PlayerData:GetGoodsById(v.skin).num > 0
    end
    row.skin = v.skin
    row.skinfree = v.skinfree
    row.skinrole = v.skinrole
    row.skinshow = v.skinshow
    row.SkinType = SkinType
    table.insert(DataModel.SkinList, row)
  end
end

return DataModel
