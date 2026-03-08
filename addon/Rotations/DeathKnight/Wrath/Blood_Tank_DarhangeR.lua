local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
local function ActiveEnemies()
	return data.GetActiveEnemies("target", 7, true, 0.15)
end
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_TANK_Blood.xml",
	{ type = "title", text = "Blood DK TANK by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },
	{ type = "entry", text = "\124T"..data.dk.deathIcon()..":26:26\124t Death Strike (Lich)", tooltip = "Use spell when player HP < %", enabled = true, value = 75, key = "deathstrike" },
	{ type = "entry", text = "\124T"..data.dk.interIcon()..":26:26\124t Auto Interrupt", tooltip = "Auto check and interrupt all interruptible spells", enabled = true, key = "autointerrupt" },
	{ type = "entry", text = "Cancel Shadowmourne (Chaos Bane)", tooltip = "Cancel Chaos Bane buff (Shadowmourne) when enabled", enabled = false, key = "cancelshadow" },
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },
	{ type = "separator" },
	{ type = "title", text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.dk.runeIcon()..":26:26\124t Rune Tap", tooltip = "Use spell when player HP < %", enabled = true, value = 55, key = "runetap" },
	{ type = "entry", text = "\124T"..data.dk.vampIcon()..":26:26\124t Vampiric Blood", tooltip = "Use spell when player HP < %", enabled = true, value = 75, key = "vampblood" },
	{ type = "entry", text = "\124T"..data.dk.markIcon()..":26:26\124t Mark of Blood", tooltip = "Use spell when player HP < %", enabled = true, value = 25, key = "markofblood" },
	{ type = "entry", text = "\124T"..data.dk.iceboundIcon()..":26:26\124t Icebound Fortitude", tooltip = "Use spell when player HP < %", enabled = true, value = 40, key = "iceboundfort" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %", enabled = true, value = 30, key = "healpotionuse" },
	{ type = "separator" },
	{ type = "title", text = "|cffEE4000Rotation Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.dk.commandIcon()..":26:26\124t Dark Command (Auto Agro)", tooltip = "Auto use spell to agro enemies in 30 yard radius", enabled = false, key = "dark" },
	{ type = "entry", text = "\124T"..data.dk.gripIcon()..":26:26\124t Death Grip (Auto Agro)", tooltip = "Auto use spell to agro enemies in 30 yard radius", enabled = false, key = "grip" },
	{ type = "separator" },
	{ type = "title", text = "Presence's" },
	{ type = "dropdown", menu = {
		{ selected = false, value = 48266, text = "Blood Presence" },
		{ selected = true, value = 48263, text = "Frost Presence" },
		{ selected = false, value = 48265, text = "Unholy Presence" },
	}, key = "Presence" },
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cff00BFFFTrinkets (Config)" },
	{ type = "separator" },
	{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = false, key = "trinketenabled" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket13unit" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
	{ type = "input", value = "", width = 80, height = 15, key = "trinket14unit" },
};
local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
        if v.type == "dropdown"
         and v.key ~= nil
         and v.key == name then
            for k2, v2 in pairs(v.menu) do
                if v2.selected then
                    return v2.value
                end
            end
        end
        if v.type == "input"
         and v.key ~= nil
         and v.key == name then
            return v.value
        end
    end
end;
local function OnLoad()
	ni.GUI.AddFrame("Blood_Tank_DarhangeR", items);
end
local function OnUnLoad()
	ni.GUI.DestroyFrame("Blood_Tank_DarhangeR");
end

local queue = {

	"Universal pause",
	"AutoTarget",
	"Use Presence",
	"Horn of Winter",
	"Combat specific Pause",
	"Pet Attack/Follow",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Racial Stuff",
	"Use enginer gloves",
	"Trinkets (Config)",
	"Trinkets",
	"Cancel Shadowmourne",
	"Mind Freeze (Interrupt)",
	"Hysteria",
	"Empower Rune Weapon",
	"Icebound Fortitude",
	"Mark of Blood",
	"Rune Tap",
	"Vampiric Blood",
	"Dark Command",
	"Dark Command (Ally)",
	"Death Grip (Ally)",
	"Death and Decay",
	"Icy Touch",
	"Plague Strike",
	"Icy Touch (Agro)",
	"Pestilence (Renew)",
	"Pestilence (AoE)",
	"Death Strike (Lich)",
	"Death Strike",
	"Death Coil (Max runpower)",
	"Rune Strike",
	"Blood Boil",
	"Blood Strike",
	"Heart Strike",
	"Death Coil",
	"Window",
}
local abilities = {
-----------------------------------
	["Universal pause"] = function()
		if data.UniPause() then
			return true
		end
		ni.vars.debug = select(2, GetSetting("Debug"));
	end,
-----------------------------------
	["AutoTarget"] = function()
		if UnitAffectingCombat("player")
		 and ((ni.unit.exists("target")
		 and UnitIsDeadOrGhost("target")
		 and not UnitCanAttack("player", "target"))
		 or not ni.unit.exists("target")) then
			ni.player.runtext("/targetenemy")
		end
	end,
-----------------------------------
	["Use Presence"] = function()
		local presence = GetSetting("Presence");
		if not ni.player.buff(presence)
		 and ni.spell.available(presence) then
			ni.spell.cast(presence)
			return true
		end
	end,
-----------------------------------
	["Horn of Winter"] = function()
		if not ni.player.buff(57623)
		 and ni.spell.available(57623) then
			ni.spell.cast(57623)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.tankStop("target")
		 or data.PlayerDebuffs("player")
		 or UnitCanAttack("player","target") == nil
		 or (UnitAffectingCombat("target") == nil
		 and ni.unit.isdummy("target") == nil
		 and UnitIsPlayer("target") == nil) then
			return true
		end
	end,
-----------------------------------
	["Pet Attack/Follow"] = function()
		if ni.unit.hp("playerpet") < 20
		 and ni.unit.exists("playerpet")
		 and ni.unit.exists("target")
		 and UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			data.petFollow()
		 else
		if UnitAffectingCombat("player")
		 and ni.unit.exists("playerpet")
		 and ni.unit.hp("playerpet") > 60
		 and ni.unit.exists("target")
		 and not UnitIsUnit("target", "pettarget")
		 and not UnitIsDeadOrGhost("playerpet") then
			data.petAttack()
			end
		end
	end,
-----------------------------------
	["Healthstone (Use)"] = function()
		local value, enabled = GetSetting("healthstoneuse");
		local hstones = { 36892, 36893, 36894 }
		for i = 1, #hstones do
			if enabled
			 and ni.player.hp() < value
			 and ni.player.hasitem(hstones[i])
			 and ni.player.itemcd(hstones[i]) == 0 then
				ni.player.useitem(hstones[i])
				return true
			end
		end
	end,
-----------------------------------
	["Heal Potions (Use)"] = function()
		local value, enabled = GetSetting("healpotionuse");
		local hpot = { 33447, 43569, 40087, 41166, 40067 }
		for i = 1, #hpot do
			if enabled
			 and ni.player.hp() < value
			 and ni.player.hasitem(hpot[i])
			 and ni.player.itemcd(hpot[i]) == 0 then
				ni.player.useitem(hpot[i])
				return true
			end
		end
	end,
-----------------------------------
	["Racial Stuff"] = function()
		local hracial = { 33697, 20572, 33702, 26297 }
		local bloodelf = { 25046, 28730, 50613 }
		local alracial = { 20594, 28880 }
		local _, enabled = GetSetting("detect")
		--- Undead
		if data.forsaken("player")
		 and IsSpellKnown(7744)
		 and ni.spell.available(7744) then
				ni.spell.cast(7744)
				return true
		end
		--- Horde race
		for i = 1, #hracial do
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and IsSpellKnown(hracial[i])
		 and ni.spell.available(hracial[i])
		 and data.dk.InRange() then
					ni.spell.cast(hracial[i])
					return true
			end
		end
		--- Blood Elf
		for i = 1, #bloodelf do
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.power() < 60
		 and IsSpellKnown(bloodelf[i])
		 and ni.spell.available(bloodelf[i])
		 and data.dk.InRange() then
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if data.dk.InRange()
		 and ni.player.hp() < 20
		 and IsSpellKnown(alracial[i])
		 and ni.spell.available(alracial[i]) then
					ni.spell.cast(alracial[i])
					return true
				end
			end
	end,
-----------------------------------
	["Use enginer gloves"] = function()
		local _, enabled = GetSetting("detect")
		if ni.player.slotcastable(10)
		 and ni.player.slotcd(10) == 0
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and data.dk.InRange() then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets (Config)"] = function()
		if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0
		 and data.dk.InRange() then
			ni.player.useinventoryitem(13)
			return true
		end
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0
		 and data.dk.InRange() then
			ni.player.useinventoryitem(14)
			return true
		end
	end,
-----------------------------------
	["Cancel Shadowmourne"] = function()
		local _, enabled = GetSetting("cancelshadow")
		if enabled then
			local p = "player"
			for i = 1, 40 do
				local _, _, _, _, _, _, _, u, _, _, spellId = UnitBuff(p, i)
				if u == p and spellId == 73422 then
					CancelUnitBuff(p, i)
					break
				end
			end
		end
	end,
-----------------------------------
	["Mind Freeze (Interrupt)"] = function()
		local _, enabled = GetSetting("autointerrupt")
		if data.TryInterrupt("target", enabled, 47528, 0.35) then
			return true
		end
	end,
-----------------------------------
	["Icebound Fortitude"] = function()
		local value, enabled = GetSetting("iceboundfort");
		if enabled
		 and ni.player.hp() < value
		 and ni.spell.available(48792)
		 and not ni.player.buff(48792) then
			ni.spell.cast(48792)
			return true
		end
	end,
-----------------------------------
	["Vampiric Blood"] = function()
		local value, enabled = GetSetting("vampblood");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and ni.player.hp() < value
		 and BR >= 1
		 and ni.spell.available(55233)
		 and not ni.player.buff(55233) then
			ni.spell.cast(55233)
			return true
		end
	end,
-----------------------------------
	["Mark of Blood"] = function()
		local value, enabled = GetSetting("markofblood");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and BR >= 1
		 and ni.player.hp() < value
		 and ni.spell.available(49005)
		 and not ni.unit.debuff("target", 49005, "player")then
			ni.spell.cast(49005, "target")
			return true
		end
	end,
-----------------------------------
	["Rune Tap"] = function()
		local value, enabled = GetSetting("runetap");
		local _, BR = ni.rune.bloodrunecd()
		if enabled
		 and ni.player.hp() < value then
		  if BR >= 1
		   and ni.spell.available(48982) then
			ni.spell.cast(48982)
			return true
		   end
		  if BR < 1
		   and ni.spell.available(45529)
		   and ni.spell.cd(48982) == 0 then
			ni.spell.cast(45529)
			return true
			end
		end
	 end,
-----------------------------------
	["Empower Rune Weapon"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.rune.available() == 0
		 and ni.spell.available(47568) then
			ni.spell.cast(47568)
			return true
		end
	end,
-----------------------------------
	["Death and Decay"] = function()
		if ni.vars.combat.aoe
		 and ni.spell.available(49938) then
			ni.spell.castatqueue(49938, "target")
			return true
		end
	end,
-----------------------------------
	["Hysteria"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.spell.available(49016)
		 and data.dk.InRange() then
		  if not ni.unit.exists("focus")
		  and not ni.player.buff(49016) then
			ni.spell.cast(49016, "player")
			return true
		else
		if ni.spell.available(49016) then
		  if ni.unit.exists("focus")
		  and not UnitIsDeadOrGhost("focus")
		  and not ni.unit.buff("focus", 49016)
		  and ni.spell.valid("focus", 49016, false, true, true) then
					ni.spell.cast(49016, "focus")
					return true
					end
			    end
			end
		end
	end,
-----------------------------------
	["Icy Touch"] = function()
		local icy = data.dk.icy()
		if ( not icy or ( icy < 2.5 ) )
		 and ni.spell.available(49909)
		 and ni.spell.valid("target", 49909, true, true) then
			data.dk.LastIcy = GetTime()
			ni.spell.cast(49909, "target")
			return true
		end
	end,
-----------------------------------
	["Plague Strike"] = function()
		local plague = data.dk.plague()
		if ( not plague or ( plague < 2.5 ) )
		 and ni.spell.available(49921)
		 and ni.spell.valid("target", 49921, true, true) then
			ni.spell.cast(49921, "target")
			return true
		end
	end,
-----------------------------------
	["Icy Touch (Agro)"] = function()
		if ni.unit.isboss("target")
		 and ni.spell.available(49909)
		 and GetTime() - data.dk.LastIcy > 25
		 and ni.spell.valid("target", 49909, true, true) then
			data.dk.LastIcy = GetTime()
			ni.spell.cast(49909, "target")
			return true
		end
	end,
-----------------------------------
	["Pestilence (AoE)"] = function()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		local enemies = ni.unit.enemiesinrange("target", 7)
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		if ( BR >= 1 or DR >= 1 )
		 and icy
		 and plague
		 and ni.spell.valid("target", 50842, true, true) then
		 if ActiveEnemies() >= 1 then
		  for i = 1, #enemies do
		   if ni.unit.creaturetype(enemies[i].guid) ~= 8
		    and ni.unit.creaturetype(enemies[i].guid) ~= 11
		    and (not ni.unit.debuff(enemies[i].guid, 55078, "player")
		    or not ni.unit.debuff(enemies[i].guid, 55095, "player")) then
				ni.spell.cast(50842, "target")
						return true
					end
				end
			end
		end
	end,
-----------------------------------
	["Pestilence (Renew)"] = function()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		local _, BR = ni.rune.bloodrunecd()
		local _, DR = ni.rune.deathrunecd()
		 if ni.player.hasglyph(63334)
		 and ni.spell.valid("target", 50842, true, true)
		 and ( ( icy ~= nil and icy < 4.5 )
		 or ( plague ~= nil and plague < 4.5 ) ) then
			if BR == 0 and DR == 0
			and ni.spell.cd(45529) == 0 then
				ni.spell.cast(45529)
				ni.spell.cast(50842, "target")
			return true
		else
				ni.spell.cast(50842, "target")
			return true
			end
		end
	end,
-----------------------------------
	["Dark Command"] = function()
		local _, enabled = GetSetting("dark")
		table.wipe(enemies);
		if (data.youInInstance()
		 or enabled)
		 and ni.unit.exists("targettarget")
		 and not UnitIsDeadOrGhost("targettarget")
		 and UnitAffectingCombat("player")
		 and (ni.unit.debuff("targettarget", 72410)
		 or ni.unit.debuff("targettarget", 72411)
		 or ni.unit.threat("player", "target") < 2 )
		 and not ni.spell.available(49576)
  		 and ni.spell.available(56222)
		 and ni.spell.valid("target", 56222, false, true, true) then
			ni.spell.cast(56222)
			return true
		end
	end,
-----------------------------------
	["Dark Command (Ally)"] = function()
		local _, enabled = GetSetting("dark")
   		if not ni.spell.available(49576)
  		 and ni.spell.available(56222)
		 and (data.youInInstance()
		 or enabled) then
		 table.wipe(enemies);
		 local enemies = ni.unit.enemiesinrange("player", 30)
			for i = 1, #enemies do
			local threatUnit = enemies[i].guid
			if ni.unit.threat("player", threatUnit) ~= nil
			 and ni.unit.threat("player", threatUnit) <= 2
			 and UnitAffectingCombat(threatUnit)
			 and not ni.unit.debuff(threatUnit, 49560)
			 and ni.spell.valid(threatUnit, 56222, false, true, true) then
				ni.spell.cast(56222, threatUnit)
				return true
			end
			end
		end
	end,
-----------------------------------
	["Death Grip (Ally)"] = function()
		local _, enabled = GetSetting("grip")
		 if ni.spell.available(49576)
		 and (data.youInInstance()
		 or enabled) then
		 table.wipe(enemies);
		 local enemies = ni.unit.enemiesinrange("player", 30)
			for i = 1, #enemies do
			local threatUnit = enemies[i].guid
			if ni.unit.threat("player", threatUnit) ~= nil
			 and ni.unit.threat("player", threatUnit) <= 2
			 and UnitAffectingCombat(threatUnit)
			 and ni.spell.valid(threatUnit, 49576, true, true) then
				ni.spell.cast(49576, threatUnit)
				return true
			end
			end
		end
	end,
-----------------------------------
	["Death Strike (Lich)"] = function()
		local value, enabled = GetSetting("deathstrike");
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if enabled
		 and ni.player.hp() < value
		 and ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))
		 and plague
		 and icy
		 and ni.spell.available(49924)
		 and ni.spell.valid("target", 49924, true, true) then
			ni.spell.cast(49924, "target")
			return true
		end
	end,
-----------------------------------
	["Death Strike"] = function()
		local _, FR = ni.rune.frostrunecd()
		local _, UR = ni.rune.unholyrunecd()
		local _, DR = ni.rune.deathrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if ((FR >= 1 and UR >= 1)
		 or (FR >= 1 and DR >= 1)
		 or (DR >= 1 and UR >= 1)
		 or (DR == 2))
		 and plague
		 and icy
		 and ni.spell.available(49924)
		 and ni.spell.valid("target", 49924, true, true) then
			ni.spell.cast(49924, "target")
			return true
		end
	end,
-----------------------------------
	["Rune Strike"] = function()
		if IsUsableSpell(GetSpellInfo(56815))
		 and ni.spell.available(56815, true)
		 and not IsCurrentSpell(56815)
		 and ni.spell.valid("target", 56815, true, true) then
			ni.spell.cast(56815, "target")
			return true
		end
	end,
-----------------------------------
	["Blood Boil"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if BR >= 1
		 and ActiveEnemies() > 1
		 and plague
		 and icy
		 and ni.spell.available(49941)
		 and ni.spell.valid("target", 49941, true, true) then
			ni.spell.cast(49941, "target")
			return true
		end
	end,
-----------------------------------
	["Blood Strike"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if not IsSpellKnown(55262)
		 and BR >= 1
		 and ( ActiveEnemies() == 1 or ActiveEnemies() < 2 )
		 and plague
		 and icy
		 and ni.spell.available(49930)
		 and ni.spell.valid("target", 49930, true, true) then
			ni.spell.cast(49930, "target")
			return true
		end
	end,
-----------------------------------
	["Heart Strike"] = function()
		local _, BR = ni.rune.bloodrunecd()
		local icy = data.dk.icy()
		local plague = data.dk.plague()
		if BR >= 1
		 and ( ActiveEnemies() == 1 or ActiveEnemies() < 2 )
		 and plague
		 and icy
		 and ni.spell.available(55262)
		 and ni.spell.valid("target", 55262, true, true) then
			ni.spell.cast(55262, "target")
			return true
		end
	end,
-----------------------------------
	["Death Coil"] = function()
		if ni.spell.available(49895)
		 and not (IsUsableSpell(GetSpellInfo(56815))
		 or not IsSpellInRange(GetSpellInfo(56815), "target") == 1 )
		 and ni.spell.valid("target", 49895, true, true) then
			ni.spell.cast(49895, "target")
			return true
		end
	end,
-----------------------------------
	["Death Coil (Max runpower)"] = function()
		if ni.player.power() > 80
		 and ni.spell.available(49895)
		 and ni.spell.valid("target", 49895, true, true) then
			ni.spell.cast(49895, "target")
			return true
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Blood Tank Death Knight by DarhangeR for 3.3.5a",
		 "Welcome to Blood Tank Death Knight Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For use Death and Decay configure AoE Toggle key.\n-Focus ally target for use Hysteria on it.")
		popup_shown = true;
		end
	end,
}

	ni.bootstrap.profile("Blood_Tank_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
else
    local queue = {
        "Error",
    }
    local abilities = {
        ["Error"] = function()
            ni.vars.profiles.enabled = false;
            if build > 30300 then
              ni.frames.floatingtext:message("This profile is meant for WotLK 3.3.5a! Sorry!")
            elseif level < 80 then
              ni.frames.floatingtext:message("This profile is meant for level 80! Sorry!")
            elseif data == nil then
              ni.frames.floatingtext:message("Data file is missing or corrupted!");
            end
        end,
    }
    ni.bootstrap.profile("Blood_Tank_DarhangeR", queue, abilities);
end
