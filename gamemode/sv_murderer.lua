local PlayerMeta = FindMetaTable("Player")

util.AddNetworkString("your_are_a_murderer")
util.AddNetworkString("RussianCommrade")
util.AddNetworkString("murderCount")


GM.MurdererWeight = CreateConVar("mu_murder_weight_multiplier", 2, bit.bor(FCVAR_NOTIFY), "Multiplier for the weight of the murderer chance" )
function PlayerMeta:SetMurderer(bool)
	self.Murderer = bool
	if bool then
		self.MurdererChance = 1
	end
	net.Start( "your_are_a_murderer" )
	net.WriteUInt(bool and 1 or 0, 8)
	net.Send( self )
	
	
	--[[net.Start( "other_murder" )
	for k, v in pairs(player.GetAll()) do
		if v:GetMurderer() && v != LocalPlayer() then
			other = v:Nick() .. ", " .. v:GetBystanderName()
			break
		end
	end
	if other then
		net.WriteString(other)
		net.WriteBool(true)
	else
		net.WriteBool(false)
	end
	net.send( self )]]
end
	
function PlayerMeta:RecieveOtherMurderer(ply)
	net.Start("RussianCommrade")
	net.WriteEntity(ply)
	net.Send( self )

end

function GM:SendMurderCount(int)
	net.Start("murderCount")
	net.WriteInt(int,2)
	net.Broadcast()
end

function PlayerMeta:GetMurderer(bool)
	return self.Murderer
end

function PlayerMeta:SetMurdererRevealed(bool)
	self:SetNWBool("MurdererFog", bool)
	if bool then
		if !self.MurdererRevealed then
		end
	else
		if self.MurdererRevealed then
		end
	end
	self.MurdererRevealed = bool
end

function PlayerMeta:GetMurdererRevealed()
	return self.MurdererRevealed
end

local NO_KNIFE_TIME = 30
function GM:MurdererThink()
	local players = team.GetPlayers(2)
	local murderer = {}
	for k,ply in pairs(players) do
		if ply:GetMurderer() then
			table.insert(murderer,ply)
		end
	end

	// regenerate knife if on ground
	for k, v in pairs(murderer) do
		if IsValid(v) && v:Alive() then
			if v:HasWeapon("weapon_mu_knife") then
				v.LastHadKnife = CurTime()
			else
				if v.LastHadKnife && v.LastHadKnife + NO_KNIFE_TIME < CurTime() then
					for k, ent in pairs(ents.FindByClass("weapon_mu_knife")) do
						ent:Remove()
					end
					for k, ent in pairs(ents.FindByClass("mu_knife")) do
						ent:Remove()
					end
					v:Give("weapon_mu_knife")
				end
			end
		end
	end
end