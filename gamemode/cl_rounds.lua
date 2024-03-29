
GM.RoundStage = 0
GM.LootCollected = 0
GM.RoundSettings = {}
if GAMEMODE then
	GM.RoundStage = GAMEMODE.RoundStage
	GM.LootCollected = GAMEMODE.LootCollected
	GM.RoundSettings = GAMEMODE.RoundSettings
end

function GM:GetRound()
	return self.RoundStage or 0
end

net.Receive("SetRound", function (length)
	local r = net.ReadUInt(8)
	local start = net.ReadDouble()
	GAMEMODE.RoundStage = r
	GAMEMODE.RoundStart = start

	GAMEMODE.RoundSettings = {}
	local settings = net.ReadUInt(8)
	if settings != 0 then
		GAMEMODE.RoundSettings.ShowAdminsOnScoreboard = net.ReadUInt(8) != 0
		GAMEMODE.RoundSettings.AdminPanelAllowed = net.ReadUInt(8) != 0
		GAMEMODE.RoundSettings.ShowSpectateInfo = net.ReadUInt(8) != 0
	end

	if r == GAMEMODE.Round.RoundStarting then
		GAMEMODE.StartNewRoundTime = net.ReadDouble()
	end

	if r == GAMEMODE.Round.Playing then
		timer.Simple(0.2, function ()
			local pitch = math.random(70, 140)
			if IsValid(LocalPlayer()) then
				LocalPlayer():EmitSound("ambient/creatures/town_child_scream1.wav", 100, pitch)
			end
		end)
		GAMEMODE.LootCollected = 0
	end
end)

net.Receive("time_remaining_round", function (length)
	GAMEMODE.PlayTimeLeft = net.ReadInt(10)
end)

net.Receive("plyaer_coords", function (length)
	GAMEMODE.PlayerCoords = net.ReadTable()
end)

net.Receive("DeclareWinner" , function (length)
	local data = {}
	data.reason = net.ReadUInt(8)
	data.murderer1 = net.ReadEntity(1)
	data.murderer1Color = net.ReadVector()
	data.murderer1Name = net.ReadString()
	murderer2 = net.ReadBool()
	if murderer2 then
		data.murderer2 = net.ReadEntity()
		data.murderer2Color = net.ReadVector()
		data.murderer2Name = net.ReadString()
	end
	
	data.collectedLoot = {}
	while true do
		local cont = net.ReadUInt(8)
		if cont == 0 then break end

		local t = {}
		t.player = net.ReadEntity()
		if IsValid(t.player) then
			t.playerName = t.player:Nick()
		end
		t.count = net.ReadUInt(32)
		t.playerColor = net.ReadVector()
		t.playerBystanderName = net.ReadString()
		table.insert(data.collectedLoot, t)
	end

	GAMEMODE:DisplayEndRoundBoard(data)

	local pitch = math.random(80, 120)
	if IsValid(LocalPlayer()) then
		LocalPlayer():EmitSound("ambient/alarms/warningbell1.wav", 100, pitch)
	end
end)

net.Receive("GrabLoot", function (length)
	GAMEMODE.LootCollected = net.ReadUInt(32)
end)

net.Receive("SetLoot", function (length)
	GAMEMODE.LootCollected = net.ReadUInt(32)
end)