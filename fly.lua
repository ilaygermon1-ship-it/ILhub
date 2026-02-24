local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- יצירת החלון הראשי
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

-- משתני תעופה
local flying = false
local flySpeed = 100
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local bv, bg

-- פונקציות ה-Fly
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    RunService:BindToRenderStep("FlyLoop", 200, function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local direction = Vector3.zero
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
        
        bv.Velocity = direction.Unit * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    RunService:UnbindFromRenderStep("FlyLoop")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- טאב Player
local PlayerTab = Window:CreateTab("Player", 4483362458)
local Section = PlayerTab:CreateSection("Movement Controls")

-- כפתור Fly
PlayerTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      if flying then 
          startFly() 
      else 
          stopFly() 
      end
   end,
})

-- סליידר מהירות תעופה
PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 1000},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 100,
   Flag = "FlySpeed",
   Callback = function(Value)
      flySpeed = Value
   end,
})

-- סליידר מהירות ריצה (WalkSpeed)
PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 1000},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
          player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- סליידר עוצמת קפיצה (JumpPower)
PlayerTab:CreateSlider({
