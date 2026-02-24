local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ILhub | Survive Lava",
   LoadingTitle = "ILhub Loading...",
   LoadingSubtitle = "by Ilay",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ILhubConfig",
      FileName = "MainHub"
   }
})

-- טאב לשליטה בדמות
local PlayerTab = Window:CreateTab("Player", 4483362458) -- אייקון של משתמש

local Section = PlayerTab:CreateSection("Movement")

-- כפתור Fly
PlayerTab:CreateToggle({
   Name = "Fly (Press F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      _G.Flying = Value
      if Value then
          -- כאן נכנסת פונקציית התעופה שלך
          print("Fly Enabled")
      else
          print("Fly Disabled")
      end
   end,
})

-- סליידר למהירות
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- סליידר לקפיצה
PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- טאב הגדרות
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

Rayfield:LoadConfiguration()
