local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Pro",
   LoadingTitle = "מפעיל את המערכת...",
   LoadingSubtitle = "Unlimited Power Mode",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ILhub_Configs",
      FileName = "MainConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "voidware",
      RememberJoins = true
   }
})

-- יצירת הקטגוריות בצד שמאל (כמו בתמונה)
local MainTab = Window:CreateTab("Main", 4483362458) -- דף הבית
local MovementTab = Window:CreateTab("Movement", 4483345998) -- תנועה
local AutomationTab = Window:CreateTab("Automation", 4483362458)

-- משתני שליטה
local walkSpeed = 16
local jumpPower = 50
local flySpeed = 50
local flying = false

--- קטגוריית תנועה (Movement) ---

MovementTab:CreateSection("Character Physicals")

-- מהירות ריצה ללא הגבלה
MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {0, 100000}, -- ללא הגבלה מעשית
   Increment = 1,
   Suffix = "Units",
   CurrentValue = 16,
   Flag = "WS_Slider",
   Callback = function(Value)
      walkSpeed = Value
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- גובה קפיצה ללא הגבלה
MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 100000},
   Increment = 1,
   Suffix = "Units",
   CurrentValue = 50,
   Flag = "JP_Slider",
   Callback = function(Value)
      jumpPower = Value
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

MovementTab:CreateSection("Extreme Flying")

-- מהירות תעופה ללא הגבלה
MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 100000},
   Increment = 1,
   Suffix = "Fly V",
   CurrentValue = 50,
   Flag = "Fly_Slider",
   Callback = function(Value)
      flySpeed = Value
   end,
})

-- כפתור הפעלת תעופה
MovementTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(state)
      flying = state
      local char = game.Players.LocalPlayer.Character
      local hrp = char:FindFirstChild("HumanoidRootPart")
      
      if flying and hrp then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "VoidFly"
         bv.Parent = hrp
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0, 0.1, 0)
         
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera.CFrame
               local moveDir = Vector3.new(0, 0.1, 0)
               
               local uis = game:GetService("UserInputService")
               if uis:IsKeyDown(Enum.KeyCode.W) then
                  moveDir = cam.LookVector * flySpeed
               elseif uis:IsKeyDown(Enum.KeyCode.S) then
                  moveDir = cam.LookVector * -flySpeed
               end
               
               bv.Velocity = moveDir
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

--- דף הבית (Main) ---
MainTab:CreateButton({
   Name = "Load External Fly Script",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/ilaygermon1-ship-it/ILhub/refs/heads/main/fly.lua"))()
   end,
})

MainTab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
