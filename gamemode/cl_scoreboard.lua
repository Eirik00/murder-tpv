local menu

surface.CreateFont( "ScoreboardPlayer" , {
	font = "coolvetica",
	size = 32,
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "ScoreboardPlayer_smoll" , {
	font = "coolvetica",
	size = 20,
	weight = 400,
	antialias = true,
	italic = false
})

local muted = Material("icon32/muted.png")
local admin = Material("icon32/wand.png")

function timeToStr( time )
    local tmp = time
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	return string.format( "%02iw %id %02ih %02im", w, d, h, m)
end

local function addPlayerItem(self, mlist, ply, pteam)
	local but = vgui.Create("DButton")
	but.player = ply
	but.ctime = CurTime()
	but:SetTall(40)
	but:SetText("")
	function but:Paint(w, h)
		local showAdmins = GAMEMODE.RoundSettings.ShowAdminsOnScoreboard
        
        if IsValid(ply) && showAdmins && ply:IsAdmin() then
			surface.SetDrawColor(Color(150,50,50))
		else
			surface.SetDrawColor(team.GetColor(pteam))
		end
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255,255,255,10)
		surface.DrawRect(0, 0, w, h * 0.45 )

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h)

		if IsValid(ply) && ply:IsPlayer() then
			local e = 0
			local s = 0
            
            
            
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(3, 3, 34, 34)
            
			if ply:IsMuted() then
				surface.SetMaterial(muted)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(s + 40, h / 2 - 16, 32, 32)
				e = e + 32
				draw.DrawText(string.Left(ply:Nick(), 27), "ScoreboardPlayer", e + 47, 9, color_black, 0)
			    draw.DrawText(string.Left(ply:Nick(), 27), "ScoreboardPlayer", e + 46, 8, Color( 169, 169, 169, 255 ), 0)
			else
			    draw.DrawText(string.Left(ply:Nick(), 27), "ScoreboardPlayer", e + 47, 9, color_black, 0)
			    draw.DrawText(string.Left(ply:Nick(), 27), "ScoreboardPlayer", e + 46, 8, color_white, 0)
            end
            
            -- U Time
            --draw.DrawText(timeToStr( ply:GetUTimeTotalTime() ), "ScoreboardPlayer", s + 800, 9, color_black, 2)
            --draw.DrawText(timeToStr( ply:GetUTimeTotalTime() ), "ScoreboardPlayer", s + 799, 8, color_white, 2)
            --draw.DrawText("|", "ScoreboardPlayer", w - 110, 9, color_black, 2)
            --draw.DrawText("|", "ScoreboardPlayer", w - 109, 8, color_white, 2)
            
            draw.DrawText("ping:", "ScoreboardPlayer_smoll", w - 39, 2, color_black, 2)
            draw.DrawText("ping:", "ScoreboardPlayer_smoll", w - 38, 1, color_white, 2)
            
			draw.DrawText(ply:Ping(), "ScoreboardPlayer_smoll", w - 9, 2, color_black, 2)
			draw.DrawText(ply:Ping(), "ScoreboardPlayer_smoll", w - 10, 1, color_white, 2)
            
            draw.DrawText("points:", "ScoreboardPlayer_smoll", w - 39, 21, color_black, 2)
            draw.DrawText("points:", "ScoreboardPlayer_smoll", w - 38, 20, color_white, 2)
            
			draw.DrawText(ply:Frags(), "ScoreboardPlayer_smoll", w - 9, 21, color_black, 2)
			draw.DrawText(ply:Frags(), "ScoreboardPlayer_smoll", w - 10, 20, color_white, 2)

			
		end
	end
	function but:DoClick()
		GAMEMODE:DoScoreboardActionPopup(ply)
	end

	mlist:AddItem(but)
	Avatar = vgui.Create( "AvatarImage", but )
    Avatar:SetPos(4, 4)
    Avatar:SetSize(32, 32)
    Avatar:SetPlayer( ply, 32 )
end

function GM:DoScoreboardActionPopup(ply)
	local actions = DermaMenu()

	if ply:IsAdmin() then
		local admin = actions:AddOption(translate.scoreboardActionAdmin)
		admin:SetIcon("icon16/shield.png")
	end

	if ply != LocalPlayer() then
		if !ply:IsBot() then
			local t = translate.scoreboardActionMute
			if ply:IsMuted() then
				t = translate.scoreboardActionUnmute
			end
			local mute = actions:AddOption( t )
			mute:SetIcon("icon16/sound_mute.png")
			function mute:DoClick()
				if IsValid(ply) then
					ply:SetMuted(!ply:IsMuted())
				end
			end
			local viewProfile = actions:AddOption(translate.scoreboardActionViewProfile)
			viewProfile:SetIcon("icon16/user_gray.png")
			function viewProfile:DoClick()
				if IsValid(ply) then
					ply:ShowProfile()
				end
		    end
		    local getSteamid = actions:AddOption("Copy SteamID")
			getSteamid:SetIcon("icon16/user_go.png")
			function getSteamid:DoClick()
			    v = LocalPlayer()
				if IsValid(ply) then
					SetClipboardText( ply:SteamID() )
					chat.AddText( Color( 255, 255, 255 ), "You copied ", ply,"'s SteamID!" )
				end
			end
		end
	end
	
	if IsValid(LocalPlayer()) && LocalPlayer():IsAdmin() then
		actions:AddSpacer()

		if ply:Team() == 2 then
			local spectate = actions:AddOption( Translator:QuickVar(translate.adminMoveToSpectate, "spectate", team.GetName(1)) )
			spectate:SetIcon( "icon16/status_busy.png" )
			function spectate:DoClick()
				RunConsoleCommand("mu_movetospectate", ply:EntIndex())
			end

			local force = actions:AddOption( translate.adminMurdererForce )
			force:SetIcon( "icon16/delete.png" )
			function force:DoClick()
				RunConsoleCommand("mu_forcenextmurderer", ply:EntIndex())
			end

			if ply:Alive() then
				local specateThem = actions:AddOption( translate.adminSpectate )
				specateThem:SetIcon( "icon16/status_online.png" )
				function specateThem:DoClick()
					RunConsoleCommand("mu_spectate", ply:EntIndex())
				end
			end
		end
	end

	actions:Open()
end

local function doPlayerItems(self, mlist, pteam)
	local playerTable = {}
    for i, v in ipairs(team.GetPlayers(pteam)) do
    	playerTable[v] = v:Frags()
	end
	for k, ply in pairs(table.SortByKey(playerTable)) do
		local found = false

		for t,v in pairs(mlist:GetCanvas():GetChildren()) do
			if v.player == ply then
				found = true
				v.ctime = CurTime()
			end
		end

		if !found then
			addPlayerItem(self, mlist, ply, pteam)
		end
	end
	local del = false

	for t,v in pairs(mlist:GetCanvas():GetChildren()) do
		if v.ctime != CurTime() then
			v:Remove()
			del = true
		end
	end
	// make sure the rest of the elements are moved up
	if del then
		timer.Simple(0, function() mlist:GetCanvas():InvalidateLayout() end)
	end
end

local function makeTeamList(parent, pteam)
	local mlist
	local chaos
	local pnl = vgui.Create("DPanel", parent)
	pnl:DockPadding(8,8,8,8)
	function pnl:Paint(w, h) 
		surface.SetDrawColor(Color(50,50,50,255))
		surface.DrawRect(2, 2, w - 4, h - 4)
	end

	function pnl:Think()
		if !self.RefreshWait || self.RefreshWait < CurTime() then
			self.RefreshWait = CurTime() + 0.1
			doPlayerItems(self, mlist, pteam)
		end
	end

	local headp = vgui.Create("DPanel", pnl)
	headp:DockMargin(0,0,0,4)
	headp:Dock(TOP)
    
	function headp:Paint() end
    
	local but = vgui.Create("DButton", headp)
	but:Dock(RIGHT)
	but:SetText(translate.scoreboardJoinTeam)
	but:SetTextColor(color_white)
	but:SetFont("Trebuchet18")
    
	function but:DoClick()
		RunConsoleCommand("mu_jointeam", pteam)
	end
    
	function but:Paint(w, h)
		surface.SetDrawColor(team.GetColor(pteam))
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255,255,255,10)
		surface.DrawRect(0, 0, w, h * 0.45 )

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h)

		if self:IsDown() then
			surface.SetDrawColor(50,50,50,120)
			surface.DrawRect(1, 1, w - 2, h - 2)
		elseif self:IsHovered() then
			surface.SetDrawColor(255,255,255,30)
			surface.DrawRect(1, 1, w - 2, h - 2)
		end
	end

	local head = vgui.Create("DLabel", headp)
	head:SetText(team.GetName(pteam))
	head:SetFont("Trebuchet24")
	head:SetTextColor(team.GetColor(pteam))
	head:Dock(FILL)


	mlist = vgui.Create("DScrollPanel", pnl)
	mlist:Dock(FILL)

	// child positioning
	local canvas = mlist:GetCanvas()
	function canvas:OnChildAdded( child )
		child:Dock( TOP )
		child:DockMargin( 0,0,0,4 )
	end
	
    
	return pnl
end

function GM:ScoreboardShow()
		menu = vgui.Create("DFrame")
		menu:SetSize(ScrW() * 0.98, ScrH() * 0.9)
		menu:Center()
		menu:MakePopup()
		menu:SetKeyboardInputEnabled(false)
		menu:SetDeleteOnClose(false)
		menu:SetDraggable(false)
		menu:ShowCloseButton(false)
		menu:SetTitle("")
		menu:DockPadding(4,4,4,4)
		function menu:PerformLayout()
			menu.Cops:SetWidth(self:GetWide() * 0.5)
		end

		function menu:Paint()
			surface.SetDrawColor(Color(40,40,40,255))
			surface.DrawRect(0, 0, menu:GetWide(), menu:GetTall())
		end

		menu.Credits = vgui.Create("DPanel", menu)
		menu.Credits:Dock(TOP)
		menu.Credits:DockPadding(8,6,8,0)
		function menu.Credits:Paint() end

		local name = Label(GAMEMODE.Name or "derp errors", menu.Credits)
		name:Dock(LEFT)
		name:SetFont("MersRadial")
		name:SetTextColor(team.GetColor(2))
		function name:PerformLayout()
			surface.SetFont(self:GetFont())
			local w,h = surface.GetTextSize(self:GetText())
			self:SetSize(w,h)
		end
        
        function menu.Credits:PerformLayout()
			surface.SetFont(name:GetFont())
			local w,h = surface.GetTextSize(name:GetText())
			self:SetTall(h)
		end
        
		menu.Cops = makeTeamList(menu, 2)
		menu.Cops:Dock(LEFT)
		menu.Robbers = makeTeamList(menu, 1)
		menu.Robbers:Dock(FILL)
		local mods = "MechanicalMind "
		local admins = "Coco "
        local owners =  "Wind "
		local one = "Created by: "
		local breaker = "& "
		local fuck = " "
		
		local owne = Label(owners, menu.Credits)
		owne:Dock(RIGHT)
		owne:SetFont("MersText1")
		owne.PerformLayout = name.PerformLayout
		owne:SetTextColor(Color(255, 158, 0))
	
		local breake = Label(breaker, menu.Credits)
		breake:Dock(RIGHT)
		breake:SetFont("MersText1")
		breake.PerformLayout = name.PerformLayout
		breake:SetTextColor(team.GetColor(1))
		
		local admi = Label(admins, menu.Credits)
		admi:Dock(RIGHT)
		admi:SetFont("MersText1")
		admi.PerformLayout = name.PerformLayout
		admi:SetTextColor(Color(150,50,50))
		
		local breake = Label(breaker, menu.Credits)
		breake:Dock(RIGHT)
		breake:SetFont("MersText1")
		breake.PerformLayout = name.PerformLayout
		breake:SetTextColor(team.GetColor(1))
		    
		--moderators
		local mode = Label(mods, menu.Credits)
		mode:Dock(RIGHT)
		mode:SetFont("MersText1")
		mode.PerformLayout = name.PerformLayout
		mode:SetTextColor(Color(0, 153, 0))
		--Misc.
		local online = Label(one, menu.Credits)
		online:Dock(RIGHT)
		online:SetFont("MersText1")
		online.PerformLayout = name.PerformLayout
		online:SetTextColor(Color(39, 192, 227))
		
		local shit = Label(fuck, menu.Credits)
		shit:Dock(RIGHT)
		shit.PerformLayout = name.PerformLayout
end
function GM:ScoreboardHide()
    menu:Close()
end

function GM:HUDDrawScoreBoard()
end