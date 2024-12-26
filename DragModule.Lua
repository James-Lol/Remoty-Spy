-- Drag Module
local UserInputService = game:GetService("UserInputService")

local DraggableObject = {}
DraggableObject.__index = DraggableObject

function DraggableObject.New(TargetObject)
	local Self = {}
	Self.TargetObject = TargetObject
	Self.OnDragStarted = nil
	Self.OnDragEnded = nil
	Self.OnDragged = nil
	Self.IsDragging = false

	setmetatable(Self, DraggableObject)
	return Self
end

function DraggableObject:Enable()
	local TargetObject = self.TargetObject
	local CurrentInput = nil
	local DragStartPosition = nil
	local StartPosition = nil
	local PreparingToDrag = false

	local function UpdatePosition(Input)
		local Delta = Input.Position - DragStartPosition
		local ParentSize = TargetObject.Parent.AbsoluteSize
		local NewPosition = UDim2.new(
			StartPosition.X.Scale + (Delta.X / ParentSize.X),
			0,
			StartPosition.Y.Scale + (Delta.Y / ParentSize.Y),
			0
		)
		TargetObject.Position = NewPosition
		return NewPosition
	end

	self.InputBeganConnection = TargetObject.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			PreparingToDrag = true
			local Connection
			Connection = Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End and (self.IsDragging or PreparingToDrag) then
					self.IsDragging = false
					Connection:Disconnect()

					if self.OnDragEnded and not PreparingToDrag then
						self.OnDragEnded()
					end

					PreparingToDrag = false
				end
			end)
		end
	end)

	self.InputChangedConnection = TargetObject.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			CurrentInput = Input
		end
	end)

	self.GlobalInputChangedConnection = UserInputService.InputChanged:Connect(function(Input)
		if TargetObject.Parent == nil then
			self:Disable()
			return
		end

		if PreparingToDrag then
			PreparingToDrag = false

			if self.OnDragStarted then
				self.OnDragStarted()
			end

			self.IsDragging = true
			DragStartPosition = Input.Position
			StartPosition = TargetObject.Position
		end

		if Input == CurrentInput and self.IsDragging then
			local NewPosition = UpdatePosition(Input)
			if self.OnDragged then
				self.OnDragged(NewPosition)
			end
		end
	end)
end

function DraggableObject:Disable()
	self.InputBeganConnection:Disconnect()
	self.InputChangedConnection:Disconnect()
	self.GlobalInputChangedConnection:Disconnect()

	if self.IsDragging then
		self.IsDragging = false
		if self.OnDragEnded then
			self.OnDragEnded()
		end
	end
end

return DraggableObject
