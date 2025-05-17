local RemoteEvent = game.ReplicatedStorage:WaitForChild("Basic Admin Essentials"):WaitForChild("Essentials Event")
local MarketPlaceService = game:GetService("MarketplaceService")

local SettingsWait = game.ReplicatedStorage:WaitForChild("ExtraSettings")
local Settings = require(SettingsWait)

local currentMusic = game.Workspace:FindFirstChild("CurrentMusic")
if not currentMusic then
	currentMusic = Instance.new("Sound", game.Workspace)
	currentMusic.Name = "CurrentMusic"
	currentMusic.Volume = Settings.MusicSystem.Volume
end


local function playMusic()
	local soundIDs = Settings.MusicSystem.SoundIDs
	if #soundIDs == 0 then return end  

	for i = #soundIDs, 1, -1 do
		local selectedSoundID = soundIDs[i]
		local Asset = MarketPlaceService:GetProductInfo(selectedSoundID)
		local soundLength = Asset.AudioLength
		if soundLength == 0 then
			table.remove(soundIDs, i)
		end
	end

	if #soundIDs == 0 then return end

	local randomIndex = math.random(1, #soundIDs)
	local selectedSoundID = soundIDs[randomIndex]

	currentMusic.SoundId = "rbxassetid://" .. selectedSoundID
	currentMusic:Play()


	local Asset = MarketPlaceService:GetProductInfo(selectedSoundID)
	RemoteEvent:FireAllClients('Hint', Settings.MusicSystem.Title, 'Now playing: ' .. Asset.Name)

	wait(currentMusic.TimeLength)
	playMusic()

end


if Settings.MusicSystem.Enabled == true then
	playMusic()
end
