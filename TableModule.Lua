-- Lua Table To Text
local Module = {}

local function GetMaxIndex(Table)
	local MaxIndex = 0
	for Key in pairs(Table) do
		if type(Key) == "number" and Key > MaxIndex then
			MaxIndex = Key
		end
	end
	return MaxIndex
end

local function Snap(Number)
	return tonumber(string.format("%.3f",Number))
end

local PathModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/PathModule.Lua"))()

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

local function FormatVector(Vector)
	local VectorType = typeof(Vector)
	if VectorType == "Vector2" then
		return string.format("Vector2.new(%g, %g)", Snap(Vector.X), Snap(Vector.Y))
	elseif VectorType == "Vector3" then
		return string.format("Vector3.new(%g, %g, %g)", Snap(Vector.X), Snap(Vector.Y), Snap(Vector.Z))
	end
	return nil
end

local function FormatColor(Color)
	local ColorType = typeof(Color)
	if ColorType == "Color3" then
		return string.format("Color3.new(%g, %g, %g)", Snap(Color.R), Snap(Color.G), Snap(Color.B))
	elseif ColorType == "BrickColor" then
		return string.format('BrickColor.new("%s")', Color.Name)
	end
	return nil
end

local function FormatDimension(Value)
	local ValueType = typeof(Value)
	if ValueType == "UDim" then
		return string.format("UDim.new(%g, %g)", Snap(Value.Scale), Snap(Value.Offset))
	elseif ValueType == "UDim2" then
		return string.format(
			"UDim2.new(%g, %g, %g, %g)",
			Snap(Value.X.Scale), Snap(Value.X.Offset),
			Snap(Value.Y.Scale), Snap(Value.Y.Offset)
		)
	end
	return nil
end

local function FormatTransform(Value)
	local ValueType = typeof(Value)
	if ValueType == "CFrame" then
		local Components = {Value:GetComponents()}
		for i = 1, #Components do
			Components[i] = string.format("%.3g", Components[i])
		end
		return string.format("CFrame.new(%s)", table.concat(Components, ", "))
	elseif ValueType == "Ray" then
		local Origin, Direction = Value.Origin, Value.Direction
		return string.format(
			"Ray.new(Vector3.new(%g, %g, %g), Vector3.new(%g, %g, %g))",
			Snap(Origin.X), Snap(Origin.Y), Snap(Origin.Z),
			Snap(Direction.X), Snap(Direction.Y), Snap(Direction.Z)
		)
	end
	return nil
end

local function FormatRegion(Value)
	local ValueType = typeof(Value)
	if ValueType == "Rect" then
		return string.format("Rect.new(%g, %g, %g, %g)", Snap(Value.Min.X), Snap(Value.Min.Y), Snap(Value.Max.X), Snap(Value.Max.Y))
	elseif ValueType == "Region3" then
		local Min = Value.CFrame.Position - Value.Size / 2
		local Max = Value.CFrame.Position + Value.Size / 2
		return string.format(
			"Region3.new(Vector3.new(%g, %g, %g), Vector3.new(%g, %g, %g))",
			Snap(Min.X), Snap(Min.Y), Snap(Min.Z),
			Snap(Max.X), Snap(Max.Y), Snap(Max.Z)
		)
	end
	return nil
end

local function FormatSequence(Value)
	local ValueType = typeof(Value)
	if ValueType == "ColorSequence" then
		local Points = {}
		for _, Keypoint in ipairs(Value.Keypoints) do
			table.insert(Points, string.format(
				"ColorSequenceKeypoint.new(%g, Color3.new(%g, %g, %g))",
				Snap(Keypoint.Time), Snap(Keypoint.Value.R), Snap(Keypoint.Value.G), Snap(Keypoint.Value.B)
				))
		end
		return string.format("ColorSequence.new({%s})", table.concat(Points, ", "))
	elseif ValueType == "NumberSequence" then
		local Points = {}
		for _, Keypoint in ipairs(Value.Keypoints) do
			table.insert(Points, string.format(
				"NumberSequenceKeypoint.new(%g, %g, %g)",
				Snap(Keypoint.Time), Snap(Keypoint.Value), Snap(Keypoint.Envelope or 0)
				))
		end
		return string.format("NumberSequence.new({%s})", table.concat(Points, ", "))
	end
	return nil
end

local function FormatRange(Value)
	local ValueType = typeof(Value)
	if ValueType == "NumberRange" then
		return string.format("NumberRange.new(%g, %g)", Snap(Value.Min), Snap(Value.Max))
	end
	return nil
end

local function FormatFont(Value)
	if typeof(Value) == "Font" then
		return string.format('Font.new("%s", Enum.FontWeight.%s, Enum.FontStyle.%s)', Value.Family, Value.Weight.Name, Value.Style.Name)
	end
	return nil
end

local function FormatPhysicalProperties(Value)
	if typeof(Value) == "PhysicalProperties" then
		return string.format(
			"PhysicalProperties.new(%g, %g, %g, %g, %g)",
			Snap(Value.Density), Snap(Value.Friction), Snap(Value.Elasticity),
			Snap(Value.FrictionWeight), Snap(Value.ElasticityWeight)
		)
	end
	return nil
end

local function FormatDateTime(Value)
	if typeof(Value) == "DateTime" then
		return string.format("DateTime.fromUnixTimestampMillis(%d)", Value.UnixTimestampMillis)
	end
	return nil
end

local function FormatTweenInfo(Value)
	if typeof(Value) == "TweenInfo" then
		return string.format(
			"TweenInfo.new(%g, Enum.EasingStyle.%s, Enum.EasingDirection.%s, %d, %s, %g)",
			Snap(Value.Time), Value.EasingStyle.Name, Value.EasingDirection.Name,
			Value.RepeatCount, tostring(Value.Reverses), Snap(Value.DelayTime)
		)
	end
	return nil
end

local function FormatPathWaypoint(Value)
	if typeof(Value) == "PathWaypoint" then
		return string.format(
			"PathWaypoint.new(Vector3.new(%g, %g, %g), Enum.PathWaypointAction.%s)",
			Snap(Value.Position.X), Snap(Value.Position.Y), Snap(Value.Position.Z), Value.Action.Name
		)
	end
	return nil
end

local function FormatFaces(Value)
	if typeof(Value) == "Faces" then
		local Faces = {}
		if Value.Top then table.insert(Faces, "Top") end
		if Value.Bottom then table.insert(Faces, "Bottom") end
		if Value.Left then table.insert(Faces, "Left") end
		if Value.Right then table.insert(Faces, "Right") end
		if Value.Back then table.insert(Faces, "Back") end
		if Value.Front then table.insert(Faces, "Front") end

		if #Faces == 0 then
			return "Faces.new()"
		else
			return string.format("Faces.new(Enum.NormalId.%s)", table.concat(Faces, ", Enum.NormalId."))
		end
	end
	return nil
end

local function FormatAxes(Value)
	if typeof(Value) == "Axes" then
		local Axes = {}
		if Value.X then table.insert(Axes, "X") end
		if Value.Y then table.insert(Axes, "Y") end
		if Value.Z then table.insert(Axes, "Z") end

		if #Axes == 0 then
			return "Axes.new()"
		else
			return string.format("Axes.new(Enum.Axis.%s)", table.concat(Axes, ", Enum.Axis."))
		end
	end
	return nil
end

local function FormatReference(Value)
	local ValueType = typeof(Value)
	if ValueType == "Instance" then
		return PathModule.ObjectToPath(Value)
	elseif ValueType == "EnumItem" then
		return string.format("Enum.%s.%s", tostring(Value.EnumType), tostring(Value.Name))
	elseif ValueType == "Enum" then
		return "Enum." .. tostring(Value)
	end
	return nil
end

local InternalTableToString = nil

local function FormatValue(Value, Indentation, Visited)
	local Formatted =
		FormatBasicType(Value)
		or FormatVector(Value)
		or FormatColor(Value)
		or FormatDimension(Value)
		or FormatTransform(Value)
		or FormatRegion(Value)
		or FormatSequence(Value)
		or FormatRange(Value)
		or FormatReference(Value)
		or FormatFont(Value)
		or FormatPhysicalProperties(Value)
		or FormatDateTime(Value)
		or FormatTweenInfo(Value)
		or FormatPathWaypoint(Value)
		or FormatFaces(Value)
		or FormatAxes(Value)

	if Formatted then
		return Formatted
	elseif type(Value) == "table" then
		return InternalTableToString(Value, Indentation, Visited)
	else
		return tostring(Value)
	end
end

function InternalTableToString(Table, Indentation, Visited)
	if type(Table) ~= "table" then
		return FormatValue(Table, Indentation, Visited)
	end

	if Visited[Table] then
		return "nil, -- <cycle>"
	end
	Visited[Table] = true

	local Result = "{\n"
	local MaxIndex = GetMaxIndex(Table)

	local SequentialLength = 0
	for Index = 1, #Table do
		SequentialLength = Index
	end

	for Index = 1, SequentialLength do
		Result = Result .. Indentation .. "    [" .. Index .. "] = "
		Result = Result .. FormatValue(Table[Index], Indentation .. "    ", Visited) .. ",\n"
	end

	for Key, Value in pairs(Table) do
		if type(Key) ~= "number" or Key > SequentialLength then
			Result = Result .. Indentation .. "    "
			if type(Key) == "number" then
				Result = Result .. "[" .. Key .. "]"
			else
				Result = Result .. "[" .. FormatValue(Key, "", Visited) .. "]"
			end

			Result = Result .. " = " .. FormatValue(Value, Indentation .. "    ", Visited) .. ",\n"
		end
	end

	Visited[Table] = nil
	return Result .. Indentation .. "}"
end

function Module.TableToString(Table)
	return InternalTableToString(Table, "", {})
end

return Module
