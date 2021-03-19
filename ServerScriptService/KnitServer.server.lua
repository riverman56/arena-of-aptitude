local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Knit = require(ReplicatedStorage.Knit)

Knit.AddServices(ServerStorage.Services)

Knit.Start():Catch(warn)