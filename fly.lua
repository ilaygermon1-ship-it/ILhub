-- Ensure the game is loaded
if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Creation
local Window = Rayfield:CreateWindow({
   Name = "ILhub | Multi-Tool",
   LoadingTitle = "ILhub Loading...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = false }
})

-- Variables
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flying = false
local noclip = false
local flySpeed = 100
local bv, bg

-- Noclip Logic
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly Functions
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
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction -
