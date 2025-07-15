local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SafeModGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0, 30, 0.4, -70)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

local function createButton(text, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 45)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 17
	btn.Font = Enum.Font.SourceSansBold
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Diğer oyunculara godmode
local antiDamage = false
local godloop

local function toggleEnemyFreeze()
	antiDamage = not antiDamage
	if antiDamage then
		godloop = runService.Stepped:Connect(function()
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						hum.AutoRotate = false
						hum.PlatformStand = true
					end
				end
			end
		end)
	else
		if godloop then
			godloop:Disconnect()
			godloop = nil
		end
	end
end

-- Kafa büyüt
local function enlargeHeads()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			if head then
				head.Size = Vector3.new(5,5,5)
				head.Transparency = 0.5
				head.Material = Enum.Material.ForceField
				local mesh = head:FindFirstChildWhichIsA("SpecialMesh")
				if mesh then mesh:Destroy() end
			end
		end
	end
end

createButton("🧠 Kafaları Büyüt", 10, enlargeHeads)
createButton("🛡 Düşmanları Kitle (Aç/Kapa)", 65, toggleEnemyFreeze)
