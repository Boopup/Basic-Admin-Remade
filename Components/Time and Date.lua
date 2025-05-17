--[[
	-- Time functions
	-- @author Narrev
	
	This module can be called like so:
	
	timeModule = require(331894616) 	
	
	timeModule.Date() 			--> returns (year, month, days) @ timestamp tick()
	timeModule.Date(seconds) 	--> returns (year, month, days) @ seconds after epoch time
	
	timeModule.Time()			--> returns (hours, minutes, seconds) @ timestamp tick()
	timeModule.Time(seconds)	--> returns (hours, minutes, seconds) @ seconds after epoch time
	
--]]

local floor, ceil = math.floor, math.ceil

local function isLeapYear(year)
    return year % 4 == 0 and (year % 25 ~= 0 or year % 16 == 0)
end

local function GetLeaps(year)
	return floor(year/4) - floor(year/100) + floor(year/400)
end

local function CountDays(year)
	return 365*year + GetLeaps(year)
end

local function CountDays2(year)
	return 365*year + GetLeaps(year - 1)	
end

local function overflow(array, seed)
	for i = 1, #array do
		if seed - array[i] <= 0 then
			return i, seed
		end
		seed = seed - array[i]
	end
end

local function GetYMDFromSeconds(seconds)
	local seconds = seconds or tick()
    local days = ceil((seconds + 1) / 86400) + CountDays(1970)
    
    local _400Years = 400*floor(days / CountDays(400))
    local _100Years = 100*floor(days % CountDays(400) / CountDays(100))
    local _4Years = 4*floor(days % CountDays(400) % CountDays(100) / CountDays(4))
    
    local _1Years, month
    _1Years, days = overflow({366,365,365,365}, days - CountDays2(_4Years + _100Years + _400Years))
	_1Years	= _1Years - 1
    
    local year = _1Years + _4Years + _100Years + _400Years
    month, days = overflow({31,isLeapYear(year) and 29 or 28,31,30,31,30,31,31,30,31,30,31}, days)
        
	return year, month, days
end

local function GetTimeFromSeconds(seconds)
	local hours	= floor(seconds / 3600 % 24)
	local minutes	= floor(seconds / 60 % 60)
	local seconds	= floor(seconds % 60)
	
	return hours, minutes, seconds
end

return {Date = GetYMDFromSeconds, Time = GetTimeFromSeconds}
