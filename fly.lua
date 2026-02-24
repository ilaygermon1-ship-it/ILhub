local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- יצירת החלון
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

-- משתנה לשמירת מצב התפריט (פתוח/סגור)
local ui_open = true

-- פונקציה להצגה והסתרה
local function toggleUI()
    ui_open = not ui_open
    if ui_open then
        Window:Open() -- פותח את התפריט
    else
        Window:Close() -- סוגר את התפריט
    end
end

-- זיהוי לחיצה על המקש T
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.T then
        toggleUI()
    end
end)

-- יצירת טאב Player
local PlayerTab = Window:CreateTab("Player", 4483362458)

local Section = PlayerTab:CreateSection("Movement")

-- כפתור תעופה (Fly)
PlayerTab:CreateToggle({
   Name = "Fly (Press F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      _G.Flying = Value
      -- כאן תוכל להוסיף את לוגיקת התעופה שרצית
      if Value then print("Fly On") else print("Fly Off") end
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

-- הודעה למשתמש
Rayfield:Notify({
   Title = "ILhub Loaded!",
   Content = "Press 'T' to Hide/Show the Menu",
   Duration = 5,
   Image = 4483362458,
})
