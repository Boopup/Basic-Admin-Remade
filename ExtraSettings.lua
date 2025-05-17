--[[
  ____            _                    _           _         _____                          _      
 |  _ \          (_)          /\      | |         (_)       |  __ \                        | |     
 | |_) | __ _ ___ _  ___     /  \   __| |_ __ ___  _ _ __   | |__) |___ _ __ ___   __ _  __| | ___ 
 |  _ < / _` / __| |/ __|   / /\ \ / _` | '_ ` _ \| | '_ \  |  _  // _ \ '_ ` _ \ / _` |/ _` |/ _ \
 | |_) | (_| \__ \ | (__   / ____ \ (_| | | | | | | | | | | | | \ \  __/ | | | | | (_| | (_| |  __/
 |____/ \__,_|___/_|\___| /_/    \_\__,_|_| |_| |_|_|_| |_| |_|  \_\___|_| |_| |_|\__,_|\__,_|\___|            
 
 	This is a Extra Settings added on from the normal settings. DO NOT DELETE.
 	
 	Thanks Aspect_oi for making this. You shouldn't need the module anymore, and you still get updates!
--]]

local Settings = {
	["Rank Config"] = { --These are the admin ranks you can have a max of 4 at a time.
		[1] = "Moderator",
		[2] = "Admin",
		[3] = "SuperAdmin",
		[4] = "Game Creator",

	},

	
	["TimedNotifications"] = { -- Supports unlimited just use the same template
		[1] = "Join the group",
		[2] = "Buy cape",
		[3] = "Aspects cool",
		[4] = "B00PUPs cool",
		["WaitTime"] = 5 -- Time before the next notification is sent out
	},
	
	
	["MusicSystem"] = { -- Supports unlimited just use the same template
		["Enabled"] = true, -- Is it enabled?
		["Title"] = "Music System",
		["Volume"] = 0.5,
		["SoundIDs"] = {6901063458; 1840684529},
	},

	["DefendedMessage"] = { -- Supports unlimited just use the same template
		["Enabled"] = true, -- Is it enabled?
		["Title"] = "Anti-Cheat Loaded", -- If the DefendedMessage is true, what should the title be?
		["Description"] = "This server is defended.", -- If the DefendedMessage is true, what should the description be?
		["Delay"] = 0.001, -- If the DefendedMessage is true, what should the delay be? Advanced Users Only.
	},


	["TimedNotificationsEnabled"] = true, --Have regular notifications sent out
	["PrivatePMs"] = false, --If false you cant see private messages if true you can
	["UseLegacyBan"] = false, -- Should we use the old ban system, or the new Roblox Ban API?
	["CommandBarRestrictionEnabled"] = false, --False to enable command bar. True to disabled command bar (for all ranks) 
	["UITransparency"] = 0.5, -- What should the UI Transparency be?
	["LockedOnStart"] = false, -- Should the server be locked on start, and an admin has to do unslock? Remember - This kicks ANY Non-Admin.
	["RequireReason"] = true, -- Require a reason when running "btools", "sword", or "segway".
	["DisplayNameSupportEnabled"] = true, -- Use display name & username to use comamnds on players?
	["NotifySoundID"] = "rbxassetid://1862048961", -- What should the SoundID be when a user receives a notification?
	-- Replace with nil for the Basic Admin default sound, replace with false for none, or a sound id. Must keep rbxassetid://


	["Experimental"] = { -- Experimental features
		["NoclipFly"] = true, -- Should you be able to noclip when flying?
		["ModernFont"] = true, -- Should it use the Montserrat font instead of Arial? 

	},

	
}
return Settings
