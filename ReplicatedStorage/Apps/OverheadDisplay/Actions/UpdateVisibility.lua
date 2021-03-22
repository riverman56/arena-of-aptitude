local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local UpdateVisibility = Rodux.makeActionCreator(script.Name, function(visible)
    return {
        visible = visible,
    }
end)

return UpdateVisibility