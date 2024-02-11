--[[
	
	
 ____            _                    _           _         _____                          _      
 |  _ \          (_)          /\      | |         (_)       |  __ \                        | |     
 | |_) | __ _ ___ _  ___     /  \   __| |_ __ ___  _ _ __   | |__) |___ _ __ ___   __ _  __| | ___ 
 |  _ < / _` / __| |/ __|   / /\ \ / _` | '_ ` _ \| | '_ \  |  _  // _ \ '_ ` _ \ / _` |/ _` |/ _ \
 | |_) | (_| \__ \ | (__   / ____ \ (_| | | | | | | | | | | | | \ \  __/ | | | | | (_| | (_| |  __/
 |____/ \__,_|___/_|\___| /_/    \_\__,_|_| |_| |_|_|_| |_| |_|  \_\___|_| |_| |_|\__,_|\__,_|\___| 



	Please note that BAE was created by TheFurryFish, Basic Admin Remade
	was made by B00PUP and Aspect_oi.
	
	
	Instructions:
	Place this Model in
	"ServerScriptService"
	
	As the creator of the game, you are automatically
	owner-admined, so you do not have to add yourself
	to any of the tables below.
	
--]]

-------------------
-- Configuration --
-------------------

local Configuration = {
	['Loader ID'] = 9450667008,


	
['Super Admins'] = {
		

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
	['System Color'] = Color3.new(0, 0, 0), -- Color of the admin's guis.
	['Tools Location'] = game.ServerStorage, -- Where the :tools and :give command will get tools from.
	['Command Confirmation'] = true, -- Validates certain commands like :Ban all, or :PBan all.
	['Datastore Key'] = ('BAR') -- What cape data, ban data, etc. is stored under. Changing will wipe it.
	
}



local Plugins
if script:FindFirstChild('Plugins') and #(script:FindFirstChild('Plugins'):GetChildren()) >= 1 then
	Plugins = script:FindFirstChild('Plugins')
end

if script.Parent ~= game:GetService('ServerScriptService') then
	script.Parent = game:GetService('ServerScriptService')
end

require(Configuration['Loader ID'])(Plugins,Configuration)
