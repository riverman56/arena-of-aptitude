local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)
local Otter = require(ReplicatedStorage.Modules.Otter)

local Constants = require(script.Parent.Parent.Constants)

local lerpCIELUV = require(script.Parent.Parent.Helpers.lerpCIELUV)

local HealthDisplay = Roact.Component:extend("HealthDisplay")

local GREEN = Color3.fromRGB(115, 234, 113)
local RED = Color3.fromRGB(182, 60, 70)

function HealthDisplay:init()
    local color = lerpCIELUV(GREEN, RED, 1 - (self.props.health / self.props.maxHealth))

    self.health, self.updateHealth = Roact.createBinding(self.props.health)
    self.healthMotor = Otter.createSingleMotor(self.props.health)
    self.healthMotor:onStep(self.updateHealth)

    self.healthColorR, self.updateHealthColorR = Roact.createBinding(color.R)
    self.healthColorRMotor = Otter.createSingleMotor(lerpCIELUV(GREEN, RED, 1 - (self.props.health / self.props.maxHealth)).R)
    self.healthColorRMotor:onStep(self.updateHealthColorR)

    self.healthColorG, self.updateHealthColorG = Roact.createBinding(color.G)
    self.healthColorGMotor = Otter.createSingleMotor(lerpCIELUV(GREEN, RED, 1 - (self.props.health / self.props.maxHealth)).G)
    self.healthColorGMotor:onStep(self.updateHealthColorG)

    self.healthColorB, self.updateHealthColorB = Roact.createBinding(color.B)
    self.healthColorBMotor = Otter.createSingleMotor(lerpCIELUV(GREEN, RED, 1 - (self.props.health / self.props.maxHealth)).B)
    self.healthColorBMotor:onStep(self.updateHealthColorB)

    self.transparency, self.updateTransparency = Roact.createBinding(0)
    self.transparencyMotor = Otter.createSingleMotor(0)
    self.transparencyMotor:onStep(self.updateTransparency)

    self.health = self.health:map(function(health)
        return UDim2.new(health / self.props.maxHealth, 0, 1, 0)
    end)

    self.healthColor = Roact.joinBindings({self.healthColorR, self.healthColorG, self.healthColorB}):map(function(colors)
        return Color3.new(colors[1], colors[2], colors[3])
    end)
end

function HealthDisplay:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.6, 0),
        Size = UDim2.new(0.8, 0, 0.1, 0),
    }, {
        Health = Roact.createElement("Frame", {
            BackgroundTransparency = self.transparency,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = self.healthColor,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = self.health,
            ZIndex = 2,

        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
            })
        }),
        Background = Roact.createElement("Frame", {
            BackgroundTransparency = self.transparency,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(36, 36, 36),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
            })
        })
    })
end

function HealthDisplay:didUpdate()
    local color = lerpCIELUV(GREEN, RED, 1 - (self.props.health / self.props.maxHealth))

    self.healthMotor:setGoal(Otter.spring(self.props.health, Constants.HEALTHBAR_SPRING_CONFIG))

    self.healthColorRMotor:setGoal(Otter.spring(color.R, Constants.HEALTHBAR_SPRING_CONFIG))
    self.healthColorGMotor:setGoal(Otter.spring(color.G, Constants.HEALTHBAR_SPRING_CONFIG))
    self.healthColorBMotor:setGoal(Otter.spring(color.B, Constants.HEALTHBAR_SPRING_CONFIG))

    if self.props.visible == true then
        self.transparencyMotor:setGoal(Otter.spring(0, Constants.VISIBILITY_SPRING_CONFIG))
    elseif self.props.visible == false then
        self.transparencyMotor:setGoal(Otter.spring(1, Constants.VISIBILITY_SPRING_CONFIG))
    end
end

local function mapStateToProps(state)
    return {
        visible = state.Visibility.visible,
        health = state.Health.health,
        maxHealth = state.Health.maxHealth,
    }
end

return RoactRodux.connect(mapStateToProps)(HealthDisplay)