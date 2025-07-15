local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LuneGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 240)
frame.Position = UDim2.new(0, 10, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.Text = "_"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
minimizeBtn.TextColor3 = Color3.new(1,1,1)

local luneBtn = Instance.new("TextButton", gui)
luneBtn.Size = UDim2.new(0, 80, 0, 30)
luneBtn.Position = UDim2.new(0, 10, 0.5, -15)
luneBtn.Text = "Lune"
luneBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
luneBtn.TextColor3 = Color3.new(1,1,1)
luneBtn.Visible = false

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    luneBtn.Visible = true
end)

luneBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    luneBtn.Visible = false
end)

local function createButton(name, text, yPos, callback)
    local button = Instance.new("TextButton", frame)
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 18
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.MouseButton1Click:Connect(callback)
    return button
end

local noclipActive = false
local connection
local noclipBtn = createButton("NoClipBtn", "🚪 Noclip: Kapalı", 40, function()
    noclipActive = not noclipActive
    noclipBtn.Text = "🚪 Noclip: " .. (noclipActive and "Açık" or "Kapalı")
    if noclipActive then
        connection = game:GetService("RunService").Stepped:Connect(function()
            local char = player.Character or player.CharacterAdded:Wait()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    elseif connection then
        connection:Disconnect()
    end
end)

createButton("TpBaseBtn", "🏠 Eve Işınlan", 100, function()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == player.Name .. "'s Tycoon" then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local spawn = v:FindFirstChild("Spawn") or v.PrimaryPart
            if spawn and root then
                root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            end
            break
        end
    end
end)

createButton("HitboxBtn", "🎯 Hitbox Büyüt", 160, function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(10,10,10)
                hrp.Transparency = 0.5
                hrp.Material = Enum.Material.ForceField
            end
        end
    end
end)
