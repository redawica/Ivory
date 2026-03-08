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
		settingsfile = "DarhangeR_Feral_Tank.xml",
		{ type = "title", text = "Feral Druid Tank by |c0000CED1DarhangeR" },
		{ type = "separator" },
		{ type = "title", text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "entry", text = "|T" .. icon(9634) .. ":26:26|t Auto Bear Form", tooltip = "Auto switch to Dire Bear Form", enabled = true, key = "autoform" },
		{ type = "entry", text = "|T" .. icon(22812) .. ":26:26|t Barkskin", tooltip = "Use when HP < %", enabled = true, value = 55, key = "barkskin" },
		{ type = "entry", text = "|T" .. icon(22842) .. ":26:26|t Frenzied Regeneration", tooltip = "Use when HP < %", enabled = true, value = 35, key = "frenzied" },
		{ type = "entry", text = "|T" .. icon(61336) .. ":26:26|t Survival Instincts", tooltip = "Use when HP < %", enabled = true, value = 30, key = "survival" },
		{ type = "entry", text = "|T" .. icon(62078) .. ":26:26|t Swipe AoE", tooltip = "Use Swipe on 2+ enemies", enabled = true, key = "swipeaoe" },
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
			if v.type == "input" and v.key ~= nil and v.key == name then
				return v.value
			end
		end
	end;

	local function OnLoad()
		ni.GUI.AddFrame("Feral_Tank_DarhangeR", items);
	end

	local function OnUnLoad()
		ni.GUI.DestroyFrame("Feral_Tank_DarhangeR");
	end

	local queue = {
		"Universal pause",
		"AutoTarget",
		"Mark of the Wild",
		"Thorns",
		"Bear Form",
		"Combat specific Pause",
		"Healthstone (Use)",
		"Heal Potions (Use)",
		"Racial Stuff",
		"Use engineer gloves",
		"Trinkets (Config)",
		"Trinkets",
		"Barkskin",
		"Survival Instincts",
		"Frenzied Regeneration",
		"Enrage",
		"Faerie Fire (Feral)",
		"Demoralizing Roar",
		"Mangle (Bear)",
		"Lacerate",
		"Maul",
		"Swipe (Bear)",
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

		["Bear Form"] = function()
			local _, enabled = GetSetting("autoform")
			if enabled and not ni.player.buff(9634) and ni.spell.available(9634) then
				ni.spell.cast(9634)
				return true
			end
		end,

		["Combat specific Pause"] = function()
			if not UnitAffectingCombat("player") or UnitCanAttack("player", "target") == nil then
				return true
			end
		end,

		["Healthstone (Use)"] = function()
			local hstones = { 36892, 36893, 36894 }
			for i = 1, #hstones do
				if ni.player.hp() < 35 and ni.player.hasitem(hstones[i]) and ni.player.itemcd(hstones[i]) == 0 then
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
			if ni.player.slotcastable(10) and ni.player.slotcd(10) == 0 and UnitAffectingCombat("player") then
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
			if ni.player.slotcastable(13) and ni.player.slotcd(13) == 0 then
				ni.player.useinventoryitem(13)
				return true
			end
			if ni.player.slotcastable(14) and ni.player.slotcd(14) == 0 then
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

		["Survival Instincts"] = function()
			local value, enabled = GetSetting("survival")
			if enabled and ni.player.hp() < value and ni.spell.available(61336) and not ni.player.buff(61336) then
				ni.spell.cast(61336)
				return true
			end
		end,

		["Frenzied Regeneration"] = function()
			local value, enabled = GetSetting("frenzied")
			if enabled and ni.player.hp() < value and ni.spell.available(22842) and ni.player.rage() > 20 then
				ni.spell.cast(22842)
				return true
			end
		end,

		["Enrage"] = function()
			if UnitAffectingCombat("player") and ni.spell.available(5229) and not ni.player.buff(5229) and ni.player.rage() < 25 then
				ni.spell.cast(5229)
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

		["Demoralizing Roar"] = function()
			if ni.spell.available(48560)
			 and ni.spell.valid("target", 48560, true, true)
			 and not ni.unit.debuff("target", 48560, "player") then
				ni.spell.cast(48560)
				return true
			end
		end,

		["Mangle (Bear)"] = function()
			if ni.spell.available(48564)
			 and ni.spell.valid("target", 48564, true, true)
			 and not ni.unit.debuff("target", 48564, "player") then
				ni.spell.cast(48564, "target")
				return true
			end
		end,

		["Lacerate"] = function()
			if ni.spell.available(48568)
			 and ni.spell.valid("target", 48568, true, true)
			 and (select(4, ni.unit.debuff("target", 48568, "player")) or 0) < 5 then
				ni.spell.cast(48568, "target")
				return true
			end
		end,

		["Maul"] = function()
			if ni.spell.available(48480)
			 and ni.spell.valid("target", 48480, true, true)
			 and ni.player.rage() > 35 then
				ni.spell.cast(48480, "target")
				return true
			end
		end,

		["Swipe (Bear)"] = function()
			local _, enabled = GetSetting("swipeaoe")
			if enabled
			 and ActiveEnemies() > 1
			 and ni.spell.available(48562)
			 and ni.spell.valid("target", 48562, true, true) then
				ni.spell.cast(48562)
				return true
			end
		end,

		["Window"] = function()
			if not popup_shown then
				ni.debug.popup("Feral Druid Tank by DarhangeR for 3.3.5a",
				"Welcome to Feral Druid Tank Profile!\n\nAutonomous tank profile with defensives, utility, trinkets and engineering support.")
				popup_shown = true;
			end
		end,
	}

	ni.bootstrap.profile("Feral_Tank_DarhangeR", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Feral_Tank_DarhangeR", queue, abilities);
end
