local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)
local Cryo = require(ReplicatedStorage.Modules.Cryo)

local UpdateHealth = require(script.Parent.Parent.Actions.UpdateHealth)

local initialHealth = {
    health = 100,
    maxHealth = 100,
}

local Health = Rodux.createReducer(initialHealth, {
    [UpdateHealth.name] = function(state, action)
        return Cryo.Dictionary.join(state, action)
    end
})

return Health