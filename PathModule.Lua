-- Object Path To Text Module
local function NeedsWrapping(String)
	if string.match(String, "^%d") or 
		string.match(String, "[^%w]") or 
		string.match(String, "_") then
		return true
	end
	return false
end

local function WrapName(Name)
	if NeedsWrapping(Name) then
		return string.format('["%s"]', Name:gsub('"', '\\"'))
	end
	return Name
end

local function GetIndexInParent(Object)
	if not Object or not Object.Parent then return nil end

	local Siblings = Object.Parent:GetChildren()
	for Index, Child in ipairs(Siblings) do
		if Child == Object then
			return Index
		end
	end
	return nil
end

local function HasDuplicateNameInParent(Object)
	if not Object or not Object.Parent then return false end

	local Count = 0
	for _, Child in ipairs(Object.Parent:GetChildren()) do
		if Child.Name == Object.Name then
			Count = Count + 1
			if Count > 1 then
				return true
			end
		end
	end
	return false
end

local function IsService(Object)
	for _, Service in ipairs(game:GetChildren()) do
		if Service == Object then
			return true
		end
	end
	return false
end

local Module = {}

function Module.ObjectToPath(Object)
	if not Object then return nil end

	local Path = {}
	local CurrentObject = Object

	while CurrentObject and CurrentObject ~= game do
		if IsService(CurrentObject) then
			table.insert(Path, 1, string.format('game:GetService("%s")', CurrentObject.ClassName))
			break
		else
			if HasDuplicateNameInParent(CurrentObject) then
				local Index = GetIndexInParent(CurrentObject)
				table.insert(Path, 1, string.format(':GetChildren()[%d]', Index))
			elseif NeedsWrapping(CurrentObject.Name) then
				table.insert(Path, 1, WrapName(CurrentObject.Name))
			else
				table.insert(Path, 1, CurrentObject.Name)
			end
		end
		CurrentObject = CurrentObject.Parent
	end

	if #Path == 0 then
		return nil
	end

	local Result = Path[1]
	for Index = 2, #Path do
		if Path[Index]:match("^:") then
			Result = Result .. Path[Index]
		else
			Result = Result .. "." .. Path[Index]
		end
	end

	return Result
end

return Module