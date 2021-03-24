local RunService = game:GetService("RunService")

local REGEN_RATE = 1

local character = script.Parent
local humanoid = character:WaitForChild'Humanoid'

RunService.Heartbeat:Connect(function(dt)
    local amount = REGEN_RATE * dt
    humanoid.Health += math.clamp(amount, 0, humanoid.MaxHealth)
end)