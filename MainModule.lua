--[[
	 	
██████╗░░█████╗░  ██████╗░███████╗███╗░░░███╗░█████╗░██████╗░███████╗
██╔══██╗██╔══██╗  ██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
██████╦╝███████║  ██████╔╝█████╗░░██╔████╔██║███████║██║░░██║█████╗░░
██╔══██╗██╔══██║  ██╔══██╗██╔══╝░░██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░
██████╦╝██║░░██║  ██║░░██║███████╗██║░╚═╝░██║██║░░██║██████╔╝███████╗
╚═════╝░╚═╝░░╚═╝  ╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝

	!! We do not support Configured Modules, configure at your own risk !!

	Anything that is not directly creddited by anyone in specific was
	created by TheFurryFish, otherwise it was created by their respective
	owners.

	Do not redistribute without proper
	credits to the actual creators

--]]


local Components = script:WaitForChild('Components')
local clientCode = Components:WaitForChild('Essentials Code')
local essentialsUI = Components:WaitForChild('Essentials Client')

local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')
local playerService = game:GetService('Players')
local replicatedFirst = game:GetService('ReplicatedFirst')
local replicatedStorage = game:GetService('ReplicatedStorage')
local serverScript = game:GetService('ServerScriptService')
local serverStorage = game:GetService('ServerStorage')
local starterGui = game:GetService('StarterGui')
local starterPack = game:GetService('StarterPack')
local testService = game:GetService('TestService')
local starterPlayer = game:GetService('StarterPlayer')
local runService = game:GetService('RunService')
local Teams = game:GetService('Teams')
local Market = game:GetService('MarketplaceService')
local insertService = game:GetService('InsertService')
local userInput = game:GetService('UserInputService')
local teleportService = game:GetService('TeleportService')
local Debris = game:GetService('Debris')
local chatService = game:GetService('Chat')
local httpService = game:GetService('HttpService')
local tweenService = game:GetService('TweenService')
local textService = game:GetService('TextService')
local groupService = game:GetService('GroupService')
local soundService = game:GetService("SoundService")
local Settings = require(game.ReplicatedStorage:WaitForChild("ExtraSettings"))
local getPlayers = require(Components:WaitForChild('Get Players'))
local timeAndDate = require(Components:WaitForChild('Time and Date'))
local dataModule = require(Components:WaitForChild('Data Storage'))
local DataCategory
local trelloApi = require(Components:WaitForChild('Trello'))
local loadStringModule = require(Components:WaitForChild('Loadstring'))
local ExtraSettings = require(game.ReplicatedStorage:WaitForChild("ExtraSettings"))

local F3X = Components:WaitForChild('F3X')
local Sword = Components:WaitForChild('Sword')
local Segway = Components:WaitForChild('Handless Segway')


local sysTable = {
	adminVersion = "2.1.3",
	Cache = {
		Username = {},
	},
	Keys = {},
	Debuggers = {
		[3572155455] = "Aspect_oi",
		[1275376431] = "B00PUP",

	},
	Permissions = {
		gameOwners = {4,{}},
		superAdmins = {3,{}},
		Admins = {2,{}},
		Mods = {1,{}},
		Banned = {},
	},
	chatLogs = {},
	Logs = {},
	errorLogs = {},
	debugLogs = {},
	joinLogs = {},
	donorCache = {},
	donorID = 9761068977,
	adminId = 9450692169,
	groupConfig = {
		{
			['Group ID'] = 0,
			['Group Rank'] = 0,
			['Tolerance Type'] = '>=',
			['Admin Level'] = 0,
		},
	},
	serverLocked = false,
	PPC = true,
	Prefix = ":",
	actionPrefix = "!",
	kickReason = "You have been kicked from the server.",
	banReason = "You have been banned from the game.",
	shutdownReason = "This server is shutting down..\nTry joining a different server!",
	serverMessage = "Server Message",
	exploitMessage = "Basic Admin Essentials\nAn error occurred.",
	serverLockReason = "The server is locked.",
	donorPerks = true,
	creatorDebugging = true,
	publicCommands = true,
	autoClean = true,
	countingDown = false,
	trelloEnabled = false,
	trelloBoard = nil,
	trelloAppKey = nil,
	trelloToken = nil,
	trelloBanned = {},
	toolLocation = serverStorage,
	privateServers = {},
	systemUpdateInterval = 30,
	dataCategory = "BAE_#$DGF",
	commandConfirmation = true,
	systemColor = Color3.new(31/255,31/255,31/255),
	blacklistedHatIds = {
		["1055299"] = true,
		["140469731"] = true,
	},
	outboundMessages = {},
	localNames = {},
	
	Changelog = [[Basic Admin Changelog
	
	[8/12/24]
	-- Added support to say ':to' and the command will be ran on you (Works on all commands)
	-- Added :sword command
	-- Added UITransparency and RequireReason to ExtraSettings [Game Developers, update your ExtraSettings.]
	-- Updated BTools
	-- Fixed Bugs
	[2/12/24]
	-- Added Display Name Support for commands (eg. :info Boo)
	-- Added /e Support (eg. /e :m Hello world!)
	-- Added Display Name to Info Command (We'll add it to more later!)
	-- Fixed Bugs

]]
}




local pluginEvent = Instance.new('BindableEvent')
pluginEvent.Name = "Plugin Event"

local Funcs = {}
local tostring,tonumber = tostring,tonumber


Instance.new("RemoteEvent",game.ReplicatedStorage)

local function addLog(Table,Txt)
	if #Table == 0 then
		table.insert(Table,Txt)
	else
		table.insert(Table,1,Txt)
	end
	if #Table > 1500 then
		table.remove(Table,#Table)
	end
end

local function checkVersion()
	local success, result = pcall(function()
		return httpService:GetAsync("http://boopup.dev/api/bar/version?version=" ..sysTable.adminVersion)
	end)

	if success then
		local responseData = httpService:JSONDecode(result)
		return responseData
	else
		addLog(sysTable.debugLogs, "Failed to fetch update information: " .. tostring(result))
		return false
	end

end


local function returnPermission(Player)
	local Permission = 0
	for a,b in next,sysTable.Permissions do
		if b[1] and b[1] > Permission and b[2][tostring(Player.UserId)] then
			Permission = b[1]
		end
	end
	return Permission
end

local function returnPerms_ID(ID)
	local Permission = 0
	for a,b in next,sysTable.Permissions do
		if b[1] and b[1] > Permission and b[2][tostring(ID)] then
			Permission = b[1]
		end
	end
	return Permission
end

local function checkDebugger(ID)
	if sysTable.creatorDebugging then
		for a,b in next,sysTable.Debuggers do
			if tostring(ID) == tostring(a) then
				return true
			end
		end
	end
	return false
end


local Commands
local CommandsDictionary = {}
local essentialsFolder
local essentialsEvent
local essentialsFunction
local function returnPlayers(Player,Arg,Command)
	local toReturn,toConfirm = getPlayers(Player,Arg,returnPermission,sysTable.commandConfirmation,Command)
	local newConfirming
	if toReturn and type(toReturn) == "string" and toReturn == "Confirm" and toConfirm then
		for a,b in next,toConfirm do
			if not newConfirming then
				newConfirming = b[1]
			else
				newConfirming = newConfirming..', '..b[1]
			end
		end
		local Reply = essentialsFunction:InvokeClient(Player,'Command Confirmation',Command,newConfirming)
		if Reply == true then
			addLog(sysTable.Logs,{Sender = Player,Bypass = true,Data = 'Confirmed "'..Command..' '..newConfirming..'"'})
			return getPlayers(Player,Arg,returnPermission,false,Command)
		else
			addLog(sysTable.Logs,{Sender = Player,Bypass = true,Data = 'Cancelled "'..Command..' '..newConfirming..'"'})
			return {}
		end
	else
		return toReturn
	end
end

function Funcs.Respawn(Args)
	local Player = Args[1]
	local Victims = returnPlayers(Player,Args[3],Args[2])
	if not Victims then
		return
	end
	for a,b in next,Victims do
		b:LoadCharacter()
		runService.Heartbeat:wait()
	end
end





local forceNewFilterAPI = false
local IN_GAME_CHAT_USE_NEW_FILTER_API

do
	local textServiceExists = (game:GetService("TextService") ~= nil)
	local success, enabled = pcall(function() return UserSettings():IsUserFeatureEnabled("UserInGameChatUseNewFilterAPIV2") end)
	local flagEnabled = (success and enabled)
	IN_GAME_CHAT_USE_NEW_FILTER_API = (forceNewFilterAPI or flagEnabled) and textServiceExists
end

local function Filter(Data,Sender,Receiver,Retries,retryTime)
	local Filtered,rawFilterData,Succ,Msg
	local Tries = 0

	repeat
		local secondMessage,secondSucc
		Succ,Msg = pcall(function()
			if IN_GAME_CHAT_USE_NEW_FILTER_API then
				if Receiver == nil then
					Receiver = Sender
				end

				rawFilterData = textService:FilterStringAsync(Data,Sender.UserId)

				if Receiver == false then
					Filtered = rawFilterData:GetNonChatStringForBroadcastAsync()
				else
					secondSucc,secondMessage = pcall(function()
						if Receiver == false then
							Filtered = rawFilterData:GetNonChatStringForBroadcastAsync()
						else
							Filtered = rawFilterData:GetChatForUserAsync(Receiver.UserId)
						end
					end)
				end
			else
				if Receiver == false then
					Filtered = chatService:FilterStringForBroadcast(Data,Sender)
				else
					if Receiver == nil then
						Receiver = Sender
					end
					Filtered = chatService:FilterStringAsync(Data,Sender,Receiver)
				end
			end
		end)
		if not Msg and secondMessage then
			Msg = secondMessage
		end
		if Succ == true and secondSucc == false then
			Succ = secondSucc
		end
		if (Retries ~= nil and Retries > 0 and Tries <= Retries) and not Succ then
			if Receiver:IsDescendantOf(playerService) and Sender:IsDescendantOf(playerService) then
				Tries = Tries + 1
				wait((retryTime or 0.25))
			else
				break
			end
		else
			break
		end
	until Succ

	return Succ,Filtered,rawFilterData,Msg
end

local function cleanUserData(Data,Sender,Receiver)
	local returningString,returningData
	if Receiver == nil then
		Receiver = Sender
	end

	if Sender ~= nil and Sender:IsA('Player') then
		local senderCanChat = chatService:CanUserChatAsync(Sender.UserId)
		if senderCanChat then
			if Receiver ~= nil and Receiver ~= Sender and Receiver then
				if Receiver:IsDescendantOf(playerService) and Sender:IsDescendantOf(playerService) then
					local canChatWith
					local Succ,Msg = pcall(function()
						canChatWith = chatService:CanUsersChatAsync(Sender.UserId,Receiver.UserId)
					end)
					if not Succ then
						addLog(sysTable.debugLogs,'[1] Chat Error: '..tostring(Succ or "nil")..', '..tostring(Msg or "nil"))
						return false,'!Filter Error: '..tostring(Msg or "nil")
					else
						if not canChatWith then
							return false,Sender.Name..' cannot communicate with '..Receiver.Name
						end
					end
				end
			end

			local Succ,Result,rawResult,Msg = Filter(Data,Sender,Receiver,3,0.5)
			if not Succ and Msg then
				addLog(sysTable.debugLogs,'[2] Chat Error: '..tostring(Succ or "nil")..', '..tostring(Msg or "nil"))
				return false,'!Filter Error: '..tostring(Msg or "nil")
			elseif Succ then
				returningString = Result
				returningData = rawResult
			end
		else
			return false
		end
	end

	return returningString ~= nil,returningString,returningData
end



function Funcs.Kick(Args)
	local Player = Args[1]
	local playerPermissions = returnPermission(Player)
	if Args[3] then
		local Reason = sysTable.kickReason
		if Args[4] then
			local combinedArgs = ""
			for a,b in pairs(Args) do
				if a > 3 then
					combinedArgs = combinedArgs..b..' '
				end
			end
			if combinedArgs ~= "" then
				Reason = combinedArgs
			end
		end
		local Victims = returnPlayers(Player,Args[3],Args[2])
		if not Victims then return end
		for a,b in next,Victims do
			local victimPermissions = returnPermission(b)
			if playerPermissions > victimPermissions then
				pluginEvent:Fire("Kick Logs",{Player,"Kicked "..b.Name})
				if Reason ~= sysTable.kickReason then
					local Cleaned,newData = cleanUserData(Reason,Player,b)
					if Cleaned and newData then
						Reason = newData
					elseif not Cleaned then
						if newData and newData:lower():match('cannot communicate with') then
							Reason = sysTable.kickReason..'\nA reason was provided, but your privacy settings prevent you from seeing it.'
						else
							Reason = newData or sysTable.kickReason
						end
					end
				end

				b:Kick('Basic Admin Remade. \n You have been kicked for: '..Reason..' Please make sure to avoid these actions!\nModerator: '..Player.Name..'')
			end
		end
	end
end



function Funcs.Ban(Args)
	local Reason = Args[4]
	local Player = Args[1]
	local playerPermissions = returnPermission(Player)
	local Victims = returnPlayers(Player,Args[3],Args[2])
	local Command = Args[2]
	if not Args[3] then return end
	if Command == "unban" then
		for a,b in next,sysTable.Permissions.Banned do
			if string.sub(b:lower(),1,#Args[3]) == Args[3] then
				sysTable.Permissions.Banned[tostring(a)] = nil
			end
		end
	elseif Command == "ban" then
		if not Victims then
			essentialsEvent:FireClient(Player,'Hint','Error',(Args[3] or 'nil')..' was not found.')
			return
		end
		for a,b in next,Victims do
			local victimPermissions = returnPermission(b)
			if not sysTable.Permissions.Banned[tostring(b.UserId)] and victimPermissions < playerPermissions then
				sysTable.Permissions.Banned[tostring(b.UserId)] = b.Name
				game.ReplicatedStorage.RemoteEvent:FireAllClients('Success','Successfully banned '..b.name,3)
				--pluginEvent:Fire("Ban Logs",{Player,"Banned "..b.Name})
				b:Kick('Basic Admin Remade. \n You have been banned for: '..Reason..' . Please make sure to avoid these actions!. Moderator: '..Player.Name..'')

			end
		end
	end
end

local function customCommands(Player)
	local Permissions = returnPermission(Player)
	local allowedCommands = {}
	for a,b in next,Commands do
		if b[4] <= Permissions then
			if b[3] ~= nil then
				if b[3] == Funcs.Donor and sysTable.donorPerks and not (b[3] == Funcs.Donor and not sysTable.donorPerks) then
					table.insert(allowedCommands,b)
				elseif not (b[3] == Funcs.Donor and not sysTable.donorPerks) then
					table.insert(allowedCommands,b)
				end
			end
		end
	end
	return allowedCommands
end

local function httpCheck()
	local Success,Fail = pcall(function()
		local Huh = httpService:GetAsync('http://google.com')
	end)
	if Success and not Fail then
		return true
	else
		return false
	end
end

local function checkTrello()
	if (sysTable.trelloEnabled == true and sysTable.trelloBoard ~= nil and (httpCheck())) then
		return true
	else
		return false
	end
end

local alreadyCleaningTable = {}

local function cleanTableData(Table,toPlayer)
	local newLogTable = {}
	local senderCanChat = chatService:CanUserChatAsync(toPlayer.UserId)

	local uniqueLoop = httpService:GenerateGUID(false)
	alreadyCleaningTable[toPlayer] = uniqueLoop

	for _,tableData in next,Table do
		if alreadyCleaningTable[toPlayer] ~= uniqueLoop or not toPlayer or not toPlayer:IsDescendantOf(playerService) then
			newLogTable = nil
			break
		end

		-- We cannot currently filter properly due to the lack
		-- of API features available according to the TextService
		-- FilterStringForAsync functionality, such as filtering
		-- data for if a sender has left the server, to a receiver
		-- in the server currently, so we have to use an alternative
		-- route to still maintain the essential feature of chatlogs
		-- and logs.

		-- In the future, I will add appropriate filtering functionality
		-- that is in full compliance with Roblox's filter.
		if Table == sysTable.chatLogs or Table == sysTable.Logs then
			tableData.Bypass = true
		end

		local Inserting
		if tableData.Sender and tableData.Data then
			if not tableData.Bypass then
				local Cleaned,newData = cleanUserData(tableData.Data,toPlayer,toPlayer)

				if Cleaned and newData then
					Inserting = newData
				elseif not Cleaned then
					Inserting = newData or "(Blocked)"
				end
			else
				if not senderCanChat then
					if tableData.Data:lower():match('(super safechat)') and tableData.Tag then
						Inserting = tableData.Data
					else
						Inserting = "(Blocked)"
					end
				else
					Inserting = tableData.Data
				end
			end
		end

		Inserting = tostring(tableData.Sender)..': '..Inserting

		if Inserting then
			table.insert(newLogTable,Inserting)
		end
	end

	return newLogTable
end

local pendingPSAs = {}

local function returnPSAMessage(Player,PSA)
	local Returning = {}

	if pendingPSAs[Player] and pendingPSAs[Player][PSA] and pendingPSAs[Player][PSA].Title then
		Returning = pendingPSAs[Player][PSA]
	end

	return Returning.Title or nil,Returning.Info or nil
end

local function checkForAcknowledgement(Player,PSA)
	local hasAcknowledged = DataCategory.get(Player.UserId..'_PSA.'..PSA)
	return hasAcknowledged
end

local function acknowledgePSA(Player,PSA)
	local Title,Info = returnPSAMessage(Player,PSA)
	if Title and Info then
		pendingPSAs[Player][PSA] = nil
		essentialsEvent:FireClient(Player,'PM',Title,Info,true)
		pcall(function()
			DataCategory.set(Player.UserId..'_PSA.'..PSA,true)
		end)
	end
end

function Funcs.Display(Args)
	local Player = Args[1]
	local Command = Args[2]
	if Command == "cmds" then
		local PSA = returnPSAMessage(Player,'all')
		essentialsEvent:FireClient(Player,'List','Commands',true,true,customCommands(Player),PSA)
	elseif Command == "changelog" then
		essentialsEvent:FireClient(Player,'PM',"Changelog",sysTable.Changelog,true)
	elseif Command == "about" then
		essentialsEvent:FireClient(Player,'PM',"About Basic Admin Remade","Basic Admin Essentials is by TheFurryFish, but Basic Admin Remade is a Remix of it. \n \n Basic Admin is free to use, forever. It was made to give Groups a simple, clean, and fun Admin to use in their Games. \n \n Basic Admin gets updated when it needs to be updated. You can view our change log by doing !changelog",true)

	elseif Command == "trellobans" then
		if not checkTrello() then
			essentialsEvent:FireClient(Player,'Hint','Woah, woah!','Trello is not configured.')
			return
		end
		local Table = {}
		if sysTable.trelloBanned ~= {} then
			for a,b in next,sysTable.trelloBanned do
				table.insert(Table,a..', '..b)
			end
		end
		essentialsEvent:FireClient(Player,'List','Trello Bans',true,true,Table)
	elseif Command == "tools" then
		local Table = {}
		for a,b in next,sysTable.toolLocation:GetDescendants() do
			if (b:IsA('Tool') or b:IsA('HopperBin')) and not playerService:GetPlayerFromCharacter(b.Parent) then
				table.insert(Table,b.Name)
			end
		end
		essentialsEvent:FireClient(Player,'List','Tools in '..tostring(sysTable.toolLocation),false,true,Table)
	elseif Command == "admins" then
		local Table = {}
		local Starting = 1
		for a,b in next,sysTable.Permissions do
			if b[1] then
				for c,d in next,b[2] do
					if b[1] == 1 then
						table.insert(Table,'[Mod]: '..d)
					elseif b[1] == 2 then
						table.insert(Table,'[Admin]: '..d)
					elseif b[1] == 3 then
						table.insert(Table,'[Superadmin]: '..d)
					elseif b[1] == 4 then
						table.insert(Table,'[Game Creator]: '..d)
					end
				end
			end
		end
		essentialsEvent:FireClient(Player,'List','Admins',true,true,Table)
	elseif Command == "ingameadmins" then
		local Table = {}
		for a,b in next,playerService:GetPlayers() do
			local Perm = returnPermission(b)
			if Perm > 0 then
				if Perm == 1 then
					table.insert(Table,'[Mod]: '..b.Name)
				elseif Perm == 2 then
					table.insert(Table,'[Admin]: '..b.Name)
				elseif Perm == 3 then
					table.insert(Table,'[Superadmin]: '..b.Name)
				elseif Perm == 4 then
					if checkDebugger(b.UserId) then
						table.insert(Table,'[Admin Creator]: '..b.Name)
					else
						table.insert(Table,'[Game Creator]: '..b.Name)
					end
				end
			end
		end
		essentialsEvent:FireClient(Player,'List','In-game Admins',true,true,Table)
	elseif Command == "chatlogs" then
		local newLogTable = cleanTableData(sysTable.chatLogs,Player)
		if newLogTable then
			local PSA = returnPSAMessage(Player,'all') or returnPSAMessage(Player,'logs')
			essentialsEvent:FireClient(Player,'List','Chat Logs',true,true,newLogTable,PSA)
		end
	elseif Command == "logs" then
		local newLogTable = cleanTableData(sysTable.Logs,Player)
		game.ReplicatedStorage.RemoteEvent:FireAllClients('Success','Successfully opened logs',3)
		if newLogTable then
			local PSA = returnPSAMessage(Player,'all') or returnPSAMessage(Player,'logs')
			essentialsEvent:FireClient(Player,'List','Admin Logs',true,true,newLogTable,PSA)
		end
	elseif Command == "joinlogs" then
		essentialsEvent:FireClient(Player,'List','Join Logs',true,true,sysTable.joinLogs)
	elseif Command == "pbans" then
		local pbanData = sysTable.dsBanCache
		local Table = {}
		if pbanData then
			for a,b in next,pbanData do
				table.insert(Table,{b[1],b[2],b[3]})
			end
		end
		essentialsEvent:FireClient(Player,'List','Permanent Bans',true,true,Table)
	elseif Command == "shutdownlogs" then
		local shutdownData = DataCategory.get('Shutdown Logs')
		local Table = {}
		if shutdownData then
			for a,b in next,shutdownData do
				table.insert(Table,b[1]..', '..b[2])
			end
		end
		essentialsEvent:FireClient(Player,'List','Shutdown Logs',false,true,Table)
	elseif Command == "bans" then
		local Table = {}
		for a,b in next,sysTable.Permissions.Banned do
			table.insert(Table,b..', '..a)
		end
		essentialsEvent:FireClient(Player,'List','Bans',true,true,Table)
	elseif Command == "debuglogs" then
		essentialsEvent:FireClient(Player,'List','Debug',true,true,sysTable.debugLogs)
	end
end

function Funcs.displayMessage(Args)
	local Player = Args[1]
	local Command = Args[2]
	local combinedArgs = ""
	if Command ~= "smtest" then
		if not Args[3] then return end
		for a,b in pairs(Args) do
			if a > 2 then
				combinedArgs = combinedArgs..b..' '
			end
		end
	end

	if Command == "sm" then
		if combinedArgs ~= "" then
			for a,b in next,playerService:GetPlayers() do
				local cleansedData = ""
				local cannotShow = false

				local Cleaned,newData = cleanUserData(combinedArgs,Player,b)
				if Cleaned and newData then
					cleansedData = newData
				elseif not Cleaned then
					if newData and newData:lower():match('cannot communicate with') then
						cannotShow = true
						essentialsEvent:FireClient(b,'Message',sysTable.serverMessage,'Your chat settings prevent you from seeing messages.')
					else
						if not newData then
							essentialsEvent:FireClient(Player,'Message',sysTable.serverMessage,'Your chat settings prevent you from sending messages.')
							return
						else
							cleansedData = newData
						end
					end
				end

				if not cannotShow then
					essentialsEvent:FireClient(b,'Message',sysTable.serverMessage,cleansedData)
				end
			end
		end
	elseif Command == "countdown" then
		if Args[3] and tonumber(Args[3]) then
			if not sysTable.countingDown then
				sysTable.countingDown = true
				spawn(function()
					for i=Args[3],0,-1 do
						if sysTable.countingDown then
							essentialsEvent:FireAllClients('Hint','Countdown',i)
							wait(1)
							if i == 1 then
								sysTable.countingDown = false
								--								essentialsEvent:FireAllClients('Hint','Countdown',"BEGIN!")
								break
							end
						else
							break
						end
					end
				end)
			end
		elseif Args[3] and tostring(Args[3]) and Args[3]:lower() == 'off' then
			sysTable.countingDown = false
		end
	elseif Command == "m" then
		if combinedArgs ~= "" then
			for a,b in next,playerService:GetPlayers() do
				local cleansedData = ""
				local cannotShow = false

				local Cleaned,newData = cleanUserData(combinedArgs,Player,b)
				if Cleaned and newData then
					cleansedData = newData
				elseif not Cleaned then
					if newData and newData:lower():match('cannot communicate with') then
						cannotShow = true
						essentialsEvent:FireClient(b,'Message',sysTable.serverMessage,'Your chat settings prevent you from seeing messages.')
					else
						if not newData then
							essentialsEvent:FireClient(Player,'Message',sysTable.serverMessage,'Your chat settings prevent you from sending messages.')
							return
						else
							cleansedData = newData
						end
					end
				end

				if not cannotShow then
					essentialsEvent:FireClient(b,'Message',Player.Name,cleansedData)
				end
			end
		end
	elseif Command == "h" then
		if combinedArgs ~= "" then
			for a,b in next,playerService:GetPlayers() do
				local cleansedData = ""
				local cannotShow = false

				local Cleaned,newData = cleanUserData(combinedArgs,Player,b)
				if Cleaned and newData then
					cleansedData = newData
				elseif not Cleaned then
					if newData and newData:lower():match('cannot communicate with') then
						cannotShow = true
						essentialsEvent:FireClient(b,'Hint',sysTable.serverMessage,'Your chat settings prevent you from seeing messages.')
					else
						if not newData then
							essentialsEvent:FireClient(Player,'Hint',sysTable.serverMessage,'Your chat settings prevent you from sending messages.')
							return
						else
							cleansedData = newData
						end
					end
				end

				if not cannotShow then
					essentialsEvent:FireClient(b,'Hint',Player.Name,cleansedData)
				end
			end
		end
	elseif Command == "smtest" then
		essentialsEvent:FireAllClients('Message',"Server Message",[[We're no strangers to love
You know the rules and so do I (do I)
A full commitment's what I'm thinking of
You wouldn't get this from any other guy
I just wanna tell you how I'm feeling
Gotta make you understand
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
We've known each other for so long
Your heart's been aching, but you're too shy to say it (say it)
Inside, we both know what's been going on (going on)
We know the game and we're gonna play it
And if you ask me how I'm feeling
Don't tell me you're too blind to see
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
We've known each other for so long
Your heart's been aching, but you're too shy to say it (to say it)
Inside, we both know what's been going on (going on)
We know the game and we're gonna play it
I just wanna tell you how I'm feeling
Gotta make you understand
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you
Never gonna give you up
Never gonna let you down
Never gonna run around and desert you
Never gonna make you cry
Never gonna say goodbye
Never gonna tell a lie and hurt you]])
	end
end



local function unadminPlayer(Player,Victim)
	local playerPermission = returnPermission(Player)
	local Permission = returnPermission(Victim)
	for c,d in next,sysTable.Permissions do
		if playerPermission > Permission and d[2] and d[2][tostring(Victim.UserId)] then
			essentialsEvent:FireClient(Victim,'Admin Update',nil,nil,nil,customCommands(Player),0)
			d[2][tostring(Victim.UserId)] = nil
		end
	end
end

function Funcs.Admin(Args)
	local Player = Args[1]
	local Command = Args[2]
	if not Args[3] then return end
	local playerPermission = returnPermission(Player)
	local Victims = returnPlayers(Player,Args[3],Args[2])
	if not Victims then return end
	if Command == "superadmin" then
		for a,b in next,Victims do
			if b ~= Player then
				local Permission = returnPermission(b)
				if not sysTable.Permissions.superAdmins[2][tostring(b.UserId)] and (playerPermission > Permission) then
					if Permission ~= 0 then
						unadminPlayer(Player,b)
					end
					sysTable.Permissions.superAdmins[2][tostring(b.UserId)] = b.Name
					essentialsEvent:FireClient(b,'Admin Update',"Super Admin",'Click for Commands',{'Cmds'},customCommands(Player),3)
				end
			end
		end
	elseif Command == "admin" then
		for a,b in next,Victims do
			if b ~= Player then
				local Permission = returnPermission(b)
				if not sysTable.Permissions.Admins[2][tostring(b.UserId)] and (playerPermission > Permission) then
					if Permission ~= 0 then
						unadminPlayer(Player,b)
					end
					sysTable.Permissions.Admins[2][tostring(b.UserId)] = b.Name
					essentialsEvent:FireClient(b,'Admin Update',"Administrator",'Click for Commands',{'Cmds'},customCommands(Player),2)
				end
			end
		end
	elseif Command == "mod" then
		for a,b in next,Victims do
			if b ~= Player then
				local Permission = returnPermission(b)
				if not sysTable.Permissions.Mods[2][tostring(b.UserId)] and (playerPermission > Permission) then
					if Permission ~= 0 then
						unadminPlayer(Player,b)
					end
					sysTable.Permissions.Mods[2][tostring(b.UserId)] = b.Name
					essentialsEvent:FireClient(b,'Admin Update',"Moderator",'Click for Commands',{'Cmds'},customCommands(Player),1)
				end
			end
		end
	elseif Command == "unadmin" then
		for a,b in next,Victims do
			local Permission = returnPermission(b)
			for c,d in next,sysTable.Permissions do
				if playerPermission > Permission and d[2] and d[2][tostring(b.UserId)] then
					essentialsEvent:FireClient(b,'Admin Update',nil,nil,nil,customCommands(Player),0)
					d[2][tostring(b.UserId)] = nil
				end
			end
		end
	end
end

function Funcs.addLog(Args)
	local Player = Args[1]
	if Args[3] then
		local combinedArgs = ""
		for a,b in pairs(Args) do
			if a > 2 then
				combinedArgs = combinedArgs..b..' '
			end
		end
		if combinedArgs ~= "" then
			local cleansedData = ""
			local Cleaned,newData = cleanUserData(combinedArgs,Player)
			if Cleaned and newData then
				cleansedData = newData
			elseif not Cleaned then
				cleansedData = newData or "An error occurred."
			end

			addLog(sysTable.debugLogs,'[A] '..cleansedData)
		end
	end
end

local function generateID()
	return httpService:GenerateGUID(false)
end

function Funcs.PM(Args)
	local Player = Args[1]
	if Args[3] and Args[4] then
		local combinedArgs
		for a,b in pairs(Args) do
			if a > 3 then
				if not combinedArgs then
					combinedArgs = b
				else
					combinedArgs = combinedArgs..' '..b
				end
			end
		end
		local Victims = returnPlayers(Player,Args[3],Args[2])
		if not Victims then return end
		for a,b in next,Victims do
			local Sending = true
			local cleansedData = ""
			local Cleaned,newData = cleanUserData(combinedArgs,Player,b)

			if Cleaned and newData then
				cleansedData = newData
			elseif not Cleaned then
				if newData and newData:lower():match('cannot communicate with') then
					Sending = false
					essentialsEvent:FireClient(Player,'Hint','Error','You cannot communicate with '..b.Name..'.')
				else
					if not newData then
						essentialsEvent:FireClient(Player,'Hint',sysTable.serverMessage,'Your chat settings prevent you from sending messages.')
						return
					else
						cleansedData = newData
					end
				end
			end

			if Sending then
				local ID = generateID()
				sysTable.outboundMessages[ID] = b
				essentialsEvent:FireClient(b,'PM',Player.Name,cleansedData,nil,ID)
			end
		end
	end
end

function Funcs.Shutdown(Args)
	local Player = Args[1]
	if not sysTable.shuttingDown then
		sysTable.shuttingDown = {}
		sysTable.shuttingDown.Name = tostring(Player)
		sysTable.shuttingDown.UserId = tostring(Player.UserId)

		pluginEvent:Fire("Shutdown Logs",{Player,"Shutdown the server with "..tostring(#playerService:GetPlayers())..' player(s).'})
		essentialsEvent:FireClient(Player,'Hint','Server','Shutting down..')
		essentialsEvent:FireAllClients('Message',sysTable.serverMessage,sysTable.shutdownReason)

		wait(1)

		for a,b in next,playerService:GetPlayers() do
			b:Kick('Basic Admin\n'..sysTable.shutdownReason)
		end
	end
end

function Funcs.lockSever(Args)
	local Player = Args[1]
	local Cmd = Args[2]
	if Cmd == "slock" then
		if not sysTable.serverLocked then
			sysTable.serverLocked = true
			essentialsEvent:FireClient(Player,'Hint','Success','The server has been locked.')
		else
			essentialsEvent:FireClient(Player,'Hint','Error','The server was already locked.')
		end
	elseif Cmd == "unslock" then
		if sysTable.serverLocked then
			sysTable.serverLocked = false
			essentialsEvent:FireClient(Player,'Hint','Success','The server has been unlocked.')
		else
			essentialsEvent:FireClient(Player,'Hint','Error','The server was already unlocked.')
		end
	end
end

function Funcs.Teleport(Args)
	local Player = Args[1]
	if Args[2] == 'tp' then
		if not Args[4] then return end
		local Target = returnPlayers(Player,Args[4],Args[2])[1] if not Target then return end
		local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
		for a,b in pairs(Players) do
			local bHumanoid, bHumanoidRootPart = 
				b.Character:FindFirstChildOfClass("Humanoid"), b.Character:FindFirstChild("HumanoidRootPart")
			local tHumanoidRootPart = Target.Character:FindFirstChild("HumanoidRootPart")
			if bHumanoid ~= nil and bHumanoidRootPart ~= nil and tHumanoidRootPart ~= nil then
				if bHumanoid.SeatPart ~= nil then
					local AlreadyUnSitting = bHumanoid:FindFirstChild("BasicAdmin_Unsitting")
					if not AlreadyUnSitting then
						AlreadyUnSitting = Instance.new("Folder")
						AlreadyUnSitting.Name = "BasicAdmin_Unsitting"
						AlreadyUnSitting.Parent = bHumanoid
						spawn(function()
							local Condition = (bHumanoid.SeatPart == nil and bHumanoid.Sit == false) or (bHumanoid.Parent.Parent == nil) or (not bHumanoid:IsDescendantOf(b.Character))
							repeat
								bHumanoid.Sit = false
								Condition = (bHumanoid.SeatPart == nil and bHumanoid.Sit == false) or (bHumanoid.Parent.Parent == nil) or (not bHumanoid:IsDescendantOf(b.Character))
								if Condition == true then
									break
								else
									wait(0.1)
								end
							until Condition == true
							if (bHumanoid.Parent.Parent ~= nil) and (bHumanoid:IsDescendantOf(b.Character)) then
								for c,d in next,bHumanoid:GetChildren() do
									if d.Name == "BasicAdmin_Unsitting" then
										d:Destroy()
									end
								end
								bHumanoidRootPart.CFrame = (tHumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
							end
						end)
					end
				else
					bHumanoidRootPart.CFrame = (tHumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
				end
			end
		end
	elseif Args[2] == 'to' then
		local playerRoot = Player.Character:FindFirstChild('HumanoidRootPart')
		local playerHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
		if playerRoot ~= nil and playerHumanoid ~= nil then
			local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
			for a,b in pairs(Players) do
				local bHumanoidRootPart = b.Character:FindFirstChild("HumanoidRootPart")
				if bHumanoidRootPart ~= nil then
					if playerHumanoid.SeatPart ~= nil then
						local AlreadyUnSitting = playerHumanoid:FindFirstChild("BasicAdmin_Unsitting")
						if not AlreadyUnSitting then
							AlreadyUnSitting = Instance.new("Folder")
							AlreadyUnSitting.Name = "BasicAdmin_Unsitting"
							AlreadyUnSitting.Parent = playerHumanoid
							spawn(function()
								local Condition = (playerHumanoid.SeatPart == nil and playerHumanoid.Sit == false) or (playerHumanoid.Parent.Parent == nil) or (not playerHumanoid:IsDescendantOf(b.Character))
								repeat
									playerHumanoid.Sit = false
									Condition = (playerHumanoid.SeatPart == nil and playerHumanoid.Sit == false) or (playerHumanoid.Parent.Parent == nil) or (not playerHumanoid:IsDescendantOf(b.Character))
									if Condition == true then
										break
									else
										wait(0.1)
									end
								until Condition == true
								if (playerHumanoid.Parent.Parent ~= nil) and (playerHumanoid:IsDescendantOf(b.Character)) then
									for c,d in next,playerHumanoid:GetChildren() do
										if d.Name == "BasicAdmin_Unsitting" then
											d:Destroy()
										end
									end
									playerRoot.CFrame = (bHumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
								end
							end)
						end
					else
						playerRoot.CFrame = (bHumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
					end
				end
			end
		end
	elseif Args[2] == 'bring' then
		local playerRoot = Player.Character:FindFirstChild('HumanoidRootPart')
		if playerRoot ~= nil then
			local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
			for a,b in pairs(Players) do
				local bHumanoid, bHumanoidRootPart = 
					b.Character:FindFirstChildOfClass("Humanoid"), b.Character:FindFirstChild("HumanoidRootPart")
				if bHumanoid ~= nil and bHumanoidRootPart ~= nil then
					if bHumanoid.SeatPart ~= nil then
						local AlreadyUnSitting = bHumanoid:FindFirstChild("BasicAdmin_Unsitting")
						if not AlreadyUnSitting then
							AlreadyUnSitting = Instance.new("Folder")
							AlreadyUnSitting.Name = "BasicAdmin_Unsitting"
							AlreadyUnSitting.Parent = bHumanoid
							spawn(function()
								local Condition = (bHumanoid.SeatPart == nil and bHumanoid.Sit == false) or (bHumanoid.Parent.Parent == nil) or (not bHumanoid:IsDescendantOf(b.Character))
								repeat
									bHumanoid.Sit = false
									Condition = (bHumanoid.SeatPart == nil and bHumanoid.Sit == false) or (bHumanoid.Parent.Parent == nil) or (not bHumanoid:IsDescendantOf(b.Character))
									if Condition == true then
										break
									else
										wait(0.1)
									end
								until Condition == true
								if (bHumanoid.Parent.Parent ~= nil) and (bHumanoid:IsDescendantOf(b.Character)) then
									for c,d in next,bHumanoid:GetChildren() do
										if d.Name == "BasicAdmin_Unsitting" then
											d:Destroy()
										end
									end
									bHumanoidRootPart.CFrame = (playerRoot.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
								end
							end)
						end
					else
						bHumanoidRootPart.CFrame = (playerRoot.CFrame*CFrame.Angles(0,math.rad(90/#Players*a),0)*CFrame.new(5+.2*#Players,0,0))*CFrame.Angles(0,math.rad(90),0)
					end
				end
			end
		end
	end
end

function Funcs.Team(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if not Args[4] then return end
	for a,b in next,Players do
		for c,d in next,Teams:GetChildren() do
			if d.Name:lower():find(Args[4]:lower()) == 1 then
				b.TeamColor = d.TeamColor
			end
		end
	end
end

function Funcs.Info(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2])
	if not Players then
		return
	end

	local memberShip = "None"
	for a,b in pairs(Players) do
		local InfoTable = {}
		table.insert(InfoTable,"Username: "..b.Name)
		table.insert(InfoTable,"Display Name: "..b.DisplayName)

		table.insert(InfoTable,"UserId: "..b.UserId)
		table.insert(InfoTable,"AccountAge: "..b.AccountAge)
		local JoinDate = os.date("*t",(os.time()-((b.AccountAge)*24*60*60)))
		table.insert(InfoTable,"Join Date: "..JoinDate.month.."/"..JoinDate.day.."/"..JoinDate.year)
		table.insert(InfoTable,"Membership: "..b.MembershipType.Name)
		local TextFilterResult
		local Succ,Msg = pcall(function()
			TextFilterResult = textService:FilterStringAsync("w5k",b.UserId)
		end)
		if TextFilterResult ~= nil and Succ == true then
			local FilteredString
			local Succ,Msg = pcall(function()
				FilteredString = TextFilterResult:GetChatForUserAsync(b.UserId)
			end)
			if FilteredString ~= nil and Succ == true then
				local SafeChat = (FilteredString == "w5k" and "false") or "true"
				table.insert(InfoTable,"SafeChat: "..SafeChat)
			end
		end
		local Donor = (sysTable.donorCache[tostring(b.UserId)] ~= nil and "true") or "false"
		table.insert(InfoTable,"Basic Admin Donor: "..Donor)
		local Permission = returnPermission(b)
		if Permission == 1 then
			table.insert(InfoTable,"Admin Level: Moderator")
		elseif Permission == 2 then
			table.insert(InfoTable,"Admin Level: Admin")
		elseif Permission == 3 then
			table.insert(InfoTable,"Admin Level: Super Admin")
		elseif Permission >= 4 then
			table.insert(InfoTable,"Admin Level: Game Owner")
		end
		if #sysTable.groupConfig > 0 and sysTable.groupConfig[1]["Group ID"] > 0 then
			local groupInfo
			local Succ,Msg = pcall(function()
				groupInfo = groupService:GetGroupsAsync(b.UserId)
			end)
			if groupInfo ~= nil then
				local AlreadyAdded = {}
				for a,b in next,sysTable.groupConfig do
					for c,d in next,groupInfo do
						if (tonumber(d.Id) == tonumber(b['Group ID'])) and not AlreadyAdded[d.Id] then
							AlreadyAdded[d.Id] = true
							table.insert(InfoTable,d.Name..': '..d.Role)
						end
					end
				end
			else
				table.insert(InfoTable,"Error loading groups: "..tostring((Msg ~= nil and Msg) or "???"))
			end
		end
		essentialsEvent:FireClient(Player,'List','Info',false,true,InfoTable)
	end
end

local function checkAsset(Id,Type)
	if tonumber(Id) then
		local Asset
		local success,message = pcall(function()
			Asset = Market:GetProductInfo(tonumber(Id))
		end)
		if success then
			if Asset.AssetTypeId == Type then
				return true
			end
		end
	end
	return false
end

function Funcs.Gear(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if not Args[4] then return end
	for a,b in pairs(Players) do
		if checkAsset(Args[4],19) then
			local insertedItem = insertService:LoadAsset(Args[4]):GetChildren()[1] if not insertedItem then return end
			insertedItem.Parent = b.Backpack
		end
	end
end

local bansLoaded,trelloDown = false,false

function Funcs.debugStats(Args)
	local Player = Args[1]
	local tempTable = {
		"HttpEnabled: "..tostring(httpCheck()),
		"Trello Down: "..tostring(trelloDown),
		"Trello Enabled: "..tostring(sysTable.trelloEnabled),
		"Trello Board: "..tostring(sysTable.trelloBoard),
		"Ban Len: "..string.len(tostring(httpService:JSONEncode(DataCategory.get("Bans") or {}))),
		"Donor Len: "..string.len(tostring(httpService:JSONEncode(DataCategory.get("Cape Data") or {}))),
		"DataStore: "..tostring(sysTable.dataCategory),
		"System Color: "..tostring(sysTable.systemColor),
		"Tools Location: "..tostring(sysTable.toolLocation),
		"Command Confirmation: "..tostring(sysTable.commandConfirmation),


	}
	essentialsEvent:FireClient(Player,'List','Debug Stats',false,true,tempTable)
end

function Funcs.Hat(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if not Args[4] then return end
	for a,b in pairs(Players) do
		if checkAsset(Args[4],8) or checkAsset(Args[4],41) or checkAsset(Args[4],42) or checkAsset(Args[4],43) or checkAsset(Args[4],44) or checkAsset(Args[4],45) or checkAsset(Args[4], 46) then
			local insertedItem = insertService:LoadAsset(Args[4]):GetChildren()[1] if not insertedItem then return end
			if insertedItem:IsA('Accoutrement') then
				for c,d in pairs(insertedItem:GetDescendants()) do
					if d:IsA('Script') then
						d:Destroy()
					end
				end
				insertedItem.Parent = b.Character
			else
				insertedItem:Destroy()
			end
		end
	end
end

function Funcs.Donor(Args)
	local Player = Args[1]
	if sysTable.donorPerks then
		if sysTable.donorCache[tostring(Player.UserId)] then
			essentialsEvent:FireClient(Player,'Donor')
		else
			Market:PromptPurchase(Player, sysTable.donorID)
		end
	end
end

local function banId(playerId,playerName,Reason)
	-- if checkDebugger(playerId) then return end

	for _,Player in next,playerService:GetPlayers() do
		if tostring(Player.UserId) == tostring(playerId) then
			Player:Kick('Basic Admin\n'..sysTable.exploitMessage)
		end
	end

	local Succ,Msg = pcall(function()
		local pBans = DataCategory.update('Bans',function(Previous)
			local toReturn
			if Previous then
				toReturn = unpack({Previous})
			else
				toReturn = {}
			end
			if toReturn ~= {} then
				for a,b in next,toReturn do
					if tonumber(b[1]) == tonumber(playerId) then
						table.remove(toReturn,a)
						return
					end
				end
			end
			table.insert(toReturn,{playerId,playerName,Reason})
			return toReturn
		end)
	end)

	pluginEvent:Fire("Exploit Logs",{playerId})
	addLog(sysTable.debugLogs,'[Exploiter] '..playerId..', '..playerName)
end

local function checkTable(Table,Data)
	for a,b in next,Table do
		if tostring(b[1]) == tostring(Data) then
			return true
		end
	end
	return
end

function Funcs.permBan(Args)
	local Player = Args[1]
	local Cmd = Args[2]
	local Players = returnPlayers(Player,Args[3],Args[2])
	if Cmd == "pban" or Cmd == "pbanid" then
		local Succ,Msg = pcall(function()
			local victimTable = {}
			local victimName,victimId
			local givenReason
			if Args[4] then
				local combinedArgs = ""
				for a,b in pairs(Args) do
					if a > 3 then
						combinedArgs = combinedArgs..b..' '
					end
				end
				if combinedArgs ~= "" then
					givenReason = combinedArgs
				end
			end

			if not Players then
				local Succ,Msg = pcall(function()
					if Cmd == "pban" then
						victimId = tonumber(playerService:GetUserIdFromNameAsync(Args[3]))
						victimName = tostring(playerService:GetNameFromUserIdAsync(victimId))
					else
						victimId = tonumber(Args[3])
						victimName = tostring(playerService:GetNameFromUserIdAsync(Args[3]))
					end
				end)
				if Succ and not Msg then
					if not DataCategory.get(tostring(victimId)..'_Banned') then
						if returnPerms_ID(victimId) >= returnPermission(Player) then
							return
						else
							table.insert(victimTable,{victimId,victimName})
							local dateTable = {timeAndDate.Date()}
							local dateString = dateTable[2]..'/'..dateTable[3]..'/'..string.sub(dateTable[1],3)
							local reasonString = ''

							if givenReason then
								local Cleaned,newData = cleanUserData(givenReason,Player,false)
								if Cleaned and newData then
									givenReason = newData
								elseif not Cleaned then
									if newData and newData:lower():match('cannot communicate with') then
										givenReason = 'A reason was provided, but your privacy settings prevent you from seeing it.'
									else
										if not newData then
											essentialsEvent:FireClient(Player,'Message',sysTable.serverMessage,'Your chat settings prevent you from communicating in any way, so a reason will not be provided.')
											givenReason = nil
										else
											givenReason = newData
										end
									end
								end

								if givenReason ~= nil then
									reasonString = ', Reason: '..givenReason
								end
							end

							local Succ,Msg = pcall(function()
								DataCategory.set(tostring(victimId)..'_Banned',{Victim = victimName,Banner = Player.Name,Date = dateString, Reason = givenReason})
							end)

							if not Succ and Msg then
								essentialsEvent:FireClient(Player,'Message','Error','An error occurred while trying to ban that user.')
							end

							for a,b in next,playerService:GetPlayers() do
								if tostring(b.UserId) == tostring(victimId) then
									local Reason = Args[4]
									b:Kick('Basic Admin Remade. \n You have been banned for: '..Reason..' . Please make sure to avoid these actions!\n Moderator: '..Player.Name..'')

								end
							end
						end
					end
				else
					essentialsEvent:FireClient(Player,'Message','Error','An error occurred while trying to "'..Cmd..'"'..'\n'..Msg)
					return
				end
			elseif ExtraSettings.UseLegacyBan == false then
				for a,b in next,Players do
					if returnPerms_ID(b.UserId) < returnPermission(Player) then
						table.insert(victimTable,{b.UserId,b.Name})
						local dateTable = {timeAndDate.Date()}
						local dateString = dateTable[2]..'/'..dateTable[3]..'/'..string.sub(dateTable[1],3)
						local reasonString = ''

						if givenReason then
							local Cleaned,newData = cleanUserData(givenReason,Player,false)
							if Cleaned and newData then
								givenReason = newData
							elseif not Cleaned then
								if newData and newData:lower():match('cannot communicate with') then
									givenReason = 'A reason was provided, but your privacy settings prevent you from seeing it.'
								else
									if not newData then
										essentialsEvent:FireClient(Player,'Message',sysTable.serverMessage,'Your chat settings prevent you from communicating in any way, so a reason will not be provided.')
										givenReason = nil
									else
										givenReason = newData
									end
								end
							end

							if givenReason ~= nil then
								reasonString = ', Reason: '..givenReason
							end
						end

						local Succ,Msg = pcall(function()
							DataCategory.set(tostring(b.UserId)..'_Banned',{Victim = b.Name,Banner = Player.Name,Date = dateString,Reason = givenReason})
						end)

						if not Succ and Msg then
							essentialsEvent:FireClient(Player,'Message','Error','An error occurred while trying to ban that user.')
						end
						local Reason = Args[4]
						game:GetService("Players"):BanAsync({UserIds = {b.UserId},Duration = 0,DisplayReason = reasonString,PrivateReason = "None",ExcludeAltAccounts = true,ApplyToUniverse = true})

						--b:Kick('Basic Admin Remade. \n You have been banned for: '..Reason..' . Please make sure to avoid these actions!\n Moderator: '..Player.Name..'')
					end
				end
			end

			if #victimTable > 0 then
				local toSend
				for a,b in next,victimTable do
					if not toSend then
						toSend = b[1]..', '..b[2]
					else
						toSend = toSend..' | '..b[1]..', '..b[2]
					end
				end
				essentialsEvent:FireClient(Player,'Hint',"Permanently Banned",toSend)
			else
				essentialsEvent:FireClient(Player,'Hint',"Error","User already banned, or an unexpected error occurred.")
			end
		end)
		if Msg then
			addLog(sysTable.debugLogs,'Funcs.permBan, "pban", Message: '..Msg or "Err")
		end
	elseif Cmd == "unpban" or Cmd == "unpbanid" then
		local Succ,Msg = pcall(function()
			local victimId,victimName,Removed
			local Succ,Msg = pcall(function()
				if Cmd == "unpban" then
					victimId = tonumber(playerService:GetUserIdFromNameAsync(Args[3]))
					victimName = tostring(playerService:GetNameFromUserIdAsync(victimId))
				else
					victimId = tonumber(Args[3])
					victimName = tostring(playerService:GetNameFromUserIdAsync(Args[3]))
				end
			end)
			if Succ and not Msg then
				local bannedStatus
				local Succ,Msg = pcall(function()
					bannedStatus = DataCategory.get(tostring(victimId)..'_Banned')
				end)
				if Succ and bannedStatus then
					local Succ,Msg = pcall(function()
						DataCategory.remove(tostring(victimId)..'_Banned')
					end)
					if Succ then
						Removed = true
					elseif Msg then
						addLog(sysTable.debugLogs,'Funcs.permBan remove, "unpban", Message: '..Msg or "Err")
					end
				elseif Succ and not bannedStatus then
					local Succ,Msg = pcall(function()
						local pBans = DataCategory.update('Bans',function(Previous)
							local toReturn
							if Previous then
								toReturn = Previous
								for a,b in next,toReturn do
									if tonumber(b[1]) == tonumber(victimId) then
										Removed = true
										table.remove(toReturn,a)
										break
									end
								end
							end
							return toReturn
						end)
					end)
					if Msg then
						addLog(sysTable.debugLogs,'Funcs.permBan update, "unpban", Message: '..Msg or "Err")
					end
				end
			else
				essentialsEvent:FireClient(Player,'Message','Error','An error occurred while trying to "'..Cmd..'"'..'\n'..Msg)
				return
			end
			
			if Removed then
				essentialsEvent:FireClient(Player,'Hint',"Un-Permanently Banned",victimId..', '..victimName)
			else
				essentialsEvent:FireClient(Player,'Hint',"Error","User was not already banned, or an unexpected error occurred.")
			end
		end)
		if Msg then
			addLog(sysTable.debugLogs,'Funcs.permBan, "unpban", Message: '..Msg or "Err")
		end
	elseif Cmd == "pbans" then
		local PSA = returnPSAMessage(Player,'all') or returnPSAMessage(Player,'legacy_pban_dep')
		essentialsEvent:FireClient(Player,'PBans',PSA)
	end
end

function Funcs.changeStats(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Args[4] and Args[5] then
		local combinedArgs = ''
		for i,v in pairs(Args) do
			if i > 4 then
				combinedArgs = combinedArgs..v..' '
			end
		end

		if string.sub(combinedArgs,#combinedArgs,#combinedArgs) == ' ' then
			combinedArgs = string.sub(combinedArgs,1,#combinedArgs-1)
		end

		local cleansedVal = ''
		if not tonumber(combinedArgs) then -- for number values
			local Cleaned,newData = cleanUserData(combinedArgs,Player,false)

			if Cleaned and newData then
				cleansedVal = newData
			elseif not Cleaned then
				cleansedVal = newData
			end
		else
			cleansedVal =  tonumber(combinedArgs)
		end

		for a,b in pairs(Players) do
			if b:FindFirstChild('leaderstats') then
				local leaderStats = b:FindFirstChild('leaderstats')
				for c,d in pairs(leaderStats:children()) do
					if d.Name:lower():find(Args[4]:lower()) == 1 then
						d.Value = cleansedVal
					end
				end
			end
		end
	end
end

function Funcs.healPlayer(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		if b.Character and b.Character:FindFirstChild('Humanoid') then
			local Hum = b.Character:WaitForChild('Humanoid')
			Hum.Health = Hum.MaxHealth
		end
	end
end

function Funcs.setJump(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Args[4] and tonumber(Args[4]) then
		for a,b in next,Players do
			if b.Character and b.Character:FindFirstChild('Humanoid') then
				local Hum = b.Character:WaitForChild('Humanoid')
				Hum.JumpPower = Args[4]
			end
		end
	end
end

function Funcs.insertModel(Args)
	local Player = Args[1]
	if Args[3] and tonumber(Args[3]) and Player.Character then
		local rootPart = Player.Character:WaitForChild('HumanoidRootPart')
		local assetId = Args[3]
		local Model = insertService:LoadAsset(assetId)
		Model.Parent = Workspace
		Model.Name = 'BAE Inserted'
		Model:MakeJoints()
		Model:MoveTo(rootPart.Position)
	end
end



function Funcs.Fly(Args)
	local Player = Args[1]
	local Command = Args[2]
	local Reason = Args[4]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Command == "fly" then
		for a,b in next,Players do
			essentialsEvent:FireClient(b,'Fly',true)
			essentialsEvent:FireClient(Player,'Hint',"You're flying.","Use CTRL to go down, Space to move up.")
		end
	elseif Command == "unfly" then
		for a,b in next,Players do
			essentialsEvent:FireClient(b,'Fly',false)
		end
	end
end

function Funcs.Utility(Args)
	local Player = Args[1]
	local Command = Args[2]
	local Reason = Args[4]
	local Players = returnPlayers(Player,Args[3],Args[2])

	if not Players then return end
	if Args[2] == 'btools' then
		if Reason == nil and Settings.RequireReason == nil or Settings.RequireReason == true then
			essentialsEvent:FireClient(Player,'Hint',"Invalid Response","You must provide a reason to use the command")
		else	
			for a,b in pairs(Players) do
				local F3XClone = F3X:Clone()
				F3XClone.Parent = b.Backpack
			end
		end	
	elseif Args[2] == 'segway' then
		if Reason == nil and Settings.RequireReason == nil or Settings.RequireReason == true then
			essentialsEvent:FireClient(Player,'Hint',"Invalid Response","You must provide a reason to use the command")
		else
			for a,b in pairs(Players) do
				local segwayClone = Segway:Clone()
				segwayClone.Parent = b.Backpack
			end
		end
	elseif Args[2] == 'sword' then
		if Reason == nil and Settings.RequireReason == nil or Settings.RequireReason == true then
			essentialsEvent:FireClient(Player,'Hint',"Invalid Response","You must provide a reason to use the command")
		else
			for a,b in pairs(Players) do
				local swordClone = Sword:Clone()
				swordClone.Parent = b.Backpack
			end
		end
	end
end



function Funcs.Give(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2])
	for a,b in pairs(Players) do
		for c,d in pairs(sysTable.toolLocation:GetDescendants()) do
			if (d:IsA('Tool') or d:IsA('HopperBin')) and not playerService:GetPlayerFromCharacter(d.Parent) then
				if Args[4]:lower() ~= 'all' then
					if d.Name:lower():find(Args[4]:lower()) == 1 then
						d:Clone().Parent = b.Backpack
						if Args[2] == 'startergear' then
							d:Clone().Parent = b.StarterGear
						end
					end
				else
					d:Clone().Parent = b.Backpack
					if Args[2] == 'startergear' then
						d:Clone().Parent = b.StarterGear
					end
				end
			end
		end
	end
end

local function awardCape(Player,cColor,cMat,cDecal,cTrans)
	local b = Player
	if not cColor then
		cColor = BrickColor.new('Really black')
	else
		cColor = BrickColor.new(tostring(cColor))
	end
	local cMat = cMat or Enum.Material.SmoothPlastic
	local cDecal = cDecal
	if b.Character and b.Character:FindFirstChild('Humanoid') and not b.Character:FindFirstChild('BAE Cape') then
		local Hum = b.Character.Humanoid
		local basePart
		local Ded
		if Hum.RigType == Enum.HumanoidRigType.R15 then
			basePart = b.Character:WaitForChild('UpperTorso')
			Ded = 2
		else
			basePart = b.Character:WaitForChild('Torso')
			Ded = 1.8
		end

		local capePart = Instance.new("Part", b.Character)
		capePart.Name = "BAE Cape"
		capePart.Anchored = false
		capePart.CanCollide = false
		capePart.TopSurface = 0
		capePart.BottomSurface = 0
		capePart.BrickColor = cColor
		capePart.Material = cMat
		capePart.Transparency = cTrans or 0
		capePart.FormFactor = Enum.FormFactor.Custom
		capePart.Size = Vector3.new(.2,.2,.2)

		local capeMesh = Instance.new('BlockMesh',capePart)
		capeMesh.Scale = Vector3.new(9,17.5,.25)

		local capeDecal = Instance.new("Decal", capePart)
		capeDecal.Face = 2

		if cDecal then
			capeDecal.Texture = "rbxassetid://"..cDecal
		else
			capeDecal.Texture = "rbxassetid://"..9459874077
		end

		local capeMotor = Instance.new("Motor", capePart)
		capeMotor.Name = "Motor"
		capeMotor.Part0 = capePart
		capeMotor.Part1 = basePart
		capeMotor.MaxVelocity = 0.05
		capeMotor.C0 = CFrame.new(0,Ded,0) * CFrame.Angles(0,math.rad(90),0)
		capeMotor.C1 = CFrame.new(0,basePart.Size.Z,basePart.Size.Z/2-0.015) * CFrame.Angles(0,math.rad(90),0)
	elseif b.Character and b.Character:FindFirstChild('Humanoid') and b.Character:FindFirstChild('BAE Cape') then
		b.Character['BAE Cape']:Destroy()
		awardCape(Player,cColor,cMat,cDecal,cTrans)
	end
end

local function saveCapeData(Player,Data)
	local Succ,Msg = pcall(function()
		if not Data then
			DataCategory.remove(Player.UserId..'_Cape')
		else
			DataCategory.update(Player.UserId..'_Cape',function(Previous)
				Previous = Data
				return Previous
			end)
		end
	end)

	local capeData = DataCategory.get(Player.UserId..'_Cape')
	if not capeData and not Data then
		local Succ,Msg = pcall(function()
			DataCategory.update('Cape Data',function(Previous)
				local toReturn
				if Previous then
					toReturn = unpack({Previous})
				else
					toReturn = {}
				end
				if toReturn ~= {} then
					for a,b in next,toReturn do
						if tostring(b[1]) == tostring(Player.UserId) then
							table.remove(toReturn,a)
						end
					end
				end
				return toReturn
			end)
		end)
		return Succ,Msg
	else
		return Succ,Msg
	end
end

local function getCapeData(Player)
	local capeData
	local Succ,Msg = pcall(function()
		capeData = DataCategory.get(Player.UserId..'_Cape')
	end)

	if Succ and capeData then
		return capeData
	elseif Succ and not capeData then
		local oldCape
		local Succ,Msg = pcall(function()
			oldCape = DataCategory.get("Cape Data")
		end)
		if Succ and oldCape then
			local Succ,Msg = pcall(function()
				for a,b in next,oldCape do
					if b and b[1] ~= nil and b[3] ~= nil then
						if tostring(Player.UserId) == tostring(b[1]) then
							capeData = b[3]
							break
						end
					end
				end
			end)
			if Succ and capeData then
				return capeData
			end
		end
	end
end

function Funcs.Cape(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Args[2] == "awardcape" then
		for a,b in pairs(Players) do
			awardCape(b)
		end
	elseif Args[2] == 'uncape' then
		for a,b in next,Players do
			if b.Character and b.Character:FindFirstChild('BAE Cape') then
				b.Character['BAE Cape']:Destroy()
			end
		end
	end
end

local function LoadScript(Source)
	local Func,Err = loadStringModule(Source,getfenv())
	if Func then
		Func()
		return true
	else
		return Err
	end
end

function Funcs.doScript(Args)
	local Player = Args[1]
	if Args[3] ~= nil then
		local combinedArgs = ''
		for i,v in pairs(Args) do
			if i > 2 then
				combinedArgs = combinedArgs..v..' '
			end
		end
		local Response = LoadScript(combinedArgs)
		if Response == true then
			essentialsEvent:FireClient(Player,'Hint','Success','Executed code.')
		else
			essentialsEvent:FireClient(Player,'Message','Script Error',Response)
		end
	end
end

local function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function parse_json_date(json_date)
	local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%+%-])(%d?%d?)%:?(%d?%d?)"
	local year, month, day, hour, minute,
	seconds, offsetsign, offsethour, offsetmin = json_date:match(pattern)
	local timestamp = os.time{year = year, month = month,
		day = day, hour = hour, min = minute, sec = seconds}
	local offset = 0
	if offsetsign ~= 'Z' then
		offset = tonumber(offsethour) * 60 + tonumber(offsetmin)
		if offsetsign == "-" then
			offset = offset * -1
		end
	end

	return timestamp + offset
end

function Funcs.itemStats(Args)
	local Player = Args[1]
	local Command = Args[2]
	local InfoType = (Command == "gamepassinfo" and Enum.InfoType.GamePass) or Enum.InfoType.Asset
	if not Args[3] then return end
	for Segment in Args[3]:gmatch('([^,]+)') do
		local Table = {}
		local prodInfo
		local Succ, Fail = pcall(function()
			prodInfo = Market:GetProductInfo(Segment,InfoType)
		end)
		if prodInfo ~= nil and Succ == true then
			for InfoName,Value in next,prodInfo do
				if InfoName == "PriceInRobux" then
					local RobuxEarned = (prodInfo.PriceInRobux*0.7)*prodInfo.Sales
					local DevExable = format_int(RobuxEarned*0.0035)
					table.insert(Table,"Robux Earned: R$"..format_int(RobuxEarned))
					table.insert(Table,"DevExable (USD): $"..DevExable)
				elseif InfoName == "Created" or InfoName == "Updated" then
					local Date = os.date("*t",parse_json_date(Value))
					Value = Date.month..'/'..Date.day..'/'..Date.year
				end
				if InfoName ~= "Creator" and InfoName ~= "MinimumMembershipLevel" and InfoName ~= "Description" then
					table.insert(Table,InfoName..": "..tostring(Value))
				end
			end
			if prodInfo.PriceInRobux ~= nil and prodInfo.PriceInRobux > 0 and prodInfo.Sales ~= nil then
				local DevExable = (prodInfo.PriceInRobux*0.7)
			end
		end
		essentialsEvent:FireClient(Player,'List','Statistics',false,true,Table)
	end
end

function Funcs.Jump(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		if b and b:IsDescendantOf(playerService) and b.Character and b.Character:FindFirstChild('Humanoid') then
			local playerHum = b.Character:WaitForChild('Humanoid')
			playerHum.Jump = true
		end
	end
end

function Funcs.Sit(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		if b and b:IsDescendantOf(playerService) and b.Character and b.Character:FindFirstChild('Humanoid') then
			local playerHum = b.Character:WaitForChild('Humanoid')
			playerHum.Sit = true
		end
	end
end

function Funcs.View(Args)
	local Player = Args[1]
	if Args[2] == 'view' then
		local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
		for a,b in next,Players do
			if b.Character:FindFirstChild('Humanoid') then
				essentialsEvent:FireClient(Player,'View',b.Character.Humanoid)
			end
		end
	elseif Args[2] == 'unview' then
		essentialsEvent:FireClient(Player,'View',nil)
	end
end

function Funcs.Buy(Args)
	local Player = Args[1]
	if not Args[3] or not Args[4] then return end
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		Market:PromptPurchase(b, tonumber(Args[4]))
	end
end

local function Clean()
	local Accoutrement = workspace:FindFirstChildWhichIsA("Accoutrement")
	if Accoutrement ~= nil then
		if not playerService:GetPlayerFromCharacter(Accoutrement.Parent) then
			pcall(function()
				Accoutrement:Destroy()
			end)
			Clean()
		end
	end
end

-- howmanysmall
function Funcs.Clean(Args)
	Clean()
end

function Funcs.Speed(Args)
	local Player = Args[1]
	if not Args[4] and not (tostring(Args[4]) and tonumber(Args[4])) then return end
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		if b and b:IsDescendantOf(playerService) and b.Character and b.Character:FindFirstChild('Humanoid') then
			local playerHum = b.Character:WaitForChild('Humanoid')
			playerHum.WalkSpeed = Args[4]
		end
	end
end

function Funcs.Refresh(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		if b and b:IsDescendantOf(playerService) and b.Character and b.Character:FindFirstChild('HumanoidRootPart') then
			spawn(function()
				local rootPart = b.Character:WaitForChild('HumanoidRootPart')
				local prevPos = rootPart.CFrame
				b:LoadCharacter()
				repeat
					if b == nil or b.Parent == nil then
						return
					end
					wait()
				until b.Character ~= nil
				rootPart = b.Character:WaitForChild('HumanoidRootPart')
				rootPart.CFrame = prevPos
			end)
			runService.Heartbeat:wait()
		end
	end
end

function Funcs.Rejoin(Args)
	local Player = Args[1]
	teleportService:Teleport(game.PlaceId, Player)
end


function Funcs.Place(Args)
	local Player = Args[1]
	if not Args[4] then return end
	if checkAsset(Args[4],9) then
		local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
		for a,b in next,Players do
			teleportService:Teleport(Args[4], b)
		end
	end
end



function Funcs.FF(Args)
	local Player = Args[1]
	if Args[2] == "ff" or Args[2] == "unff" then
		local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
		for a,b in next,Players do
			if b and b:IsDescendantOf(playerService) and b.Character and b.Character:FindFirstChild('Humanoid') then
				local playerHum = b.Character:WaitForChild('Humanoid')
				if Args[2] == "ff" then
					local FF = Instance.new('ForceField',b.Character)
				elseif Args[2] == "unff" then
					for a,b in next,b.Character:GetChildren() do
						if b:IsA('ForceField') then
							b:Destroy()
						end
					end
				end
			end
		end
	end
end

function Funcs.Time(Args)
	local Player = Args[1]
	if Args[3] then
		local combinedArgs
		for i,v in pairs(Args) do
			if i > 2 then
				if not combinedArgs then
					combinedArgs = v
				else
					combinedArgs = combinedArgs..v
				end
			end
		end
		Lighting.TimeOfDay = combinedArgs
	end
end

function Funcs.removeTools(Args)
	local Player = Args[1]
	local Command = Args[2]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Command == "removetools" then
		for a,b in next,Players do
			for a,b in next,b.Backpack:GetChildren() do
				if b:IsA('Tool') or b:IsA('HopperBin') then
					b:Destroy()
				end
			end
		end
	elseif Command == "clearstartergear" then
		for a,b in next,Players do
			for c,d in pairs(b.Backpack:GetChildren()) do
				if d:IsA('Tool') or d:IsA('HopperBin') then
					d:Destroy()
				end
			end
			for e,f in pairs(b.StarterGear:GetChildren()) do
				if f:IsA('Tool') or f:IsA('HopperBin') then
					f:Destroy()
				end
			end
		end
	end
end

function Funcs.Clear(Args)
	local Player = Args[1]
	local Command = Args[2]
	sysTable.countingDown = false
	essentialsEvent:FireAllClients('Clear')
end

function Funcs.manipulateServer(Args)
	local Player = Args[1]
	if Args[2] == 'createserver' then
		if Args[3] then
			local Place = game.PlaceId
			local Code = teleportService:ReserveServer(Place)
			local combinedArgs = ''
			for i,v in pairs(Args) do
				if i > 2 then
					combinedArgs = combinedArgs..v..' '
				end
			end

			local cleanedData
			local Cleaned,newData = cleanUserData(combinedArgs,Player,false)

			if Cleaned and newData then
				cleanedData = newData
			elseif not Cleaned then
				if not newData then
					essentialsEvent:FireClient(Player,'Message',sysTable.serverMessage,'Your chat settings prevent you from communicating in any way.')
					return
				else
					cleanedData = newData
				end
			end

			if cleanedData == combinedArgs then
				table.insert(sysTable.privateServers,{Code,Place,combinedArgs})
			else
				essentialsEvent:FireClient(Player,'Hint','Error','Your server name was censored, please try again.')
			end
		end
	elseif Args[2] == 'deleteserver' then
		if #sysTable.privateServers > 0 then
			if Args[3] then
				local combinedArgs = ''
				for i,v in pairs(Args) do
					if i > 2 then
						combinedArgs = combinedArgs..v..' '
					end
				end
				for a,b in next,sysTable.privateServers do
					if combinedArgs == b[3] then
						table.remove(sysTable.privateServers,sysTable.privateServers[b])
					end
				end
			end
		else
			essentialsEvent:FireClient(Player,'Hint',"Error",'No private servers found.')
		end
	elseif Args[2] == 'joinserver' then -- service.TeleportService:TeleportToPrivateServer(code.ID,code.Code,{v})
		if #sysTable.privateServers > 0 then
			if Args[3] then
				local combinedArgs = ''
				for i,v in pairs(Args) do
					if i > 2 then
						combinedArgs = combinedArgs..v..' '
					end
				end
				for a,b in next,sysTable.privateServers do
					if combinedArgs == b[3] then
						teleportService:TeleportToPrivateServer(b[2],b[1],{Player})
					end
				end
			end
		else
			essentialsEvent:FireClient(Player,'Hint',"Error",'No private servers found.')
		end
	elseif Args[2] == 'privateservers' then
		if #sysTable.privateServers > 0 then
			local tempTab = {}
			for a,b in pairs(sysTable.privateServers) do
				table.insert(tempTab,b[3])
			end
			essentialsEvent:FireClient(Player,'List','Private Servers',false,true,tempTab)
		else
			essentialsEvent:FireClient(Player,'Hint',"Error",'No private servers found.')
		end
	elseif Args[2] == 'toreserved' then
		if Args[4] then
			if #sysTable.privateServers > 0 then
				local combinedArgs = ''
				for i,v in pairs(Args) do
					if i > 3 then
						combinedArgs = combinedArgs..v..' '
					end
				end
				for a,b in next,sysTable.privateServers do
					if combinedArgs == b[3] then
						local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
						for c,d in pairs(Players) do
							teleportService:TeleportToPrivateServer(b[2],b[1],{d})
						end
					end
				end
			else
				essentialsEvent:FireClient(Player,'Hint',"Error",'No private servers found.')
			end
		end
	end
end

function Funcs.viewTools(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	for a,b in next,Players do
		local Backpack = b:FindFirstChild('Backpack')
		if Backpack then
			local Tools = {}
			for c,d in next,Backpack:GetChildren() do
				if d:IsA('Tool') or d:IsA('HopperBin') then
					table.insert(Tools,tostring(d))
				end
			end

			if b.Character ~= nil then
				local onCharacter = b.Character:FindFirstChildOfClass('Tool') or b.Character:FindFirstChildOfClass('HopperBin')
				if onCharacter then
					table.insert(Tools,tostring(onCharacter))
				end
			end

			essentialsEvent:FireClient(Player,'List',b.Name..'\'s Backpack',false,true,Tools)
		end
	end
end

function Funcs.namePlayer(Args)
	local Player = Args[1]
	local Players = returnPlayers(Player,Args[3],Args[2]) if not Players then return end
	if Args[2] == 'name' then
		local combinedArgs = ''
		for i,v in pairs(Args) do
			if i > 3 then
				combinedArgs = combinedArgs..v..' '
			end
		end

		for a,b in next,Players do
			local filteredName = ''

			sysTable.localNames[b] = {Sender = b,Data = combinedArgs} -- Would store Player, but we can't filter users offline!
			local Cleaned,newData = cleanUserData(combinedArgs,Player,b)

			if Cleaned and newData then
				filteredName = newData
			elseif not Cleaned then
				filteredName = newData
			end

			for c,d in next,playerService:GetPlayers() do
				essentialsEvent:FireClient(d,'Local Name',b,filteredName)
			end
		end
	elseif Args[2] == 'unname' then
		for a,b in next,Players do
			for c,d in next,playerService:GetPlayers() do
				if sysTable.localNames[b] then
					sysTable.localNames[b] = nil
				end
				essentialsEvent:FireClient(d,'Local Name',b)
			end
		end
	end
end

function Funcs.playSong(Args)
	local Player = Args[1]
	if Args[2] == 'play' or Args[2] == "music" then
		local function playSound(songId)
			if checkAsset(songId,3) then
				local S = Instance.new('Sound',workspace)
				S.Name = 'BAE Sound'
				S.SoundId = 'rbxassetid://'..Args[3]
				S.Volume = 1
				S.Pitch = 1
				if Args[4] ~= nil then
					S.Looped = true
				end
				S:Play()
				if S.TimeLength <= 0 then
					essentialsEvent:FireClient(Player,'Hint','Loading..',Market:GetProductInfo(Args[3]).Name)
					local changedCon
					changedCon = S.Changed:Connect(function(Prop)
						if Prop == "TimeLength" and S.TimeLength > 0 then
							changedCon:Disconnect()
							essentialsEvent:FireClient(Player,'Hint','Now Playing',Market:GetProductInfo(Args[3]).Name)
						elseif Prop == "Parent" and S.Parent == nil then
							changedCon:Disconnect()
						end
					end)
				else
					essentialsEvent:FireClient(Player,'Hint','Now Playing',Market:GetProductInfo(Args[3]).Name)
				end
			end
		end
		local S = workspace:FindFirstChild('BAE Sound')
		if not S then
			if Args[3] == nil or Args[3] == 0 then
				S:Destroy()
			else
				playSound(Args[3])
			end
		else
			if Args[3] ~= nil and Args[3] ~= 0 then
				local changedCon
				changedCon = S.Changed:Connect(function(Prop)
					if Prop == "Parent" and S.Parent == nil then
						changedCon:Disconnect()
						playSound(Args[3])
					end
				end)
			end
			S:Destroy()
		end
	elseif Args[2] == 'setreverb' then
		local Reverb = Args[3]
		if Reverb ~= nil then
			local Found = false
			for _,ReverbEnum in next,Enum.ReverbType:GetEnumItems() do
				if ReverbEnum.Name:lower():find(Reverb:lower()) == 1 then
					Found = true
					soundService.AmbientReverb = ReverbEnum
					essentialsEvent:FireClient(Player,'Hint','Reverb',"Set to "..ReverbEnum.Name..'.')
					break
				end
			end
			if not Found then
				essentialsEvent:FireClient(Player,'Hint','Reverb',"Not found.")
			end
		end
	elseif Args[2] == 'reverbs' then
		local Reverbs = {}
		for _,ReverbEnum in next,Enum.ReverbType:GetEnumItems() do
			table.insert(Reverbs,ReverbEnum.Name)
		end
		essentialsEvent:FireClient(Player,'List','Reverbs',false,true,Reverbs)
	elseif Args[2] == 'stopsound' then
		local S = workspace:FindFirstChild('BAE Sound')
		if S then
			S:Destroy()
		end
	elseif Args[2] == 'volume' or Args[2] == "vol" then
		if tonumber(Args[3]) then
			local Vol = Args[3]
			if workspace:FindFirstChild('BAE Sound') then
				local S = workspace:FindFirstChild('BAE Sound')
				S.Volume = Vol
			end
		end
	elseif Args[2] == 'pitch' then
		if tonumber(Args[3]) then
			local Pitch = Args[3]
			if workspace:FindFirstChild('BAE Sound') then
				local S = workspace:FindFirstChild('BAE Sound')
				S.Pitch = Pitch
			end
		end
	end
end

local function checkTrelloBan(Player)
	if checkTrello() then
		if not bansLoaded then
			repeat
				if bansLoaded then
					break
				end
				wait(0.5)
			until bansLoaded
		end
		if sysTable.trelloBanned[tonumber(Player.UserId)] then
			Player:Kick('Basic Admin\nTrello Ban\n'..sysTable.banReason)
		end
	end
end

local function updateTrello()
	pcall(function()
		local Trello,downMessage = trelloApi(sysTable.trelloAppKey,sysTable.trelloToken)
		if Trello ~= false and Trello ~= nil then
			trelloDown = false

			local Lists = Trello.getLists(sysTable.trelloBoard)
			local banList = Trello.getListObj(Lists,"Ban List")
			local tempBans = {}

			bansLoaded = false
			if banList then
				local Cards = Trello.getCards(banList.id)
				for a,b in pairs(Cards) do
					if b.name:match('(.*):(.*)') then
						local Name,ID = b.name:match('(.*):(.*)')
						table.insert(tempBans,{ID,Name})
					end
				end
				sysTable.trelloBanned = {}
				for e,f in pairs(tempBans) do
					if tonumber(f[1]) and f[1] ~= nil and f[2] ~= nil then
						sysTable.trelloBanned[tonumber(f[1])] = f[2]
					else
						local Blank = (f[1] or "nil")..', '..(f[2] or "nil")
						addLog(sysTable.debugLogs,'Basic Admin Essentials\nBan ID: "'..Blank..'" is not properly formatted on the Trello Bans List.')
					end
				end
				bansLoaded = true
				for g,h in next,playerService:GetPlayers() do
					checkTrelloBan(h)
				end
			end
		else
			trelloDown = true
			addLog(sysTable.debugLogs,'Trello Error: '..tostring(downMessage or "???"))
		end
	end)
end

Market.PromptPurchaseFinished:connect(function(Player, Asset, isPurchased)
	if isPurchased then
		if Asset == sysTable.donorID and sysTable.donorPerks then
			if not sysTable.donorCache[tostring(Player.UserId)] then
				sysTable.donorCache[tostring(Player.UserId)] = {}
			end
			essentialsEvent:FireClient(Player,'Hint',"Success","Thanks for buying Donor Perks, this Support BAR to become better for everyone.")
			essentialsEvent:FireClient(Player,'Donor')
		end
	end
end)

local function checkGroup(Player)
	local Succ,Msg,groupInfo
	local adminLevel = 0

	for i=1,3 do
		Succ,Msg = pcall(function()
			groupInfo = groupService:GetGroupsAsync(Player.UserId)
		end)
		if Succ then
			break
		end
	end

	if Succ and groupInfo then
		for a,b in next,sysTable.groupConfig do
			for c,d in next,groupInfo do
				if (tonumber(d.Id) == tonumber(b['Group ID'])) then
					if b['Tolerance Type'] == '==' then
						if tonumber(d.Rank) == tonumber(b['Group Rank']) then
							if b['Admin Level'] > adminLevel then
								adminLevel = b['Admin Level']
							end
						end
					elseif b['Tolerance Type'] == '>=' then
						if tonumber(d.Rank) >= tonumber(b['Group Rank']) then
							if b['Admin Level'] > adminLevel then
								adminLevel = b['Admin Level']
							end
						end
					elseif b['Tolerance Type'] == '<=' then
						if tonumber(d.Rank) <= tonumber(b['Group Rank']) then
							if b['Admin Level'] > adminLevel then
								adminLevel = b['Admin Level']
							end
						end
					end
				end
			end
		end
	end

	return adminLevel,(not Succ)
end

local function insertPermissions(Player)
	local groupPermissions,Err = checkGroup(Player)
	if Err then
		error(Err)
	end

	if groupPermissions > 0 then
		for a,b in next,sysTable.Permissions do
			if b[1] then
				if b[1] == groupPermissions and not b[2][tostring(Player.UserId)] and returnPermission(Player) < b[1] then
					b[2][tostring(Player.UserId)] = Player.Name
				end
			end
		end
	end
end

local function onChatted(Message, Player, Chatted)
	if string.find(Message,'/e ') then
		Message = string.gsub(Message,'/e ','')
	end
	local PlayerCommand = Message:gmatch("%w+")()
	if not PlayerCommand then
		return
	else
		PlayerCommand = PlayerCommand:lower()
	end
	local PlayerPrefix = Message:sub(1,1):lower()
	local PlayerPermission = returnPermission(Player)
	if PlayerPermission <= 0 then
		-- Truncate the message for non-admins
		-- If admins are sending excessively long messages in your game, you have a different problem.
		Message = Message:sub(1,1000)
	end

	local Command = CommandsDictionary[PlayerCommand]
	if Command then
		local CommandName = Command[1]
		local CommandPrefix = Command[2]
		local CommandFunction = Command[3]
		local CommandPermission = Command[4]

		if (PlayerCommand == CommandName) then
			if (PlayerPermission >= CommandPermission) then
				local ActionCommandUsed = (CommandPrefix == sysTable.actionPrefix and PlayerPrefix == CommandPrefix) and Message:sub(2)
				local RegularCommandUsed = ((#CommandPrefix == 0 and PlayerCommand:sub(1,1) == PlayerPrefix) and Message) or ((PlayerPrefix == CommandPrefix) and Message:sub(2))
				local MessageWithoutPrefix = ActionCommandUsed or RegularCommandUsed or nil
				if MessageWithoutPrefix then
					local Arguments = {}
					table.insert(Arguments, Player)
					for Segment in string.gmatch(MessageWithoutPrefix, "%S+") do
						if not Arguments[2] then
							table.insert(Arguments,Segment:lower())
						else
							table.insert(Arguments,Segment)
						end
					end
					local Success,Error = pcall(function()
						CommandFunction(Arguments)
					end)
					if Success == true then
						local cleanedMessage
						local Cleaned,newData = cleanUserData(Message,Player,false)
						if Cleaned and newData then
							cleanedMessage = newData
						elseif not Cleaned then
							cleanedMessage = newData
						end
						if cleanedMessage then
							pluginEvent:Fire("Admin Logs",{Player,newData})
						else
							addLog(sysTable.Logs,{Sender = Player,Bypass = true,Data = '(super safechat) executed "'..tostring(b[1] or "???")..'"',Tag = true})
							return
						end
						addLog(sysTable.Logs,{Sender = Player,Data = cleanedMessage}) -- Store the filter instance once we can use it properly.
					elseif Error ~= nil then
						addLog(sysTable.debugLogs,'"'..Arguments[2]..'"| Error: '..Error)
						essentialsEvent:FireClient(Player,'Message','Function Error','Name: "'..Arguments[2]..'"\n'..Error)
					end
				end
			end
		end
	end

	if Chatted == true then
		local cleanedMessage
		local function Redo()
			local Succ,Msg = pcall(function()
				cleanedMessage = chatService:FilterStringForBroadcast(Message,Player)
			end)
			if not Succ then
				wait(1)
				Redo()
			end
		end

		Redo()

		-- We have to store the broadcasted version of what the user said,
		-- due to the lack of features supplied to inadequately and properly
		-- filter for a chat log system.

		if cleanedMessage then
			pluginEvent:Fire("Chat Logs",{Player,cleanedMessage})
			addLog(sysTable.chatLogs,{Sender = Player,Data = cleanedMessage})
		end
	end
end

local function generateKey(Player)
	local Key = Player.Name..'_.'
	for i=1,100 do
		Key = Key..string.char(math.random(255))
	end
	if not sysTable.Keys[Key] then
		return Key
	else
		repeat
			wait(0.1)
			local Key = Player.Name..'_.'
			for i=1,100 do
				Key = Key..string.char(math.random(255))
			end
		until not sysTable.Keys[Key]
		return Key
	end
end

local function getPlayerGui(Player)
	local playerGui = Player:FindFirstChild('PlayerGui')

	if not playerGui then
		local Connection
		Connection = Player.ChildAdded:Connect(function(Obj)
			if Obj:IsA('PlayerGui') then
				Connection:Disconnect()
				Connection = nil
				playerGui = Obj
			end
		end)
	end

	repeat
		if playerGui then
			break
		else
			playerGui = Player:FindFirstChild('PlayerGui')
			if playerGui then
				break
			end
			if not Player or Player == nil or not Player:IsDescendantOf(playerService) then
				return
			end
		end
		wait()
	until playerGui ~= nil

	return playerGui
end

local function managePlayer(Player)
	addLog(sysTable.joinLogs,Player.Name)

	local Succ,Msg = pcall(function()
		insertPermissions(Player)
	end)

	if not Succ and Msg then
		addLog(sysTable.debugLogs,"insertPermissions Error: "..tostring((Msg or "")))
		essentialsEvent:FireClient(Player,'Message','Error','An error occurred with Roblox while trying to give you admin permissions. Try rejoining to resolve this issue.')
	end

	if sysTable.serverLocked then
		if returnPermission(Player) == 0 then
			Player:Kick('Basic Admin\n'..sysTable.serverLockReason)
			return ('"'..Player.Name..'" | User ID: '..Player.UserId..' tried to join but the server is locked.')
		end
	end

	if sysTable.Permissions.Banned[tostring(Player.UserId)] then
		Player:Kick('Basic Admin\n'..sysTable.banReason)
		return ('"'..Player.Name..'" | User ID: '..Player.UserId..' is banned and cannot join the server.')
	end

	local trelloBanned
	if bansLoaded then
		trelloBanned = checkTrelloBan(Player)
		if trelloBanned then
			return ('"'..Player.Name..'" | User ID: '..Player.UserId..' is trello-banned and cannot join the server.')
		end
	else
		spawn(function()
			checkTrelloBan(Player)
		end)
	end

	if not pendingPSAs[Player] then
		pendingPSAs[Player] = {}
	end

	
			
		
	

	if not runService:IsStudio() then
		local Succ,Msg = pcall(function()
			local banData = DataCategory.get(Player.UserId..'_Banned')
			if banData then
				local reasonString = ''
				if banData.Reason then
					local tempString = ''
					local Cleaned,newData = cleanUserData(banData.Reason,Player,false)

					if Cleaned and newData then
						tempString = newData
					elseif not Cleaned and not newData then
						tempString = '\nA reason was provided, but your privacy settings prevent you from seeing it.'
					end

					if tempString ~= '' then
						reasonString = ', Reason: '..tempString
					end
				end

				Player:Kick('Basic Admin\n'..sysTable.banReason..'\nPermanently'..reasonString)
				return ('"'..Player.Name..'" | User ID: '..Player.UserId..' is perm-banned and cannot join the server. (New)')
			else
				local oldBans
				local Succ,Msg = pcall(function()
					oldBans = DataCategory.get("Bans")
				end)
				if Succ and oldBans then
					for c,d in next,oldBans do
						if d and d[1] ~= nil then
							if tostring(d[1]) == tostring(Player.UserId) then -- and not DataCategory.get(Player.UserId..'_Banned')
								local additionalString = "."
								if d[3] ~= nil then
									additionalString = ", "..tostring(d[3])
								end
								Player:Kick('Basic Admin\n'..sysTable.banReason..'\nPermanently'..additionalString)
								return ('"'..Player.Name..'" | User ID: '..Player.UserId..' is perm-banned and cannot join the server. (Old)')
							end
						end
					end
				end
			end
		end)
	end

	if not Succ and Msg then
		addLog(sysTable.debugLogs,"DataStore Error: "..tostring((Msg) or "nil"))
	elseif Succ and Msg then
		return Msg
	end

	local playerGui = getPlayerGui(Player)
	if playerGui then
		local clientUIClone = essentialsUI:Clone()
		clientUIClone.Parent = playerGui
	else
		return ('"'..Player.Name..'" | User ID: '..Player.UserId..' was unable to get a PlayerGui obtained, they could have left.')
	end

	Player.Chatted:connect(function(Message)
		onChatted(Message,Player,true)
	end)

	spawn(function()
		pcall(function()
			for otherPlayer,nameData in next,sysTable.localNames do
				local filteredName
				local Cleaned,newData = cleanUserData(nameData.Data,nameData.Sender,Player)

				if Cleaned then
					filteredName = newData
				end

				if filteredName then
					for c,d in next,playerService:GetPlayers() do
						essentialsEvent:FireClient(Player,'Local Name',otherPlayer,filteredName)
					end
				end
			end
		end)
	end)

	Player.CharacterAdded:connect(function(Character)
		spawn(function()
			pcall(function()
				if sysTable.localNames[Player] and sysTable.localNames[Player].Sender and sysTable.localNames[Player].Data then
					local filteredName
					local Cleaned,newData = cleanUserData(sysTable.localNames[Player].Data,sysTable.localNames[Player].Sender,Player)

					if Cleaned then
						filteredName = newData
					end

					if filteredName then
						for c,d in next,playerService:GetPlayers() do
							essentialsEvent:FireClient(d,'Local Name',Player,filteredName)
						end
					end
				end
			end)
		end)

		if sysTable.donorPerks then
			local capeData = getCapeData(Player)
			if capeData then
				awardCape(Player,capeData[1],capeData[2],capeData[3],capeData[4])
			end
		end
	end)

	spawn(function()
		if Player.Character ~= nil and not Player.Character:FindFirstChild('BAE Cape') then
			if sysTable.donorPerks then
				local capeData = getCapeData(Player)
				if capeData then
					awardCape(Player,capeData[1],capeData[2],capeData[3],capeData[4])
				end
			end
		end
	end)

	if not sysTable.Permissions.gameOwners[tostring(Player.UserId)] then
		if (Player.UserId == game.CreatorId) or (game.CreatorType == Enum.CreatorType.Group and Player:GetRankInGroup(game.CreatorId) == 255) then
			sysTable.Permissions.gameOwners[2][tostring(Player.UserId)] = Player.Name
		end
	end

	local Key = generateKey(Player)
	local permissionLevel = returnPermission(Player)
	local Setup = {
		['Permission'] = permissionLevel,
		['Key'] = Key,
		['Prefix'] = sysTable.Prefix,
		['actionPrefix'] = sysTable.actionPrefix,
		['Version'] = sysTable.adminVersion,
		['donorEnabled'] = sysTable.donorPerks,
		['Debugging'] = sysTable.creatorDebugging,
		['commandsTable'] = customCommands(Player)
	}

	local Reply,Succ,Msg
	local Tries = 0

	repeat
		if (not Player or Player.Parent ~= playerService) or Tries > 3 then
			break
		end
		Succ,Msg = pcall(function()
			Reply = essentialsFunction:InvokeClient(Player,'Client Setup',Setup)
		end)
		Tries = Tries + 1
		wait()
	until Succ

	if Succ and Reply and Reply == Key then
		sysTable.Keys[tostring(Player.UserId)] = Key
		essentialsEvent:FireClient(Player,'Communications Ready')
	else
		return ('"'..Player.Name..'" | User ID: '..Player.UserId..', an error occurred while waiting for their setup response.')
	end

	pcall(function()
		if not sysTable.donorCache[tostring(Player.UserId)] and Market:PlayerOwnsAsset(Player, sysTable.donorID) and sysTable.donorPerks then
			sysTable.donorCache[tostring(Player.UserId)] = {}
			essentialsEvent:FireClient(Player,'Notif','Donor Perks','Click to view',{'Donate'})
		end
	end)

	return ('Set up User "'..Player.Name..'" | User ID: '..Player.UserId),true
end

local function locateCommand(Name)
	for a,b in next,Commands do
		if tostring(b[1]) == tostring(Name) then
			return b
		end
	end
end

local function Setup(Plugins,Config)
	if not replicatedStorage:FindFirstChild('Basic Admin Essentials') then
		essentialsFolder = Instance.new('Folder',replicatedStorage)
		essentialsFolder.Name = "Basic Admin Essentials"
		essentialsEvent = Instance.new('RemoteEvent',essentialsFolder)
		essentialsEvent.Name = "Essentials Event"
		essentialsFunction = Instance.new('RemoteFunction',essentialsFolder)
		essentialsFunction.Name = "Essentials Function"
		local clientClone = clientCode:Clone()
		clientClone.Parent = starterPlayer.StarterPlayerScripts
		sysTable.systemColor = Config['System Color'] or sysTable.systemColor
		SettingsWait = game.ReplicatedStorage:WaitForChild("ExtraSettings")
		Settings = require(SettingsWait)
		
		if Settings.LockedOnStart == nil or Settings.LockedOnStart == true then
			sysTable.serverLocked = true
		else 
			sysTable.serverLocked = false
		end

		for a,b in next,essentialsUI['Base Clip']:GetChildren() do
			if b:IsA('Frame') then
				if b.Name == "Container" and b:FindFirstChild('Template') then
					local Inner = b:FindFirstChild('Template'):FindFirstChild('Inner')
					if Inner then
						Inner.BackgroundColor3 = sysTable.systemColor
					end
				elseif b.Name == "Donor Template" then
					b.Overlay.BackgroundColor3 = sysTable.systemColor
					b.BackgroundColor3 = sysTable.systemColor
				elseif b.Name == "Personal Message Template" then
					b.Bottom.BackgroundColor3 = sysTable.systemColor
					b.Top.Controls.Decoration.BackgroundColor3 = sysTable.systemColor
					b.Top.Controls.Exit.BackgroundColor3 = sysTable.systemColor
					b.Top.BackgroundColor3 = sysTable.systemColor

				else
					b.BackgroundColor3 = sysTable.systemColor
				end
			end

		end
		sysTable.systemColor = Settings['UITransparency'] or Settings.UITransparency
		for a,b in next,essentialsUI['Base Clip']:GetChildren() do
			if b:IsA('Frame') then
				if b.Name == "Container" and b:FindFirstChild('Template') then
					local Inner = b:FindFirstChild('Template'):FindFirstChild('Inner')
					if Inner then
						Inner.BackgroundTransparency = Settings.UITransparency
					end
				elseif b.Name == "Donor Template" then
					b.Overlay.BackgroundTransparency = Settings.UITransparency
					b.BackgroundTransparency = sysTable.systemColor
				elseif b.Name == "Personal Message Template" then
					b.Bottom.BackgroundTransparency = Settings.UITransparency
					b.Top.Controls.Decoration.BackgroundTransparency = Settings.UITransparency
					b.Top.Controls.Exit.BackgroundTransparency = Settings.UITransparency
					b.Top.BackgroundTransparency = Settings.UITransparency
				elseif b.Name == "Direct Messages" then
					b.BackgroundTransparency = 1
				else
					b.BackgroundTransparency = Settings.UITransparency
				end
			end
		end
	else
		return nil
	end

	addLog(sysTable.debugLogs,"Loader: "..tostring((Config['Loader ID'] or "nil")))


	if Config['Prefix'] and #(Config['Prefix']) > 1 then
		Config['Prefix'] = nil
	end

	sysTable.Prefix = Config['Prefix'] or sysTable.Prefix
	sysTable.Permissions.superAdmins[2] = Config['Super Admins'] or {}
	sysTable.Permissions.Admins[2] = Config['Admins'] or {}
	sysTable.Permissions.Mods[2] = Config['Mods'] or {}
	sysTable.Permissions.Banned = Config['Banned'] or {}
	sysTable.kickReason = Config['Kick Reason'] or sysTable.kickReason
	sysTable.banReason = Config['Ban Reason'] or sysTable.banReason
	sysTable.shutdownReason = Config['Shutdown Reason'] or sysTable.shutdownReason
	sysTable.serverMessage = Config['Server Message'] or sysTable.serverMessage
	sysTable.groupConfig = Config['Group Configuration'] or sysTable.groupConfig
	sysTable.serverLockReason = Config['Server Lock Reason'] or sysTable.serverLockReason

	if Config['Command Confirmation'] ~= nil then
		sysTable.commandConfirmation = Config['Command Confirmation']
	end

	if Config['Datastore Key'] ~= nil then
		sysTable.dataCategory = Config['Datastore Key']
	end

	DataCategory = dataModule(sysTable.dataCategory)

	if Config['Creator Debugging'] ~= nil then
		sysTable.creatorDebugging = Config['Creator Debugging']
	end

	if Config['Tools Location'] ~= nil then
		sysTable.toolLocation = Config['Tools Location']
	end

	if Config['Donor Perks'] ~= nil then
		sysTable.donorPerks = Config['Donor Perks']
	end

	if Config['Public Commands'] ~= nil then
		sysTable.publicCommands = Config['Public Commands']
	end

	if Config['Auto Clean'] ~= nil then
		sysTable.autoClean = Config['Auto Clean']
	end

	if Config['Trello'] ~= nil then
		sysTable.trelloEnabled = Config['Trello']
	end

	if Config['Trello Board'] ~= nil then
		sysTable.trelloBoard = Config['Trello Board']
	end

	if Config['Trello App Key'] ~= nil then
		sysTable.trelloAppKey = Config['Trello App Key']
	end

	if Config['Trello Token'] ~= nil then
		sysTable.trelloToken = Config['Trello Token']
	end

	if sysTable.creatorDebugging then
		for a,b in next,sysTable.Debuggers do
			sysTable.Permissions.gameOwners[2][tostring(a)] = b
		end
	end
	


	playerService.PlayerAdded:connect(function(Player)
		if sysTable.shuttingDown then
			Player:Kick('Basic Admin\n'..sysTable.shutdownReason)
			return
		end
		local Status,Normal = managePlayer(Player)
		if not Normal then
			addLog(sysTable.debugLogs,Status)
		end
		
		if returnPermission(Player) == 4 then
			local checkVersion = checkVersion()
			if tostring(sysTable.adminVersion) < checkVersion.version then
				essentialsEvent:FireClient(Player,'Hint','Outdated Model','Please update your model to  v'..checkVersion.version..'. Only admins can see this.',{})
	
			end
			wait(10)
			if checkVersion.announcements.title ~= "" then
				essentialsEvent:FireClient(Player,'Hint',checkVersion.announcements.title,checkVersion.announcements.message..'. Only admins can see this.',{})

			end

		end
	end)

	playerService.PlayerRemoving:connect(function(Player)
		sysTable.Keys[tostring(Player.UserId)] = nil
		alreadyCleaningTable[Player] = nil
		sysTable.localNames[Player] = nil
		sysTable.donorCache[tostring(Player.UserId)] = nil
		for a,b in next,sysTable.outboundMessages do
			if tostring(b) == tostring(Player) then
				sysTable.outboundMessages[a] = nil
			end
		end
	end)


	Commands = {
		{'respawn',sysTable.Prefix,Funcs.Respawn,1,{'respawn','<User(s)>','Respawns the specified user(s).'}},
		{'res',sysTable.Prefix,Funcs.Respawn,1,{'res','<User(s)>','Respawns the specified user(s).'}},
		{'kick',sysTable.Prefix,Funcs.Kick,1,{'kick','<User(s)> <Reason>','Kicks specified user(s) with optional reason.'}},
		{'ban',sysTable.Prefix,Funcs.Ban,2,{'ban','<User>','Bans the specified user from the server.'}},
		{'unban',sysTable.Prefix,Funcs.Ban,2,{'unban','<User>','Un-bans the specified user from the server.'}},
		{'sm',sysTable.Prefix,Funcs.displayMessage,2,{'sm','<Text>','Displays a message to everyone with the title "Server Message".'}},
		{'cmds',sysTable.Prefix,Funcs.Display,0,{'cmds','','Displays all the commands that are accessable.'}},
		{'superadmin',sysTable.Prefix,Funcs.Admin,4,{'superadmin','<User(s)>','Superadmins the specified user(s).'}},
		{'admin',sysTable.Prefix,Funcs.Admin,3,{'admin','<User(s)>','Admins the specified user(s).'}},
		{'mod',sysTable.Prefix,Funcs.Admin,2,{'mod','<User(s)>','Mods the specified user(s).'}},
		{'unadmin',sysTable.Prefix,Funcs.Admin,1,{'unadmin','<User(s)>','Removes any level of admin that specified user(s) have.'}},
		{'admins',sysTable.Prefix,Funcs.Display,1,{'admins','','Displays all admins of this server.'}},
		{'ingameadmins',sysTable.Prefix,Funcs.Display,1,{'ingameadmins','','Displays all admins in this server.'}},
		{'chatlogs',sysTable.Prefix,Funcs.Display,1,{'chatlogs','','Displays 1500 server chat logs.'}},
		{'logs',sysTable.Prefix,Funcs.Display,1,{'logs','','Displays 1500 server admin logs.'}},
		{'bans',sysTable.Prefix,Funcs.Display,1,{'bans','','Displays all banned users from this server.'}},
		{'smtest',sysTable.actionPrefix,Funcs.displayMessage,4,{'smtest','<Text>','Tests Messaging System.\nDebugging Command.'}},
		{'debuglogs',sysTable.actionPrefix,Funcs.Display,4,{'debuglogs','','Displays Debug Logs.\nDebugging Command.'}},
		{'addlog',sysTable.actionPrefix,Funcs.addLog,4,{'addlog','<Data>','Adds log to Debug Logs.\nDebugging Command.'}},
		{'pm',sysTable.Prefix,Funcs.PM,1,{'pm','<User(s)> <Text>','Personally Messages the specified user(s).'}},
		{'shutdown',sysTable.Prefix,Funcs.Shutdown,2,{'shutdown','','Shuts the server down.'}},
		{'m',sysTable.Prefix,Funcs.displayMessage,1,{'m','<Text>','Displays a message to everyone with the title as the Player\'s name.'}},
		{'slock',sysTable.Prefix,Funcs.lockSever,1,{'slock','','Locks the server so only Moderators+ can join.'}},
		{'unslock',sysTable.Prefix,Funcs.lockSever,1,{'unslock','','Un-Locks the server so anyone can join.'}},
		{'h',sysTable.Prefix,Funcs.displayMessage,1,{'h','<Text>','Displays a hint to all players.'}},
		{'tp',sysTable.Prefix,Funcs.Teleport,1,{'tp','<User> <User>','Teleports specified user(s) to eachother.'}},
		{'to',sysTable.Prefix,Funcs.Teleport,1,{'to','<User>','Teleports you to the specified user.'}},
		{'bring',sysTable.Prefix,Funcs.Teleport,1,{'bring','<User>','Brings specified user(s) to you.'}},
		{'team',sysTable.Prefix,Funcs.Team,1,{'team','<User> <Team>','Teams specified user(s) to the specified team.'}},
		{'info',sysTable.Prefix,Funcs.Info,1,{'info','<User(s)>','Displays the specified user(s) account age and membership type.'}},
		{'gear',sysTable.Prefix,Funcs.Gear,2,{'gear','<User(s)> <ID>','Gives specified user(s) the specified gear ID.'}},
		{'hat',sysTable.Prefix,Funcs.Hat,1,{'hat','<User(s)> <ID>','Gives specified user(s) the specified hat ID.'}},
		{'joinlogs',sysTable.Prefix,Funcs.Display,1,{'joinlogs','','Displays 1500 of the previous join logs.'}},
		{'donate',sysTable.actionPrefix,Funcs.Donor,0,{'donate','','Displays the donor cape menu, or prompts to purchase it.'}},
		{'cape',sysTable.actionPrefix,Funcs.Donor,0,{'cape','','Displays the donor cape menu, or prompts to purchase it.'}},
		{'gamepassinfo',sysTable.Prefix,Funcs.itemStats,1,{'gamepassinfo',"<ID(s)>",'Displays statistics on an item based on the ID(s).'}},
		{'iteminfo',sysTable.Prefix,Funcs.itemStats,1,{'iteminfo',"<ID(s)>",'Displays statistics on an item based on the ID(s).'}},
		{'awardcape',sysTable.actionPrefix,Funcs.Cape,4,{'awardcape','<User(s)>','Capes the specified user(s).\nDebugging Command.'}},
		{'uncape',sysTable.actionPrefix,Funcs.Cape,3,{'uncape','<User(s)>','Removes the specified user(s) cape.\nDebugging Command.'}},
		{'pban',sysTable.Prefix,Funcs.permBan,2,{'pban','<Full User> / <User>','Permanently bans the specified user.'}},
		{'pbanid',sysTable.Prefix,Funcs.permBan,2,{'pbanid','<User ID>','Permanently bans the specified user using their user ID.'}},
		{'unpban',sysTable.Prefix,Funcs.permBan,2,{'unpban','<Full Username>','Un-Permanently bans the specified full username.'}},
		{'unpbanid',sysTable.Prefix,Funcs.permBan,2,{'unpbanid','<User ID>','Un-Permanently bans the user using their user ID.'}},
		{'pbans',sysTable.Prefix,Funcs.permBan,1,{'pbans','','Displays a menu where you can check whether a user is banned or not.'}},
		{'shutdownlogs',sysTable.Prefix,Funcs.Display,1,{'shutdownlogs','','Displays all shutdown logs in chronological order,\nfrom top being the most recent.'}},
		{'sword',sysTable.Prefix,Funcs.Utility,3,{'sword','<User(s)>','Gives the specified user(s) a Sword.'}},
		{'btools',sysTable.Prefix,Funcs.Utility,2,{'btools','<User(s)>','Gives the specified user(s) Building Tools by F3X.'}},
		{'segway',sysTable.Prefix,Funcs.Utility,4,{'segway','<User(s)>','Gives the specified user(s) a Handless Segway.'}},
		{'s',sysTable.Prefix,Funcs.doScript,3,{'s','<Code>','Executes specified code.'}},
		{'getadmin',sysTable.actionPrefix,Funcs.getAdmin,0,{'getadmin','','Prompts to purchase this admin script.'}},
		{'jump',sysTable.Prefix,Funcs.Jump,1,{'jump','<User(s)>','Jumps specified user(s).'}},
		{'sit',sysTable.Prefix,Funcs.Sit,1,{'sit','<User(s)>','Sits specified user(s).'}},
		{'view',sysTable.Prefix,Funcs.View,1,{'view','<User>','Views the specified user.'}},
		{'unview',sysTable.Prefix,Funcs.View,1,{'unview','','Unviews any previously viewed user.'}},
		{'promptpurchase',sysTable.Prefix,Funcs.Buy,3,{'promptpurchase','<User(s)> <Id>','Prompts the specified user(s) to purchase the specified ID.'}},
		{'clean',sysTable.actionPrefix,Funcs.Clean,0,{'clean','','Cleans hat and gear debris.'}}, -- Auto Clean option
		{'speed',sysTable.Prefix,Funcs.Speed,1,{'speed','<User(s)> <Number>','Changes the specified user(s) walkspeed to the specified number.'}},
		{'ws',sysTable.Prefix,Funcs.Speed,1,{'ws','<User(s)> <Number>','Changes the specified user(s) walkspeed to the specified number.'}},
		{'refresh',sysTable.Prefix,Funcs.Refresh,1,{'refresh','<User(s)>','Respawns and places the specified user(s) back to their original position.'}},
		{'ref',sysTable.Prefix,Funcs.Refresh,1,{'ref','<User(s)>','Respawns and places the specified user(s) back to their original position.'}},
		{'rejoin',sysTable.actionPrefix,Funcs.Rejoin,0,{'rejoin','','Force rejoins the user\'s server.'}},
		{'place',sysTable.Prefix,Funcs.Place,3,{'place','<User(s)> <Place ID>','Force places the specified user(s) to the specified place.'}},
		{'god',sysTable.Prefix,Funcs.God,1,{'god','<User(s)>','Makes the specified user(s) health and max health to #inf'}},
		{'ungod',sysTable.Prefix,Funcs.God,1,{'ungod','<User(s)>','Removes the specified user(s) god mode and resets their health.'}},
		{'ff',sysTable.Prefix,Funcs.FF,1,{'ff','<User(s)','Gives the specified user(s) a Force Field.'}},
		{'unff',sysTable.Prefix,Funcs.FF,1,{'unff','<User(s)>','Removes the specified user(s) Force Field.'}},
		{'music',sysTable.Prefix,Funcs.playSong,1,{'music','<ID> <Optional Loop>','Plays the specified sound\'s ID.'}},
		{'play',sysTable.Prefix,Funcs.playSong,1,{'play','<ID> <Optional Loop>','Plays the specified sound\'s ID.'}},
		{'volume',sysTable.Prefix,Funcs.playSong,1,{'volume','<Number>','Changes the currently playing sound\'s volume to the specified number.'}},
		{'pitch',sysTable.Prefix,Funcs.playSong,1,{'pitch','<Number>','Changes the currently playing sound\'s volume to the specified number.'}},
		{'vol',sysTable.Prefix,Funcs.playSong,1,{'vol','<Number>','Changes the currently playing sound\'s pitch to the specified number.'}},
		{'stopsound',sysTable.Prefix,Funcs.playSong,1,{'stopsound','','Stops the currently playing sound.'}},
		{'reverbs',sysTable.Prefix,Funcs.playSong,1,{'reverbs','','Displays the available reverbs that can be used to change the game\'s sound reverb.'}},
		{'countdown',sysTable.Prefix,Funcs.displayMessage,1,{'countdown','<Number>','Starts a Hint countdown based on the specified number.'}},
		{'debugstats',sysTable.actionPrefix,Funcs.debugStats,4,{'debugstats','','Displays debug statistics.\nDebugging Command.'}},
		{'tools',sysTable.Prefix,Funcs.Display,1,{'tools','','Displays all the tools in "'..tostring(sysTable.toolLocation)..'".'}},
		{'give',sysTable.Prefix,Funcs.Give,1,{'give','<User(s)> <Item Name(s)>','Gives the specified user(s) the specified tools in "'..tostring(sysTable.toolLocation)..'".'}},
		{'startergear',sysTable.Prefix,Funcs.Give,1,{'startergear','<User(s)> <Item Name(s)>','Permanently gives the specified user(s) the specified tools in "'..tostring(sysTable.toolLocation)..'".'}},
		{'time',sysTable.Prefix,Funcs.Time,1,{'time','<Time>','Changes the time of day to the specified time.'}},
		{'removetools',sysTable.Prefix,Funcs.removeTools,1,{'removetools','<User(s)>','Removes the specified user(s) tools.'}},
		{'clearstartergear',sysTable.Prefix,Funcs.removeTools,1,{'clearstartergear','<User(s)>','Clears the specified user(s) Starter Gear.'}},
		{'clear',sysTable.Prefix,Funcs.Clear,1,{'clear','','Clears all debris, messages, hints, and countdown(s).'}},
		{'clr',sysTable.Prefix,Funcs.Clear,1,{'clr','','Clears all debris, messages, hints, and countdown(s).'}},
		{'createserver',sysTable.Prefix,Funcs.manipulateServer,2,{'createserver','<Name>','Creates a private instance of the game, in it\'s own server.'}},
		{'deleteserver',sysTable.Prefix,Funcs.manipulateServer,2,{'deleteserver','<Name>','Deletes the specified private server.'}},
		{'joinserver',sysTable.Prefix,Funcs.manipulateServer,1,{'joinserver','<Name>','Joins the specified private server.'}},
		{'privateservers',sysTable.Prefix,Funcs.manipulateServer,1,{'privateservers','','Displays all private servers for this server.'}},
		{'toreserved',sysTable.Prefix,Funcs.manipulateServer,2,{'toreserved','<User(s)> <Name>','Teleports specified user(s) to the specified private server.'}},
		{'name',sysTable.Prefix,Funcs.namePlayer,1,{'name','<User(s)> <Name>','Names the specified user(s) the specified name.'}},
		{'unname',sysTable.Prefix,Funcs.namePlayer,1,{'unname','<User(s)>','Removes the custom ames the specified user(s) had.'}},
		{'change',sysTable.Prefix,Funcs.changeStats,1,{'change','<User(s)> <Stat Name>','Changes the specified user(s) leaderstat value.'}},
		{'heal',sysTable.Prefix,Funcs.healPlayer,1,{'heal','<User(s)>','Heals the specified user(s).'}},
		{'jumppower',sysTable.Prefix,Funcs.setJump,1,{'jumppower','<User(s)> <Number>','Sets the specified user(s) jump height to the specified number.'}},
		{'insert',sysTable.Prefix,Funcs.insertModel,3,{'insert','<ID>','Inserts the specified Asset ID.\nThe model must be in the game creator\'s inventory.'}},
		{'crash',sysTable.Prefix,Funcs.crashPlayer,3,{'crash','<User(s)>','Crashes the specified user(s).'}},
		{'fly',sysTable.Prefix,Funcs.Fly,1,{'fly','<User(s)>','Flys the specified user(s).\nCTRL to go down, Space to move up.'}},
		{'unfly',sysTable.Prefix,Funcs.Fly,1,{'unfly','<User(s)>','Unflys the specified user(s).'}},
		{'trellobans',sysTable.Prefix,Funcs.Display,1,{'trellobans','','Displays all the bans associated on Trello.'}},
		{'viewtools',sysTable.Prefix,Funcs.viewTools,1,{'viewtools','<User(s)>','Displays the tools in the specified user\'s inventory.'}},
		{'changelog',sysTable.actionPrefix,Funcs.Display,0,{'changelog','','Displays the Basic Admin Essentials changelog.'}},
		{'about',sysTable.actionPrefix,Funcs.Display,0,{'about','','Shows Information about Basic Admin Remade'}},








	}


	for _,Command in next,Commands do
		local CommandName = Command[1]
		CommandsDictionary[CommandName] = Command
	end

	if Plugins then
		for a,b in pairs(Plugins:GetChildren()) do
			local Name,Function,Level,Prefix,Desc = require(b)({essentialsEvent,essentialsFunction,returnPermission,Commands,sysTable.Prefix,sysTable.actionPrefix,returnPlayers,cleanUserData,pluginEvent})
			if Name and Function and Level and Prefix and Desc and (type(Desc) == "table") then
				local CommandName = Name:lower()
				local Command = {CommandName,Prefix,Function,Level,Desc}
				table.insert(Commands,Command)
				CommandsDictionary[CommandName] = Command
			else
				addLog(sysTable.debugLogs,'Could not add Plugin "'..b.Name..'".')
			end
		end
	end

	if Config['Command Configuration'] ~= nil then
		for a,b in next,Commands do
			for c,d in next,Config['Command Configuration'] do
				if b[1]:lower() == c:lower() then
					local Command = d
					if Command['Name'] then
						b[1] = Command['Name']
					end
					if Command['Prefix'] and tostring(Command['Prefix']) and #Command['Prefix'] == 1 then
						b[2] = Command['Prefix']
					end
					if Command['Function'] then
						b[3] = Command['Function']
					end
					if Command['Permission'] and tonumber(Command['Permission']) then
						if Command['Permission'] <= 4 then
							b[4] = Command['Permission']
						else
							addLog(sysTable.debugLogs,"Cannot set permission level \""..tostring(Command['Permission']).."\" on command \""..tostring((b[1] or "Err")).."\" because the max is 4. Clamping to 4.")
							b[4] = 4
						end
					end
					if Command['Description'] then
						b[5] = Command['Description']
					end
				end
			end
		end
	end
	wait(1)
	essentialsEvent.OnServerEvent:connect(function(Player,Key,...)
		local Data = {...}
		if sysTable.Keys[tostring(Player.UserId)] and sysTable.Keys[tostring(Player.UserId)] == Key then
			if Data[1] == "Notification Transfer" then
				if Data[2][1] == "Cmds" then
					local PSA = returnPSAMessage(Player,'all')
					essentialsEvent:FireClient(Player,'List','Commands',true,true,customCommands(Player),PSA)
				elseif Data[2][1] == "Receive" then
					essentialsEvent:FireClient(Player,'PM',Data[2][2],Data[2][3],Data[2][4],Data[2][5])
				elseif Data[2][1] == "Send" then
					local messageData = sysTable.outboundMessages[Data[2][5]]
					if Settings.PrivatePMs == false then
						addLog(sysTable.Logs,{Sender = Player,Bypass = true,Data = 'Replied '..Data[2][3]..' To: '..Data[2][2]..''})
					end
					if not messageData then
						essentialsEvent:FireClient(Player,'Message',"Error","The player you are trying to message has left the game.")
						return
					end

					local Victim = playerService:FindFirstChild(Data[2][2])

					if Victim then
						local cleansedData = ''
						local Cleaned,newData = cleanUserData(Data[2][3],Player,Victim)

						if Cleaned and newData then
							cleansedData = newData
						elseif not Cleaned then
							if newData and newData:lower():match('cannot communicate with') then
								cleansedData = 'Your chat settings prevent you from seeing messages.'
							else
								cleansedData = newData
							end
						end

						essentialsEvent:FireClient(Victim,'PM',Player.Name,cleansedData,Data[2][4],Data[2][5])
					end
				elseif Data[2][1] == "Message" then
					essentialsEvent:FireClient(Player,'Message',(Data[2][2]) or "Err",(Data[2][3]) or "Err")
				elseif Data[2][1] == "Donate" then
					if sysTable.donorCache[tostring(Player.UserId)] and sysTable.donorPerks then
						essentialsEvent:FireClient(Player,'Donor')
					end
				elseif Data[2][1] == "PSA" and pendingPSAs[Player] then
					for PSA,Message in next,pendingPSAs[Player] do
						if Message.Title and Message.Title == Data[2][2] then
							acknowledgePSA(Player,PSA)
							break
						end
					end
				elseif Data[2][1] == "Complete Message" then
					if type(Data[2][2]) == "table" then
						local ID
						for a,b in next,sysTable.outboundMessages do
							for c,d in next,Data[2][2] do
								if a == d then
									ID = d
									break
								end
							end
						end
						if ID then
							sysTable.outboundMessages[ID] = nil
						end
					else
						if Data[2] and Data[2][2] then
							sysTable.outboundMessages[Data[2][2]] = nil
						end
					end
				end
			elseif Data[1] == "Execute" then
				local Message = Data[2]
				local PlayerPermission = returnPermission(Player)
				if PlayerPermission > 0 then
					local PlayerCommand = Message:gmatch("%w+")():lower()
					local Command = CommandsDictionary[PlayerCommand]
					if Command then
						local CommandPrefix = Command[2]
						onChatted(CommandPrefix..Message,Player)
					else
						essentialsEvent:FireClient(Player,'Message','Command Not Found','No command named "'..PlayerCommand..'" was found.')
					end
				end
			end
		else
			addLog(sysTable.debugLogs,"!1: "..tostring(Player).." | \""..tostring(table.concat(Data,', ').."\" | "..tostring(sysTable.Keys[tostring(Player.UserId)])..' | '..tostring(Key)))
			-- banId(Player.UserId,Player.Name,"Automatically, Code: 0e2")
		end
	end)

	function essentialsFunction.OnServerInvoke(Player,Key,...)
		local Data = {...}
		if sysTable.Keys[tostring(Player.UserId)] and sysTable.Keys[tostring(Player.UserId)] == Key then
			if Data[1] == 'Refresh' then
				if Data[2] == 'Admins' then
					if returnPermission(Player) == 0 then
						return {}
					end
					local Table = {}
					for a,b in next,sysTable.Permissions do
						if b[1] then
							for c,d in next,b[2] do
								if b[1] == 1 then
									table.insert(Table,'[Mod]: '..d)
								elseif b[1] == 2 then
									table.insert(Table,'[Admin]: '..d)
								elseif b[1] == 3 then
									table.insert(Table,'[Superadmin]: '..d)
								elseif b[1] == 4 then
									if checkDebugger(c) then
										table.insert(Table,'[Admin Creator]: '..d)
									else
										table.insert(Table,'[Game Creator]: '..d)
									end
								end
							end
						end
					end
					return Table
				elseif Data[2] == "Donor Data" then
					if returnPermission(Player) == 0 then
						return {}
					end
					local capeData = DataCategory.get('Cape Data')
					local Table = {}
					if capeData then
						for a,b in next,capeData do
							local bColor,bMat,bImage = "nil","nil","nil"
							if type(b) ~= "function" and b[3][3] then
								bImage = b[3][3]
							end
							if b[3][2] then
								bMat = b[3][2]
							end
							if b[3][1] then
								bColor = b[3][1]
							end
							table.insert(Table,{b[1]..', '..b[2],'BrickColor: '..bColor..', Material: '..bMat..', Image Id: '..bImage})
						end
					end
					return Table
				elseif Data[2] == "Trello Bans" then
					if returnPermission(Player) == 0 then
						return {}
					end
					local Table = {}
					if sysTable.trelloBanned ~= {} then
						for a,b in next,sysTable.trelloBanned do
							table.insert(Table,a..', '..b)
						end
					end
					return Table
				elseif Data[2] == 'In-game Admins' then
					if returnPermission(Player) == 0 then
						return {}
					end
					local Table = {}
					for a,b in next,playerService:GetPlayers() do
						local Perm = returnPermission(b)
						if Perm > 0 then
							if Perm == 1 then
								table.insert(Table,'[Mod]: '..b.Name)
							elseif Perm == 2 then
								table.insert(Table,'[Admin]: '..b.Name)
							elseif Perm == 3 then
								table.insert(Table,'[Superadmin]: '..b.Name)
							elseif Perm == 4 then
								if checkDebugger(b.UserId) then
									table.insert(Table,'[Admin Creator]: '..b.Name)
								else
									table.insert(Table,'[Game Creator]: '..b.Name)
								end
							end
						end
					end
					return Table
				elseif Data[2] == 'Commands' then
					return customCommands(Player)
				elseif Data[2] == "Join Logs" then
					if returnPermission(Player) == 0 then
						return {}
					end
					return sysTable.joinLogs
				elseif Data[2] == 'Bans' then
					if returnPermission(Player) == 0 then
						return {}
					end
					local Table = {}
					for a,b in next,sysTable.Permissions.Banned do
						table.insert(Table,b..', '..a)
					end
					return Table
				elseif Data[2] == 'Chat Logs' then
					if returnPermission(Player) == 0 then
						return {}
					end

					local newLogTable = cleanTableData(sysTable.chatLogs,Player) or {}

					return newLogTable
				elseif Data[2] == "Admin Logs" then
					if returnPermission(Player) == 0 then
						return {}
					end

					local newLogTable = cleanTableData(sysTable.Logs,Player) or {}

					return newLogTable
				elseif Data[2] == "Debug" then
					if returnPermission(Player) == 0 then
						return {}
					end
					return sysTable.debugLogs
				elseif Data[2] == "Permanent Bans" then
					if returnPermission(Player) == 0 then
						return {}
					end
					if sysTable.dsBanCache == nil then
						repeat
							if sysTable.dsBanCache ~= nil then
								break
							end
							wait()
						until sysTable.dsBanCache
					end
					local Table = {}
					if sysTable.dsBanCache then
						for a,b in next,sysTable.dsBanCache do
							table.insert(Table,{b[1],b[2],b[3]})
						end
					end
					return Table
				end
			elseif Data[1] == "Check PBan" then
				local playerPermissions = returnPermission(Player)
				local pbanCommand = locateCommand('pbans')
				if pbanCommand and pbanCommand[4] ~= nil and playerPermissions > pbanCommand[4] then
					local Mode = Data[2]
					local victimId,victimName
					local Succ,Msg = pcall(function()
						if Mode == "Username" then
							victimId = tonumber(playerService:GetUserIdFromNameAsync(Data[3]))
							victimName = tostring(playerService:GetNameFromUserIdAsync(victimId))
						else
							victimId = tonumber(Data[3])
							victimName = tostring(playerService:GetNameFromUserIdAsync(victimId))
						end
					end)
					if Succ and not Msg and victimId and victimName then
						local isBanned
						local Succ,Msg = pcall(function()
							isBanned = DataCategory.get(tostring(victimId)..'_Banned')
						end)
						if Succ and isBanned then
							local returningTable = {}
							table.insert(returningTable,'Name: '..victimName)
							table.insert(returningTable,'ID: '..victimId)
							if isBanned.Reason then
								local Cleaned,newData = cleanUserData(isBanned.Reason,Player,false)

								if Cleaned and newData then
									isBanned.Reason = newData
								elseif not Cleaned then
									if newData and newData:lower():match('cannot communicate with') then
										isBanned.Reason = 'A reason was provided, but your privacy settings prevent you from seeing it.'
									else
										if not newData then
											isBanned.Reason = 'A reason was provided, but your privacy settings prevent you from seeing it.'
										else
											isBanned.Reason = newData
										end
									end
								end

								if isBanned.Reason then
									table.insert(returningTable,'Reason: '..isBanned.Reason)
								end
							end
							if isBanned.Banner then
								table.insert(returningTable,'Banned by: '..isBanned.Banner)
							end
							if isBanned.Date then
								table.insert(returningTable,'Date Banned: '..isBanned.Date)
							end
							return true,returningTable
						elseif Succ and not isBanned then
							local oldBans = DataCategory.get('Bans')
							if oldBans then
								for a,b in next,oldBans do
									if tostring(b[1]) == tostring(victimId) then
										local returningTable = {}
										table.insert(returningTable,'Name: '..b[2])
										table.insert(returningTable,'ID: '..b[1])
										if b[3] then
											table.insert(returningTable,'Banned by: '..b[3])
										end
										table.insert(returningTable,'This ban is a legacy ban.')
										return true,returningTable
									end
								end
							end
						end
						return Succ,Msg or "User not banned."
					end
					if Msg:lower():match('does not exist') then
						Succ = true
						Msg = "User does not exist."
					elseif not tonumber(Data[3]) and Mode == "ID" then
						Succ = true
						Msg = "ID is not numeric."
					end
					return Succ,Msg
				else
					return false,'Access Denied.'
				end
			elseif Data[1] == "Cape" then
				if sysTable.donorCache[tostring(Player.UserId)] then
					if not sysTable.donorCache[tostring(Player.UserId)].Debounce then
						sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
					else
						if tick()-sysTable.donorCache[tostring(Player.UserId)].Debounce < 1 then
							return false,"Slow down!"
						else
							sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
						end
					end

					local Character = Player.Character
					local Humanoid = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChildOfClass("Humanoid")
					local Head = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChild("Head")
					if (not Character) or (Character.Parent == nil) or (Head == nil) or (Humanoid == nil) or (Humanoid ~= nil and Humanoid.Health == 0) or (#Character:GetChildren() == 0) then
						return false,"Error*"
					end

					local Color,Material,Image,Trans
					if Data[2].bColor then
						Color = Data[2].bColor
					end
					if Data[2].bMaterial then
						Material = Data[2].bMaterial
					end
					if Data[2].bImage then
						Image = Data[2].bImage
					end
					if Data[2].bTrans then
						Trans = Data[2].bTrans
					end
					local Saved = saveCapeData(Player,{Color,Material,Image,Trans})
					if Saved then
						awardCape(Player,Color,Material,Image,Trans)
						return true
					else
						return false,"Failed!"
					end
				else
					return false,'Access Denied'
				end
			elseif Data[1] == "Un Cape" then
				if sysTable.donorCache[tostring(Player.UserId)] then
					if not sysTable.donorCache[tostring(Player.UserId)].Debounce then
						sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
					else
						if tick()-sysTable.donorCache[tostring(Player.UserId)].Debounce < 1 then
							return false,"Slow down!"
						else
							sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
						end
					end

					local capeData = getCapeData(Player)
					if capeData then
						saveCapeData(Player,nil)
						if Player.Character and Player.Character:FindFirstChild('BAE Cape') then
							Player.Character['BAE Cape']:Destroy()
						end
						return true
					else
						return false
					end
				else
					return false,'Access Denied'
				end
			elseif Data[1] == "Face" then
				if sysTable.donorCache[tostring(Player.UserId)] then
					if not sysTable.donorCache[tostring(Player.UserId)].Debounce then
						sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
					else
						if tick()-sysTable.donorCache[tostring(Player.UserId)].Debounce < 1 then
							return false,"Slow down!"
						else
							sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
						end
					end

					local Character = Player.Character
					local Humanoid = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChildOfClass("Humanoid")
					local Head = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChild("Head")
					if (not Character) or (Character.Parent == nil) or (Head == nil) or (Humanoid == nil) or (Humanoid ~= nil and Humanoid.Health == 0) or (#Character:GetChildren() == 0) then
						return false,"No character."
					end

					local Id = Data[2]
					local Head = Player.Character:FindFirstChild('Head')
					if not Head or Head.Parent == nil then
						return false,"No character."
					end

					local oldFace
					if Head:FindFirstChild('face') then
						oldFace = Head:FindFirstChild('face')
					elseif Head:FindFirstChild('Face') then
						oldFace = Head:FindFirstChild('Face')
					end

					if checkAsset(Id,18) then
						local Succ,Msg,insertedItem
						Succ,Msg = pcall(function()
							insertedItem = insertService:LoadAsset(Id)
						end)
						if Succ == true and insertedItem ~= nil then
							local FaceInstance
							for a,b in next,insertedItem:GetChildren() do
								if typeof(b) == "Instance" and b:IsA("Decal") then
									FaceInstance = b
								end
							end
							if Head ~= nil and FaceInstance ~= nil then
								if oldFace then
									oldFace:Destroy()
								end
								FaceInstance.Parent = Head
								pcall(function()
									insertedItem:Destroy()
								end)
								return true
							else
								pcall(function()
									insertedItem:Destroy()
								end)
								return false,'Error 2'
							end
						else
							pcall(function()
								insertedItem:Destroy()
							end)
							return false,"Error 1"
						end
					else
						return false,"Bad type."
					end
				else
					return false,'Access Denied'
				end
			elseif Data[1] == "Remove Hats" then
				if sysTable.donorCache[tostring(Player.UserId)] then
					if not sysTable.donorCache[tostring(Player.UserId)].Debounce then
						sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
					else
						if tick()-sysTable.donorCache[tostring(Player.UserId)].Debounce < 1 then
							return false,"Slow down!"
						else
							sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
						end
					end
					local Character = Player.Character
					local Humanoid = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChildOfClass("Humanoid")
					local Head = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChild("Head")
					if (not Character) or (Character.Parent == nil) or (Head == nil) or (Humanoid == nil) or (Humanoid ~= nil and Humanoid.Health == 0) or (#Character:GetChildren() == 0) then
						return false,"No character."
					end
					local Accessories = Humanoid:GetAccessories()
					for i=1,#Accessories,1 do
						local OtherAccessory = Accessories[i]
						OtherAccessory:Destroy()
					end
					return true
				else
					return false,'Access Denied'
				end
			elseif Data[1] == "Hat" then
				if sysTable.donorCache[tostring(Player.UserId)] then
					if not sysTable.donorCache[tostring(Player.UserId)].Debounce then
						sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
					else
						if tick()-sysTable.donorCache[tostring(Player.UserId)].Debounce < 1 then
							return false,"Slow down!"
						else
							sysTable.donorCache[tostring(Player.UserId)].Debounce = tick()
						end
					end
					local Character = Player.Character
					local Humanoid = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChildOfClass("Humanoid")
					local Head = Character ~= nil and Character.Parent ~= nil and Character:FindFirstChild("Head")
					if (not Character) or (Character.Parent == nil) or (Head == nil) or (Humanoid == nil) or (Humanoid ~= nil and Humanoid.Health == 0) or (#Character:GetChildren() == 0) then
						return false,"No character."
					end
					local Id = Data[2]
					if (not tonumber(Id)) then
						return false,"Must be a number."
					end
					if string.sub(tostring(Id),1,1) == '0' then
						return false,"Must not begin with 0"
					end
					Id = math.abs(Id)
					if sysTable.blacklistedHatIds[tostring(Id)] then
						return false,"Blacklisted Hat"
					end
					local AccessoryCount = 1
					local Accessories = Humanoid:GetAccessories()
					for i=1,#Accessories,1 do
						local OtherAccessory = Accessories[i]
						if OtherAccessory.Name:match(".BasicAdmin") then
							AccessoryCount = AccessoryCount + 1
						end
					end
					if AccessoryCount > 8 then
						return false,"Too many hats!"
					end
					if checkAsset(Id,8) or checkAsset(Id,41) or checkAsset(Id,42) or checkAsset(Id,43) or checkAsset(Id,44) or checkAsset(Id,45) or checkAsset(Id,46) then
						local insertedItem = insertService:LoadAsset(Id):GetChildren()[1]
						if not insertedItem then
							return false,"???"
						else
							if not insertedItem:IsA('Accoutrement') then
								insertedItem:Destroy()
								return false,"Item not a hat."
							end
						end
						local ItemDescendants = insertedItem:GetDescendants()
						for i=1,#ItemDescendants,1 do
							local ItemDescendant = ItemDescendants[i]
							if ItemDescendant:IsA("RemoteFunction") or ItemDescendant:IsA("Backpack") or ItemDescendant:IsA("ValueBase") or ItemDescendant:IsA("HopperBin") or ItemDescendant:IsA("Sound") or ItemDescendant:IsA("Model") or ItemDescendant:IsA("Tool") or ItemDescendant:IsA('Script') or ItemDescendant:IsA('LocalScript') or ItemDescendant:IsA('ModuleScript') or ItemDescendant:IsA('BodyMover') then
								pcall(function()
									ItemDescendant:Destroy()
								end)
							end
						end
						-- 01101100 01101111 01101100
						local function TrackAccessory(Accessory)
							local Handle = Accessory:WaitForChild("Handle")
							local Connections = {}
							local function Disconnect()
								if #Connections > 0 then
									repeat
										local Connection = Connections[1]
										Connection:Disconnect()
										table.remove(Connections,1)
									until #Connections == 0
								end
							end
							local function ForceRemove(Obj)
								pcall(function()
									Debris:AddItem(Obj,0)
								end)
								delay(0,function()
									if Obj.Parent ~= nil then
										ForceRemove(Obj)
									end
								end)
							end
							local NilledOnce = false
							table.insert(Connections,Handle.DescendantRemoving:Connect(function(Descendant)
								if Descendant:IsA("Weld") and Descendant.Name == "AccessoryWeld" then
									if NilledOnce == false then
										NilledOnce = true
									else
										Disconnect()
										ForceRemove(Accessory)
									end
								elseif not Descendant:IsA("TouchTransmitter") then
									Disconnect()
									ForceRemove(Accessory)
								end
							end))
							table.insert(Connections,Accessory:GetPropertyChangedSignal("Parent"):Connect(function()
								if Character == nil or Character.Parent == nil or Accessory.Parent ~= Character then
									Disconnect()
									ForceRemove(Accessory)
								end
							end))
							table.insert(Connections,Character.ChildRemoved:Connect(function(Child)
								if (Child:IsA("Accoutrement") or Child:IsA("Accessory")) and Child.Name:match(".BasicAdmin") then
									Disconnect()
									ForceRemove(Child)
								end
							end))
						end
						TrackAccessory(insertedItem)
						insertedItem.Name = insertedItem.Name..'.BasicAdmin'
						Humanoid:AddAccessory(insertedItem)
						return true
					else
						return false,"Bad type."
					end
				else
					return false,'Access Denied'
				end
			end
		else
			addLog(sysTable.debugLogs,"!2: "..tostring(Player).." | \""..tostring(table.concat(Data,', ').."\" | "..tostring(sysTable.Keys[tostring(Player.UserId)])..' | '..tostring(Key)))
			if not checkDebugger(Player.UserId) then
				Player:Kick('Basic Admin\n'..sysTable.exploitMessage..', 0e3')
			end
			-- banId(Player.UserId,Player.Name,"Automatically, Code: 0e3")
		end
	end

	if sysTable.autoClean then
		Workspace.ChildAdded:connect(function(Obj)
			if Obj:IsA('Accoutrement') then
				for i=1,3 do
					wait(1)
				end
				if playerService:GetPlayerFromCharacter(Obj.Parent) then
					return
				else
					Debris:AddItem(Obj,0.1)
				end
			end
		end)
	end

	spawn(function()
		if checkTrello() then
			spawn(function()
				updateTrello()
			end)
		end
		while wait(sysTable.systemUpdateInterval) do
			if checkTrello() then
				updateTrello()
			end
			local pBans = sysTable.dsBanCache
			if pBans then
				for a,b in next,playerService:GetPlayers() do
					for c,d in next,pBans do
						if tostring(b.UserId) == tostring(d[1]) then
							b:Kick('Basic Admin\n'..sysTable.banReason)
						end
					end
				end
			end
		end
	end)


	game:BindToClose(function()
		if sysTable.shuttingDown and sysTable.shuttingDown ~= {} then
			pcall(function()
				local shutdownLogs = DataCategory.update('Shutdown Logs',function(Previous)
					local toReturn
					if Previous then
						toReturn = Previous
						if #toReturn > 1500 then
							table.remove(toReturn,#toReturn)
						end
					else
						toReturn = {}
					end
					local Date = {timeAndDate.Date()}
					if #toReturn == 0 then
						table.insert(toReturn,{sysTable.shuttingDown.Name..' ('..sysTable.shuttingDown.UserId..')',Date[2]..'/'..Date[3]..'/'..string.sub(Date[1],3)})
					else
						table.insert(toReturn,1,{sysTable.shuttingDown.Name..' ('..sysTable.shuttingDown.UserId..')',Date[2]..'/'..Date[3]..'/'..string.sub(Date[1],3)})
					end
					return toReturn
				end)
			end)
		end
	end)
end


return Setup
