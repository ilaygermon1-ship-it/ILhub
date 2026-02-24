local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- הגדרות
local flying = false
local flySpeed = 90
local control = {f=0,b=0,l=0,r=0,u=0,d=0}
local bv, bg

-- יצירת הלוח (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true -- שתוכל להזיז את הלוח
frame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ILhub Fly Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Parent = frame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 180, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 50)
flyBtn.Text = "Toggle Fly (F)"
flyBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Parent = frame

-- פונקציות תעופה
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 9e4
    
    RunService:BindToRenderStep("Fly", 200, function()
        local cam = workspace.CurrentCamera
        bv.Velocity = ((cam.CFrame.LookVector * (control.f - control.b)) + (cam.CFrame.RightVector * (control.r - control.l)) + (Vector3.new(0,1,0) * (control.u - control.d))).Unit * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    RunService:UnbindFromRenderStep("Fly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then 
        flyBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 20)
        startFly() 
    else 
        flyBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
        stopFly() 
    end
end)

-- שליטה במקלדת
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then flyBtn.Text = "Toggle Fly (F)"; flying = not flying; if flying then startFly() else stopFly() end end
    if input.KeyCode == Enum.KeyCode.W then control.f = 1 end
    if input.KeyCode == Enum.KeyCode.S then control.b = 1 end
    if input.KeyCode == Enum.KeyCode.A then control.l = 1 end
    if input.KeyCode == Enum.KeyCode.D then control.r = 1 end
    if input.KeyCode == Enum.KeyCode.Space then control.u = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then control.d = 1 end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then control.f = 0 end
    if input.KeyCode == Enum.KeyCode.S then control.b = 0 end
    if input.KeyCode == Enum.KeyCode.A then control.l = 0 end
    if input.KeyCode == Enum.KeyCode.D then control.r = 0 end
    if input.KeyCode == Enum.KeyCode.Space then control.u = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then control.d = 0 end
end)
