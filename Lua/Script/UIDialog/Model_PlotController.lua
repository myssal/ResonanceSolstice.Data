local View = require("UIDialog/UIDialogView")
local PlotChangeBg = require("UIDialog/Model_ChangeBg")
local PlotChangeRoleImg = require("UIDialog/Model_ChangeRoleImg")
local PlotRoleImgStatus = require("UIDialog/Model_RoleImgStatus")
local PlotCheckBox = require("UIDialog/Model_CheckBox")
local PlotJumpOrder = require("UIDialog/Model_JumpOrder")
local PlotText = require("UIDialog/Model_PlotText")
local PlotTree = require("UIDialog/Model_PlotTree")
local PlotTextShow = require("UIDialog/Model_PlotTextShow")
local PlotTextHide = require("UIDialog/Model_PlotTextHide")
local PlotShake = require("UIDialog/Model_Shake")
local PlotFocus = require("UIDialog/Model_Focus")
local PlotSound = require("UIDialog/Model_Sound")
local PlotMask = require("UIDialog/Model_Mask")
local DataModel = require("UIDialog/UIDialogDataModel")
local PlotChangeFace = require("UIDialog/Model_PlotChangeFace")
local RoleSpine = require("UIDialog/Model_RoleSpine")
local ChangeSpine = require("UIDialog/Model_ChangeSpine")
local Subtitles = require("UIDialog/Model_Subtitles")
local SubtitlesHide = require("UIDialog/Model_SubtitlesHide")
local Gender = require("UIDialog/Model_SelectGender")
local MaskController = require("UIDialog/Model_MaskController")
local Video = require("UIDialog/Model_PlotVideo")
local VideoHide = require("UIDialog/Model_PlotVideoHide")
local PlotImgMove = require("UIDialog/Model_PlotImgMove")
local PlotTimeLine = require("UIDialog/Model_PlotTimeLine")
local PlotSetUI = require("UIDialog/Model_PlotSetUI")
local PlotSetMaskAndBg = require("UIDialog/Model_SetMaskAndBg")
local AddSpeedController = require("UIDialog/UIDialog_AddSpeedController")
local PlotItem = require("UIDialog/Model_PlotItem")
local PlotItemHide = require("UIDialog/Model_PlotItemHide")
local PlotBoxCallBack = require("UIDialog/Model_BoxCallBack")
local WordTips = require("UIDialog/Model_WordTips")
local DialogReviewDataModel = require("UIDialogReview/UIDialogReviewDataModel")
local PlotAddSpeedReview = require("UIDialog/Model_PlotAddSpeedReview")
local PlotReviewDataModel = require("UIPlotReview/UIPlotReviewDataModel")
local isCheckBoxExitPending = false
local classModName = {
  ["\232\131\140\230\153\175"] = function()
    return PlotChangeBg.New()
  end,
  ["\232\167\146\232\137\178"] = function()
    return PlotChangeRoleImg.New()
  end,
  ["\228\184\187\232\167\146\231\171\139\231\187\152"] = function()
    return RoleSpine.New()
  end,
  ["\231\171\139\231\187\152\231\138\182\230\128\129"] = function()
    return PlotRoleImgStatus.New()
  end,
  ["\231\171\139\231\187\152\231\167\187\229\138\168"] = function()
    return PlotImgMove.New()
  end,
  ["\229\164\141\233\128\137\230\161\134"] = function()
    return PlotCheckBox.New()
  end,
  ["\232\183\179\232\183\131\229\145\189\228\187\164"] = function()
    return PlotJumpOrder.New()
  end,
  ["\230\150\135\230\156\172\229\137\167\230\131\133"] = function()
    return PlotText.New()
  end,
  ["\229\137\167\230\131\133\230\160\145"] = function()
    return PlotTree.New()
  end,
  ["\230\152\190\231\164\186\230\150\135\230\156\172"] = function()
    return PlotTextShow.New()
  end,
  ["\233\154\144\232\151\143\230\150\135\230\156\172"] = function()
    return PlotTextHide.New()
  end,
  ["\233\156\135\229\138\168"] = function()
    return PlotShake.New()
  end,
  ["\232\129\154\231\132\166"] = function()
    return PlotFocus.New()
  end,
  ["\229\163\176\233\159\179"] = function()
    return PlotSound.New()
  end,
  ["\229\133\168\229\177\143\233\129\174\231\189\169"] = function()
    return PlotMask.New()
  end,
  ["\229\136\135\230\141\162\232\161\168\230\131\133"] = function()
    return PlotChangeFace.New()
  end,
  ["\232\167\146\232\137\178\229\138\168\231\148\187"] = function()
    return RoleSpine.New()
  end,
  ["\229\136\135\230\141\162\229\138\168\231\148\187"] = function()
    return ChangeSpine.New()
  end,
  ["\229\173\151\229\185\149"] = function()
    return Subtitles.New()
  end,
  ["\233\154\144\232\151\143\229\173\151\229\185\149"] = function()
    return SubtitlesHide.New()
  end,
  ["\230\128\167\229\136\171\233\128\137\230\139\169"] = function()
    return Gender.New()
  end,
  ["\229\185\149\229\184\131\229\188\128\229\133\179"] = function()
    return MaskController.New()
  end,
  ["\232\167\134\229\177\143\230\146\173\230\148\190"] = function()
    return Video.New()
  end,
  ["\229\133\179\233\151\173\232\167\134\229\177\143"] = function()
    return VideoHide.New()
  end,
  ["\230\146\173\230\148\190TimeLine"] = function()
    return PlotTimeLine.New()
  end,
  ["\232\174\190\231\189\174UI"] = function()
    return PlotSetUI.New()
  end,
  ["\232\174\190\231\189\174\233\129\174\231\189\169\228\184\142\232\131\140\230\153\175"] = function()
    return PlotSetMaskAndBg.New()
  end,
  ["\233\129\147\229\133\183\229\177\149\231\164\186"] = function()
    return PlotItem.New()
  end,
  ["\229\133\179\233\151\173\233\129\147\229\133\183"] = function()
    return PlotItemHide.New()
  end,
  ["\229\164\141\233\128\137\230\161\134\230\140\137\233\146\174\229\155\158\232\176\131"] = function()
    return PlotBoxCallBack.New()
  end,
  ["\232\175\141\230\157\161\230\143\144\231\164\186"] = function()
    return WordTips.New()
  end,
  ["\229\138\160\233\128\159\229\155\158\233\161\190"] = function()
    return PlotAddSpeedReview.New()
  end,
  __CheckBoxExit = function()
    return {
      OnStart = function()
        isCheckBoxExitPending = true
      end,
      OnUpdate = function()
      end,
      GetState = function()
        return true
      end,
      Dtor = function()
      end
    }
  end
}
local plotIndex = 0
local continue = false
local classMod, allMod, isStopUpdate, isFinish, CA, count, checkBoxReturnInfo

local function AddPlotIndex(addNum)
  plotIndex = plotIndex + addNum
  continue = true
end

local function ClearCheckBoxReturn()
  checkBoxReturnInfo = nil
end

local function TryReturnCheckBoxIndex()
  if checkBoxReturnInfo == nil or plotIndex < checkBoxReturnInfo.endIndex then
    return
  end
  for i = 1, checkBoxReturnInfo.insertCount do
    if checkBoxReturnInfo.insertIndex <= #DataModel.plotList then
      table.remove(DataModel.plotList, checkBoxReturnInfo.insertIndex)
    end
  end
  plotIndex = checkBoxReturnInfo.returnIndex
  ClearCheckBoxReturn()
end

local function InitPlot(index)
  local data = PlayerData.ServerData
  if data ~= nil and data.user_info ~= nil and data.user_info.gender == 0 then
    DataModel.isBoy = false
  else
    DataModel.isBoy = true
  end
  DataModel.plotIndex = index
  DialogReviewDataModel.paragraphId = index
  DialogReviewDataModel.contentId = 1
  DialogReviewDataModel.paragraphContent = DataModel.plotList
  CA = DataModel.plotList[index]
  if CA.mod == "\229\173\151\229\185\149" and plotIndex + 1 <= #DataModel.plotList then
    DataModel.isAutoCloseSubtitles = false
    local ca = DataModel.plotList[index + 1]
    if ca.mod == "\230\150\135\230\156\172\229\137\167\230\131\133" then
      DataModel.isAutoCloseSubtitles = true
    end
  end
  classMod = classModName[CA.mod]()
  count = count + 1
  allMod[count] = classMod
  if next(DataModel.ReviewList) and CA.mod == "\229\164\141\233\128\137\230\161\134\230\140\137\233\146\174\229\155\158\232\176\131" then
    return
  end
  if CA.mod == "\228\184\187\232\167\146\231\171\139\231\187\152" then
    local caID = PlayerData.IsMale() and CA.BoyID or CA.GirlID
    CA = PlayerData:GetFactoryData(caID)
  end
  classMod:OnStart(CA, AddPlotIndex)
end

local function End(isSkip)
  isCheckBoxExitPending = false
  if DataModel.UploadingParagraphId > 0 then
    if Net ~= nil then
      Net:SendProto("plot.note", nil, DataModel.UploadingParagraphId)
    end
    PlayerData.plot_paragraph[tostring(DataModel.UploadingParagraphId)] = tostring(DataModel.UploadingParagraphId)
    MapNeedleData.NeedleCompletedSendServer()
    MapNeedleEventData.EventCompletedSendServer()
  end
  isStopUpdate = true
  isFinish = true
  continue = false
  if allMod == nil then
    CS.UnityEngine.Debug.LogError("\230\174\181\232\144\189\233\133\141\231\189\174\233\148\153\232\175\175,\233\156\128\232\166\129\231\173\150\229\136\146\232\167\163\229\134\179!!!\n\230\174\181\232\144\189\229\139\190\233\128\137\228\186\134\228\184\141\232\191\148\229\155\158\228\184\138\228\184\170\231\149\140\233\157\162,\228\188\154\229\141\161\229\156\168\230\156\128\229\144\142\228\184\128\230\174\181\229\137\167\230\131\133\n\n\232\167\163\229\134\179\230\150\185\229\188\143:\n\230\150\185\229\188\1431.\229\139\190\233\128\137\230\174\181\232\144\189-\232\191\148\229\155\158\228\184\138\228\184\170\231\149\140\233\157\162,\230\150\185\229\188\143\n2.\229\188\149\229\175\188\229\183\165\229\142\130+\229\188\149\229\175\188+\229\188\149\229\175\188\229\145\189\228\187\164\229\183\165\229\142\130")
    UIManager:GoBack()
  else
    for k, v in pairs(allMod) do
      v:Dtor(v)
    end
    allMod = nil
    local id = tonumber(DataModel.Ca.id)
    local idCN = DataModel.Ca.idCN
    if isSkip then
      ReportTrackEvent.Story_play(1, id, idCN, plotIndex, 1, 511003, TimeUtil:GetServerTimeStamp() - DataModel.duration)
    else
      ReportTrackEvent.Story_play(1, id, idCN, -1, 1, 511002, 0)
    end
    if isSkip then
      local gotWord = {}
      local index = 0
      for i = plotIndex, #DataModel.plotList do
        local ca = DataModel.plotList[i]
        if ca.mod == "\232\175\141\230\157\161\230\143\144\231\164\186" then
          local hasGot = false
          if 0 < ca.tip01 then
            for k, v in pairs(PlayerData.gotWord) do
              if tonumber(v) == ca.tip01 then
                hasGot = true
                break
              end
            end
            if hasGot == false then
              index = index + 1
              gotWord[index] = ca.tip01
            end
          end
          if 0 < ca.tip02 and ca.tip01 ~= ca.tip02 then
            hasGot = false
            for k, v in pairs(PlayerData.gotWord) do
              if tonumber(v) == ca.tip02 then
                hasGot = true
                break
              end
            end
            if hasGot == false then
              index = index + 1
              gotWord[index] = ca.tip02
            end
          end
        end
      end
      if next(gotWord) ~= nil then
        if Net ~= nil then
          Net:SendProto("plot.note_noun", function(json)
            UIManager:Open("UI/Dialog/Tips/DialogTips", Json.encode({isOpen = false}))
          end, table.concat(gotWord, ","))
        else
          UIManager:Open("UI/Dialog/Tips/DialogTips", Json.encode({isOpen = false}))
        end
      end
    end
    DOTweenTools.KillAll()
    AddSpeedController.Destroy()
    View.Img_Transit:SetActive(false)
    local nextParagraphId = -1
    local index = 1
    for k, v in pairs(DataModel.ReviewList) do
      index = index + 1
      if DataModel.CurrentParagraphId == v then
        break
      end
    end
    if nextParagraphId == -1 then
      nextParagraphId = DataModel.Ca.nextParagraph or -1
    end
    if next(DataModel.ReviewList) then
      nextParagraphId = DataModel.ReviewList[index] or -1
      if not PlotReviewDataModel.GetAutoChapterState() then
        nextParagraphId = -1
      end
    end
    isFinish = true
    if 0 < nextParagraphId and DataModel.ClosePanel then
      UIManager:Open(UIPath.UIDialog, Json.encode({
        id = nextParagraphId,
        finishLogOut = DataModel.finishLogOut
      }), View.self.callbackConfirm, View.self.callbackCancel)
      isFinish = false
    elseif (DataModel.Ca.isGoBack or next(DataModel.ReviewList) ~= nil) and DataModel.ClosePanel then
      if DataModel.finishLogOut then
        DataModel.finishLogOut = nil
        SdkHelper.TryLogout()
        PlayerData:Logout()
        return
      end
      UIManager:GoBack(next(DataModel.ReviewList) == nil)
    end
    if nextParagraphId < 0 then
      DataModel.ReviewList = {}
    end
  end
  PlotManager:SetPlotStatus(isFinish)
  if isSkip == true then
    View.self:Cancel()
  else
    View.self:Confirm()
  end
end

local controller = {
  Init = function()
    for k, v in pairs(View.Group_Option) do
      if v ~= View.Group_Option.self then
        v.self:SetActive(false)
      end
    end
    View.Btn_Dialog.self:SetActive(false)
    View.Img_Speaker.self:SetActive(false)
    View.Group_Shake.Group_Img.Img_Paint01:SetActive(false)
    View.Group_Shake.Group_Img.Img_Paint02:SetActive(false)
    View.Group_Shake.Group_Img.Img_Paint03:SetActive(false)
    View.Group_Shake.Group_Spines.SpineAnimation_Role01:SetActive(false)
    View.Group_Shake.Group_Spines.SpineAnimation_Role02:SetActive(false)
    View.Group_Shake.Group_Spines.SpineAnimation_Role03:SetActive(false)
    View.Group_Subtitles:SetActive(false)
    View.Group_Gender:SetActive(false)
    DataModel.ForceAutoPlay(DataModel.Ca.isAuto)
    DataModel.SetSkipAndAutoBtn(not DataModel.Ca.isBanSkip)
    if DataModel.isReview then
      View.Btn_Skip:SetActive(true)
    end
    View.Video_BG:SetActive(false)
    DataModel.InitAutoSpeed()
    View.Group_Item:SetActive(false)
    View.Img_Face:SetActive(false)
    View.Img_Bg:SetActive(true)
    allMod = {}
    DialogReviewDataModel.ClearCoachData()
    continue = true
    plotIndex = 1
    isStopUpdate = false
    isFinish = false
    count = 0
    DataModel.Video.isPlaying = false
    DataModel.TimeLine.isPlaying = false
    ClearCheckBoxReturn()
    isCheckBoxExitPending = false
  end,
  OnEnd = function(self)
    End(true)
  end,
  Update = function()
    if isStopUpdate then
      return
    end
    if continue then
      if isCheckBoxExitPending then
        End()
        return
      end
      TryReturnCheckBoxIndex()
      continue = false
      if plotIndex <= #DataModel.plotList then
        InitPlot(plotIndex)
        plotIndex = plotIndex + 1
      else
        End()
      end
    end
    if isStopUpdate then
      return
    end
    classMod:OnUpdate()
    DataModel.SkipCurrentNode()
    if not continue then
      if CA.isWaitFinish then
        continue = classMod.GetState(classMod)
      else
        continue = true
      end
    end
    if DataModel.SpeedChanged == true then
      DataModel.SpeedChanged = false
      if CA.mod == "\230\146\173\230\148\190TimeLine" and classMod.GetState() ~= true then
        classMod.SetSpeed(DataModel.Speed)
      end
    end
    AddSpeedController.Update()
  end,
  JumpPlot = function(index)
    if index <= #DataModel.plotList then
      DataModel.RunSkipCurrentNodeCb()
      ClearCheckBoxReturn()
      isCheckBoxExitPending = false
      plotIndex = index
      InitPlot(plotIndex)
      plotIndex = plotIndex + 1
      continue = false
    end
  end
}

function controller:IsFinish()
  return isFinish
end

function controller.resetPlotList(resetList)
  if resetList == nil then
    return
  end
  DataModel.plotList = resetList
  plotIndex = 0
  ClearCheckBoxReturn()
  isCheckBoxExitPending = false
end

function controller.InsertPlotList(insertList)
  if insertList == nil then
    return 0
  end
  local insertCount = 0
  for k, v in pairs(insertList) do
    table.insert(DataModel.plotList, plotIndex + k - 1, v)
    insertCount = insertCount + 1
  end
  return insertCount
end

function controller.InsertCheckBoxExit(insertCount)
  insertCount = tonumber(insertCount) or 0
  table.insert(DataModel.plotList, plotIndex + insertCount, {
    mod = "__CheckBoxExit",
    isWaitFinish = true
  })
end

function controller.GetClassModName(mod)
  return classModName[mod]()
end

function controller.FreshAutoChapterBtn()
  local AutoChapterState = PlotReviewDataModel.GetAutoChapterState()
  local aniName = AutoChapterState and "play02" or "play01"
  View.Btn_PlayIcon.Spine_:SetAction(aniName, true)
end

function controller.RecordCheckBoxReturnIndex(returnIndex, insertCount)
  returnIndex = tonumber(returnIndex)
  if returnIndex == nil or returnIndex <= 0 then
    return
  end
  insertCount = insertCount or 0
  checkBoxReturnInfo = {
    returnIndex = returnIndex,
    insertIndex = plotIndex,
    insertCount = insertCount,
    endIndex = plotIndex + insertCount
  }
end

return controller
