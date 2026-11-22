local View = require("UIIllustration_Equipment/UIIllustration_EquipmentView")
local DataModel = {
  EquipList = {},
  AllEquipList = {},
  NowShowList = {},
  EnumEquipSideList = {},
  Element = {},
  RightIndex = -1,
  Tweens = {},
  SortState = {
    index = 1,
    currentBtn = nil,
    currentDown = true
  },
  UnlockCount = 0,
  TotalCount = 0,
  CacheSelectRecord = {RightIndex = 1},
  CurMaxLevelStats = 0,
  CacheAffixData = {},
  CurAffixType = "-1",
  CurAffixList = {}
}
DataModel.AffixPartCfg = {}
DataModel.QualityCfg = {
  Blue = {
    qualityIndex = 1,
    bgPath = "UI/Book/Armament_Illustration/Card_R",
    iconColor = "#73AFDB"
  },
  Purple = {
    qualityIndex = 2,
    bgPath = "UI/Book/Armament_Illustration/Card_SR",
    iconColor = "#AE8CD7"
  },
  Golden = {
    qualityIndex = 3,
    bgPath = "UI/Book/Armament_Illustration/Card_SSR",
    iconColor = "#D7A30C"
  },
  Orange = {
    qualityIndex = 4,
    bgPath = "UI/Book/Armament_Illustration/Card_UR",
    iconColor = "#D78101"
  }
}
DataModel.EquipTypeIcon = {
  ["12600155"] = "UI/Common/Common_icon_equipment_type_1",
  ["12600161"] = "UI/Common/Common_icon_equipment_type_5",
  ["12600162"] = "UI/Common/Common_icon_equipment_type_6"
}

local function AddToCacheData(part, camp, affId)
  if not DataModel.CacheAffixData[tostring(part)] then
    DataModel.CacheAffixData[tostring(part)] = {}
  end
  if not DataModel.CacheAffixData[tostring(part)][tostring(camp)] then
    DataModel.CacheAffixData[tostring(part)][tostring(camp)] = {}
  end
  table.insert(DataModel.CacheAffixData[tostring(part)][tostring(camp)], tostring(affId))
end

function DataModel.InitAffixData()
  DataModel.AffixPartCfg = {
    [1] = {
      id = "-1",
      ctr = View.Group_Affix.Group_TopRight.Btn_All
    },
    [2] = {
      id = "12600155",
      ctr = View.Group_Affix.Group_TopRight.Btn_Weapon
    },
    [3] = {
      id = "12600161",
      ctr = View.Group_Affix.Group_TopRight.Btn_Armor
    },
    [4] = {
      id = "12600162",
      ctr = View.Group_Affix.Group_TopRight.Btn_Pendant
    }
  }
  DataModel.CacheAffixData = {
    ["-1"] = {
      ["-1"] = {}
    }
  }
  local affixList = PlayerData:GetFactoryData(80900012).affixList
  for i, v in ipairs(affixList) do
    local affixCfg = PlayerData:GetFactoryData(v.id)
    if affixCfg then
      if affixCfg.id == 12300777 then
        local _
      end
      AddToCacheData(-1, -1, v.id)
      local v2Flag = false
      for i1, v1 in ipairs(affixCfg.partList) do
        AddToCacheData(v1.name, -1, v.id)
        for i2, v2 in ipairs(affixCfg.campList) do
          if v2Flag == false then
            AddToCacheData(-1, v2.name, v.id)
          end
          AddToCacheData(v1.name, v2.name, v.id)
        end
        v2Flag = true
      end
    end
  end
end

return DataModel
