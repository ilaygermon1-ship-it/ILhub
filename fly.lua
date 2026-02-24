-- טעינת ספריית העיצוב Rayfield (Voidware Style)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate",
   LoadingTitle = "טוען ESP ומערכות ראייה...",
   LoadingSubtitle = "W,A,S,D Fly | ESP | Noclip",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ILhub_Configs",
      FileName = "UltimateVisualsConfig"
   }
})

-- יצירת הקטגוריות בצד שמאל
local MainTab = Window:CreateTab("Main", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

-- משתני שליטה
local walkSpeed = 16
local jumpPower = 50
local flySpeed = 50
local flying = false
local noclip = false
local espEnabled = false

--- קטגוריית Visuals (ראיית שחקנים) ---
VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
   Name = "Player ESP (שחקנים באדום + שמות)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(state)
      espEnabled = state
      
      local function createESP(player)
         if player ~= game.Players.LocalPlayer then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ILhub_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            
            local function applyESP()
               if player.Character then
                  highlight.Parent = player.Character
               end
            end
            
            applyESP()
            player.CharacterAdded:Connect(applyESP)
         end
      end

      if espEnabled then
         for _, player in pairs(game.Players:GetPlayers()) do
            createESP(player)
         end
         
         game.Players.PlayerAdded:Connect(function(player)
            if espEnabled then createESP(player) end
         end)
      else
         for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ILhub_Highlight") then
               player.Character.ILhub_Highlight:Destroy()
            end
         end
      end
   end,
})

--- קטגוריית תנועה (W,A,S,D Fly + Speed) ---
MovementTab:CreateSection("Movement Control")

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {0, 3000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if game.Players.LocalPlayer.Character then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MovementTab:CreateToggle({
   Name = "Enable Full Fly (W,A,S,D)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      local char = game.Players.LocalPlayer.Character
      local hrp = char:FindFirstChild("HumanoidRootPart")
      if flying and hrp then
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
   Name = "Fly Speed",
   Range = {0, 3000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) flySpeed = Value end,
})

--- קטגוריית Exploits (Noclip) ---
ExploitsTab:CreateToggle({
   Name = "Noclip",
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
   Title = "ILhub Loaded",
   Content = "כל המערכות פועלות! תהנה מה-ESP.",
   Duration = 5,
})
