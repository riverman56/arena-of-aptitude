local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)

local Gradient = Roact.Component:extend("Gradient")

function Gradient:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        Position = self.props.position,
        Size = UDim2.new(1, 0, 0.097, 0),
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