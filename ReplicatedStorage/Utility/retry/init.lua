local RunService = game:GetService("RunService")

local timesRetried = 0

function heartbeatWait(seconds)
    seconds = math.max(seconds or (1 / 60), 1 / 60)

    while seconds > 0 do
        seconds -= RunService.Heartbeat:Wait()
    end
end

local function retry(_function, maxRetries: number, yieldTime: number | nil)
    if yieldTime and yieldTime <= 0 then
        error("yieldTime must be greater than 0")
    end

    assert(math.floor(maxRetries) == maxRetries and maxRetries > 0, "maxRetries must be an integer greater than 0")
    timesRetried += 1

    local success, result = pcall(_function)

    if success == false then
        if timesRetried >= maxRetries then
            return success, result
        end

        if yieldTime then
            heartbeatWait(yieldTime)
        end

        return retry(_function, maxRetries, yieldTime)
    elseif success == true then
        return success, result
    end
end

return retry