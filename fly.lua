-- בדיקה אם הסקריפט כבר רץ
if _G.VoidwareLoaded then return end
_G.VoidwareLoaded = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate V9.9",
   LoadingTitle = "Fixing Gravity Bug...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhub_Configs", FileName = "Main" }
})

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flySpeed = 50
local flying = false
local infJump = false

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

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

MovementTab:CreateSection("Anti-Gravity Fly")

MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) flySpeed = v end,
})

MovementTab:CreateToggle({
   Name = "Fly (Locked Height)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      local char = player.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      
      if flying and hrp and hum then
         task.spawn(function()
            -- יצירת כוח שנועל אותך במיקום מסוים כדי למנוע נפילה
            local bp = Instance.new("BodyPosition")
            bp.P = 9000 -- עוצמת ה"נעילה"
            bp.D = 750
            bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bp.Position = hrp.Position
            bp.Parent = hrp

            -- איפוס מהירות כדי שהשרת לא ימשוך אותך
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0, 0.1, 0)
            bv.Parent = hrp

            hum.PlatformStand = true 

            while flying and player.Character and hrp do
               local cam = workspace.CurrentCamera.CFrame
               local moveDir = Vector3.new(0,0,0)

               if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
               if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

               if moveDir.Magnitude > 0 then
                  bp.Position = bp.Position + (moveDir * (flySpeed / 25))
               end
               
               hrp.Velocity = Vector3.new(0, 0, 0)
               RunService.Heartbeat:Wait()
            end
            
            -- ניקוי
            bp:Destroy()
            bv:Destroy()
            if hum then hum.PlatformStand = false end
         end)
      end
   end,
})

-- שאר הסקריפט שלך (Teleport וכו')
-- [המשך הקוד המקורי שלך כאן]

Rayfield:Notify({
   Title = "Voidware V9.9",
   Content = "Gravity Fix Applied! Enjoy Flying.",
   Duration = 5
})
