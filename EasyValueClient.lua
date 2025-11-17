--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local EasyValue = require(ReplicatedStorage.EasyValue)
local ValueUpdate = ReplicatedStorage.EasyValue.ValueUpdate

--// Main Code

ValueUpdate.OnClientEvent:Connect(function(obj, value)
	if obj then
		local success, err = pcall(function()
			local wrapped = EasyValue(obj)
			wrapped:Set(value)
		end)
		
		if not success then
			warn("[EasyValue Client] - Error updating value: " .. err)
		end
	end
end)
