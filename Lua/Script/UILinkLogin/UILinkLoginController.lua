local Controller = {}

function Controller:StartLogin(cb, id, password)
  if id == nil or id == "" or password == nil or password == "" then
    return
  end
  
  local function callback(json)
    if cb ~= nil then
      cb(json)
    end
  end
  
  DataLinkLoginHelper.TryDataLinkLogin(id, password, callback)
end

function Controller:StartLoginAfter(cb)
end

return Controller
