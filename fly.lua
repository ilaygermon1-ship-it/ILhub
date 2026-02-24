-- Ensure the game is loaded
if not game:IsLoaded() then game.Loaded:Wait() end

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate",
   LoadingTitle = "Systems Loading...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ILhub_Configs",
      FileName = "UltimateVisualsConfig"
   }
})

-- Variables
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flying = false
local noclip = false
local espEnabled = false
local flySpeed = 50
local selectedPlayer = ""

-- Helper Function: Get Players List
local function getPlayersList()
    local players = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players, p.Name)
        end
    end
    return players
end

-- TABS
local MovementTab = Window:CreateTab("Movement", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

--- MOVEMENT TAB ---
MovementTab:CreateSection("Character Physicals")

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 1000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.UseJumpPower = true
         player.Character.Humanoid.JumpPower = Value
      end
   end,
})

MovementTab:CreateSection("Fly Controls")

MovementTab:CreateToggle({
   Name = "Enable Fly (W,A,S,D)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      local char = player.Character
      local hrp = char:FindFirstChild("HumanoidRootPart")
      if flying and hrp then
         local bv = Instance.new("BodyVelocity", hrp)
         bv.Name = "FlyVelocity"
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera.CFrame
               local moveDir = Vector3.new(0, 0.1, 0)
               if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + cam.LookVector * -flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + cam.RightVector * -flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector * flySpeed end
               bv.Velocity = moveDir
               task.wait()
            end
            if bv then bv:Destroy() end
         end)
      end
   end,
})

MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) flySpeed = Value end,
})

--- VISUALS TAB (ESP) ---
VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
   Name = "Red Highlight ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(state)
      espEnabled = state
      local function createESP(p)
         if p ~= player then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ILhub_Highlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            local function apply() if p.Character then highlight.Parent = p.Character end end
            apply()
            p.CharacterAdded:Connect(apply)
         end
      end

      if espEnabled then
         for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
      else
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ILhub_Highlight") then
               p.Character.ILhub_Highlight:Destroy()
            end
         end
      end
   end,
})

--- TELEPORT TAB (With Image Preview) ---
TeleportTab:CreateSection("Teleport Menu")

local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Select Target Player",
   Options = getPlayersList(),
   CurrentOption = {""},
   Callback = function(Options)
      selectedPlayer = type(Options) == "table" and Options[1] or Options
      
      -- הצגת תמונה של השחקן שנבחר
      if selectedPlayer ~= "" and selectedPlayer ~= nil then
         local target = game.Players:FindFirstChild(selectedPlayer)
         if target then
            -- מושך את תמונת הראש של השחקן
            local content, isReady = game.Players:GetUserThumbnailAsync(
                target.UserId, 
                Enum.ThumbnailType.HeadShot, 
                Enum.ThumbnailSize.Size150x150
            )
            
            -- שולח התראה עם התמונה של השחקן
            Rayfield:Notify({
               Title = "Target: " .. selectedPlayer,
               Content = "Profile loaded. You can now teleport.",
               Duration = 4,
               Image = content -- כאן מופיעה התמונה!
            })
         end
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
      PlayerDropdown:Refresh(getPlayersList(), true)
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport Now",
   Callback = function()
      if selectedPlayer ~= "" then
         local target = game.Players:FindFirstChild(selectedPlayer)
         if target and target.Character and player.Character then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Success", Content = "Teleported to " .. selectedPlayer, Duration = 2})
         end
      else
         Rayfield:Notify({Title = "Error", Content = "Select a player first!", Duration = 3})
      end
   end,
})

--- EXPLOITS TAB ---
ExploitsTab:CreateSection("Special Abilities")

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

-- UI Toggle Key (T)
local ui_open = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.T then
        ui_open = not ui_open
        if ui_open then Window:Open() else Window:Close() end
    end
end)

Rayfield:Notify({
   Title = "ILhub Loaded Successfully",
   Content = "Teleport with images and all features ready!",
   Duration = 5,
})
