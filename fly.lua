-- Essential check
if not game:IsLoaded() then game.Loaded:Wait() end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then return end

local Window = Rayfield:CreateWindow({
   Name = "ILhub | Mobile Friendly",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Ilay",
   ConfigurationSaving = { Enabled = false }
})

local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 1000},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(V) 
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V 
   end,
})

Rayfield:Notify({
   Title = "Loaded!",
   Content = "If you see this, the script works!",
   Duration = 5
})
