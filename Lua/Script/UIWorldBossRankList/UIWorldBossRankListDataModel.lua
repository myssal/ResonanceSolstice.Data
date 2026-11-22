local DataModel = {QuickClickTime = 0, QuickClickLimit = 10}
DataModel.RankBg = {
  [1] = "UI/RankList/first_bg",
  [2] = "UI/RankList/second_bg",
  [3] = "UI/RankList/third_bg",
  [4] = "UI/RankList/other_bg"
}
DataModel.SelectBg = {
  [1] = "UI/RankList/btn_select",
  [2] = "UI/RankList/btn_unselect"
}

function DataModel.SimpleDamageValue(value)
  local suffixes = {
    "t",
    "b",
    "m"
  }
  local thresholds = {
    1000000000000,
    1000000000,
    1000000
  }
  for i, threshold in ipairs(thresholds) do
    if threshold <= value then
      local divided = value / threshold
      local formatted
      if 1000000 <= divided then
        formatted = tostring(math.floor(divided))
        if 6 < #formatted then
          formatted = formatted:sub(1, 6)
        end
      else
        local integerDigits = math.floor(math.log(divided, 10)) + 1
        local maxDecimalDigits = math.max(0, 5 - integerDigits)
        local multiplier = 10 ^ maxDecimalDigits
        local rounded = math.floor(divided * multiplier + 0.5) / multiplier
        if 0 < maxDecimalDigits then
          formatted = string.format("%." .. maxDecimalDigits .. "f", rounded)
          formatted = formatted:gsub("%.?0+$", "")
        else
          formatted = tostring(math.floor(rounded))
        end
      end
      return formatted .. suffixes[i]
    end
  end
  return tostring(value)
end

return DataModel
