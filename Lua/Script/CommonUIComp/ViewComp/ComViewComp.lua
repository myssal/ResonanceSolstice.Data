local ComViewComp = {}

function ComViewComp.SetActive(view, active)
  if view == nil or view.self == nil or view.SetActive == nil or type(view.SetActive) ~= "function" then
    return
  end
  view:SetActive(active)
end

return ComViewComp
