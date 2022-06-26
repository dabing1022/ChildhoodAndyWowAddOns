local panelWidth = 500
local panelHeight = 440
local buttonEdgeMargin = 10
local buttonSliderHSpace = 16
local cameraStartStopButtonWidth = 100
local sliderWidth = panelWidth - 2 * buttonEdgeMargin - 2 * buttonSliderHSpace - 2 * cameraStartStopButtonWidth

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

local weatherDensityControlSlider

local cameraControlFrame
local CameraControlFrameName = "CameraControlFrame"

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

local function OnWeatherDensityValueChanged(slider ,value)
  local intValue = math.floor(value)
  _G[slider:GetName() .. 'Text']:SetText("天气效果：" .. intValue)
  ConsoleExec("weatherDensity " .. intValue)
  ConsoleExec("RAIDweatherDensity " .. intValue)
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

local function buildWeatherDensitySlider(globalName, alignWidget, parent)
  local slider = CreateFrame("Slider", globalName, parent, "OptionsSliderTemplate")
  slider:SetScript("OnValueChanged", nil)
  slider:SetOrientation("HORIZONTAL")
  slider:SetPoint("TOP", alignWidget, "BOTTOM", 0, -30) 
  slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
  slider:SetMinMaxValues(0, 3)
  slider:SetValueStep(1)
  slider:SetStepsPerPage(1)
  slider:SetValue(2)
  slider:SetWidth(panelWidth - 100)
  slider:SetHeight(15)
  _G[slider:GetName() .. 'Low']:SetText('0')      
  _G[slider:GetName() .. 'High']:SetText('3')   
  _G[slider:GetName() .. 'Text']:SetText("天气效果：" .. '2')
  slider:SetScript("OnValueChanged", OnWeatherDensityValueChanged)

  return slider
end

function showCameraControl()
    if cameraControlFrame ~= nil and not cameraControlFrame:IsVisible() then
      cameraControlFrame:Show()
      return
    end

    cameraControlFrame = CreateFrame("Frame", CameraControlFrameName, UIParent, "BasicFrameTemplateWithInset")
    cameraControlFrame:SetSize(panelWidth, panelHeight)
    cameraControlFrame:SetPoint("CENTER")
    cameraControlFrame:SetMovable(true)
    cameraControlFrame:EnableMouse(true)
    cameraControlFrame:RegisterForDrag("LeftButton")
    cameraControlFrame:SetScript("OnDragStart", function(self)
      self:StartMoving()
    end)
    cameraControlFrame:SetScript("OnDragStop", function(self)
      self:StopMovingOrSizing()
    end)

    cameraControlFrame.title = cameraControlFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cameraControlFrame.title:SetPoint("CENTER", cameraControlFrame.TitleBg, "CENTER", 0, -2)
    cameraControlFrame.title:SetText("镜头录制控制器")

    moveViewInStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewInStartButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewInStartButton:SetPoint("TOPLEFT", CameraControlFrameName, "TOPLEFT", buttonEdgeMargin, -40)
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

    moveViewInSpeedSlider = buildASlider("moveViewInSpeedSliderGlobalName", moveViewInStartButton, cameraControlFrame)

    moveViewInStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewInStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewInStopButton:SetPoint("TOPRIGHT", CameraControlFrameName, "TOPRIGHT", -buttonEdgeMargin, -40)
    moveViewInStopButton:SetText("停止拉近")
    moveViewInStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewInStopButton:SetScript("OnClick", function(self, button, down)
        moveViewInStartButton:Enable()

        MoveViewInStop()
    end)

    moveViewOutStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
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

    moveViewOutSpeedSlider = buildASlider("moveViewOutSpeedSliderGlobalName", moveViewOutStartButton, cameraControlFrame)

    moveViewOutStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewOutStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewOutStopButton:SetPoint("TOP", moveViewInStopButton, "BOTTOM", 0, -15)
    moveViewOutStopButton:SetText("停止拉远")
    moveViewOutStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewOutStopButton:SetScript("OnClick", function(self, button, down)
        moveViewOutStartButton:Enable()
        MoveViewOutStop()
    end)

    moveViewLeftStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
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

    moveViewLeftSpeedSlider = buildASlider("moveViewLeftSpeedSliderGlobalName", moveViewLeftStartButton, cameraControlFrame)

    moveViewLeftStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewLeftStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewLeftStopButton:SetPoint("TOP", moveViewOutStopButton, "BOTTOM", 0, -15)
    moveViewLeftStopButton:SetText("停止左旋")
    moveViewLeftStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewLeftStopButton:SetScript("OnClick", function(self, button, down)
        moveViewLeftStartButton:Enable()
        MoveViewLeftStop()
    end)

    moveViewRightStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
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

    moveViewRightSpeedSlider = buildASlider("moveViewRightSpeedSliderGlobalName", moveViewRightStartButton, cameraControlFrame)

    moveViewRightStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewRightStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewRightStopButton:SetPoint("TOP", moveViewLeftStopButton, "BOTTOM", 0, -15)
    moveViewRightStopButton:SetText("停止右旋")
    moveViewRightStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewRightStopButton:SetScript("OnClick", function(self, button, down)
        moveViewRightStartButton:Enable()
        MoveViewRightStop()
    end)

    moveViewUpStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
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

    moveViewUpSpeedSlider = buildASlider("moveViewUpSpeedSliderGlobalName", moveViewUpStartButton, cameraControlFrame)

    moveViewUpStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewUpStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewUpStopButton:SetPoint("TOP", moveViewRightStopButton, "BOTTOM", 0, -15)
    moveViewUpStopButton:SetText("停止上摇")
    moveViewUpStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewUpStopButton:SetScript("OnClick", function(self, button, down)
        moveViewUpStartButton:Enable()
        MoveViewUpStop()
    end)

    moveViewDownStartButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
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

    moveViewDownSpeedSlider = buildASlider("moveViewDownSpeedSliderGlobalName", moveViewDownStartButton, cameraControlFrame)

    moveViewDownStopButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    moveViewDownStopButton:SetSize(cameraStartStopButtonWidth, 30)
    moveViewDownStopButton:SetPoint("TOP", moveViewUpStopButton, "BOTTOM", 0, -15)
    moveViewDownStopButton:SetText("停止下摇")
    moveViewDownStopButton:RegisterForClicks("AnyUp", "AnyDown")
    moveViewDownStopButton:SetScript("OnClick", function(self, button, down)
        moveViewDownStartButton:Enable()
        MoveViewDownStop()
    end)

    weatherDensityControlSlider = buildWeatherDensitySlider("weatherDensityControlSliderGlobalName", moveViewDownSpeedSlider, cameraControlFrame)

    local showPlayerButton = CreateFrame("CheckButton", "showPlayerButtonGlobalName", cameraControlFrame, "OptionsCheckButtonTemplate")
    showPlayerButton:SetPoint("BOTTOMLEFT", CameraControlFrameName, "BOTTOMLEFT", buttonEdgeMargin, 10)
    showPlayerButton:SetChecked(true)
		_G[showPlayerButton:GetName() .. "Text"]:SetText("切换显示自己")
		showPlayerButton:SetScript("OnClick", function(self, frame)
      local __checked = self:GetChecked()
      if __checked then
        ConsoleExec("showPlayer 1")
      else
        ConsoleExec("showPlayer 0")
      end
		end)

    local allCameraStartButtons = {moveViewInStartButton, moveViewOutStartButton, moveViewLeftStartButton,
                                   moveViewRightStartButton, moveViewUpStartButton, moveViewDownStartButton}

    local stopAllCameraMoveButton = CreateFrame("Button", nil, cameraControlFrame, "UIPanelButtonTemplate")
    stopAllCameraMoveButton:SetSize(180, 30)
    stopAllCameraMoveButton:SetPoint("BOTTOM", cameraControlFrame, "BOTTOM", 0, 10)
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
