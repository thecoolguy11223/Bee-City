MODE.name = "assasin"
MODE.PrintName = "Assasin"


MODE.OverideSpawnPos = true
MODE.LootSpawn = false
MODE.ForBigMaps = false
MODE.Chance = 0.04
MODE.GuiltDisabled = true
MODE.randomSpawns = true

util.AddNetworkString("as_start")
util.AddNetworkString("as_roundend")
util.AddNetworkString("as_targetvisualizer")

function MODE:Intermission()
    game.CleanUpMap()

	for i, ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end

		ply:SetupTeam(ply:Team())
	end

    net.Start("as_start")
    net.Broadcast()
end





function MODE:EndRound()
	timer.Simple(2,function()
		net.Start("as_roundend")
		net.Broadcast()
        local ent = zb:CheckAlive(true)[1]
        net.WriteEntity(IsValid(ent) and ent:Alive() and ent or NULL)
	end)
end
local targets = {}
function givetarget(infl,target)
    if IsValid(target) and target:Alive() and target.CurAppearance then
        net.Start("as_targetvisualizer")

        net.Send(infl)
    end
end

function MODE:CheckAlivePlayers()
	local AlivePlyTbl = {
	}
	for _, ply in player.Iterator() do
		if not ply:Alive() then continue end
		if ply.organism and ply.organism.incapacitated then continue end
		AlivePlyTbl[#AlivePlyTbl + 1] = ply
	end
	return AlivePlyTbl
end

function MODE:ShouldRoundEnd()
	return (#zb:CheckAlive(true) <= 1)
end

function MODE:RoundStart()
end
local pistol = {
    --{wep = "weapon_hk_usp", att = "supressor3"}, говно
    {wep = "weapon_p22", att = "supressor4"},
    {wep = "weapon_browninghp", att = "supressor4"},
    {wep = "weapon_pl15", att = "supressor4"},
    {wep = "weapon_tokarev"}
}
function traitorloadout(ply)
    ply:SetSuppressPickupNotices(true)
    ply.noSound = true
    zb.GiveRole(ply, "Assasin", Color(255, 0, 0))
    local hnds = ply:Give("weapon_hands_sh")
    local ch = pistol[math.random(1,#pistol)]
    local gun = ply:Give(ch.wep)
    if ch.att then
        hg.AddAttachmentForce(ply, gun, ch.att) 
    end
    ply:SelectWeapon(hnds)
    ply:SetSuppressPickupNotices(false)
    ply.noSound = false
end
function MODE:GiveEquipment()

    for i,ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        PrintTable(ply.CurAppearance)
        ply:Give("weapon_hands_sh")
        
    end
end

function MODE:GetTeamSpawn()
	return zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_T" )), zb.TranslatePointsToVectors(zb.GetMapPoints( "HMCD_TDM_CT" ))
end

function MODE:RoundThink()

end


function MODE:CanLaunch()
    return false --позже...
end

return MODE