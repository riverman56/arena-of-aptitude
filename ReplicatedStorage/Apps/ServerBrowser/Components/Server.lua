--[[
    props

    @region
    @playerCount
    @jobId
    @userIds
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local Roact = require(ReplicatedStorage.Modules.Roact)
local RoactRodux = require(ReplicatedStorage.Modules.RoactRodux)
local Otter = require(ReplicatedStorage.Modules.Otter)
local retry = require(ReplicatedStorage.Utility.retry)

local Constants = require(script.Parent.Parent.Constants)

local Gradient = require(script.Parent.Gradient)

local SetIsOpen = require(script.Parent.Parent.Actions.SetIsOpen)

local Server = Roact.Component:extend("Server")

function Server:init()
    self.debounce = false

    self.canvasPosition, self.updateCanvasPosition = Roact.createBinding(0)
    self.canvasPositionMotor = Otter.createSingleMotor(0)
    self.canvasPositionMotor:onStep(self.updateCanvasPosition)

    self.transparency, self.updateTransparency = Roact.createBinding(1)
    self.transparencyMotor = Otter.createSingleMotor(1)
    self.transparencyMotor:onStep(self.updateTransparency)

    self.playButtonTransparency, self.updatePlayButtonTransparency = Roact.createBinding(1)
    self.playButtonTransparencyMotor = Otter.createSingleMotor(1)
    self.playButtonTransparencyMotor:onStep(self.updatePlayButtonTransparency)

    self.canvasPosition:map(function(position)
        return Vector2.new(position, 0)
    end)

    self.canvasSize, self.updateCanvasSize = Roact.createBinding(0)

    self.canvasSize = self.canvasSize:map(function(size)
        return UDim2.new(0, size, 0, 0)
    end)

    self.canvasPosition = self.canvasPosition:map(function(position)
        return Vector2.new(position, 0)
    end)
end

function Server:render()
    local colors = table.create(2)

    local playerScrollerChildren = table.create(#self.props.userIds)

    local listLayout = Roact.createElement("UIListLayout", {
        Padding = UDim.new(0, 1),
        FillDirection = Enum.FillDirection.Horizontal,
        [Roact.Change.AbsoluteContentSize] = function(instance)
            self.updateCanvasSize(instance.AbsoluteContentSize.X)
        end,
    })

    table.insert(playerScrollerChildren, listLayout)

    for _, userId in pairs(self.props.userIds) do
        local image, setImage = Roact.createBinding("")

        local element = Roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Image = image,
            ImageTransparency = self.transparency,
        }, {
            UIScale = Roact.createElement("UIScale", {
                Scale = workspace.CurrentCamera.ViewportSize.X / 1085,
            }),
        })

        coroutine.wrap(function()
            local thumbnail = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            setImage(thumbnail)
        end)()

        table.insert(playerScrollerChildren, element)
    end

    if self.props.jobId == game.JobId then
        colors = {
            [1] = Color3.fromRGB(89, 88, 90),
            [2] = Color3.fromRGB(62, 62, 63),
        }
    else
        colors = {
            [1] = Color3.fromRGB(127, 248, 97),
            [2] = Color3.fromRGB(98, 158, 90),
        }
    end

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = self.transparency,
        Size = UDim2.new(0, 197, 0, 50),
        LayoutOrder = self.props.layoutOrder,
    }, {
        UIScale = Roact.createElement("UIScale", {
            Scale = workspace.CurrentCamera.ViewportSize.X / 1085,
        }),
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0.1, 0),
        }),
        Gradient1 = Roact.createElement(Gradient, {
            color = Color3.fromRGB(9, 9, 9),
            rotation = 0,
            position = UDim2.new(0.065, 0, 0.697, 0),
            size = UDim2.new(0.051, 0, 0.342, 0),
            transparency = self.props.isOpen == true and self.transparency or 1,
        }),
        Gradient2 = Roact.createElement(Gradient, {
            color = Color3.fromRGB(9, 9, 9),
            rotation = 180,
            position = UDim2.new(0.488, 0, 0.697, 0),
            size = UDim2.new(0.159, 0, 0.342, 0),
            transparency = self.props.isOpen == true and self.transparency or 1,
        }),
        Icon = Roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.099, 0, 0.274, 0),
            Size = UDim2.new(0.076, 0, 0.24, 0),
            Image = "rbxassetid://6546977371",
            ImageTransparency = self.transparency,
        }),
        Region = Roact.createElement("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.504, 0, 0.265, 0),
            Size = UDim2.new(0.657, 0, 0.306, 0),
            Font = Enum.Font.SourceSansSemibold,
            Text = self.props.region,
            TextColor3 = Color3.fromRGB(246, 246, 246),
            TextScaled = true,
            TextTransparency = self.transparency,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
        PlayerCount = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = self.transparency,
            Position = UDim2.new(0.902, 0, 0.274, 0),
            Size = UDim2.new(0.093, 0, 0.288, 0),
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.2, 0),
            }),
            Count = Roact.createElement("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0.8, 0, 0.8, 0),
                Font = Enum.Font.SourceSansBold,
                Text = string.format("%s/%s", self.props.playerCount, Players.MaxPlayers),
                TextColor3 = Color3.fromRGB(237, 237, 237),
                TextScaled = true,
                TextTransparency = self.transparency,
            }),
        }),
        PlayerScroller = Roact.createElement("ScrollingFrame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.298, 0, 0.697, 0),
            Size = UDim2.new(0.506, 0, 0.342, 0),
            CanvasSize = self.canvasSize,
            CanvasPosition = self.canvasPosition,
            ScrollBarImageTransparency = self.transparency,
            ScrollBarThickness = 2,
            ScrollingDirection = Enum.ScrollingDirection.X,
        }, {
            Container = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
            }, playerScrollerChildren),
        }),
        PlayButton = Roact.createElement("TextButton", {
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = self.playButtonTransparency,
            Position = UDim2.new(0.765, 0, 0.706, 0),
            Size = UDim2.new(0.369, 0,0.324, 0),
            Text = "",
            [Roact.Event.MouseEnter] = function()
                if self.props.isOpen == true then
                    self.playButtonTransparencyMotor:setGoal(Otter.spring(0.3, Constants.PLAYERSCROLLER_PLAYBUTTON_SPRING_CONFIG))
                end
            end,
            [Roact.Event.MouseLeave] = function()
                if self.props.isOpen == true then
                    self.playButtonTransparencyMotor:setGoal(Otter.spring(0, Constants.PLAYERSCROLLER_PLAYBUTTON_SPRING_CONFIG))
                end
            end,
            [Roact.Event.Activated] = function()
                if not game.JobId == self.props.jobId then
                    retry(function()
                        return TeleportService:TeleportToPlaceInstance(game.PlaceId, self.props.jobId)
                    end, Constants.MAX_TELEPORTATION_RETRIES)
                end
            end
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.25, 0),
            }),
            UIGradient = Roact.createElement("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, colors[1]),
                    ColorSequenceKeypoint.new(1, colors[2]),
                }),
                Rotation = 10,
            }),
            Text = Roact.createElement("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0.908, 0, 0.778, 0),
                Font = Enum.Font.SourceSansBold,
                Text = "PLAY",
                TextColor3 = Color3.fromRGB(227, 227, 227),
                TextScaled = true,
                TextTransparency = self.transparency,
            })
        })
    })
end

function Server:didUpdate(previousProps)
    if not self.props.isOpen == previousProps.isOpen then
        local transparency = nil

        if self.props.isOpen == true then
            transparency = 0
        elseif self.props.isOpen == false then
            transparency = 1
        end

        self.transparencyMotor:setGoal(Otter.spring(transparency, Constants.TRANSPARENCY_SPRING_CONFIG))
        self.playButtonTransparencyMotor:setGoal(Otter.spring(transparency, Constants.TRANSPARENCY_SPRING_CONFIG))
    end
end

function mapStateToProps(state)
    return {
        isOpen = state.ServerBrowser.isOpen,
    }
end

function mapDispatchToProps(dispatch)
    return {
        onClose = function()
            dispatch(SetIsOpen(false))
        end
    }
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Server)