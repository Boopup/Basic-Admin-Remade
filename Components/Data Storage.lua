local DatastoreFunctions = {}

DatastoreFunctions.init = function(datastoreName)
	if(type(datastoreName) == "string") then
		DatastoreFunctions.dataStoreName = datastoreName
		DatastoreFunctions.DataStore = game:GetService("DataStoreService"):GetDataStore(datastoreName)
		return setmetatable({}, {
			__index = DatastoreFunctions,
			__call = function(self, key, value, increment)
				if(key) then
					if(value ~= nil) then
						if(type(value) == "function") then
							return DatastoreFunctions.onUpdate(key, value)
						elseif(type(value) == "number" and increment) then
							return DatastoreFunctions.increment(key, value)
						end
						return DatastoreFunctions.set(key, value)
					end
					return DatastoreFunctions.get(key)
				else
					return DatastoreFunctions.getName()
				end
			end,
			__newindex = function()
				
			end,
			__metatable = "Access Denied"
		})
	end
end

DatastoreFunctions.getName = function()
	return DatastoreFunctions.dataStoreName
end

DatastoreFunctions.get = function(key, default)
	local data = DatastoreFunctions.DataStore:GetAsync(key)
	return data or default
end

DatastoreFunctions.set = function(key, value)
	DatastoreFunctions.DataStore:SetAsync(key, value)
	return value
end

DatastoreFunctions.remove = function(key)
	DatastoreFunctions.DataStore:RemoveAsync(key)
end

DatastoreFunctions.update = function(key, onUpdate)
	return DatastoreFunctions.DataStore:UpdateAsync(key, onUpdate)
end

DatastoreFunctions.increment = function(key, delta)
	return DatastoreFunctions.DataStore:IncrementAsync(key, delta)
end

local subs = {}
DatastoreFunctions.onUpdate = function(key, OnUpdate, manual)
	if(subs[key]) then
		subs[key]:disconnect()
	end
	if(manual) then
		return DatastoreFunctions.DataStore:OnUpdate(key, OnUpdate)
	end
	subs[key] = DatastoreFunctions.DataStore:OnUpdate(key, OnUpdate)
end

DatastoreFunctions.disconnect = function(key)
	if(subs[key]) then
		subs[key]:disconnect()
		subs[key] = nil
	end
end

return DatastoreFunctions.init
