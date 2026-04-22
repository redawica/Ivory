local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local enemies = { };
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");
if build == 30300 and level == 80 and data then
local items = {
	settingsfile = "DarhangeR_Arcane.xml",
	{ type = "title", text = "Arcane Mage by |c0000CED1DarhangeR" },
	{ type = "separator" },
	{ type = "page", number = 0, text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.bossIcon()..":26:26\124t Boss Detect", tooltip = "When ON - Auto detect Bosses, when OFF - use CD bottom for Spells", enabled = true, key = "detect" },
	{ type = "entry", text = "\124T"..data.mage.interIcon()..":26:26\124t Auto Interrupt", tooltip = "Auto check and interrupt all interruptible spells", enabled = true, key = "autointerrupt" },
	{ type = "entry", text = "\124T"..data.mage.evoIcon()..":26:26\124t Evocation", tooltip = "Use spell when player mana < %", enabled = true, value = 20, key = "evocation" },
	{ type = "entry", text = "\124T"..data.mage.gemIcon()..":26:26\124t Conjure Mana Gem", tooltip = "Create Mana Gem and use it when player mana < %", enabled = true, value = 35, key = "managem" },	
	{ type = "entry", text = "\124T"..data.debugIcon()..":26:26\124t Debug Printing", tooltip = "Enable for debug if you have problems", enabled = false, key = "Debug" },
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cff00C957Defensive Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.mage.iceIcon()..":26:26\124t Ice Block", tooltip = "Use spell when player HP < %", enabled = true, value = 23, key = "iceblock" },
	{ type = "entry", text = "\124T"..data.mage.evoIcon()..":26:26\124t Evocation (Glyph Healing)", tooltip = "Use spell when player have glyph and HP < %", enabled = true, value = 30, key = "evocationglyph" },
	{ type = "entry", text = "\124T"..data.stoneIcon()..":26:26\124t Healthstone", tooltip = "Use Warlock Healthstone (if you have) when player HP < %", enabled = true, value = 35, key = "healthstoneuse" },
	{ type = "entry", text = "\124T"..data.hpotionIcon()..":26:26\124t Heal Potion", tooltip = "Use Heal Potions (if you have) when player HP < %",  enabled = true, value = 30, key = "healpotionuse" },
	{ type = "entry", text = "\124T"..data.mpotionIcon()..":26:26\124t Mana Potion", tooltip = "Use Mana Potions (if you have) when player mana < %", enabled = true, value = 25, key = "manapotionuse" },
	{ type = "separator" },
	{ type = "page", number = 2, text = "|cffEE4000Rotation Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.mage.stealIcon()..":26:26\124t Spellsteal", tooltip = "Steal proper spell. You can edit table in Data file.", enabled = true, key = "spellsteal" },
	{ type = "entry", text = "\124T"..data.mage.fwardIcon()..":26:26\124t Auto Fire Ward", tooltip = "Use spell for block some fire spells. You can edit table in Data file.", enabled = true, key = "fireward" },
	{ type = "entry", text = "\124T"..data.mage.frwardIcon()..":26:26\124t Auto Frost Ward", tooltip = "Use spell for block some frost spells. You can edit table in Data file.", enabled = true, key = "frostward" },
	{ type = "entry", text = "\124T"..data.controlIcon()..":26:26\124t Auto Control (Member)", tooltip = "Auto check and control member if he mindcontrolled or etc.", enabled = true, key = "control" },	{ type = "separator" },
	{ type = "separator" },	
	{ type = "title", text = "Dispel" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..data.mage.curseIcon()..":26:26\124t Remove Curse", tooltip = "Auto dispel debuffs from player", enabled = true, key = "removecurse" },
	{ type = "entry", text = "\124T"..data.mage.curseIcon()..":26:26\124t Remove Curse (Member)", tooltip = "Auto dispel debuffs from members", enabled = false, key = "removecursememb" },	
		{ type = "separator" },
		{ type = "page", number = 99, text = "|cff00BFFFTrinkets (Config)" },
		{ type = "separator" },
		{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = false, key = "trinketenabled" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
		{ type = "input", value = "target", width = 80, height = 15, key = "trinket13unit" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
		{ type = "input", value = "target", width = 80, height = 15, key = "trinket14unit" },
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
	ni.GUI.AddFrame("Arcane_DarhangeR", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Arcane_DarhangeR");
end

local queue = {
		
	"AutoTarget",
	"Universal pause",
	"Arcane Brilliance",
	"Mage / Molten Armor",
	"Conjure Mana Gem",
	"Focus Magic",
	"Cancel Ice Block",
	"Fire Ward",
	"Frost Ward",
	"Combat specific Pause",
	"Mana Gem (Use)",
	"Healthstone (Use)",
	"Heal Potions (Use)",
	"Mana Potions (Use)",		
	"Trinkets (Config)",
	"Racial Stuff",
		"Use enginer gloves",
		"Trinkets",
	"Counterspell (Interrupt)",
	"Ice Block",	
	"Evocation",
	"Evocation Healing",
	"Spellsteal",
	"Presence of Mind",
	"Mirror Image",
	"Control (Member)",
	"Icy Veins",
	"Arcane Power",
	"Flamestrike",
	"Remove Curse (Member)",
	"Remove Curse (Self)",
	"Frostfire Bolt (Non Cast)",
	"Arcane Barrage",
	"Arcane Missiles",	
	"Arcane Blast",	
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
	["Arcane Brilliance"] = function()
		if ni.player.buffs("43002||61316||57567||42995||61024")
		 or not IsUsableSpell(GetSpellInfo(43002)) then 
		 return false
	end
		if ni.spell.available(43002) then
			ni.spell.cast(43002)	
			return true
		end
	end,
-----------------------------------
	["Mage / Molten Armor"] = function()
		if not ni.player.hasglyph(56382) 
		 and not ni.player.buff(43024)
		 and ni.spell.available(43024) then
			ni.spell.cast(43024)
			return true
		else
		if ni.player.hasglyph(56382)
		 and not ni.player.buff(43046)
		 and ni.spell.available(43046) then
			ni.spell.cast(43046)
			return true
			end
		end
	end,
-----------------------------------
	["Conjure Mana Gem"] = function()
		local _, enabled = GetSetting("managem")
		if enabled
		 and not ni.player.hasitem(33312)
		 and not ni.player.ismoving()
		 and not UnitAffectingCombat("player")
		 and IsUsableSpell(GetSpellInfo(42985))
		 and ni.spell.available(42985) then
			ni.spell.cast(42985)
			return true
		end
	end,
-----------------------------------
	["Focus Magic"] = function()
		if IsSpellKnown(54646)
		and ni.spell.available(54646) then
		 if ni.unit.exists("focus")
		  and not UnitIsDeadOrGhost("focus")
		  and not ni.unit.buff("focus", 54646) 
		  and ni.spell.valid("focus", 54646, false, true, true) then
				ni.spell.cast(54646, "focus")
				return true
			end
		end
	end,
-----------------------------------
	["Cancel Ice Block"] = function()
		local p = "player"
		for i = 1, 40 do
			local _, _, _, _, _, _, _, u, _, _, s = UnitBuff(p, i)
			if ni.player.hp() > 60
			 and u == p and s == 45438 then
				CancelUnitBuff(p, i)
				break
			end
		end
	end,
-----------------------------------	
	["Fire Ward"] = function()
		local _, enabled = GetSetting("fireward")
		if enabled
		 and data.mage.FireWard()
		 and ni.spell.available(43010) then
		 	ni.spell.cast(43010)
			return true
		end
	end,
-----------------------------------
	["Frost Ward"] = function()
		local _, enabled = GetSetting("frostward")
		if enabled 
		 and data.mage.FrostWard()
		 and ni.spell.available(43012) then
		 	ni.spell.cast(43012)
			return true
		end
	end,
-----------------------------------
	["Combat specific Pause"] = function()
		if data.casterStop("target")
		 or data.PlayerDebuffs("player")
		 or UnitCanAttack("player","target") == nil
		 or (UnitAffectingCombat("target") == nil 
		 and ni.unit.isdummy("target") == nil 
		 and UnitIsPlayer("target") == nil) then 
			return true
		end
	end,
-----------------------------------
	["Mana Gem (Use)"] = function()
		local value, enabled = GetSetting("managem")
		if enabled
		 and ni.player.power() < value
		 and ni.player.hasitem(33312) 
		 and ni.player.itemcd(33312) == 0 then
		 	ni.player.useitem(33312)
		 	return true
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
	["Mana Potions (Use)"] = function()
		local value, enabled = GetSetting("manapotionuse");
		local mpot = { 33448, 43570, 40087, 42545, 39671 }
		for i = 1, #mpot do
			if enabled
			 and ni.player.power() < value
			 and ni.player.hasitem(mpot[i])
			 and ni.player.itemcd(mpot[i]) == 0 then
				ni.player.useitem(mpot[i])
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
		 and ni.spell.valid("target", 42897) then 
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
		 and ni.spell.valid("target", 42897) then 
					ni.spell.cast(bloodelf[i])
					return true
			end
		end
		--- Ally race
		for i = 1, #alracial do
		if ni.spell.valid("target", 42897)
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
		 and ni.spell.valid("target", 42897) then
			ni.player.useinventoryitem(10)
			return true
		end
	end,
-----------------------------------
	["Trinkets (Config)"] = function()
		if data.UseConfiguredTrinkets(GetSetting, 42897, "target") then
			return true
		end
	end,
-----------------------------------
	["Trinkets"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(13)
		 and ni.player.slotcd(13) == 0 
		 and ni.spell.valid("target", 42897) then
			ni.player.useinventoryitem(13)
		else
		 if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.player.slotcastable(14)
		 and ni.player.slotcd(14) == 0 
		 and ni.spell.valid("target", 42897) then
			ni.player.useinventoryitem(14)
			return true
			end
		end
	end,
-----------------------------------
	["Counterspell (Interrupt)"] = function()
		local _, enabled = GetSetting("autointerrupt")
		if data.TryInterrupt("target", enabled, 2139, 0.35) then
			return true
		end
	end,
-----------------------------------	
	["Ice Block"] = function()
		local value, enabled = GetSetting("iceblock");		
		if enabled
		 and ni.player.hp() < value
		 and ni.spell.available(45438)
		 and not ni.player.buff(45438) then
			ni.spell.cast(45438)
			return true
		end
	end,
-----------------------------------
	["Evocation"] = function()
		local value, enabled = GetSetting("evocation");
		if enabled
		 and ni.player.power() < value
		 and not ni.player.ismoving()
		 and UnitChannelInfo("player") == nil
		 and ni.spell.available(12051) then
			ni.spell.cast(12051)
			return true
		end
	end,
-----------------------------------
	["Evocation Healing"] = function()
		local value, enabled = GetSetting("evocationglyph");		
		if enabled
		 and ni.player.hp() < value
		 and not ni.player.ismoving()
		 and ni.player.hasglyph(56380)
		 and UnitChannelInfo("player") == nil
		 and ni.spell.available(12051) then
			ni.spell.cast(12051)
			return true
		end
	end,
-----------------------------------
	["Spellsteal"] = function()
		local _, enabled = GetSetting("spellsteal")
		if enabled
		 and data.mage.isStealable("target")
		 and ni.spell.available(30449)
		 and ( ni.player.buffstacks(67108) < 10
		 or ni.player.buffremaining(67108) < 3 )
		 and ni.spell.valid("target", 30449, true, true) then
			ni.spell.cast(30449, "target")
			return true
		end
	end,
-----------------------------------
	["Mirror Image"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.spell.available(55342)
		 and ni.spell.valid("target", 42897) then
			ni.spell.cast(55342, "target")
			ni.player.runtext("/petattack")
			return true
		end
	end,
-----------------------------------
	["Icy Veins"] = function()
		local _, enabled = GetSetting("detect")
		if IsSpellKnown(12472)
		 and ni.spell.cd(12043)
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.spell.available(12472)
		 and ni.spell.valid("target", 42897) then
			ni.spell.cast(12472)
			return true
		end
	end,
-----------------------------------
	["Arcane Power"] = function()
		local _, enabled = GetSetting("detect")
		if ( ni.player.buff(12472) or ni.spell.cd(12472) )
		 and data.CDorBoss("target", 5, 35, 5, enabled)
		 and ni.spell.available(12042)
		 and ni.spell.valid("target", 42897) then
			ni.spell.cast(12042)
			return true
		end
	end,
-----------------------------------
	["Presence of Mind"] = function()
		local _, enabled = GetSetting("detect")
		if data.CDorBoss("target", 5, 35, 5, enabled)
		 and not ni.player.buff(44401)
		 and ni.spell.available(12043)
		 and ni.spell.available(42897)
		 and ni.spell.valid("target", 42897, true, true) then
			ni.spell.castspells("12043|42897", "target")
			return true
		end
	end,	
-----------------------------------
	["Arcane Blast"] = function()
		if not ni.player.ismoving()
		 and ni.spell.available(42897)
		 and ni.spell.valid("target", 42897, true, true) then
			ni.spell.cast(42897, "target")
			return true
		end
	end,
-----------------------------------
	["Arcane Missiles"] = function()
		if ni.player.debuffstacks(36032) == 4
		 and ni.player.buff(44401)
		 and not ni.player.ismoving()
		 and ni.spell.available(42846)
		 and ni.spell.valid("target", 42846, true, true) then
			ni.spell.cast(42846, "target")
			return true
		end
	end,
-----------------------------------
	["Arcane Barrage"] = function()
		if ni.player.ismoving()
		 and ni.spell.available(44781)
		 and ni.spell.valid("target", 44781, true, true) then
			ni.spell.cast(44781, "target")
			return true
		end
	end,
-----------------------------------
	["Remove Curse (Member)"] = function()
		local _, enabled = GetSetting("removecursememb")
		if enabled
		 and ni.spell.available(475) then
		  for i = 1, #ni.members do
		  if ni.unit.debufftype(ni.members[i].unit, "Curse")
		   and ni.healing.candispel(ni.members[i].unit)
		   and GetTime() - data.LastDispel > 1.5
		   and ni.spell.valid(ni.members[i].unit, 475, false, true, true) then
				ni.spell.cast(475, ni.members[i].unit)
				data.LastDispel = GetTime()
				return true
				end
			end
		end
	end,
-----------------------------------
	["Remove Curse (Self)"] = function()
		local _, enabled = GetSetting("removecurse")
		if enabled
		  and ni.player.debufftype("Curse")
		  and ni.spell.available(475)
		  and ni.healing.candispel("player")
		  and GetTime() - data.LastDispel > 1.5
		  and ni.spell.valid("player", 475, false, true, true) then
			ni.spell.cast(475, "player")
			data.LastDispel = GetTime()
			return true
		end
	end,
-----------------------------------
	["Flamestrike"] = function()
		if ni.vars.combat.aoe
		 and not ni.player.ismoving()
		 and ni.spell.available(42926) then
			ni.spell.castat(42926, "target")
			return true
		end
	end,
-----------------------------------
	["Frostfire Bolt (Non Cast)"] = function()
		if ni.player.buff(57761)
		 and ni.spell.isinstant(47610) 
		 and ni.spell.available(47610)
		 and ni.spell.valid("target", 47610, true, true) then
			ni.spell.cast(47610, "target")
			return true
		end
	end,
-----------------------------------
	["Control (Member)"] = function()
		local _, enabled = GetSetting("control")
		if enabled
		 and ni.spell.available(12826) then
		  for i = 1, #ni.members do
		   local ally = ni.members[i].unit
		    if data.ControlMember(ally)
			and not data.UnderControlMember(ally)
			and ni.spell.valid(ally, 12826, false, true, true) then
				ni.spell.cast(12826, ally)
				return true
				end
			end
		end
	end,
-----------------------------------
	["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Arcane Mage by DarhangeR for 3.3.5a", 
		 "Welcome to Arcane Mage Profile! Support and more in Discord > https://discord.gg/TEQEJYS.\n\n--Profile Function--\n-For use Flamestrike configure AoE Toggle key.\n-Focus target for use Focus Magic (If learned).")	
		popup_shown = true;
		end 
	end,
}

	ni.bootstrap.profile("Arcane_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
    ni.bootstrap.profile("Arcane_DarhangeR", queue, abilities);
end
