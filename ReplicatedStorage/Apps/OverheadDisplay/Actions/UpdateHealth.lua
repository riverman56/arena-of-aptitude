local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local UpdateHealth = Rodux.makeActionCreator(script.Name, function(health, maxHealth)
    return {
        health = health,
        maxHealth = maxHealth,
    }
end)

return UpdateHealth