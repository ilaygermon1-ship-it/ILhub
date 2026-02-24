local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = false }
})

local player = game.Players.LocalPlayer
local selectedPlayer = ""

-- טאב שיגור
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Select a Player")

local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Choose Target",
   Options = (function()
      local t = {}
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= player then table.insert(t, p.Name) end
      end
      return t
   end)(),
   Callback = function(Option)
      selectedPlayer = type(Option) == "table" and Option[1] or Option
      
      -- כאן אנחנו יוצרים את ה"תמונה" בשיטה שעובדת בטוח
      local target = game.Players:FindFirstChild(selectedPlayer)
      if target then
         local content = game.Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
         
         -- הודעה קופצת עם התמונה (תסתכל בפינה הימנית למטה של המסך כשתלחץ!)
         Rayfield:Notify({
            Title = "Skin Preview: " .. selectedPlayer,
            Content = "You selected " .. selectedPlayer,
            Duration = 5,
            Image = content
         })
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport Now",
   Callback = function()
      local target = game.Players:FindFirstChild(selectedPlayer)
      if target and target.Character then
         player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Refresh List",
   Callback = function()
      local t = {}
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= player then table.insert(t, p.Name) end
      end
      PlayerDropdown:Refresh(t, true)
   end,
})

-- הוספת שאר הטאבים (בקיצור כדי שלא יחסר כלום)
local MovementTab = Window:CreateTab("Movement", 4483345998)
MovementTab:CreateSlider({Name = "Speed", Range = {16, 500}, CurrentValue = 16, Callback = function(v) player.Character.Humanoid.WalkSpeed = v end})
MovementTab:CreateSlider({Name = "Jump", Range = {50, 500}, CurrentValue = 50, Callback = function(v) player.Character.Humanoid.JumpPower = v end})
