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

---Determines whether a given year is a leap year using custom rules.
---@param year integer The year to check.
---@return boolean True if the year is a leap year, false otherwise.
local function isLeapYear(year)
    return year % 4 == 0 and (year % 25 ~= 0 or year % 16 == 0)
end

---Calculates the number of leap years up to and including the specified year.
---@param year number The year up to which leap years are counted.
---@return number The total number of leap years from year 0 to the given year.
local function GetLeaps(year)
	return floor(year/4) - floor(year/100) + floor(year/400)
end

---Calculates the total number of days in the given number of years, including leap years.
---@param year integer The number of years to count from year 0.
---@return integer Total days including leap days.
local function CountDays(year)
	return 365*year + GetLeaps(year)
end

---Calculates the total number of days in the given number of years, counting leap days up to the previous year.
---@param year number The number of years to include in the calculation.
---@return number Total days including leap days up to year - 1.
local function CountDays2(year)
	return 365*year + GetLeaps(year - 1)	
end

---Finds the index in an array where the cumulative sum exceeds or matches a given seed value.
---@param array number[] Array of integers to iterate through.
---@param seed number The value to decrement by each array element.
---@return number index The 1-based index where the running total overflows.
---@return number remainder The remaining value of seed at the overflow point.
local function overflow(array, seed)
	for i = 1, #array do
		if seed - array[i] <= 0 then
			return i, seed
		end
		seed = seed - array[i]
	end
end

---Converts seconds since the Unix epoch to the corresponding year, month, and day.
---@param seconds number|nil Number of seconds since January 1, 1970 (UTC). If omitted, uses the current tick time.
---@return number year The calculated year.
---@return number month The calculated month (1–12).
---@return number day The calculated day of the month (1–31).
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

---Converts seconds since the epoch into hour, minute, and second components.
---@param seconds number Number of seconds since the epoch.
---@return integer hours Hour component (0–23).
---@return integer minutes Minute component (0–59).
---@return integer seconds Second component (0–59).
local function GetTimeFromSeconds(seconds)
	local hours	= floor(seconds / 3600 % 24)
	local minutes	= floor(seconds / 60 % 60)
	local seconds	= floor(seconds % 60)
	
	return hours, minutes, seconds
end

return {Date = GetYMDFromSeconds, Time = GetTimeFromSeconds}
