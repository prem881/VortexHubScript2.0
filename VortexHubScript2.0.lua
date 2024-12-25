
-- Import Libraries
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


print('                                                                                         mm      ')
print('*@@@@*   *@@@*                     @@                       *@@@@*  *@@@@**             m@@')
print('  *@@     m@                       @@                         @@      @@                 @@        ')
print('   @@m   m@     m@@*@@m *@@@m@@@ @@@@@@   mm@*@@ *@@*   *@@*  @@      @@   *@@@  *@@@    @@m@@@@m  ')
print('    @@m  @*    @@*   *@@  @@* **   @@    m@*   @@  *@@ m@*    @@@@@@@@@@     @@    @@    @@    *@@ ')
print('    *!@ !*     @@     @@  @!       @@    !@******    @@@      !@      @!     !@    @@    !@     @@ ')
print('     !@@m      @@     !@  @!       @!    !@m    m    !!@@     !@      @!     !@    @!    !!!   m@! ')
print('     !! !*     !@     !!  !!       !!    !!******    !!@      :!      !!     !@    !!    !!     !! ')
print('     !!::      !!!   !!!  !:       !!    :!!       !!* !!!    :!      :!     !!    !!    :!!   !!! ')
print('      :         : : : : : :::      ::: :  : : ::  ::    :!: ::: :   : :!::   :: !: :!:   : : : ::  ')
print('                                                                                                   ')


-- Window Settings
local Window = Fluent:CreateWindow({
    Title = "VortexHub",
    SubTitle = "เวอร์ชั่น Beta",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Announce = Window:AddTab({ Title = "ประกาศ", Icon = "megaphone" }),
    Main = Window:AddTab({ Title = "เมนู", Icon = "home" }),
    TP = Window:AddTab({ Title = "วาป", Icon = "cloud" }),
    Discord = Window:AddTab({ Title = "Discord", Icon = "search" }),
    Dev = Window:AddTab({ Title = "Dev", Icon = "user" }),
    Settings = Window:AddTab({ Title = "ตั้งค่า", Icon = "settings" })
}

-- Services and LocalPlayer
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Global Variables
_G.FreezeCharacter = false
_G.AutoEquipRod = false
_G.AutoCast = false
_G.AutoShake = false
_G.AutoReel = false

-- Function: Freeze Character
local function freezeCharacter()
    local oldPos = Char.HumanoidRootPart.CFrame
    while _G.FreezeCharacter do
        task.wait(0.1)
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.CFrame = oldPos
        else
            break
        end
    end
end

-- Function: Teleport
local function teleportTo(position)
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        Char.HumanoidRootPart.CFrame = CFrame.new(position)
        print("Teleported to:", position)
    else
        warn("Character or HumanoidRootPart not found!")
    end
end

-- Add teleport buttons
local teleportLocations = {
    { Title = "Teleport to Moosewood", Position = Vector3.new(386.92, 134.51, 252.23) },
    { Title = "Teleport to Roslit", Position = Vector3.new(-1467.63, 132.52, 711.78) },
    { Title = "Teleport to Mushgrove Swamp", Position = Vector3.new(2425, 130, -670) },
    { Title = "Teleport to Terrapin Island", Position = Vector3.new(-200, 130, 1925) },
    { Title = "Teleport to Snowcap Island", Position = Vector3.new(2600, 150, 2400) },
    { Title = "Teleport to Sunstone Island", Position = Vector3.new(-935, 130, -1105) },
    { Title = "Teleport to Forsaken Shores", Position = Vector3.new(-2425, 135, 1555) },
    { Title = "Teleport to Statue of Sovereignty", Position = Vector3.new(20, 160, -1040) },
    { Title = "Teleport to Keepers Altar", Position = Vector3.new(1380, -805, -300) },
    { Title = "Teleport to Vertigo", Position = Vector3.new(1310.0255126953125, -805.2923583984375, -106.29073333740234) },
    { Title = "Teleport to Desolate Deep", Position = Vector3.new(-790.1,142.6,-3101.9) },
    { Title = "Teleport to Brine Pool", Position = Vector3.new(5833, 125, 401) }
    -- Add more locations here
}

for _, location in ipairs(teleportLocations) do
    Tabs.TP:AddButton({
        Title = location.Title,
        Callback = function()
            teleportTo(location.Position)
        end
    })
end

-- Function: Auto Equip Rod
local function equipItem(itemName)
    local item = LocalPlayer.Backpack:FindFirstChild(itemName)
    if item then
        Char.Humanoid:EquipTool(item)
    end
end

local function autoEquipRod()
    while _G.AutoEquipRod do
        task.wait(0.5)
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("rod") then
                equipItem(tool.Name)
            end
        end
    end
end

-- Toggle: AutoEquipRod
Tabs.Main:AddToggle("AutoEquipRod", { Title = "Auto Equip Rod", Default = false }):OnChanged(function(v)
    _G.AutoEquipRod = v
    if v then
        -- ใช้ coroutine แทน spawn เพื่อให้แน่ใจว่าฟังก์ชันทำงานตลอดเวลา
        coroutine.wrap(function()
            autoEquipRod()
        end)()
    end
end)

-- Function: AutoFish
local function autoFish()
    while _G.AutoFish do
        task.wait(0.1)
        local rod = Char:FindFirstChildOfClass("Tool")
        if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
            rod.events.cast:FireServer(100, 1)
        end
    end
end

-- Toggle: AutoFish
Tabs.Main:AddToggle("AutoFish", { Title = "ออโต้ Fish", Default = false }):OnChanged(function(v)
    _G.AutoFish = v
    if v then
        spawn(autoFish)
    end
end)

-- Function: AutoCast
local function autoCast()
    while _G.AutoCast do
        task.wait(0.1)
        local Rod = Char:FindFirstChildOfClass("Tool")
        if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("cast") then
            Rod.events.cast:FireServer(100, 1)
        end
    end
end

-- Toggle: AutoCast
Tabs.Main:AddToggle("AutoCast", { Title = "ออโต้ Cast", Default = false }):OnChanged(function(v)
    _G.AutoCast = v
    if v then
        spawn(autoCast)
    end
end)

-- Function: AutoShake
local function autoShake()
    while _G.AutoShake do
        task.wait(0.01)
        pcall(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local shakeUI = playerGui:FindFirstChild("shakeui")
            if shakeUI and shakeUI.Enabled then
                local safezone = shakeUI:FindFirstChild("safezone")
                if safezone then
                    local button = safezone:FindFirstChild("button")
                    if button and button:IsA("ImageButton") and button.Visible then
                        GuiService.SelectedCoreObject = button
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                end
            end
        end)
    end
end

-- Toggle: AutoShake
Tabs.Main:AddToggle("AutoShake", { Title = "ออโต้ Shake", Default = false }):OnChanged(function(v)
    _G.AutoShake = v
    if v then
        spawn(autoShake)
    end
end)

-- Function: AutoReel
local function autoReel()
    while _G.AutoReel do
        task.wait(0.15)
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name == "reel" then
                if gui:FindFirstChild("bar") then
                    ReplicatedStorage.events.reelfinished:FireServer(100, true)
                end
            end
        end
    end
end

-- Toggle: AutoReel
Tabs.Main:AddToggle("AutoReel", { Title = "ออโต้ Reel", Default = false }):OnChanged(function(v)
    _G.AutoReel = v
    if v then
        spawn(autoReel)
    end
end)

-- Toggle: Freeze Character
Tabs.Main:AddToggle("FreezeCharacter", { Title = "Freeze Character", Default = false }):OnChanged(function(v)
    _G.FreezeCharacter = v
    if v then
        spawn(freezeCharacter)
    end
end)

-- ฟังก์ชัน AFK
local function afk()
    while _G.AFK do
        -- ตรวจสอบว่า Character มี HumanoidRootPart หรือไม่
        local humanoidRootPart = Char:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- ขยับเล็กน้อยเพื่อป้องกัน Idle Kick
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, 0.1)  -- ขยับไปข้างหน้าเล็กน้อย
        end
        task.wait(5) -- รอ 5 วินาทีแล้วขยับอีก
    end
end

-- Toggle: AFK
Tabs.Main:AddToggle("AFK", { Title = "AFK", Default = false }):OnChanged(function(v)
    _G.AFK = v
    if v then
        -- เริ่มต้นฟังก์ชัน AFK เมื่อเปิดใช้งาน
        spawn(afk)
    end
end)


-- Announce Tab Content
Tabs.Announce:AddParagraph({
    Title = "Now open for Testing | เปิดเทศแล้ววันนี้!",
    Content = ""
})

-- Developer Tab Content
Tabs.Dev:AddParagraph({
    Title = "ADMIN : BY QUQ",
    Content = ""
})
Tabs.Dev:AddParagraph({
    Title = "Developer : BY BLACKxxx.",
    Content = ""
})


-- SaveManager and InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("VortexHub")
SaveManager:SetFolder("VortexHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load Settings
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
