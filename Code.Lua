if not hookfunction or not hookmetamethod then
	warn("Your executor does not support : hookfunction() or hookmetamethod()")
	return
end

local Modules = {
	TableModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/TableModule.Lua"))(),
	PathModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/PathModule.Lua"))(),
	DragModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/DragModule.Lua"))(),
	CodeDisplayModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Remoty-Spy/refs/heads/main/CodeDisplayModule.Lua"))()
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScreenGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.new(0.156, 0.156, 0.156)
MainFrame.BorderSizePixel = 0
MainFrame.BorderColor3 = Color3.new(0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

Modules.DragModule.New(MainFrame):Enable()

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
UIAspectRatioConstraint.AspectRatio = 2.0330374240875244
UIAspectRatioConstraint.Parent = MainFrame

local Remotes = Instance.new("ScrollingFrame")
Remotes.Name = "Remotes"
Remotes.Position = UDim2.new(0.1, 0, 0.5, 0)
Remotes.Size = UDim2.new(0.15, 0, 0.9, 0)
Remotes.BackgroundColor3 = Color3.new(0.180, 0.180, 0.180)
Remotes.BorderSizePixel = 0
Remotes.BorderColor3 = Color3.new(0, 0, 0)
Remotes.AnchorPoint = Vector2.new(0.5, 0.5)
Remotes.Active = true
Remotes.ScrollBarImageColor3 = Color3.new(0.274, 0.274, 0.274)
Remotes.ScrollBarThickness = 7
Remotes.BottomImage = "rbxassetid://19000029648"
Remotes.MidImage = "rbxassetid://19000029648"
Remotes.TopImage = "rbxassetid://19000029648"
Remotes.Parent = MainFrame

local RemotesUIListLayout = Instance.new("UIListLayout")
RemotesUIListLayout.Name = "UIListLayout"
RemotesUIListLayout.Padding = UDim.new(0, 5)
RemotesUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

RemotesUIListLayout.Parent = Remotes

local RemoteCalls = Instance.new("ScrollingFrame")
RemoteCalls.Name = "RemoteCalls"
RemoteCalls.Position = UDim2.new(0.275, 0, 0.5, 0)
RemoteCalls.Size = UDim2.new(0.15, 0, 0.9, 0)
RemoteCalls.BackgroundColor3 = Color3.new(0.180, 0.180, 0.180)
RemoteCalls.BorderSizePixel = 0
RemoteCalls.BorderColor3 = Color3.new(0, 0, 0)
RemoteCalls.AnchorPoint = Vector2.new(0.5, 0.5)
RemoteCalls.Active = true
RemoteCalls.ScrollBarImageColor3 = Color3.new(0.274, 0.274, 0.274)
RemoteCalls.ScrollBarThickness = 7
RemoteCalls.BottomImage = "rbxassetid://19000029648"
RemoteCalls.MidImage = "rbxassetid://19000029648"
RemoteCalls.TopImage = "rbxassetid://19000029648"
RemoteCalls.Parent = MainFrame

local RemoteCallsUIListLayout = Instance.new("UIListLayout")
RemoteCallsUIListLayout.Name = "UIListLayout"
RemoteCallsUIListLayout.Padding = UDim.new(0, 5)
RemoteCallsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
RemoteCallsUIListLayout.Parent = RemoteCalls

local CodeFrame = Instance.new("Frame")
CodeFrame.Name = "CodeFrame"
CodeFrame.Position = UDim2.new(0.675, 0, 0.25, 0)
CodeFrame.Size = UDim2.new(0.6, 0, 0.4, 0)
CodeFrame.BackgroundColor3 = Color3.new(0.180, 0.180, 0.180)
CodeFrame.BorderSizePixel = 0
CodeFrame.BorderColor3 = Color3.new(0, 0, 0)
CodeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CodeFrame.Active = true
CodeFrame.Parent = MainFrame

local CodeDisplay = Modules.CodeDisplayModule.New(CodeFrame)

local Buttons = Instance.new("Frame")
Buttons.Name = "Buttons"
Buttons.Position = UDim2.new(0.675, 0, 0.73, 0)
Buttons.Size = UDim2.new(0.6, 0, 0.425, 0)
Buttons.BackgroundColor3 = Color3.new(1, 1, 1)
Buttons.BackgroundTransparency = 1
Buttons.BorderSizePixel = 0
Buttons.BorderColor3 = Color3.new(0, 0, 0)
Buttons.AnchorPoint = Vector2.new(0.5, 0.5)
Buttons.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.Padding = UDim.new(0.1, 0)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Wraps = true
UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
UIListLayout.Parent = Buttons

local function ClearButtons()
	for _, Button in ipairs(Buttons:GetChildren()) do
		if Button:IsA("TextButton") then
			Button:Destroy()
		end
	end
end

local function CreateButton(ButtonSize, ButtonName, ButtonText, Order)
	ButtonSize = ButtonSize or 1
	ButtonName = ButtonName or "Button"
	ButtonText = ButtonText or ""
	Order = Order or 1

	local Button = Instance.new("TextButton")
	Button.Name = ButtonName
	Button.Size = UDim2.new(ButtonSize, 0, 0.2, 0)
	Button.BackgroundColor3 = Color3.new(0.207, 0.207, 0.207)
	Button.BorderSizePixel = 0
	Button.BorderColor3 = Color3.new(0, 0, 0)
	Button.LayoutOrder = Order
	Button.Text = ButtonText
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Button.TextScaled = true
	Button.TextWrapped = true
	Button.Parent = Buttons

	return Button
end

local CurrentRemoteInfo = nil
local CurrentRemote = nil
local CurrentCode = ""

local ClipBoardFunction = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

local function CopyToClipboard(Text)
	if ClipBoardFunction then
		ClipBoardFunction(tostring(Text))
	end
end

local function CreateMainButtons()
	CreateButton(1, "MainButton1", "Remote", 1).MouseButton1Click:Connect(function()
		ClearButtons()

		CreateButton(0.25, "ReturnButton", "Return", 1).MouseButton1Click:Connect(function()
			ClearButtons()
			CreateMainButtons()
		end)

		CreateButton(0.25, "CopyButtonPath", "Copy Remote Path", 2).MouseButton1Click:Connect(function()
			if CurrentRemote then
				CopyToClipboard(Modules.PathModule.ObjectToPath(CurrentRemote))
			end
		end)
	end)

	CreateButton(1, "MainButton2", "Source Script", 2).MouseButton1Click:Connect(function()
		ClearButtons()

		CreateButton(0.25, "ReturnButton", "Return", 1).MouseButton1Click:Connect(function()
			ClearButtons()
			CreateMainButtons()
		end)

		CreateButton(0.25, "CopyButtonPath", "Copy Script Path", 2).MouseButton1Click:Connect(function()
			if CurrentRemoteInfo and CurrentRemoteInfo[1] then
				CopyToClipboard(Modules.PathModule.ObjectToPath(CurrentRemoteInfo[1]))
			end
		end)

		CreateButton(0.25, "CopyButton", "Copy Script Code", 3).MouseButton1Click:Connect(function()
			if CurrentRemoteInfo and CurrentRemoteInfo[1] then
				local SourceScriptCode = nil
				local Success, ErrorMsg = pcall(function()
					SourceScriptCode = decompile(CurrentRemoteInfo[1])
				end)

				if Success and SourceScriptCode then
					CopyToClipboard(tostring(SourceScriptCode))
				else
					warn("Error during decompilation: " .. tostring(ErrorMsg))
				end
			end
		end)

		CreateButton(0.25, "DisplayCode", "Display Script Code", 4).MouseButton1Click:Connect(function()
			if CurrentRemoteInfo and CurrentRemoteInfo[1] then
				local SourceScriptCode = nil
				local Success, ErrorMsg = pcall(function()
					SourceScriptCode = decompile(CurrentRemoteInfo[1])
				end)

				if Success and SourceScriptCode then
					CodeDisplay:SetCode(tostring(SourceScriptCode))
				else
					warn("Error during decompilation: " .. tostring(ErrorMsg))
				end
			end

		end)

		CreateButton(0.25, "StopDisplayCode", "Stop Displaying Script Code", 5).MouseButton1Click:Connect(function()
			if CurrentCode ~= "" then
				CodeDisplay:SetCode(CurrentCode)
			end
		end)
	end)

	CreateButton(1, "MainButton3", "Copy Code", 3).MouseButton1Click:Connect(function()
		if CurrentCode ~= "" then
			CopyToClipboard(CurrentCode)
		end
	end)

	CreateButton(1, "MainButton4", "Run Code", 3).MouseButton1Click:Connect(function()
		if CurrentCode ~= "" then
			local Success, ErrorMsg = pcall(function()
				loadstring(CurrentCode)()
			end)

			if not Success then

				warn("Error during decompilation: " .. tostring(ErrorMsg))
			end
		end
	end)
end

local function CreateScrollButton(ButtonName, ButtonText, ScrollingFrame, Order)
	ButtonName = ButtonName or "Button"
	ButtonText = ButtonText or ""
	ScrollingFrame = ScrollingFrame or Remotes
	Order = Order or 1

	local Button = Instance.new("TextButton")
	Button.Name = ButtonName
	Button.Size = UDim2.new(1, 0, 0, 15)
	Button.BackgroundColor3 = Color3.new(0.24, 0.24, 0.24)
	Button.BorderSizePixel = 0
	Button.LayoutOrder = Order
	Button.Text = ButtonText
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	Button.TextScaled = true
	Button.Parent = ScrollingFrame

	local UIListLayout = ScrollingFrame:FindFirstChildWhichIsA("UIListLayout")
	if UIListLayout then
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y * 1.1)
	end

	return Button
end

local RegisteredRemotes = {}

local function GenerateCode(Remote, Args, Method)
	local RemotePath = Modules.PathModule.ObjectToPath(Remote)
	local Code = nil

	if RemotePath then
		if #Args > 0 then
			local ArgText = Modules.TableModule.TableToString(Args)

			if ArgText then
				Code = string.format("local Args = %s\n\n%s:%s(unpack(Args))", ArgText, RemotePath, Method)
			else
				Code = string.format("%s:%s()", RemotePath, Method)
			end
		else
			Code = string.format("%s:%s()", RemotePath, Method)
		end
	end

	return Code
end

local function RegisterRemote(Remote, Info)
	if not Remote or not Info then
		return
	end

	if RegisteredRemotes[Remote] then
		table.insert(RegisteredRemotes[Remote],Info)
	else
		RegisteredRemotes[Remote] = {}
		table.insert(RegisteredRemotes[Remote],Info)
		CreateScrollButton(Remote.Name, Remote.Name, Remotes, #RegisteredRemotes).MouseButton1Click:Connect(function()
			for _, Button in ipairs(RemoteCalls:GetChildren()) do
				if Button:IsA("TextButton") then
					Button:Destroy()
				end
			end

			for Index ,Info in pairs(RegisteredRemotes[Remote]) do
				CreateScrollButton(tostring(Index), tostring(Index), RemoteCalls, #RegisteredRemotes[Remote] - Index + 1).MouseButton1Click:Connect(function()
					CurrentRemote = Remote
					CurrentRemoteInfo = Info
					local GeneratedCode = GenerateCode(Remote, Info[2], Info[3])
					CurrentCode = GeneratedCode
					CodeDisplay:SetCode(GeneratedCode)
				end)
			end
		end)
	end
end

local OriginalFireServer = nil
local OriginalInvokeServer = nil

OriginalFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(RemoteObject, ...)
	local Args = { ... }
	local Source = getcallingscript()

	coroutine.wrap(function()
		RegisterRemote(RemoteObject, {Source, Args, "FireServer"})
	end)()

	return OriginalFireServer(RemoteObject, unpack(Args))
end))

OriginalInvokeServer = hookfunction(Instance.new("RemoteFunction").InvokeServer, newcclosure(function(RemoteObject, ...)

	local Args = { ... }
	local Source = getcallingscript()

	coroutine.wrap(function()
		RegisterRemote(RemoteObject, {Source, Args, "InvokeServer"})
	end)()

	return OriginalInvokeServer(RemoteObject, unpack(Args))
end))

local OriginalNamecall
OriginalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)

	local MethodName = getnamecallmethod()
	local Args = { ... }
	local Source = getcallingscript()

	coroutine.wrap(function()
		if MethodName == "FireServer" or MethodName == "InvokeServer" then
			RegisterRemote(Self, {Source, Args, MethodName})
		end
	end)()

	return OriginalNamecall(Self, ...)
end))

CreateMainButtons()
