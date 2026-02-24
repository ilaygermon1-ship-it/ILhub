local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local flying = false
local flySpeed = 90
local walkSpeed = 50
local jumpPower = 120
local control = {f=0,b=0,l=0,r=0,u=0,d=0}
local bv, bg

-- יצירת הלוח (GUI)
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ILhubMenu"

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 220, 0, 280) -- הגדלתי את הלוח שיהיה מקום
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local function makeBtn(text, posY, color, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- כפתור תעופה
local flyBtn = makeBtn("Toggle Fly (F)", 40, Color3.fromRGB(100, 20, 20), function()
    flying = not flying
    if flying then startFly() else stopFly() end
end)

-- כפתור מהירות מקסימלית
makeBtn("Max Speed", 85, Color3.fromRGB(50, 50, 150), function()
    player.Character.Humanoid.WalkSpeed = 150
    flySpeed = 150
end)

-- כפתור קפיצה גבוהה
makeBtn("Super Jump", 130, Color3.fromRGB(50, 150, 50), function()
    player.Character.Humanoid.JumpPower = 200
end)

-- כפתור איפוס
makeBtn("Reset Stats", 175, Color3.fromRGB(80, 80, 80), function()
    player.Character.Humanoid.WalkSpeed = 16
    player.Character.Humanoid.JumpPower = 50
    flySpeed = 90
end)

-- כפתור סגירת תפריט
makeBtn("Close Menu", 225, Color3.fromRGB(150, 50, 50), function()
    ScreenGui:Destroy()
end)

-- פונקציות תעופה (נשארות אותו דבר)
function startFly()
    local hrp = player.Character:WaitForChild("HumanoidRootPart")
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

function stopFly()
    RunService:UnbindFromRenderStep("Fly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- שליטה במקלדת (W,A,S,D וכו') - להשאיר מהקוד הקודם
