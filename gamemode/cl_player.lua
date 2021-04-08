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

function initMenu()
		RunConsoleCommand("mu_jointeam", 1) 
		local Frame = vgui.Create( "DFrame" )
		Frame:MakePopup()
		Frame:SetTitle( "" )
		Frame:SetSize( 180,180 )
		Frame:SetDraggable( false )
		Frame:ShowCloseButton( false )
		Frame:Center()
		
		Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
			draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100 ) ) -- Draw a red box instead of the frame
		end
		local ButtonPlayers = vgui.Create("DButton", Frame)
		ButtonPlayers:SetText( "Players" )
		ButtonPlayers:SetTextColor( Color(255,255,255) )
		ButtonPlayers:SetPos( 10, 10 )
		ButtonPlayers:SetSize( 75, 160 )
		ButtonPlayers.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(41, 128, 185) ) -- Draw a blue button
		end
		local ButtonSpectators = vgui.Create("DButton", Frame)
		ButtonSpectators:SetText( "Spectators" )
		ButtonSpectators:SetTextColor( Color(255,255,255) )
		ButtonSpectators:SetPos( 95, 10 )
		ButtonSpectators:SetSize( 75, 160 )
		ButtonSpectators.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(160, 160, 160) ) -- Draw a blue button
		end
		ButtonPlayers.DoClick = function()
			print( "Joined Players" )
			RunConsoleCommand("mu_jointeam", 2)
			Frame:Close()
		end
		ButtonSpectators.DoClick = function()
			print( "Joined Spectators" )
			Frame:Close()
		end
        
        timer.Create( "CloseTimer", 60, 1, function()
			RunConsoleCommand("mu_jointeam", 1) 
            Frame:Close() 
        end )
        function Frame:OnClose()
            timer.Destroy("CloseTimer") 
            RunConsoleCommand("mu_jointeam", 1) 
        end
end
net.Receive( "Teammenu", initMenu())