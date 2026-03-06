-- בדיקה אם הסקריפט כבר רץ
if _G.VoidwareLoaded then 
    return 
end
_G.VoidwareLoaded = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate V10",
   LoadingTitle = "Anti-Gravity System v2",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhub_Configs", FileName = "Main" }
})

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flySpeed = 50
local flying = false
local noclip = false
local infJump = false
local espColor = Color3.fromRGB(255, 0, 0)
local espEnabled = false

-- Infinite Jump Logic
local jumpConn = UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local function updateESPColor()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("ILhub_ESP") then
            p.Character.ILhub_ESP.FillColor = espColor
        end
    end
end

-- Tabs
local MovementTab = Window:CreateTab("Movement", 4483345998)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

-- MOVEMENT
MovementTab:CreateSection("Physicals")

MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(state) infJump = state end,
})

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end,
})

MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
      if player.Character then 
         player.Character.Humanoid.UseJumpPower = true
         player.Character.Humanoid.JumpPower = v 
      end  
   end,
})

MovementTab:CreateSection("Bypass Fly (No Fall)")

MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) flySpeed = v end,
})

MovementTab:CreateToggle({
   Name = "Anchor Fly (Anti-Gravity)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      local char = player.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      
      if flying and hrp then
         task.spawn(function()
            -- מייצב סיבוב כדי שלא תתהפך
            local bg = Instance.new("BodyGyro", hrp)
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = hrp.CFrame

            while flying and player.Character and hrp do
               local cam = workspace.CurrentCamera.CFrame
               local moveDir = Vector3.new(0,0,0)

               if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
               if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

               hrp.Velocity = Vector3.new(0, 0.1, 0)
               
               if moveDir.Magnitude > 0 then
                  hrp.Anchored = false
                  hrp.CFrame = hrp.CFrame + (moveDir * (flySpeed / 30))
               else
                  -- נועל אותך באוויר כשאתה לא זז כדי למנוע נפילה
                  hrp.Anchored = true
               end
               
               bg.CFrame = cam
               RunService.Heartbeat:Wait()
            end
            if bg then bg:Destroy() end
            if hrp then hrp.Anchored = false end
         end)
      end
   end,
})

-- TELEPORT
TeleportTab:CreateSection("Active Players")

TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        -- פונקציה פשוטה לריענון (בלחיצה היא תוסיף כפתורים חדשים)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                TeleportTab:CreateButton({
                    Name = "TP to: " .. p.DisplayName,
                    Callback = function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                        end
                    end
                })
            end
        end
    end
})

-- VISUALS
VisualsTab:CreateSection("ESP Customization")

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        espColor = Value
        if espEnabled then updateESPColor() end
    end
})

VisualsTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Callback = function(state)
      espEnabled = state
      if espEnabled then
         for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then 
               local h = p.Character:FindFirstChild("ILhub_ESP") or Instance.new("Highlight", p.Character)
               h.FillColor = espColor
               h.Name = "ILhub_ESP"
               h.Enabled = true
            end
         end
      else
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ILhub_ESP") then p.Character.ILhub_ESP:Destroy() end
         end
      end
   end,
})

-- EXPLOITS
ExploitsTab:CreateSection("Character Mod")

ExploitsTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(state)
      noclip = state
      RunService.Stepped:Connect(function()
         if noclip and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

Rayfield:Notify({
   Title = "Voidware V10 Loaded",
   Content = "Anchor Fly & Full Hub Ready!",
   Duration = 5
})
