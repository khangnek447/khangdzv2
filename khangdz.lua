local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "khangdzv1",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "BloxFruitsConfig"
})

local autoFarmEnabled = false
local antiBanEnabled = true -- Anti-Ban mặc định bật

local function getNearestEnemy()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local nearestEnemy = nil
    local shortestDistance = math.huge

    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local distance = (npc.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = npc
            end
        end
    end
    return nearestEnemy
end

local function detectAntiCheat()
    local suspicious = false

    if game.Workspace:FindFirstChild("AntiCheat") then
        print("[WARNING] Anti-Cheat Detected!")
        suspicious = true
    end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if character and character.HumanoidRootPart.Velocity.Magnitude > 100 then
        print("[WARNING] Unusual movement detected!")
        suspicious = true
    end

    return suspicious
end

local function autoFarm()
    while autoFarmEnabled do
        -- Kiểm tra Anti-Ban
        if antiBanEnabled and detectAntiCheat() then
            print("[ANTI-BAN] Stopping Auto Farm for safety.")
            autoFarmEnabled = false
            break
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local enemy = getNearestEnemy()

        if enemy then

            character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
            wait(0.5)

            game:GetService("ReplicatedStorage").Remotes.Combat:FireServer("Attack")
        end

        wait(1.5) -- Tăng khoảng cách giữa các hành động
    end
end

local farmingTab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

farmingTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(value)
        autoFarmEnabled = value
        if autoFarmEnabled then
            autoFarm()
        end
    end
})

farmingTab:AddToggle({
    Name = "Enable Anti-Ban",
    Default = true,
    Callback = function(value)
        antiBanEnabled = value
        print("Anti-Ban status:", antiBanEnabled)
    end
})

OrionLib:Init()