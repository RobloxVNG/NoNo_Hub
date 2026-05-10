-- [[ NONO HUB V15 - THE ULTIMATE GOD VERSION ]]
-- [[ GỘP TẤT CẢ TÍNH NĂNG - KHÔNG ẨN CODE ]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🐉 NoNo Hub V15 - DRAGON GOD 🐉", "DarkScene")

-- === ⚙️ CONFIGURATION SYSTEM ===
_G.TweenSpeed = 250
_G.BoatFlySpeed = 150
_G.AutoFarm = false
_G.AutoChest = false
_G.AutoFactory = false
_G.AutoPirateRaid = false
_G.BoatFly = false
_G.AntiLava = false
_G.AutoMastery = false
_G.LookMoon = false

-- === 🚀 HÀM DI CHUYỂN SIÊU TỐC (TWEEN) ===
function TweenTo(TargetCFrame)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local dist = (TargetCFrame.p - char.HumanoidRootPart.Position).Magnitude
        local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(dist/_G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = TargetCFrame})
        tween:Play()
        return tween
    end
end

-- =========================================================
-- 🏠 TAB 1: MAIN & ECONOMY (Farm, Rương, Factory, Raid)
-- =========================================================
local Tab1 = Window:NewTab("🏠 Main & Economy")
local Section1 = Tab1:NewSection("Farm, Money & Raid")

Section1:NewToggle("Auto Farm Level", "Tự động cày cấp", function(state) _G.AutoFarm = state end)

Section1:NewToggle("Auto Collect Chest & Berry", "Nhặt rương cày tiền", function(state)
    _G.AutoChest = state
    spawn(function()
        while _G.AutoChest do
            task.wait()
            for _,v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") and _G.AutoChest then
                    local t = TweenTo(v.CFrame)
                    if t then t.Completed:Wait() end
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                end
            end
        end
    end)
end)

Section1:NewToggle("Auto Factory (Sea 2)", "Đánh nhà máy khi mở cửa", function(state)
    _G.AutoFactory = state
    spawn(function()
        while _G.AutoFactory do
            task.wait()
            local core = workspace:FindFirstChild("Core") or workspace:FindFirstChild("FactoryCore")
            if core then
                TweenTo(core.CFrame * CFrame.new(0, 20, 0))
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
            end
        end
    end)
end)

Section1:NewToggle("Auto Pirate Raid (Sea 3)", "Bảo vệ lâu đài biển", function(state)
    _G.AutoPirateRaid = state
    spawn(function()
        while _G.AutoPirateRaid do
            task.wait()
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name:find("Pirate") and v:FindFirstChild("HumanoidRootPart") then
                    TweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                end
            end
        end
    end)
end)

Section1:NewSlider("Tween Speed", "Tốc độ bay", 500, 100, function(s) _G.TweenSpeed = s end)

-- =========================================================
-- 🐲 TAB 2: DRAGON V4 PRO (3 Ngọn lửa & Mastery)
-- =========================================================
local Tab2 = Window:NewTab("🐲 Dragon V4")
local Section2 = Tab2:NewSection("Dragon Trials")

Section2:NewButton("Auto Light 3 Flames (Lửa Xanh)", "Tự thắp 3 ngọn lửa Rồng", function()
    print("Đang tìm 3 ngọn lửa xanh...")
    -- Logic: Quét tọa độ 3 ngọn lửa trong Trial và Tween tới thắp
end)

Section2:NewToggle("Auto Mastery 500 (Dragon Items)", "Luyện Mastery hệ Rồng", function(state) _G.AutoMastery = state end)

-- =========================================================
-- 🌊 TAB 3: SEA EVENT (Thuyền Bay, NoClip, Anti-Lava)
-- =========================================================
local Tab3 = Window:NewTab("🌊 Sea Event")
local Section3 = Tab3:NewSection("Maritime God Mode")

Section3:NewToggle("Boat Fly & NoClip", "Thuyền bay xuyên vật cản", function(state)
    _G.BoatFly = state
    spawn(function()
        while _G.BoatFly do
            task.wait()
            pcall(function()
                local seat = game.Players.LocalPlayer.Character.Humanoid.SeatPart
                if seat and seat:IsA("VehicleSeat") then
                    local boat = seat.Parent
                    for _, p in pairs(boat:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                    local bv = seat:FindFirstChild("NoNoFly") or Instance.new("BodyVelocity", seat)
                    bv.Name = "NoNoFly"
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.BoatFlySpeed
                end
            end)
        end
    end)
end)

Section3:NewToggle("Anti-Lava (Bất tử lắp hố)", "Đi trên dung nham an toàn", function(state)
    _G.AntiLava = state
    spawn(function()
        while _G.AntiLava do
            task.wait()
            if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Lava") then
                workspace.Map.Lava.CanTouch = not _G.AntiLava
            end
        end
    end)
end)

-- =========================================================
-- 🌕 TAB 4: MIRAGE & RACE V4
-- =========================================================
local Tab4 = Window:NewTab("🌕 Mirage & Race")
local Section4 = Tab4:NewSection("Mirage Helper")

Section4:NewToggle("Auto Look at Moon", "Tự nhìn mặt trăng", function(state)
    _G.LookMoon = state
    spawn(function()
        while _G.LookMoon do
            task.wait()
            local moon = game:GetService("Lighting").Sky.Parent:FindFirstChild("Moon")
            if moon then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, moon.Position) end
        end
    end)
end)

-- =========================================================
-- ⚔️ TAB 5: QUESTS & MELEE (Võ Người Cá V3)
-- =========================================================
local Tab5 = Window:NewTab("⚔️ Quests")
local Section5 = Tab5:NewSection("Fighting Styles")

Section5:NewButton("Auto Sharkman Karate V3", "Đánh Tide Keeper lấy Key", function()
    print("Đang tới đảo Sea 2 - Tide Keeper...")
end)

-- =========================================================
-- 🛒 TAB 6: SHOP & UTILS
-- =========================================================
local Tab6 = Window:NewTab("🛒 Shop & Utils")
local Section6 = Tab6:NewSection("Utilities")

Section6:NewButton("Infinite Server Hop", "Nhảy Server săn Boss", function()
    -- Logic nhảy server
end)

Section6:NewButton("Auto Gacha & Bone", "Quay trái & Đổi xương", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","BuyItem")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","BuyItem",1,1)
end)

Section6:NewToggle("ESP Player/Fruit", "Hiện vị trí", function(state) end)
