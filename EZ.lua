--[[
    NAME: NoNo_Hub
    VERSION: 2026 - Fresh Character Logic
    STATUS: FIXED CHARACTER CACHE & RESPAWN ISSUE
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- // CONFIGURATION //
_G.Config = {
    AutoFarm = false,
    TweenSpeed = 225,
    AutoHopTarget = "",
    AntiAFK = true
}

--------------------------------------------------
-- FIX 1: CHARACTER REFRESH LOGIC (CHỐNG OUTDATED)
--------------------------------------------------
local function GetCharacter()
    local Char = Player.Character
    if not Char then return nil, nil, nil end

    local Root = Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char:FindFirstChild("Humanoid")

    return Char, Root, Hum
end

--------------------------------------------------
-- HỆ THỐNG TWEEN & DI CHUYỂN (DÙNG FRESH DATA)
--------------------------------------------------
local CurrentTween = nil

local function StopTween()
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
end

local function To(targetCFrame)
    local Char, Root, Hum = GetCharacter()
    
    -- Kiểm tra nhân vật còn sống và đầy đủ bộ phận không
    if not Root or not Hum or Hum.Health <= 0 then 
        StopTween()
        return 
    end
    
    local dist = (targetCFrame.Position - Root.Position).Magnitude
    if dist < 5 then StopTween() return end

    local speed = math.max(_G.Config.TweenSpeed, 1)
    
    StopTween() 
    Root.CanCollide = false 
    
    CurrentTween = TweenService:Create(Root, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    CurrentTween:Play()
end

-- Tự động dừng Tween khi nhân vật reset/chết thông qua event mới
Player.CharacterAppearanceLoaded:Connect(function()
    StopTween()
end)

--------------------------------------------------
-- HỆ THỐNG SERVER HOP (AUTO-LOOP)
--------------------------------------------------
if Player.PlayerGui:FindFirstChild("NoNo_Hub") then
    Player.PlayerGui.NoNo_Hub:Destroy()
end

local function GetEnemies()
    local Enemies = workspace:FindFirstChild("Enemies")
    return Enemies and Enemies:GetChildren() or {}
end

local function HopServer()
    pcall(function()
        local PlaceID = game.PlaceId
        local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Desc&limit=100"))
        local List = {}
        for _, s in pairs(Servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                table.insert(List, s.id)
            end
        end
        if #List > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceID, List[math.random(1, #List)])
        end
    end)
end

-- Vòng lặp kiểm tra Boss runtime
task.spawn(function()
    while task.wait(5) do
        if _G.Config.AutoHopTarget ~= "" then
            local found = false
            for _, v in pairs(GetEnemies()) do
                if v.Name:lower():find(_G.Config.AutoHopTarget:lower()) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    found = true
                    break
                end
            end
            
            if not found then
                print("NoNo_Hub: Đang tìm server có " .. _G.Config.AutoHopTarget)
                HopServer()
            else
                print("NoNo_Hub: Đã tìm thấy mục tiêu! Dừng Hop.")
                _G.Config.AutoHopTarget = "" 
            end
        end
    end
end)

--------------------------------------------------
-- GIAO DIỆN CHÍNH NoNo_Hub
--------------------------------------------------
local Gui = Instance.new("ScreenGui", Player.PlayerGui)
Gui.Name = "NoNo_Hub"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 420, 0, 350)
Main.Position = UDim2.new(0.5, -210, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Topbar = Instance.new("Frame", Main)
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Topbar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "NoNo_Hub | 2026 Edition"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 8)

local function NewButton(Text, Target)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    btn.Text = "Săn Boss: " .. Text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        _G.Config.AutoHopTarget = Target
        print("NoNo_Hub: Bắt đầu săn " .. Target)
    end)
end

-- Danh sách Boss
NewButton("Rip_Indra", "rip_indra")
NewButton("Dough King", "Dough King")
NewButton("Darkbeard", "Darkbeard")

local StopBtn = Instance.new("TextButton", Container)
StopBtn.Size = UDim2.new(1, 0, 0, 40)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopBtn.Text = "DỪNG TỰ ĐỘNG NHẢY SERVER"
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StopBtn)
StopBtn.MouseButton1Click:Connect(function()
    _G.Config.AutoHopTarget = ""
end)

-- Kéo thả UI & Anti-AFK
local dragging, dragStart, startPos
Topbar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Player.Idled:Connect(function()
    if _G.Config.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

print("NoNo_Hub: Character Logic Fixed.")
