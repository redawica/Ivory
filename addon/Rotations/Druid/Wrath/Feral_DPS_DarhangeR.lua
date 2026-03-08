local data = ni.utils.require("DarhangeR");
local popup_shown = false;
local build = select(4, GetBuildInfo());
local level = UnitLevel("player");

local function icon(spellID)
	return select(3, GetSpellInfo(spellID)) or ""
end

local function ActiveEnemies()
	return data.GetActiveEnemies("target", 8, true, 0.15)
end

if build == 30300 and level == 80 and data then
	local items = {
		settingsfile = "DarhangeR_Feral_DPS.xml",
		{ type = "title", text = "Feral Druid DPS by |c0000CED1DarhangeR" },
		{ type = "separator" },
		{ type = "title", text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "entry", text = "|T" .. icon(33876) .. ":26:26|t Boss Detect", tooltip = "Auto detect bosses for cooldown usage", enabled = true, key = "detect" },
		{ type = "entry", text = "|T" .. icon(768) .. ":26:26|t Auto Cat Form", tooltip = "Auto switch to Cat Form in combat", enabled = true, key = "autoform" },
		{ type = "entry", text = "|T" .. icon(22842) .. ":26:26|t Frenzied Regeneration", tooltip = "Use when HP < %", enabled = true, value = 35, key = "frenzied" },
		{ type = "entry", text = "|T" .. icon(22812) .. ":26:26|t Barkskin", tooltip = "Use when HP < %", enabled = true, value = 45, key = "barkskin" },
		{ type = "entry", text = "|T" .. icon(5229) .. ":26:26|t Enrage", tooltip = "Use Enrage in combat", enabled = true, key = "enrage" },
		{ type = "entry", text = "|T" .. icon(3127) .. ":26:26|t Racial Stuff", tooltip = "Enable racial abilities", enabled = true, key = "racial" },
		{ type = "entry", text = "|T" .. icon(2382) .. ":26:26|t Debug Printing", tooltip = "Enable debug output", enabled = false, key = "Debug" },
		{ type = "separator" },
		{ type = "page", number = 1, text = "|cff00BFFFTrinkets (Config)" },
		{ type = "separator" },
		{ type = "entry", text = "Enable Custom Trinkets", tooltip = "Use configured trinkets by ID/spell target", enabled = true, key = "trinketenabled" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13spell" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket13unit" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14id" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14spell" },
		{ type = "input", value = "", width = 80, height = 15, key = "trinket14unit" },
	};

	local function GetSetting(name)
		for _, v in ipairs(items) do
			if v.type == "entry" and v.key ~= nil and v.key == name then
				return v.value, v.enabled
			end
			if v.type == "dropdown" and v.key ~= nil and v.key == name then
				for _, v2 in pairs(v.menu) do
					if v2.selected then
						return v2.value
					end
				end
			end
			if v.type == "input" and v.key ~= nil and v.key == name then
				return v.value
			end
		end
	end;

	local function OnLoad()
		ni.GUI.AddFrame("Feral_DPS_DarhangeR", items);
	end

	local function OnUnLoad()
		ni.GUI.DestroyFrame("Feral_DPS_DarhangeR");
	end

	local queue = {
		"Universal pause",
		"AutoTarget",
		"Mark of the Wild",
		"Thorns",
		"Cat Form",
		"Combat specific Pause",
		"Healthstone (Use)",
		"Heal Potions (Use)",
		"Racial Stuff",
		"Use engineer gloves",
		"Trinkets (Config)",
		"Trinkets",
		"Barkskin",
		"Frenzied Regeneration",
		"Enrage",
		"Tiger's Fury",
		"Berserk",
		"Faerie Fire (Feral)",
		"Savage Roar",
		"Mangle (Cat)",
		"Rake",
		"Rip",
		"Ferocious Bite",
		"Window",
	}

	local abilities = {
		["Universal pause"] = function()
			if data.UniPause() then
				return true
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
		end,

		["AutoTarget"] = function()
			if UnitAffectingCombat("player")
			 and ((ni.unit.exists("target") and UnitIsDeadOrGhost("target") and not UnitCanAttack("player", "target"))
			 or not ni.unit.exists("target")) then
				ni.player.runtext("/targetenemy")
			end
		end,

		["Mark of the Wild"] = function()
			if not UnitAffectingCombat("player") and ni.spell.available(48469) and not ni.player.buffs("48469||48470") then
				ni.spell.cast(48469)
				return true
			end
		end,

		["Thorns"] = function()
			if not UnitAffectingCombat("player") and ni.spell.available(53307) and not ni.player.buff(53307) then
				ni.spell.cast(53307)
				return true
			end
		end,

		["Cat Form"] = function()
			local _, enabled = GetSetting("autoform")
			if enabled and not ni.player.buff(768) and ni.spell.available(768) then
				ni.spell.cast(768)
				return true
			end
		end,

		["Combat specific Pause"] = function()
			if not UnitAffectingCombat("player") or UnitCanAttack("player", "target") == nil then
				return true
			end
		end,

		["Healthstone (Use)"] = function()
			local value = 35
			local hstones = { 36892, 36893, 36894 }
			for i = 1, #hstones do
				if ni.player.hp() < value and ni.player.hasitem(hstones[i]) and ni.player.itemcd(hstones[i]) == 0 then
					ni.player.useitem(hstones[i])
					return true
				end
			end
		end,

		["Heal Potions (Use)"] = function()
			local hpot = { 33447, 43569, 40087, 41166, 40067 }
			for i = 1, #hpot do
				if ni.player.hp() < 30 and ni.player.hasitem(hpot[i]) and ni.player.itemcd(hpot[i]) == 0 then
					ni.player.useitem(hpot[i])
					return true
				end
			end
		end,

		["Racial Stuff"] = function()
			local _, enabled = GetSetting("racial")
			if not enabled then
				return false
			end
			if data.druid.Race() then
				return true
			end
		end,

		["Use engineer gloves"] = function()
			local _, enabled = GetSetting("detect")
			if ni.player.slotcastable(10)
			 and ni.player.slotcd(10) == 0
			 and data.CDorBoss("target", 5, 35, 5, enabled)
			 and UnitAffectingCombat("player") then
				ni.player.useinventoryitem(10)
				return true
			end
		end,

		["Trinkets (Config)"] = function()
			if data.UseConfiguredTrinkets(GetSetting, nil, "target") then
				return true
			end
		end,

		["Trinkets"] = function()
			local _, enabled = GetSetting("detect")
			if data.CDorBoss("target", 5, 35, 5, enabled)
			 and ni.player.slotcastable(13)
			 and ni.player.slotcd(13) == 0 then
				ni.player.useinventoryitem(13)
				return true
			end
			if data.CDorBoss("target", 5, 35, 5, enabled)
			 and ni.player.slotcastable(14)
			 and ni.player.slotcd(14) == 0 then
				ni.player.useinventoryitem(14)
				return true
			end
		end,

		["Barkskin"] = function()
			local value, enabled = GetSetting("barkskin")
			if enabled and ni.player.hp() < value and ni.spell.available(22812) and not ni.player.buff(22812) then
				ni.spell.cast(22812)
				return true
			end
		end,

		["Frenzied Regeneration"] = function()
			local value, enabled = GetSetting("frenzied")
			if enabled and ni.player.hp() < value and ni.spell.available(22842) and ni.player.buff(22812) then
				ni.spell.cast(22842)
				return true
			end
		end,

		["Enrage"] = function()
			local _, enabled = GetSetting("enrage")
			if enabled and UnitAffectingCombat("player") and ni.spell.available(5229) and not ni.player.buff(5229) then
				ni.spell.cast(5229)
				return true
			end
		end,

		["Tiger's Fury"] = function()
			if UnitAffectingCombat("player") and ni.spell.available(50213) and ni.player.power() < 35 then
				ni.spell.cast(50213)
				return true
			end
		end,

		["Berserk"] = function()
			local _, enabled = GetSetting("detect")
			if data.CDorBoss("target", 5, 35, 5, enabled) and ni.spell.available(50334) then
				ni.spell.cast(50334)
				return true
			end
		end,

		["Faerie Fire (Feral)"] = function()
			if ni.spell.available(16857)
			 and ni.spell.valid("target", 16857, true, true)
			 and not ni.unit.debuff("target", 16857) then
				ni.spell.cast(16857, "target")
				return true
			end
		end,

		["Savage Roar"] = function()
			if ni.spell.available(52610)
			 and ni.player.power() > 30
			 and not ni.player.buff(52610)
			 and GetComboPoints("player", "target") > 0 then
				ni.spell.cast(52610)
				return true
			end
		end,

		["Mangle (Cat)"] = function()
			if ni.spell.available(48566)
			 and ni.spell.valid("target", 48566, true, true)
			 and not ni.unit.debuff("target", 48566, "player") then
				ni.spell.cast(48566, "target")
				return true
			end
		end,

		["Rake"] = function()
			if ni.spell.available(48574)
			 and ni.spell.valid("target", 48574, true, true)
			 and not ni.unit.debuff("target", 48574, "player") then
				ni.spell.cast(48574, "target")
				return true
			end
		end,

		["Rip"] = function()
			if ni.spell.available(49800)
			 and ni.spell.valid("target", 49800, true, true)
			 and GetComboPoints("player", "target") >= 5
			 and not ni.unit.debuff("target", 49800, "player") then
				ni.spell.cast(49800, "target")
				return true
			end
		end,

		["Ferocious Bite"] = function()
			if ni.spell.available(48577)
			 and ni.spell.valid("target", 48577, true, true)
			 and GetComboPoints("player", "target") >= 5
			 and (ni.unit.debuffremaining("target", 49800, "player") or 0) > 6
			 and ActiveEnemies() < 2 then
				ni.spell.cast(48577, "target")
				return true
			end
		end,

		["Window"] = function()
			if not popup_shown then
				ni.debug.popup("Feral Druid DPS by DarhangeR for 3.3.5a",
				"Welcome to Feral Druid DPS Profile!\n\nAutonomous profile with utility, trinkets config and engineering support.")
				popup_shown = true;
			end
		end,
	}

	ni.bootstrap.profile("Feral_DPS_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
else
	local queue = { "Error" }
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
	ni.bootstrap.profile("Feral_DPS_DarhangeR", queue, abilities);
end
