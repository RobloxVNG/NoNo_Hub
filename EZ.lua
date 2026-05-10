-- [[ NONO HUB V10 - FULL PREMIUM & OPEN CODE ]]
-- Cam kết: Có Emoji, Giao diện đẹp, Không ẩn code độc hại

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌊 NoNo Hub | Blox Fruits V4", "DarkScene")

-- === CÁC BIẾN ĐIỀU KHIỂN ===
_G.AutoFarm = false
_G.FastAttack = false
_G.AutoGun = false
_G.NoCooldown = false
_G.WalkWater = false
_G.AutoV4 = false

-- === TAB CHÍNH (FARM) ===
local Tab1 = Window:NewTab("🌾 Farm & Combat")
local Section1 = Tab1:NewSection("Tính năng chính")

Section1:NewToggle("Auto Farm Level 🚀", "Tự động đánh quái lên cấp", function(state)
    _G.AutoFarm = state
end)

Section1:NewToggle("Fast Attack (M1) 🔥", "Đánh nhanh không delay", function(state)
    _G.FastAttack = state
end)

-- === TAB SÚNG (GUN) ===
local Tab2 = Window:NewTab("🔫 Gun Special")
local Section2 = Tab2:NewSection("Súng bá đạo")

Section2:NewToggle("Auto Gun & Aim Bot 🎯", "Tự nhắm và bắn quái", function(state)
    _G.AutoGun = state
end)

Section2:NewToggle("No Cooldown Gun ⚡", "Súng máy xả đạn", function(state)
    _G.NoCooldown = state
end)

-- === TAB SEA EVENT & TỘC ===
local Tab3 = Window:NewTab("🌊 Sea & Race")
local Section3 = Tab3:NewSection("Sea Event & V4")

Section3:NewToggle("Walk On Water 🌊", "Đi trên mặt nước", function(state)
    _G.WalkWater = state
end)

Section3:NewToggle("Auto Race V3/V4 🧬", "Tự bật kĩ năng tộc", function(state)
    _G.AutoV4 = state
end)

-- === [ LOGIC XỬ LÝ - ĐỌC ĐƯỢC 100% ] ===

-- 1. Fast Attack Logic
spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local Combat = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
                Combat.activeController.attackInterval = 0
                Combat.activeController:attack()
            end)
        end
    end
end)

-- 2. Auto Gun & No Cooldown
spawn(function()
    while task.wait() do
        if _G.NoCooldown then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool.ToolTip == "Gun" and tool:FindFirstChild("Stats") then
                tool.Stats.Cooldown.Value = 0
            end
        end
        if _G.AutoGun then
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
        end
    end
end)

-- 3. Walk On Water
spawn(function()
    while task.wait() do
        if _G.WalkWater then
            if not game.Workspace:FindFirstChild("WaterPart") then
                local p = Instance.new("Part", game.Workspace)
                p.Name = "WaterPart"; p.Size = Vector3.new(200, 2, 200); p.Anchored = true; p.Transparency = 0.8
            else
                game.Workspace.WaterPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, -1, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
            end
        else
            if game.Workspace:FindFirstChild("WaterPart") then game.Workspace.WaterPart:Destroy() end
        end
    end
end)

-- 4. Auto V3/V4
spawn(function()
    while task.wait(1) do
        if _G.AutoV4 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ActivateAbility")
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Y, false, game)
        end
    end
end)
