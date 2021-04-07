local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	self:FootStepsFootstep(ply, pos, foot, sound, volume, filter)

end

function EntityMeta:GetPlayerColor()
	return self:GetNWVector("playerColor") or Vector()
end

function EntityMeta:GetBystanderName()
	local name = self:GetNWString("bystanderName")
	if !name || name == "" then
		return "Bystander" 
	end
	return name
end


--function GM:ShowPlayers()
--		local round = self:GetRound()
----		if round == 1 then
--			if self.PlayTimeLeft then
--		if self:GetSecondMurderer() != "" then
--		
--			local ply = self:GetSecondMurderer()
---			local plypos = ply:GetPos()
--			local center = ply:OBBMaxs() 
--			local dotpos = Vector(plypos.x, plypos.y , plypos.z + center.z / 2)
--			
---
--			alphaval = alphaval - 0.4
--			
--			
--			cam.Start3D()
--			render.SetMaterial( Laser )
---			render.SetColorMaterial()
--			render.DrawSphere( dotpos, 8, 10, 10, Color( 158, 25, 25, alphaval ) )
--			cam.End3D()
--end
--	end
--end
	
--hook.Add( "HUDPaint", "RenderMurderHalos", function()
--	hook.Run( "ShowPlayers" )
--end)