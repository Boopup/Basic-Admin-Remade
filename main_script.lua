--[[
	
	
██████╗░░█████╗░  ██████╗░███████╗███╗░░░███╗░█████╗░██████╗░███████╗
██╔══██╗██╔══██╗  ██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
██████╦╝███████║  ██████╔╝█████╗░░██╔████╔██║███████║██║░░██║█████╗░░
██╔══██╗██╔══██║  ██╔══██╗██╔══╝░░██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░
██████╦╝██║░░██║  ██║░░██║███████╗██║░╚═╝░██║██║░░██║██████╔╝███████╗
╚═════╝░╚═╝░░╚═╝  ╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝

	Please note that BAE was created by TheFurryFish, Basic Admin Remade
	was made by B00PUP.
	
  This GitHub fork is by DavidTDC3377/DavidStudios
	
	Instructions:
	Place this Model in
	"ServerScriptService"
	
	
	There is more information regarding
	this admin script in the description
	of the actual model if you are interested.
	
	If you are confused as to how to configure this,
	please scroll to the bottom of this script
	for examples.
	
	As the creator of the game, you are automatically
	owner-admined, so you do not have to add yourself
	to any of the tables below.
	
--]]

-------------------
-- Configuration --
-------------------

local Configuration = {
	['Loader ID'] = 9450667008,

	--[[
		
		Example:
		
		['Super Admins'] = {
			["1"] = "ROBLOX",
			["2"] = "John Doe",
			["3"] = "Jane Doe",
		},

		["1"] is the User ID
		"ROBLOX" is their Username
		
		This format is the same for
		Super Admins, Admins, Mods,
		and Banned.
		
	--]]
	

	
['Super Admins'] = {
		[1275376431] = "B00PUP",
		

	},
	
	['Admins'] = {
	
	},
		
	['Mods'] = {
	
	},
	
	['Banned'] = {

	},
	
	['Group Configuration'] = {
		{
			['Group ID'] = 0,
			['Group Rank'] = 0,
			['Tolerance Type'] = '>=',
			['Admin Level'] = 0,
		},
	
		},
	
	['Command Configuration'] = {
		['fly'] = {
			['Permission'] = 1,
		},
		['unfly'] = {
			['Permission'] = 1,
		},
	},

	['Prefix'] = (':'), -- The prefix to the admin, i.e :cmds or :sm hi
	['Kick Reason'] = ('You have been kicked from the server.'), -- Displayed to people that are kicked.
	['Ban Reason'] = ('You have been banned from the game.'), -- Displayed to people that are banned.
	['Shutdown Reason'] = ('This server is shutting down..\nTry joining a different server!'), -- Displayed to people when the server is shut down.
	['Server Message'] = ('BAR Server Message'), -- Displayed in the :sm command's title.
	['Server Lock Reason'] = ('The server is locked.'), -- Displayed to people being kicked that try to enter a locked server.
	['Trello'] = false, -- Use trello? HttpService must be enabled.
	['Trello Board'] = (''), -- Trello board ID.
	['Trello App Key'] = (''), -- Private trello application key.
	['Trello Token'] = (''), -- Private trello token.
	['Creator Debugging'] = true, -- Allows the creator to debug potential issues with the admin.
	['Donor Perks'] = true, -- Gives people who purchase an admin donation the ability to cape, put hats on, etc.
	['Public Commands'] = false, -- Will people that are not admin be able to say :cmds, or !clean?
	['Auto Clean'] = true, -- Will hats and gear automatically be cleaned up every so often?
	['System Color'] = Color3.new(0.333333, 0.666667, 1), -- Color of the admin's guis.
	['Tools Location'] = game.ServerStorage, -- Where the :tools and :give command will get tools from.
	['Command Confirmation'] = true, -- Validates certain commands like :Ban all, or :PBan all.
	['Datastore Key'] = ('BAR') -- What cape data, ban data, etc. is stored under. Changing will wipe it.
}

--------------------------
-- End of Configuration --
--------------------------

------------------
-- Help Section --
------------------

--[[

	* Trello Bans Help
	
	Steps to follow:
	1) Make sure HttpService is enabled, to do so, paste
	"game:GetService('HttpService').HttpEnabled = true" into the command bar.
	2) Make sure Trello Bans is enabled
	3) Make sure the trello board is public
	4) Paste the trello board ID into the Trello Board ID option
	5) On the trello board, create a list called "Ban List"
	6) Add bans
	
	Note that the ban format for the name of the card is:
	Shedletsky:261

	-----------------------------------------------------------------------------	
	
	* Group Admin Help:
	Types of admin
	1 = Mod
	2 = Admin
	3 = Super Admin
	
	The empty table should appear as this:
	['Group Configuration'] = {
		{
			['Group ID'] = 0,
			['Group Rank'] = 0,
			['Tolerance Type'] = '>=',
			['Admin Level'] = 0,
		},
	},
	
	To add a group, create another table inside of the existing one;
	this should look like this:
	['Group Configuration'] = {
		{
			['Group ID'] = 0,
			['Group Rank'] = 0,
			['Tolerance Type'] = '>=',
			['Admin Level'] = 0,
		},
		{
			['Group ID'] = 0,
			['Group Rank'] = 0,
			['Tolerance Type'] = '>=',
			['Admin Level'] = 0,
		},
	},
	
	Now add the group id into it, followed by a comma, followed by the group rank,
	- followed by the level of admin those users should receive.
	
	An example of a finished product is:
	{
		['Group ID'] = 950346,
		['Group Rank'] = 20,
		['Tolerance Type'] = '>=',
		['Admin Level'] = 2,
	},
	
	That will give people in the group id "950346", whom are at rank 20 or higher, level 2 admin,
	- which is regular admin.
	
	------------------------------------------------------------------------------
	
	* Command Configuration Help
	
	['Command Configuration'] = {
		['fly'] = {
			['Permission'] = 1,
		},
	},
	
	['fly'] is the command being altered or changed.
	['Permission'] is the property of the command being changed.
	
	There are 5 levels of admin,
	0 = Everyone
	1 = Mod
	2 = Admin
	3 = Superadmin
	4 = Game Creator
	
	If you only wanted admins to fly, change
	the 1 to a 2.
	
	['Command Configuration'] = {
		['fly'] = {
			['Permission'] = 2,
		},
		['unfly'] = {
			['Permission'] = 2,
		},
	},
	
--]]

----------------------------
-- Configuration Examples --
----------------------------

--[[
	
	Note that if you have multiple
	admins, mods, banned, etc., you
	must have a comma after the previous
	entry.
	
	local Configuration = {
		['Loader ID'] = script.MainModule,
		
		['Super Admins'] = {
			['261'] = "Shedletsky",
		},
		
		['Admins'] = {
			['261'] = "Shedletsky",
		},
			
		['Mods'] = {
			['261'] = "Shedletsky"
		},
		
		['Banned'] = {
			['261'] = "Shedletsky",
		},
		
		['Group Configuration'] = {
			{
				['Group ID'] = 0,
				['Group Rank'] = 0,
				['Tolerance Type'] = '>=',
				['Admin Level'] = 0,
			},
		},
			
		['Command Configuration'] = {
			['fly'] = {
				['Permission'] = 1,
			},
			['unfly'] = {
				['Permission'] = 1,
			},
		},
		
		['Prefix'] = (':'),
		['Kick Reason'] = ('You have been kicked from the server.'),
		['Ban Reason'] = ('You have been banned from the game.'),
		['Shutdown Reason'] = ('This server is shutting down..\nTry joining a different server!'),
		['Server Message'] = ('Server Message'),
		['Server Lock Reason'] = ('The server is locked.'),
		['Trello'] = false,
		['Trello Board'] = (''),
		['Trello App Key'] = (''),
		['Trello Token'] = (''),
		['Creator Debugging'] = true,
		['Donor Perks'] = true,
		['Public Commands'] = true,
		['Auto Clean'] = true,
		['System Color'] = Color3.new(31/255,31/255,31/255),
		['Tools Location'] = game.ServerStorage,
		['Command Confirmation'] = false, -- Validates certain commands like :Ban all, or :PBan all.
		['Datastore Key'] = ('BAE_#$DGF') -- What cape data, ban data, etc. is stored under. Changing will wipe it.
	}
		
--]]

---------------------
-- End of Examples --
---------------------

local Plugins
if script:FindFirstChild('Plugins') and #(script:FindFirstChild('Plugins'):GetChildren()) >= 1 then
	Plugins = script:FindFirstChild('Plugins')
end

if script.Parent ~= game:GetService('ServerScriptService') then
	script.Parent = game:GetService('ServerScriptService')
end

require(Configuration['Loader ID'])(Plugins,Configuration)
