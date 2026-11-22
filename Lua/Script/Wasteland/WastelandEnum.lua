local Enum = {}
Enum.EntityType = {
  Cell = "Cell",
  Player = "Player",
  Resource = "Resource",
  Building = "Building",
  Train = "Train",
  Item = "Item",
  Rail = "Rail",
  TrainInteract = "TrainInteract"
}
Enum.CompType = {
  AttrComponent = "AttrComponent",
  ViewStateComponent = "ViewStateComponent",
  BuildingViewComponent = "BuildingViewComponent",
  TranslateComponent = "TranslateComponent",
  ProductComponent = "ProductComponent"
}
Enum.SystemType = {
  ViewSyncSystem = "ViewSyncSystem",
  AttrSystem = "AttrSystem",
  HpBarSystem = "HpBarSystem"
}
Enum.ViewState = {Normal = 0, GetHit = 1}
Enum.Event = {
  OnEntityCreate = "OnEntityCreate",
  OnPlayerEquipChange = "OnPlayerEquipChange",
  OnPlayerStepChange = "OnPlayerStepChange"
}
Enum.Attr = {
  Hp = "Hp",
  HpMax = "HpMax",
  GatherSpeed = "GatherSpeed"
}
return Enum
