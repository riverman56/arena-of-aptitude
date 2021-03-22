local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)

local Gradient = require(script.Parent.Gradient)
local ServerList = require(script.Parent.ServerList)

local Background = Roact.Component:extend("Background")

function Background:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.214, 0, 0.747, 0),
    }, {
        UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 0.597,
        }),
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0.07, 0),
        }),
        Gradient1 = Roact.createElement(Gradient, {
            position = UDim2.new(0.5, 0, 0.137, 0),
            rotation = 90,
        }),
        Gradient2 = Roact.createElement(Gradient, {
            position = UDim2.new(0.5, 0, 0.921, 0),
            rotation = -90,
        }),
        Title = Roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.295, 0, 0.045, 0),
            Size = UDim2.new(0.483, 0, 0.053, 0),
            Font = Enum.Font.SourceSansBold,
            Text = "Server List",
            TextColor3 = Color3.fromRGB(235, 235, 235),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            UIGradient = Roact.createElement("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0.131),
                }),
            }),
        }),
        Topbar = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(9, 9, 9),
            Position = UDim2.new(0.5, 0, 0.031, 0),
            Size = UDim2.new(1, 0, 0.066, 0),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.48, 0),
            }),
            Bottom = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(9, 9, 9),
                Position = UDim2.new(0.5, 0, 1.047, 0),
                Size = UDim2.new(1, 0, 0.694, 0),
            }),
        }),
        ServerList = Roact.createElement(ServerList),
    })
end

function mapStateToProps(state)
    return {
        servers = state.Servers,
    }
end

return RoactRodux.connect(mapStateToProps)(Background)