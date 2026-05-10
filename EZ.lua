-- ======================================================
-- NONO HUB - FULL PREMIUM VERSION (EZ.LUA)
-- ======================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌊 NoNo Hub | Blox Fruits Premium V4",
   LoadingTitle = "Đang khởi chạy NoNo Hub...",
   LoadingSubtitle = "by NoNo - High Performance",
   ConfigurationSaving = {Enabled = true, Folder = "NoNoHubConfig"}
})

-- === BIẾN HỆ THỐNG ===
_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.AutoStats = false
_G.StatType = "Melee"
_G.AutoGunAim = false
_G.NoCooldownGun = false
_G.StartSeaEvent = false
_G.ESPFruit = false
_G.BlackScreen = false

-- === HÀM HỖ TRỢ ===
function EquipWeapon(toolType)
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == toolType or v.Name == toolType) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

-- === GIAO DIỆN CÁC TAB ===

-- TAB FARM
local FarmTab = Window:CreateTab("🌾 Farm & Gun", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

FarmTab:CreateSection("Súng (Gun) Special")

FarmTab:CreateToggle({
   Name = "Auto Gun & Aim Bot (Tự bắn quái)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoGunAim = Value end,
})

FarmTab:CreateToggle({
   Name = "No Cooldown Gun (Súng không hồi chiêu)",
   CurrentValue = false,
   Callback = function(Value) _G.NoCooldownGun = Value end,
})

-- TAB CHỈ SỐ
local StatTab = Window:CreateTab("📊 Chỉ Số", 4483362458)
StatTab:CreateToggle({
   Name = "Auto Cộng Điểm",
   CurrentValue = false,
   Callback = function(Value) _G.AutoStats = Value end,
})

-- TAB HỆ THỐNG
local SysTab = Window:CreateTab("⚙️ Hệ Thống", 4483362458)
SysTab:CreateToggle({
   Name = "Màn Hình Đen (Treo Máy)",
   CurrentValue = false,
   Callback = function(Value)
      local black = game:GetService("CoreGui"):FindFirstChild("NoNoBlack") or Instance.new("ScreenGui", game:GetService("CoreGui"))
      black.Name = "NoNoBlack"
      local f = black:FindFirstChild("Frame") or Instance.new("Frame", black)
      f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,0,0); f.Visible = Value
   end,
})

-- === BỘ NÃO XỬ LÝ (LOGIC) ===

-- 1. Vòng lặp Auto Farm & Gun
spawn(function()
    while task.wait() do
        pcall(function()
            -- Logic Auto Farm Level
            if _G.AutoFarm then
                EquipWeapon(_G.SelectWeapon)
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    end
                end
            end

            -- Logic Auto Gun & Aim Bot
            if _G.AutoGunAim then
                local target = nil
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        target = v
                        break
                    end
                end
                
                if target then
                    EquipWeapon("Gun")
                    local gun = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if gun and gun.ToolTip == "Gun" then
                        -- Gửi lệnh bắn thẳng vào quái
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ShootGun", {
                            ["Target"] = target.HumanoidRootPart,
                            ["Pos"] = target.HumanoidRootPart.Position
                        })
                        -- Auto Click
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    end
                end
            end
        end)
    end
end)

-- 2. Vòng lặp No Cooldown Gun
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoCooldownGun then
            pcall(function()
                local gun = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if gun and gun.ToolTip == "Gun" then
                    -- Reset delay bắn
                    if gun:FindFirstChild("Stats") and gun.Stats:FindFirstChild("Cooldown") then
                        gun.Stats.Cooldown.Value = 0
                    end
                end
            end)
        end
    end)
end)

-- 3. Vòng lặp Cộng Stats
spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", _G.StatType, 1)
        end
    end
end)

Rayfield:Notify({Title = "NoNo Hub", Content = "Đã cập nhật Auto Gun & No Cooldown!", Duration = 5})
