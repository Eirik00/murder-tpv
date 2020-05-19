
function GM:SetAmMurderer(bool)
	self.Murderer = bool
end

function GM:GetAmMurderer(bool)
	return self.Murderer
end

net.Receive( "your_are_a_murderer", function( length, client )
	local am = net.ReadUInt(8) != 0
	GAMEMODE:SetAmMurderer(am)
end)


--[[function GM:SetTwoMurders(bool)
	self.TwoMurderers = bool
end

function GM:GetTwoMurders(bool)
	return self.TwoMurderers
end

function GM:SetOtherMurderer(o)
	self.OtherMurderer = o
end

function GM:GetOtherMurderer(bool)
	return self.OtherMurderer
end

net.Recieve( "other_murder", function( client )
	local check = net.ReadBool()
	if check then
		local a = net.ReadString()
		GAMEMODE:SetOtherMurderer(a)
		GAMEMODE:SetTwoMurders(check)
	else
		GAMEMODE:SetTwoMurders(check)
	end
end)]]