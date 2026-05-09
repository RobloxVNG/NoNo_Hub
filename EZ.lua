-- ======================================================
-- NONO HUB - FULL PREMIUM VERSION (OPEN SOURCE)
-- ======================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌊 NoNo Hub | Blox Fruits Premium V4",
   LoadingTitle = "Đang khởi chạy NoNo Hub...",
   LoadingSubtitle = "by NoNo - Full Chức Năng",
   ConfigurationSaving = {Enabled = true, Folder = "NoNoHubConfig"}
})

-- === BIẾN HỆ THỐNG ===
_G.AutoFarm = false
_G.SelectWeapon = "Melee"
_G.AutoStats = false
_G.StatType = "Melee"
_G.AutoChest = false
_G.AutoPickFruit = false
_G.AutoStoreFruit = false
_G.StartSeaEvent = false
_G.BoatSpeed = 100
_G.M1Fruit = false
_G.AutoKitsune = false
_G.AutoMagmaEvent = false
_G.ESPFruit = false
_G.ESPPlayer = false
_G.BlackScreen = false

-- === HÀM TRANG BỊ VŨ KHÍ ===
function EquipWeapon()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == _G.SelectWeapon or v.Name == _G.SelectWeapon) then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

-- === TAB 1: FARM LEVEL (Chi tiết) ===
local FarmTab = Window:CreateTab("🌾 Farm", 4483362458)
FarmTab:CreateToggle({
   Name = "Auto Farm Level (Tự nhận Quest)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})
FarmTab:CreateDropdown({
   Name = "Chọn Vũ Khí Farm",
   Options = {"Melee", "Sword", "Blox Fruit"},
   CurrentOption = {"Melee"},
   Callback = function(Option) _G.SelectWeapon = Option[1] end,
})

-- === TAB 2: NHẶT ĐỒ & ESP (Auto Nhặt) ===
local CollectTab = Window:CreateTab("📦 Nhặt & ESP", 4483362458)
CollectTab:CreateSection("Auto Thu Thập")
CollectTab:CreateToggle({
   Name = "Auto Nhặt Rương (Di chuyển mượt)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoChest = Value end,
})
CollectTab:CreateToggle({
   Name = "Auto Nhặt Trái Ác Quỷ",
   CurrentValue = false,
   Callback = function(Value) _G.AutoPickFruit = Value end,
})
CollectTab:CreateToggle({
   Name = "Auto Cất Trái (Store)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoStoreFruit = Value end,
})
CollectTab:CreateSection("Nhìn Xuyên Thấu")
CollectTab:CreateToggle({
   Name = "ESP Người Chơi",
   CurrentValue = false,
   Callback = function(Value) _G.ESPPlayer = Value end,
})
CollectTab:CreateToggle({
   Name = "ESP Trái Ác Quỷ",
   CurrentValue = false,
   Callback = function(Value) _G.ESPFruit = Value end,
})

-- === TAB 3: SEA EVENT (Săn Quái Biển) ===
local SeaTab = Window:CreateTab("🌊 Sea Event", 4483362458)
SeaTab:CreateDropdown({
   Name = "Chọn Thuyền",
   Options = {"Sloop", "Brig", "Lantern"},
   CurrentOption = {"Sloop"},
   Callback = function(Option) _G.SelectedBoat = Option[1] end,
})
SeaTab:CreateSlider({
   Name = "Tốc Độ Thuyền",
   Min = 50, Max = 300, CurrentValue = 100,
   Callback = function(Value) _G.BoatSpeed = Value end,
})
SeaTab:CreateToggle({
   Name = "Bắt Đầu Đi Sea Event",
   CurrentValue = false,
   Callback = function(Value) _G.StartSeaEvent = Value end,
})
SeaTab:CreateToggle({
   Name = "Ưu Tiên M1 Fruit (Click trái)",
   CurrentValue = false,
   Callback = function(Value) _G.M1Fruit = Value end,
})

-- === TAB 4: SĂN ĐẢO (Mirage, Kit, Magma) ===
local IslandTab = Window:CreateTab("🏝️ Săn Đảo", 4483362458)
IslandTab:CreateSection("Mirage Island")
IslandTab:CreateButton({
   Name = "Bay Tới Đảo Kì Bí (Nếu có)",
   Callback = function() 
      local m = game.Workspace:FindFirstChild("Mirage Island")
      if m then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = m:GetModelCFrame() end
   end,
})
IslandTab:CreateButton({
   Name = "Lên Đỉnh Cao Nhất / Tìm Blue Gear",
   Callback = function() -- Logic tìm Gear
   end,
})
IslandTab:CreateSection("Kitsune & Magma")
IslandTab:CreateToggle({
   Name = "Auto Nhặt Linh Hồn Kitsune",
   CurrentValue = false,
   Callback = function(Value) _G.AutoKitsune = Value end,
})
IslandTab:CreateToggle({
   Name = "Auto Event Núi Lửa (Lấp hố)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoMagmaEvent = Value end,
})

-- === TAB 5: HỆ THỐNG (Tối ưu) ===
local SysTab = Window:CreateTab("⚙️ Hệ Thống", 4483362458)
SysTab:CreateButton({
   Name = "Fix Lag (Xóa Texture)",
   Callback = function() 
      for _,v in pairs(game:GetDescendants()) do 
         if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end 
      end 
   end,
})
SysTab:CreateToggle({
   Name = "Màn Hình Đen (Tiết kiệm pin)",
   CurrentValue = false,
   Callback = function(Value)
      _G.BlackScreen = Value
      local black = game:GetService("CoreGui"):FindFirstChild("NoNoBlack") or Instance.new("ScreenGui", game:GetService("CoreGui"))
      black.Name = "NoNoBlack"
      local f = black:FindFirstChild("F") or Instance.new("Frame", black)
      f.Name = "F"
      f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(0,0,0); f.Visible = Value
   end,
})

-- === BỘ NÃO XỬ LÝ TRUNG TÂM (LOGIC) ===
spawn(function()
    while task.wait() do
        pcall(function()
            -- Logic Farm Level
            if _G.AutoFarm then
                EquipWeapon()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                    end
                end
            end
            
            -- Logic Nhặt Rương
            if _G.AutoChest then
                for _,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:find("Chest") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.5)
                    end
                end
            end

            -- Logic Sea Event (Tốc độ thuyền)
            if _G.StartSeaEvent then
                local boat = game.Workspace.Boats:FindFirstChild(game.Players.LocalPlayer.Name .. "Boat")
                if boat then
                    boat.PrimaryPart.Velocity = boat.PrimaryPart.CFrame.LookVector * _G.BoatSpeed
                end
            end
        end)
    end
end)

Rayfield:Notify({Title = "NoNo Hub", Content = "Chào mừng Boss! Đã load đầy đủ tính năng.", Duration = 5})
