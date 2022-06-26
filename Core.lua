SLASH_HELLO1 = "/hello"
SLASH_WRITER1 = "/writer"
SLASH_CAMERA_CONTROL1 = "/cc"

printGameTocVersion()

local function showGreeting(name)
    message("你好呀, " .. name .. "， 欢迎使用艾泽拉斯作家开发的插件，祝使用愉快！")
end

local function HelloHandler(name)
    local userAddedName = string.len(name) > 0

    if (userAddedName) then
        showGreeting(name)
    else
        local playerName = UnitName("player")
        showGreeting(playerName)
    end

end

local toolMap = {
    cc = {showCameraControl, "打开镜头控制"}
}

local function WriterHandler(toolId)
    if toolMap[toolId] == nil then
        print("------------------------------------")
        for k, v in pairs(toolMap) do
            print("/writer " .. k .. ", " .. v[2])
        end
        print("------------------------------------")
    else
        local functionName = toolMap[toolId][1]

        functionName()
    end
end

local function CameraControlHandler()
    showCameraControl()
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("VARIABLES_LOADED")
EventFrame:SetScript("OnEvent", function(_, event)
   SetCVar("showPlayer", 1)
end)

SlashCmdList.HELLO = HelloHandler
SlashCmdList.WRITER = WriterHandler
SlashCmdList.CAMERA_CONTROL = CameraControlHandler
