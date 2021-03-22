local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local Attachment = Roact.Component:extend("Attachment")

function Attachment:render()
    return Roact.createElement("Attachment", {
        Position = self.props.position,
    })
end

return Attachment