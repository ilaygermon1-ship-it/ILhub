-- ניקוי משתנים קודמים כדי לוודא שהסקריפט ייפתח
_G.VoidwareLoaded = nil 

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

-- Tabs
local MovementTab = Window:CreateTab("Movement", 4483345998)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local ExploitsTab = Window:CreateTab("Exploits", 4483362458)

--- MOVEMENT ---
MovementTab:CreateSection("Physicals")
MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(state) infJump = state end,
})

MovementTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end,
})

MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) 
      if player.Character then 
         player.Character.Humanoid.UseJumpPower = true
         player.Character.Humanoid.JumpPower = v 
      end  
   end,
})

--- TELEPORT ---
TeleportTab:CreateSection("Active Players")
TeleportTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        -- פונקציה לריענון הרשימה במידה ושחקנים הצטרפו
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                TeleportTab:CreateButton({
                    Name = "TP to: " .. p.DisplayName,
                    Callback = function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                        end
                    end
                })
            end
        end
    end
})

--- VISUALS ---
VisualsTab:CreateSection("ESP")
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

--- EXPLOITS ---
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

-- היעלמות בטוחה ללא שגיאות
ExploitsTab:CreateButton({
    Name = "Invisibility (English)",
    Callback = function()
        local char = player.Character
        if char then
            pcall(function()
                -- שיטה שעובדת על רוב סוגי השחקנים
                local rootJoint = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("RootJoint")
                if rootJoint then
                    rootJoint:Destroy()
                    Rayfield:Notify({Title = "Invisibility", Content = "You are now invisible! Reset to undo.", Duration = 4})
                else
                    -- ניסיון לשיטת R15
                    local lowerTorsoRoot = char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("Root")
                    if lowerTorsoRoot then
                        lowerTorsoRoot:Destroy()
                        Rayfield:Notify({Title = "Invisibility", Content = "Invisible mode active.", Duration = 4})
                    end
                end
            end)
        end
    end,
})

Rayfield:Notify({
   Title = "Voidware V9.9",
   Content = "Script Loaded Successfully!",
   Duration = 5
})
