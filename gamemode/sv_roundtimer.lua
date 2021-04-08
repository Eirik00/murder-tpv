
util.AddNetworkString("time_remaining_round")
util.AddNetworkString("plyaer_coords")

function GM:StartRoundTimer()
	self.EndRoundTime = math.ceil(CurTime() + self.PlayTime:GetInt())
	
	
	timer.Create( "SendSecondsLeft", 1, self.EndRoundTime, function()
		local timeLeft = self:GetTimeLeft()
		self:SendRoundTimer(timeLeft)
		if timeLeft <= 60 and timeLeft % 5 == 0 then
			self:SendPlayerCoords()
		end
	end)
end

function GM:GetTimeLeft()
	if self.EndRoundTime then
		local timeLefta = self.EndRoundTime - CurTime() 
		local timeLeftb = math.ceil(timeLefta)
		return timeLeftb
	else
		return 0
	end
end

function GM:EndRoundTimer()
	timer.Remove("SendSecondsLeft")
end

function GM:SendRoundTimer( seconds)
	net.Start( "time_remaining_round" )
	net.WriteInt(seconds, 10)
	net.Broadcast()
end

function GM:SendPlayerCoords()
	local players = team.GetPlayers(2)
	local pos = {}
	
	for k, v in pairs(players) do
		if IsValid(v) and v:Alive() then
			local vp = v:GetPos()
			local x = math.floor(vp.x)
			local y = math.floor(vp.y)
			local z = math.floor(vp.z)
			local vectorv = Vector(x,y,z)
			table.insert(pos,vectorv)
		end
	end
	net.Start( "plyaer_coords" )
	net.WriteTable(pos)
	net.Broadcast()
end
