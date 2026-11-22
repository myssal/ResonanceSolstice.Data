local DataModel = {
  RightList = {},
  RightIndex = nil,
  PicRightIndex = nil,
  TopIndex = nil,
  PicGridHave = false,
  MainGridHave = false,
  IsRefresh = false
}

local function parseFontTag(html)
  local pattern = "<font%s+color%s*=%s*\"(.-)\"%s+size%s*=%s*\"(.-)\".->(.-)</font>"
  local color, size, text = html:match(pattern)
  if color and size and text then
    text = text:gsub("<br>", "\n"):gsub("^%s+", ""):gsub("%s+$", "")
    return color, tonumber(size), text
  end
  return nil, 0, nil
end

local function parseImgFontTag(html, haveText)
  local pattern = "<font%s+color%s*=%s*\"(.-)\"%s+size%s*=%s*\"(.-)\".->(.-)</font>"
  local color, size, text = html:match(pattern)
  if color and size and text then
    text = text:gsub("<br>", "\n"):gsub("^%s+", ""):gsub("%s+$", "")
    return text
  end
  return nil
end

function DataModel.InitHtmlText(rawData)
  DataModel.RightList = {}
  DataModel.RightIndex = nil
  DataModel.PicRightIndex = nil
  DataModel.PicGridHave = false
  DataModel.MainGridHave = false
  DataModel.IsRefresh = false
  DataModel.LeftList = {}
  DataModel.LeftImgBig = ""
  DataModel.LeftImgTime = ""
  DataModel.LeftImgTitle = ""
  DataModel.LeftImgJumpUrl = ""
  DataModel.LeftImgJumpUrlId = ""
  DataModel.LeftImgJumpWebUrlId = ""
  local contentLeftList = string.split(rawData, "{$$$}")
  for k, v in pairs(contentLeftList) do
    if k == 1 then
      local contentLeftImgList = string.split(v, "{,,,}")
      for c, d in pairs(contentLeftImgList) do
        local data = string.split(d, "{***}")
        local imgUrl = data[1]:gsub("^%s*\"", ""):gsub("\"%s*$", "")
        local time, title, jumpUrl, jumpUrlId, jumpWebUrlId
        if data[2] then
          if parseImgFontTag(data[2]) == nil then
            CommonTips.OpenTips("\230\163\128\230\159\165\229\133\172\229\145\138\229\156\176\229\157\128")
            return
          end
          time = parseImgFontTag(data[2]):gsub("^%s*\"", ""):gsub("\"%s*$", "")
          title = parseImgFontTag(data[3]):gsub("^%s*\"", ""):gsub("\"%s*$", "")
          jumpUrl = parseImgFontTag(data[4]):gsub("^%s*\"", ""):gsub("\"%s*$", "")
          jumpUrlId = data[5] and data[5]:gsub("^%s*\"", ""):gsub("\"%s*$", "")
          jumpWebUrlId = data[6] and data[6]:gsub("^%s*\"", ""):gsub("\"%s*$", "")
        end
        if c == 1 then
          DataModel.LeftImgBig = imgUrl
          DataModel.LeftImgTime = time
          DataModel.LeftImgTitle = title
          DataModel.LeftImgJumpUrl = jumpUrl
          DataModel.LeftImgJumpUrlId = jumpUrlId
          DataModel.LeftImgJumpWebUrlId = jumpWebUrlId
        elseif title then
          table.insert(DataModel.LeftList, {
            smallImg = imgUrl,
            time = time,
            title = title,
            jumpUrl = jumpUrl,
            jumpUrlId = jumpUrlId,
            jumpWebUrlId = jumpWebUrlId
          })
        end
      end
    else
      local contentBigList = string.split(v, "{###}")
      for k, v in pairs(contentBigList) do
        local notice = {}
        local contentSmallList = string.split(v, "{,,,}")
        for index, value in pairs(contentSmallList) do
          if index == 5 then
            local color, size, text = parseFontTag(string.gsub(value, "\n", ""))
            notice.content = text
            notice.color_des = color and color:gsub("#", "") or nil
            notice.size_des = size
          else
            local color, size, text = parseFontTag(value)
            if index == 1 then
              notice.title = text
              notice.color = color
              notice.size = size
            end
            if index == 2 then
              notice.time = text
            end
            if index == 3 then
              notice.left_titile = text
            end
            if index == 4 then
              notice.left_time = text
            end
          end
        end
        if notice.content then
          notice.content = notice.content:gsub("<br>", "\n")
          notice.content = notice.content:gsub("<br/>", "\n")
        end
        notice.isNeedDown = false
        table.insert(DataModel.RightList, notice)
      end
    end
  end
  print_r(DataModel.RightList, DataModel.LeftList, "DataModel.RightList")
end

return DataModel
