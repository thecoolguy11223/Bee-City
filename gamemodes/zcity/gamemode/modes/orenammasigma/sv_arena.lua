MODE.name = "arena"
MODE.PrintName = "Arena"


MODE.OverideSpawnPos = true
MODE.LootSpawn = false
MODE.ForBigMaps = false
MODE.Chance = 0.02


function MODE.GuiltCheck(Attacker, Victim, add, harm, amt)
    return 1, true
end

util.AddNetworkString("arena_start")
util.AddNetworkString("arena_roundend")

function MODE:Intermission()
    game.CleanUpMap()

	for i, ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end

		ply:SetupTeam(ply:Team())
	end

    net.Start("arena_start")
    net.Broadcast()
end





function MODE:EndRound()
	timer.Simple(2,function()
		net.Start("arena_roundend")
		net.Broadcast()
	end)

	local endround, winner = zb:CheckWinner(self:CheckAlivePlayers())
end

function MODE:CheckAlivePlayers()
	return zb:CheckAliveTeams(true)
end

function MODE:ShouldRoundEnd()
	local endround, winner = zb:CheckWinner(self:CheckAlivePlayers())

	return endround
end

function MODE:RoundStart()
end


function MODE:GiveEquipment()
    local players = player.GetAll()
    table.Shuffle(players)

    local numPlayers = #players
    local numBlue= math.max(math.floor(numPlayers / 2), 1)
    local numRed = numPlayers - numBlue
    for i = 1, numRed do
        local ply = players[i]
        if ply:Team() == TEAM_SPECTATOR then continue end
        ply:SetupTeam(0)
        ply:Give("weapon_hands_sh")
        ply:Give("weapon_hg_sledgehammer")
        local tbl = ply.CurAppearance
	    tbl.AClothes["main"] = "normal"
		tbl.AClothes["pants"] = "normal"
		tbl.AClothes["boots"] = "normal"
		hg.Appearance.ForceApplyAppearance(ply,tbl)
        zb.GiveRole(ply, "Red", Color(255, 0, 0))
        ply:SetPlayerColor(Color(255,0,0):ToVector())
    end
    

    for i = numRed + 1, numPlayers do
        local ply = players[i]
        if ply:Team() == TEAM_SPECTATOR then continue end
        ply:SetupTeam(1)
        ply:Give("weapon_hands_sh")
        ply:Give("weapon_hg_sledgehammer")
        local tbl = ply.CurAppearance
	    tbl.AClothes["main"] = "normal"
		tbl.AClothes["pants"] = "normal"
		tbl.AClothes["boots"] = "normal"
		hg.Appearance.ForceApplyAppearance(ply,tbl)
        zb.GiveRole(ply, "Blue", Color(0, 0, 190))
        ply:SetPlayerColor(Color(0,0,190):ToVector())
    end
end

function MODE:GetTeamSpawn()
	return zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_T" )), zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_CT" ))
end

function MODE:RoundThink()
    for i,v in player.Iterator() do
        v.organism.stamina.sub = 0
		v.organism.stamina[1] = v.organism.stamina.max
    end
end


function MODE:CanLaunch()
    return true
end

return MODE