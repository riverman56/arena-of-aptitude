local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)
local Otter = require(ReplicatedStorage.Modules.Otter)

local Constants = require(script.Parent.Parent.Constants)

local Gradient = require(script.Parent.Gradient)
local ServerList = require(script.Parent.ServerList)

local SetIsOpen = require(script.Parent.Parent.Actions.SetIsOpen)

local Background = Roact.Component:extend("Background")

function Background:init()
    self.background = Roact.createRef()

    self.transparency, self.updateTransparency = Roact.createBinding(1)
    self.transparencyMotor = Otter.createSingleMotor(1)
    self.transparencyMotor:onStep(self.updateTransparency)

    self.blur, self.updateBlur = Roact.createBinding(0)
    self.blurMotor = Otter.createSingleMotor(0)
    self.blurMotor:onStep(self.updateBlur)

    self.buttonTransparency, self.updateButtonTransparency = Roact.createBinding(1)
    self.buttonTransparencyMotor = Otter.createSingleMotor(1)
    self.buttonTransparencyMotor:onStep(self.updateButtonTransparency)
end

function Background:render()
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BackgroundTransparency = self.transparency,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.214, 0, 0.747, 0),
        [Roact.Ref] = self.background,
    }, {
        Blur = Roact.createElement(Roact.Portal, {
            target = Lighting,
        }, {
            Blur = Roact.createElement("BlurEffect", {
                Size = self.blur,
            })
        }),
        UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 0.597,
        }),
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0.07, 0),
        }),
        Gradient1 = Roact.createElement(Gradient, {
            position = UDim2.new(0.5, 0, 0.137, 0),
            rotation = 90,
            size = UDim2.new(1, 0, 0.097, 0),
            color = Color3.fromRGB(22, 22, 22),
            transparency = self.props.isOpen == true and self.transparency or 1,
        }),
        Gradient2 = Roact.createElement(Gradient, {
            position = UDim2.new(0.5, 0, 0.921, 0),
            rotation = -90,
            size = UDim2.new(1, 0, 0.097, 0),
            color = Color3.fromRGB(22, 22, 22),
            transparency = self.props.isOpen == true and self.transparency or 1,
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
            TextTransparency = self.transparency,
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
            BackgroundTransparency = self.transparency,
            Position = UDim2.new(0.5, 0, 0.031, 0),
            Size = UDim2.new(1, 0, 0.066, 0),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.48, 0),
            }),
            Bottom = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(9, 9, 9),
                BackgroundTransparency = self.transparency,
                BorderSizePixel = 0,
                Position = UDim2.new(0.5, 0, 1.047, 0),
                Size = UDim2.new(1, 0, 0.694, 0),
            }),
        }),
        CloseButton = Roact.createElement("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(163, 75, 75),
            BackgroundTransparency = self.buttonTransparency,
            Position = UDim2.new(0.761, 0, 0.026, 0),
            Size = UDim2.new(0.181, 0, 0.039, 0),
            ZIndex = 2,
            Text = "",
            [Roact.Event.Activated] = self.props.onClose,
            [Roact.Event.MouseEnter] = function()
                if self.props.isOpen == true then
                    self.buttonTransparencyMotor:setGoal(Otter.spring(0.3, Constants.TRANSPARENCY_SPRING_CONFIG))
                end
            end,
            [Roact.Event.MouseLeave] = function()
                if self.props.isOpen == true then
                    self.buttonTransparencyMotor:setGoal(Otter.spring(0, Constants.TRANSPARENCY_SPRING_CONFIG))
                end
            end,
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(1, 0),
            }),
            Text = Roact.createElement("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0.8, 0, 0.8, 0),
                ZIndex = 3,
                Font = Enum.Font.SourceSansBold,
                Text = "CLOSE",
                TextColor3 = Color3.fromRGB(237, 237, 237),
                TextScaled = true,
                TextTransparency = self.transparency,
            })
        }),
        ServerList = Roact.createElement(ServerList),
    })
end

function Background:didUpdate(previousProps)
    if not self.props.isOpen == previousProps.isOpen then
        local transparency = nil
        local blur = nil

        if self.props.isOpen == true then
            transparency = 0
            blur = 56
        elseif self.props.isOpen == false then
            transparency = 1
            blur = 0
        end

        if self.props.isOpen == true then
            self.background:getValue().Visible = true
        end

        self.blurMotor:setGoal(Otter.spring(blur, Constants.BLUR_SPRING_CONFIG))

        self.transparencyMotor:setGoal(Otter.spring(transparency, Constants.TRANSPARENCY_SPRING_CONFIG))
        self.buttonTransparencyMotor:setGoal(Otter.spring(transparency, Constants.TRANSPARENCY_SPRING_CONFIG))

        local disconnect = nil
        
        disconnect = self.transparencyMotor:onComplete(function()
            if self.props.isOpen == false then
                self.background:getValue().Visible = false
            end
            disconnect()
        end)
    end
end

function mapStateToProps(state)
    return {
        isOpen = state.ServerBrowser.isOpen,
        servers = state.Servers,
    }
end

function mapDispatchToProps(dispatch)
    return {
        onClose = function()
            dispatch(SetIsOpen(false))
        end
    }
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Background)