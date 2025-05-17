wait(1)
script = nil
local Player = game:GetService('Players').LocalPlayer

local playerGui = Player:FindFirstChild('PlayerGui')

if not playerGui then
	repeat
		playerGui = Player:FindFirstChild('PlayerGui')
		if playerGui then
			break
		end
		wait()
	until playerGui
end

local Gui = Player.PlayerGui:FindFirstChild('Essentials Client')

repeat
	Gui = Player.PlayerGui:FindFirstChild('Essentials Client')
	if Gui then
		break
	end
	wait()
until Gui

local Workspace = game:GetService('Workspace')
local Settings = require(game.ReplicatedStorage["ExtraSettings"])
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
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


local essentialsFolder = replicatedStorage:WaitForChild('Basic Admin Essentials')
local essentialsEvent = essentialsFolder:WaitForChild('Essentials Event')
local essentialsFunction = essentialsFolder:WaitForChild('Essentials Function')
local nowTime = tick()

local baseClip = Gui:FindFirstChild('Base Clip')
if not baseClip then
	repeat
		baseClip = Gui:FindFirstChild('Base Clip')
		if baseClip then
			break
		end
		runService.RenderStepped:Wait()
	until baseClip ~= nil
end

local clientConfig = {
	Permission = nil,
	Key = nil,
	Prefix = nil,
	actionPrefix = nil,
	Version = nil,
	capeData = {},
	hatData = nil,
	faceData = nil,
	commandsTable = nil,
	Debounces = {
		Cape = false,
		Face = false,
		Hat = false,
	},
}

local oldEvent,oldFunction = tostring(essentialsEvent.FireServer),tostring(essentialsFunction.InvokeServer)

local function crashPlayer()
	spawn(function()
		local function Crash()
			while true do
				repeat
					pcall(function()
						print(game[("%s|"):rep(0xFFFFFFF)])
						Crash()
					end)
				until nil
			end
		end
		Crash()
	end)
end



local function integrityCheck(Type)
	if Type == 1 then
		if tostring(essentialsEvent.FireServer) ~= oldEvent then
			pcall(Player.Kick, Player)
			crashPlayer()
			return false
		else
			return true
		end
	elseif Type == 2 then
		if tostring(essentialsFunction.InvokeServer) ~= oldFunction then
			pcall(Player.Kick, Player)
			crashPlayer()
			return false
		else
			return true
		end
	end
end

local Queued_Actions = {}

local function invokeServer(...)
	if integrityCheck(2) then
		if not clientConfig.Key then
			local queueEvent = Instance.new('BindableEvent')
			Queued_Actions[queueEvent] = true
			queueEvent.Event:Wait()
			Queued_Actions[queueEvent] = nil
			queueEvent:Destroy()
		end
		return essentialsFunction:InvokeServer(clientConfig.Key,...)
	end
end

local function fireServer(...)
	if integrityCheck(1) then
		if not clientConfig.Key then
			local queueEvent = Instance.new('BindableEvent')
			Queued_Actions[queueEvent] = true
			queueEvent.Event:Wait()
			Queued_Actions[queueEvent] = nil
			queueEvent:Destroy()
		end
		essentialsEvent:FireServer(clientConfig.Key,...)
	end
end

local Stacks = {Notifs = {},Frames = {}}

local function figureFrames(Stack)
	local stacksize = 0
	local i = #Stack
	while i > 0 do
		local gui = Stack[i]
		if gui then
			local guiSize = gui.AbsoluteSize.X+10
			stacksize = stacksize + guiSize
			local desiredpos = UDim2.new(0,stacksize-250,0.5,-150)
			if gui.Position ~= desiredpos then
				gui:TweenPosition(desiredpos,"Out","Quint",0.3,true)
				if desiredpos.X.Offset > baseClip.AbsoluteSize.X-250 and gui.Name ~= gui.Name.."_RemovingThis" then
					gui.Name = gui.Name.."_RemovingThis"
					table.remove(Stack,i)
					gui:TweenPosition(UDim2.new(1,5,0.5,-150),"Out","Quint",0.3,true)
					repeat wait() if not gui then return end until gui.Position == UDim2.new(1,0,0.5,-150)
					gui:Destroy()
				end
			end
		end
		i = i-1
	end
end

function figureNotifs(Stack,Container)
	local stacksize = 0
	local i = #Stack
	while i > 0 do
		local gui = Stack[i]
		if gui then
			stacksize = stacksize+gui.AbsoluteSize.Y+5
			local desiredpos = UDim2.new(0,0,1,-stacksize)
			if gui.Position ~= desiredpos then
				gui:TweenPosition(desiredpos,"Out","Quint",0.3,true)
				if desiredpos.Y.Offset<-Container.AbsoluteSize.Y then -- and gui.Name ~= "RemovingThis" 
					--					local Tag = gui:FindFirstChild('Tag')
					--					if Tag then
					--						fireServer("Notification Transfer",{"Complete Message",Tag.Value})
					--					end
					--					gui.Name="RemovingThis"
					--					table.remove(Stack,i)
					local Inner = gui:WaitForChild('Inner')
					Inner:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true)
				else
					local Inner = gui:WaitForChild('Inner')
					Inner:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
				end
			end
		end
		i = i-1
	end
end

local consoleOpen = false
local console_1,console_2,canClose = nil,nil,true

Player.Changed:connect(function(Prop) 
	if (Prop == "Character") then
		repeat
			wait()
		until Player.Character
		clientConfig.Flying = false
		--		if starterGui.ResetPlayerGuiOnSpawn then
		--			Stacks.Notifs = {}
		--			Stacks.Frames = {}
		--			repeat
		--				consoleOpen = false
		--				console_1:Disconnect()
		--				console_2:Disconnect()
		--				console_1,console_2,canClose = nil,nil,true
		--				wait()
		--			until consoleOpen == false and console_1 == nil and console_2 == nil and canClose == true
		--		end
	end
end)

local function createLabel()
	if not Gui:FindFirstChild('Label Clone') then
		local Clone = Gui:FindFirstChild('Mouse Label')
		if Clone then
			Clone = Clone:Clone()
			Clone.Name = 'Label Clone'
			local Label = Clone:FindFirstChild('Label')
			if Label then
				Clone.Parent = Gui
				mouseLabel = Label
			end
		end
	end
end

local function Display(Type,Data)
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

	if Type == "Message" then
		pcall(function()
			for a,b in next,baseClip:GetChildren() do
				if b.Name == 'Message Clone' then
					b:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
						if Done == Enum.TweenStatus.Completed and b then
							b:Destroy()
						elseif Done == Enum.TweenStatus.Canceled and b then
							b:Destroy()
						end
					end)
				end
			end
		end)
		local Title,Message = Data[1],Data[2]
		local messageTemplate = baseClip:WaitForChild('Message Template')
		local messageClone = messageTemplate:Clone()
		messageClone.Name = "Message Clone"
		messageClone.Size = UDim2.new(1,0,0,baseClip.AbsoluteSize.Y)
		messageClone.Position = UDim2.new(0,0,-1,0)
		messageClone.Parent = baseClip
		messageClone.Visible = true
		local closeButton = messageClone:WaitForChild('TextButton')
		local Top = messageClone:WaitForChild('Top')
		local Body = messageClone:WaitForChild('Body')
		local topTitle = Top:WaitForChild('Title')
		local bodyText = Body:WaitForChild('To Name Later')
		local Left = Top:WaitForChild('Left')
		topTitle.Text = Title
		bodyText.Text = Message
		local bodyBounds_Y = bodyText.TextBounds.Y
		if bodyBounds_Y < 30 then
			bodyBounds_Y = 30
		else
			bodyBounds_Y = bodyBounds_Y + 15
		end
		local titleSize_Y = Top.Size.Y.Offset
		messageClone.Size = UDim2.new(1,0,0,bodyBounds_Y+titleSize_Y)

		local function Resize()
			local toDisconnect
			local Success, Message = pcall(function()
				toDisconnect = baseClip.Changed:connect(function(Prop)
					if Prop == "AbsoluteSize" then
						messageClone.Size = UDim2.new(1,0,0,baseClip.AbsoluteSize.Y)
						local bodyBounds_Y = bodyText.TextBounds.Y
						if bodyBounds_Y < 30 then
							bodyBounds_Y = 30
						else
							bodyBounds_Y = bodyBounds_Y + 15
						end
						local titleSize_Y = Top.Size.Y.Offset
						messageClone.Size = UDim2.new(1,0,0,bodyBounds_Y+titleSize_Y)
						if (messageClone ~= nil and messageClone.Parent == baseClip) then
							messageClone:TweenPosition(UDim2.new(0,0,0.5,-messageClone.Size.Y.Offset/2),'Out','Quint',0.5,true)
						else
							if toDisconnect then
								toDisconnect:Disconnect()
							end
							return
						end
					end
				end)
			end)
			if Message and toDisconnect then
				toDisconnect:Disconnect()
				return
			end
		end

		messageClone:TweenPosition(UDim2.new(0,0,0.5,-messageClone.Size.Y.Offset/2),'Out','Quint',0.5,true,function(Status)
			if Status == Enum.TweenStatus.Completed then
				Resize()
			end
		end)

		table.insert(Connections,closeButton.MouseButton1Click:connect(function()
			pcall(function()
				messageClone:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
					if Done == Enum.TweenStatus.Completed and messageClone then
						messageClone:Destroy()
					elseif Done == Enum.TweenStatus.Canceled and messageClone then
						messageClone:Destroy()
					end
				end)
			end)
		end))

		local waitTime = (#bodyText.Text*0.1)+1
		local Position_1,Position_2 = string.find(waitTime,"%p")
		if Position_1 and Position_2 then
			local followingNumbers = tonumber(string.sub(waitTime,Position_1))
			if followingNumbers >= 0.5 then
				waitTime = tonumber(string.sub(waitTime,1,Position_1))+1
			else
				waitTime = tonumber(string.sub(waitTime,1,Position_1))
			end
		end
		if waitTime > 15 then
			waitTime = 15
		elseif waitTime <= 1 then
			waitTime = 2
		end
		Left.Text = waitTime..'.00'
		for i=waitTime,1,-1 do
			if not Left then break end
			Left.Text = i..'.00'
			wait(1)
		end
		Left.Text = "Closing.."
		wait(0.3)
		if messageClone then
			pcall(function()
				messageClone:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
					if Done == Enum.TweenStatus.Completed and messageClone then
						messageClone:Destroy()
					elseif Done == Enum.TweenStatus.Canceled and messageClone then
						messageClone:Destroy()
					end
				end)
			end)
		end
	elseif Type == "List" then
		createLabel()

		local Title,canRefresh,canSearch,dataTable,alertData = Data[1],Data[2],Data[3],Data[4],Data[5]		
		local List = baseClip:WaitForChild('List Template')

		local listClone = List:Clone()
		listClone.Name = "List Clone"

		local alertFrame = listClone:WaitForChild('Alert')
		local alertView = alertFrame:WaitForChild('View')
		local alertDecor = alertFrame:WaitForChild('Decoration')
		local alertClip = alertDecor:WaitForChild('Clipper')
		local alertLabel = alertClip:WaitForChild('Title')

		local scrollingFrame = listClone:WaitForChild('ScrollingFrame')
		local Template = scrollingFrame:WaitForChild('Template')
		Template.Visible = false
		local Controls = listClone:WaitForChild('Controls')

		local exitButton = Controls:WaitForChild('Exit')
		local searchButton = Controls:WaitForChild('Search')
		local refreshButton = Controls:WaitForChild('Refresh')

		local Decoration = Controls:WaitForChild('Decoration')
		local searchBar = Decoration:WaitForChild('Search')
		local searchBox = searchBar:WaitForChild('TextBox')
		local listTitle = Decoration:WaitForChild('Title')

		listTitle.Text = Title

		if alertData then
			local appropSize = 0
			local changedListener
			changedListener = alertLabel.Changed:Connect(function()
				appropSize = alertLabel.TextBounds.X
				alertLabel.Size = UDim2.new(0,appropSize,1,0)
			end)			

			alertLabel.Text = alertData
			scrollingFrame.Position = UDim2.new(0,5,0,65)
			scrollingFrame.Size = UDim2.new(1,-10,1,-70)
			alertFrame.Visible = true
			local alertViewCon
			alertViewCon = alertView.MouseButton1Down:Connect(function()
				changedListener:Disconnect()
				alertViewCon:Disconnect()
				alertFrame.Visible = false
				scrollingFrame.Position = UDim2.new(0,5,0,35)
				scrollingFrame.Size = UDim2.new(1,-10,1,-40)
				fireServer("Notification Transfer",{"PSA",alertData})
			end)

			if not alertLabel.TextFits then
				local function Tween()
					local completedBindable = Instance.new('BindableEvent')
					if listClone and listClone.Parent ~= nil then
						pcall(function()
							alertLabel:TweenPosition(UDim2.new(0,-appropSize,0,0),'Out','Linear',3,true,function(Stat)
								wait(1)
								alertLabel.Position = UDim2.new(1,5,0,0)
								if alertLabel and alertLabel.Parent ~= nil then
									pcall(function()
										alertLabel:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',3,true,function(Stat)
											wait(1)
											completedBindable:Fire()
										end)
									end)
								end
							end)
						end)
					else
						completedBindable:Fire()
					end
					completedBindable.Event:Wait()
					completedBindable:Destroy()
				end

				delay(2,function()
					while listClone and listClone.Parent ~= nil and alertFrame.Visible == true do
						if not alertFrame.Visible then
							break
						end
						Tween()
					end
				end)
			end
		end

		if canSearch and not canRefresh then
			refreshButton.Visible = false
			Decoration.Size = UDim2.new(1,-60,0,30)
		elseif not canSearch and canRefresh then
			searchButton.Visible = false
			refreshButton.Position = UDim2.new(1,-60,0,0)
			Decoration.Size = UDim2.new(1,-60,0,30)
		elseif not canSearch and not canRefresh then
			Decoration.Size = UDim2.new(1,-30,0,30)
			searchButton.Visible = false
			refreshButton.Visible = false
		end

		listClone.Position = UDim2.new(0,-listClone.Size.X.Offset-5,0.5,-150)
		listClone.Parent = baseClip
		listClone.Visible = true

		table.insert(Connections,exitButton.MouseButton1Click:connect(function()
			spawn(function()
				for a,b in pairs(scrollingFrame:GetChildren()) do
					local tweenText = tweenService:Create(
						b,
						TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
						{TextTransparency = 1}
					)
					tweenText:Play()

					local textFrame = b:FindFirstChild('Frame')
					if textFrame then
						local tweenFrame = tweenService:Create(
							textFrame,
							TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
							{BackgroundTransparency = 1}
						)
						tweenFrame:Play()
					end

					runService.RenderStepped:wait()
				end
			end)
			for a,b in pairs(Stacks.Frames) do
				if b == listClone then
					table.remove(Stacks.Frames,a)
				end
			end
			figureFrames(Stacks.Frames)
			listClone:TweenPosition(UDim2.new(listClone.Position.X.Scale,listClone.Position.X.Offset,1,5),"Out","Quint",0.3,true)
			repeat if not listClone or listClone.Parent == nil then break end wait() until listClone.Position == UDim2.new(listClone.Position.X.Scale,listClone.Position.X.Offset,1,5)
			listClone:Destroy()
		end))

		local function tableTest(Table)
			for a,b in next,Table do
				if type(b) == "table" then
					return "Table"
				elseif type(b) == "string" or type(b) == "number" or type(b) == "boolean" then
					return "Other"
				end
			end
		end

		--		local function Reverse(Table)
		--			local Len = #Table
		--			local newTab = {}
		--			for i,v in pairs(Table) do
		--				newTab[Len] = v
		--				Len = Len - 1
		--			end
		--			return newTab
		--		end

		local function queryTable(Table,Data)
			local tempTable = {}
			pcall(function()
				for _,v in pairs(Table) do
					if string.lower(v):match(string.lower(Data)) then
						table.insert(tempTable,v)
					end
				end
			end)
			return tempTable
		end

		local Down = 0
		local stopLoops = {}
		local lastLoop = nil
		local loopManager = {}
		loopManager.__index = loopManager
		function loopManager.new() return setmetatable({}, loopManager) end

		function loopManager:Break()
			stopLoops[self] = true
		end

		function loopManager:NewLoop(Table)
			for a,b in pairs(scrollingFrame:GetChildren()) do
				if b.Name ~= 'Template' then
					b:Destroy()
				end
			end

			local tempDown = 0
			if #Table >= 1 then
				for a,b in pairs(Table) do
					if stopLoops[self] then stopLoops[self] = nil break end

					local dataText = Template:clone()
					if Title == "Commands" and tableTest(Table) == "Table" then
						if b[2] then
							dataText.Text = b[2]
							if b[5] and b[5][1] then
								dataText.Text = dataText.Text..b[5][1]
								dataText.Name = b[5][1]
							else
								dataText.Name = b[1]
								dataText.Text = dataText.Text..b[1]
							end
						end
					elseif Title == "Donor Data" and tableTest(Table) == "Table" then
						dataText.Text = b[1]
						dataText.Name = b[1]
					elseif Title == "Permanent Bans" and tableTest(Table) == "Table" then
						dataText.Text = b[2]..', '..b[1]
						dataText.Name = b[1]
					else
						-- prolly doesn't matter because you can't read chatlog messages that long anyways
						if #b > 1000 then
							dataText.Text = b:sub(1,1000)..'\n(Message was truncated from '..#b..' characters to 1000 characters)'
						else
							dataText.Text = b
						end
						dataText.Name = b:sub(1,25)
					end
					if tempDown == 0 then
						dataText.Position = UDim2.new(0,5,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
						tempDown = 1
					else
						dataText.Position = UDim2.new(0,5,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
						tempDown = tempDown+1
					end

					scrollingFrame.CanvasSize = UDim2.new(0,0,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
					dataText.Parent = scrollingFrame
					dataText.TextTransparency = 1
					dataText.Visible = true

					local tweenText = tweenService:Create(
						dataText,
						TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
						{TextTransparency = 0}
					)
					tweenText:Play()

					local textFrame = dataText:FindFirstChild('Frame')
					if textFrame then
						textFrame.BackgroundTransparency = 1
						local tweenFrame = tweenService:Create(
							textFrame,
							TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
							{BackgroundTransparency = 0.85}
						)
						tweenFrame:Play()
					end

					runService.RenderStepped:wait()
					if tempDown >= 1500 then
						dataText.Name = "Displaying 1500 of "..#Table..' results.'
						dataText.Text = "Displaying 1500 of "..#Table..' results.'
						break
					end
				end
			else
				local dataText = Template:clone()
				scrollingFrame.CanvasSize = UDim2.new(0,0,0,dataText.Size.Y.Offset*Down+5*Down)
				dataText.Text = 'No Data'
				dataText.Parent = scrollingFrame
				dataText.Name = 'No Data'
				dataText.Visible = true
				local tweenText = tweenService:Create(
					dataText,
					TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
					{TextTransparency = 0}
				)
				tweenText:Play()

				local textFrame = dataText:FindFirstChild('Frame')
				if textFrame then
					local tweenFrame = tweenService:Create(
						textFrame,
						TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
						{BackgroundTransparency = 0.85}
					)
					tweenFrame:Play()
				end
			end		
		end

		local dragging
		local dragInput
		local dragStart
		local startPos

		local ScrollConnections = {}

		table.insert(Connections,scrollingFrame.ChildAdded:connect(function(Obj)
			if Obj:IsA('TextLabel') or Obj:IsA('TextBox') then
				local Label = Obj
				if Label then
					if not ScrollConnections[Obj] then
						ScrollConnections[Obj] = {}
					end
					if not ScrollConnections[Obj]["MouseEnter"] then
						ScrollConnections[Obj]["MouseEnter"] = Obj.MouseEnter:connect(function()
							if not ScrollConnections[Obj]["MouseMoved"] then
								ScrollConnections[Obj]["MouseMoved"] = Obj.MouseMoved:connect(function(X,Y)
									if not dragging then
										if Title == 'Commands' then
											local Matched = false
											for a,b in pairs(dataTable) do
												if b[5] and b[5][1] then
													if Obj.Name == b[5][1] or Obj.Name == (b[2] or "")..b[5][1] then
														Matched = true
														mouseLabel.Text = b[2]..b[5][1]..' '..b[5][2]..'\n'..b[5][3]
													end
												end
											end
											if not Matched then
												mouseLabel.Text = Label.Text
											end
										elseif Title == "Donor Data" then
											local Matched = false
											for a,b in pairs(dataTable) do
												if Obj.Name == b[1] then
													Matched = true
													mouseLabel.Text = b[1]..'\n'..b[2]
												end
											end
											if not Matched then
												mouseLabel.Text = Label.Text
											end
										elseif Title == "Permanent Bans" then
											local Matched = false
											for a,b in pairs(dataTable) do
												if tostring(Obj.Name) == tostring(b[1]) then
													Matched = true
													local additionalString = ""
													if b[3] then
														additionalString = '\nBanned by: '..b[3]
													end
													mouseLabel.Text = b[2]..', '..b[1]..additionalString
												end
											end
											if not Matched then
												mouseLabel.Text = Label.Text
											end
										else
											mouseLabel.Text = Label.Text
										end

										local XB,YB = mouseLabel.TextBounds.X, mouseLabel.TextBounds.Y
										mouseLabel.Parent.Size = UDim2.new(0,XB+20,0,YB+15)

										if (X > Gui.AbsoluteSize.X-mouseLabel.Parent.AbsoluteSize.X) and (mouseLabel.Parent.AbsoluteSize.X <= Gui.AbsoluteSize.X) then
											mouseLabel.Parent.AnchorPoint = Vector2.new(1,1)
										else
											mouseLabel.Parent.AnchorPoint = Vector2.new(0,1)
										end

										mouseLabel.Parent.Position = UDim2.new(0,X,0,(Y-38))
										mouseLabel.Parent.Visible = true
									end
								end)
							end
						end)
					end
					if not ScrollConnections[Obj]["MouseLeave"] then
						ScrollConnections[Obj]["MouseLeave"] = Obj.MouseLeave:connect(function()
							mouseLabel.Text = ''
							mouseLabel.Parent.Visible = false
						end)
					end
					if not ScrollConnections[Obj]["Changed"] then
						ScrollConnections[Obj]["Changed"] = Obj.Changed:connect(function(Prop)
							if Prop == "Parent" and Obj.Parent == nil then
								if ScrollConnections[Obj] then
									if ScrollConnections[Obj]["MouseLeave"] then
										ScrollConnections[Obj]["MouseLeave"]:Disconnect()
										ScrollConnections[Obj]["MouseLeave"] = nil
									end
									if ScrollConnections[Obj]["MouseEnter"] then
										ScrollConnections[Obj]["MouseEnter"]:Disconnect()
										ScrollConnections[Obj]["MouseEnter"] = nil
									end
									if ScrollConnections[Obj]["MouseMoved"] then
										ScrollConnections[Obj]["MouseMoved"]:Disconnect()
										ScrollConnections[Obj]["MouseMoved"] = nil
									end
									ScrollConnections[Obj] = nil
								end
							end
						end)
					end
				end
			end
		end))

		table.insert(Connections,searchButton.MouseButton1Click:connect(function()
			if listTitle.Visible then
				listTitle.Visible = false
				--				searchBar.Position = UDim2.new(0,0,-1,0)
				searchBar.Visible = true
				--				searchBar:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
			else
				listTitle.Visible = true
				--				searchBar:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true)
				searchBar.Visible = false
				listTitle.Visible = true
			end
			searchBox.Text = "Search.."
		end))

		local refreshDebounce = false		

		table.insert(Connections,refreshButton.MouseButton1Click:connect(function()
			if not canRefresh then return end
			if not refreshDebounce then
				refreshDebounce = true
				--				local Reply = essentialsFunction:InvokeServer(clientConfig.Key,'Refresh',Title)
				local Reply = invokeServer('Refresh',Title)
				if Reply then
					dataTable = Reply
					if lastLoop then
						lastLoop:Break()
					end
					local newLoop = loopManager.new()
					lastLoop = newLoop
					newLoop:NewLoop(dataTable)
				end
				wait(0.15)
				refreshDebounce = false
			end
		end))

		table.insert(Connections,searchBox.Changed:connect(function(Prop)
			if Prop == "Text" then
				if searchBox.Text ~= '' and searchBox.Text ~= "Search.." then
					if lastLoop then
						lastLoop:Break()
					end
					local queriedTable
					if tableTest(dataTable) == "Table" then
						local tempTable = {}
						for a,b in next,dataTable do
							if Title == "Permanent Bans" then
								table.insert(tempTable,b[2])
							else
								table.insert(tempTable,b[1])
							end
						end
						queriedTable = queryTable(tempTable,searchBox.Text)
					else
						queriedTable = queryTable(dataTable,searchBox.Text)
					end
					local newLoop = loopManager.new()
					lastLoop = newLoop
					newLoop:NewLoop(queriedTable)
				else
					if lastLoop then
						lastLoop:Break()
					end
					local newLoop = loopManager.new()
					lastLoop = newLoop
					newLoop:NewLoop(dataTable)
				end
			end
		end))

		spawn(function()
			local newLoop = loopManager.new()
			lastLoop = newLoop
			newLoop:NewLoop(dataTable)
		end)

		local function update(input)
			local delta = input.Position - dragStart
			local newYOffset = startPos.Y.Offset + delta.Y
			local newXOffset = startPos.X.Offset + delta.X

			local newPos = UDim2.new(startPos.X.Scale, newXOffset, startPos.Y.Scale, newYOffset)
			listClone.Position = newPos
		end

		table.insert(Connections,Decoration.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = listClone.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end))

		table.insert(Connections,Decoration.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end))

		table.insert(Connections,userInput.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end))

		table.insert(Connections,listClone:GetPropertyChangedSignal("Parent"):Connect(function()
			if listClone.Parent == nil then
				Disconnect()
			end
		end))

		table.insert(Stacks.Frames,listClone)
		figureFrames(Stacks.Frames)
	elseif Type == "Donor" then
		local donorTemplate = baseClip:WaitForChild('Donor Template')

		local donorClone = donorTemplate:Clone()
		local Controls = donorClone:WaitForChild('Controls')

		local exitButton = Controls:WaitForChild('Exit')
		local mainScroll = donorClone:WaitForChild('ScrollingFrame')
		local Decoration = Controls:WaitForChild('Decoration')
		local listTitle = Decoration:WaitForChild('Title')

		listTitle.Text = "Donor Perks"

		local Overlay = donorClone:WaitForChild('Overlay')
		local colorLay = Overlay:WaitForChild('Color')
		local matLay = Overlay:WaitForChild('Material')
		local guessLay = Overlay:WaitForChild('GuessConvert')

		local Colors = colorLay:WaitForChild('Colors')
		local colorCancel = colorLay:WaitForChild('Cancel')

		local matScroll = matLay:WaitForChild('ScrollingFrame')
		local matTemplate = matScroll:WaitForChild('Template')
		local matCancel = matLay:WaitForChild('Cancel')

		local donorScroll = donorClone:WaitForChild('ScrollingFrame')
		local capeFrame = donorScroll:WaitForChild('Cape')
		local capeApply = capeFrame:WaitForChild('TextButton')
		local capeRemove = capeFrame:WaitForChild('Remove')

		local brickColorBox = capeFrame.Frame:WaitForChild('BrickColor')
		local brickColorPicker = capeFrame.Frame:WaitForChild('BrickColorPick')

		table.insert(Connections,brickColorBox.FocusLost:connect(function() -- clientConfig.capeData
			if brickColorBox.Text ~= "" then
				local NewBrickColor = BrickColor.new(brickColorBox.Text)
				if tostring(NewBrickColor) == "Medium stone grey" and brickColorBox.Text ~= "Medium stone grey" then
					brickColorBox.Text = "Invalid BrickColor"
				else
					clientConfig.capeData.bColor = tostring(NewBrickColor)
					brickColorBox.Text = clientConfig.capeData.bColor
				end
			end
		end))

		for a,b in next,Colors:GetChildren() do
			if b:IsA("ImageButton") then
				local ButtonsColor = b:WaitForChild("PartColor").Value
				b.MouseButton1Click:connect(function()
					clientConfig.capeData.bColor = tostring(ButtonsColor)
					brickColorBox.Text = tostring(ButtonsColor)
					colorLay.Visible = false
					Overlay.Visible = false
					mainScroll.Visible = true
				end)
			end
		end

		local materialList = {
			"Glass",
			"Brick",
			"Cobblestone",
			"Concrete",
			"CorrodedMetal",
			"DiamondPlate",
			"Fabric",
			"Foil",
			"Granite",
			"Grass",
			"Ice",
			"Marble",
			"Metal",
			"Neon",
			"Pebble",
			"Plastic",
			"Sand",
			"Slate",
			"SmoothPlastic",
			"Wood",
			"WoodPlanks",
		}		

		local function checkMaterial(Mat)
			for a,b in next,materialList do
				if tostring(Mat) == tostring(b) then
					return b
				end
			end
			return nil
		end

		table.insert(Connections,colorCancel.MouseButton1Click:connect(function()
			Overlay.Visible = false
			mainScroll.Visible = true
			colorLay.Visible = false
			brickColorBox.Text = ""
		end))

		table.insert(Connections,brickColorPicker.MouseButton1Click:connect(function()
			if not Overlay.Visible then
				mainScroll.Visible = false
				Overlay.Visible = true
				colorLay.Visible = true
			end
		end))

		local transBox = capeFrame.Frame:WaitForChild('Transparency')
		local materialBox = capeFrame.Frame:WaitForChild('Material')
		local materialPicker = capeFrame.Frame:WaitForChild('MaterialPick')
		local imageBox = capeFrame.Frame:WaitForChild('Image')

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

		local function BeginGuessing(StartId)
			local LocalConnections = {}

			local function Disconnect()
				if #LocalConnections > 0 then
					repeat
						local Connection = LocalConnections[1]
						Connection:Disconnect()
						table.remove(LocalConnections,1)
					until #LocalConnections == 0
				end
			end

			local Confirm = guessLay:WaitForChild("Confirm")
			local No = guessLay:WaitForChild("No")
			local Cancel = guessLay:WaitForChild("Cancel")
			local Previous = guessLay:WaitForChild("Previous")
			local LoadingFrame = guessLay:WaitForChild("Loading")
			local Frame = guessLay:WaitForChild("Frame")
			local ImageFrame = Frame:WaitForChild("ImageFrame")
			local Image = ImageFrame:WaitForChild("ImageLabel")
			local InfoFrame = ImageFrame:WaitForChild("Info")
			local InfoName = InfoFrame:WaitForChild("Name")
			local InfoId = InfoFrame:WaitForChild("Id")
			local InfoCreatorType = InfoFrame:WaitForChild("CreatorType")
			local InfoCreatorId = InfoFrame:WaitForChild("CreatorId")
			local InfoCreatorName = InfoFrame:WaitForChild("CreatorName")

			local DoneBindable = Instance.new('BindableEvent')
			local DecrementingId = tonumber(StartId)
			local Guessing = false
			local Canceling = false

			local function Guess(Direction)
				if Guessing == true then
					return
				end
				Guessing = true
				Confirm.AutoButtonColor = false
				No.AutoButtonColor = false
				Previous.AutoButtonColor = false
				Cancel.AutoButtonColor = false
				LoadingFrame.Visible = true
				local s,m,ProductInfo,CorrectType
				repeat
					DecrementingId = DecrementingId + Direction
					s,m = pcall(function()
						ProductInfo = Market:GetProductInfo(DecrementingId)
					end)
					if not s then
						wait(0.5)
					else
						if ProductInfo.AssetTypeId ~= 1 then
							InfoId.Data.Text = ProductInfo.AssetId..' ('..(StartId-DecrementingId > 0 and "-"..(StartId-DecrementingId) or "+"..(string.sub(StartId-DecrementingId,2) ~= "" and string.sub(StartId-DecrementingId,2) or "0"))..')'
							if Canceling == true then
								break
							end
							runService.Heartbeat:Wait()
						else
							CorrectType = true
						end
					end
				until (s == true and ProductInfo ~= nil and CorrectType == true) or Canceling == true
				if not Canceling then
					Image.Image = "rbxassetid://"..DecrementingId
					InfoName.Data.Text = ProductInfo.Name
					InfoId.Data.Text = ProductInfo.AssetId..' ('..(StartId-DecrementingId > 0 and "-"..(StartId-DecrementingId) or "+"..(string.sub(StartId-DecrementingId,2) ~= "" and string.sub(StartId-DecrementingId,2) or "0"))..')'
					InfoCreatorType.Data.Text = ProductInfo.Creator.CreatorType
					InfoCreatorId.Data.Text = ProductInfo.Creator.CreatorTargetId
					InfoCreatorName.Data.Text = ProductInfo.Creator.Name
					LoadingFrame.Visible = false
					Confirm.AutoButtonColor = true
					No.AutoButtonColor = true
					Previous.AutoButtonColor = true
					Cancel.AutoButtonColor = true
				end
				wait(0.1)
				Guessing = false
			end

			Guess(-1)

			mainScroll.Visible = false
			Overlay.Visible = true
			guessLay.Visible = true

			table.insert(LocalConnections,No.MouseButton1Click:Connect(function()
				Guess(-1)
			end))

			table.insert(LocalConnections,Previous.MouseButton1Click:Connect(function()
				Guess(1)
			end))

			table.insert(LocalConnections,Confirm.MouseButton1Click:Connect(function()
				if not Guessing then
					Disconnect()

					LoadingFrame.Visible = false
					Confirm.AutoButtonColor = true
					No.AutoButtonColor = true
					Previous.AutoButtonColor = true
					Cancel.AutoButtonColor = true

					mainScroll.Visible = true
					Overlay.Visible = false
					guessLay.Visible = false

					DoneBindable:Fire(DecrementingId)
				end
			end))

			table.insert(LocalConnections,Cancel.MouseButton1Click:Connect(function()
				Disconnect()
				Canceling = true

				LoadingFrame.Visible = false
				Confirm.AutoButtonColor = true
				No.AutoButtonColor = true
				Previous.AutoButtonColor = true
				Cancel.AutoButtonColor = true

				mainScroll.Visible = true
				Overlay.Visible = false
				guessLay.Visible = false
				DoneBindable:Fire()
			end))

			table.insert(LocalConnections,donorClone:GetPropertyChangedSignal("Parent"):Connect(function()
				if donorClone.Parent == nil then
					Disconnect()
				end
			end))

			return DoneBindable.Event:Wait()
		end

		local focusDebounce = false

		table.insert(Connections,imageBox.FocusLost:connect(function()
			if imageBox.Text ~= "" then
				if not focusDebounce then
					focusDebounce = true
					imageBox.ClearTextOnFocus = false
					imageBox.TextEditable = false
					local Id = imageBox.Text
					imageBox.Text = Id..' (Converting)'
					local IsADecal = checkAsset(Id,13)
					if IsADecal then
						local Guessed = BeginGuessing(Id)
						if Guessed ~= nil then
							clientConfig.capeData.bImage = Guessed
							imageBox.Text = "Converted"
							wait(1)
							imageBox.Text = Guessed
							imageBox.ClearTextOnFocus = true
							imageBox.TextEditable = true
						else
							imageBox.Text = "Couldn't convert Image"
							imageBox.ClearTextOnFocus = true
							imageBox.TextEditable = true
						end
					else
						local IsAImage = checkAsset(Id,1)
						if IsAImage then
							imageBox.Text = Id
							clientConfig.capeData.bImage = Id
							imageBox.ClearTextOnFocus = true
							imageBox.TextEditable = true
						else
							imageBox.Text = "Not an image or a decal"
							imageBox.ClearTextOnFocus = true
							imageBox.TextEditable = true
						end
					end
					focusDebounce = false
				end
			end
		end))

		table.insert(Connections,matCancel.MouseButton1Click:connect(function()
			matScroll.CanvasPosition = Vector2.new(0,0)
			Overlay.Visible = false
			mainScroll.Visible = true
			matLay.Visible = false
			materialBox.Text = ""
		end))

		table.insert(Connections,materialBox.FocusLost:connect(function()
			if materialBox.Text ~= "" then
				clientConfig.capeData.bMaterial = checkMaterial(materialBox.Text) or "SmoothPlastic"
				materialBox.Text = tostring(clientConfig.capeData.bMaterial)
			end
		end))

		-- transBox

		table.insert(Connections,transBox.FocusLost:connect(function()
			if transBox.Text ~= "" then
				local Transparency = tonumber(transBox.Text)
				if Transparency then
					if Transparency < 0 or Transparency > 0.9 then
						transBox.Text = "Out of range. (0 - 0.9)"
					else
						clientConfig.capeData.bTrans = Transparency
					end
				else
					transBox.Text = "Not a number"
				end
			end
		end))

		spawn(function()
			local nDown = 0
			for i,v in pairs(materialList) do
				local button = matTemplate:clone()
				local textTemp = button:WaitForChild('TextLabel')
				textTemp.Text = v
				button.Name = v
				if nDown == 0 then
					button.Position = UDim2.new(0,1,0,30*nDown+5*nDown)
					nDown = 1
				else
					button.Position = UDim2.new(0,1,0,30*nDown+5*nDown)
					nDown = nDown+1
				end
				matScroll.CanvasSize = UDim2.new(0,0,0,30*nDown+5*nDown)
				button.Parent = matScroll
				button.Visible = true
				button.MouseButton1Click:connect(function()
					clientConfig.capeData.bMaterial = tostring(button.Name)
					materialBox.Text = tostring(button.Name)
					matLay.Visible = false
					Overlay.Visible = false
					mainScroll.Visible = true
					matScroll.CanvasPosition = Vector2.new(0,0)
				end)
			end
			matScroll.CanvasSize = UDim2.new(0,0,0,matScroll.CanvasSize.Y.Offset-5)
		end)

		table.insert(Connections,materialPicker.MouseButton1Click:connect(function()
			if not Overlay.Visible then
				Overlay.Visible = true
				matLay.Visible = true
				mainScroll.Visible = false
			end
		end))

		local applyDebounce = false		

		table.insert(Connections,capeApply.MouseButton1Click:connect(function()
			if focusDebounce then
				applyDebounce = true
				capeApply.Text = "Converting.."
				repeat
					wait()
				until not focusDebounce
				applyDebounce = false
			end
			if not clientConfig.Debounces.Cape and not applyDebounce then
				clientConfig.Debounces.Cape = true
				repeat
					wait()
				until not userInput:GetFocusedTextBox()
				capeApply.Text = "Applying, please wait..."
				local Result,Data = invokeServer('Cape',clientConfig.capeData)
				if Result then
					capeApply.Text = "Applied"
					wait(1)
					capeApply.Text = "Apply"
				elseif not Result then
					capeApply.Text = Data or "Error"
					wait(1)
					capeApply.Text = "Apply"
				end
				wait(0.25)
				clientConfig.Debounces.Cape = false
			end
		end))

		table.insert(Connections,capeRemove.MouseButton1Click:connect(function()
			if not clientConfig.Debounces.Cape then
				clientConfig.Debounces.Cape = true
				clientConfig.capeData.bColor = nil
				clientConfig.capeData.bImage = nil
				clientConfig.capeData.bMaterial = nil
				clientConfig.capeData.bTrans = nil
				capeRemove.Text = "Removing..."
				local Result,Data = invokeServer('Un Cape')
				if Result then
					capeRemove.Text = "Removed"
					wait(1)
					capeRemove.Text = "Remove"
				elseif not Result then
					capeRemove.Text = Data or "Error"
					wait(1)
					capeRemove.Text = "Remove"
				end
				wait(0.25)
				clientConfig.Debounces.Cape = false
			end
		end))

		local hatFrame = donorScroll:WaitForChild('Hat')
		local hatApply = hatFrame:WaitForChild('TextButton')
		local hatClear = hatFrame:WaitForChild("Remove")
		local hatBox = hatFrame.Frame:WaitForChild('Hat')	

		local faceFrame = donorScroll:WaitForChild('Face')
		local faceApply = faceFrame:WaitForChild('Apply')
		local faceBox = faceFrame.Frame:WaitForChild('Face')

		table.insert(Connections,faceBox.FocusLost:connect(function()
			if faceBox.Text ~= "" then
				clientConfig.Debounces.faceLoading = true
				faceBox.ClearTextOnFocus = false
				faceBox.TextEditable = false
				if checkAsset(faceBox.Text,18) then
					clientConfig.faceData = faceBox.Text
				else
					faceBox.Text = "Invalid Id.."
				end
				faceBox.ClearTextOnFocus = true
				faceBox.TextEditable = true
				clientConfig.Debounces.faceLoading = false
			end
		end))

		-- hatClear
		table.insert(Connections,hatClear.MouseButton1Click:connect(function()
			local PLR = game.Workspace:FindFirstChild(Players.LocalPlayer.Name)
			PLR.Head.Transparency = 0
			PLR.Head.face.Transparency = 0
		end))

		table.insert(Connections,faceApply.MouseButton1Click:connect(function()
			game.ReplicatedStorage.DonorEvent:FireServer(game.Players.LocalPlayer.Name)
		end))

		table.insert(Connections,hatBox.FocusLost:connect(function()
			if hatBox.Text ~= "" then
				clientConfig.Debounces.hatLoading = true
				hatBox.ClearTextOnFocus = false
				hatBox.TextEditable = false
				if checkAsset(hatBox.Text,8) or checkAsset(hatBox.Text,41) or checkAsset(hatBox.Text,42) or checkAsset(hatBox.Text,43) or checkAsset(hatBox.Text,44) or checkAsset(hatBox.Text,45) or checkAsset(hatBox.Text,46) then
					clientConfig.hatData = hatBox.Text
				else
					hatBox.Text = "Invalid Id.."
				end
				hatBox.ClearTextOnFocus = true
				hatBox.TextEditable = true
				clientConfig.Debounces.hatLoading = false
			end
		end))

		table.insert(Connections,hatApply.MouseButton1Click:connect(function()
			local PLR = game.Workspace:FindFirstChild(Players.LocalPlayer.Name)
			PLR.Head.Transparency = 1
			PLR.Head.face.Transparency = 1
		end))

		donorClone.Position = UDim2.new(0,-donorClone.Size.X.Offset-5,0.5,-150)
		donorClone.Parent = baseClip
		donorClone.Visible = true

		table.insert(Connections,exitButton.MouseButton1Click:connect(function()
			for a,b in pairs(Stacks.Frames) do
				if b == donorClone then
					table.remove(Stacks.Frames,a)
				end
			end
			figureFrames(Stacks.Frames)
			donorClone:TweenPosition(UDim2.new(donorClone.Position.X.Scale,donorClone.Position.X.Offset,1,5),"Out","Quint",0.3,true)
			repeat wait() until donorClone.Position == UDim2.new(donorClone.Position.X.Scale,donorClone.Position.X.Offset,1,5)
			donorClone:Destroy()
		end))

		local dragging
		local dragInput
		local dragStart
		local startPos	

		local function update(input)
			local delta = input.Position - dragStart
			local newYOffset = startPos.Y.Offset + delta.Y
			local newXOffset = startPos.X.Offset + delta.X

			local newPos = UDim2.new(startPos.X.Scale, newXOffset, startPos.Y.Scale, newYOffset)
			donorClone.Position = newPos
		end

		table.insert(Connections,Decoration.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = donorClone.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end))

		table.insert(Connections,Decoration.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end))

		table.insert(Connections,userInput.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end))

		table.insert(Connections,donorClone:GetPropertyChangedSignal("Parent"):Connect(function()
			if donorClone.Parent == nil then
				Disconnect()
			end
		end))

		table.insert(Stacks.Frames,donorClone)
		figureFrames(Stacks.Frames)
	elseif Type == "PBans" then
		createLabel()

		local pbansTemplate = baseClip:WaitForChild('PBans Template')	
		local pbanClone = pbansTemplate:Clone()
		local Controls = pbanClone:WaitForChild('Controls')

		local alertFrame = pbanClone:WaitForChild('Alert')
		local alertView = alertFrame:WaitForChild('View')
		local alertDecor = alertFrame:WaitForChild('Decoration')
		local alertClip = alertDecor:WaitForChild('Clipper')
		local alertLabel = alertClip:WaitForChild('Title')

		local exitButton = Controls:WaitForChild('Exit')
		local dataFrame = pbanClone:WaitForChild('Data')
		local mainScroll = dataFrame:WaitForChild('ScrollingFrame')
		local mainScrollTemplate = mainScroll:WaitForChild('Template')
		mainScrollTemplate.Visible = false
		local statFrame = pbanClone:WaitForChild('Status')
		local statusInner = statFrame:WaitForChild('Frame')
		local Decoration = Controls:WaitForChild('Decoration')
		local listTitle = Decoration:WaitForChild('Title')

		listTitle.Text = "Permanent Bans"

		local alertData = Data[1]

		if alertData then
			local appropSize = 0
			local changedListener
			changedListener = alertLabel.Changed:Connect(function()
				appropSize = alertLabel.TextBounds.X
				alertLabel.Size = UDim2.new(0,appropSize,1,0)
			end)

			alertLabel.Text = alertData
			dataFrame.Position = UDim2.new(0,5,1,-95)
			dataFrame.Size = UDim2.new(1,-10,0,90)
			statFrame.Position = UDim2.new(0,5,0,65)
			statFrame.Size = UDim2.new(1,-10,0,138)
			alertFrame.Visible = true
			local alertViewCon
			alertViewCon = alertView.MouseButton1Down:Connect(function()
				changedListener:Disconnect()
				alertViewCon:Disconnect()
				alertFrame.Visible = false
				statFrame.Position = UDim2.new(0,5,0,35)
				statFrame.Size = UDim2.new(1,-10,1,-40)
				fireServer("Notification Transfer",{"PSA",alertData})
			end)

			if not alertLabel.TextFits then
				local function Tween()
					local completedBindable = Instance.new('BindableEvent')
					if pbanClone and pbanClone.Parent ~= nil then
						pcall(function()
							alertLabel:TweenPosition(UDim2.new(0,-appropSize,0,0),'Out','Linear',3,true,function(Stat)
								wait(1)
								alertLabel.Position = UDim2.new(1,5,0,0)
								if alertLabel and alertLabel.Parent ~= nil then
									pcall(function()
										alertLabel:TweenPosition(UDim2.new(0,0,0,0),'Out','Linear',3,true,function(Stat)
											wait(1)
											completedBindable:Fire()
										end)
									end)
								end
							end)
						end)
					else
						completedBindable:Fire()
					end
					completedBindable.Event:Wait()
					completedBindable:Destroy()
				end

				delay(2,function()
					while pbanClone and pbanClone.Parent ~= nil and alertFrame.Visible == true do
						if not alertFrame.Visible then
							break
						end
						Tween()
					end
				end)
			end
		end

		local checkButton = statFrame:WaitForChild('TextButton')
		local mainBox = statusInner:WaitForChild('Box')
		local switchButton = statusInner:WaitForChild('Switch')

		pbanClone.Position = UDim2.new(0,-pbanClone.Size.X.Offset-5,0.5,-150)
		pbanClone.Parent = baseClip
		pbanClone.Visible = true

		local Mode = "Username"

		local Down = 0
		local stopLoops = {}
		local lastLoop = nil
		local loopManager = {}
		loopManager.__index = loopManager
		function loopManager.new() return setmetatable({}, loopManager) end

		function loopManager:Break()
			stopLoops[self] = true
		end

		function loopManager:NewLoop(Table)
			for a,b in pairs(mainScroll:GetChildren()) do
				if b.Name ~= 'Template' then
					b:Destroy()
				end
			end

			table.insert(Connections,mainScroll.ChildAdded:connect(function(Obj)
				if Obj:IsA('TextLabel') or Obj:IsA('TextBox') then
					table.insert(Connections,Obj.MouseEnter:connect(function()
						table.insert(Connections,Obj.MouseMoved:connect(function(X,Y)
							if Obj.Text == "This ban is a legacy ban." then
								mouseLabel.Text = "Basic Admin did some data restructuring, and this ban was from the old data structure."
							else
								mouseLabel.Text = Obj.Text
							end
							local XB,YB = mouseLabel.TextBounds.X, mouseLabel.TextBounds.Y
							mouseLabel.BorderSizePixel = 1
							mouseLabel.Size = UDim2.new(0,XB+10,0,YB+10)
							local mouseOffset
							if mouseLabel.AbsoluteSize.Y <= 28 then
								mouseOffset = ((mouseLabel.AbsoluteSize.Y*2)-5)
							else
								mouseOffset = 60
							end
							if X-(mouseLabel.AbsoluteSize.X) >= 0 then
								mouseLabel.Position = UDim2.new(0, X-(mouseLabel.AbsoluteSize.X), 0, Y-(mouseLabel.AbsoluteSize.Y/2)-mouseOffset)
							elseif X-(mouseLabel.AbsoluteSize.X) <= 0 then
								mouseLabel.Position = UDim2.new(0, X, 0, Y-(mouseLabel.AbsoluteSize.Y/2)-mouseOffset)
							end
						end))
					end))

					table.insert(Connections,Obj.MouseLeave:connect(function()
						mouseLabel.Text = ''
						mouseLabel.BorderSizePixel = 0
						mouseLabel.Size = UDim2.new(0,0,0,0)
					end))
				end
			end))

			local tempDown = 0
			if #Table >= 1 then
				for a,b in pairs(Table) do
					if stopLoops[self] then stopLoops[self] = nil break end

					local dataText = mainScrollTemplate:clone()
					dataText.Text = b
					dataText.Name = b

					if tempDown == 0 then
						dataText.Position = UDim2.new(0,5,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
						tempDown = 1
					else
						dataText.Position = UDim2.new(0,5,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
						tempDown = tempDown+1
					end

					mainScroll.CanvasSize = UDim2.new(0,0,0,dataText.Size.Y.Offset*tempDown+5*tempDown)
					dataText.Parent = mainScroll
					dataText.TextTransparency = 1
					dataText.Visible = true

					local tweenText = tweenService:Create(
						dataText,
						TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
						{TextTransparency = 0}
					)
					tweenText:Play()

					local textFrame = dataText:FindFirstChild('Frame')
					if textFrame then
						textFrame.BackgroundTransparency = 1
						local tweenFrame = tweenService:Create(
							textFrame,
							TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
							{BackgroundTransparency = 0.85}
						)
						tweenFrame:Play()
					end

					runService.RenderStepped:wait()
				end
			else
				local dataText = mainScrollTemplate:clone()
				mainScroll.CanvasSize = UDim2.new(0,0,0,dataText.Size.Y.Offset*Down+5*Down)
				dataText.Text = 'No Data'
				dataText.Parent = mainScroll
				dataText.Name = 'No Data'
				dataText.Visible = true
				local tweenText = tweenService:Create(
					dataText,
					TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
					{TextTransparency = 0}
				)
				tweenText:Play()

				local textFrame = dataText:FindFirstChild('Frame')
				if textFrame then
					local tweenFrame = tweenService:Create(
						textFrame,
						TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
						{BackgroundTransparency = 0.85}
					)
					tweenFrame:Play()
				end
			end
		end

		local function Check()
			if not clientConfig.Debounces.checkPban and mainBox.Text ~= "Username.." and mainBox.Text ~= "User ID.." then
				clientConfig.Debounces.checkPban = true
				repeat
					checkButton.Text = "Checking.."
					if userInput:GetFocusedTextBox() or pbanClone.Parent == nil then
						break
					end
					wait()
				until not userInput:GetFocusedTextBox()
				local Result,Data = invokeServer('Check PBan',Mode,mainBox.Text)
				local Down = 0

				spawn(function()
					local newLoop = loopManager.new()
					lastLoop = newLoop
					local dataTable = Data
					if Data and type(Data) ~= "table" then
						dataTable = {}
						if not Result then
							table.insert(dataTable,'Error: '..Data)
						else
							table.insert(dataTable,Data)
						end
					end
					newLoop:NewLoop(dataTable)
				end)

				checkButton.Text = "Check"
				clientConfig.Debounces.checkPban = false
			end
		end

		table.insert(Connections,checkButton.MouseButton1Down:Connect(function()
			Check()
		end))

		table.insert(Connections,switchButton.MouseButton1Down:Connect(function()
			if not clientConfig.Debounces.checkPban then
				if Mode == "Username" then
					mainBox.Text = "User ID.."
					switchButton.Text = "UN"
					Mode = "ID"
				else
					mainBox.Text = "Username.."
					switchButton.Text = "ID"
					Mode = "Username"
				end
			end
		end))

		local acceptableText

		table.insert(Connections,mainBox.FocusLost:Connect(function(enterPressed)
			if not clientConfig.Debounces.checkPban then
				if mainBox.Text == '' then
					if Mode == "Username" then
						mainBox.Text = "User ID.."
					else
						mainBox.Text = "Username.."
					end
				end
				acceptableText = mainBox.Text
				if enterPressed then
					Check()
				end
			else
				mainBox.Text = acceptableText
			end
		end))

		table.insert(Connections,exitButton.MouseButton1Click:connect(function()
			for a,b in pairs(Stacks.Frames) do
				if b == pbanClone then
					table.remove(Stacks.Frames,a)
				end
			end
			figureFrames(Stacks.Frames)
			pbanClone:TweenPosition(UDim2.new(pbanClone.Position.X.Scale,pbanClone.Position.X.Offset,1,5),"Out","Quint",0.3,true)
			repeat wait() until pbanClone.Position == UDim2.new(pbanClone.Position.X.Scale,pbanClone.Position.X.Offset,1,5)
			pbanClone:Destroy()
		end))

		spawn(function()
			local newLoop = loopManager.new()
			lastLoop = newLoop		
			newLoop:NewLoop({'Enter data to search.'})
		end)

		local dragging
		local dragInput
		local dragStart
		local startPos	

		local function update(input)
			local delta = input.Position - dragStart
			local newYOffset = startPos.Y.Offset + delta.Y
			local newXOffset = startPos.X.Offset + delta.X

			local newPos = UDim2.new(startPos.X.Scale, newXOffset, startPos.Y.Scale, newYOffset)
			pbanClone.Position = newPos
		end

		table.insert(Connections,Decoration.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = pbanClone.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end))

		table.insert(Connections,Decoration.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end))

		table.insert(Connections,userInput.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end))

		table.insert(Connections,pbanClone:GetPropertyChangedSignal("Parent"):Connect(function()
			if pbanClone.Parent == nil then
				Disconnect()
			end
		end))

		table.insert(Stacks.Frames,pbanClone)
		figureFrames(Stacks.Frames)
	elseif Type == "Hint" then
		if baseClip:FindFirstChild('Hint Clone') then
			local toRemove = baseClip:FindFirstChild('Hint Clone')
			toRemove:TweenPosition(UDim2.new(0,0,0,-toRemove.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
				if Stat == Enum.TweenStatus.Completed then
					toRemove:Destroy()
				end
			end)
		end

		local hintTemplate = baseClip:WaitForChild('Hint Template')
		local hintClone = hintTemplate:Clone()
		hintClone.Name = "Hint Clone"
		local hintButton = hintClone:WaitForChild('TextButton')
		local hintTop = hintClone:WaitForChild('Top')
		local hintBody = hintClone:WaitForChild('Body')
		local hintTitleText = hintTop:WaitForChild('Title')
		local hintBodyText = hintBody:WaitForChild('To Name Later')

		hintButton.MouseButton1Click:connect(function()
			hintClone:TweenPosition(UDim2.new(0,0,0,-hintClone.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
				if Stat == Enum.TweenStatus.Completed then
					hintClone:Destroy()
				end
			end)
		end)

		hintTitleText.Text = Data[1]
		hintBodyText.Text = Data[2]
		hintClone.Parent = baseClip
		hintClone.Visible = true
		hintClone.Position = UDim2.new(0,0,-1,0)
		hintClone:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
		local waitTime = (#hintBodyText.Text*0.1)+1
		if waitTime <= 1 then
			waitTime = 2.5
		elseif waitTime > 10 then
			waitTime = 10
		end
		wait(waitTime)
		pcall(function()
			if hintClone then
				hintClone:TweenPosition(UDim2.new(0,0,0,-hintClone.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
					if Stat == Enum.TweenStatus.Completed then
						hintClone:Destroy()
					end
				end)
			end
		end)
	end
end

local function pendNotif(Title,Desc,Data)
	spawn(function()
		local notificationContainer = baseClip:WaitForChild('Container')
		local Notification = notificationContainer:WaitForChild('Template')	
		local notifClone = Notification:Clone()
		local notifInner = notifClone:WaitForChild('Inner')
		local notifControls = notifInner:WaitForChild('Controls')
		local notifTitle = notifControls.Decoration:WaitForChild('Title')
		local notifExit = notifControls:WaitForChild('Exit')
		local notifOpen = notifInner:WaitForChild('Open')
		local notifDesc = notifInner:WaitForChild('Desc')
		notifClone.Name = 'Notif Clone'
		notifClone.Visible = true
		notifClone.Parent = notificationContainer
		notifTitle.Text = Title
		notifDesc.Text = Desc

		local receiveSound = Instance.new('Sound',Workspace.CurrentCamera)
		receiveSound.Name = 'Notification'
		if Settings.NotifySoundID == nil then
			receiveSound.SoundId = 'rbxassetid://255881176' -- Want the old one? Replace the ID with 255881176
		elseif Settings.NotifySoundID == false then
			receiveSound.SoundId = 'rbxassetid://0' -- Want the old one? Replace the ID with 255881176
		else
			receiveSound.SoundId = Settings.NotifySoundID -- Want the old one? Replace the ID with 255881176	
		end
		receiveSound.Volume = 1
		receiveSound.Pitch = 1
		receiveSound.PlayOnRemove = true
		receiveSound:Destroy()

		notifClone.Position = UDim2.new(0,0,1,0)
		notifInner.Position = UDim2.new(0,0,1,0)
		notifInner:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)

		if Data[5] then
			local Tag = Instance.new('StringValue',notifClone)
			Tag.Name = "Tag"
			Tag.Value = Data[5]
		end

		local exitConnection
		exitConnection = notifExit.MouseButton1Click:connect(function()
			exitConnection:Disconnect()
			if Data[5] then
				fireServer("Notification Transfer",{"Complete Message",Data[5]})

			end
			for a,b in pairs(Stacks.Notifs) do
				if b == notifClone then
					table.remove(Stacks.Notifs,a)
				end
			end
			notifClone:Destroy()
			figureNotifs(Stacks.Notifs,notificationContainer)
		end)

		local openConnection
		openConnection = notifOpen.MouseButton1Click:connect(function()
			openConnection:Disconnect()
			fireServer('Notification Transfer',Data)
			for a,b in pairs(Stacks.Notifs) do
				if b == notifClone then
					table.remove(Stacks.Notifs,a)
				end
			end
			notifClone:Destroy()
			figureNotifs(Stacks.Notifs,notificationContainer)
		end)
		table.insert(Stacks.Notifs,notifClone)
		figureNotifs(Stacks.Notifs,notificationContainer)
	end)
end

local layoutConnection

local function moveOn(pageLayout,dmInner,lastPm)
	pageLayout:Previous()
	local function Fade(Wait)
		local Done = Instance.new('BindableEvent')
		local countEvent = Instance.new('BindableEvent')
		local Frames,Tweens_Completed = {},{}
		local Count_Connection
		Count_Connection = countEvent.Event:Connect(function(Data)
			table.insert(Tweens_Completed,Data)
			if #Frames == #Tweens_Completed then
				Count_Connection:Disconnect()
				countEvent:Destroy()
				lastPm:Destroy()
				Done:Fire()
			end
		end)
		for a,b in next,lastPm:GetDescendants() do
			if b:IsA('Frame') or b:IsA('TextBox') or b:IsA('TextLabel') or b:IsA('TextButton') then
				table.insert(Frames,b)
			end
		end
		for c,d in next,Frames do
			local Tween = tweenService:Create(
				d,
				TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}				
			)
			local CompletedCon
			CompletedCon = Tween.Completed:Connect(function()
				CompletedCon:Disconnect()
				Tween:Destroy()
				countEvent:Fire(d)
			end)
			Tween:Play()
			if d:IsA('TextBox') or d:IsA('TextLabel') or d:IsA('TextButton') then
				local Tween = tweenService:Create(
					d,
					TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
					{TextTransparency = 1}				
				)
				local CompletedCon2
				CompletedCon2 = Tween.Completed:Connect(function()
					CompletedCon2:Disconnect()
					Tween:Destroy()
					countEvent:Fire(d)
				end)
				Tween:Play()
			end
		end
		if Wait then
			Done.Event:Wait()
			Done:Destroy()
		end
	end
	Fade()
	local Con_1
	Con_1 = pageLayout.PageLeave:Connect(function(Obj)
		if Obj == lastPm then
			Con_1:Disconnect()
			Obj:Destroy()
		end
	end)
	local Con_2
	Con_2 = pageLayout.PageEnter:Connect(function(Obj)
		if Obj == lastPm then
			Con_2:Disconnect()
			Obj:Destroy()
		end
	end)
	local Con_3
	Con_3 = pageLayout.Stopped:Connect(function(Obj)
		if Obj == lastPm then
			Con_3:Disconnect()
			Obj:Destroy()
		end
	end)
	local realChildren = 0
	for a,b in next,dmInner:GetChildren() do
		if b:IsA('Frame') then
			realChildren = realChildren + 1
		end
	end
	lastPm.Changed:Connect(function()
		if lastPm.Parent == nil then
			local realChildren = 0
			for a,b in next,dmInner:GetChildren() do
				if not b:IsA('UIPageLayout') then
					realChildren = realChildren + 1
				end
			end
			if realChildren == 0 then
				Fade(true)
				dmInner.Visible = false
			end
		end
	end)
end

local function displayPM(Sender,Data,Override,ID)
	local dmFrame = baseClip:WaitForChild('Direct Messages')
	local holderFrame = dmFrame:WaitForChild('Holder')
	local dmInner = dmFrame:WaitForChild('Inner')
	local pageLayout = dmInner:WaitForChild('UIPageLayout')

	if not Override then
		pendNotif("Personal Message","From "..Sender,{"Receive",Sender,Data,true,ID})
		return
	end

	local pmFrame = baseClip:WaitForChild('Personal Message Template')
	local pmClone = pmFrame:Clone()

	if layoutConnection and layoutConnection.Connected then
		layoutConnection:Disconnect()
	end

	layoutConnection = pageLayout.Changed:Connect(function(Prop)
		if Prop == "CurrentPage" then
			dmInner:TweenSize(UDim2.new(0,420,0.1,pageLayout.CurrentPage.Size.Y.Offset),'Out','Quint',0.3,true)
		end
	end)	

	dmInner.Visible = true

	if ID then
		local Tag = Instance.new('StringValue',pmClone)
		Tag.Name = "Tag"
		Tag.Value = ID
	end

	local pmTop = pmClone:WaitForChild('Top')
	local pmControls = pmTop:WaitForChild('Controls')
	local pmTitle = pmControls.Decoration:WaitForChild('Title')
	local pmBottom = pmClone:WaitForChild('Bottom')

	local pmExit = pmControls:WaitForChild('Exit')
	local pmBody = pmTop.Body['To Name Later']
	local pmBox = pmBottom.Frame.Entry:WaitForChild('TextBox')
	local pmBoxButtonlolz = pmBox:WaitForChild('TextButton')
	local pmSend = pmBottom.Frame.Options:WaitForChild('Send')
	local pmCancel = pmBottom.Frame.Options:WaitForChild('Cancel')

	local pmRead = pmBottom.Frame.Options:WaitForChild('Read')	
	local pmReadReceipt = pmRead:WaitForChild('Toggled')

	pmReadReceipt.Size = UDim2.new(0,0,0,0)
	pmReadReceipt.Visible = true

	pmClone.Name = "PM Clone"
	pmClone.Parent = holderFrame
	pmClone.Visible = true

	if ID then
		pmTitle.Text = "Message from "..Sender
	else
		pmSend.Visible = false
		pmCancel.Text = "Close"
		pmTitle.Text = Sender
	end

	local addedConnection 
	addedConnection = pmBody.Changed:Connect(function(Wa)
		if Wa == "TextBounds" then
			addedConnection:Disconnect()
			local bodyBounds_Y = pmBody.TextBounds.Y
			pmTop.Size = UDim2.new(1,0,0,bodyBounds_Y+47)
			pmClone.Size = UDim2.new(0,420,0,pmTop.AbsoluteSize.Y+pmBottom.AbsoluteSize.Y+5)
			dmInner:TweenSize(UDim2.new(0,420,0.1,pmClone.Size.Y.Offset),'Out','Quint',0.3,true)
			pmClone.Parent = dmInner
			if Override then
				pageLayout:JumpTo(pmClone)
			end
		end
	end)	

	if (not Data) or Data == "" then
		Data = "No Data was typed in this Message."
	end

	pmBody.Text = Data

	if ID then
		local sendConnection
		sendConnection = pmSend.MouseButton1Click:connect(function()
			sendConnection:Disconnect()
			fireServer("Notification Transfer",{"Send",Sender,pmBox.Text,false,ID})
			moveOn(pageLayout,dmInner,pmClone)
		end)
	end

	local exitConnection
	exitConnection = pmExit.MouseButton1Click:connect(function()
		exitConnection:Disconnect()
		fireServer("Notification Transfer",{"Complete Message",ID})
		moveOn(pageLayout,dmInner,pmClone)
	end)

	local cancelConnection
	cancelConnection = pmCancel.MouseButton1Click:connect(function()
		cancelConnection:Disconnect()
		fireServer("Notification Transfer",{"Complete Message",ID})
		moveOn(pageLayout,dmInner,pmClone)
	end)

	local lastClick
	pmBoxButtonlolz.MouseButton1Down:Connect(function()
		if not lastClick then
			lastClick = tick()
			pmBox:CaptureFocus()
		else
			if tick()-lastClick < 0.25 then
				pmBox.Text = ""
				pmBox:CaptureFocus()
			else
				pmBox:CaptureFocus()
			end
			lastClick = tick()
		end
	end)

	local Delaying
	pmBox.Focused:Connect(function()
		Delaying = httpService:GenerateGUID(false)
		local storedDelay = Delaying
		delay(0.5,function()
			if Delaying == storedDelay then
				if pmBox:IsFocused() and pmBoxButtonlolz then
					pmBoxButtonlolz.Visible = false
				end
			end
		end)
	end)

	if ID then
		local focusConnection
		focusConnection = pmBox.FocusLost:connect(function(enterPressed)
			pmBoxButtonlolz.Visible = true
			if enterPressed then
				focusConnection:Disconnect()
				fireServer("Notification Transfer",{"Send",Sender,pmBox.Text,false,ID})
				moveOn(pageLayout,dmInner,pmClone)
				--			else
				--				if pmBox.Text == "" then
				--					pmBox.Text = "Enter reply here.."
				--				end
			end
		end)
	else
		pmBox.Text = "You're unable to reply to this message, "..Player.DisplayName.."."
	end

	--	pmRead.MouseButton1Down:connect(function()
	--		if not sendingRead then
	--			sendingRead = true
	--			pmReadReceipt:TweenSize(UDim2.new(1,-10,1,-10),'Out','Quart',0.15,true)
	--		else
	--			sendingRead = false
	--			pmReadReceipt:TweenSize(UDim2.new(0,0,0,0),'Out','Quart',0.15,true)
	--		end
	--	end)

	local acceptableText
	pmBox.Changed:Connect(function(Prop)
		if Prop == "TextBounds" then
			pmBottom.Size = UDim2.new(1,0,0,200)
			if pmBox.TextFits then
				if ID then
					acceptableText = pmBox.Text
				else
					acceptableText = "You're unable to reply to this message, "..Player.DisplayName..""
					pmBox.Text = acceptableText
				end

				local Bound_Y = pmBox.TextBounds.Y

				pmBottom.Size = UDim2.new(1,0,0,Bound_Y+57)
				pmBottom.Position = UDim2.new(0,0,1,-pmBottom.Size.Y.Offset)
			else
				pmBox.Text = acceptableText or ""
			end
		end
	end)

	pmBottom.Changed:Connect(function(Prop)
		if Prop == "Size" then
			pmClone.Size = UDim2.new(0,420,0,pmTop.Size.Y.Offset+pmBottom.Size.Y.Offset+5)
			dmInner:TweenSize(UDim2.new(0,420,0.1,pmClone.Size.Y.Offset),'Out','Quint',0.3,true)
		end
	end)
end
local function viewPlayer(Who)
	if Who == nil then
		game.Workspace.CurrentCamera.CameraType = 'Custom'
		game.Workspace.CurrentCamera.FieldOfView = 70
		game.Workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
	elseif Who then
		game.Workspace.CurrentCamera.CameraSubject = Who
	end
end

local capeData = {}
spawn(function()
	repeat
		runService.RenderStepped:wait()
	until clientConfig.donorEnabled ~= nil
	runService.RenderStepped:connect(function()
		for a,b in next,Players:GetPlayers() do
			if b.Character and b.Character:FindFirstChild('BAE Cape') and b.Character:FindFirstChild('Humanoid') then
				local Cape = b.Character['BAE Cape']
				local Humanoid = b.Character.Humanoid
				if Cape:FindFirstChild('Motor') then
					local capeMotor = Cape.Motor
					local basePart
					if Humanoid.RigType == Enum.HumanoidRigType.R15 then
						basePart = b.Character:WaitForChild('UpperTorso')
					else
						basePart = b.Character:WaitForChild('Torso')
					end
					if capeData[b.UserId] == nil then
						capeData[b.UserId] = {}
					end
					capeData[b.UserId]['Angle'] = 0
					local oldMagnitude = basePart.Velocity.magnitude
					if capeData[b.UserId]['Wave'] then
						capeData[b.UserId]['Angle'] = capeData[b.UserId]['Angle'] + ((basePart.Velocity.magnitude/11)*0.01)
						capeData[b.UserId]['Wave'] = false
					else
						capeData[b.UserId]['Wave'] = true
					end
					capeData[b.UserId]['Angle'] = capeData[b.UserId]['Angle'] + math.min(basePart.Velocity.magnitude/11, 0.6)
					capeMotor.MaxVelocity = math.min((basePart.Velocity.magnitude/111), 0.03)
					capeMotor.DesiredAngle = -capeData[b.UserId]['Angle']
					if capeMotor.CurrentAngle < -.15 and capeMotor.DesiredAngle > -.15 then
						capeMotor.MaxVelocity = 0.04
					end
				end
			else
				if capeData[b.UserId] then
					capeData[b.UserId] = nil
				end
			end
		end	
	end)
end)

local function keyDown(Key)
	return userInput:IsKeyDown(Key)
end

local function flyPlayer(Val)
	if Val then
		if not clientConfig.Flying and clientConfig.canFly then
			clientConfig.Flying = true
		else
			return
		end

		if not Player.Character then
			return
		end

		local rootPart = Player.Character:WaitForChild('HumanoidRootPart')	
		local Humanoid = Player.Character:WaitForChild('Humanoid')

		local maxSpeed,M,Acc,Dir,CF = 100, 5, Vector3.new()
		local bodyGyro = Instance.new('BodyGyro',rootPart)
		local bodyVelo = Instance.new('BodyVelocity',rootPart)

		bodyGyro.D = 200
		bodyVelo.P = 5000

		bodyGyro.CFrame = rootPart.CFrame	
		local boolVal = Instance.new('BoolValue',rootPart)
		boolVal.Name = 'Fly'

		boolVal.Changed:connect(function(Prop)
			if Prop then
				local Force = Prop and Vector3.new(9e9,9e9,9e9) or Vector3.new()
				Humanoid.PlatformStand, bodyGyro.MaxTorque, bodyVelo.MaxForce = Prop,Force,Force
				Apple = Humanoid.Changed:connect(function(Wat)
					if not clientConfig.Flying then
						Apple:disconnect()
					end
					Humanoid.Jump = false
				end)
			end
		end)

		boolVal.Value = true

		spawn(function()
			repeat
				if boolVal.Value then
					wait()
					Dir, CF = Humanoid.MoveDirection, game.Workspace.CurrentCamera.CoordinateFrame
					Dir = (CF:inverse() * CFrame.new(CF.p + Dir)).p
					Acc = Acc * 0.95
					local inABox = userInput:GetFocusedTextBox()
					Acc = Vector3.new(math.max(-maxSpeed,math.min(maxSpeed, Acc.x + Dir.x * M)),math.max(-maxSpeed,math.min(maxSpeed and not inABox and (keyDown(Enum.KeyCode.Space) and Acc.y + M or keyDown(Enum.KeyCode.LeftControl) and Acc.y - M) or Acc.y)),math.max(-maxSpeed,math.min(maxSpeed, Acc.z + Dir.z * M))) bodyGyro.cframe, bodyVelo.velocity = CF,(CF * CFrame.new(Acc)).p-CF.p
				else
					wait()
				end
			until not boolVal.Value
		end)
	else
		if Player.Character then
			local rootPart = Player.Character:WaitForChild('HumanoidRootPart')
			local Humanoid = Player.Character:WaitForChild('Humanoid')
			if rootPart:FindFirstChild('Fly') and rootPart:FindFirstChild('BodyGyro') and rootPart:FindFirstChild('BodyVelocity') then
				if clientConfig.Flying then
					clientConfig.Flying = false
				else
					return
				end
				Humanoid.PlatformStand = false
				rootPart:FindFirstChild('BodyGyro'):Destroy()
				rootPart:FindFirstChild('BodyVelocity'):Destroy()
				local boolVal = rootPart:FindFirstChild('Fly')
				if boolVal.Value then
					boolVal.Value = false
					boolVal:Destroy()
				end
			end
		end
	end
end

local function Console()
	pcall(function()
		local function queryTable(Table,Data)
			local found = nil
			local Succ,Msg = pcall(function()
				if Data == nil then return end
				for _,search in pairs(Table) do
					if string.find(string.lower(search[1]),string.lower(Data)) == 1 then
						-- if found then return nil end -- ambig
						found = search[1]
					end
				end
			end)
			return found
		end
		local Result
		local consoleFrame = baseClip:WaitForChild('Console')
		local consoleInner = consoleFrame:WaitForChild('Frame')
		local consoleBox = consoleInner:WaitForChild('TextBox')
		local consoleText = consoleInner:WaitForChild('TextLabel')
		if not consoleOpen then
			consoleOpen = true
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			spawn(function()
				for i,v in pairs(baseClip:GetChildren()) do
					if v.Name == 'Hint Clone' then
						v:TweenPosition(UDim2.new(0,0,0,-v.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
							if Stat == Enum.TweenStatus.Completed then
								v:Destroy()
							end
						end)
					end
				end
			end)
			consoleFrame.Position = UDim2.new(0,0,0,-31)
			consoleText.Text = 'Enter a command, ' ..Player.DisplayName
			consoleBox.Text = ''
			consoleFrame.Visible = true
			consoleBox:CaptureFocus()
			consoleFrame:TweenPosition(UDim2.new(0,0,0,0),'Out','Quint',0.3,true)
		else
			consoleOpen = false
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
			consoleText.Text = 'Enter a command, ' ..Player.DisplayName
			consoleBox.Text = ''
			consoleBox:ReleaseFocus()
			consoleFrame:TweenPosition(UDim2.new(0,0,0,-consoleFrame.AbsoluteSize.Y),'Out','Quint',0.3,true)
		end
		if not console_1 then
			console_1 = consoleBox.Changed:connect(function()
				Result = nil
				if #consoleBox.Text >= 1 then
					Result = queryTable(clientConfig.commandsTable,consoleBox.Text)
					if Result and Result ~= consoleBox.Text then
						consoleText.Text = Result
					else
						consoleText.Text = ''
					end
				elseif #consoleBox.Text == 0 then
					consoleText.Text = 'Enter a command...'
				end
				if consoleBox.Text:lower():match('	') then
					Result = queryTable(clientConfig.commandsTable,consoleBox.Text:match("%a+"))
					if not Result then return end
					consoleBox.Text = Result
					canClose = false
					--consoleBox:ReleaseFocus()
					consoleBox.CursorPosition = #consoleBox.Text + 1
					consoleBox:CaptureFocus()
					canClose = true
				elseif consoleBox.Text == "'" then
					consoleBox.Text = ''
				end
			end)
		end
		if not console_2 then
			console_2 = consoleBox.FocusLost:connect(function(enterPressed)
				if enterPressed then
					if consoleBox.Text ~= '' then
						--						essentialsEvent:FireServer(clientConfig.Key,'Execute',consoleBox.Text)
						fireServer('Execute',consoleBox.Text)
					end
				end
				if canClose then
					Console()
				end
			end)
		end
	end)
end
local settings = require(game.ReplicatedStorage.ExtraSettings)
userInput.InputBegan:connect(function(Input,Processed)
	local inABox = userInput:GetFocusedTextBox()
	if inABox then return end
	if not inABox then
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			local keyPressed = Input.KeyCode
			if keyPressed == Enum.KeyCode.Quote then
				if clientConfig.Key and clientConfig.Permission and clientConfig.Permission >= 1 and Settings.CommandBarRestrictionEnabled == false then
					Console()
				else
					pendNotif("Error","Console Is Disabled","Console")
				end
			elseif keyPressed == Enum.KeyCode.E then
				if clientConfig.Flying then
					flyPlayer(false)
				elseif not clientConfig.Flying and clientConfig.canFly then
					flyPlayer(true)
				end
			end
		end
	end
end)

local function commandConfirmation(Command,Argument)
	if baseClip:FindFirstChild('Confirmation Clone') then
		return false
	end
	local toReturn
	local confirmationTemplate = baseClip:WaitForChild('Confirmation')
	local confirmationClone = confirmationTemplate:Clone()
	confirmationClone.Name = "Confirmation Clone"
	confirmationClone.Parent = baseClip
	confirmationClone.Position = UDim2.new(0.5,-210,0,-confirmationClone.Size.Y.Offset)
	confirmationClone.Visible = true
	local Body = confirmationClone:WaitForChild('Body')
	local Options = Body:WaitForChild('Options')
	local Confirm,Cancel = Options:WaitForChild('Confirm'),Options:WaitForChild('Cancel')
	local commandText = Body:WaitForChild('Command')
	commandText.Text = '"'..Command..' '..Argument..'"'
	confirmationClone:TweenPosition(UDim2.new(0.5,-210,0.5,-70),"Out",'Quint',0.3,true)
	Confirming = Confirm.MouseButton1Click:connect(function()
		Confirming:Disconnect()
		confirmationClone:TweenPosition(UDim2.new(0.5,-210,1,0),"Out",'Quint',0.3,true,function(Stat)
			if Stat == Enum.TweenStatus.Completed then
				confirmationClone:Destroy()
			end
		end)
		toReturn = true
	end)
	Cancelling = Cancel.MouseButton1Click:connect(function()
		Cancelling:Disconnect()
		confirmationClone:TweenPosition(UDim2.new(0.5,-210,1,0),"Out",'Quint',0.3,true,function(Stat)
			if Stat == Enum.TweenStatus.Completed then
				confirmationClone:Destroy()
			end
		end)
		toReturn = false
	end)
	repeat
		wait()
	until toReturn ~= nil
	return toReturn
end


function essentialsFunction.OnClientInvoke(Starter,...)
	local Data = {...}
	if Starter == "Command Confirmation" then
		if not clientConfig.Key then
			local queueEvent = Instance.new('BindableEvent')
			Queued_Actions[queueEvent] = true
			queueEvent.Event:Wait()
			Queued_Actions[queueEvent] = nil
			queueEvent:Destroy()
		end
		local Reply = commandConfirmation(Data[1],Data[2])
		return Reply
	elseif Starter == "Client Setup" then
		if not clientConfig.Permission and not clientConfig.Key then
			for a,b in next,Data[1] do
				clientConfig[a] = b
			end
			local Settings = require(game.ReplicatedStorage.ExtraSettings)
			testService:Message("Basic Admin Remade 2.0 | "..clientConfig.Version.." | Prefix: \""..clientConfig.Prefix.."\" | Act. Prefix: \""..clientConfig.actionPrefix.."\"")
			local adminTitle
			if clientConfig.Permission == 1 then
				adminTitle = Settings["Rank Config"][1]
			elseif clientConfig.Permission == 2 then
				adminTitle = Settings["Rank Config"][2]
			elseif clientConfig.Permission == 3 then
				adminTitle = Settings["Rank Config"][3]
			elseif clientConfig.Permission == 4 then
				adminTitle = Settings["Rank Config"][4]
				
			


				testService:Message("Basic Admin Remade | DP: "..tostring(clientConfig.donorEnabled).." | CD: "..tostring(clientConfig.Debugging))
			end
			if adminTitle then
				pendNotif(adminTitle,'Click for Commands',{'Cmds'})
			end

			return clientConfig.Key
		end
	end
end

local function localName(otherPlayer,Data)
	if otherPlayer and otherPlayer.Character then
		local oldNamed = otherPlayer.Character:FindFirstChild('BAE_Named',true)	

		local Head = otherPlayer.Character:WaitForChild('Head')
		if oldNamed and oldNamed.Parent:IsA('Model') and oldNamed:IsDescendantOf(otherPlayer.Character) then
			oldNamed.Parent:Destroy()
			if not Data then
				Head.Transparency = 0
				return
			end
		end

		if Data then
			local headClone = Head:Clone()
			headClone.Transparency = 0

			local fakeModel = Instance.new("Model", otherPlayer.Character)
			fakeModel.Name = Data
			headClone.Parent = fakeModel

			local removeOldTag = Instance.new('BoolValue')
			removeOldTag.Name = "BAE_Named"
			removeOldTag.Parent = fakeModel

			local fakeHum = Instance.new("Humanoid", fakeModel)
			fakeHum.Name = "Name Tag"
			fakeHum.MaxHealth = 0
			fakeHum.Health = 0

			local Weld = Instance.new("Weld", headClone)
			Weld.Part0 = headClone
			Weld.Part1 = Head
			Head.Transparency = 1
		end
	end
end




essentialsEvent.OnClientEvent:connect(function(Starter,...)
	if not clientConfig.Key then
		local queueEvent = Instance.new('BindableEvent')
		Queued_Actions[queueEvent] = true
		queueEvent.Event:Wait()
		Queued_Actions[queueEvent] = nil
		queueEvent:Destroy()
	end

	local Data = {...}
	if Starter == "Message" then
		Display("Message",{Data[1],Data[2]})
	elseif Starter == "Communications Ready" then
		for Event,_ in next,Queued_Actions do
			if Event ~= nil and Queued_Actions[Event] ~= nil then
				Event:Fire()
			end
		end
	elseif Starter == "Donor" then
		Display("Donor")
	elseif Starter == "PBans" then
		Display("PBans",Data)
	elseif Starter == "List" then
		Display("List",Data)
	elseif Starter == "Notif" then
		pendNotif(Data[1],Data[2],Data[3])
	elseif Starter == "Local Name" then
		localName(Data[1],Data[2])
	elseif Starter == "PM" then
		displayPM(Data[1],Data[2],Data[3],Data[4])
	elseif Starter == "Hint" then
		Display('Hint',{Data[1],Data[2]})
	elseif Starter == "View" then
		viewPlayer(Data[1])
	elseif Starter == "Crash" then
		crashPlayer()
	elseif Starter == "Admin Update" then
		if Data[1] and Data[2] and Data[3] then
			pendNotif(Data[1],Data[2],Data[3])
		end
		clientConfig.Permission = Data[5]
		clientConfig.commandsTable = Data[4]
	elseif Starter == "Fly" then
		if Data[1] then
			clientConfig.canFly = true
			flyPlayer(true)
		else
			clientConfig.canFly = false
			flyPlayer(false)
		end
	elseif Starter == "Clear" then
		pcall(function()
			for a,b in next,baseClip:GetChildren() do
				if b.Name == 'Message Clone' then
					b:TweenPosition(UDim2.new(0,0,1,0),'Out','Quint',0.3,true,function(Done)
						if Done == Enum.TweenStatus.Completed and b then
							b:Destroy()
						elseif Done == Enum.TweenStatus.Canceled and b then
							b:Destroy()
						end
					end)
				end
			end
		end)
		spawn(function()
			if baseClip:FindFirstChild('Hint Clone') then
				local toRemove = baseClip:FindFirstChild('Hint Clone')
				toRemove:TweenPosition(UDim2.new(0,0,0,-toRemove.AbsoluteSize.Y),'Out','Quint',0.3,true,function(Stat)
					if Stat == Enum.TweenStatus.Completed then
						toRemove:Destroy()
					end
				end)
			end
		end)
	end
end)

if Settings.DefendedMessage.Enabled == true or Settings.DefendedMessage.Enabled == nil then
	wait(Settings.DefendedMessage.Delay)
	pendNotif(Settings.DefendedMessage.Title, Settings.DefendedMessage.Description, {'clear'})
	
end
