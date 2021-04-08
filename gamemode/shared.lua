GM.Name 	= "Murder"
GM.Author 	= "MechanicalMind"
-- credits to Minty Fresh for some styling on the scoreboard
-- credits to Waddlesworth for the logo and menu icon
GM.Email 	= ""
GM.Website 	= "www.codingconcoctions.com/murder/"
GM.Version = "29"

function GM:SetupTeams()
	team.SetUp(1, translate.teamSpectators, Color(150, 150, 150))
	team.SetUp(2, translate.teamPlayers, Color(26, 120, 245))
	team.SetUp(1001, "Cringe", Color(26, 120, 245), false)
	team.SetUp(1002, "Stupid", Color(26, 120, 245), false)
	team.SetUp(1003, "Moron", Color(26, 120, 245), false)
end
GM:SetupTeams()

GM.Round = {
	NotEnoughPlayers = 0, // not enough players
	Playing = 1,  // playing
	RoundEnd = 2, // 2 round ended, about to restart
	MapSwitch = 4, // 4 waiting for map switch
	RoundStarting = 5 // 5 waiting to start new round after enough players
}