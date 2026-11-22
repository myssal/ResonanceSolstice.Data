local Component = require("Wasteland/Components/Component")
local Class = require("UIDialog/MetatableClass")
local AttrComponent = Class.New("AttrComponent", Component)

function AttrComponent:Ctor(entity)
  self.attrs = {}
end

function AttrComponent:Init()
  local entityCA = self.entity.ca
  local attr = {}
  for i, v in pairs(entityCA.attrList) do
    attr[v.attrType] = v.value
    if v.attrType == WastelandEnum.Attr.Hp then
      attr[WastelandEnum.Attr.HpMax] = v.value
    end
  end
  self.attrs = attr
end

function AttrComponent:GetType()
  return WastelandEnum.CompType.AttrComponent
end

function AttrComponent:GetAttr(attrType)
  return self.attrs[attrType] or 0
end

function AttrComponent:SetAttr(attrType, value)
  self.attrs[attrType] = value
end

return AttrComponent
