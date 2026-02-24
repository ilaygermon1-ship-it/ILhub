-- Voidware | ILhub Ultimate V9.1
-- Created by Liran and Ilay IL

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate V9.1",
   LoadingTitle = "By Liran and Ilay IL",
   LoadingSubtitle = "Teleport, Movement & Visuals",
   ConfigurationSaving = { Enabled = false }
})

-- משתנים גלובליים
local flySpeed = 50
local flying = false
local noclip = false
local espEnabled = false

-- יצירת הקטגוריות
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

--- קטגוריית Teleport (שיגור) ---
TeleportTab:CreateSection("Teleport (שיגור לשחקנים בשרת)")

local function UpdateTeleportList()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            -- השם על הכפתור יראה: Display Name (@Username)
            TeleportTab:CreateButton({
                Name = player.DisplayName .. " (@" .. player.Name .. ")",
                Callback = function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                        
                        -- הודעת אישור עם שני השמות כפי שביקשת
                        Rayfield:Notify({
                            Title = "שיגור הצליח", 
                            Content = "שוגרת אל " .. player.DisplayName .. " (@" .. player.Name .. ")", 
                            Duration = 3
                        })
                    end
                end,
            })
        end
    end
end
UpdateTeleportList()

--- קטגוריית Movement (תנועה) ---
MovementTab:CreateSection("מהירות וקפיצה (מוגבל ל-3000)")

MovementTab:CreateSlider({
   Name = "מהירות ריצה (WalkSpeed)",
   Range = {0, 3000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if game.Players.LocalPlayer.Character then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MovementTab:CreateSlider({
   Name = "גובה קפיצה (JumpPower)",
   Range = {0, 3000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if game.Players.LocalPlayer.Character then
         game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

MovementTab:CreateSection("תעופה מתקדמת (W,A,S,D)")

MovementTab:CreateToggle({
   Name = "הפעל תעופה",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      if flying and game.Players.LocalPlayer.Character then
         local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
         local bv = Instance.new("BodyVelocity", hrp)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera.CFrame
               local moveDir = Vector3.new(0, 0.1, 0)
               local uis = game:GetService("UserInputService")
               if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector * flySpeed end
               if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + cam.LookVector * -flySpeed end
               if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + cam.RightVector * -flySpeed end
               if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector * flySpeed end
               bv.Velocity = moveDir
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

MovementTab:CreateSlider({
   Name = "מהירות תעופה",
   Range = {0, 3000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) flySpeed = Value end,
})

--- קטגוריית Visuals (ESP) ---
VisualsTab:CreateSection("ראיית שחקנים")

VisualsTab:CreateToggle({
   Name = "Player Names ESP (שמות וגוף באדום)",
   CurrentValue = false,
   Callback = function(state)
      espEnabled = state
      if espEnabled then
         for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
               local highlight = p.Character:FindFirstChild("ILhub_Highlight") or Instance.new("Highlight")
               highlight.Name = "ILhub_Highlight"; highlight.Parent = p.Character
               highlight.FillColor = Color3.fromRGB(255, 0, 0); highlight.Enabled = true
               if p.Character:FindFirstChild("Humanoid") then
                  p.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Always
                  p.Character.Humanoid.NameDisplayDistance = 10000
               end
            end
         end
      else
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ILhub_Highlight") then p.Character.ILhub_Highlight:Destroy() end
         end
      end
   end,
})

--- קטגוריית Exploits (Noclip) ---
ExploitsTab:CreateSection("מעבר דרך קירות")

ExploitsTab:CreateToggle({
   Name = "לעבור דרך קירות (Noclip)",
   CurrentValue = false,
   Callback = function(state)
      noclip = state
      game:GetService("RunService").Stepped:Connect(function()
         if noclip and game.Players.LocalPlayer.Character then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)
   end,
})

Rayfield:Notify({
   Title = "By Liran and Ilay IL",
   Content = "V9.1 Loaded: Teleport names updated.",
   Duration = 5,
})
