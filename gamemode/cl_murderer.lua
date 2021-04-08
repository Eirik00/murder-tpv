function GM:SetAmMurderer(bool)
	self.Murderer = bool
	self:ResetMurdererList()
end

function GM:GetAmMurderer(bool)
	return self.Murderer
end

function GM:ResetMurdererList()
	self.SecondMurderer = ""
end

function GM:GetSecondMurderer(bool)
	if self.SecondMurderer == nil then
		self.SecondMurderer = ""
	end
	return self.SecondMurderer
end

function GM:SetSecondMurderer(ply)
	self.SecondMurderer = ply
end

function GM:SetMurdererCount(int)
	self.MurdererCount = int
end

function GM:GetMurdererCount(bool)
	if self.MurdererCount == nil then
		self.MurdererCount = 1
	end
	return self.MurdererCount
end

net.Receive( "your_are_a_murderer", function( length, client )
	local am = net.ReadUInt(8) != 0
	GAMEMODE:SetAmMurderer(am)
end)

net.Receive( "RussianCommrade", function (length, client )
	local ply = net.ReadEntity()
	GAMEMODE:SetSecondMurderer(ply)
end)

net.Receive( "murderCount", function (length, client )
	local int = net.ReadInt(2)
	GAMEMODE:SetMurdererCount(int)
end)
	

local Laser = Material( "cable/redlaser" )
local alphaval = 255
			
function GM:DrawStuff()
	local round = self:GetRound()
	if self:GetAmMurderer() then
		if self:GetSecondMurderer() != "" then
		
			local ply = self:GetSecondMurderer()
			local plypos = ply:GetPos()
			local center = ply:OBBMaxs() 
			local dotpos = Vector(plypos.x, plypos.y , plypos.z + center.z / 2)
			

			alphaval = alphaval - 0.4
			
			
			cam.Start3D()
			render.SetMaterial( Laser )
			render.SetColorMaterial()
			render.DrawSphere( dotpos, 8, 10, 10, Color( 158, 25, 25, alphaval ) )
			cam.End3D()
		end
	end
	if round == 1 then
		if self.PlayTimeLeft and self.PlayTimeLeft <= 60 then
			if self.PlayerCoords then
			    if self:GetAmMurderer() then
				    cam.Start3D()
				    render.SetMaterial( Laser )
				    render.SetColorMaterial()
			        for k, v in pairs(self.PlayerCoords) do
					    render.DrawSphere( v, 8, 10, 10, Color( 0, 200, 25, 150 ) )
				    end
				    cam.End3D()
				end
			end
		end
	end
end


	
hook.Add( "HUDPaint", "RenderMurderHalos", function()
	hook.Run( "DrawStuff" )
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