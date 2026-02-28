local dalvae = {}

-- Spells with IDs and Icons for easier reference
dalvae.spells = {
	druid = {
		-- Feral (Cat)
		CatForm = { id = 768, name = GetSpellInfo(768), icon = select(3, GetSpellInfo(768)) },
		MangleCat = { id = 48566, name = GetSpellInfo(48566), icon = select(3, GetSpellInfo(48566)) },
		Rip = { id = 49800, name = GetSpellInfo(49800), icon = select(3, GetSpellInfo(49800)) },
		Rake = { id = 48574, name = GetSpellInfo(48574), icon = select(3, GetSpellInfo(48574)) },
		SavageRoar = { id = 52610, name = GetSpellInfo(52610), icon = select(3, GetSpellInfo(52610)) },
		Prowl = { id = 5215, name = GetSpellInfo(5215), icon = select(3, GetSpellInfo(5215)) },
		TigersFury = { id = 50213, name = GetSpellInfo(50213), icon = select(3, GetSpellInfo(50213)) },
		Maim = { id = 49802, name = GetSpellInfo(49802), icon = select(3, GetSpellInfo(49802)) },
		FerociousBite = { id = 48577, name = GetSpellInfo(48577), icon = select(3, GetSpellInfo(48577)) },
		Pounce = { id = 49803, name = GetSpellInfo(49803), icon = select(3, GetSpellInfo(49803)) },
		FaerieFireFeral = { id = 16857, name = GetSpellInfo(16857), icon = select(3, GetSpellInfo(16857)) },
		Shred = { id = 48572, name = GetSpellInfo(48572), icon = select(3, GetSpellInfo(48572)) },
		SurvivalInstincts = { id = 61336, name = GetSpellInfo(61336), icon = select(3, GetSpellInfo(61336)) },
		Berserk = { id = 50334, name = GetSpellInfo(50334), icon = select(3, GetSpellInfo(50334)) },
		SwipeCat = { id = 62078, name = GetSpellInfo(62078), icon = select(3, GetSpellInfo(62078)) },

		-- Feral (Bear)
		BearForm = { id = 9634, name = GetSpellInfo(9634), icon = select(3, GetSpellInfo(9634)) },
		MangleBear = { id = 48564, name = GetSpellInfo(48564), icon = select(3, GetSpellInfo(48564)) },
		Maul = { id = 48480, name = GetSpellInfo(48480), icon = select(3, GetSpellInfo(48480)) },
		Lacerate = { id = 48568, name = GetSpellInfo(48568), icon = select(3, GetSpellInfo(48568)) },
		DemoralizingRoar = { id = 48560, name = GetSpellInfo(48560), icon = select(3, GetSpellInfo(48560)) },
		Enrage = { id = 5229, name = GetSpellInfo(5229), icon = select(3, GetSpellInfo(5229)) },
		FrenziedRegeneration = { id = 22842, name = GetSpellInfo(22842), icon = select(3, GetSpellInfo(22842)) },
		FeralChargeBear = { id = 16979, name = GetSpellInfo(16979), icon = select(3, GetSpellInfo(16979)) },
		Bash = { id = 8983, name = GetSpellInfo(8983), icon = select(3, GetSpellInfo(8983)) },
		SwipeBear = { id = 48562, name = GetSpellInfo(48562), icon = select(3, GetSpellInfo(48562)) },
		Growl = { id = 6795, name = GetSpellInfo(6795), icon = select(3, GetSpellInfo(6795)) },

		-- Restoration
		Rejuv = { id = 48441, name = GetSpellInfo(48441), icon = select(3, GetSpellInfo(48441)) },
		Lifebloom = { id = 48451, name = GetSpellInfo(48451), icon = select(3, GetSpellInfo(48451)) },
		Regrowth = { id = 48443, name = GetSpellInfo(48443), icon = select(3, GetSpellInfo(48443)) },
		Nourish = { id = 50464, name = GetSpellInfo(50464), icon = select(3, GetSpellInfo(50464)) },
		HealingTouch = { id = 48378, name = GetSpellInfo(48378), icon = select(3, GetSpellInfo(48378)) },
		MarkoftheWild = { id = 48470, name = GetSpellInfo(48470), icon = select(3, GetSpellInfo(48470)) },
		Thorns = { id = 26992, name = GetSpellInfo(26992), icon = select(3, GetSpellInfo(26992)) },
		AbolishPoison = { id = 2893, name = GetSpellInfo(2893), icon = select(3, GetSpellInfo(2893)) },
		RemoveCurse = { id = 2782, name = GetSpellInfo(2782), icon = select(3, GetSpellInfo(2782)) },
		Tranquility = { id = 48447, name = GetSpellInfo(48447), icon = select(3, GetSpellInfo(48447)) },
		TreeOfLife = { id = 33891, name = GetSpellInfo(33891), icon = select(3, GetSpellInfo(33891)) },

		-- Balance & General
		Barkskin = { id = 22812, name = GetSpellInfo(22812), icon = select(3, GetSpellInfo(22812)) },
		Innervate = { id = 29166, name = GetSpellInfo(29166), icon = select(3, GetSpellInfo(29166)) },
		Moonfire = { id = 8921, name = GetSpellInfo(8921), icon = select(3, GetSpellInfo(8921)) },
		Roots = { id = 26989, name = GetSpellInfo(26989), icon = select(3, GetSpellInfo(26989)) },
		Cyclone = { id = 33786, name = GetSpellInfo(33786), icon = select(3, GetSpellInfo(33786)) },
		Hibernate = { id = 18658, name = GetSpellInfo(18658), icon = select(3, GetSpellInfo(18658)) },
		NatureGrasp = { id = 27009, name = GetSpellInfo(27009), icon = select(3, GetSpellInfo(27009)) },

		-- Procs / Auras
		Clearcasting = { id = 16870, name = GetSpellInfo(16870), icon = select(3, GetSpellInfo(16870)) },
		InstantCast = { id = 69369, name = GetSpellInfo(69369), icon = select(3, GetSpellInfo(69369)) },

		-- General Spells
		Attack = { id = 6603, name = GetSpellInfo(6603), icon = select(3, GetSpellInfo(6603)) },
		Shadowmeld = { id = 58984, name = GetSpellInfo(58984), icon = select(3, GetSpellInfo(58984)) },
	},
}

-- Form IDs from GetShapeshiftForm()
dalvae.forms = {
	humanoid = 0,
	bear = 1, -- ID correcto es 1
	aquatic = 2,
	cat = 3, -- ID correcto es 3
	travel = 4,
	moonkin = 5,
}

-- Centralized definitions for crowd control and immunity effects
dalvae.crowdControlDebuffs = {
	[118] = true,
	[12826] = true,
	[61305] = true,
	[61721] = true,
	[61780] = true,
	[28271] = true,
	[28272] = true,
	[2094] = true,
	[1776] = true,
	[6770] = true,
	[605] = true,
	[8122] = true,
	[64044] = true,
	[5782] = true,
	[17928] = true,
	[6358] = true,
	[18658] = true,
	[339] = true,
	[19386] = true,
	[3355] = true,
	[19503] = true,
	[20066] = true,
	[10326] = true,
	[51514] = true,
}

dalvae.immunityBuffs = {
	[642] = true,
	[1022] = true,
	[45438] = true,
	[19263] = true,
}

dalvae.usableWhileStunned = {
	[22812] = true, -- Barkskin
}

dalvae.immunitySpells = {
	magic = { 642, 45438, 31224 },
	physical = { 1022, 19263 },
	cc = { 33786 },
}

-- Item definitions
dalvae.items = {
	healthstones = { 36894, 22105, 19013, 9421, 5512 },
	health_potions = { 40078, 22829, 13446 },
	offensive_potions = { 40211, 40212, 39927, 42993, 22838 },
	utility_consumables = { [8956] = true },
	mana_potions = { 40067, 22832 },
	food = {},
}

-- General Utility Functions
function dalvae.getLatency()
	local _, _, latency = GetNetStats()
	return (latency or 160) / 1000
end

function dalvae.playerHasTalent(talentName, requiredPoints)
	requiredPoints = requiredPoints or 1
	for tab = 1, GetNumTalentTabs() do
		for i = 1, GetNumTalents(tab) do
			local name, _, _, _, currentRank = GetTalentInfo(tab, i)
			if name == talentName and currentRank >= requiredPoints then
				return true, currentRank
			end
		end
	end
	return false, 0
end

function dalvae.findMember(name)
	for i = 1, #ni.members do
		if ni.members[i].name == name then
			return ni.members[i]
		end
	end
	return nil
end

function dalvae.groupCount(distance, hpThreshold)
	local count = 0
	distance = distance or 40
	hpThreshold = hpThreshold or 100
	for _, member in ipairs(ni.members) do
		if member:hp() < hpThreshold and ni.player.distance(member.unit) <= distance then
			count = count + 1
		end
	end
	return count
end

-- Spell Casting and Readiness
function dalvae.isImmune(unit, immunityType)
	if immunityType then
		if dalvae.immunitySpells[immunityType] then
			for _, spellId in ipairs(dalvae.immunitySpells[immunityType]) do
				if ni.unit.buff(unit, spellId) then
					return true
				end
			end
		end
	else
		for _, list in pairs(dalvae.immunitySpells) do
			for _, spellId in ipairs(list) do
				if ni.unit.buff(unit, spellId) then
					return true
				end
			end
		end
	end
	return false
end

function dalvae.spellReady(spell)
	local id
	if type(spell) == "table" then
		id = spell.id
	else
		id = tonumber(spell) or ni.spell.id(spell)
	end
	if not id then
		return false
	end

	local name, _, _, cost, _, powertype = GetSpellInfo(id)
	if not name or not IsUsableSpell(name) or not IsSpellKnown(id) then
		return false
	end

	local latency = dalvae.getLatency()
	local spellQueueWindow = math.max(latency, 0.2)

	-- Check if casting another spell
	local castName, _, _, _, _, endTimeMS = UnitCastingInfo("player")
	if castName then
		local remainingCast = (endTimeMS / 1000) - GetTime()
		if remainingCast > spellQueueWindow then
			return false
		end
	end

	-- Check GCD with latency tolerance
	local gcdStart, gcdDuration = GetSpellCooldown(61304)
	if gcdStart and gcdStart > 0 and gcdDuration > 0 then
		if (gcdStart + gcdDuration - GetTime()) > latency then
			return false
		end
	end

	-- Check spell cooldown with latency tolerance
	if ni.spell.cd(id) > latency then
		return false
	end

	-- Check resources, accounting for Berserk
	if cost and cost > 0 then
		if GetShapeshiftForm() == dalvae.forms.cat and ni.player.buff(dalvae.spells.druid.Berserk.id) then
			cost = cost / 2
		end
		if powertype >= 0 and ni.player.powerraw(powertype) < cost then
			return false
		end
	end

	return true
end
function dalvae.isUnitUntouchable(unit)
	-- Comprueba si la unidad tiene buffs de inmunidad como Escudo Divino o Bloque de Hielo
	if ni.unit.buff(unit, 642) or ni.unit.buff(unit, 45438) then
		return true
	end
	return false
end
function dalvae.findBestItem(itemList)
	for _, itemId in ipairs(itemList) do
		-- Comprueba si tienes el objeto en tus bolsas
		if GetItemCount(itemId) > 0 then
			return itemId -- Devuelve el ID del primer objeto que encuentre en la lista
		end
	end
	return nil -- Si no encuentra ninguno, devuelve nil
end

function dalvae.spellUsable(spell)
	local spellId = type(spell) == "table" and spell.id or tonumber(spell) or ni.spell.id(spell)
	if (ni.player.isstunned() or ni.player.issilenced()) and not dalvae.usableWhileStunned[spellId] then
		return false
	end
	return dalvae.spellReady(spell)
end

function dalvae.cast(spell, target)
	if not dalvae.spellUsable(spell) then
		return false
	end

	if target then
		ni.spell.cast(spell.id, target)
	else
		ni.spell.cast(spell.id)
	end
	return true
end

-- Consumables and Defensives
function dalvae.useConsumable(itemList, condition, checkCombat, checkStunned)
	checkCombat = (checkCombat == nil) or checkCombat
	checkStunned = (checkStunned == nil) or checkStunned

	if checkCombat and not UnitAffectingCombat("player") then
		return false
	end
	if checkStunned and ni.player.isstunned() then
		return false
	end
	if condition and not condition() then
		return false
	end

	for _, itemId in ipairs(itemList) do
		if ni.player.hasitem(itemId) and ni.player.itemcd(itemId) == 0 and IsUsableItem(itemId) then
			ni.player.useitem(itemId)
			return true
		end
	end
	return false
end

function dalvae.useDefensive(spell, hpThreshold)
	if ni.player.hp() < hpThreshold and dalvae.spellUsable(spell) then
		ni.spell.cast(spell.id, "player")
		return true
	end
	return false
end

-- Feral DPS Logic
function dalvae.getFinisherPriority()
	local cp = GetComboPoints("player", "target")
	if cp == 0 then
		return "Wait"
	end

	local sr_remains = ni.player.buffremaining(dalvae.spells.druid.SavageRoar.id)
	local rip_remains = ni.unit.debuffremaining("target", dalvae.spells.druid.Rip.id, "player")
	local ttd = ni.unit.ttd("target")
	local isBerserk = ni.player.buff(dalvae.spells.druid.Berserk.id)

	-- TIME TO DIE (TTD) LOGIC
	if ttd > 0 and ttd < 12 and cp >= 5 then
		return "FerociousBite"
	end

	-- BERSERK LOGIC
	if isBerserk then
		if sr_remains < 2 and cp > 0 then
			return "SavageRoar"
		end
		if rip_remains < 0.1 and cp == 5 then
			return "Rip"
		end
		if cp == 5 then
			return "FerociousBite"
		end
		return "Wait"
	end

	-- STANDARD LOGIC (NO BERSERK)
	if sr_remains < 1.5 and cp >= 2 then
		return "SavageRoar"
	end

	if cp < 5 then
		return "Wait"
	end

	local DANGER_ZONE_THRESHOLD = 8
	local DESYNC_WINDOW = 4
	local timersAreClose = math.abs(sr_remains - rip_remains) < DESYNC_WINDOW
	local inDangerZone = sr_remains < DANGER_ZONE_THRESHOLD or rip_remains < DANGER_ZONE_THRESHOLD

	if timersAreClose and inDangerZone then
		if sr_remains < rip_remains then
			return "SavageRoar"
		else
			return "Rip"
		end
	end

	if rip_remains < 0.1 then
		return "Rip"
	end

	if sr_remains < 0.2 then
		return "SavageRoar"
	end

	if ni.player.powerraw("energy") >= 99 then
		return "FerociousBite"
	end

	if sr_remains > 8 and rip_remains > 8 then
		return "FerociousBite"
	end

	return "Wait"
end

-- Profession checking
function dalvae.hasProfession(professionName)
	for i = 1, GetNumSkillLines() do
		local skillName = GetSkillLineInfo(i)
		if skillName == professionName then
			return true
		end
	end
	return false
end

return dalvae
