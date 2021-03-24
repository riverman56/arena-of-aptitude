local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Modules.Rodux)

local SetIsOpen = Rodux.makeActionCreator(script.Name, function(open: boolean)
    return {
        isOpen = open,
    }
end)

return SetIsOpen