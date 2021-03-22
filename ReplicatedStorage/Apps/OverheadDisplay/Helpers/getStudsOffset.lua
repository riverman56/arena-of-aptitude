local function getStudsOffset(billboardSizeY: number, adornee: Model)
    local orientation, size = adornee:GetBoundingBox()

    return Vector3.new(0, size.Y / 2 + billboardSizeY / 2, 0)
end

return getStudsOffset