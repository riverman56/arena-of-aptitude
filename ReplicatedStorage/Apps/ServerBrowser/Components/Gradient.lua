--[[
    creates a gradient frame with specified position, gradient rotation, size, and color
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local Gradient = Roact.Component:extend("Gradient")

function Gradient:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.props.color,
        BackgroundTransparency = self.props.transparency,
        BorderSizePixel = 0,
        Position = self.props.position,
        Size = self.props.size,
    }, {
        UIGradient = Roact.createElement("UIGradient", {
            Rotation = self.props.rotation,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })
    })
end

return Gradient