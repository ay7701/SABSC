local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "StealABrainrotGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 20, 0.3, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local autoStealActive = false
local autoStealConnection

local function findClosestBrainrot()
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest = nil
    local minDist = math.huge

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local brainPart = obj:FindFirstChild("Brainrot") or (obj.Name == "Brainrot" and obj:FindFirstChildWhichIsA("BasePart"))
            if brainPart then
                local dist = (hrp.Position - brainPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = brainPart
                end
            end
        elseif obj:IsA("BasePart") and obj.Name == "Brainrot" then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = obj
            end
        end
    end

    return closest
end

local hitboxBtn = createButton("🎯 Hitbox Büyüt", 10, function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(10, 10, 10)
                hrp.Transparency = 0.5
                hrp.Material = Enum.Material.ForceField
            end
        end
    end
end)

local autoStealBtn = createButton("🤖 Otomatik Beyin Çalma: Kapalı", 70, function(self)
    autoStealActive = not autoStealActive
    self.Text = "🤖 Otomatik Beyin Çalma: " .. (autoStealActive and "Açık" or "Kapalı")

    if autoStealActive then
        autoStealConnection = runService.Heartbeat:Connect(function()
            local brain = findClosestBrainrot()
            local character = player.Character
            if brain and character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - brain.Position).Magnitude < 60 then
                    hrp.CFrame = CFrame.new(brain.Position + Vector3.new(0, 5, 0))
                end
            end
        end)
    else
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
    end
end)
