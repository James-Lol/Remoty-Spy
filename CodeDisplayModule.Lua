-- Turn Text Code Into Display
print("Updated")

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

function CodeDisplay.New(Frame, Settings)
	local self = setmetatable({}, CodeDisplay)

	Settings = Settings or {}
	self.TextSize = Settings.TextSize or 14
	self.LineNumberWidth = Settings.LineNumberWidth or 30

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

	local CodeLabel = Instance.new("TextLabel")
	CodeLabel.Size = UDim2.new(1, -(self.LineNumberWidth + 10), 1, 0)
	CodeLabel.Position = UDim2.new(0, self.LineNumberWidth + 5, 0, 0)
	CodeLabel.BackgroundTransparency = 1
	CodeLabel.TextColor3 = DefaultCodeColors.TextColor
	CodeLabel.TextSize = self.TextSize
	CodeLabel.RichText = true
	CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
	CodeLabel.TextYAlignment = Enum.TextYAlignment.Top
	CodeLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	CodeLabel.Name = "CodeLabel"
	CodeLabel.Parent = CodeDisplayScrollingFrame

	local CopyableCodeLabel = Instance.new("TextBox")
	CopyableCodeLabel.Size = UDim2.new(1, -(self.LineNumberWidth + 10), 1, 0)
	CopyableCodeLabel.Position = UDim2.new(0, self.LineNumberWidth + 5, 0, 0)
	CopyableCodeLabel.BackgroundTransparency = 1
	CopyableCodeLabel.TextTransparency = 0.9
	CopyableCodeLabel.TextSize = self.TextSize
	CopyableCodeLabel.TextXAlignment = Enum.TextXAlignment.Left
	CopyableCodeLabel.TextYAlignment = Enum.TextYAlignment.Top
	CopyableCodeLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	CopyableCodeLabel.Name = "CopyableCodeLabel"
	CopyableCodeLabel.ClearTextOnFocus = false
	CopyableCodeLabel.TextEditable = false
	CopyableCodeLabel.ZIndex = 2
	CopyableCodeLabel.Parent = CodeDisplayScrollingFrame

	local LineNumbers = Instance.new("TextLabel")
	LineNumbers.Size = UDim2.new(0, self.LineNumberWidth, 1, 0)
	LineNumbers.Position = UDim2.new(0, 0, 0, 0)
	LineNumbers.BackgroundTransparency = 1
	LineNumbers.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	LineNumbers.TextSize = self.TextSize
	LineNumbers.TextXAlignment = Enum.TextXAlignment.Left
	LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
	LineNumbers.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	LineNumbers.Name = "LineNumbers"
	LineNumbers.Parent = CodeDisplayScrollingFrame

	self.ScrollingFrame = CodeDisplayScrollingFrame
	self.CodeLabel = CodeLabel
	self.CopyableCodeLabel = CopyableCodeLabel
	self.LineNumbers = LineNumbers

	return self
end

local function WrapWithColor(Text, Color)
	return string.format([[<font color="%s">%s</font>]], ToHex(Color), Text)
end

function CodeDisplay:ProcessText(Text)
	if Text == "" then return "" end
	local ProcessedLines = {}
	for Line in (Text .. "\n"):gmatch("([^\n]*)\n") do
		local ProcessedLine = Line
		local CommentStart = Line:find("%-%-")
		if CommentStart then
			local BeforeComment = Line:sub(1, CommentStart - 1)
			local Comment = Line:sub(CommentStart)
			ProcessedLine = self:ProcessWords(BeforeComment) .. WrapWithColor(Comment, DefaultCodeColors.CommentColor)
		else
			ProcessedLine = self:ProcessWords(Line)
		end
		table.insert(ProcessedLines, ProcessedLine)
	end
	return table.concat(ProcessedLines, "\n")
end

function CodeDisplay:ProcessWords(Text)
	local ProcessedWords = {}
	local CurrentWord = ""
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

function CodeDisplay:SetCode(Code)
	local RobloxTextLimit = 20000

	if #Code >= RobloxTextLimit then
		self.LineNumbers.Text = "1"
		self.CodeLabel.Text = string.format("-- Unable to assign property Text. Provided code length (%d) is greater than or equal to max length (%d)", #Code, RobloxTextLimit)
		self.CopyableCodeLabel.Text = ""
		self.ScrollingFrame.CanvasSize = UDim2.new(0, self.CodeLabel.TextBounds.X + self.LineNumberWidth + 10, 0, self.CodeLabel.TextBounds.Y)
		return
	end

	local LineCount = select(2, Code:gsub("\n", "\n"))
	local LineNumbersText = {}
	for i = 1, LineCount do
		table.insert(LineNumbersText, i)
	end
	
	self.LineNumbers.Text = table.concat(LineNumbersText, "\n")
	self.CodeLabel.Text = self:ProcessText(Code)
	self.CopyableCodeLabel.Text = Code

	self.ScrollingFrame.CanvasSize = UDim2.new(0, (self.CodeLabel.TextBounds.X + self.LineNumberWidth + 10) * 1.5, 0, self.CodeLabel.TextBounds.Y)
end

function CodeDisplay:UpdateSettings(Settings)
	Settings = Settings or {}
	if Settings.TextSize then
		self.TextSize = Settings.TextSize
		self.CodeLabel.TextSize = self.TextSize
		self.CopyableCodeLabel.TextSize = self.TextSize
		self.LineNumbers.TextSize = self.TextSize
	end
	if Settings.LineNumberWidth then
		self.LineNumberWidth = Settings.LineNumberWidth
		self.LineNumbers.Size = UDim2.new(0, self.LineNumberWidth, 1, 0)
		self.CodeLabel.Size = UDim2.new(1, -(self.LineNumberWidth + 10), 1, 0)
		self.CodeLabel.Position = UDim2.new(0, self.LineNumberWidth + 5, 0, 0)
		self.CopyableCodeLabel.Size = UDim2.new(1, -(self.LineNumberWidth + 10), 1, 0)
		self.CopyableCodeLabel.Position = UDim2.new(0, self.LineNumberWidth + 5, 0, 0)
	end

	if self.CopyableCodeLabel.Text ~= "" then
		self:SetCode(self.CopyableCodeLabel.Text)
	end
end

return CodeDisplay
