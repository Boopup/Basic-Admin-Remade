local RemoteEvent = game.ReplicatedStorage:WaitForChild("Basic Admin Essentials"):WaitForChild("Essentials Event")

local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")

MessagingService:SubscribeAsync("GlobalAnnouncement", function(message)
	if message and message.Data then
		local msg = tostring(message.Data["msg"])
		local user = tostring(message.Data["user"])

		if msg and user then
			for _, player in ipairs(Players:GetPlayers()) do
				local filteredMsg = Chat:FilterStringForBroadcast(msg, player)

				RemoteEvent:FireClient(player, 'Message', 'Global Message - ' .. user, filteredMsg)
			end
		end
	end
end)
