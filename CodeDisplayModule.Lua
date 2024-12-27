-- Turn Text Code Into Display
local CodeDisplay = {}
CodeDisplay.__index = CodeDisplay

local DefaultCodeColors = {
	["TextColor"] = Color3.fromRGB(204, 204, 204),
	["OperatorColor"] = Color3.fromRGB(204, 204, 204),
	["NumberColor"] = Color3.fromRGB(255, 198, 0),
	["StringColor"] = Color3.fromRGB(173, 241, 149),
	["CommentColor"] = Color3.fromRGB(102, 102, 102),
	["KeywordColor"] = Color3.fromRGB(248, 109, 124),
	["BuiltInFunctionColor"] = Color3.fromRGB(132, 214, 247),
	["NilOrBoolColor"] = Color3.fromRGB(255, 198, 0),
	["FunctionLocalSelfColor"] = Color3.fromRGB(248, 109, 124)
}

local Keywords = {
	["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true,
	["elseif"] = true, ["end"] = true, ["false"] = true, ["for"] = true,
	["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true,
	["nil"] = true, ["not"] = true, ["or"] = true, ["repeat"] = true,
	["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
	["while"] = true
}

local BuiltInFunctions = {
	["assert"] = true, ["collectgarbage"] = true, ["error"] = true,
	["getfenv"] = true, ["getmetatable"] = true, ["ipairs"] = true,
	["loadstring"] = true, ["next"] = true, ["pairs"] = true,
	["pcall"] = true, ["print"] = true, ["rawequal"] = true,
	["rawget"] = true, ["rawset"] = true, ["select"] = true,
	["setfenv"] = true, ["setmetatable"] = true, ["tonumber"] = true,
	["tostring"] = true, ["type"] = true, ["unpack"] = true,
	["xpcall"] = true, ["new"] = true, ["Color3"] = true,
	["fromRGB"] = true, ["string"] = true, ["math"] = true,
	["Instance"] = true, ["Enum"] = true, ["Vector2"] = true,
	["Vector3"] = true, ["UDim2"] = true, ["UDim"] = true,
	["game"] = true
}

local function ToInteger(Color)
	return math.floor(Color.R * 255) * 256^2 + math.floor(Color.G * 255) * 256 + math.floor(Color.B * 255)
end

local function ToHex(Color)
	local Int = ToInteger(Color)
	local Current = Int
	local Final = ""
	local HexChar = { "A", "B", "C", "D", "E", "F" }
	repeat
		local Remainder = Current % 16
		local Char = tostring(Remainder)
		if Remainder >= 10 then
			Char = HexChar[1 + Remainder - 10]
		end
		Current = math.floor(Current / 16)
		Final = Final .. Char
	until Current <= 0
	return "#" .. string.reverse(Final)
end

function CodeDisplay.New(Frame)
	local self = setmetatable({}, CodeDisplay)
	
	local CodeDisplayScrollingFrame = Instance.new("ScrollingFrame")
	CodeDisplayScrollingFrame.Name = "CodeDisplay"
	CodeDisplayScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	CodeDisplayScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	CodeDisplayScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	CodeDisplayScrollingFrame.BackgroundTransparency = 1
	CodeDisplayScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	CodeDisplayScrollingFrame.Active = true
	CodeDisplayScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	CodeDisplayScrollingFrame.ScrollBarImageColor3 = Color3.new(0.274, 0.274, 0.274)
	CodeDisplayScrollingFrame.BottomImage = "rbxassetid://19000029648"
	CodeDisplayScrollingFrame.MidImage = "rbxassetid://19000029648"
	CodeDisplayScrollingFrame.TopImage = "rbxassetid://19000029648"
	CodeDisplayScrollingFrame.BorderSizePixel = 0
	CodeDisplayScrollingFrame.Parent = Frame
	
	self.ScrollingFrame = CodeDisplayScrollingFrame
	
	local ListLayout = Instance.new("UIListLayout")
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = CodeDisplayScrollingFrame
	
	self:CreateLine(1)
	self.LineCount = 1
	return self
end

local function WrapWithColor(Text, Color)
	return string.format([[<font color="%s">%s</font>]],ToHex(Color),Text)
end

function CodeDisplay:ProcessText(Text)
	if Text == "" then return "" end

	local CommentStart = Text:find("%-%-")
	if CommentStart then
		local BeforeComment = Text:sub(1, CommentStart - 1)
		local Comment = Text:sub(CommentStart)
		return self:ProcessText(BeforeComment) .. WrapWithColor(Comment, DefaultCodeColors.CommentColor)
	end

	local ProcessedWords = {}
	local CurrentWord = ""
	local Result = ""
	local InString = false
	local StringChar = nil
	local i = 1

	while i <= #Text do
		local Char = Text:sub(i, i)

		if (Char == '"' or Char == "'") and (i == 1 or Text:sub(i - 1, i - 1) ~= "\\") then
			if not InString then
				if CurrentWord ~= "" then
					table.insert(ProcessedWords, CurrentWord)
					CurrentWord = ""
				end
				InString = true
				StringChar = Char
				CurrentWord = Char
			elseif StringChar == Char then
				CurrentWord = CurrentWord .. Char
				table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.StringColor))
				CurrentWord = ""
				InString = false
			else
				CurrentWord = CurrentWord .. Char
			end
		elseif InString then
			CurrentWord = CurrentWord .. Char
		elseif Char:match("[%w_]") then
			CurrentWord = CurrentWord .. Char
		else
			if CurrentWord ~= "" then
				if CurrentWord == "true" or CurrentWord == "false" or CurrentWord == "nil" then
					table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.NilOrBoolColor))
				elseif tonumber(CurrentWord) then
					table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.NumberColor))
				elseif Keywords[CurrentWord] then
					table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.KeywordColor))
				elseif BuiltInFunctions[CurrentWord] then
					table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.BuiltInFunctionColor))
				else
					table.insert(ProcessedWords, CurrentWord)
				end
				CurrentWord = ""
			end
			table.insert(ProcessedWords, Char)
		end
		i = i + 1
	end

	if CurrentWord ~= "" then
		if CurrentWord == "true" or CurrentWord == "false" or CurrentWord == "nil" then
			table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.NilOrBoolColor))
		elseif tonumber(CurrentWord) then
			table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.NumberColor))
		elseif Keywords[CurrentWord] then
			table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.KeywordColor))
		elseif BuiltInFunctions[CurrentWord] then
			table.insert(ProcessedWords, WrapWithColor(CurrentWord, DefaultCodeColors.BuiltInFunctionColor))
		else
			table.insert(ProcessedWords, CurrentWord)
		end
	end

	return table.concat(ProcessedWords)
end

function CodeDisplay:CreateLine(Number, CodeText)
	local LineNumber = Instance.new("TextLabel")
	LineNumber.Size = UDim2.new(0, 28, 0.1, 0)
	LineNumber.BackgroundTransparency = 1
	LineNumber.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	LineNumber.TextScaled = true
	LineNumber.RichText = true
	LineNumber.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LineNumber.TextXAlignment = Enum.TextXAlignment.Left
	LineNumber.Text = " " .. tostring(Number)
	LineNumber.Name = "Line" .. Number
	LineNumber.LayoutOrder = Number
	LineNumber.Parent = self.ScrollingFrame
	
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
	UIAspectRatioConstraint.AspectRatio = 1.455339789390564
	UIAspectRatioConstraint.Parent = LineNumber

	local CodeLabel = Instance.new("TextLabel")
	CodeLabel.Size = UDim2.new(1000, 0, 1, 0)
	CodeLabel.Position = UDim2.new(1, 0, 0, 0)
	CodeLabel.BackgroundTransparency = 1
	CodeLabel.TextColor3 = DefaultCodeColors.TextColor
	CodeLabel.TextScaled = true
	CodeLabel.RichText = true
	CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
	CodeLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	CodeLabel.Name = "Code"
	CodeLabel.Text = self:ProcessText(CodeText or "")
	CodeLabel.Parent = LineNumber
	
	local CopyableCodeLabel = Instance.new("TextBox")
	CopyableCodeLabel.ClearTextOnFocus = false
	CopyableCodeLabel.TextEditable = false
	CopyableCodeLabel.Size = UDim2.new(1000, 0, 1, 0)
	CopyableCodeLabel.Position = UDim2.new(1, 0, 0, 0)
	CopyableCodeLabel.TextTransparency = 0.9
	CopyableCodeLabel.BackgroundTransparency = 1
	CopyableCodeLabel.TextScaled = true
	CopyableCodeLabel.RichText = true
	CopyableCodeLabel.TextXAlignment = Enum.TextXAlignment.Left
	CopyableCodeLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	CopyableCodeLabel.Name = "CopyableCode"
	CopyableCodeLabel.Text = CodeText or ""
	CopyableCodeLabel.ZIndex = 2
	CopyableCodeLabel.Parent = LineNumber
	
	return LineNumber
end

function CodeDisplay:SetCode(Code)
	local Lines = {}
	local XScrollingFrameSize = 0
	local YScrollingFrameSize = 0
	
	for Line in (Code .. "\n"):gmatch("([^\n]*)\n") do
		table.insert(Lines, Line)
		XScrollingFrameSize = math.max(XScrollingFrameSize, math.floor(#Line * 0.03))
	end
		
	local NewLineCount = #Lines

	while self.LineCount < NewLineCount do
		self.LineCount = self.LineCount + 1
		self:CreateLine(self.LineCount)
	end

	while self.LineCount > NewLineCount do
		local LineToRemove = self.ScrollingFrame:FindFirstChild("Line" .. self.LineCount)
		if LineToRemove then
			LineToRemove:Destroy()
		end
		self.LineCount = self.LineCount - 1
	end

	for i = 1, self.LineCount do
		local LineLabel = self.ScrollingFrame:FindFirstChild("Line" .. i)
		if LineLabel then
			LineLabel.Text = " " .. tostring(i)
			local CodeLabel = LineLabel:FindFirstChild("Code")
			if CodeLabel then
				CodeLabel.Text = self:ProcessText(Lines[i] or "")
			end
			local CopyableCodeLabel = LineLabel:FindFirstChild("CopyableCode")
			if CopyableCodeLabel then
				CopyableCodeLabel.Text = Lines[i] or ""
			end
		end
	end
	
	YScrollingFrameSize = self.ScrollingFrame:FindFirstChild("UIListLayout").AbsoluteContentSize.Y
	self.ScrollingFrame.CanvasSize = UDim2.new(XScrollingFrameSize, 0, 0, YScrollingFrameSize)
end

return CodeDisplay
