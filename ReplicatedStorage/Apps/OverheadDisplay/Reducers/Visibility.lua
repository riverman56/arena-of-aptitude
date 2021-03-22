local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)
local Cryo = require(ReplicatedStorage.Modules.Cryo)

local UpdateVisibility = require(script.Parent.Parent.Actions.UpdateVisibility)

local initialVisibility = {
    visible = true,
}

local Visibility = Rodux.createReducer(initialVisibility, {
    [UpdateVisibility.name] = function(state, action)
        return Cryo.Dictionary.join(state, action)
    end
})

return Visibility