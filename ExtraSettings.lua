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
	["Rank Config"] = { --These are the admin ranks you can have a max of 4 contact support if more is needed
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
	

	["TimedNotificationsEnabled"] = true, --Have regular notifications sent out
	["PrivatePMs"] = false, --If false you cant see private messages if true you can
	["CommandBarRestrictionEnabled"] = false, --False to enable command bar. True to disabled command bar (for all ranks) 
	["DefendedMessage"] = false, -- Should the "This server is defended." message show up on boot?

	
}
return Settings
