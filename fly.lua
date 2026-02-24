local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- יצירת החלון
local Window = Rayfield:CreateWindow({
   Name = "ILhub | Survive Lava",
   LoadingTitle = "ILhub Loading...",
   LoadingSubtitle = "by Ilay",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhubConfig", FileName = "MainHub" }
})

-- משתני מערכת
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flying = false
local flySpeed = 100
local bv, bg

-- יצירת כפתור צף (Mobile/Floating Button)
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ILhubFloating"

local FloatingBtn = Instance.new("TextButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 60, 0, 60)
FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingBtn.Text = "FLY"
FloatingBtn.TextColor3 = Color3.new(1, 1, 1)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 14

-- עיגול הפינות של הכפתור
local UICorner = Instance.new("UICorner", FloatingBtn)
UICorner.CornerRadius = UDim.new(1, 0) -- הופך אותו לעיגול

-- אפשרות להזיז את הכפתור הצף
FloatingBtn.Active = true
FloatingBtn.Draggable = true

-- פונקציות Fly
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

-- פונקציה לשינוי מצב Fly (לשימוש בכפתור הצף וב-Toggle)
local function toggleFly(state)
    flying = state
    if flying then
        FloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- ירוק כשהוא עובד
        startFly()
    else
        FloatingBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- אדום כשהוא כבוי
        stopFly()
    end
end

-- חיבור הכפתור הצף
FloatingBtn.MouseButton1Click:Connect(function()
    toggleFly(not flying)
end)

-- בניית התפריט ב-Rayfield
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      toggleFly(Value)
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

-- פתיחה/סגירה של
