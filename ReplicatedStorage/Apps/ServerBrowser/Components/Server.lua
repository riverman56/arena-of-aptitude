local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local Server = Roact.Component:extend("Server")

function Server:render()
    return Roact.createElement()
end

return Server