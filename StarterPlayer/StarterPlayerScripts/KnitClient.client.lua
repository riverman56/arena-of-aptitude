local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Knit)

Knit.AddControllers(ReplicatedStorage.Controllers)

Knit.Start():Catch(warn)