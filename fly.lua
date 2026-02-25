if _G.VoidwareLoaded then 
    return 
end
_G.VoidwareLoaded = true

if not game:IsLoaded() then game.Loaded:Wait() end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Voidware | ILhub Ultimate V9.9",
   LoadingTitle = "Fixing Stability...",
   LoadingSubtitle = "by ilay and liran",
   ConfigurationSaving = { Enabled = true, FolderName = "ILhub_Configs", FileName = "Main" }
})

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flySpeed = 50
local flying = false
local noclip = false
local infJump = false
local espColor = Color3.fromRGB(255, 0, 0)
local espEnabled = false

-- Infinite Jump Logic
UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local function updateESPColor()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("ILhub_ESP") then
            p.Character.ILhub_ESP.FillColor = espColor
        end
    end
end

-- Tabs (סדר הטאבים נשאר כפי שביקשת)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

-- MOVEMENT
MovementTab:CreateSection("Physicals")

MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(state)
      infJump = state
   end,
})

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 1000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end,
})

MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
      if player.Character then 
         player.Character.Humanoid.UseJumpPower = true
         player.Character.Humanoid.JumpPower = v 
      end 
   end,
})

MovementTab:CreateSection("Flight Settings")

MovementTab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) flySpeed = v end,
})

MovementTab:CreateToggle({
   Name = "Fly (W,A,S,D)",
   CurrentValue = false,
   Callback = function(state)
      flying = state
      if flying and player.Character then
         local hrp = player.Character:FindFirstChild("HumanoidRootPart")
         local bv = Instance.new("BodyVelocity", hrp)
         bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera.CFrame
               local dir = Vector3.new(0, 0.1, 0)
               if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector * flySpeed end
               if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector * flySpeed end
               bv.Velocity = dir
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

-- TELEPORT
TeleportTab:CreateSection("Active Players")

local function RefreshTPList()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            TeleportTab:CreateButton({
                Name = "Teleport to: " .. p.Name,
                Callback = function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                        Rayfield:Notify({
                            Title = "Teleported",
                            Content = "Arrived at " .. p.Name,
                            Duration = 2
                        })
                    end
                end,
            })
        end
    end
end
RefreshTPList()

-- VISUALS
VisualsTab:CreateSection("ESP Customization")

VisualsTab:CreateColorPicker({
    Name = "ESP Highlight Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        espColor = Value
        if espEnabled then
            updateESPColor()
        end
    end
})

VisualsTab:CreateToggle({
   Name = "Enable Player ESP",
   CurrentValue = false,
   Callback = function(state)
      espEnabled = state
      if espEnabled then
         for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then 
               local h = p.Character:FindFirstChild("ILhub_ESP") or Instance.new("Highlight", p.Character)
               h.FillColor = espColor
               h.Name = "ILhub_ESP"
               h.Enabled = true
            end
         end
      else
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ILhub_ESP") then 
               p.Character.ILhub_ESP:Destroy() 
            end
         end
      end
   end,
})

-- EXPLOITS
ExploitsTab:CreateSection("Character Mod")
ExploitsTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(state)
      noclip = state
      RunService.Stepped:Connect(function()
         if noclip and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

Rayfield:Notify({
   Title = "Voidware V9.9",
   Content = "Stability Fixed - Script won't auto-close.",
   Duration = 5
})
