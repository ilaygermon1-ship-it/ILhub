local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Creation
local Window = Rayfield:CreateWindow({
   Name = "ILhub | Survive Lava",
   LoadingTitle = "ILhub Loading...",
   LoadingSubtitle = "by Ilay",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhubConfig", FileName = "MainHub" }
})

-- Variables
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flying = false
local flySpeed = 100
local bv, bg

-- Floating Toggle Button (Mobile Friendly)
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ILhubFloating"

local FloatingBtn = Instance.new("TextButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 60, 0, 60)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingBtn.Text = "FLY"
FloatingBtn.TextColor3 = Color3.new(1, 1, 1)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 14
local UICorner = Instance.new("UICorner", FloatingBtn)
UICorner.CornerRadius = UDim.new(1, 0)
FloatingBtn.Draggable = true
FloatingBtn.Active = true

-- Fly Logic
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P =
