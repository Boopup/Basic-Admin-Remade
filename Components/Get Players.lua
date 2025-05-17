local Players = game:GetService('Players')
local Teams = game:GetService('Teams')
local Settings = require(game.ReplicatedStorage:WaitForChild("ExtraSettings"))

local filteredArgs = {
	['all'] = {'ban','pban','kick','crash'},
	['others'] = {'ban','pban','kick','crash'},
	['nonadmins'] = {'ban','pban','kick','crash'},
	['admins'] = {'ban','pban','kick','crash'},
}

---Determines if a given argument and command combination requires confirmation.
---@param Arg string The argument category to check (e.g., 'all', 'others').
---@param commandConfirmation boolean Whether command confirmation is enabled.
---@param Command string The command name to check.
---@return boolean True if confirmation is required for the argument-command pair; otherwise, false.
local function Filter(Arg, commandConfirmation, Command)
	if not commandConfirmation then
		return false
	end
	for a, b in next, filteredArgs do
		for c, d in next, b do
			if (tostring(Command):lower() == tostring(d):lower()) and (tostring(Arg):lower() == tostring(a):lower()) then
				return true
			end
		end
	end
	return false
end

---Parses player selection arguments and returns a list of targeted players or a confirmation request.
---@param Player Player The player issuing the command.
---@param Arguments string|nil Comma-separated string specifying target players or selection keywords.
---@param getPermissions fun(player: Player): number Function to retrieve a player's permission level.
---@param commandConfirmation any Value indicating if command confirmation is required.
---@param Command string The command being executed.
---@return table|boolean|string Returns a table of matched players, `false` if no players matched, or `"Confirm"` and a confirmation list if confirmation is required.
---@desc
---Supports selection keywords such as "me", "all", "others", "random", "admins", "nonadmins", and team selectors prefixed with `%`. Also matches players by name or display name prefix (if enabled). If no arguments are provided, defaults to the issuing player. If confirmation is required for any argument-command pair, returns `"Confirm"` and the relevant confirmation data.
local function getPlayers(Player, Arguments, getPermissions, commandConfirmation, Command)
	local toReturn = {}
	local toConfirm = {}

	-- If Arguments is blank, default to the Player who ran the command
	if not Arguments or Arguments == "" then
		table.insert(toReturn, Player)
	else
		for Segment in Arguments:gmatch('([^,]+)') do
			local lowerSegment = Segment:lower()
			if Filter(lowerSegment, commandConfirmation, Command) then
				table.insert(toConfirm, {lowerSegment, commandConfirmation, Command})
			end
			if lowerSegment == 'me' then
				table.insert(toReturn, Player)
			elseif lowerSegment == 'all' then
				for _, b in next, Players:GetPlayers() do
					table.insert(toReturn, b)
				end
			elseif lowerSegment == 'others' then
				for _, b in next, Players:GetPlayers() do
					if b ~= Player then
						table.insert(toReturn, b)
					end
				end
			elseif lowerSegment == 'random' then
				local ranPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
				if ranPlayer == Player then
					repeat
						ranPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
						if #Players:GetPlayers() == 1 and ranPlayer == Player then
							break
						end
						wait()
					until ranPlayer ~= Player
				end
				table.insert(toReturn, ranPlayer)
			elseif lowerSegment == 'admins' then
				for _, b in next, Players:GetPlayers() do
					if getPermissions(b) > 0 then
						table.insert(toReturn, b)
					end
				end
			elseif lowerSegment == 'nonadmins' then
				for _, b in next, Players:GetPlayers() do
					if getPermissions(b) == 0 then
						table.insert(toReturn, b)
					end
				end
			elseif string.sub(lowerSegment, 1, 1) == '%' then
				for _, b in next, Teams:GetChildren() do
					if string.sub(b.Name:lower(), 1, #Segment - 1) == string.sub(Segment:lower(), 2) then
						for _, d in next, Players:GetPlayers() do
							if d.TeamColor == b.TeamColor then
								table.insert(toReturn, d)
							end
						end
					end
				end
			else
				if Settings.DisplayNameSupportEnabled == true then
					for _, b in next, Players:GetPlayers() do
						if string.sub(b.Name:lower(), 1, #Segment) == lowerSegment or string.sub(b.DisplayName:lower(), 1, #Segment) == lowerSegment then
							table.insert(toReturn, b)
						end
					end
				else
					for _, b in next, Players:GetPlayers() do
						if string.sub(b.Name:lower(), 1, #Segment) == lowerSegment then
							table.insert(toReturn, b)
						end
					end
				end
			end
		end
	end

	if #toReturn == 0 then
		return false
	elseif #toReturn > 0 then
		if #toConfirm > 0 then
			return "Confirm", toConfirm
		else
			return toReturn
		end
	end
end

return getPlayers
