--[[

	#########################################################
	#                                                       #
	#                   EasyValue v1.0                      #
	#                                                       #
	#               Developed by Cynmorphic                 #
	#                                                       #
	#########################################################

	EasyValue is a class-based module that enhances readability and
	functionality when working with value objects in Roblox, providing
	a more structured alternative to the default framework.

]]

--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

type values = (string | number | boolean | CFrame | Vector3 | Ray | Instance | Color3 | BrickColor)

local EasyValue = {
	Type = {
		BoolValue = "BoolValue";
		BrickColorValue = "BrickColorValue";
		CFrameValue = "CFrameValue";
		Color3Value = "Color3Value";
		IntValue = "IntValue";
		NumberValue = "NumberValue";
		ObjectValue = "ObjectValue";
		RayValue = "RayValue";
		StringValue = "StringValue";
		Vector3Value = "Vector3Value";
	}

}

EasyValue.__index = EasyValue

local ValueCaches = {}

function EasyValue.__call(_, obj)
	if ValueCaches[obj] then
		return ValueCaches[obj]
	end

	local self = setmetatable({}, EasyValue)

	self.obj = obj
	self.oldValue = nil
	self.currentValue = obj.Value
	self.callbacks = {}

	ValueCaches[obj] = self
	return self
end

function EasyValue.Create(type : string, name : string, value : values, parent : Instance, returnObject : boolean?)

	if not EasyValue.Type[type] then
		warn(`EasyValue :: Unsupported value type! Got: {tostring(type)}`)
		return nil
	end

	local newValue

	local success, response = pcall(function()
		newValue = Instance.new(type)
		newValue.Name = name
		newValue.Value = value
		newValue.Parent = parent
	end)

	if not success then
		warn(`EasyValue :: {response}`)

		if newValue then
			newValue:Destroy()
		end

		return nil
	end

	local returned = returnObject == false and newValue or EasyValue.__call(nil, newValue)

	return returned
end

function EasyValue:_Update(dontCallOnUpdate : boolean)
	if not dontCallOnUpdate then
		for _, callback in pairs(self.callbacks) do
			callback(self.currentValue, self.oldValue)
		end
	end
end

function EasyValue:Set(value : values, dontCallOnUpdate : boolean)
	self.oldValue = self.currentValue
	self.obj.Value, self.currentValue = value, value
	self:_Update(dontCallOnUpdate)
	
	if RunService:IsServer() then
		local success, err = pcall(function()
			script.ValueUpdate:FireAllClients(self.obj, value)
		end)
	end
end

function EasyValue:OnUpdate(callback : (...any) -> ())
	assert(
		type(callback) == "function",
		"callback must be a function"
	)

	table.insert(self.callbacks, callback)
end

function EasyValue:Disconnect(func)
	for i, callback in ipairs(self.callbacks) do
		if callback == func then
			table.remove(self.callbacks, i)
		end
	end
end

function EasyValue:Get()
	return self.obj.Value
end

function EasyValue:Toggle(dontCallOnUpdate : boolean)

	if not self.obj:IsA(EasyValue.Type.BoolValue) then
		warn("EasyValue :: :Toggle() can only be used with BoolValues!")
		return
	end

	self:Set(not self:Get(), dontCallOnUpdate)
end


local incrementWarn = false
function EasyValue:Increment(amount : number, dontCallOnUpdate : boolean)
	if not (self.obj:IsA(EasyValue.Type.NumberValue) or self.obj:IsA(EasyValue.Type.IntValue)) then
		warn("EasyValue :: :Increment() can only be used with IntValues and NumberValues!")
		return
	end

	local current : number = self:Get()
	self:Set(current + amount, dontCallOnUpdate)


	if (amount < 0) and not incrementWarn then
		incrementWarn = true
		warn("EasyValue :: You are using :Increment() for negative values. Have you considered using :Take() for better readability?")
	end
end

function EasyValue:Take(amount : number, dontCallOnUpdate : boolean)
	if not (self.obj:IsA(EasyValue.Type.NumberValue) or self.obj:IsA(EasyValue.Type.IntValue)) then
		warn("EasyValue :: :Take() can only be used with IntValues and NumberValues!")
		return
	end

	local current : number = self:Get()
	self:Set(current - math.abs(amount), dontCallOnUpdate)
end

function EasyValue:Multiply(factor : number, dontCallOnUpdate : boolean)
	if not (self.obj:IsA(EasyValue.Type.NumberValue) or self.obj:IsA(EasyValue.Type.IntValue)) then
		warn("EasyValue :: :Multiply() can only be used with IntValues and NumberValues!")
		return
	end

	local current : number = self:Get()
	self:Set(current * factor, dontCallOnUpdate)
end

function EasyValue:Divide(factor : number, dontCallOnUpdate : boolean)

	if not (self.obj:IsA(EasyValue.Type.NumberValue) or self.obj:IsA(EasyValue.Type.IntValue)) then
		warn("EasyValue :: :Divide() can only be used with IntValues and NumberValues!")
		return
	end

	local current : number = self:Get()
	self:Set(current / factor, dontCallOnUpdate)
end

function EasyValue:Equals(value : values)
	return self:Get() == value
end

function EasyValue:GetType()
	return type(self:Get())
end

function EasyValue:Destroy()
	for _, callback : RBXScriptConnection in self.callbacks do
		if typeof(callback) == "RBXScriptConnection" then
			callback:Disconnect()
		end
	end

	if ValueCaches[self.obj] then
		ValueCaches[self.obj] = nil
	end

	self.obj:Destroy()
end

return setmetatable(EasyValue, EasyValue)
