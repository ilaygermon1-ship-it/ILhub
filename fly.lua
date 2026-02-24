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

-- משתנים לניהול ה-Fly
local flying = false
local flySpeed = 90
local control = {f=0,b=0,l=0,r=0,u=0,d=0}
local bv, bg
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- פונקציות ה-Fly המקוריות שלך
local function startFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.P = 9e4
    
    RunService:BindToRenderStep("FlyStep", 200, function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        bv.Velocity = ((cam.CFrame.LookVector * (control.f - control.b)) + (cam.CFrame.RightVector * (control.r - control.l)) + (Vector3.new(0,1,0) * (control.u - control.d))).Unit * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    RunService:UnbindFromRenderStep("FlyStep")
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- טאב Player עם הסליידרים החדשים
local PlayerTab = Window:CreateTab("Player", 4483362458)
local Section = PlayerTab:CreateSection("Movement")

-- כפתור Fly בתוך הממשק המעוגל
PlayerTab:CreateToggle({
   Name = "Fly (Press F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      if flying then startFly() else stopFly
