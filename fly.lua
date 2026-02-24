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
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
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

local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      if flying then startFly() else stopFly() end
   end,
})

PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 1000},
   Increment = 1,
   CurrentValue = 100,
   Callback = function(Value) flySpeed = Value end,
})

PlayerTab:CreateSlider({
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

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
          player.Character.Humanoid.UseJumpPower = true
          player.Character.Humanoid.JumpPower = Value
      end
   end,
})

local ui_open = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.T then
        ui_open = not ui_open
        if ui_open then Window:Open() else Window:Close() end
    end
end)
