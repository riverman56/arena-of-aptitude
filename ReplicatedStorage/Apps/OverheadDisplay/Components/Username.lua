local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)
local Otter = require(ReplicatedStorage.Modules.Otter)

local Constants = require(script.Parent.Parent.Constants)

local Username = Roact.Component:extend("Username")

function Username:init()
    self.transparency, self.updateTransparency = Roact.createBinding(0.2)
    self.transparencyMotor = Otter.createSingleMotor(0.2)
    self.transparencyMotor:onStep(self.updateTransparency)
end

function Username:render()
    return Roact.createElement("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.2, 0),
        Size = UDim2.new(1, 0, 0.4, 0),
        Font = Enum.Font.SourceSans,
        Text = self.props.username,
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        TextTransparency = self.transparency,
    })
end

function Username:didUpdate()
    if self.props.visible == true then
        self.transparencyMotor:setGoal(Otter.spring(0.2, Constants.VISIBILITY_SPRING_CONFIG))
    elseif self.props.visible == false then
        self.transparencyMotor:setGoal(Otter.spring(1, Constants.VISIBILITY_SPRING_CONFIG))
    end
end

function mapStateToProps(state)
    return {
        visible = state.Visibility.visible
    }
end

return RoactRodux.connect(mapStateToProps)(Username)