if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate",
   LoadingTitle = "Loading All Systems...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhub_Configs", FileName = "Main" }
})

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local selectedPlayer = ""
local flySpeed = 50
local flying = false
local noclip = false

local function getPlayersList()
    local pTable = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then table.insert(pTable, p.Name) end
    end
    return pTable
end

-- טאבים
local MovementTab = Window:CreateTab("Movement", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

-- MOVEMENT
MovementTab:CreateSection("Physicals")
MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 1000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end,
})
MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
      if player.Character then 
         player.Character.Humanoid.UseJumpPower = true
         player.Character.Humanoid.JumpPower = v 
      end 
   end,
})

MovementTab:CreateSection("Fly Controls")
MovementTab:CreateToggle({
   Name = "Fly (W,A,S,D)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      if flying and player.Character then
         local hrp = player.Character:FindFirstChild("HumanoidRootPart")
         local bv = Instance.new("BodyVelocity", hrp)
         bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera.CFrame
               local dir = Vector3.new(0, 0.1, 0)
               if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector * flySpeed end
               bv.Velocity = dir
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})
MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 1000},
   CurrentValue = 50,
   Callback = function(v) flySpeed = v end,
})

-- VISUALS
VisualsTab:CreateToggle({
   Name = "Red ESP Highlight",
   CurrentValue = false,
   Callback = function(state)
      if state then
         for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then 
               local h = Instance.new("Highlight", p.Character)
               h.FillColor = Color3.fromRGB(255,0,0)
               h.Name = "ILhub_ESP"
            end
         end
      else
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ILhub_ESP") then p.Character.ILhub_ESP:Destroy() end
         end
      end
   end,
})

-- TELEPORT (עם תיקון טעינת התמונה)
TeleportTab:CreateSection("Selection")
local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Select Player",
   Options = getPlayersList(),
   Callback = function(opt)
      selectedPlayer = type(opt) == "table" and opt[1] or opt
      local target = game.Players:FindFirstChild(selectedPlayer)
      
      if target then
         -- מנגנון טעינת תמונה בטוח
         task.spawn(function()
            local content, isReady = game.Players:GetUserThumbnailAsync(
               target.UserId, 
               Enum.ThumbnailType.HeadShot, 
               Enum.ThumbnailSize.Size150x150
            )
            
            -- שולח הודעה רק כשהתמונה מוכנה
            Rayfield:Notify({
               Title = "Target: " .. selectedPlayer,
               Content = "Skin loaded! Ready to TP.",
               Image = content,
               Duration = 4
            })
         end)
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport Now",
   Callback = function()
      local target = game.Players:FindFirstChild(selectedPlayer)
      if target and target.Character and player.Character then 
         player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame 
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
      PlayerDropdown:Refresh(getPlayersList(), true)
   end,
})

-- EXPLOITS
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

-- פתיחה/סגירה ב-T
UIS.InputBegan:Connect(function(i, g)
   if not g and i.KeyCode == Enum.KeyCode.T then
      -- Rayfield standard toggle
   end
end)

Rayfield:Notify({
   Title = "ILhub Loaded",
   Content = "Everything is ready! Created by ilay and liran",
   Duration = 5
})
