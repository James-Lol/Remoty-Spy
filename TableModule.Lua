-- Lua Table To Text
local Module = {}

-- Local helper functions
local function GetMaxIndex(Tbl)
    local MaxIndex = 0
    for Index in pairs(Tbl) do
        if type(Index) == "number" and Index > MaxIndex then
            MaxIndex = Index
        end
    end
    return MaxIndex
end

local PathModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/PathModule.Lua"))()

-- Format basic types
local function FormatBasicType(Value)
    if type(Value) == "string" then
        return string.format("%q", Value)
    elseif type(Value) == "boolean" or type(Value) == "number" then
        return tostring(Value)
    elseif Value == nil then
        return "nil"
    end
    return nil
end

-- Format Vector types
local function FormatVector(Vector)
    local VectorType = typeof(Vector)
    if VectorType == "Vector2" or VectorType == "Vector3" then
        return string.format("%s.new(%s)", 
            VectorType,
            table.concat({Vector:components()}, ", "))
    end
    return nil
end

-- Format Color types
local function FormatColor(Color)
    local ColorType = typeof(Color)
    if ColorType == "Color3" then
        return string.format("Color3.new(%g, %g, %g)", 
            Color.R, Color.G, Color.B)
    elseif ColorType == "BrickColor" then
        return string.format('BrickColor.new("%s")', Color.Name)
    end
    return nil
end

-- Format Dimension types
local function FormatDimension(Value)
    local ValueType = typeof(Value)
    if ValueType == "UDim" then
        return string.format("UDim.new(%g, %g)", 
            Value.Scale, Value.Offset)
    elseif ValueType == "UDim2" then
        return string.format("UDim2.new(%g, %g, %g, %g)",
            Value.X.Scale, Value.X.Offset,
            Value.Y.Scale, Value.Y.Offset)
    end
    return nil
end

-- Format Position/Transform types
local function FormatTransform(Value)
    local ValueType = typeof(Value)
    if ValueType == "CFrame" then
        return string.format("CFrame.new(%s)", 
            table.concat({Value:components()}, ", "))
    elseif ValueType == "Ray" then
        local Origin, Direction = Value.Origin, Value.Direction
        return string.format("Ray.new(Vector3.new(%g, %g, %g), Vector3.new(%g, %g, %g))",
            Origin.X, Origin.Y, Origin.Z,
            Direction.X, Direction.Y, Direction.Z)
    end
    return nil
end

-- Format Region types
local function FormatRegion(Value)
    local ValueType = typeof(Value)
    if ValueType == "Rect" then
        return string.format("Rect.new(%g, %g, %g, %g)",
            Value.Min.X, Value.Min.Y,
            Value.Max.X, Value.Max.Y)
    elseif ValueType == "Region3" then
        local Min, Max = Value.CFrame.Position - Value.Size/2, Value.CFrame.Position + Value.Size/2
        return string.format("Region3.new(Vector3.new(%g, %g, %g), Vector3.new(%g, %g, %g))",
            Min.X, Min.Y, Min.Z,
            Max.X, Max.Y, Max.Z)
    end
    return nil
end

-- Format Sequence types
local function FormatSequence(Value)
    local ValueType = typeof(Value)
    if ValueType == "ColorSequence" then
        local FormattedPoints = {}
        for _, Point in ipairs(Value.Keypoints) do
            table.insert(FormattedPoints, 
                string.format("ColorSequenceKeypoint.new(%g, Color3.new(%g, %g, %g))",
                    Point.Time,
                    Point.Value.R, Point.Value.G, Point.Value.B))
        end
        return string.format("ColorSequence.new({%s})",
            table.concat(FormattedPoints, ", "))
    elseif ValueType == "NumberSequence" then
        local FormattedPoints = {}
        for _, Point in ipairs(Value.Keypoints) do
            table.insert(FormattedPoints,
                string.format("NumberSequenceKeypoint.new(%g, %g, %g)",
                    Point.Time,
                    Point.Value,
                    Point.Envelope or 0))
        end
        return string.format("NumberSequence.new({%s})",
            table.concat(FormattedPoints, ", "))
    end
    return nil
end

-- Format Range types
local function FormatRange(Value)
    local ValueType = typeof(Value)
    if ValueType == "NumberRange" then
        return string.format("NumberRange.new(%g, %g)",
            Value.Min, Value.Max)
    end
    return nil
end

-- Format Font type
local function FormatFont(Value)
    if typeof(Value) == "Font" then
        return string.format('Font.new("%s", Enum.FontWeight.%s, Enum.FontStyle.%s)', 
            Value.Family, 
            Value.Weight.Name, 
            Value.Style.Name)
    end
    return nil
end

-- Format PhysicalProperties type
local function FormatPhysicalProperties(Value)
    if typeof(Value) == "PhysicalProperties" then
        return string.format("PhysicalProperties.new(%g, %g, %g, %g, %g)",
            Value.Density,
            Value.Friction,
            Value.Elasticity,
            Value.FrictionWeight,
            Value.ElasticityWeight)
    end
    return nil
end

-- Format DateTime type
local function FormatDateTime(Value)
    if typeof(Value) == "DateTime" then
        return string.format("DateTime.fromUnixTimestampMillis(%d)",
            Value.UnixTimestampMillis)
    end
    return nil
end

-- Format TweenInfo type
local function FormatTweenInfo(Value)
    if typeof(Value) == "TweenInfo" then
        return string.format("TweenInfo.new(%g, Enum.EasingStyle.%s, Enum.EasingDirection.%s, %d, %s, %g)",
            Value.Time,
            Value.EasingStyle.Name,
            Value.EasingDirection.Name,
            Value.RepeatCount,
            tostring(Value.Reverses),
            Value.DelayTime)
    end
    return nil
end

-- Format PathWaypoint type
local function FormatPathWaypoint(Value)
    if typeof(Value) == "PathWaypoint" then
        return string.format("PathWaypoint.new(Vector3.new(%g, %g, %g), %s)",
            Value.Position.X, Value.Position.Y, Value.Position.Z,
            Value.Action.Name)
    end
    return nil
end

-- Format Faces type
local function FormatFaces(Value)
    if typeof(Value) == "Faces" then
        local faces = {}
        if Value.Top then table.insert(faces, "Top") end
        if Value.Bottom then table.insert(faces, "Bottom") end
        if Value.Left then table.insert(faces, "Left") end
        if Value.Right then table.insert(faces, "Right") end
        if Value.Back then table.insert(faces, "Back") end
        if Value.Front then table.insert(faces, "Front") end
        
        if #faces == 0 then
            return "Faces.new()"
        else
            return string.format("Faces.new(Enum.NormalId.%s)", 
                table.concat(faces, ", Enum.NormalId."))
        end
    end
    return nil
end

-- Format Axes type
local function FormatAxes(Value)
    if typeof(Value) == "Axes" then
        local axes = {}
        if Value.X then table.insert(axes, "X") end
        if Value.Y then table.insert(axes, "Y") end
        if Value.Z then table.insert(axes, "Z") end
        
        if #axes == 0 then
            return "Axes.new()"
        else
            return string.format("Axes.new(Enum.Axis.%s)", 
                table.concat(axes, ", Enum.Axis."))
        end
    end
    return nil
end

-- Format Reference types
local function FormatReference(Value)
    local ValueType = typeof(Value)
    if ValueType == "Instance" then
        return PathModule.ObjectToPath(Value)
    elseif ValueType == "EnumItem" then
        return string.format("Enum.%s.%s", 
            tostring(Value.EnumType),
            tostring(Value.Name))
    elseif ValueType == "Enum" then
        return "Enum." .. tostring(Value)
    end
    return nil
end

local TableToString

local function FormatValue(Value, Indent, Visited)
    local Formatted = 
        FormatBasicType(Value) or
        FormatVector(Value) or
        FormatColor(Value) or
        FormatDimension(Value) or
        FormatTransform(Value) or
        FormatRegion(Value) or
        FormatSequence(Value) or
        FormatRange(Value) or
        FormatReference(Value) or
        FormatFont(Value) or
        FormatPhysicalProperties(Value) or
        FormatDateTime(Value) or
        FormatTweenInfo(Value) or
        FormatPathWaypoint(Value) or
        FormatFaces(Value) or
        FormatAxes(Value)
    
    if Formatted then
        return Formatted
    elseif type(Value) == "table" then
        return TableToString(Value, Indent, Visited)
    else
        return tostring(Value)
    end
end

TableToString = function(Tbl, Indent, Visited)
    if type(Tbl) ~= "table" then
        return FormatValue(Tbl, Indent, Visited)
    end
    
    Visited = Visited or {}
    if Visited[Tbl] then
        return "<cycle>"
    end

    Visited[Tbl] = true
    
    Indent = Indent or ""
    local Result = "{\n"
    local MaxIndex = GetMaxIndex(Tbl)
    
    for I = 1, MaxIndex do
        Result = Result .. Indent .. "    [" .. I .. "] = "
        Result = Result .. FormatValue(Tbl[I], Indent .. "    ", Visited) .. ",\n"
    end
    
    for Index, Value in pairs(Tbl) do
        if type(Index) ~= "number" or Index > MaxIndex then
            Result = Result .. Indent .. "    "
            
            if type(Index) == "number" then
                Result = Result .. "[" .. Index .. "]"
            else
                Result = Result .. "[" .. FormatValue(Index, "", Visited) .. "]"
            end
            
            Result = Result .. " = " .. FormatValue(Value, Indent .. "    ", Visited) .. ",\n"
        end
    end
    
    Visited[Tbl] = nil
    return Result .. Indent .. "}"
end

Module.TableToString = TableToString

return Module
