-- ILhub Ultimate - Full Combined Script
if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate",
   LoadingTitle = "Loading All Systems...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhub_Configs", FileName = "Main" }
})

-- משתנים גלובליים
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local selectedPlayer = ""
local flySpeed = 50
local flying = false
local noclip = false

-- פונקציה לעדכון רשימת השחקנים
local function getPlayersList()
    local pTable = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then table.insert(pTable, p.Name) end
    end
    return pTable
end

-- יצירת טאבים
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

MovementTab:CreateSection("Flight")
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

--- VISUALS TAB ---
VisualsTab:CreateSection("ESP Settings")
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

--- TELEPORT TAB (With Skin Preview Fix) ---
TeleportTab:CreateSection("Teleport Menu")

-- תווית סטטוס כדי לראות מי נבחר בתוך התפריט
local StatusLabel = TeleportTab:CreateLabel("Selected Player: None")

local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Choose Player",
   Options = getPlayersList(),
   Callback = function(Option)
      selectedPlayer = type(Option) == "table" and Option[1] or Option
      StatusLabel:Set("Selected: " .. selectedPlayer .. " (Loading Skin...)")
      
      local target = game.Players:FindFirstChild(selectedPlayer)
      if target then
         task.spawn(function()
            -- משיכת תמונת הסקין מהשרתים של רובלוקס
            local content, isReady = game.Players:GetUserThumbnailAsync(
               target.UserId, 
               Enum.ThumbnailType.HeadShot, 
               Enum.ThumbnailSize.Size420x420
            )
            
            -- שליחת ההתראה עם התמונה (תסתכל בפינת המסך!)
            Rayfield:Notify({
               Title = "Skin Loaded: " .. selectedPlayer,
               Content = "Teleport is ready.",
               Image = content,
               Duration = 4
            })
            StatusLabel:Set("Selected: " .. selectedPlayer .. " (Ready)")
         end)
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Selected",
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
      Rayfield:Notify({Title = "System", Content = "Player list updated", Duration = 2})
   end,
})

--- EXPLOITS TAB ---
ExploitsTab:CreateSection("Abilities")
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

-- הודעת פתיחה
Rayfield:Notify({
   Title = "ILhub V2 Loaded",
   Content = "Toggle Menu with 'T' (if binded) or use the UI.",
   Duration = 5
})
