local pannelWidth = 500
local buttonEdgeMargin = 10
local buttonSliderHSpace = 16
local cameraStartStopButtonWidth = 100
local sliderWidth = pannelWidth - 2 * buttonEdgeMargin - 2 * buttonSliderHSpace - 2 * cameraStartStopButtonWidth

local moveViewInStartButton
local moveViewInSpeedSlider
local moveViewInStopButton

local moveViewOutStartButton
local moveViewOutSpeedSlider
local moveViewOutStopButton

local moveViewLeftStartButton
local moveViewLeftSpeedSlider
local moveViewLeftStopButton

local moveViewRightStartButton
local moveViewRightSpeedSlider
local moveViewRightStopButton

local moveViewUpStartButton
local moveViewUpSpeedSlider
local moveViewUpStopButton

local moveViewDownStartButton
local moveViewDownSpeedSlider
local moveViewDownStopButton  

local function stopAllCameraMove()
    MoveViewOutStop()
    MoveViewInStop()
    MoveViewLeftStop()
    MoveViewRightStop()
    MoveViewUpStop()
    MoveViewDownStop()
end

local function stopInOutCameraMove()
    MoveViewOutStop()
    MoveViewInStop()
end

local function stopLeftRightCameraMove()
    MoveViewLeftStop()
    MoveViewRightStop()
end

local function stopUpDownCameraMove()
    MoveViewUpStop()
    MoveViewDownStop()
end

local function OnCameraSpeedChanged(slider, value)
  _G[slider:GetName() .. 'Text']:SetText(string.format("%.2f", value))
  if (slider:GetName() == "moveViewInSpeedSliderGlobalName") then
    if not moveViewInStartButton:IsEnabled() then
      MoveViewInStart(value)
    end
  end
  if (slider:GetName() == "moveViewOutSpeedSliderGlobalName") then
    if not moveViewOutStartButton:IsEnabled() then
      MoveViewOutStart(value)
    end
  end
  if (slider:GetName() == "moveViewLeftSpeedSliderGlobalName") then
    if not moveViewLeftStartButton:IsEnabled() then
      MoveViewLeftStart(value)
    end
  end
  if (slider:GetName() == "moveViewRightSpeedSliderGlobalName") then
    if not moveViewRightStartButton:IsEnabled() then
      MoveViewRightStart(value)
    end
  end
  if (slider:GetName() == "moveViewUpSpeedSliderGlobalName") then
    if not moveViewUpStartButton:IsEnabled() then
      MoveViewUpStart(value)
    end
  end
  if (slider:GetName() == "moveViewDownSpeedSliderGlobalName") then
    if not moveViewDownStartButton:IsEnabled() then
      MoveViewDownStart(value)
    end
  end
end

local function buildASlider(globalName, alignButton, parent)
  local slider = CreateFrame("Slider", globalName, parent, "OptionsSliderTemplate")
  slider:SetScript("OnValueChanged", nil)
  slider:SetOrientation("HORIZONTAL")
  slider:SetPoint("LEFT", alignButton, "RIGHT", 10, 0) 
  slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  slider:SetMinMaxValues(0.01, 2.00)
  slider:SetValueStep(0.01)
  slider:SetValue(0.02)
  slider:SetWidth(sliderWidth)
  slider:SetHeight(15)
  _G[slider:GetName() .. 'Low']:SetText('0.01')      
  _G[slider:GetName() .. 'High']:SetText('2.00')   
  _G[slider:GetName() .. 'Text']:SetText('0.02')
  slider:SetScript("OnValueChanged", OnCameraSpeedChanged)

  return slider
end

function showCameraControl()

    local cameraControlFrame
    local bgLabel

    local backdropInfo = {
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    }

    cameraControlFrame = FrameBackdrop
    if not cameraControlFrame:IsVisible() then
      cameraControlFrame:Show()
      return
    end
    cameraControlFrame:SetBackdrop(backdropInfo);
    cameraControlFrame:SetBackdropColor(0, 0, 0, 1)

    bgLabel = FrameFontString
    bgLabel:SetText("镜头录制控制器")
    bgLabel:SetPoint("TOP", "FrameBackdrop", "TOP", 0, -20)
    bgLabel:SetTextColor(1, 1, 1)

    moveViewInStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewInStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewInStartButton:SetPoint("TOPLEFT", "FrameBackdrop", "TOPLEFT", buttonEdgeMargin, -60)
    moveViewInStartButton:SetText("镜头拉近")
    moveViewInStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewInStartButton:SetScript("OnClick", function(self, button, down)
        stopInOutCameraMove()

        MoveViewInStart(moveViewInSpeedSlider:GetValue())
        if down then
            moveViewInStartButton:Disable()

            moveViewOutStartButton:Enable()
        end
    end)

    moveViewInSpeedSlider = buildASlider("moveViewInSpeedSliderGlobalName", moveViewInStartButton, FrameBackdrop)

    moveViewInStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewInStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewInStopButton:SetPoint("TOPRIGHT", "FrameBackdrop", "TOPRIGHT", -buttonEdgeMargin, -60)
    moveViewInStopButton:SetText("停止拉近")
    moveViewInStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewInStopButton:SetScript("OnClick", function(self, button, down)
        moveViewInStartButton:Enable()

        MoveViewInStop()
    end)

    moveViewOutStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewOutStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewOutStartButton:SetPoint("TOP", moveViewInStartButton, "BOTTOM", 0, -15)
    moveViewOutStartButton:SetText("镜头拉远")
    moveViewOutStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewOutStartButton:SetScript("OnClick", function(self, button, down)
        stopInOutCameraMove()

        MoveViewOutStart(moveViewOutSpeedSlider:GetValue())
        if down then
            moveViewOutStartButton:Disable()
            moveViewInStartButton:Enable()
        end
    end)

    moveViewOutSpeedSlider = buildASlider("moveViewOutSpeedSliderGlobalName", moveViewOutStartButton, FrameBackdrop)

    moveViewOutStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewOutStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewOutStopButton:SetPoint("TOP", moveViewInStopButton, "BOTTOM", 0, -15)
    moveViewOutStopButton:SetText("停止拉远")
    moveViewOutStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewOutStopButton:SetScript("OnClick", function(self, button, down)
        moveViewOutStartButton:Enable()
        MoveViewOutStop()
    end)

    moveViewLeftStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewLeftStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewLeftStartButton:SetPoint("TOP", moveViewOutStartButton, "BOTTOM", 0, -15)
    moveViewLeftStartButton:SetText("镜头左旋")
    moveViewLeftStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewLeftStartButton:SetScript("OnClick", function(self, button, down)
        stopLeftRightCameraMove()
        MoveViewLeftStart(moveViewLeftSpeedSlider:GetValue())

        if down then
            moveViewLeftStartButton:Disable()
            moveViewRightStartButton:Enable()
        end
    end)

    moveViewLeftSpeedSlider = buildASlider("moveViewLeftSpeedSliderGlobalName", moveViewLeftStartButton, FrameBackdrop)

    moveViewLeftStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewLeftStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewLeftStopButton:SetPoint("TOP", moveViewOutStopButton, "BOTTOM", 0, -15)
    moveViewLeftStopButton:SetText("停止左旋")
    moveViewLeftStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewLeftStopButton:SetScript("OnClick", function(self, button, down)
        moveViewLeftStartButton:Enable()
        MoveViewLeftStop()
    end)

    moveViewRightStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewRightStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewRightStartButton:SetPoint("TOP", moveViewLeftStartButton, "BOTTOM", 0, -15)
    moveViewRightStartButton:SetText("镜头右旋")
    moveViewRightStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewRightStartButton:SetScript("OnClick", function(self, button, down)
        stopLeftRightCameraMove()
        MoveViewRightStart(moveViewRightSpeedSlider:GetValue())

        if down then
            moveViewRightStartButton:Disable()
            moveViewLeftStartButton:Enable()
        end
    end)

    moveViewRightSpeedSlider = buildASlider("moveViewRightSpeedSliderGlobalName", moveViewRightStartButton, FrameBackdrop)

    moveViewRightStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewRightStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewRightStopButton:SetPoint("TOP", moveViewLeftStopButton, "BOTTOM", 0, -15)
    moveViewRightStopButton:SetText("停止右旋")
    moveViewRightStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewRightStopButton:SetScript("OnClick", function(self, button, down)
        moveViewRightStartButton:Enable()
        MoveViewRightStop()
    end)

    moveViewUpStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewUpStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewUpStartButton:SetPoint("TOP", moveViewRightStartButton, "BOTTOM", 0, -15)
    moveViewUpStartButton:SetText("镜头上摇")
    moveViewUpStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewUpStartButton:SetScript("OnClick", function(self, button, down)
        stopUpDownCameraMove()
        MoveViewUpStart(moveViewUpSpeedSlider:GetValue())

        if down then
            moveViewUpStartButton:Disable()
            moveViewDownStartButton:Enable()
        end
    end)

    moveViewUpSpeedSlider = buildASlider("moveViewUpSpeedSliderGlobalName", moveViewUpStartButton, FrameBackdrop)

    moveViewUpStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewUpStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewUpStopButton:SetPoint("TOP", moveViewRightStopButton, "BOTTOM", 0, -15)
    moveViewUpStopButton:SetText("停止上摇")
    moveViewUpStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewUpStopButton:SetScript("OnClick", function(self, button, down)
        moveViewUpStartButton:Enable()
        MoveViewUpStop()
    end)

    moveViewDownStartButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewDownStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewDownStartButton:SetPoint("TOP", moveViewUpStartButton, "BOTTOM", 0, -15)
    moveViewDownStartButton:SetText("镜头下摇")
    moveViewDownStartButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewDownStartButton:SetScript("OnClick", function(self, button, down)
        stopUpDownCameraMove()
        MoveViewDownStart(moveViewDownSpeedSlider:GetValue())

        if down then
            moveViewDownStartButton:Disable()
            moveViewUpStartButton:Enable()
        end
    end)

    moveViewDownSpeedSlider = buildASlider("moveViewDownSpeedSliderGlobalName", moveViewDownStartButton, FrameBackdrop)

    moveViewDownStopButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    moveViewDownStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewDownStopButton:SetPoint("TOP", moveViewUpStopButton, "BOTTOM", 0, -15)
    moveViewDownStopButton:SetText("停止下摇")
    moveViewDownStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewDownStopButton:SetScript("OnClick", function(self, button, down)
        moveViewDownStartButton:Enable()
        MoveViewDownStop()
    end)

    local showPlayerButton = CreateFrame("CheckButton", "showPlayerButtonGlobalName", FrameBackdrop, "OptionsCheckButtonTemplate")
    showPlayerButton:SetPoint("BOTTOMLEFT", "FrameBackdrop", "BOTTOMLEFT", buttonEdgeMargin, 10)
    showPlayerButton:SetChecked(true)
		_G[showPlayerButton:GetName() .. "Text"]:SetText("是否显示玩家自己")
		showPlayerButton:SetScript("OnClick", function(self, frame)
      local __checked = self:GetChecked()
      if __checked then
        print("checked")
        C_CVar.SetCVar("showPlayer", 1, "showPlayerEvent_1")
      else
        print("not checked")
        C_CVar.SetCVar("showPlayer", 0, "showPlayerEvent_0")
      end
		end)

    local closeButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    closeButton:SetSize(50, 30)
    closeButton:SetPoint("BOTTOM", "FrameBackdrop", "BOTTOM", 0, 10)
    closeButton:SetText("关闭")
    closeButton:RegisterForClicks("AnyUp", "AnyDown")
    closeButton:SetScript("OnClick", function(self, button, down)
        getglobal("FrameBackdrop"):Hide()
    end)

    local allCameraStartButtons = {moveViewInStartButton, moveViewOutStartButton, moveViewLeftStartButton,
                                   moveViewRightStartButton, moveViewUpStartButton, moveViewDownStartButton}

    local stopAllCameraMoveButton = CreateFrame("Button", nil, FrameBackdrop, "UIPanelButtonTemplate")
    stopAllCameraMoveButton:SetSize(180, 30)
    stopAllCameraMoveButton:SetPoint("BOTTOM", closeButton, "TOP", 0, 15)
    stopAllCameraMoveButton:SetText("停止所有镜头运动")
    stopAllCameraMoveButton:RegisterForClicks("AnyUp", "AnyDown")
    stopAllCameraMoveButton:SetScript("OnClick", function(self, button, down)
        if down then
            for i = 1, #allCameraStartButtons do
                local button = allCameraStartButtons[i]
                button:Enable()
            end
            stopAllCameraMove()
        end
    end)
end
