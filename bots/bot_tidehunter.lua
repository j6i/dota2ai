local module = require(GetScriptDirectory().."/functions")
local bot_generic = require(GetScriptDirectory().."/bot_generic")

local SKILL_Q = "tidehunter_gush"
local SKILL_W = "tidehunter_kraken_shell"
local SKILL_E = "tidehunter_anchor_smash"
local SKILL_R = "tidehunter_ravage"
local TALENT1 = "special_bonus_movement_speed_20"
local TALENT2 = "special_bonus_unique_tidehunter_2"
local TALENT3 = "special_bonus_exp_boost_40"
local TALENT4 = "special_bonus_unique_tidehunter_3"
local TALENT5 = "special_bonus_unique_tidehunter_4"
local TALENT6 = "special_bonus_unique_tidehunter"
local TALENT7 = "special_bonus_cooldown_reduction_25"
local TALENT8 = "special_bonus_attack_damage_250"

local TideAbility = {
	SKILL_E,
	SKILL_W,
	SKILL_E,
	SKILL_Q,
	SKILL_E,
	SKILL_R,
	SKILL_E,
	SKILL_W,
	SKILL_W,
	TALENT2,
	SKILL_W,
	SKILL_R,
	SKILL_Q,
	SKILL_Q,
	TALENT4,
	SKILL_Q,
	"nil",
	SKILL_R,
	"nil",
	TALENT6,
	"nil",
	"nil",
	"nil",
	"nil",
	TALENT8
}

function IsBotCasting(npcBot)
	return npcBot:IsChanneling()
		  or npcBot:IsUsingAbility()
		  or npcBot:IsCastingAbility()
end

function ConsiderItem(npcBot, Item)
	if (Item == nil or not Item:IsFullyCastable()) then
		return 0
	end

		return 1
end

function ConsiderCast(npcBot, ability)
	if (not ability:IsFullyCastable()) then
		return 0
	end

	return 1
end

--if(blink~=nil and blink:IsFullyCastable())
--	then
--		CastRange=CastRange+1200
--		if(npcBot:GetActiveMode() == BOT_MODE_ATTACK )
--		then
--			local locationAoE = npcBot:FindAoELocation( true, true, npcBot:GetLocation(), CastRange, Radius, 0, 0 );
--			if ( locationAoE.count >= 2 )
--			then
--				npcBot:Action_UseAbilityOnLocation( blink, locationAoE.targetloc );
--				return 0
--			end
--		end

function castOrder(PowUnit, npcBot)
	local abilityQ = npcBot:GetAbilityByName(SKILL_Q)
	local abilityE = npcBot:GetAbilityByName(SKILL_E)
	local abilityR = npcBot:GetAbilityByName(SKILL_R)
	local blink = module.ItemSlot(npcBot, "item_blink")

	local Mana = npcBot:GetMana()
	local MaxMana = npcBot:GetMaxMana()
	local manaPer = Mana/MaxMana

	if (IsBotCasting(npcBot)) then
		return
	end

	if (ConsiderItem(npcBot, blink) == 1 and ConsiderCast(npcBot, abilityR) == 1) then
		if (GetUnitToUnitDistance(npcBot,PowUnit) <= 1500) then
			npcBot:ActionPush_UseAbility(abilityR)
			npcBot:ActionPush_UseAbilityOnLocation(blink, PowUnit:GetLocation())
		end
	elseif (ConsiderCast(npcBot, abilityR) == 1) then
		if (GetUnitToUnitDistance(npcBot,PowUnit) <= 1000) then
			npcBot:ActionPush_UseAbility(abilityR)
		end
	else
		return
	end

end

function Think()
	local npcBot = GetBot()
	local EHERO = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local WeakestEHero,EHeroHealth = module.GetWeakestUnit(EHERO)
	local PowUnit,PowHealth = module.GetStrongestHero(EHERO)

	module.AbilityLevelUp(TideAbility)
	if (npcBot:GetLevel() >= 1 and PowUnit ~= nil) then
		castOrder(PowUnit, npcBot)
	end

	bot_generic.Think()
end
