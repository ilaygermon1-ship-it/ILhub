local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false

-- הגדרות
local flySpeed = 90
local walkSpeed = 50
local jumpPower = 120
local vehicleSpeed = 150

local control = {f=0,b=0,l=0,r=0,u=0,d=0}
local bv, bg

-- סטטים לשחקן
local function applyMovementStats(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = walkSpeed
    hum.JumpPower = jumpPower

    hum.Seated:Connect(function(active, seat)
        if active and seat then
            seat.MaxSpeed = vehicleSpeed
        end
    end)
end

-- Fly
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    applyMovementStats(char)

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 9e4
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
        if not flying then return end

        local cam = workspace.CurrentCamera
        local move = Vector3.new()

        move = move + (cam.CFrame.LookVector * (control.f - control.b))
        move = move + (cam.CFrame.RightVector * (control.r - control.l))
        move = move + (Vector3.new(0,1,0) * (control.u - control.d))

        bv.Velocity = move * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    RunService:UnbindFromRenderStep("Fly")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- מקשים
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            startFly()
        else
            stopFly()
        end
    end

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

player.CharacterAdded:Connect(function(char)
    flying = false
    stopFly()
    applyMovementStats(char)
end)
